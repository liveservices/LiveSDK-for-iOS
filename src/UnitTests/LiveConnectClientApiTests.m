//
//  LiveConnectClientApiTests.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft. All rights reserved.
//

#import "JsonWriter.h"
#import "LiveAuthRefreshRequest.h"
#import "LiveAuthStorage.h"
#import "LiveConnectClientApiTests.h"
#import "LiveConnectClient.h"
#import "LiveConnectClientListener.h"
#import "LiveConnectionHelper.h"
#import "MockResponse.h"
#import "MockUrlConnection.h"

@implementation LiveConnectClientApiTests
@synthesize factory, clientId, listener;

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

- (LiveConnectClient *) createAuthenticatedClient
{
    [self setRefreshToken:@"refresh token"];
    
    NSArray *scopes = [NSArray arrayWithObjects:@"wl.signin", @"wl.basic", nil];
    NSString *userState = @"init";
    LiveConnectClient *liveClient = [[[LiveConnectClient alloc] initWithClientId:self.clientId 
                                                                          scopes:scopes 
                                                                        delegate:self.listener 
                                                                       userState:userState]
                                     autorelease];
    
    // Validate outbound request
    MockUrlConnection *connection = [self.factory fetchRequestConnection];
    NSURLRequest *request = connection.request;
    
    STAssertEqualObjects(@"POST", [request HTTPMethod], @"Method should be POST");
    STAssertEqualObjects(@"https://login.live.com/oauth20_token.srf", request.URL.absoluteString, @"Invalid url");
    
    NSString *requestBodyString = [[[NSString alloc] initWithData:request.HTTPBody
                                                         encoding:NSUTF8StringEncoding] 
                                   autorelease];
    
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
    
    STAssertEquals(LiveAuthConnected, (LiveConnectSessionStatus)[[eventArgs objectForKey:LIVE_UNIT_STATUS] intValue], @"Invalid status");
    STAssertNotNil([eventArgs objectForKey:LIVE_UNIT_SESSION], @"session should not be nil");
    STAssertEqualObjects(userState, [eventArgs objectForKey:LIVE_UNIT_USERSTATE], @"incorrect userState");
    
    return liveClient;
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
    self.listener = [[[LiveConnectClientListener alloc]init]autorelease];
    [self clearStorage];
}

- (void) tearDown 
{
    [self clearStorage];
    self.factory = nil;
    [LiveConnectionHelper setLiveConnectCreator:nil];
    self.listener = nil;
}

#pragma mark - Test cases

- (void) testGet
{
    NSString *path = @"me";
    NSString *userState = @"getme";
    LiveConnectClient *liveClient = [self createAuthenticatedClient];
    
    LiveOperation * operation = [liveClient getWithPath:path
                                               delegate:self.listener 
                                              userState:userState];
    
    STAssertEqualObjects(path, operation.path, @"Path invalid");
    STAssertEqualObjects(@"GET", operation.method, @"METHOD invalid");
    
    // We should get an async event right away. We use the NSRunLoop to allow the async event to kick in.
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:10];
    while ((listener.events.count == 0) && ([timeout timeIntervalSinceNow] > 0)) 
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
        NSLog(@"Polling...");
    }
    
    // Validate outbound request
    MockUrlConnection *connection = [self.factory fetchRequestConnection];
    NSURLRequest *request = connection.request;
    
    STAssertEqualObjects(@"GET", [request HTTPMethod], @"Method should be GET");
    STAssertEqualObjects(@"https://apis.live.net/v5.0/me?suppress_response_codes=true&suppress_redirects=true", request.URL.absoluteString, @"Invalid url");
    
    
    // set response
    id delegate = connection.delegate;
    MockResponse *response = [[[MockResponse alloc] init] autorelease];
    response.statusCode = 200;
    [delegate connection:connection didReceiveResponse:response];
    
    // set response data
    NSString *cid = @"aw383339";
    NSString *name = @"Alice W.";
    NSString *gender = @"female";
    
    NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  cid, @"id", 
                                  name, @"name",
                                  gender, @"gender",
                                  nil];
    NSString *responseText = [MSJSONWriter textForValue:responseDict];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding]; 
    [delegate connection:connection didReceiveData:data]; 
    
    // notify complete
    [delegate connectionDidFinishLoading:connection];
    
    // validate event
    STAssertEquals((NSUInteger)1, listener.events.count, @"Should receive 1 event.");
    
    NSDictionary *eventArgs = [listener fetchEvent];
    
    STAssertEquals(LIVE_UNIT_OPCOMPLETED, [eventArgs objectForKey:LIVE_UNIT_EVENT], @"Incorrect event.");
    STAssertNotNil([eventArgs objectForKey:LIVE_UNIT_OPERATION], @"operation should be nil");
    STAssertEqualObjects(operation, [eventArgs objectForKey:LIVE_UNIT_OPERATION], @"operation instance should be the same.");
    
    STAssertNotNil(operation.rawResult, @"rawresult should not be nil");
    
    STAssertEqualObjects(cid, [operation.result objectForKey:@"id"], @"Incorrect id value");
    STAssertEqualObjects(name, [operation.result objectForKey:@"name"], @"Incorrect name value");
    STAssertEqualObjects(gender, [operation.result objectForKey:@"gender"], @"Incorrect gender value");    
}

