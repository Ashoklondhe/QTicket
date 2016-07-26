//
//  LoginViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "Q-ticketsConstants.h"
#import "RegistationViewController.h"
#import "SMSCountryLocalDB.h"
#import "QticketsSingleton.h"

#import "LoginParseOperation.h"
#import "ForgotPasswordParseOperation.h"
#import "HomeViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "SUCache.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

#import "UserVoucherParseOperation.h"

#import "AppDelegate.h"
#import "RegistrationParseOperation.h"



static NSString *kMyClientID = @"560191928474-hp6h1b0su07l9kilo877nvokan405cmc.apps.googleusercontent.com";
static NSString *kMyClientSecret = @"dfPfr-l4BRUBJjUnsfL9wApP";

static NSString *scopeurl = @"https://www.googleapis.com/auth/plus.me";



@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>{
    
  
     IBOutlet UITextField *tfofUserName;
     IBOutlet UITextField *tfofPassword;
     IBOutlet UIImageView *imgviewofusername;
     IBOutlet UIImageView *imgviewofPassword;
     IBOutlet UIView      *viewforAlertForgotPwd;
     IBOutlet UITextField  *tfofEmailId;
     IBOutlet UIScrollView *scrollofLogin;
    GTMOAuth2ViewControllerTouch *logincontroller;
    UINavigationController *navigationController;
    NSString *strUserServerId;
    NSMutableArray  *arrofVoucherDetails;
    AppDelegate    *delegateApp;
    
    
    IBOutlet UILabel *lblRegisterWith;
    IBOutlet UIButton *btnFacebook;
    IBOutlet UIButton *btngooglePlus;
    IBOutlet UILabel  *lblbottomBlackline;
    IBOutlet UIButton *btnForgotPwd;
    IBOutlet UIImageView *imgviewOfbottombg;
    IBOutlet UIImageView *imgviewofbottomLogo;
    
}
@end
@implementation LoginViewController
@synthesize connectionsArr,parsersArr,queue,isValue;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    delegateApp      = QTicketsAppDelegate;
    arrofVoucherDetails = [[NSMutableArray alloc] init];
    [viewforAlertForgotPwd setHidden:YES];
     NSInteger login = 0;
    [USERDEFAULTS setInteger:login forKey:@"LoginStatus"];
    USERDEFAULTSAVE;
    if (ViewHeight == 480) {
        
        [scrollofLogin setContentSize:CGSizeMake(310, ViewHeight-30)];
        [lblRegisterWith setFrame:CGRectMake(lblRegisterWith.frame.origin.x, lblRegisterWith.frame.origin.y+80, lblRegisterWith.frame.size.width, lblRegisterWith.frame.size.height)];
        [btnFacebook setFrame:CGRectMake(btnFacebook.frame.origin.x, btnFacebook.frame.origin.y+70, btnFacebook.frame.size.width, btnFacebook.frame.size.height)];
        [btngooglePlus setFrame:CGRectMake(btngooglePlus.frame.origin.x, btngooglePlus.frame.origin.y+70, btngooglePlus.frame.size.width, btngooglePlus.frame.size.height)];
         [btnForgotPwd setFrame:CGRectMake(btnForgotPwd.frame.origin.x, btnForgotPwd.frame.origin.y+70, btnForgotPwd.frame.size.width, btnForgotPwd.frame.size.height)];
         [lblbottomBlackline setFrame:CGRectMake(lblbottomBlackline.frame.origin.x, lblbottomBlackline.frame.origin.y+50, lblbottomBlackline.frame.size.width, lblbottomBlackline.frame.size.height)];
        [imgviewOfbottombg setFrame:CGRectMake(imgviewOfbottombg.frame.origin.x, imgviewOfbottombg.frame.origin.y+40, imgviewOfbottombg.frame.size.width, imgviewOfbottombg.frame.size.height)];
        [imgviewofbottomLogo setFrame:CGRectMake(imgviewofbottomLogo.frame.origin.x, imgviewofbottomLogo.frame.origin.y+40, imgviewofbottomLogo.frame.size.width, imgviewofbottomLogo.frame.size.height)];

    }
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }
    
    
    
    [imgviewofusername.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofusername.layer setBorderWidth: 1.0];
    [imgviewofPassword.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofPassword.layer setBorderWidth: 1.0];
    
    
    //tap gesture for hiding keyboard
    UITapGestureRecognizer *taptoHide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TaponView:)];
    [taptoHide setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:taptoHide];

    //for facebook
    [self initForFacebook];
    
    
}


