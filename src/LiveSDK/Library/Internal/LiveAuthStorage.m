//
//  LiveAuthStorage.m
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

#import "LiveAuthStorage.h"
#import "LiveConstants.h"

@interface LiveAuthStorage()

- (void) save;

@end

@implementation LiveAuthStorage

@synthesize refreshToken = _refreshToken;

- (id) initWithClientId:(NSString *)clientId
{
    self = [super init];
    if (self) 
    {
        // Find the file path
        NSString *libDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _filePath = [[libDirectory stringByAppendingPathComponent:@"LiveService_auth.plist"] retain];
        _clientId = clientId;
        
        // If file exist, load the file
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath])
        {
            assert(clientId != nil);
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:_filePath];
            if ([clientId isEqualToString:[dictionary valueForKey: LIVE_AUTH_CLIENTID]]) 
            {
                _refreshToken = [[dictionary valueForKey:LIVE_AUTH_REFRESH_TOKEN] retain];
            }
            else
            {
                // The storage has a different client_id, flush it.
                [self save];
            }
        }
        
    }
    
    return self; 
}

- (void) dealloc
{
    [_filePath release];
    [_clientId release];
    [_refreshToken release];
    
    [super dealloc];
}

- (void) save
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:_clientId forKey:LIVE_AUTH_CLIENTID];
    [data setValue:_refreshToken forKey:LIVE_AUTH_REFRESH_TOKEN];
    
    [data writeToFile:_filePath atomically:YES];
    [data release];
}

- (void) setRefreshToken:(NSString *)refreshToken
{
    [_refreshToken release];    
    _refreshToken = [refreshToken retain];
    
    [self save];
}

@end
