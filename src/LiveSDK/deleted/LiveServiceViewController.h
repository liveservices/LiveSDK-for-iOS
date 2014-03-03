//
//  LiveServiceViewController.h
//  Live SDK for iOS sample code
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
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
