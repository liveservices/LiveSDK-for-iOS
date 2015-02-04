//
//  LiveAuthStorageTests.m
//  Live SDK for iOS
//
//  Copyright 2015 Microsoft Corporation
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
