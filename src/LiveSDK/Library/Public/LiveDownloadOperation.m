//
//  LiveDownloadOperation.m
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

#import "LiveOperationInternal.h"
#import "LiveDownloadOperationInternal.h"

@implementation LiveDownloadOperation

- (id)initWithOpCore:(LiveDownloadOperationCore *)opCore
{
    return [super initWithOpCore:opCore];
}

- (NSString *)destinationDownloadPath
{
    return ((LiveDownloadOperationCore*)self.liveOpCore).destinationDownloadPath;
}

- (unsigned long long)downloadedBytes
{
    return ((LiveDownloadOperationCore*)self.liveOpCore).downloadedBytes;
}

- (long long)expectedContentLength
{
    return ((LiveDownloadOperationCore*)self.liveOpCore).expectedContentLength;
}

- (void)dealloc 
{
    [super dealloc];
}

@end
