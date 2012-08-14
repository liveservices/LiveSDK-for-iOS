//
//  LiveOperation.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "LiveOperationInternal.h"

@implementation LiveOperation

@synthesize liveOpCore;

- (id) initWithOpCore:(LiveOperationCore *)opCore
{
    self = [super init];
    if (self) 
    {
        liveOpCore = [opCore retain];
        liveOpCore.publicOperation = self;
    }
    
    return self;
}

- (void)dealloc 
{
    liveOpCore.publicOperation = nil;
    [liveOpCore release];
    
    [super dealloc];
}

- (NSString *)path
{
    return liveOpCore.path;
}

- (NSString *)method
{
    return liveOpCore.method;
}

- (NSString *)rawResult
{
    return liveOpCore.rawResult;
}

- (NSDictionary *)result
{
    return liveOpCore.result;
}

- (id) userState
{
    return liveOpCore.userState;
}

- (id<LiveOperationDelegate>) delegate
{
    return liveOpCore.delegate;
}

- (void) setDelegate:(id<LiveOperationDelegate>)delegate
{
    liveOpCore.delegate = delegate;
}

- (void) cancel
{
    [liveOpCore cancel];
}
@end
