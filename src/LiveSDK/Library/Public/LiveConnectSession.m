//
//  LiveConnectSession.m
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
