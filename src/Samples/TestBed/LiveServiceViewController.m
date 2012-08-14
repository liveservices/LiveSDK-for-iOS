//
//  LiveServiceViewController.m
//  Live SDK for iOS sample code
//
//  Copyright (c) 2011 Microsoft Corp. All rights reserved.
//

#import "LiveServiceViewController.h"
#import "LiveAuthHelper.h"

// Set the CLIENT_ID value to be the one you get from http://manage.dev.live.com/
static NSString * const CLIENT_ID = @"%CLIENT_ID%";

@implementation LiveServiceViewController

@synthesize liveClient, outputView, signInButton, scopesTextField, pathTextField, destinationTextField, jsonBodyTextView, imgView;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc 
{
    [liveClient release];
    [outputView release];
    [signInButton release];
    [scopesTextField release];
    [pathTextField release];
    [destinationTextField release];
    [jsonBodyTextView release];
    [imgView release];
    [super dealloc];
}

#pragma mark - Output handling
- (void) handleException:(id)exception
                 context:(NSString *)context
{
    NSLog(@"Exception received. Context: %@", context);
    NSLog(@"Exception detail: %@", exception);
    
    [self appendOutput:[NSString stringWithFormat:@"Exception received. Context: %@", context]];
    [self appendOutput:[NSString stringWithFormat:@"Exception detail: %@", exception]];
}

- (void) handleError:(NSError *)error
             context:(NSString *)context
{
    NSLog(@"Error received. Context: %@", context);
    NSLog(@"Error detail: %@", error);
    
    [self appendOutput:[NSString stringWithFormat:@"Error received. Context: %@", context]];
    [self appendOutput:[NSString stringWithFormat:@"Error detail: %@", error]];
}

- (void) appendOutput:(NSString *)text
{
    if (text) 
    {
        self.outputView.text = [self.outputView.text stringByAppendingFormat:@"\r\n%@",text];
    }
}

- (void) clearOutput
{
    self.outputView.text = @"";
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureLiveClientWithScopes:self.scopesTextField.text];
}

- (void)viewDidUnload
{
    [self setScopesTextField:nil];
    [self setSignInButton:nil];
    [self setPathTextField:nil];
    [self setOutputView:nil];
    [self setDestinationTextField:nil];
    [self setJsonBodyTextView:nil];
    [self setImgView:nil];
    [super viewDidUnload];
}

#pragma mark - Auth methods

