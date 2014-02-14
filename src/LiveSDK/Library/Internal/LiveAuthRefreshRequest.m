//
//  LiveAuthRefreshRequest.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft. All rights reserved.
//

#import "LiveAuthHelper.h"
#import "LiveAuthRefreshRequest.h"
#import "LiveConnectionHelper.h"
#import "StringHelper.h"

@implementation LiveAuthRefreshRequest

@synthesize tokenConnection, tokenResponseData;

- (id)initWithClientId:(NSString *)clientId
                 scope:(NSArray *)scopes
          refreshToken:(NSString *)refreshToken
              delegate:(id<LiveAuthDelegate>)delegate
             userState:(id)userState
            clientStub:(LiveConnectClientCore *)client
{
    assert(![StringHelper isNullOrEmpty:clientId]);
    assert(![StringHelper isNullOrEmpty:refreshToken]);
    
    self = [super init];
    if (self) 
    {
        _clientId = [clientId retain];
        _scopes = [scopes retain];
        _refreshToken = [refreshToken retain];
        _delegate = delegate;
        _userState = [userState retain];
        _client = client;
    }
    
    return self;
}

- (void) dealloc
{
    [tokenConnection setDelegate:nil];

    [_clientId release];
    [_scopes release];
    [_refreshToken release];
    [_userState release];
    [_client release];
    [tokenConnection release];
    [tokenResponseData release];
    
    [super dealloc];
}

- (void) execute
{
    NSURL * url = [LiveAuthHelper getRetrieveTokenUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:HTTP_REQUEST_TIMEOUT_INTERVAL];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:LIVE_AUTH_POST_CONTENT_TYPE forHTTPHeaderField:LIVE_API_HEADER_CONTENTTYPE];
    [request setHTTPBody:[LiveAuthHelper buildRefreshTokenBodyDataWithClientId:_clientId
                                                                  refreshToken:_refreshToken
                                                                         scope:_scopes]];
    
    self.tokenConnection = [LiveConnectionHelper createConnectionWithRequest:request delegate:self];
}

- (void) complete
{
    // We only notify complete, because 
    // 1) we don't raise error event of LiveAuthDelegate instance passed in from  
    // LiveConnectClient - initWithClientId:redirectUri:scopes:delegate:userState;
    // 2) NSError is not interested in internal logic.
    
    if ([_delegate respondsToSelector:@selector(authCompleted:session:userState:)]) 
    {
        [_delegate authCompleted:_client.status
                         session:_client.session
                       userState:_userState];
        
        _delegate = nil;
    }
}

#pragma mark -  NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection 
didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((httpResponse.statusCode / 100) != 2) 
    {
        NSLog(@"HTTP error %zd", (ssize_t)httpResponse.statusCode);
        [self complete];
    }
    else
    {
        self.tokenResponseData = [[[NSMutableData alloc] init] autorelease];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [self.tokenResponseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse 
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{    
    id response = [LiveAuthHelper readAuthResponse:self.tokenResponseData];
    
    if ([response isKindOfClass:[LiveConnectSession class]])
    {
        _client.session = response;
    }
    else
    {
        NSError *error = (NSError *)response;
        NSString *errorCode = (NSString *)[error.userInfo objectForKey:LIVE_ERROR_KEY_ERROR];
        if (_client.status == LiveAuthUnknown && 
            [errorCode isEqual:LIVE_ERROR_CODE_S_ACCESS_DENIED])
        {
            // access_denied indicates the user has not consented.
            _client.status = LiveAuthNotConnected;
        }
        else if ([errorCode isEqual:LIVE_ERROR_CODE_S_INVALID_GRANT])
        {
            _client.session = nil;
        }
    }   
    
    [self complete];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [self complete];
}

@end