-(void)TaponView:(UITapGestureRecognizer *)gesture{
    
    if ([tfofPassword becomeFirstResponder] == YES) {
        [tfofPassword resignFirstResponder];
    }
    if ([tfofUserName becomeFirstResponder] == YES) {
        [tfofUserName resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    
//    textField.placeholder = nil;
//    [textField becomeFirstResponder];
//
//}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
//    if ([textField.text isEqualToString:@""]) {
//        
//        if (textField.tag == 1) {
//            
//            textField.placeholder = @"Email";
//        }
//        else if (textField.tag == 2){
//            
//            textField.placeholder = @"Password";
//        }
//    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [scrollofLogin setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
    
}

- (IBAction)btnHomeClicked:(id)sender {
    
    NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    int index = 0;
    for(int i=0 ; i<[arrofNavoagtionsCon count] ; i++)
    {
        if([[arrofNavoagtionsCon objectAtIndex:i] isKindOfClass:NSClassFromString(@"HomeViewController")])
        {
            index = i;
            break;
        }
    }
    if (index != 0) {
        [self.navigationController popToViewController:[arrofNavoagtionsCon objectAtIndex:index] animated:YES];
        
    }
    else{
        
        HomeViewController *homeviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:homeviewVC animated:NO];

    }
    
}
#pragma mark --- facebook initializations

-(void)initForFacebook{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_accessTokenChanged:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
    SUCacheItem *item = [SUCache itemForSlot:0];
    if (![item.token isEqualToAccessToken:[FBSDKAccessToken currentAccessToken]]) {
        [self _deselectRow];
    }
    
}

- (void)_deselectRow
{
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
}
-(void)_accessTokenChanged:(NSNotification *)notification{
    
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    
    if (!token) {
        [self _deselectRow];
    } else {
        
        //      NSInteger slot = [self _userSlotFromIndexPath:_currentIndexPath];
        SUCacheItem *item = [SUCache itemForSlot:0] ?: [[SUCacheItem alloc] init];
        if (![item.token isEqualToAccessToken:token]) {
            item.token = token;
            [SUCache saveItem:item slot:0];
            
            
            //to get profile details
            
            
            [FBSDKAccessToken setCurrentAccessToken:token];
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
            
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                // Since we're only requesting /me, we make a simplifying assumption that any error
                // means the token is bad.
                
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:nil
                                                message:@"The user token is no longer valid."
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil] show];
                    [SUCache deleteItemInSlot:0];
                    
                }
                else{
                    
                    RegistrationVO   *regVO = [[RegistrationVO alloc]init];

                    
                    if (![[result objectForKey:@"email"] isEqualToString:@""]) {
                        
                        regVO.mailId = [result objectForKey:@"email"];
                    }
                    if (![[result objectForKey:@"first_name"] isEqualToString:@""]) {
                        
                        regVO.firstName = [result objectForKey:@"first_name"];
                    }
                    if (![[result objectForKey:@"last_name"] isEqualToString:@""]) {
                        
                        regVO.lastName  = [result objectForKey:@"last_name"];
                    }
                    if (![[result objectForKey:@"id"] isEqualToString:@""]) {
                        
                        regVO.fid = [result objectForKey:@"id"];
                    }
                   
                        regVO.phone = @"";
                        regVO.phonePrefix = @"";
                        regVO.password = @"";
                    regVO.confirmPassword = @"";
                    regVO.nationality = @"Nationality";
//                    NSDictionary *loation = [result objectForKey:@"location"];
//                    if (![[loation objectForKey:@"name"] isEqualToString:@""]) {
//                        
//                        regVO.nationality = [loation objectForKey:@"name"];
//                        
//                    }
                     [self userRegistrationWithRegistrationVOLogin:regVO];
                    
                 }
            }];
            
            
        }
    }
    
}

