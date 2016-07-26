//
//  MobileNumVerifyViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 19/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "MobileNumVerifyViewController.h"
#import "Q-ticketsConstants.h"
#import "SMSCountryConnections.h"
#import "SMSCountryLocalDB.h"
#import "SMSCountryUtils.h"
#import "PhoneVerificationParseOperation.h"
#import "ResendVericiationParseOperation.h"
#import "QticketsSingleton.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

@interface MobileNumVerifyViewController ()<SMSCountryConnectionDelegate,CommonParseOperationDelegate,UIAlertViewDelegate>{
    
     IBOutlet UILabel     *lblviewTitle;
     IBOutlet UIView      *viewforInfo;
     IBOutlet UIImageView *imgviewformobilebg;
     IBOutlet UITextField *tfofMobileVerificationNumber;
    
    NSMutableArray                      *connectionsArr;
    NSOperationQueue                    *queue;
    NSMutableArray                      *parsersArr;
    AppDelegate          *delegateApp;
    IBOutlet UIButton    *btnResendConfirmation;
    IBOutlet UIButton    *btnConfirmConfiramtion;

    
}

@end

@implementation MobileNumVerifyViewController
@synthesize phnePrefix,phoneNumber,userServerID,isVerify,isfromRegistation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegateApp         =  QTicketsAppDelegate;
    connectionsArr      = [[NSMutableArray alloc] init];
    parsersArr          = [[NSMutableArray alloc]init];
    queue               = [[NSOperationQueue alloc] init];
    
    [imgviewformobilebg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewformobilebg.layer setBorderWidth: 1.0];
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        if (ViewHeight == 480) {
            
            [btnConfirmConfiramtion setFrame:CGRectMake(btnConfirmConfiramtion.frame.origin.x, btnConfirmConfiramtion.frame.origin.y-20, btnConfirmConfiramtion.frame.size.width, btnConfirmConfiramtion.frame.size.height)];
        }
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
  //  tfofMobileVerificationNumber.inputAccessoryView = numberToolbar;

    
    
    
}

-(void)cancelNumberPad{
    
    [tfofMobileVerificationNumber resignFirstResponder];
    tfofMobileVerificationNumber.text = @"";
}

-(void)doneWithNumberPad{
    
    [tfofMobileVerificationNumber resignFirstResponder];
}




- (IBAction)btnConfirmedClicked:(id)sender {
    
    QticketsSingleton *sngleton = [QticketsSingleton sharedInstance];

    
    
    if (tfofMobileVerificationNumber.text.length<=0)
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_PHONE_VERIFICATION_CODE];
    }
    else
    {
        if (self.phoneNumber!=nil && self.phnePrefix!=nil)
        {
            [self userPhoneVerificationWithPrefix:self.phnePrefix WithPhone:self.phoneNumber andCode:tfofMobileVerificationNumber.text];
        }
        else if(sngleton.cureentLoginUser.serverId !=nil)
        {
            [self userPhoneVerificationWithPrefix:sngleton.cureentLoginUser.prefix WithPhone:sngleton.cureentLoginUser.phoneNumber andCode:tfofMobileVerificationNumber.text];
        }
    }

    
    
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark SMSCountry Service Calls
#pragma mark

-(void)userPhoneVerificationWithPrefix:(NSString *)prefx WithPhone:(NSString *)phone andCode:(NSString *)code
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn userPhoneVerificationWithPrefix:prefx andWithPhone:phone andCode:code];
    [connectionsArr addObject:conn];
   }

-(void)resendVerificationCodeWithUserID:(NSString *)useID andMobile:(NSString *)mobile withPrefix:(NSString *)prefix
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn resendVerificationCodeWithUserID:useID andMobile:mobile withPrefix:prefix];
    [connectionsArr addObject:conn];
    
}

#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:PHONE_VERIFICATION]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        PhoneVerificationParseOperation *pParser = [[PhoneVerificationParseOperation alloc] initWithData:data delegate:self andRequestMessage:PHONE_VERIFICATION];
        [queue addOperation:pParser];
        [parsersArr addObject:pParser];
        data = nil;
    }
    
    if ([reqMessage isEqualToString:RESEND_CODE]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        ResendVericiationParseOperation *rParser = [[ResendVericiationParseOperation alloc] initWithData:data delegate:self andRequestMessage:RESEND_CODE];
        [queue addOperation:rParser];
        [parsersArr addObject:rParser];
        data = nil;
    }
}

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:PHONE_VERIFICATION]) {
        
        if ([error.description isEqualToString:INTERNET_CONNECTION_OFFLINE])
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:CHECK_INTERNET_CONNECTION];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:error.description];
        }
    }
    
    if ([reqMessage isEqualToString:RESEND_CODE]) {
        
        if ([error.description isEqualToString:INTERNET_CONNECTION_OFFLINE])
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:CHECK_INTERNET_CONNECTION];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:error.description];
        }
    }
}

