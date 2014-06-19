//
//  LiveOperationProgress.m
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