- (IBAction)btnLoginClicked:(id)sender {
    
       //check if input fields are empty
    if (tfofUserName.text.length<=0)
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_EMAIL_ID];
    }
    else
    {
        if (tfofPassword.text.length<=0)
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_PASSWORD];
        }
        else
        {//service call is done over here
            [self userLoginWithEmailId:tfofUserName.text andPassword:tfofPassword.text];
        }
    }
    
    
    
    
}


- (IBAction)btnFbClicked:(id)sender {
    
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior      = FBSDKLoginBehaviorWeb;
      
       
        [login logInWithReadPermissions:@[@"public_profile",@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
           
            if (error || result.isCancelled ) {
                
                [self _deselectRow];
            }
            else {
                
                
            }
            
        }];
    
}

#pragma mark --- g+ integration

- (IBAction)btnGplusClicked:(id)sender {
    
    
    void (^handler)(id, id, id) =
    ^(GTMOAuth2ViewControllerTouch *viewController,
      GTMOAuth2Authentication *auth,
      NSError *error) {
        
        if(error)
        {
            
            
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Authendication Cancled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            
        }
        else {
            // Create the request.
            NSURLRequest *logrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",auth.accessToken]]];
            [NSURLConnection sendAsynchronousRequest:logrequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       
                                       if (error) {
                                           [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Login Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                                           
                                       }
                                       else{
                                           
                                           NSDictionary  * result = [NSJSONSerialization                      JSONObjectWithData:data                                                         options:kNilOptions   error:&error];
                                           
                                           
                                           [self.navigationController dismissViewControllerAnimated:YES completion:nil];

                                           
                                           RegistrationVO   *regVO = [[RegistrationVO alloc]init];
                                           
                                           
                                           
                                           if (![[result objectForKey:@"email"] isEqualToString:@""]) {
                                               
                                               regVO.mailId = [result objectForKey:@"email"];
                                           }
                                           if (![[result objectForKey:@"family_name"] isEqualToString:@""]) {
                                               
                                               regVO.firstName = [result objectForKey:@"family_name"];
                                           }
                                           if (![[result objectForKey:@"given_name"] isEqualToString:@""]) {
                                               
                                               regVO.lastName  = [result objectForKey:@"given_name"];
                                           }
                                           if (![[result objectForKey:@"id"] isEqualToString:@""]) {
                                               
                                               regVO.fid = [result objectForKey:@"id"];
                                           }
                                           
                                           regVO.phone = @"";
                                           regVO.phonePrefix = @"";
                                           regVO.password = @"";
                                           regVO.confirmPassword = @"";
                                           regVO.nationality = @"Nationality";
                                           [self userRegistrationWithRegistrationVOLogin:regVO];
                                           
                                           
                                       }
                                   }];
        }
    };
    logincontroller = [GTMOAuth2ViewControllerTouch
                       controllerWithScope:kGTLAuthScopePlusLogin
                       clientID:kMyClientID
                       clientSecret:kMyClientSecret
                       keychainItemName:[GPPSignIn sharedInstance].keychainName
                       completionHandler:handler];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:logincontroller];
    navigationController.modalTransitionStyle = UIModalPresentationFormSheet;
    
    [navigationController.view setBackgroundColor:[UIColor whiteColor]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(didCanceledAuthorization)];
        logincontroller.navigationItem.rightBarButtonItem = cancelButton;
        logincontroller.navigationItem.leftBarButtonItem = nil;
        logincontroller.navigationItem.title = @"Google Login";
    });
    [self presentViewController:navigationController animated:YES completion:nil];
    
    
}

-(void)didCanceledAuthorization{
    
    [logincontroller cancelSigningIn];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)NavigatetoHome{

     NSInteger login = 1;
    [USERDEFAULTS setInteger:login forKey:@"LoginStatus"];
    USERDEFAULTSAVE;
    
    NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    int index = 0;
    for(int i=0 ; i<[arrofNavoagtionsCon count] ; i++)
    {
        if([[arrofNavoagtionsCon objectAtIndex:i] isKindOfClass:NSClassFromString(@"HomeViewController")])
        {
            index = i;
            break;
        }
    }
    if (index != 0) {
        [self.navigationController popToViewController:[arrofNavoagtionsCon objectAtIndex:index] animated:YES];
    }
    else{
        
        HomeViewController *homeviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:homeviewVC animated:NO];
        
    }
    
}



