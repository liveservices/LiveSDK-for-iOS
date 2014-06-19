//
//  PSMainViewController.h
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
