//
//  PSMainViewController.m
//  PhotoSky
//
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import "PSMainViewController.h"
#import "PSSkyPhotoViewer.h"

// Set the CLIENT_ID value to be the one you get from http://manage.dev.live.com/
static NSString * const CLIENT_ID = @"%CLIENT_ID%";

@implementation PSMainViewController
@synthesize appLogo;
@synthesize userInfoLabel;
@synthesize signInButton;
@synthesize viewPhotosButton;
@synthesize userImage;
@synthesize liveClient;
@synthesize currentModal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([CLIENT_ID isEqualToString:@"%CLIENT_ID%"]) {
        [NSException raise:NSInvalidArgumentException format:@"The CLIENT_ID value must be specified."];
    }
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _scopes = [NSArray arrayWithObjects:
                   @"wl.signin",
                   @"wl.basic",
                   @"wl.skydrive",
                   @"wl.offline_access", nil];
        liveClient = [[LiveConnectClient alloc] initWithClientId:CLIENT_ID 
                                                          scopes:_scopes
                                                        delegate:self];
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
    // Do any additional setup after loading the view from its nib.
    
    self.appLogo.image = [UIImage imageNamed:@"skydrive.jpeg"];
    [self updateUI];
}

- (void)viewDidUnload
{
    [self setAppLogo:nil];
    [self setUserInfoLabel:nil];
    [self setUserImage:nil];
    [self setSignInButton:nil];
    [self setViewPhotosButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)signinButtonClicked:(id)sender {
    if (self.liveClient.session == nil)
    {
        [self.liveClient login:self
                        scopes:_scopes
                      delegate:self];
    }
    else
    {
        [self.liveClient logoutWithDelegate:self 
                                  userState:@"logout"];
    }
}

- (IBAction)viewPhotoButtonClicked:(id)sender {
    
    // Create a Navigation controller
    PSSkyPhotoViewer *aPhotoViewer = [[PSSkyPhotoViewer alloc] initWithNibName:@"PSSkyPhotoViewer" bundle:nil];
    aPhotoViewer.parentVC = self;
    
    self.currentModal = [[UINavigationController alloc] initWithRootViewController:aPhotoViewer];
    [self presentModalViewController:self.currentModal animated:YES];    
}

- (void) modalCompleted:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    self.currentModal = nil;
}


#pragma mark LiveAuthDelegate

- (void) updateUI {
    LiveConnectSession *session = self.liveClient.session;
    if (session == nil) {            
        [self.signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
        self.viewPhotosButton.hidden = YES;
        self.userInfoLabel.text = @"Sign in with a Microsoft account before you can view your SkyDrive photos.";
        self.userImage.image = nil;
    }
    else {        
        [self.signInButton setTitle:@"Sign out" forState:UIControlStateNormal];
        self.viewPhotosButton.hidden = NO;
        self.userInfoLabel.text = @"";
        
        [self.liveClient getWithPath:@"me" delegate:self userState:@"me"];
        [self.liveClient getWithPath:@"me/picture" delegate:self userState:@"me-picture"];
    }
}

- (void) authCompleted: (LiveConnectSessionStatus) status
               session: (LiveConnectSession *) session
             userState: (id) userState {
    [self updateUI];
}

- (void) authFailed: (NSError *) error
          userState: (id)userState {
    // Handle error here
}

#pragma mark LiveOperationDelegate

- (void) liveOperationSucceeded:(LiveOperation *)operation {
    if ([operation.userState isEqual:@"me"]) {
        NSDictionary *result = operation.result;
        id name = [result objectForKey:@"name"];
        
        self.userInfoLabel.text = (name != nil)? name : @"";
    }
    
    if ([operation.userState isEqual:@"me-picture"]) {
        NSString *location = [operation.result objectForKey:@"location"];
        if (location) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:location]];
            self.userImage.image = [UIImage imageWithData:data];        
        }
    }
}

- (void) liveOperationFailed:(NSError *)error operation:(LiveOperation *)operation
{
    // Handle error here.
}

@end
