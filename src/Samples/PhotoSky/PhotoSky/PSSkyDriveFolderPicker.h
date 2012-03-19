//
//  PSSkyDriveFolderPicker.h
//  PhotoSky
//
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSSkyDriveObject.h"
#import "PSSkyPhotoViewer.h"

@interface PSSkyDriveFolderPicker : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PSSkyDriveObject* rootFolder;
@property (strong, nonatomic) PSSkyDriveObject* currentFolder;
@property (strong, nonatomic) PSSkyPhotoViewer* parentVC;

@property (strong, nonatomic) UIBarButtonItem* upButton;
@property (strong, nonatomic) UIBarButtonItem* openButton;
@property (strong, nonatomic) UIBarButtonItem* selectButton;
@property (strong, nonatomic) UIBarButtonItem* cancelButton;

- (void) goUp;
- (void) goDown;
- (void) selectFolder;
- (void) cancelSelection;
- (void) updateUI;
@end
