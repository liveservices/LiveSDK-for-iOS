//
//  LiveDownloadOperation.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "LiveOperationInternal.h"
#import "LiveDownloadOperationInternal.h"

@implementation LiveDownloadOperation

@synthesize data;

- (id) initWithOpCore:(LiveDownloadOperationCore *)opCore
{
    return [super initWithOpCore:opCore];
}

- (NSData *)data
{
    return self.liveOpCore.responseData;
}

- (void)dealloc 
{
    [data release];
    
    [super dealloc];
}

@end
