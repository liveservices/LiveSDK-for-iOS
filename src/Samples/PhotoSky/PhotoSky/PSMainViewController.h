//
//  PSMainViewController.h
//  PhotoSky
//
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveSDK/LiveConnectClient.h"

@interface PSMainViewController : UIViewController<LiveAuthDelegate, LiveOperationDelegate>
{
@private NSArray *_scopes;
}
@property (strong, nonatomic) IBOutlet UIImageView *appLogo;
@property (strong, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;

@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UIButton *viewPhotosButton;
@property (strong, nonatomic) LiveConnectClient *liveClient;
@property (strong, nonatomic) UIViewController *currentModal;


- (IBAction)signinButtonClicked:(id)sender;
- (IBAction)viewPhotoButtonClicked:(id)sender;

- (void) updateUI;
- (void) modalCompleted:(id)sender;
@end
