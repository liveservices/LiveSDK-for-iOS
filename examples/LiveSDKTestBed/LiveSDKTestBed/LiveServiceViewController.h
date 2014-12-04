//
//  LiveServiceViewController.h
//  Live SDK for iOS sample code
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

#import <Foundation/Foundation.h>
#import "LiveConnectClient.h"

@interface LiveServiceViewController : UIViewController<LiveAuthDelegate, LiveOperationDelegate, LiveDownloadOperationDelegate, LiveUploadOperationDelegate>

@property (nonatomic, retain) LiveConnectClient *liveClient;

@property (retain, nonatomic) IBOutlet UIButton *signInButton;
@property (retain, nonatomic) IBOutlet UIImageView *imgView;
@property (retain, nonatomic) IBOutlet UITextField *destinationTextField;
@property (retain, nonatomic) IBOutlet UITextField *pathTextField;
@property (retain, nonatomic) IBOutlet UITextField *scopesTextField;
@property (retain, nonatomic) IBOutlet UITextView *jsonBodyTextView;
@property (retain, nonatomic) IBOutlet UITextView *outputView;

- (IBAction)onClickAuthorizeButton:(id)sender;
- (IBAction)onClickSignInButton:(id)sender;
- (IBAction)onClickClearOutputButton:(id)sender;
- (IBAction)onClickGetButton:(id)sender;
- (IBAction)onClickDeleteButton:(id)sender;
- (IBAction)onClickDownloadButton:(id)sender;
- (IBAction)onClickUploadButton:(id)sender;
- (IBAction)onClickCopyButton:(id)sender;
- (IBAction)onClickMoveButton:(id)sender;
- (IBAction)onClickPostButton:(id)sender;
- (IBAction)onClickPutButton:(id)sender;

- (void) configureLiveClientWithScopes:(NSString *)scopeText;
- (void) loginWithScopes:(NSString *)scopeText;
- (void) logout;

- (void) appendOutput:(NSString *)text;
- (void) clearOutput;
- (void) handleException:(id)exception
                 context:(NSString *)context;
- (void) handleError:(NSError *)error
             context:(NSString *)context;

- (void) closeKeyboard;
@end