- (IBAction)btnRegisterClicked:(id)sender {
    
    RegistationViewController *registaionVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"RegistationViewController"];
    [self.navigationController pushViewController:registaionVc animated:YES];
    
}


- (IBAction)btnForgotpwdClicked:(id)sender {
    
    tfofEmailId.text = @"";
    [viewforAlertForgotPwd setHidden:NO];
}

-(IBAction)btnAlertCancelClciked:(id)sender
{
    [viewforAlertForgotPwd setHidden:YES];
}
-(IBAction)btnAlertSubmitClicked:(id)sender
{
   
    
    
    if (tfofEmailId.text.length <=0) {
        
        [SMSCountryUtils showAlertMessageWithTitle:@"Alert" Message:@"Please Enter EmailId"];
    }
    else{
    
         [viewforAlertForgotPwd setHidden:YES];
        
    [self forgotPasswordWithEmailID:[NSString stringWithFormat:@"%@",tfofEmailId.text]];
    }
}


#pragma mark
#pragma mark SMSCountry Service Calls
#pragma mark

-(void)userRegistrationWithRegistrationVOLogin:(RegistrationVO *)registerVO
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn userRegistrationWithUserVO:registerVO withDeviceToken:delegateApp.strDeviceToken];
    [connectionsArr addObject:conn];
}




-(void)userLoginWithEmailId:(NSString *)emailID andPassword:(NSString *)password
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn userLoginWithUserName:emailID andPassword:password wihtDeviceToken:delegateApp.strDeviceToken];
    [connectionsArr addObject:conn];
    
}

-(void)forgotPasswordWithEmailID:(NSString *)userEmailID
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn forgotPasswordWithEmailID:userEmailID];
    [connectionsArr addObject:conn];
}


#pragma mark ---  calling for evouchers

-(void)CallforEvouchers:(id)sender{
    
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn getUserVoucherwithUserID:strUserServerId];
    [connectionsArr addObject:conn];

}




#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:USER_LOGIN]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        self.queue = tmpQueue;
        
        LoginParseOperation *lParser = [[LoginParseOperation alloc] initWithData:data delegate:self andRequestMessage:USER_LOGIN];
        [self.queue addOperation:lParser];
        [parsersArr addObject:lParser];
        data = nil;
    }
    if ([reqMessage isEqualToString:REGISTRATION]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        RegistrationParseOperation *rParser = [[RegistrationParseOperation alloc] initWithData:data delegate:self andRequestMessage:REGISTRATION];
        [queue addOperation:rParser];
        [parsersArr addObject:rParser];
        data = nil;
    }
    if ([reqMessage isEqualToString:FORGOT_PASSWORD]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        self.queue = tmpQueue;
        ForgotPasswordParseOperation *lParser = [[ForgotPasswordParseOperation alloc] initWithData:data delegate:self andRequestMessage:FORGOT_PASSWORD];
        [ self.queue addOperation:lParser];
        [parsersArr addObject:lParser];
        data = nil;
    }
    if ([reqMessage isEqualToString:GET_ALLEVOUCHERS]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
         self.queue = tmpQueue;
        UserVoucherParseOperation *bParser = [[UserVoucherParseOperation alloc] initWithData:data delegate:self andRequestMessage:GET_ALLEVOUCHERS];
        [self.queue addOperation:bParser];
        [parsersArr addObject:bParser];
        data = nil;
        
    }

    

}

