//
//  PSFolder.m
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


#import "PSSkyDriveObject.h"

@implementation PSSkyDriveObject

@synthesize objectId, name, type, files, folders, data, parent, liveClient, delegate;

- (BOOL) isFolder
{
    return [self.type isEqual:@"folder"] || [self.type isEqual:@"album"];
}

- (BOOL) isImage
{
    return [self.type isEqual:@"photo"];
}

- (NSString *)filesPath 
{
    return [NSString stringWithFormat:@"%@%@", self.objectId, @"/files"];
}

- (NSString *) downloadPath
{
    return [NSString stringWithFormat:@"%@%@", self.objectId, @"/picture?type=normal"];
}

- (BOOL) hasFullFolderTree
{
    BOOL hasFullTree = YES;
    
    if (self.folders != nil) {
        for (NSUInteger i=0; i<self.folders.count; i++) {
            PSSkyDriveObject *folder = [self.folders objectAtIndex:i];
            if (!folder.hasFullFolderTree) {
                hasFullTree = NO;
                break;
            }
        }
    }
    else {
        hasFullTree = NO;
    }
    
    return hasFullTree;
}

- (void) loadFolderContent
{
    assert(self.isFolder);
    
    if (self.folders == nil) {
        [self.liveClient getWithPath:self.filesPath 
                            delegate:self 
                           userState:@"load-folder-content"];
    }
    else {
        for (NSUInteger i=0; i< self.folders.count; i++) {
            PSSkyDriveObject *folder = [self.folders objectAtIndex:i];
            if (!folder.hasFullFolderTree) {
                [folder loadFolderContent];
                return;
            }
        }
        
        [self.delegate fullFolderTreeLoaded:self];
    }
}

- (void) loadFileContent
{
    assert(!self.isFolder);
    
    if (self.data == nil) {
        [self.liveClient downloadFromPath:self.downloadPath
                                 delegate:self 
                                userState:@"load-file-content"];
    }
}

#pragma mark - LiveOperationDelegate


- (void) liveOperationSucceeded:(LiveOperation *)operation
{
    if ([operation.userState isEqual:@"load-file-content"])
    {
        LiveDownloadOperation *downloadOp = (LiveDownloadOperation *)operation;
        self.data = downloadOp.data;
        
        [self.delegate fileContentLoaded:self];
    }
    else if ([operation.userState isEqual:@"load-folder-content"])
    {
        NSMutableArray *subFolders = [NSMutableArray array];
        NSMutableArray *folderFiles = [NSMutableArray array];
        NSDictionary *result = operation.result;
        NSArray *rawFolderObjects = [result objectForKey:@"data"];
        BOOL hasSubFolders = NO;
        
        for (NSUInteger i=0; i < rawFolderObjects.count; i++) {
            NSDictionary *rawObject = [rawFolderObjects objectAtIndex:i];
            PSSkyDriveObject *skyDriveObject = [[PSSkyDriveObject alloc]init];
            
            skyDriveObject.parent = self;
            skyDriveObject.objectId = [rawObject objectForKey:@"id"];
            skyDriveObject.name = [rawObject objectForKey:@"name"];
            skyDriveObject.type = [rawObject objectForKey:@"type"];
            
            skyDriveObject.delegate = self;
            skyDriveObject.liveClient = self.liveClient;
            
            if (skyDriveObject.isFolder)
            {
                hasSubFolders = YES;
                [subFolders addObject:skyDriveObject];
            }
            else if (skyDriveObject.isImage)
            {
                [folderFiles addObject:skyDriveObject];
            }
            
        }
        
        
        self.folders = subFolders;
        self.files = folderFiles;
        
        [self.delegate folderContentLoaded:self];
        [self loadFolderContent];
    }
}
                
- (void) liveOperationFailed:(NSError *)error operation:(LiveOperation *)operation
{
    if ([operation.userState isEqual:@"load-folder-content"])
    {
        [self.delegate folderContentLoadingFailed:error sender:self];
    }
    else if ([operation.userState isEqual:@"load-file-content"])
    {
        [self.delegate fileContentLoadingFailed:error sender:self];
    }
}

#pragma mark - PSSkyDriveContentLoaderDelegate

- (void) folderContentLoaded: (PSSkyDriveObject *) sender
{
    // wait for full folder tree loaded.
}

- (void) fullFolderTreeLoaded: (PSSkyDriveObject *) sender
{
    [self loadFolderContent];
}

- (void) folderContentLoadingFailed: (NSError *)error 
                             sender: (PSSkyDriveObject *) sender
{
    [self.delegate folderContentLoadingFailed:error sender:self];
}

- (void) fileContentLoaded: (PSSkyDriveObject *) sender
{
    // We don't load file from here. The callback should not happen here.
}

- (void) fileContentLoadingFailed: (NSError *)error 
                           sender: (PSSkyDriveObject *) sender
{
    // We don't load file from here. The callback should not happen here.
}

@end