- (void) configureLiveClientWithScopes:(NSString *)scopeText
{
    if ([CLIENT_ID isEqualToString:@"%CLIENT_ID%"]) {
        [NSException raise:NSInvalidArgumentException format:@"The CLIENT_ID value must be specified."];
    }
    
    self.liveClient = [[[LiveConnectClient alloc] initWithClientId:CLIENT_ID 
                                                           scopes:[scopeText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                         delegate:self 
                                                        userState:@"init"] 
                       autorelease ];   
}

- (void) loginWithScopes:(NSString *)scopeText
{
    @try 
    {
        NSArray *scopes = [scopeText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [liveClient login:self
                   scopes:scopes
                 delegate:self 
                userState:@"login"];
    }
    @catch(id ex)
    {
        [self handleException:ex context:@"loginWithScopes"];
    }
}

- (void) logout
{
    @try 
    {
        [liveClient logoutWithDelegate:self userState:@"logout"];
    }
    @catch(id ex)
    {
        [self handleException:ex context:@"logout"];
    }
}

- (void) updateSignInButton 
{
    LiveConnectSession *session = self.liveClient.session;
    
    if (session == nil)
    {            
        [self.signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
    }
    else 
    {        
        [self.signInButton setTitle:@"Sign out" forState:UIControlStateNormal];
    }
}

#pragma mark - onClick button actions

- (IBAction)onClickSignInButton:(id)sender 
{
    if (self.liveClient.session == nil)
    {
        [self loginWithScopes:self.scopesTextField.text];
    }
    else
    {
        [self logout];
    }
    
    [self closeKeyboard];
}

- (IBAction)onClickAuthorizeButton:(id)sender 
{
    @try
    {
        [self loginWithScopes:self.scopesTextField.text]; 
    }
    @catch (id ex) 
    {
        [self handleException:ex context:@"authorize"];
    }
    @finally 
    {
        [self closeKeyboard];
    }
}

- (IBAction)onClickClearOutputButton:(id)sender 
{
    [self clearOutput];
}

- (IBAction)onClickGetButton:(id)sender 
{
    @try
    {
        [self.liveClient getWithPath:self.pathTextField.text
                            delegate:self
                           userState:@"get"];
    }
    @catch (id ex) 
    {
        [self handleException:ex context:@"get"];
    }
    @finally 
    {
        [self closeKeyboard];
    }
}

- (IBAction)onClickDeleteButton:(id)sender 
{
    @try 
    {
        [self.liveClient deleteWithPath:self.pathTextField.text 
                               delegate:self 
                              userState:@"delete"];
    }
    @catch (id ex) 
    {
        [self handleException:ex context:@"delete"];
    }
    @finally 
    {
        [self closeKeyboard];
    }
}

- (IBAction)onClickUploadButton:(id)sender 
{
    @try 
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"volvo_c70" 
                                                         ofType:@"jpg"];
        
        NSData *data = [[[NSData alloc]initWithContentsOfFile:path] autorelease];
        
        NSString *uploadPath = self.pathTextField.text;
        if ([uploadPath isEqual:@""] || 
            [[uploadPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
            uploadPath = @"me/skydrive";
        }
        
        [self.liveClient uploadToPath:uploadPath
                             fileName:@"volvo_c70.jpg" 
                                 data:data 
                            overwrite:LiveUploadOverwrite 
                             delegate:self 
                            userState:@"upload"];
    }
    @catch (id ex) 
    {
        [self handleException:ex context:@"upload"];
    }
    @finally 
    {
        [self closeKeyboard];
    }
}

- (IBAction)onClickCopyButton:(id)sender 
{
    @try
    {
        [self.liveClient copyFromPath:self.pathTextField.text
                        toDestination:self.destinationTextField.text 
                             delegate:self
                            userState:@"copy"];
    }
    @catch (id ex) 
    {
        [self handleException:ex context:@"copy"];
    }
    @finally 
    {
        [self closeKeyboard];
    }
}

- (IBAction)onClickMoveButton:(id)sender 
{
    @try 
    {
        [self.liveClient moveFromPath:self.pathTextField.text
                        toDestination:self.destinationTextField.text 
                             delegate:self
                            userState:@"move"];    
    }
    @catch (id ex) 
    {
        [self handleException:ex context:@"move"];
    }
    @finally 
    {
        [self closeKeyboard];
    }
}

- (IBAction)onClickPutButton:(id)sender 
{
    @try 
    {
        [self.liveClient putWithPath:self.pathTextField.text
                            jsonBody:self.jsonBodyTextView.text
                            delegate:self
                           userState:@"put"];
        
    }
    @catch (id ex) 
    {
        [self handleException:ex context:@"put"];
    }
    @finally 
    {
        [self closeKeyboard];
    }
}
- (IBAction)onClickPostButton:(id)sender 
{
    @try 
    {
        [self.liveClient postWithPath:self.pathTextField.text
                             jsonBody:self.jsonBodyTextView.text
                             delegate:self
                            userState:@"post"];    
    }
    @catch (id ex) 
    {
        [self handleException:ex context:@"post"];
    }
    @finally 
    {
        [self closeKeyboard];
    }
}

- (IBAction)onClickDownloadButton:(id)sender 
{
    @try 
    {
        [self.liveClient downloadFromPath:self.pathTextField.text 
                                 delegate:self 
                                userState:@"download"];
    }
    @catch (id ex) 
    {
        [self handleException:ex context:@"download"];
    }
    @finally 
    {
        [self closeKeyboard];
    }
}

- (void) closeKeyboard
{
    [self.scopesTextField resignFirstResponder];
    [self.pathTextField resignFirstResponder];
    [self.destinationTextField resignFirstResponder];
    [self.jsonBodyTextView resignFirstResponder];
}


#pragma mark LiveAuthDelegate 

- (void) authCompleted: (LiveConnectSessionStatus) status
               session: (LiveConnectSession *) session
             userState: (id) userState
{
    NSString *scopeText = [session.scopes componentsJoinedByString:@" "];
    [self appendOutput:[NSString stringWithFormat:@"%@ succeeded. scopes: %@",userState, scopeText]];
    [self updateSignInButton];
}

- (void) authFailed: (NSError *) error
          userState: (id)userState
{
    [self handleError:error 
              context:[NSString stringWithFormat:@"auth failed during %@", userState ]];
}

#pragma mark LiveOperationDelegate

- (void) liveOperationSucceeded:(LiveOperation *)operation
{
    [self appendOutput: [NSString stringWithFormat:@"The operation '%@' succeeded.", operation.userState]];
    if (operation.rawResult) 
    {
        [self appendOutput:operation.rawResult];
    }
    
    if ([operation.userState isEqual:@"download"]) 
    {
        LiveDownloadOperation *downloadOp = (LiveDownloadOperation *)operation;
        self.imgView.image = [UIImage imageWithData:downloadOp.data];
        
    }
}

- (void) liveOperationFailed:(NSError *)error 
                   operation:(LiveOperation *)operation
{
    [self handleError:error context:operation.userState];
}

- (void) liveDownloadOperationProgressed:(LiveOperationProgress *)progress data:(NSData *)receivedData operation:(LiveDownloadOperation *)operation
{
    NSString *text = [NSString stringWithFormat:@"Download in progress..%u bytes(%f %%, total %u bytes) has been transferred.", progress.bytesTransferred, progress.progressPercentage * 100, progress.totalBytes ];
    [self appendOutput:text];
}

- (void) liveUploadOperationProgressed:(LiveOperationProgress *)progress 
                             operation:(LiveOperation *)operation
{
    NSString *text = [NSString stringWithFormat:@"Upload in progress. %u bytes(%f %%, total %u bytes) has been transferred.", progress.bytesTransferred, progress.progressPercentage * 100, progress.totalBytes ];
    [self appendOutput:text];
}


@end
