//
//  LiveConnectClientCore.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "LiveAuthHelper.h"
#import "LiveConnectClientCore.h"
#import "LiveOperationInternal.h"
#import "LiveDownloadOperationInternal.h"
#import "LiveUploadOperationCore.h"
#import "StringHelper.h"

@implementation LiveConnectClientCore

@synthesize clientId = _clientId,
              scopes = _scopes,
             session = _session,
              status = _status,
         authRequest = _authRequest,
  authRefreshRequest;

#pragma mark init and dealloc

- (id) initWithClientId:(NSString *)clientId
                 scopes:(NSArray *)scopes
               delegate:(id<LiveAuthDelegate>)delegate
              userState:(id)userState
{
    self = [super init];
    if (self) 
    {
        _clientId = [clientId copy];
        _scopes = [scopes copy];
        _storage = [[LiveAuthStorage alloc] initWithClientId:clientId];            
        _status = LiveAuthUnknown;
        _session = nil;
    }
    
    [self refreshSessionWithDelegate:delegate
                           userState:userState];
    return self;
}

- (void)dealloc
{ 
    [_clientId release];
    [_scopes release];
    [_session release];
    [_authRequest release];
    [_storage release];
    [authRefreshRequest release];
    
    [super dealloc];
}

#pragma mark Auth methods

- (void) login:(UIViewController *)currentViewController 
        scopes:(NSArray *)scopes 
      delegate:(id<LiveAuthDelegate>)delegate
     userState:(id)userState 
{   
    if (self.session && 
        [LiveAuthHelper isScopes:scopes subSetOf:self.session.scopes]) 
    {
        NSArray *authCompletedEvent = [NSArray arrayWithObjects:delegate, userState, nil];
        [self performSelector:@selector(sendAuthCompletedMessage:) withObject:authCompletedEvent afterDelay:0.1];
        return;
    }
    
    LiveAuthRequest *authRequest = [[[LiveAuthRequest alloc] initWithClient:self 
                                                                    scopes:scopes 
                                                     currentViewController:currentViewController 
                                                                  delegate:delegate 
                                                                 userState:userState]
                                    autorelease];
    
    self.authRequest = authRequest;
    
    [authRequest execute]; 
}

- (BOOL) hasPendingUIRequest
{
    return (self.authRequest != nil && self.authRequest.isUserInvolved);
}

- (void) logoutWithDelegate:(id<LiveAuthDelegate>)delegate
                  userState:(id)userState
{
    self.session = nil;
    
    [LiveAuthHelper clearAuthCookie];
    
    if ([delegate respondsToSelector:@selector(authCompleted:session:userState:)]) 
    {
        NSArray *authCompletedEvent = [NSArray arrayWithObjects:delegate, userState, nil];
        [self performSelector:@selector(sendAuthCompletedMessage:) withObject:authCompletedEvent afterDelay:0.1];
    }
}

- (void) sendAuthCompletedMessage:(NSArray *)eventArgs
{
    id<LiveAuthDelegate> delegate = [eventArgs objectAtIndex:0]; 
    
    [delegate authCompleted:self.status
                    session:self.session
                  userState: (eventArgs.count>1?  [eventArgs objectAtIndex:1] : nil)];
}

- (void) setSession:(LiveConnectSession *)session
{
    [_session release];
    _session = [session retain];
    
    if (_session == nil)
    {
        _status = LiveAuthUnknown;
    }
    else
    {
        _status = LiveAuthConnected;
    }
    
    // By the time we update the session, we persist the refreshToken.
    _storage.refreshToken = session.refreshToken;
}

- (void) refreshSessionWithDelegate:(id<LiveAuthDelegate>)delegate
                          userState:(id)userState
{
    if ([LiveAuthHelper shouldRefreshToken:_session 
                              refreshToken:_storage.refreshToken]) 
    {
        authRefreshRequest = [[LiveAuthRefreshRequest alloc] initWithClientId:_clientId 
                                                                        scope:_scopes 
                                                                 refreshToken:_storage.refreshToken
                                                                     delegate:delegate
                                                                    userState:userState 
                                                                   clientStub:self];
        
        [authRefreshRequest execute];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(authCompleted:session:userState:)]) 
        {
            NSArray *authCompletedEvent = [NSArray arrayWithObjects:delegate, userState, nil];
            [self performSelector:@selector(sendAuthCompletedMessage:) 
                       withObject:authCompletedEvent 
                       afterDelay:0.1];
        }
    }
}

#pragma mark Access API service

- (LiveOperation *) sendRequestWithMethod:(NSString *)method
                                     path:(NSString *)path
                                 jsonBody:(NSString *)jsonBody
                                 delegate:(id <LiveOperationDelegate>) delegate
                                userState:(id) userState
{
    NSData *bodyData = [jsonBody dataUsingEncoding:NSUTF8StringEncoding];
    LiveOperationCore *operation = [[[LiveOperationCore alloc] initWithMethod:method 
                                                                         path:path 
                                                                  requestBody:bodyData 
                                                                     delegate:delegate 
                                                                    userState:userState 
                                                                   liveClient:self] 
                                    autorelease];
    [operation execute];  
    
    return [[[LiveOperation alloc] initWithOpCore:operation] autorelease];
}

- (LiveDownloadOperation *) downloadFromPath:(NSString *)path
                                    delegate:(id <LiveDownloadOperationDelegate>)delegate
                                   userState:(id)userState
{
    LiveDownloadOperationCore *operation = [[[LiveDownloadOperationCore alloc] initWithPath:path 
                                                                                   delegate:delegate
                                                                                  userState:userState 
                                                                                 liveClient:self]
                                            autorelease];
    [operation execute];
    
    return [[[LiveDownloadOperation alloc] initWithOpCore:operation] autorelease];
}

- (LiveOperation *) uploadToPath:(NSString *)path
                        fileName:(NSString *)fileName
                            data:(NSData *)data
                       overwrite:(LiveUploadOverwriteOption)overwrite
                        delegate:(id <LiveUploadOperationDelegate>)delegate
                       userState:(id)userState
{
    LiveUploadOperationCore *operation = [[[LiveUploadOperationCore alloc] initWithPath:path
                                                                               fileName:fileName
                                                                                   data:data
                                                                              overwrite:overwrite
                                                                               delegate:delegate
                                                                              userState:userState
                                                                             liveClient:self] 
                                          autorelease];
    
    [operation execute];
    
    return [[[LiveOperation alloc] initWithOpCore:operation] autorelease];
}

- (LiveOperation *) uploadToPath:(NSString *)path
                        fileName:(NSString *)fileName
                     inputStream:(NSInputStream *)inputStream
                       overwrite:(LiveUploadOverwriteOption)overwrite
                        delegate:(id <LiveUploadOperationDelegate>)delegate
                       userState:(id)userState
{
    LiveUploadOperationCore *operation = [[[LiveUploadOperationCore alloc] initWithPath:path
                                                                               fileName:fileName
                                                                            inputStream:inputStream
                                                                              overwrite:overwrite
                                                                               delegate:delegate
                                                                              userState:userState
                                                                             liveClient:self]
                                          autorelease];
    [operation execute];
    
    return [[[LiveOperation alloc] initWithOpCore:operation] autorelease];
}

@end
