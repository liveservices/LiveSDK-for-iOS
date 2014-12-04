//
//  PSSkyDriveFolderPicker.m
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

#import "PSSkyDriveFolderPicker.h"

@implementation PSSkyDriveFolderPicker
@synthesize tableView, 
            rootFolder, 
            currentFolder, 
            parentVC, 
            upButton,
            openButton,
            selectButton,
            cancelButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
     
    
    // create a toolbar to have two buttons in the right
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 233, 44.01)];
    
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:5];
    
    // create a standard "up" button
    self.upButton =  [[UIBarButtonItem alloc] 
                            initWithTitle:@"Up" style:UIBarButtonItemStylePlain 
                            target:self
                            action:@selector(goUp)];

    self.upButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:self.upButton];
    
    // create a standard "Open" button
    self.openButton =  [[UIBarButtonItem alloc] 
                            initWithTitle:@"Open" style:UIBarButtonItemStylePlain 
                            target:self
                            action:@selector(goDown)];
    self.openButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:self.openButton];
    
    // create a standard "Select" button
    self.selectButton =  [[UIBarButtonItem alloc] 
           initWithTitle:@"Select" style:UIBarButtonItemStylePlain 
           target:self
           action:@selector(selectFolder)];
    self.selectButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:self.selectButton];
    
    // create a standard "Cancel" button
    self.cancelButton = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSelection)];
    self.cancelButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:self.cancelButton];
    
    // stick the buttons in the toolbar
    [tools setItems:buttons animated:NO];
    
    // and put the toolbar in the nav bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
    
    [self updateUI];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.currentFolder.folders count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    PSSkyDriveObject *skydriveObj = [self.currentFolder.folders objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d folders; %d files)", skydriveObj.name, (int)skydriveObj.folders.count, (int)skydriveObj.files.count];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - button actions
- (void) updateUI
{
    self.upButton.enabled = self.currentFolder.parent != nil;
    self.openButton.enabled = self.currentFolder.folders.count >0;
    
    [self.tableView reloadData];
}

- (void) goUp
{
    self.currentFolder = self.currentFolder.parent;
    [self updateUI];
}

- (void) goDown
{
    NSArray *indexes = [self.tableView indexPathsForSelectedRows];
    if (indexes.count > 0) {
        NSIndexPath *index = [indexes objectAtIndex:0];
        self.currentFolder = [self.currentFolder.folders objectAtIndex:index.row];
        [self updateUI];
    }
}

- (void) selectFolder
{
    NSArray *indexes = [self.tableView indexPathsForSelectedRows];
    if (indexes.count > 0) {
        NSIndexPath *index = [indexes objectAtIndex:0];
        PSSkyDriveObject *selectFolder = [self.currentFolder.folders objectAtIndex:index.row];
            
        [self.parentVC selectFolderCompleted:selectFolder];
    }
}

- (void) cancelSelection
{
    [self.parentVC selectFolderCompleted:nil];
}

@end
