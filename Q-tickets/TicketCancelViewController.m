//
//  TicketCancelViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 15/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "TicketCancelViewController.h"
#import "Q-ticketsConstants.h"
#import "QticketsSingleton.h"
#import "CommonParseOperation.h"
#import "CancelBookingParseOperation.h"
#import "cancelBookingStatusParseOperation.h"
#import "SMSCountryUtils.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "CountryInfo.h"

@interface TicketCancelViewController ()<CommonParseOperationDelegate,UITextFieldDelegate,SMSCountryConnectionDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    
    IBOutlet UIView       *viewofInfo;
    IBOutlet UIScrollView *scrollviewofInfo;
    IBOutlet UIImageView  *imgviewforreservationcode;
    IBOutlet UIImageView  *imgviewforEmialid;
    IBOutlet UIImageView  *imgviewforPhoneNo;
    IBOutlet UITextField  *tfofReservationCode;
    IBOutlet UITextField  *tfofEmailid;
    IBOutlet UITextField  *tfofMobileNumber;
    IBOutlet UIView       *viewforAlertView;
    IBOutlet UILabel      *lblofAlertviewmessage;
    IBOutlet UITextField  *tfCountryCode;
    
    NSInteger             textFieldTag;
    NSMutableArray         *connectionsArr;
    NSMutableArray         *parseArrNew;
    NSOperationQueue       *queue;
    UIPickerView           *countryCodePicker;
    NSString               *strStatusis;
    NSString               *strResponseConfirCode;

    BOOL                   havetoCallforCancel;
    SMSCountryUtils        *smscUtilities;
    NSTimer                *timer1,*timer2;
    int nooftimes;
    AppDelegate          *delegateApp;
    QticketsSingleton    *singleton;

}
@end

@implementation TicketCancelViewController
@synthesize strReservationCode;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    delegateApp = QTicketsAppDelegate;
    
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }
    
    
    connectionsArr  = [[NSMutableArray alloc] init];
    parseArrNew        = [[NSMutableArray alloc] init];
    queue           = [[NSOperationQueue alloc] init];
    smscUtilities   = [[SMSCountryUtils alloc] init];
    singleton       = [QticketsSingleton sharedInstance];

    havetoCallforCancel = NO;
    nooftimes= 0;
    
    [viewforAlertView setHidden:YES];
    
    

    
    
    [imgviewforreservationcode.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewforreservationcode.layer setBorderWidth: 1.0];
    
    [imgviewforEmialid.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewforEmialid.layer setBorderWidth: 1.0];
    
    [imgviewforPhoneNo.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewforPhoneNo.layer setBorderWidth: 1.0];

    
    countryCodePicker = [[UIPickerView alloc]init];
    countryCodePicker.delegate=self;
    countryCodePicker.dataSource=self;
    [countryCodePicker sizeToFit];
    countryCodePicker.showsSelectionIndicator=YES;

    
    tfCountryCode.inputView=countryCodePicker;
    tfCountryCode.inputAccessoryView=[self toolbarWithUIBarButtonItemCountryCode];

    
    NSInteger selectdTimeIndex = [countryCodePicker selectedRowInComponent:0];
    if(selectdTimeIndex!=-1){
        CountryInfo *countrydet = [singleton.arrofCountryDetails objectAtIndex:13];
        
        [countryCodePicker selectRow:13 inComponent:0 animated:YES];
        
        [tfCountryCode setText:[NSString stringWithFormat:@"%@",countrydet.CountryPrefix]];
    }

    if (singleton.cureentLoginUser.status == 1) {
        
        tfofEmailid.text = singleton.cureentLoginUser.emailId;
        tfCountryCode.text = singleton.cureentLoginUser.prefix;
        tfofMobileNumber.text = singleton.cureentLoginUser.phoneNumber;
        
        
    }
    
    if (![self.strReservationCode isEqualToString:@""]) {
        
        tfofReservationCode.text = self.strReservationCode;
    }
   
    strStatusis = @"";
    
    strResponseConfirCode = self.strReservationCode;
    
    
    [self SetToolBar];
    
    
    if (![SMSCountryUtils isIphone]) {
        [scrollviewofInfo setContentSize:CGSizeMake(728, ViewHeight-250)];

    }

    
}

