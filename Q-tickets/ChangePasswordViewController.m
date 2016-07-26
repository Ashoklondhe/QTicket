//
//  ChangePasswordViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Q-ticketsConstants.h"
#import "QticketsSingleton.h"
#import "SMSCountryLocalDB.h"
#import "SMSCountryConnections.h"
#import "SMSCountryUtils.h"
#import "ChangePasswordParseOperation.h"
#import "AppDelegate.h"
#import "HomeViewController.h"



@interface ChangePasswordViewController ()<UITextFieldDelegate,SMSCountryConnectionDelegate,CommonParseOperationDelegate>{
    
   

     IBOutlet UILabel     *lblofViewtitle;
     IBOutlet UIImageView *imgviewofoldpwsbg;
     IBOutlet UITextField *tfofOldPwd;
     IBOutlet UIImageView *imgviewofNewpwsbg;
     IBOutlet UITextField *tfofNewPwd;
     IBOutlet UIImageView *imgviewofConfirmpwsbg;
     IBOutlet UITextField *tfofConfirmPwd;
     IBOutlet UIScrollView *scrollofData;
    
     NSInteger             textFieldTag;
    NSMutableArray         *connectionsArr;
    NSMutableArray         *parseArrNew;
    NSOperationQueue       *queue;
    AppDelegate            *delegateApp;
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    connectionsArr  = [[NSMutableArray alloc] init];
    parseArrNew        = [[NSMutableArray alloc] init];
    queue           = [[NSOperationQueue alloc] init];
    
    delegateApp = QTicketsAppDelegate;
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }
    
    
    
    
    [imgviewofoldpwsbg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofoldpwsbg.layer setBorderWidth: 1.0];
  
    [imgviewofNewpwsbg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofNewpwsbg.layer setBorderWidth: 1.0];
  
    [imgviewofConfirmpwsbg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofConfirmpwsbg.layer setBorderWidth: 1.0];
    
   // [scrollofData setFrame:CGRectMake(0, 4, ViewWidth-20, ViewHeight-200)];
    [scrollofData setContentSize:CGSizeMake(ViewWidth-20, ViewHeight)];
    

    [self SetToolBar];
    
    
   
}


-(void)SetToolBar{
    
    UIToolbar* keyboardDoneButtonView  = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle    = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor   = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton        = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneClicked:)];
    UIBarButtonItem* previousButton    = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                                       style:UIBarButtonItemStylePlain target:self
                                                                      action:@selector(previousBtnClicked:)];
    UIBarButtonItem* nextButton        = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(nextBtnClicked:)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:previousButton,nextButton,doneButton, nil]];
    
    tfofOldPwd.inputAccessoryView=keyboardDoneButtonView;
    tfofNewPwd.inputAccessoryView=keyboardDoneButtonView;
    tfofConfirmPwd.inputAccessoryView=keyboardDoneButtonView;

}
-(void)nextBtnClicked:(id)sender
{
    if (textFieldTag == tfofOldPwd.tag)
    {
        [tfofOldPwd resignFirstResponder];
        [tfofNewPwd becomeFirstResponder];
    }
    else if (textFieldTag == tfofNewPwd.tag)
    {
        [tfofNewPwd resignFirstResponder];
        [tfofConfirmPwd becomeFirstResponder];
    }
    else if (textFieldTag == tfofConfirmPwd.tag)
    {
        [scrollofData setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofConfirmPwd resignFirstResponder];
        
    }
    
}

-(void)previousBtnClicked:(id)sender
{
    if (textFieldTag == tfofOldPwd.tag)
    {
        [scrollofData setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofOldPwd resignFirstResponder];
    }
    else if (textFieldTag == tfofNewPwd.tag)
    {
        [tfofNewPwd resignFirstResponder];
        [tfofOldPwd becomeFirstResponder];
    }
    else if (textFieldTag == tfofConfirmPwd.tag)
    {
        [scrollofData setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofConfirmPwd resignFirstResponder];
        [tfofNewPwd becomeFirstResponder];
    }
    
}
- (void)doneClicked:(id)sender {
    
    [[self.view viewWithTag:tfofOldPwd.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofNewPwd.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofConfirmPwd.tag] resignFirstResponder];
    [scrollofData setContentOffset:CGPointMake(0,0) animated:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
    return YES;
    
}
// called when textField start editting.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textFieldTag=textField.tag;
    
    [scrollofData setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
}

// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [scrollofData setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [scrollofData setContentOffset:CGPointMake(0,0) animated:YES];
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
    //    return YES;
}

- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
 /*   NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
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
*/
}
- (IBAction)btnSaveClicked:(id)sender {
    
    if (tfofOldPwd.text.length<=0)
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_OLD_PASSWORD];
    }
    else
    {
        if (tfofNewPwd.text.length<=0)
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_NEW_PASSWORD];
        }
        else
        {
            if (tfofConfirmPwd.text.length<=0)
            {
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_CONFIRM_PWD];
            }
            else
            {
                if (![tfofNewPwd.text isEqualToString:tfofConfirmPwd.text])
                {
                    [SMSCountryUtils showAlertMessageWithTitle:@"" Message:MISSMATCH_PWD];
                }
                else if (tfofNewPwd.text.length <6){
                    
                      [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_VALID_PASSWORD];
                }
                else
                {
                    QticketsSingleton *singleton = [QticketsSingleton sharedInstance];
                    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
                    [conn changePasswordWither:singleton.cureentLoginUser.serverId withNewPassword:tfofNewPwd.text andOldPwd:tfofOldPwd.text];
                    [connectionsArr addObject:conn];
                }
            }
        }
    }

    

    
}

#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark 

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:CHANGE_PASSWORD]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        ChangePasswordParseOperation *cParser = [[ChangePasswordParseOperation alloc] initWithData:data delegate:self andRequestMessage:CHANGE_PASSWORD];
        [queue addOperation:cParser];
        [parseArrNew addObject:cParser];
        data = nil;
    }
}

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:CHANGE_PASSWORD]) {
        
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
    
    if ([reqMsg isEqualToString:CHANGE_PASSWORD]) {
        [self performSelectorOnMainThread:@selector(handleLoadedChangePassword:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:CHANGE_PASSWORD]) {
        [self performSelectorOnMainThread:@selector(handleParserError:) withObject:error waitUntilDone:NO];
    }
    queue = nil;
}

#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark

- (void) handleLoadedChangePassword:(NSArray *)parsedArr {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    if (parsedArr.count>0)
    {
        NSMutableDictionary *chngePwdDictionary = [parsedArr objectAtIndex:0];
        if ([[chngePwdDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[chngePwdDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            QticketsSingleton *singleton = [QticketsSingleton sharedInstance];
            singleton.cureentLoginUser.password=tfofNewPwd.text;
            [SMSCountryLocalDB updateloginUserwithUserVO:singleton.cureentLoginUser];
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:PWD_CHANGED_SUCCESSFULLY delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertV show];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[chngePwdDictionary valueForKey:ERROR_MESSAGE]];
        }
    }
}

- (void) handleParserError:(NSError *) error {
    
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
}

#pragma mark
#pragma mark AlertView Delegate
#pragma mark

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (IBAction)btnCancelClikced:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
