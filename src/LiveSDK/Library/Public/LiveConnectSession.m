//
//  LiveConnectSession.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "LiveConnectSession.h"

@implementation LiveConnectSession

@synthesize accessToken = _accessToken, 
    authenticationToken = _authenticationToken,
           refreshToken = _refreshToken, 
                 scopes = _scopes, 
                expires = _expires;

- (id) initWithAccessToken:(NSString *)accessToken
       authenticationToken:(NSString *)authenticationToken
              refreshToken:(NSString *)refreshToken
                    scopes:(NSArray *)scopes
                   expires:(NSDate *)expires
{
    self = [super init];
    if (self) 
    {
        _accessToken = [accessToken retain];
        _authenticationToken = [authenticationToken retain];
        _refreshToken = [refreshToken retain];
        _scopes = [scopes retain];
        _expires = [expires retain];
    }
    
    return self;
}

- (void)dealloc 
{
    [_accessToken release];
    [_authenticationToken release];
    [_refreshToken release];
    [_scopes release];
    [_expires release];
    
    [super dealloc];
}

@end
