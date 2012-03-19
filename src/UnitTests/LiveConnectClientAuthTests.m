//
//  LiveAuthRefreshRequestTests.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft. All rights reserved.
//

#import "JsonWriter.h"
#import "LiveConnectClientAuthTests.h"
#import "LiveAuthRefreshRequest.h"
#import "LiveAuthStorage.h"
#import "LiveConnectClient.h"
#import "LiveConnectClientListener.h"
#import "LiveConnectionHelper.h"
#import "MockResponse.h"
#import "MockUrlConnection.h"

@implementation LiveConnectClientAuthTests

@synthesize factory, clientId;

#pragma mark - Utility methods

- (void) setRefreshToken:(NSString *)refreshToken
{
    LiveAuthStorage *storage = [[LiveAuthStorage alloc] initWithClientId:self.clientId];
    storage.refreshToken = refreshToken;
    [storage release];     
}

- (void) clearStorage
{
    [self setRefreshToken:nil];
}

#pragma mark - Set up and tear down

- (void) dealloc
{
    [factory release];
    [clientId release];
    [super dealloc];
}

- (void) setUp 
{
    self.clientId = @"56789999932";
    self.factory = [MockFactory factory];
    [LiveConnectionHelper setLiveConnectCreator:self.factory];
    
    [self clearStorage];
}

- (void) tearDown 
{
    [self clearStorage];
    
    self.factory = nil;
    [LiveConnectionHelper setLiveConnectCreator:nil];
}

#pragma mark - Test cases

- (void) testInitWithoutRefreshToken
{
    NSArray *scopes = [NSArray arrayWithObjects:@"wl.signin", @"wl.basic", nil];
    LiveConnectClientListener *listener = [[[LiveConnectClientListener alloc]init]autorelease];
    NSString *userState = @"init";
    LiveConnectClient *liveClient = [[[LiveConnectClient alloc] initWithClientId:self.clientId 
                                                                          scopes:scopes 
                                                                        delegate:listener 
                                                                       userState:userState]
                                     autorelease];
  
    // We should get an async event right away. We use the NSRunLoop to allow the async event to kick in.
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:10];
    while ((listener.events.count == 0) && ([timeout timeIntervalSinceNow] > 0)) 
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
        NSLog(@"Polling...");
    }
    
    STAssertEquals((NSUInteger)1, listener.events.count, @"Should receive 1 event.");
    
    NSDictionary *eventArgs = [listener fetchEvent];
    STAssertEquals(LIVE_UNIT_AUTHCOMPLETED, [eventArgs objectForKey:LIVE_UNIT_EVENT], @"Incorrect event.");
    STAssertEquals(LiveAuthUnknown, (LiveConnectSessionStatus)[[eventArgs objectForKey:LIVE_UNIT_STATUS] intValue], @"Invalid status");
    STAssertNil([eventArgs objectForKey:LIVE_UNIT_SESSION], @"session should be nil");
    STAssertEqualObjects(userState, [eventArgs objectForKey:LIVE_UNIT_USERSTATE], @"incorrect userState");
    
}

- (void) testInitWithRefreshToken
{
    [self setRefreshToken:@"refresh token"];
    
    NSArray *scopes = [NSArray arrayWithObjects:@"wl.signin", @"wl.basic", nil];
    LiveConnectClientListener *listener = [[[LiveConnectClientListener alloc]init]autorelease];
    NSString *userState = @"init";
    LiveConnectClient *liveClient = [[[LiveConnectClient alloc] initWithClientId:self.clientId 
                                                                          scopes:scopes 
                                                                        delegate:listener 
                                                                       userState:userState]
                                     autorelease];
    
    // Validate outbound request
    MockUrlConnection *connection = [self.factory fetchRequestConnection];
    NSURLRequest *request = connection.request;
    
    STAssertEqualObjects(@"POST", [request HTTPMethod], @"Method should be POST");
    STAssertEqualObjects(@"https://oauth.live.com/token", request.URL.absoluteString, @"Invalid url");
    
    NSString *requestBodyString = [[[NSString alloc] initWithData:request.HTTPBody
                                                         encoding:NSUTF8StringEncoding] 
                                   autorelease];
    STAssertEqualObjects(@"scope=wl.signin%20wl.basic&grant_type=refresh_token&refresh_token=refresh%20token&client_id=56789999932", requestBodyString, @"Invalid url");
    STAssertEqualObjects(LIVE_AUTH_POST_CONTENT_TYPE, [request valueForHTTPHeaderField:LIVE_API_HEADER_CONTENTTYPE], @"Incorrect content-type.");
    
    // set response
    id delegate = connection.delegate;
    MockResponse *response = [[[MockResponse alloc] init] autorelease];
    response.statusCode = 200;
    [delegate connection:connection didReceiveResponse:response];
    
    // set response data
    NSString *accessToken = @"accesstoken";
    NSString *authenticationToken = @"authtoken";
    NSString *refreshToken = @"refreshtoken";
    NSString *scopesStr = @"wl.signin wl.basic";
    NSString *expiresIn = @"3600";
    
    NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  accessToken, LIVE_AUTH_ACCESS_TOKEN, 
                                  authenticationToken, LIVE_AUTH_AUTHENTICATION_TOKEN,
                                  refreshToken, LIVE_AUTH_REFRESH_TOKEN,
                                  scopesStr, LIVE_AUTH_SCOPE, expiresIn, LIVE_AUTH_EXPIRES_IN, 
                                  nil];
    NSString *responseText = [MSJSONWriter textForValue:responseDict];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding]; 
    [delegate connection:connection didReceiveData:data]; 
    
    // notify complete
    [delegate connectionDidFinishLoading:connection];
    
    // validate event
    STAssertEquals((NSUInteger)1, listener.events.count, @"Should receive 1 event.");
    
    NSDictionary *eventArgs = [listener fetchEvent];
    STAssertEquals(LIVE_UNIT_AUTHCOMPLETED, [eventArgs objectForKey:LIVE_UNIT_EVENT], @"Incorrect event.");
    STAssertEquals(LiveAuthConnected, (LiveConnectSessionStatus)[[eventArgs objectForKey:LIVE_UNIT_STATUS] intValue], @"Invalid status");
    STAssertNotNil([eventArgs objectForKey:LIVE_UNIT_SESSION], @"session should not be nil");
    STAssertEqualObjects(userState, [eventArgs objectForKey:LIVE_UNIT_USERSTATE], @"incorrect userState");
    
    LiveConnectSession *session = [eventArgs objectForKey:LIVE_UNIT_SESSION];
    
    STAssertEqualObjects(accessToken, session.accessToken, @"Incorrect access_token");
    STAssertEqualObjects(authenticationToken, session.authenticationToken, @"Incorrect authentication_token");
    STAssertEqualObjects(refreshToken, session.refreshToken, @"Incorrect refresh_token");
     
    STAssertEquals((NSUInteger)2, session.scopes.count, @"Incorrect scopes");
    STAssertEqualObjects(@"wl.signin", [session.scopes objectAtIndex:0], @"Incorrect scopes");
    STAssertEqualObjects(@"wl.basic", [session.scopes objectAtIndex:1], @"Incorrect scopes");
    STAssertTrue([session.expires timeIntervalSinceNow] < 3600, @"Invalid expires value");
    STAssertTrue([session.expires timeIntervalSinceNow] > 3500, @"Invalid expires value");
}
@end
