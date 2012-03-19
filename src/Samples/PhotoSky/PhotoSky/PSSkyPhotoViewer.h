//
//  PSSkyPhotoViewer.h
//  PhotoSky
//
//  Copyright (c) 2012 Microsoft. All rights reserved.
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
