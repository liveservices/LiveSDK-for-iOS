//
//  PSFolder.h
//  PhotoSky
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
#import "LiveSDK/LiveConnectClient.h"

@class PSSkyDriveObject;

@protocol PSSkyDriveContentLoaderDelegate <NSObject>

- (void) folderContentLoaded: (PSSkyDriveObject *) sender;

- (void) fullFolderTreeLoaded: (PSSkyDriveObject *) sender;

- (void) folderContentLoadingFailed: (NSError *)error 
                             sender: (PSSkyDriveObject *) sender;

- (void) fileContentLoaded: (PSSkyDriveObject *) sender;

- (void) fileContentLoadingFailed: (NSError *)error 
                           sender: (PSSkyDriveObject *) sender;

@end

@interface PSSkyDriveObject : NSObject<LiveOperationDelegate, LiveDownloadOperationDelegate, PSSkyDriveContentLoaderDelegate>

@property (strong, nonatomic) PSSkyDriveObject *parent;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (readonly, nonatomic) BOOL isFolder;
@property (readonly, nonatomic) BOOL isImage;

@property (strong, nonatomic) NSArray *folders;
@property (strong, nonatomic) NSArray *files;
@property (strong, nonatomic) NSData *data;

@property (readonly, nonatomic) NSString *filesPath;
@property (readonly, nonatomic) NSString *downloadPath;
@property (readonly, nonatomic) BOOL hasFullFolderTree;

@property (strong, nonatomic) LiveConnectClient *liveClient;
@property (strong, nonatomic) id<PSSkyDriveContentLoaderDelegate> delegate;

- (void) loadFolderContent;

- (void) loadFileContent;

@end
