//
//  PSSkyPhotoViewer.m
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

#import "PSSkyPhotoViewer.h"
#import "PSSkyDriveFolderPicker.h"

@class PSMainViewController;

@implementation PSSkyPhotoViewer
@synthesize selectFolderButton;
@synthesize previousButton;
@synthesize nextButton;
@synthesize folderInfoLable;
@synthesize fileInfoLabel;
@synthesize image;
@synthesize parentVC;
@synthesize rootFolder;
@synthesize currentFolder;
@synthesize currentModal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                             target:self.parentVC
                                             action:@selector(modalCompleted:)];
    
    [self loadFolderContent];
}

- (void)viewDidUnload
{
    [self setImage:nil];
    [self setSelectFolderButton:nil];
    [self setPreviousButton:nil];
    [self setNextButton:nil];
    [self setFolderInfoLable:nil];
    [self setFileInfoLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - show photo logic

- (void) loadFolderContent
{
    if (self.rootFolder == nil) {
        PSSkyDriveObject *root = [[PSSkyDriveObject alloc] init];
        root.objectId = @"me/skydrive";
        root.name = @"SkyDrive";
        root.type = @"folder";
        root.liveClient = self.parentVC.liveClient;
        root.delegate = self;
        
        self.rootFolder = root;
        if (self.currentFolder == nil) {
            self.currentFolder = root;
        }
    }
        
    _currentPhotoIndex = -1;
    
    self.folderInfoLable.text = [NSString stringWithFormat:@"Folder: %@", self.currentFolder.name];
        
    if (!self.currentFolder.hasFullFolderTree) {
        [self.currentFolder loadFolderContent];
    }   
    
    if (self.currentFolder.folders) {
        [self updateUI];
    }
}

- (void) showCurrentPhoto
{
    PSSkyDriveObject *file = [self.currentFolder.files objectAtIndex:_currentPhotoIndex];
    
    if (file.data) {
        self.image.image = [UIImage imageWithData:file.data];
        self.fileInfoLabel.text = file.name;
    }
    else {
        file.delegate = self;
        [file loadFileContent];
        self.fileInfoLabel.text = @"Loading ...";
    }
}

- (void) updateUI
{
    if (self.currentFolder == nil || 
        self.currentFolder.files == nil ||
        self.currentFolder.files.count == 0)
    {
        self.previousButton.hidden = YES;
        self.nextButton.hidden = YES;
        return;
    }
    
    if (_currentPhotoIndex < 0) {
        _currentPhotoIndex = 0;
    }
    
    self.previousButton.hidden = (_currentPhotoIndex == 0);
    self.nextButton.hidden =
    (_currentPhotoIndex == (self.currentFolder.files.count -1));
    
    [self showCurrentPhoto];
}

- (void) movePrevious
{
    if (!self.previousButton.hidden) {
        _currentPhotoIndex--;
        [self updateUI];
    }
}

- (void) moveNext
{
    if (!self.nextButton.hidden) {
        _currentPhotoIndex++;
        [self updateUI];
    }
}

- (IBAction)previousButtonClicked:(id)sender {
    [self movePrevious];
}

- (IBAction)nextButtonClicked:(id)sender {
    [self moveNext];
}

- (IBAction)selectButtonClicked:(id)sender {
    // Create a Navigation controller
    PSSkyDriveFolderPicker *aFolderPicker = [[PSSkyDriveFolderPicker alloc] initWithNibName:@"PSSkyDriveFolderPicker" bundle:nil];
    aFolderPicker.parentVC = self;
    
    PSSkyDriveObject *selectRoot = [[PSSkyDriveObject alloc] init];
    selectRoot.objectId = @"root";
    selectRoot.name = @"root";
    selectRoot.type = @"folder";
    selectRoot.folders = [NSArray arrayWithObject:self.rootFolder];
    self.rootFolder.parent = selectRoot;
    selectRoot.files = [NSArray array];

    aFolderPicker.rootFolder = selectRoot;
    aFolderPicker.currentFolder = self.rootFolder;
    
    self.currentModal = [[UINavigationController alloc] initWithRootViewController:aFolderPicker];
    [self presentModalViewController:self.currentModal animated:YES];  
}

- (void) selectFolderCompleted:(PSSkyDriveObject *)selectedFolder
{ 
    [self dismissModalViewControllerAnimated:YES];
    self.currentModal = nil;  
    
    if (selectedFolder) {
        self.currentFolder = selectedFolder;
        [self loadFolderContent];
    }
}

#pragma mark - PSSkyDriveContentLoaderDelegate

- (void) folderContentLoaded: (PSSkyDriveObject *) sender
{
    [self updateUI];
}

- (void) fullFolderTreeLoaded: (PSSkyDriveObject *) sender
{
    if (self.currentFolder.hasFullFolderTree) {
        self.selectFolderButton.hidden = NO;
    }
}

- (void) folderContentLoadingFailed: (NSError *)error 
                             sender: (PSSkyDriveObject *) sender
{
    // error
}

- (void) fileContentLoaded: (PSSkyDriveObject *) sender
{
    self.image.image = [UIImage imageWithData:sender.data];
    self.fileInfoLabel.text = sender.name;
}

- (void) fileContentLoadingFailed: (NSError *)error 
                           sender: (PSSkyDriveObject *) sender
{
    // error
}

@end
