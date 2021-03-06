//
//  SignInVwCtrl.m
//  PalUp
//
//  Created by Elisoft on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignInVwCtrl.h"

#import "PostAdvertController.h"
#import "PostAdvertControllerV2.h"
//#import "PalUpAppDelegate_iPhone.h"

#import "CredentialInfo.h"
#import "SignInBaseVwCtrl.h"
#import "NewAccountVwCtrl.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@interface SignInVwCtrl ()
- (IBAction)valueChanged:(id)sender;

@end
@implementation SignInVwCtrl


@synthesize palUpCtrl;
@synthesize resetPasswordVw;
@synthesize activityIndicator;
@synthesize txtFldRegisteredEmail;


-(id) initWithPostAdvertController:(PostAdvertController *) postAdvertController
{
    if (self) {
        self.palUpCtrl = postAdvertController;
    }

    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithAultoLogin:(BOOL)autoLogin
{
    _autoLogin = autoLogin;
    self = [super init];
    if (!self) {
        self = [super initWithNibName:nil bundle:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    if (interfaceOrientation==UIInterfaceOrientationPortrait ) {
        return YES;
    } else {
        return NO;
    }
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return NO;
}
- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    switch (toInterfaceOrientation) {
//        case UIInterfaceOrientationLandscapeLeft:
//            transform = CGAffineTransformTranslate(transform, self.view.frame.size.width, self.view.frame.size.height);
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//            break;
//        case UIInterfaceOrientationLandscapeRight:
//            transform = CGAffineTransformTranslate(transform, self.view.frame.size.width, self.view.frame.size.height);
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//            break;
//            
//            break;
//        default:
//            break;
//    }
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    self.view.transform = transform;

}
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
//    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
//        CGRect frame = signupBtn.frame;
//        frame.origin.y = 406;
//        signupBtn.frame = frame;
//    }else {
//        CGRect frame = signupBtn.frame;
//        frame.origin.y = 255;
//        signupBtn.frame = frame;
//    }

}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
   
    
    NSLog(@"orient %d", fromInterfaceOrientation);
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        CGRect frame = signupBtn.frame;
        frame.origin.y = 406;
        //signupBtn.frame = frame;
    }else {
        CGRect frame = signupBtn.frame;
        frame.origin.y = 255;
        //signupBtn.frame = frame;
    }
}
#pragma mark - View lifecycle


- (void)initUserPassword
{
    NSUserDefaults* dababase = [NSUserDefaults standardUserDefaults];
    //int iAutoFill =  [dababase integerForKey:cAutoFillInfor];
    //if (iAutoFill) {
        self.emailAddressTxt.text = [dababase stringForKey:@"userNamePA"];
        //self.passwordTxt.text  = [dababase stringForKey:@"passwordPA"];
    //}
    dababase = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    self.view.userInteractionEnabled = YES;
//    [activityIndicator stopAnimating];
//    if (success)
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    }
//    else
//    {
//        
//    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.layer.cornerRadius = 3.0;
    // Register Notification event 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWilBeShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
//    [self initDialog:resetPasswordVw];
    [self initUserPassword];
    [self valueChanged:nil];
  
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Custom initialization
    NSUserDefaults *database = [[NSUserDefaults alloc]init];
    if (_autoLogin)
    {
        NSString *userName = [database objectForKey:@"userNamePA"];
        NSString *email = [database objectForKey:@"email"];
        NSString *passwordPA = [database objectForKey:@"passwordPA"];
        if (passwordPA != nil) {
             passwordTxt.text = passwordPA;
            if ([passwordPA isEqualToString: @""]) {
                return;
            }
        }else
            passwordTxt.text = @"";
        
        if ((![email isEqualToString:@""]) && email != nil) {
            //success = [[PostadvertControllerV2 sharedPostadvertController]registrationLogin:email :passwordPA];
            emailAddressTxt.text = email;
            self.view.userInteractionEnabled = NO;
            activityIndicator.hidden = NO;
            [activityIndicator startAnimating];
            [self performSelector:@selector(processSignIn) withObject:nil afterDelay:0.000001];
        }else if(![userName isEqualToString:@""] && userName !=nil) {
            //success = [[PostadvertControllerV2 sharedPostadvertController]registrationLogin:userName :passwordPA];
            emailAddressTxt.text = userName;
            self.view.userInteractionEnabled = NO;
            activityIndicator.hidden = NO;
            [activityIndicator startAnimating];
            [self performSelector:@selector(processSignIn) withObject:nil afterDelay:0.000001];
        }
    }
}
///////////////////
-(IBAction) touchForgetPasswordBtn: (id) sender
{
    if (!self.overlay) {
        UIView *vw1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
        self.overlay = vw1;
    }
    
    [self makeKeyboardGoAway:nil];
    txtFldRegisteredEmail.text = @"";
    [self showDialog:resetPasswordVw];
    txtFldRegisteredEmail.keyboardType = UIKeyboardTypeEmailAddress;
    [txtFldRegisteredEmail becomeFirstResponder];
    //[self showDialog:resetPasswordVw];   
}