-(UIToolbar *)toolbarWithUIBarButtonItemCountryCode
{
    UIToolbar *pickertoolbar = [[UIToolbar alloc] init];
    pickertoolbar.barStyle = UIBarStyleBlack;
    pickertoolbar.translucent = YES;
    pickertoolbar.tintColor = nil;
    [pickertoolbar sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneButtonClickedCountryCode:)];
    [pickertoolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    
    return pickertoolbar;
}
-(void)doneButtonClickedCountryCode:(id)sender{
    
    [tfCountryCode resignFirstResponder];
    
    
}

-(void)SetToolBar{
    
    UIToolbar* keyboardDoneButtonView  = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle    = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor   = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton        = [[UIBarButtonItem alloc] initWithTitle:@"Done"style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
    UIBarButtonItem* previousButton    = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previousBtnClicked:)];
    UIBarButtonItem* nextButton        = [[UIBarButtonItem alloc] initWithTitle:@"Next"style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:previousButton,nextButton,doneButton, nil]];
    
    tfofReservationCode.inputAccessoryView=keyboardDoneButtonView;
    tfofMobileNumber.inputAccessoryView=keyboardDoneButtonView;
    tfofEmailid.inputAccessoryView=keyboardDoneButtonView;
    
}
-(void)nextBtnClicked:(id)sender
{
    if (textFieldTag == tfofReservationCode.tag)
    {
        [tfofReservationCode resignFirstResponder];
        [tfofEmailid becomeFirstResponder];
    }
    else if (textFieldTag == tfofEmailid.tag)
    {
        [tfofEmailid resignFirstResponder];
        [tfofMobileNumber becomeFirstResponder];
    }
    else if (textFieldTag == tfofMobileNumber.tag)
    {
        [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofMobileNumber resignFirstResponder];
    }
}

-(void)previousBtnClicked:(id)sender
{
    if (textFieldTag == tfofReservationCode.tag)
    {
        [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofReservationCode resignFirstResponder];
    }
    else if (textFieldTag == tfofEmailid.tag)
    {
        [tfofEmailid resignFirstResponder];
        [tfofReservationCode becomeFirstResponder];
    }
    else if (textFieldTag == tfofMobileNumber.tag)
    {
        [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofMobileNumber resignFirstResponder];
        [tfofEmailid becomeFirstResponder];
    }
    
}
- (void)doneClicked:(id)sender {
    
    [[self.view viewWithTag:tfofReservationCode.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofEmailid.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofMobileNumber.tag] resignFirstResponder];
    [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
       return YES;
    
}
// called when textField start editting.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textFieldTag=textField.tag;
    
    [scrollviewofInfo setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
}

// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [scrollviewofInfo setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
    //    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 26 || textField.tag == 28) {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_NUMERICS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else{
        return YES;
    }
}


#pragma mark PickerView Datasource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return singleton.arrofCountryDetails.count;
}
#pragma mark
#pragma mark PickerView Delegate Methods
#pragma mark

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CountryInfo *countryinfo = [singleton.arrofCountryDetails objectAtIndex:row];
    NSString *strCountyPrefix = [NSString stringWithFormat:@"+%@-%@",countryinfo.CountryPrefix,countryinfo.CountryName];
    
    return strCountyPrefix;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CountryInfo *countryinfo = [singleton.arrofCountryDetails objectAtIndex:row];
    NSString *strCountyPrefix = [NSString stringWithFormat:@"+%@",countryinfo.CountryPrefix];
    tfCountryCode.text=strCountyPrefix;

    
}




