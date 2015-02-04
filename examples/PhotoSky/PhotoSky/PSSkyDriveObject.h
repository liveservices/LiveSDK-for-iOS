//
//  PSFolder.h
//  PhotoSky
//
//  Copyright 2015 Microsoft Corporation
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import <Foundation/Foundation.h>
#import <LiveSDK/LiveConnectClient.h>

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