- (void) testPost
{
    NSString *path = @"me/contacts";
    NSString *userState = @"create a contact";
    NSString *firstName = @"Alice";
    NSString *lastName = @"Wang";
    LiveConnectClient *liveClient = [self createAuthenticatedClient];
    NSDictionary *dictBody = [NSDictionary dictionaryWithObjectsAndKeys:firstName,@"first_name", lastName, @"last_name", nil];
    NSString *jsonBody = [MSJSONWriter textForValue:dictBody];
    LiveOperation * operation = [liveClient postWithPath:path dictBody:dictBody delegate:self.listener userState:userState];
    
    STAssertEqualObjects(path, operation.path, @"Path invalid");
    STAssertEqualObjects(@"POST", operation.method, @"METHOD invalid");
    
    // We should get an async event right away. We use the NSRunLoop to allow the async event to kick in.
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:10];
    while ((listener.events.count == 0) && ([timeout timeIntervalSinceNow] > 0)) 
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
        NSLog(@"Polling...");
    }
    
    // Validate outbound request
    MockUrlConnection *connection = [self.factory fetchRequestConnection];
    NSURLRequest *request = connection.request;
    
    STAssertEqualObjects(@"POST", [request HTTPMethod], @"Method should be POST");
    STAssertEqualObjects(@"https://apis.live.net/v5.0/me/contacts?suppress_response_codes=true&suppress_redirects=true", request.URL.absoluteString, @"Invalid url");
    STAssertEqualObjects(jsonBody,  [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding], @"Request body incorrrect.");
    STAssertEqualObjects(LIVE_API_HEADER_CONTENTTYPE_JSON, [request valueForHTTPHeaderField:LIVE_API_HEADER_CONTENTTYPE], @"Incorrect content-type.");
    
    // set response
    id delegate = connection.delegate;
    MockResponse *response = [[[MockResponse alloc] init] autorelease];
    response.statusCode = 200;
    [delegate connection:connection didReceiveResponse:response];
    
    // set response data
    NSString *cid = @"aw383339";
    NSString *name = @"Alice W.";
    NSString *gender = @"female";
    
    NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  cid, @"id", 
                                  name, @"name",
                                  gender, @"gender",
                                  nil];
    NSString *responseText = [MSJSONWriter textForValue:responseDict];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding]; 
    [delegate connection:connection didReceiveData:data]; 
    
    // notify complete
    [delegate connectionDidFinishLoading:connection];
    
    // validate event
    STAssertEquals((NSUInteger)1, listener.events.count, @"Should receive 1 event.");
    
    NSDictionary *eventArgs = [listener fetchEvent];
    
    STAssertEquals(LIVE_UNIT_OPCOMPLETED, [eventArgs objectForKey:LIVE_UNIT_EVENT], @"Incorrect event.");
    STAssertNotNil([eventArgs objectForKey:LIVE_UNIT_OPERATION], @"operation should be nil");
    STAssertEqualObjects(operation, [eventArgs objectForKey:LIVE_UNIT_OPERATION], @"operation instance should be the same.");
    
    STAssertNotNil(operation.rawResult, @"rawresult should not be nil");
    
    STAssertEqualObjects(cid, [operation.result objectForKey:@"id"], @"Incorrect id value");
    STAssertEqualObjects(name, [operation.result objectForKey:@"name"], @"Incorrect name value");
    STAssertEqualObjects(gender, [operation.result objectForKey:@"gender"], @"Incorrect gender value");    
}

