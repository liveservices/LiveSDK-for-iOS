//
//  LiveConnectClientListener.m
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
