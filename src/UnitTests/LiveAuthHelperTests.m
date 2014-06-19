//
//  LiveAuthHelperTests.m
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

#import "LiveAuthHelper.h"
#import "LiveAuthHelperTests.h"
#import "LiveConnectSession.h"

@implementation LiveAuthHelperTests

#pragma mark scopes utility

- (void) testNormalizeScopes
{
    NSArray *array1 = [LiveAuthHelper normalizeScopes:nil];
    STAssertNotNil(array1, @"We should return empty NSArray");
    STAssertEquals((NSUInteger)0, array1.count, @"Incorrect array count value.");
    
    NSArray *array2 = [LiveAuthHelper normalizeScopes:[NSArray arrayWithObjects:@"WL.SignIn", @"WL.Basic", @"", @" ", nil]];
    STAssertNotNil(array2, @"We should return not nil NSArray");
    STAssertEquals((NSUInteger)2, array2.count, @"We should return the same size of array");
    STAssertEqualObjects(@"wl.signin", [array2 objectAtIndex:0], @"We should lower case string values");
    STAssertEqualObjects(@"wl.basic", [array2 objectAtIndex:1], @"We should lower case string values");
}

- (void) testIsScopesSubSetOf
{
    NSArray *array1 = [NSArray arrayWithObjects:@"wl.signin", @"wl.basic", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"wl.basic", @"wl.signin", nil];
    NSArray *array3 = [NSArray arrayWithObjects:@"wl.basic", @"wl.share", @"wl.signin", nil];
    NSArray *array4 = [NSArray arrayWithObjects:@"wl.share", @"wl.signin", nil];    

    STAssertTrue([LiveAuthHelper isScopes:array1 subSetOf:array2] , @"The two arrays are the same set.");
    STAssertTrue([LiveAuthHelper isScopes:array2 subSetOf:array1] , @"The two arrays are the same set.");
    STAssertTrue([LiveAuthHelper isScopes:array1 subSetOf:array3] , @"Incorrect subset computation.");    
    STAssertTrue([LiveAuthHelper isScopes:array2 subSetOf:array3] , @"Incorrect subset computation.");   
    STAssertFalse([LiveAuthHelper isScopes:array3 subSetOf:array1] , @"Incorrect subset computation.");    
    STAssertFalse([LiveAuthHelper isScopes:array3 subSetOf:array2] , @"Incorrect subset computation.");   
    STAssertFalse([LiveAuthHelper isScopes:array4 subSetOf:array1] , @"Incorrect subset computation.");    
    STAssertFalse([LiveAuthHelper isScopes:array4 subSetOf:array2] , @"Incorrect subset computation.");     
}

#pragma mark shouldRefreshToken

- (void)testShouldRefreshToken_should
{
    LiveConnectSession *session = [[[LiveConnectSession alloc] initWithAccessToken:@"accessToken" 
                                                               authenticationToken:@"authToken" 
                                                                      refreshToken:@"refreshToken" 
                                                                            scopes:[NSArray arrayWithObjects:@"wl.signin", nil]
                                                                           expires:[NSDate dateWithTimeIntervalSinceNow:19]]
                                   autorelease];
    STAssertTrue([LiveAuthHelper shouldRefreshToken:session refreshToken:@"refreshToken" ], 
                  @"should refresh if it has less than 20 seconds before it expires.");
}

- (void)testShouldRefreshToken_shouldNot_emptyRefreshToken
{
    LiveConnectSession *session = [[[LiveConnectSession alloc] initWithAccessToken:@"accessToken" 
                                                               authenticationToken:@"authToken" 
                                                                      refreshToken:@" " 
                                                                            scopes:[NSArray arrayWithObjects:@"wl.signin", nil]
                                                                           expires:[NSDate dateWithTimeIntervalSinceNow:210]]
                                   autorelease];
    STAssertFalse([LiveAuthHelper shouldRefreshToken:session refreshToken: @" "], 
                  @"should not refresh if we don't have refresh token.");
}

- (void)testShouldRefreshToken_shouldNot_nilRefreshToken
{
    LiveConnectSession *session = [[[LiveConnectSession alloc] initWithAccessToken:@"accessToken" 
                                                               authenticationToken:@"authToken" 
                                                                      refreshToken:nil 
                                                                            scopes:[NSArray arrayWithObjects:@"wl.signin", nil]
                                                                           expires:[NSDate dateWithTimeIntervalSinceNow:210]]
                                   autorelease];
    STAssertFalse([LiveAuthHelper shouldRefreshToken:session refreshToken:nil], 
                  @"should not refresh if we don't have refresh token.");
}

- (void)testShouldRefreshToken_shouldNot_EnoughExpirePeriod
{
    LiveConnectSession *session = [[[LiveConnectSession alloc] initWithAccessToken:@"accessToken" 
                                                               authenticationToken:@"authToken" 
                                                                      refreshToken:@"refreshToken" 
                                                                            scopes:[NSArray arrayWithObjects:@"wl.signin", nil]
                                                                           expires:[NSDate dateWithTimeIntervalSinceNow:31]]
                                   autorelease];
    STAssertFalse([LiveAuthHelper shouldRefreshToken:session refreshToken:@"refreshToken" ], 
                 @"should not refresh if it has more than 20 seconds before it expires.");
}

- (void)testShouldRefreshToken_nilSession_refreshToken
{
    STAssertTrue([LiveAuthHelper shouldRefreshToken:nil refreshToken:@"refreshToken"], 
                  @"Should refresh token if we have the refresh token although the session is nil");
}

- (void)testShouldRefreshToken_nilSession_nilRefreshToken
{
    STAssertFalse([LiveAuthHelper shouldRefreshToken:nil refreshToken:nil], 
                 @"Should not refresh token if the session is nil and the refresh token is nil");
}

#pragma mark isSessionValid

- (void)testIsSessionValid_nil
{
    STAssertFalse([LiveAuthHelper isSessionValid:nil], @"nil session should be invalid.");
}

- (void)testIsSessionValid_Valid
{
    LiveConnectSession *session = [[[LiveConnectSession alloc] initWithAccessToken:@"accessToken" 
                                                               authenticationToken:@"authToken" 
                                                                      refreshToken:@"refreshToken" 
                                                                            scopes:[NSArray arrayWithObjects:@"wl.signin", nil]
                                                                           expires:[NSDate dateWithTimeIntervalSinceNow:4]]
                                   autorelease];
    STAssertTrue([LiveAuthHelper isSessionValid:session], 
                 @"The token should be still valid, if it has 4 seconds before expire.");
}

- (void)testIsSessionValid_inValid
{
    LiveConnectSession *session = [[[LiveConnectSession alloc] initWithAccessToken:@"accessToken" 
                                                               authenticationToken:@"authToken" 
                                                                      refreshToken:@"refreshToken" 
                                                                            scopes:[NSArray arrayWithObjects:@"wl.signin", nil]
                                                                           expires:[NSDate dateWithTimeIntervalSinceNow:2]]
                                   autorelease];
    STAssertFalse([LiveAuthHelper isSessionValid:session], 
                 @"The token should be still invalid, if it has less than 3 seconds before expire.");
}
@end