- (void) testCopy
{
    NSString *path = @"file.12345678";
    NSString *destination = @"folder.232323444";
    NSString *userState = @"copy a file";
    LiveConnectClient *liveClient = [self createAuthenticatedClient];
    
    LiveOperation * operation = [liveClient copyFromPath:path toDestination:destination delegate:self.listener userState:userState];
                                 
    STAssertEqualObjects(path, operation.path, @"Path invalid");
    STAssertEqualObjects(@"COPY", operation.method, @"Method invalid");
    
    // We should get an async event right away. We use the NSRunLoop to allow the async event to kick in.
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:10];
    while ((listener.events.count == 0) && ([timeout timeIntervalSinceNow] > 0)) 
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
        NSLog(@"Polling...");
    }
    
    // Validate outbound request
    MockUrlConnection *connection = [self.factory fetchRequestConnection];
    NSURLRequest *request = connection.request;
    
    STAssertEqualObjects(@"COPY", [request HTTPMethod], @"Method should be COPY");
    STAssertEqualObjects(@"https://apis.live.net/v5.0/file.12345678?suppress_response_codes=true&suppress_redirects=true", request.URL.absoluteString, @"Invalid url");
   
    NSDictionary *dictBody = [NSDictionary dictionaryWithObjectsAndKeys:destination ,@"destination", nil];
    NSString *jsonBody = [MSJSONWriter textForValue:dictBody];
    STAssertEqualObjects(jsonBody,[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding], @"Request body incorrrect.");
    STAssertEqualObjects(LIVE_API_HEADER_CONTENTTYPE_JSON, [request valueForHTTPHeaderField:LIVE_API_HEADER_CONTENTTYPE], @"Incorrect content-type.");
    
    NSString *tokenHeader = [NSString stringWithFormat:@"bearer %@", liveClient.session.accessToken];
    STAssertEqualObjects(tokenHeader, [request valueForHTTPHeaderField:LIVE_API_HEADER_AUTHORIZATION], @"Token invalid");
    
    // set response
    id delegate = connection.delegate;
    MockResponse *response = [[[MockResponse alloc] init] autorelease];
    response.statusCode = 200;
    [delegate connection:connection didReceiveResponse:response];
    
    // set response data
    
    NSString *name = @"Alice W.";
    
    NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  path, @"id", 
                                  name, @"name",
                                  nil];
    NSString *responseText = [MSJSONWriter textForValue:responseDict];
    NSData *data = [responseText dataUsingEncoding:NSUTF8StringEncoding]; 
    [delegate connection:connection didReceiveData:data]; 
    
    // notify complete
    [delegate connectionDidFinishLoading:connection];
    
    // validate event
    STAssertEquals((NSUInteger)1, listener.events.count, @"Should receive 1 event.");
    
    NSDictionary *eventArgs = [listener fetchEvent];
    
    STAssertEquals(LIVE_UNIT_OPCOMPLETED, [eventArgs objectForKey:LIVE_UNIT_EVENT], @"Incorrect event.");
    STAssertNotNil([eventArgs objectForKey:LIVE_UNIT_OPERATION], @"operation should be nil");
    STAssertEqualObjects(operation, [eventArgs objectForKey:LIVE_UNIT_OPERATION], @"operation instance should be the same.");
    
    STAssertNotNil(operation.rawResult, @"rawresult should not be nil");
    
    STAssertEqualObjects(path, [operation.result objectForKey:@"id"], @"Incorrect id value");
    STAssertEqualObjects(name, [operation.result objectForKey:@"name"], @"Incorrect name value");   
}

@end