-(void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage{
    
    
    if ([reqMessage isEqualToString:USER_LOGIN])
    {
        //checking whether user exists or not through locadb at failure situation and navigating to nextvc
        UserVO *userVo = [SMSCountryLocalDB getUserExistWithEmailId:tfofEmailId.text andPassword:tfofPassword.text];
        if(userVo.serverId != nil)
        {
            [SMSCountryLocalDB logInUser:userVo.serverId];
            QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
            
            //isvalue becomes true when it comes from any new vc and pops back to same vc
            if (isValue)
            {
                singleTon.cureentLoginUser=[SMSCountryLocalDB getLoggedInUser];
                [self.navigationController  popViewControllerAnimated:YES];
                isValue=false;
            }
            else
            {
                [self NavigatetoHome];
            }
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SERVER_NOT_RESPONDING];
        }
    }
    
    if ([reqMessage isEqualToString:REGISTRATION]) {
        //If error tells that there is no internet connection then check through localDB and naviagate to next VC
        if ([error.description isEqualToString:INTERNET_CONNECTION_OFFLINE])
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:CHECK_INTERNET_CONNECTION];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:error.description];
        }
    }

    
    
    
    if ([reqMessage isEqualToString:FORGOT_PASSWORD])
    {
        if ([error.description isEqualToString:INTERNET_CONNECTION_OFFLINE])
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:CHECK_INTERNET_CONNECTION];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:error.description];
        }
    }

    if ([reqMessage isEqualToString:GET_ALLEVOUCHERS]) {
        
        if ([SMSCountryLocalDB  getVoucherDetailsForlocalUserId:strUserServerId].count>0)
        {
            [arrofVoucherDetails addObjectsFromArray:[SMSCountryLocalDB getVoucherDetailsForlocalUserId:strUserServerId]];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:VOUCHERDETAILS_NOT_AVAILABLE];
        }
    }
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:error.description];
    }


    
}


#pragma mark
#pragma mark CommonParserOperation Delegate methods
#pragma mark
- (void)didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr {
    
    if ([reqMsg isEqualToString:USER_LOGIN]) {
        [self performSelectorOnMainThread:@selector(handleLoadedLogin:) withObject:parseArr waitUntilDone:NO];
        self.queue = nil;   // we are finished with the queue and our ParseOperation
    }
    if ([reqMsg isEqualToString:FORGOT_PASSWORD]) {
        [self performSelectorOnMainThread:@selector(handleLoadedForgotPassword:) withObject:parseArr waitUntilDone:NO];
        self.queue = nil;   // we are finished with the queue and our ParseOperation
    }
    if ([reqMsg isEqualToString:GET_ALLEVOUCHERS]) {
        [self performSelectorOnMainThread:@selector(handleUserVoucherDetails:) withObject:parseArr waitUntilDone:NO];
         self.queue = nil;   // we are finished with the queue and our ParseOperation
    }
    if ([reqMsg isEqualToString:REGISTRATION]) {
        [self performSelectorOnMainThread:@selector(handleLoadedRegistrationlogin:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }

}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:USER_LOGIN]) {
        [self performSelectorOnMainThread:@selector(handleParserError:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:FORGOT_PASSWORD]) {
        [self performSelectorOnMainThread:@selector(handleForgotPwdParserError:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:GET_ALLEVOUCHERS]) {
        [self performSelectorOnMainThread:@selector(handleParserErrorVOU:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:REGISTRATION]) {
        [self performSelectorOnMainThread:@selector(handleParserErrorlogin:) withObject:error waitUntilDone:NO];
    }
    self.queue = nil;
}

#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark

- (void) handleLoadedLogin:(NSArray *)parsedArr {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    // if parsed Arr count is greater then zero. Now we can insert the user into localdb if user doesnot exist, if user exists then update localdb data
    if([parsedArr count]>0)
    {
        NSMutableDictionary *loginDictionary = [parsedArr objectAtIndex:0];
        
        if ([[loginDictionary valueForKey:STATUS] isEqualToString:@"true"]||[[loginDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            
            UserVO *userVo = [loginDictionary valueForKey:USER_OBJECT];
            userVo.password=tfofPassword.text;//as password will not be obtained in response so we are storing it
            userVo.status=1;
            
            [SMSCountryLocalDB deleteAllUsers];
            
            
            
            if ([SMSCountryLocalDB isUserExists:userVo.serverId])
            {
                [SMSCountryLocalDB updateloginUserwithUserVO:userVo];
            }
            else
            {
                [SMSCountryLocalDB insertUser:userVo];
            }

            strUserServerId = [NSString stringWithFormat:@"%@",userVo.serverId];
            QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
            //isvalue becomes true when it comes from any new vc and pops back to same vc
            if (isValue)
            {
                singleTon.cureentLoginUser=[SMSCountryLocalDB getLoggedInUser];
                [self NavigatetoHome];
                isValue=false;
            }
            else
            {
                singleTon.cureentLoginUser=[SMSCountryLocalDB getLoggedInUser];

                [self NavigatetoHome];
            }
            

        }
        else   //Based on error code data will be displayed
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[loginDictionary valueForKey:ERROR_MESSAGE]];
        }
    }
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:RESPONSE Message:SERVER_ERROR];
    }
}