-(IBAction) touchResetPasswordBtn: (id) sender
{
    NSString *strEmail = txtFldRegisteredEmail.text;
    NSRange range = [strEmail rangeOfString:@"@"];
    
    if (range.length) {
        [self hideDialog:resetPasswordVw];
        self.overlay = nil;
        [self registrationResetPassword:txtFldRegisteredEmail.text];
    } else {
        UIAlertView *baseAlert = [[UIAlertView alloc]
                                  initWithTitle: @"Error!"
                                  message: @"Your email address is invalid. Please try again."
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
        [baseAlert show];
    }
    
}

-(IBAction) touchCancelResetPasswordBtn: (id) sender
{
    [self hideDialog:resetPasswordVw];
    self.overlay = nil;
    [self makeKeyboardGoAway:nil];
}

/*
-(void) didParseDatafromServer
{
    if ([palUpCtrl isLoggedIn]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showDialog:loginErrorVw];
    }
}
*/

- (void)processSignIn
{
    long success = [[PostadvertControllerV2 sharedPostadvertController] registrationLogin:[(UITextView*)[self.view viewWithTag:1] text]
                                               :[(UITextView*)[self.view viewWithTag:2] text] ]; 

    self.view.userInteractionEnabled = YES;
    if (success) 
    {
         _autoLogin = NO;
        [self.navigationController popViewControllerAnimated:YES];
        [activityIndicator stopAnimating];
    } else {
        [activityIndicator stopAnimating];
        if(_autoLogin)
        {
            _autoLogin = NO;
            return;
        }
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
        self.overlay = vw;
        [self showDialog:self.loginErrorVw];
        
    };
    if(_autoLogin)
    {
        _autoLogin = NO;
        return;
    }

}

- (IBAction)touchSignInBtn: (id) sender
{
    self.view.userInteractionEnabled = NO;
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    [self performSelector:@selector(processSignIn) withObject:nil afterDelay:0.000001];
    //[NSThread detachNewThreadSelector:@selector(processSignIn) toTarget:self withObject:nil];
}
- (IBAction)touchSignUpForPostAdvert:(id)sender
{
    NewAccountVwCtrl *newAccVwCtrl ;
    
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
        newAccVwCtrl = [[NewAccountVwCtrl alloc] initWithNibName:@"NewAccountVwCtrl_iPad" bundle:nil];
    }
    else
        newAccVwCtrl = [[NewAccountVwCtrl alloc] initWithNibName:@"NewAccountVwCtrl" bundle:nil];
    
    [self.navigationController pushViewController:newAccVwCtrl animated:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)touchTrySignInBtn: (id) sender
{
    passwordTxt.text = @"";
    [self valueChanged:nil];
    [self hideDialog:self.loginErrorVw];
}

- (IBAction)makeKeyboardGoAway:(id)sender
{
    [passwordTxt resignFirstResponder];
    [emailAddressTxt resignFirstResponder];
    [txtFldRegisteredEmail resignFirstResponder];
}
- (IBAction)valueChanged:(id)sender
{
    if ([emailAddressTxt.text isEqualToString:@""] || [passwordTxt.text isEqualToString:@""]) {
        loginBtn.enabled = NO;
        [loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else {
        [loginBtn setEnabled:YES];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [emailAddressTxt setEnablesReturnKeyAutomatically:YES];
    [passwordTxt setEnablesReturnKeyAutomatically:YES];
}

- (IBAction)didEndOnExitTxt:(id) sender
{
    UITextField *txtFld = (UITextField*) sender;
    
    if (txtFld == self.emailAddressTxt) {
        [self.passwordTxt becomeFirstResponder];
    } else if (txtFld == self.passwordTxt){
        [self makeKeyboardGoAway:nil];
        [self touchSignInBtn:nil];
    }    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWilBeShown:(NSNotification*)aNotification
{
    //    if (vwShowing){
    if (self.overlay){
        CGRect rc = self.overlay.frame;
        // Animate the message view into place
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        rc.origin = CGPointMake(0.0f, -70.0f);
        self.overlay.frame = rc;
        [UIView commitAnimations];
    }
    //    } 
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //    if (vwShowing){
    if (self.overlay){
        CGRect rc = self.overlay.frame;
        // Animate the message view into place
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        rc.origin = CGPointMake(0.0f, 0.0f);
        self.overlay.frame = rc;
        [UIView commitAnimations];
    }
    //    } 
}


- (void)registrationResetPassword:(NSString*) registeredEmail
{
    
    //PalUpController   *palUpCtrl = (PalUpController *)cAppiPhoneDelegate.palUpController;
    
    if(![palUpCtrl isConnectToWeb]){
        [palUpCtrl showAlertWithMessage:@"This device does not connect to Internet." andTitle:@"PalUp"];
        
        return;
    }
    
    NSLog(@"=====================E: registrationResetPassword=====================");
   
    NSString *post = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
					  "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                        "<soap:Body>"
                            "<RegistrationResetPassword xmlns='http://50.19.216.234/palup/server.php'>"
                                "<userName>%@</userName>"
                            "</RegistrationResetPassword>"
                        "</soap:Body>"
					  "</soap:Envelope>", registeredEmail];
	
	NSLog(@"%@", post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init]; 
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@#%@", cServiceLinks, @"RegistrationResetPassword"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
    
	NSError *error;
	NSURLResponse *response;
	NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@"=====================");
    NSString *encodeData=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];	
    NSString *data1 = [encodeData stringByReplacingOccurrencesOfString:@"&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;" withString:@""];
//    data1 = [data1 stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
//    data1 = [data1 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
	NSLog(@"%@", data1);
    NSLog(@"=====================");

/*    NSScanner *scanner = [NSScanner scannerWithString:data1];
    NSString *startTag = [NSString stringWithFormat:@"Status RegistrationStatusTypeID=\""];
    NSString *strResult= nil;
    
    [scanner scanUpToString:startTag intoString:nil];
    [scanner scanString:startTag intoString:nil];
    [scanner scanUpToString:@"\"" intoString:&strResult];
    
    NSLog(@"RegistrationStatusTypeID: %@", strResult);
    int retVal = 5; //OffLine status as default
    if (strResult) {
        retVal = [strResult longLongValue];
    }*/
}

@end