#pragma mark
#pragma mark CommonParserOperation Delegate methods
#pragma mark

- (void)didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr {
    
    if ([reqMsg isEqualToString:PHONE_VERIFICATION]) {
        [self performSelectorOnMainThread:@selector(handleLoadedVerificationPhone:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
    
    if ([reqMsg isEqualToString:RESEND_CODE]) {
        [self performSelectorOnMainThread:@selector(handleLoadedResendCode:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:PHONE_VERIFICATION]) {
        [self performSelectorOnMainThread:@selector(handleParserError:) withObject:error waitUntilDone:NO];
    }
    
    if ([reqMsg isEqualToString:RESEND_CODE]) {
        [self performSelectorOnMainThread:@selector(handleResendParserError:) withObject:error waitUntilDone:NO];
    }
    queue = nil;
}

#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark

- (void) handleLoadedVerificationPhone:(NSArray *)parsedArr {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    // if parsed Arr count is greater then zero. check the status if it is true then verification success else error code will be displayed
    if([parsedArr count]>0)
    {
        NSMutableDictionary *phneVerifyDictionary = [parsedArr objectAtIndex:0];
        if ([[phneVerifyDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[phneVerifyDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:VERFICIATION_SUCCESSFULL delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            isVerify = true;
            [alertV show];
        }
        else
        {
//            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[phneVerifyDictionary valueForKey:ERROR_MESSAGE]];
            
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:[phneVerifyDictionary valueForKey:ERROR_MESSAGE] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            if ([ERROR_MESSAGE isEqualToString:@"Already Verified"]) {
                
                isVerify = true;
            }
            [alertV show];
        }
    }
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:RESPONSE Message:SERVER_ERROR];
    }
    
}

- (void) handleParserError:(NSError *) error {
    
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
}

-(void)handleLoadedResendCode:(NSArray *)parsedArr {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    // if parsed Arr count is greater then zero. check the status if it is true then verification success else error code will be displayed
    
    if([parsedArr count]>0)
    {
        NSMutableDictionary *resendCodeDictionary = [parsedArr objectAtIndex:0];
        
        if ([[resendCodeDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[resendCodeDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:[resendCodeDictionary valueForKey:ERROR_MESSAGE] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertV show];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[resendCodeDictionary valueForKey:ERROR_MESSAGE]];
        }
    }
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:RESPONSE Message:SERVER_ERROR];
    }
}

-(void)handleResendParserError:(NSError *) error {
    
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
}

#pragma mark
#pragma mark AlertView Delegate
#pragma mark

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (isVerify && buttonIndex==0)
    {
        QticketsSingleton *sngleton = [QticketsSingleton sharedInstance];
        sngleton.cureentLoginUser.verify=@"True";
        [SMSCountryLocalDB updateloginUserwithUserVO:sngleton.cureentLoginUser];
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

        
        isVerify=false;
    }
    else
    {
        
        QticketsSingleton *sngleton = [QticketsSingleton sharedInstance];
        sngleton.cureentLoginUser.verify=@"False";
        [SMSCountryLocalDB updateloginUserwithUserVO:sngleton.cureentLoginUser];
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

//        NSArray *navController = self.navigationController.viewControllers;
//        
//        
//        NSInteger allcount = navController.count;
//        
//        
//        UIViewController *vC = [navController objectAtIndex:allcount-2];
//        
//        
//        [self.navigationController popToViewController:vC animated:YES];
    }
}

-(IBAction)btnBackClicked:(id)sender
{
    NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    QticketsSingleton *sngleton = [QticketsSingleton sharedInstance];
    sngleton.cureentLoginUser.verify=@"False";
    sngleton.cureentLoginUser.status= 1;
    [SMSCountryLocalDB updateloginUserwithUserVO:sngleton.cureentLoginUser];
     NSInteger login = 1;
     [USERDEFAULTS setInteger:login forKey:@"LoginStatus"];
     USERDEFAULTSAVE;
    
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
-(IBAction)btnResenedCodeClicked:(id)sender
{
    
    //checking whether userserverid exists or not and sending service call
    QticketsSingleton *sngleton = [QticketsSingleton sharedInstance];
    if (userServerID != nil)
    {
        //if user comes from registration page then this condition works
        [self resendVerificationCodeWithUserID:userServerID andMobile:phoneNumber withPrefix:phnePrefix];
    }
    else if(sngleton.cureentLoginUser.serverId!=nil)
    {
        //if user comes on button click of phone verification over setting this condition works
        [self resendVerificationCodeWithUserID:sngleton.cureentLoginUser.serverId andMobile:sngleton.cureentLoginUser.phoneNumber withPrefix:sngleton.cureentLoginUser.prefix];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
