//
//  LiveDownloadOperationCore.m
//  Live SDK for iOS
//
//  Copyright 2014 Microsoft Corporation
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LiveApiHelper.h"
#import "LiveDownloadOperationCore.h"
#import "LiveDownloadOperationInternal.h"
#import "LiveOperationInternal.h"
#import "LiveOperationProgress.h"
#import "LiveConstants.h"

@class LiveDownloadOperation;

@interface LiveDownloadOperationCore ()
{
    unsigned long long _downloadedBytes;
    long long _expectedContentLength;
}

@property (nonatomic, strong, readwrite) NSString *destinationDownloadPath;
@property (nonatomic, strong) NSFileHandle *outputFileHandle;

@end

@implementation LiveDownloadOperationCore

- (id) initWithPath:(NSString *)path
    destinationPath:(NSString *)destinationPath
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
        self.destinationDownloadPath = destinationPath;
    }
    
    return self;
}

- (unsigned long long)downloadedBytes
{
    return _downloadedBytes;
}

- (long long)expectedContentLength
{
    return _expectedContentLength;
}

#pragma mark override methods

- (void)execute
{
    NSError *fileTruncationError = nil;

    [[[NSData alloc] init] writeToFile:self.destinationDownloadPath options:0 error:&fileTruncationError];
    
    if (fileTruncationError)
    {
        [self operationFailed:fileTruncationError];
    }
    else
    {
        self.outputFileHandle = [NSFileHandle fileHandleForWritingAtPath:self.destinationDownloadPath];
        
        _downloadedBytes = 0;
        _expectedContentLength = 0;
        
        [super execute];
    }
}

- (void)cancel
{
    [super cancel];
    
    if (self.outputFileHandle)
    {
        [self.outputFileHandle closeFile];
        self.outputFileHandle = nil;
    }
}

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
    
    [self.outputFileHandle closeFile];
    self.outputFileHandle = nil;
    
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
        
        // LiveOperation was returned in the interface return. However, the app may not retain the object
        // In order to keep it alive, we keep LiveOperationCore and LiveOperation in circular reference.
        // After the event raised, we set this property to nil to break the circle, so that they are recycled.
        self.publicOperation = nil;
        
        self.completed = YES;
    }
}

- (void) operationReceivedData:(NSData *)data
{
    @try
    {
        [self.outputFileHandle writeData:data];
    }
    @catch (NSException *exception)
    {
        [self cancel];
        
        NSMutableDictionary *userInfo = [exception.userInfo mutableCopy];
        userInfo[NSLocalizedFailureReasonErrorKey] = exception.reason;
        
        NSError *error = [NSError errorWithDomain:LIVE_ERROR_DOMAIN
                                             code:0
                                         userInfo:userInfo];
        [self operationFailed:error];
        
        return;
    }
    @finally
    {
        
    }
    
    _downloadedBytes += (unsigned long long)data.length;
    
    if ([self.delegate respondsToSelector:@selector(liveDownloadOperationProgressed:operation:)])
    {
        if (_expectedContentLength == 0)
        {
            NSString *field = [self.httpResponse.allHeaderFields valueForKey:@"Content-Length"];
            if (field)
            {
                _expectedContentLength = [field longLongValue];
            }
            else
            {
                _expectedContentLength = -1ULL;
            }
        }
        
        LiveOperationProgress *progress = [[[LiveOperationProgress alloc] 
                                            initWithBytesTransferred:(NSUInteger)_downloadedBytes
                                                          totalBytes:(NSUInteger)_expectedContentLength]
                                           autorelease];
        
        [self.delegate liveDownloadOperationProgressed:progress
                                             operation:self.publicOperation];
    }
}

- (void) operationFailed:(NSError *)error
{
    if (!self.completed && self.outputFileHandle)
    {
        [self.outputFileHandle closeFile];
        self.outputFileHandle = nil;
    }
    
    [super operationFailed:error];
}

@end
