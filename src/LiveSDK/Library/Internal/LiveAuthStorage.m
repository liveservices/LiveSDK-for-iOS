//
//  LiveAuthStorage.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft. All rights reserved.
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
