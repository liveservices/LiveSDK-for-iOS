//
//  LiveDownloadOperation.h
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

#import <Foundation/Foundation.h>
#import "LiveDownloadOperationDelegate.h"
#import "LiveOperation.h"

// LiveDownloadOperation class represents an operation of downloading a file from the user's SkyDrive account.
@interface LiveDownloadOperation : LiveOperation

// The path to the temporary file where we are downloading to, which can be used to track progress
@property (nonatomic, strong, readonly) NSString *temporaryPath;

// The destination path to where the file will be saved after downloading
@property (nonatomic, strong, readonly) NSString *destinationDownloadPath;

// The destination path to where the file will be saved after downloading
@property (nonatomic, assign, readonly) unsigned long long downloadedBytes;

// The expected content length. If there's no Content-Length specified, this could be -1
@property (nonatomic, assign, readonly) long long expectedContentLength;

@end
