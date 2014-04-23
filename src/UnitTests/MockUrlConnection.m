//
//  LiveSDKTests.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "MockUrlConnection.h"

@implementation MockUrlConnection

@synthesize request = _request, 
           delegate = _delegate;

+ (id) connection
{
    return [[[MockUrlConnection alloc] init] autorelease];
}

- (void)cancel
{
    
}
@end
