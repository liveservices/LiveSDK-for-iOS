//
//  MockFactory.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft. All rights reserved.
//

#import "MockFactory.h"
#import "MockUrlConnection.h"

@implementation MockFactory

@synthesize connectionQueue = _connectionQueue;

+ (id) factory
{
    return [[[MockFactory alloc] init] autorelease];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _connectionQueue = [[NSMutableArray array] retain];
    }
    return self;
}

- (void) dealloc
{
    [_connectionQueue release];
    [super dealloc];
}

- (id) createConnectionWithRequest:(NSURLRequest *)request 
                          delegate:(id)delegate
{
    MockUrlConnection *connection = [MockUrlConnection connection];        
    connection.request = request;
    connection.delegate = delegate;
    [self.connectionQueue addObject:connection];
        
    return connection;
}

- (MockUrlConnection *)fetchRequestConnection
{
    if (self.connectionQueue.count > 0) {
        MockUrlConnection *connection = [[[self.connectionQueue objectAtIndex:0] retain] autorelease];
        [self.connectionQueue removeObjectAtIndex:0];
        return connection;
    }
    
    return nil;
}
@end
