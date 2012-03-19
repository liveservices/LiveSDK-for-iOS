//
//  LiveConnectClientListener.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft. All rights reserved.
//

#import "LiveConnectClientListener.h"

@implementation LiveConnectClientListener

@synthesize events;

- (id) init
{
    self = [super init];
    if (self) 
    {
        events = [[NSMutableArray array] retain];
    }
    
    return self;
}

- (void) dealloc
{
    [events release];
    [super dealloc];
}

- (NSDictionary *)fetchEvent
{
    if (self.events.count > 0) 
    {
        NSDictionary *event = [[[self.events objectAtIndex:0] retain] autorelease];
        [self.events removeObjectAtIndex:0];
        return event;
    }
    return nil;
}

#pragma mark - LiveAuthDelegates

- (void) authCompleted:(LiveConnectSessionStatus)status 
               session:(LiveConnectSession *)session 
             userState:(id)userState
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                          LIVE_UNIT_AUTHCOMPLETED, LIVE_UNIT_EVENT, 
                          [NSNumber numberWithInt: status], LIVE_UNIT_STATUS, 
                          userState, LIVE_UNIT_USERSTATE,
                          session, LIVE_UNIT_SESSION, nil];
    
    [self.events addObject:args];
}

- (void) authFailed:(NSError *)error 
          userState:(id)userState
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                          LIVE_UNIT_AUTHFAILED, LIVE_UNIT_EVENT, 
                          error, LIVE_UNIT_ERROR, 
                          userState, LIVE_UNIT_USERSTATE, nil];
    
    [self.events addObject:args];    
}

- (void) liveOperationSucceeded:(LiveOperation *)operation
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                          LIVE_UNIT_OPCOMPLETED, LIVE_UNIT_EVENT, 
                          operation, LIVE_UNIT_OPERATION, nil];
    
    [self.events addObject:args];     
}

- (void) liveOperationFailed:(NSError *)error operation:(LiveOperation *)operation
{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                          LIVE_UNIT_OPFAILED, LIVE_UNIT_EVENT, 
                          error, LIVE_UNIT_ERROR, 
                          operation, LIVE_UNIT_OPERATION, nil];
    
    [self.events addObject:args]; 
}

@end