- (IBAction)btnCancelTicketclicked:(id)sender {
    
    
    
    if (tfofReservationCode.text.length<=0)
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_RESERVATION_CODE];
    }
    else if (tfofReservationCode.text.length != 8){
        
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_VALID_RESERVATION_CODE];
        
    }
    else
    {
        if (tfofEmailid.text.length<=0)
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_EMAIL_ID];
        }
        else if (![SMSCountryUtils validateEmail:[tfofEmailid.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
            
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_VALID_EMAILID];
        }
        else
        {
            if (tfofMobileNumber.text.length<=0)
            {
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_PHONE_NUMBER];
            }
            else if (tfofMobileNumber.text.length < 8){
                
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_VALID_PHONE_NUMBER];
                
            }
            else
            {
                if (tfCountryCode.text.length<=0)
                {
                    [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SELECT_COUNTRY_CODE];
                }
                else
                {
                    
                   
                    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
                    if (singleton.cureentLoginUser.status == 1) {
                        
                         [conn cancelBookedTicketwithReservationCode:tfofReservationCode.text withUserId:singleton.cureentLoginUser.serverId withUserEmail:tfofEmailid.text withPrefix:tfCountryCode.text withPhonenumber:tfofMobileNumber.text withCheckStatus:@"0" withAppsource:@"3"];
                    }
                    else{
                    [conn cancelBookedTicketwithReservationCode:tfofReservationCode.text withUserId:@"0" withUserEmail:tfofEmailid.text withPrefix:tfCountryCode.text withPhonenumber:tfofMobileNumber.text withCheckStatus:@"0" withAppsource:@"3"];
                    }
                    [connectionsArr addObject:conn];
                }
            }
        }
    }
 
    
}

