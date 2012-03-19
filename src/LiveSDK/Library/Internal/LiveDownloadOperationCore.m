//
//  LiveDownloadOperationCore.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "LiveApiHelper.h"
#import "LiveDownloadOperationCore.h"
#import "LiveDownloadOperationInternal.h"
#import "LiveOperationInternal.h"
#import "LiveOperationProgress.h"

@class LiveDownloadOperation;

@implementation LiveDownloadOperationCore

- (id) initWithPath:(NSString *)path
           delegate:(id <LiveDownloadOperationDelegate>)delegate
          userState:(id)userState
         liveClient:(LiveConnectClientCore *)liveClient
{
    self = [super initWithMethod:@"GET" 
                            path:path 
                     requestBody:nil 
                        delegate:delegate 
                       userState:userState 
                      liveClient:liveClient];
    if (self)
    {
        contentLength = 0;
    }
    
    return self;
}

#pragma mark override methods

- (NSURL *)requestUrl
{
    // We don't use suppress_redirects for download, since redirect maybe expected.
    return [LiveApiHelper buildAPIUrl:self.path
                               params:nil];
}

- (void) setRequestContentType
{
    // override the behaviour in LiveOperation.
}

 - (void) operationCompleted
{
    if (self.completed) 
    {
        return;
    }
    
    if (self.httpError) 
    {
        // If there is httpError, try read the error information from the server.
        NSString *textResponse;
        NSDictionary *response;
        NSError *error = nil;
        
        [LiveApiHelper parseApiResponse:self.responseData 
                           textResponse:&textResponse 
                               response:&response 
                                  error:&error];
        error = (error != nil)? error : self.httpError;
        [self operationFailed:error];
    }
    else 
    {
        if ([self.delegate respondsToSelector:@selector(liveOperationSucceeded:)]) 
        {
            [self.delegate liveOperationSucceeded:self.publicOperation];
        }
        
        self.completed = YES;
    }
}

- (void) operationReceivedData:(NSData *)data
{
    [self.responseData appendData:data];
    
    if ([self.delegate respondsToSelector:@selector(liveDownloadOperationProgressed:data:operation:)])
    {
        if (contentLength == 0)
        {
            contentLength = [[self.httpResponse.allHeaderFields valueForKey:@"Content-Length"] intValue];
        }
        
        LiveOperationProgress *progress = [[[LiveOperationProgress alloc] 
                                            initWithBytesTransferred:self.responseData.length 
                                                          totalBytes:contentLength]
                                           autorelease];
        
        [self.delegate liveDownloadOperationProgressed:progress 
                                                  data:data 
                                             operation:self.publicOperation];
    }
}

@end
