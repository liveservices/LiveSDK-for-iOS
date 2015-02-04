//
//  LiveServiceViewController.h
//  Live SDK for iOS sample code
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