- (IBAction)btnCancelClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnAlertYesClicked:(id)sender {
    
  

    if ([strStatusis isEqualToString:@"128"]) {
        
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
      
        if (singleton.cureentLoginUser.status == 1) {
            
            [conn cancelBookedTicketwithReservationCode:tfofReservationCode.text withUserId:singleton.cureentLoginUser.serverId withUserEmail:tfofEmailid.text withPrefix:tfCountryCode.text withPhonenumber:tfofMobileNumber.text withCheckStatus:@"1" withAppsource:@"3"];
        }
        else{
        
    [conn cancelBookedTicketwithReservationCode:tfofReservationCode.text withUserId:@"0" withUserEmail:tfofEmailid.text withPrefix:tfCountryCode.text withPhonenumber:tfofMobileNumber.text withCheckStatus:@"1" withAppsource:@"3"];
        }
    [connectionsArr addObject:conn];
    

        
    }

    else{
        
        [viewforAlertView setHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
}


-(void)CheckToCallforCanceling{
    
    if (havetoCallforCancel == NO) {
        
        havetoCallforCancel = YES;
        
    }
    else{
        
        havetoCallforCancel = NO;
        
    }
    
    
}


-(void)CallforCheckCancel{
    
    nooftimes ++ ;
    
    if (nooftimes >6) {
        
        if (timer1 != nil) {
            [timer1 invalidate];
            timer1 = nil;
        }
        if (timer2 != nil) {
            [timer2 invalidate];
            timer2 = nil;
        }

        
        
        [smscUtilities hideLoader];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Proceesing" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert setTag:99];
        [alert show];
        
    }
    else{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn checkCancelBookingStatuswithConfirmationCode:strResponseConfirCode];
    [connectionsArr addObject:conn];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if (timer1 != nil) {
            [timer1 invalidate];
            timer1 = nil;
        }
        if (timer2 != nil) {
            [timer2 invalidate];
            timer2 = nil;
        }

         [smscUtilities hideLoader];
        [self.navigationController popViewControllerAnimated:YES];
        
           }
    else if (alertView.tag == 789){
        if (timer1 != nil) {
            [timer1 invalidate];
            timer1 = nil;
        }
        if (timer2 != nil) {
            [timer2 invalidate];
            timer2 = nil;
        }

         [smscUtilities hideLoader];
               [self.navigationController popViewControllerAnimated:YES];

    }
}

- (IBAction)btnAlertNoClicked:(id)sender {
    
    if (timer1 != nil) {
        [timer1 invalidate];
        timer1 = nil;
    }
    if (timer2 != nil) {
        [timer2 invalidate];
        timer2 = nil;
    }

    [viewforAlertView setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnBackClicked:(id)sender{
    
    if (timer1 != nil) {
        [timer1 invalidate];
        timer1 = nil;
    }
    if (timer2 != nil) {
        [timer2 invalidate];
        timer2 = nil;
    }

    
    [self.navigationController popViewControllerAnimated:YES];
    
}




#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:CANCEL_BOOKING]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        CancelBookingParseOperation *cParser = [[CancelBookingParseOperation alloc] initWithData:data delegate:self andRequestMessage:CANCEL_BOOKING];
        [queue addOperation:cParser];
        [parseArrNew addObject:cParser];
        data = nil;
    }
    
    if ([reqMessage isEqualToString:CANCEL_BOOKING_CHECKSTATUS]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        cancelBookingStatusParseOperation *cParser = [[cancelBookingStatusParseOperation alloc] initWithData:data delegate:self andRequestMessage:CANCEL_BOOKING_CHECKSTATUS];
        [queue addOperation:cParser];
        [parseArrNew addObject:cParser];
        data = nil;
    }
}

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:CANCEL_BOOKING]) {
        
        if ([error.description isEqualToString:INTERNET_CONNECTION_OFFLINE])
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:CHECK_INTERNET_CONNECTION];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:error.description];
        }
    }
    if ([reqMessage isEqualToString:CANCEL_BOOKING_CHECKSTATUS]) {
        
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
    
    if ([reqMsg isEqualToString:CANCEL_BOOKING]) {
        [self performSelectorOnMainThread:@selector(handleBookingCancel1Response:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
    if ([reqMsg isEqualToString:CANCEL_BOOKING_CHECKSTATUS]) {
        [self performSelectorOnMainThread:@selector(handleBookingCancel23Response:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:CANCEL_BOOKING]) {
        [self performSelectorOnMainThread:@selector(handleCancelingParserError:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:CANCEL_BOOKING_CHECKSTATUS]) {
        [self performSelectorOnMainThread:@selector(handleCanceling23ParserError:) withObject:error waitUntilDone:NO];
    }
//
    queue = nil;
}

#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark

- (void) handleBookingCancel1Response:(NSArray *)parsedArr {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    if (parsedArr.count>0)
    {
        NSMutableDictionary *cancelBookingDictionary = [parsedArr objectAtIndex:0];
        if ([[cancelBookingDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[cancelBookingDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            
                strResponseConfirCode  = [cancelBookingDictionary objectForKey:CANCEL_BOOKING_CONFIRMATION_CODE];

            if ([[cancelBookingDictionary valueForKey:CANCEL_BOOKING_ERRORCODE] isEqualToString:@"127"]) {
                
                
                 [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[cancelBookingDictionary valueForKey:CANCEL_BOOKING_MESSAGE]];
                
            }
            else if ([[cancelBookingDictionary valueForKey:CANCEL_BOOKING_ERRORCODE] isEqualToString:@"128"]){
                
                strStatusis = [cancelBookingDictionary valueForKey:CANCEL_BOOKING_ERRORCODE];
                
                [lblofAlertviewmessage setText:[NSString stringWithFormat:@"%@",[cancelBookingDictionary objectForKey:CANCEL_BOOKING_MESSAGE]]];
                
                [viewforAlertView setHidden:NO];

                
            }
            else if ([[cancelBookingDictionary valueForKey:CANCEL_BOOKING_ERRORCODE] isEqualToString:@"129"])
            
            {
             strStatusis = [cancelBookingDictionary valueForKey:CANCEL_BOOKING_ERRORCODE];
                
//
                [viewforAlertView setHidden:YES];

                
                NSString *strCheckInterval = [cancelBookingDictionary objectForKey:CANCEL_BOOKING_CHECKINTERVAL];
                NSString *strCheckTime     = [cancelBookingDictionary objectForKey:CANCEL_BOOKING_CHECKTIME];
                
               
                if (havetoCallforCancel == NO) {
             
                    
                    
                    
                  timer1 =   [NSTimer scheduledTimerWithTimeInterval:[strCheckInterval doubleValue] target:self selector:@selector(CallforCheckCancel) userInfo:nil repeats:YES];
                    [smscUtilities showLoaderWithTitle:@"" andSubTitle:TICKET_CANCELING];


                }
                

             timer2 =    [NSTimer scheduledTimerWithTimeInterval:[strCheckTime doubleValue] target:self selector:@selector(CheckToCallforCanceling) userInfo:nil repeats:NO];


            }
        
        }
        else if ([[cancelBookingDictionary valueForKey:STATUS] isEqualToString:@"false"] || [[cancelBookingDictionary valueForKey:STATUS] isEqualToString:@"False"]){
            
            if ([[cancelBookingDictionary objectForKey:CANCEL_BOOKING_ERRORCODE] isEqualToString:@"127" ]) {
                
                if (timer1 != nil) {
                    [timer1 invalidate];
                    timer1 = nil;
                }
                if (timer2 != nil) {
                    [timer2 invalidate];
                    timer2 = nil;
                }
                
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[cancelBookingDictionary objectForKey:CANCEL_BOOKING_MESSAGE] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert setTag:99];if (timer1 != nil) {
                    [timer1 invalidate];
                    timer1 = nil;
                }
                if (timer2 != nil) {
                    [timer2 invalidate];
                    timer2 = nil;
                }

                [alert show];
                
               
            }
            
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[cancelBookingDictionary valueForKey:CANCEL_BOOKING_MESSAGE]];
        }
    }
}

- (void) handleCancelingParserError:(NSError *) error {
    
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
}




-(void)handleBookingCancel23Response:(NSArray *)parsedArr{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    if (parsedArr.count>0)
    {
        NSMutableDictionary *cancelBookingDictionary = [parsedArr objectAtIndex:0];
        if ([[cancelBookingDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[cancelBookingDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            
            if ([[cancelBookingDictionary objectForKey:CANCEL_BOOKING_ERRORCODE] isEqualToString:@"131"]) {
                
                
                if (timer1 != nil) {
                    [timer1 invalidate];
                    timer1 = nil;
                }
                if (timer2 != nil) {
                    [timer2 invalidate];
                    timer2 = nil;
                }

                
                [smscUtilities hideLoader];
                
                UIAlertView *alerviewSuc = [[UIAlertView alloc] initWithTitle:@"Success" message:[cancelBookingDictionary objectForKey:CANCEL_BOOKING_MESSAGE] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alerviewSuc.tag = 789;
                
                //remove local notification also
                NSData *data= [[NSUserDefaults standardUserDefaults] objectForKey:[NSString   stringWithFormat:@"%@",self.strReservationCode]];
                UILocalNotification *localNotif = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@",self.strReservationCode]];
                singleton.nooflocalNotifications = singleton.nooflocalNotifications-1;
                
                [alerviewSuc show];
                
                     }
    
            
            
        }
        else if ([[cancelBookingDictionary valueForKey:STATUS] isEqualToString:@"False"] || [[cancelBookingDictionary valueForKey:STATUS] isEqualToString:@"false"]){
            
            
            if (timer1 != nil) {
                [timer1 invalidate];
                timer1 = nil;
            }
            if (timer2 != nil) {
                [timer2 invalidate];
                timer2 = nil;
            }

            
        }
        else
        {
            
            if (timer1 != nil) {
                [timer1 invalidate];
                timer1 = nil;
            }
            if (timer2 != nil) {
                [timer2 invalidate];
                timer2 = nil;
            }

            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[cancelBookingDictionary valueForKey:CANCEL_BOOKING_MESSAGE]];
        }
    }
    
}


-(void)handleCanceling23ParserError:(NSError *)error{
    
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
    
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
