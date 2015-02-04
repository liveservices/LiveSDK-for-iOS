//
//  PSSkyPhotoViewer.h
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