- (void) handleParserError:(NSError *) error
{
    //if parsed error obtains then again check in localdb if exists login and navigate to next VC
    UserVO *userVo = [SMSCountryLocalDB getUserExistWithEmailId:tfofEmailId.text andPassword:tfofPassword.text];
    if(userVo.serverId != nil)
    {
        [SMSCountryLocalDB logInUser:userVo.serverId];
        QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
        //isvalue becomes true when it comes from any new vc and pops back to same vc
        if (isValue)
        {
            singleTon.cureentLoginUser=[SMSCountryLocalDB getLoggedInUser];
            [self NavigatetoHome];
            isValue=false;
        }
        else
        {
            singleTon.cureentLoginUser=[SMSCountryLocalDB getLoggedInUser];
            [self NavigatetoHome];
        
        }
    }
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SERVER_NOT_RESPONDING];
    }
}






- (void) handleLoadedRegistrationlogin:(NSArray *)parsedArr {
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    // if parsed Arr count is greater then zero. Now we can insert the user into localdb
    if (parsedArr.count > 0)
    {
        NSMutableDictionary *registerDictionary = [parsedArr objectAtIndex:0];

        if ([[registerDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[registerDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            
            UserVO *userVo             = [registerDictionary valueForKey:USER_OBJECT];
            
            userVo.password=@"";
            userVo.status=1;
            if ([SMSCountryLocalDB isUserExists:userVo.serverId])
            {
                [SMSCountryLocalDB updateloginUserwithUserVO:userVo];
            }
            else
            {
                [SMSCountryLocalDB insertUser:userVo];
            }
            QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
            //isvalue becomes true when it comes from any new vc and pops back to same vc
            if (isValue)
            {
                singleTon.cureentLoginUser=[SMSCountryLocalDB getLoggedInUser];
                [self NavigatetoHome];
                isValue=false;
            }
            else
            {
                singleTon.cureentLoginUser=[SMSCountryLocalDB getLoggedInUser];
                
                [self NavigatetoHome];
            }
        }
        else   //Based on error code data will be displayed
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[registerDictionary valueForKey:ERROR_MESSAGE]];
        }
    }
    
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:RESPONSE Message:SERVER_ERROR];
    }
    
}
- (void) handleParserErrorlogin:(NSError *) error {
    
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
}


- (void) handleLoadedForgotPassword:(NSArray *)parsedArr
{
    if([parsedArr count]>0)
    {
        NSMutableDictionary *loginDictionary = [parsedArr objectAtIndex:0];
        if ([[loginDictionary valueForKey:STATUS] isEqualToString:@"true"]||[[loginDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            if ([[loginDictionary valueForKey:ERRORCODE] isEqualToString:@"122"])
            {
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[loginDictionary valueForKey:ERROR_MESSAGE]];
            }
            else  if ([[loginDictionary valueForKey:ERRORCODE] isEqualToString:@"102"])
            {
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[loginDictionary valueForKey:ERROR_MESSAGE]];
            }
        }
        else{
            
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[loginDictionary valueForKey:ERROR_MESSAGE]];
        }
    }
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SERVER_NOT_RESPONDING];
    }
}

- (void) handleForgotPwdParserError:(NSError *) error
{
    [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SERVER_NOT_RESPONDING];
}



#pragma  mark ---- VoucherDetails parser methods




-(void)handleUserVoucherDetails:(NSArray *)parsedArr{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    // if parsed Arr count is greater then zero. Now we can insert bookinghistory into localdb
    if (parsedArr.count>0)
    {
        
        [arrofVoucherDetails addObjectsFromArray:parsedArr];
    }
    
}


-(void)handleParserErrorVOU:(NSError *)error{
    
    
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
    
    
}

-(void)dealloc{
    
    for (SMSCountryConnections *conn in connectionsArr) {
        [conn cancelServerConnection];
    }
    if (queue != nil) {
        
        queue = nil;
    }
    for (CommonParseOperation *tmpParseOper in parsersArr) {
        
        [tmpParseOper setDelegate:nil];
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
