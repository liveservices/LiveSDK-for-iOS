//
//  PSFolder.h
//  PhotoSky
//
//  Copyright (c) 2012 Microsoft. All rights reserved.
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
