//
//  PSSkyPhotoViewer.h
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

#import <UIKit/UIKit.h>
#import "PSMainViewController.h"
#import "PSSkyDriveObject.h"

@interface PSSkyPhotoViewer : UIViewController<PSSkyDriveContentLoaderDelegate>
{
@private
    NSInteger _currentPhotoIndex; 
}
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIButton *selectFolderButton;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *folderInfoLable;
@property (strong, nonatomic) IBOutlet UILabel *fileInfoLabel;

@property (strong, nonatomic) PSMainViewController *parentVC;
@property (strong, nonatomic) PSSkyDriveObject *rootFolder;
@property (strong, nonatomic) PSSkyDriveObject *currentFolder;

@property (strong, nonatomic) UIViewController *currentModal;

- (void) loadFolderContent;

- (void) showCurrentPhoto;

- (void) movePrevious;

- (void) moveNext;

- (void) updateUI;

- (IBAction)previousButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;
- (IBAction)selectButtonClicked:(id)sender;

- (void) selectFolderCompleted: (PSSkyDriveObject *)selectedFolder;

@end
