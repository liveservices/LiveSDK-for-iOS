//
//  MockFactory.m
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
