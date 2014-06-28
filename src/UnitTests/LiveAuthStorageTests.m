//
//  LiveAuthStorageTests.m
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

#import "LiveAuthStorageTests.h"
#import "LiveAuthStorage.h"

NSString * const CLIENTA = @"clientA";
NSString * const CLIENTB = @"clientB";

@implementation LiveAuthStorageTests

- (void)setUp 
{
}

- (void)tearDown 
{
    LiveAuthStorage *storage = [[LiveAuthStorage alloc] initWithClientId:CLIENTA];
    storage.refreshToken = nil;
    [storage release];  
}

- (void)testWriteToken
{
    // first time should receive nil refreshToken
    LiveAuthStorage *storage = [[LiveAuthStorage alloc] initWithClientId:CLIENTA];
    STAssertNil(storage.refreshToken, @"There is an existing persisted token.");
    
    // write a token
    NSString *token = @"refresh token value";
    storage.refreshToken = token;
    STAssertEqualObjects(token, storage.refreshToken, @"setRefreshToken does not work properly.");
    [storage release];
    
    // check if persisted
    storage = [[LiveAuthStorage alloc] initWithClientId:CLIENTA];
    STAssertEqualObjects(token, storage.refreshToken, @"The data was not persisted properly.");
    
    // write a different token
    token = @"refresh token value 2";
    storage.refreshToken = token;
    STAssertEqualObjects(token, storage.refreshToken, @"setRefreshToken does not work properly.");
    [storage release];
    
    // check if the change persisted
    storage = [[LiveAuthStorage alloc] initWithClientId:CLIENTA];
    STAssertEqualObjects(token, storage.refreshToken, @"The data was not persisted properly.");
    
    // write a nil token
    token = nil;
    storage.refreshToken = token;
    STAssertEqualObjects(token, storage.refreshToken, @"setRefreshToken does not work properly.");
    [storage release];
    
    // check if the nil value persisted
    storage = [[LiveAuthStorage alloc] initWithClientId:CLIENTA];
    STAssertNil(storage.refreshToken, @"The nil value was not persisted properly.");
    [storage release];    
}

- (void) testClientIdCheck
{
    // Write a token associated with a client Id
    LiveAuthStorage *storage = [[LiveAuthStorage alloc] initWithClientId:CLIENTA];
    NSString *token = @"refresh token value";
    storage.refreshToken = token;
    [storage release];
    
    // Init with an LiveAuthStorage instance with CLIENTB, the token with CLIENTA should be cleared.
    storage = [[LiveAuthStorage alloc] initWithClientId:CLIENTB];
    STAssertNil(storage.refreshToken, @"The new client storage did not flush the token associated with a different client ID");
    [storage release];
    
    // Switch back to CLIENTA, it should be flushed.
    storage = [[LiveAuthStorage alloc] initWithClientId:CLIENTA];
    STAssertNil(storage.refreshToken, @"The flushing did not work.");
    [storage release];
}

@end
