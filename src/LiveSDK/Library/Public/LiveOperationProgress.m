//
//  LiveOperationProgress.m
//  Live SDK for iOS
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "LiveOperationProgress.h"

@implementation LiveOperationProgress

@synthesize bytesTransferred = _bytesTransferred,
            totalBytes = _totalBytes;

- (id) initWithBytesTransferred:(NSUInteger)bytesTransferred
                     totalBytes:(NSUInteger)totalBytes
{
    self = [super init];
    if (self) 
    {
        _bytesTransferred = bytesTransferred;
        _totalBytes = totalBytes;        
    }
    
    return self;
}

- (double) progressPercentage
{
    if (_totalBytes == 0)
    {
        return 0;
    }
    
    return (double)_bytesTransferred / _totalBytes;
}

@end
