//
//  RegistationViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "RegistationViewController.h"
#import "Q-ticketsConstants.h"
#import "HomeViewController.h"
#import "SelectNationalityViewController.h"
#import "RegistrationVO.h"
#import "SMSCountryUtils.h"
#import "SMSCountryConnections.h"
#import "RegistrationParseOperation.h"
#import "MobileNumVerifyViewController.h"
#import "CommonParseOperation.h"
#import "CountryInfo.h"
#import "AppDelegate.h"
#import "QticketsSingleton.h"
#import "SMSCountryLocalDB.h"


@interface RegistationViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,SMSCountryConnectionDelegate,CommonParseOperationDelegate>
{
    
     IBOutlet UITextField  *tfofUserName;
     IBOutlet UITextField  *tfofUserLastName;
     IBOutlet UITextField  *tfofMobileNumber;
     IBOutlet UITextField  *tfofEmialId;
     IBOutlet UITextField  *tfofPassword;
     IBOutlet UITextField  *tfofConfirmPassword;
     IBOutlet UIImageView  *imgviewofuserName;
     IBOutlet UIImageView  *imgviewofuserLastName;
     IBOutlet UIImageView  *imgviewofMobilenum;
     IBOutlet UIImageView  *imgviewofNationality;
     IBOutlet UIImageView  *imgviewofEmail;
     IBOutlet UIImageView  *imgviewofPassword;
     IBOutlet UIImageView  *imgviewofConfirmPassword;
     UIPickerView *pickerViewforCountryCode;
     NSInteger              textFieldTag;
    IBOutlet UIScrollView *scrollofContent;
    IBOutlet UITextField   *tfofcountryCode;
    IBOutlet UIButton      *btnNationality;
    NSMutableArray                      *connectionsArr;
    NSOperationQueue                    *queue;
    NSMutableArray                      *parsersArr;
    QticketsSingleton      *singleTon;
    AppDelegate            *delegateApp;
    IBOutlet UIButton *btnAlreadyHaveAccount;
    IBOutlet UILabel  *lblbottomBlackstrip;
    IBOutlet UIImageView *imgviewofBottomBg;
    IBOutlet UIImageView *imgviewofBottomLogo;
    
    
}

@end

@implementation RegistationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegateApp    = QTicketsAppDelegate;
    singleTon = [QticketsSingleton sharedInstance];

    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }
    
    if (ViewHeight == 480) {
        
        [btnAlreadyHaveAccount setFrame:CGRectMake(btnAlreadyHaveAccount.frame.origin.x, btnAlreadyHaveAccount.frame.origin.y, btnAlreadyHaveAccount.frame.size.width, btnAlreadyHaveAccount.frame.size.height)];
         [lblbottomBlackstrip setFrame:CGRectMake(lblbottomBlackstrip.frame.origin.x, lblbottomBlackstrip.frame.origin.y+100, lblbottomBlackstrip.frame.size.width, lblbottomBlackstrip.frame.size.height)];
        [imgviewofBottomBg setFrame:CGRectMake(imgviewofBottomBg.frame.origin.x, imgviewofBottomBg.frame.origin.y+120, imgviewofBottomBg.frame.size.width, imgviewofBottomBg.frame.size.height)];
        [imgviewofBottomLogo setFrame:CGRectMake(imgviewofBottomLogo.frame.origin.x, imgviewofBottomLogo.frame.origin.y+120, imgviewofBottomLogo.frame.size.width, imgviewofBottomLogo.frame.size.height)];

    }
    
    [self setBoardersforLayers];
    [self setInitaialData];
    UISwipeGestureRecognizer *gestureSwiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(GotoLoginView:)];
    [gestureSwiperight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:gestureSwiperight];
    //tap gesture for hiding keyboard
    UITapGestureRecognizer *taptoHide           = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TaponView:)];
    [taptoHide setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:taptoHide];
    //for numeric keyboard
    pickerViewforCountryCode    = [[UIPickerView alloc]init];
    [pickerViewforCountryCode setDelegate:self];
    [pickerViewforCountryCode setDataSource:self];
    tfofcountryCode.inputView  = pickerViewforCountryCode;
    tfofcountryCode.inputAccessoryView = [self toolbarWithUIBarButtonItem];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSString *selectedCountry = [USERDEFAULTS objectForKey:@"CountrySelected"];
    if (selectedCountry == nil) {
        
        [btnNationality setTitle:@"Nationality" forState:UIControlStateNormal];
    }
    else{
    [btnNationality setTitle:selectedCountry forState:UIControlStateNormal];
    }
}
-(UIToolbar *)toolbarWithUIBarButtonItem
{
    UIToolbar *pickertoolbar = [[UIToolbar alloc] init];
    pickertoolbar.barStyle = UIBarStyleBlack;
    pickertoolbar.translucent = YES;
    pickertoolbar.tintColor = nil;
    [pickertoolbar sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneButtonClicked:)];
    [pickertoolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    return pickertoolbar;
}
-(void)doneButtonClicked:(id)sender{
    
    [tfofcountryCode resignFirstResponder];
}
-(void)setInitaialData{
    
    
    connectionsArr                    = [[NSMutableArray alloc]init];
    parsersArr                        = [[NSMutableArray alloc]init];
    queue                             = [[NSOperationQueue alloc]init];
    
    //toolbar for prev,next,done....
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneClicked:)];
    UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                                       style:UIBarButtonItemStylePlain target:self
                                                                      action:@selector(previousBtnClicked:)];
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(nextBtnClicked:)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:previousButton,nextButton,doneButton, nil]];

    tfofUserName.inputAccessoryView        = keyboardDoneButtonView;
    tfofUserLastName.inputAccessoryView    = keyboardDoneButtonView;
    tfofMobileNumber.inputAccessoryView    = keyboardDoneButtonView;
    tfofPassword.inputAccessoryView        = keyboardDoneButtonView;
    tfofEmialId.inputAccessoryView         = keyboardDoneButtonView;
    tfofConfirmPassword.inputAccessoryView = keyboardDoneButtonView;
    
    if ([SMSCountryUtils isIphone]) {
        [scrollofContent setFrame:CGRectMake(5, 66, ViewWidth-10, ViewHeight-80)];
        [scrollofContent setContentSize:CGSizeMake(ViewWidth-10, ViewHeight)];
        
    }
    else{
        [scrollofContent setFrame:CGRectMake(10, 120, ViewWidth-20, ViewHeight-130)];
        [scrollofContent setContentSize:CGSizeMake(ViewWidth-20, ViewHeight)];

    }
    
    int countryIndex = 0;
    
    NSInteger selectdTimeIndex = [pickerViewforCountryCode selectedRowInComponent:0];
    if(selectdTimeIndex!=-1){
        
        for (int k = 0; k< singleTon.arrofCountryDetails.count; k++) {
            CountryInfo *countrydetol = [singleTon.arrofCountryDetails objectAtIndex:k];
            if ([countrydetol.CountryName isEqualToString:@"Qatar"]) {
                
                countryIndex = k;
            }
            
        }
        
        
        CountryInfo *countrydet = [singleTon.arrofCountryDetails objectAtIndex:countryIndex];
        
        [pickerViewforCountryCode selectRow:countryIndex inComponent:0 animated:YES];
        
        [tfofcountryCode setText:[NSString stringWithFormat:@"%@",countrydet.CountryPrefix]];
    }

}
-(void)setBoardersforLayers{
    
    [imgviewofuserName.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofuserName.layer setBorderWidth: 1.0];
    
    [imgviewofuserLastName.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofuserLastName.layer setBorderWidth: 1.0];

    [imgviewofMobilenum.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofMobilenum.layer setBorderWidth: 1.0];
    
    [imgviewofNationality.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofNationality.layer setBorderWidth: 1.0];
    
    [imgviewofEmail.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofEmail.layer setBorderWidth: 1.0];
    
    [imgviewofPassword.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofPassword.layer setBorderWidth: 1.0];
    
    [imgviewofConfirmPassword.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofConfirmPassword.layer setBorderWidth: 1.0];
}


-(void)nextBtnClicked:(id)sender{
    
    if (textFieldTag == tfofUserName.tag) {
        
        [tfofUserName     resignFirstResponder];
        [tfofUserLastName becomeFirstResponder];
        
    }
    else if (textFieldTag == tfofUserLastName.tag){
        
        [tfofUserLastName resignFirstResponder];
        [tfofMobileNumber becomeFirstResponder];
        
    }
    else if (textFieldTag == tfofMobileNumber.tag){
        
        [tfofMobileNumber  resignFirstResponder];
        [tfofEmialId  becomeFirstResponder];
    }
    else if (textFieldTag == tfofEmialId.tag){
        [tfofEmialId       resignFirstResponder];
        [tfofPassword      becomeFirstResponder];
    }
    else if (textFieldTag == tfofPassword.tag){
        [tfofPassword       resignFirstResponder];
        [tfofConfirmPassword becomeFirstResponder];
    }
    else if (textFieldTag == tfofConfirmPassword.tag){
        [scrollofContent setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofConfirmPassword resignFirstResponder];
    }
    
}

-(void)previousBtnClicked:(id)sender{
    
    if (textFieldTag == tfofUserName.tag) {
        //we need to set scrolloffset
        [scrollofContent setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofUserLastName resignFirstResponder];
    }
    else if (textFieldTag == tfofUserLastName.tag){
        [tfofUserLastName resignFirstResponder];
        [tfofUserName becomeFirstResponder];
    }
    else if (textFieldTag == tfofMobileNumber.tag){
        [tfofMobileNumber resignFirstResponder];
        [tfofUserLastName     becomeFirstResponder];
    }
    else if (textFieldTag == tfofEmialId.tag){
        [tfofEmialId      resignFirstResponder];
        [tfofMobileNumber becomeFirstResponder];
    }
    else if (textFieldTag == tfofPassword.tag){
        [tfofPassword    resignFirstResponder];
        [tfofEmialId     becomeFirstResponder];
    }
    else if (textFieldTag == tfofConfirmPassword.tag){
        [tfofConfirmPassword resignFirstResponder];
        [tfofPassword        becomeFirstResponder];
        [scrollofContent setContentOffset:CGPointMake(0,0) animated:YES];
    }
}
-(void)doneClicked:(id)sender{
    
    if ([tfofUserName becomeFirstResponder] == YES) {
        [tfofUserName resignFirstResponder];
    }
    else if ([tfofUserLastName becomeFirstResponder] == YES){
        [tfofUserLastName resignFirstResponder];
    }
   else if ([tfofConfirmPassword becomeFirstResponder] == YES) {
        [tfofConfirmPassword resignFirstResponder];
    }
  else  if ([tfofEmialId becomeFirstResponder] == YES) {
        [tfofEmialId resignFirstResponder];
    }
  else  if ([tfofMobileNumber becomeFirstResponder] == YES) {
        [tfofMobileNumber resignFirstResponder];
    }
    else {
        [tfofPassword resignFirstResponder];
    }
    [scrollofContent setContentOffset:CGPointMake(0,0) animated:YES];
}

-(void)cancelNumberPad{
    
    [tfofMobileNumber resignFirstResponder];
    tfofMobileNumber.text = @"";
}

-(void)doneWithNumberPad{
    
    [tfofMobileNumber resignFirstResponder];
}



#pragma mark PickerView Datasource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return singleTon.arrofCountryDetails.count;
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
    CountryInfo *countryinfo = [singleTon.arrofCountryDetails objectAtIndex:row];
    NSString *strCountyPrefix = [NSString stringWithFormat:@"+%@-%@",countryinfo.CountryPrefix,countryinfo.CountryName];
    return strCountyPrefix;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    CountryInfo *countryinfo = [singleTon.arrofCountryDetails objectAtIndex:row];
    NSString *strCountyPrefix = [NSString stringWithFormat:@"+%@",countryinfo.CountryPrefix];
   tfofcountryCode.text=strCountyPrefix;
    
}



-(void)TaponView:(UITapGestureRecognizer *)gesture{
    
    if ([tfofUserName becomeFirstResponder] == YES) {
        
        [tfofUserName resignFirstResponder];        
    }
    if ([tfofUserLastName becomeFirstResponder]==YES) {
        
        [tfofUserLastName resignFirstResponder];
    }
    if ([tfofConfirmPassword becomeFirstResponder] == YES) {
        
        [tfofConfirmPassword resignFirstResponder];
    }
    if ([tfofEmialId becomeFirstResponder] == YES) {
        
        [tfofEmialId resignFirstResponder];
    }
    if ([tfofMobileNumber becomeFirstResponder] == YES) {
        
        [tfofMobileNumber resignFirstResponder];
    }
    if ([tfofPassword becomeFirstResponder] == YES) {
        
        [tfofPassword resignFirstResponder];
    }
    
}



-(void)GotoLoginView:(UISwipeGestureRecognizer *)swipeges{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark -- textfield delegate methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
        return YES;
    
}
// called when textField start editting.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textFieldTag=textField.tag;
    
    [scrollofContent setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];

}

// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [scrollofContent setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [scrollofContent setContentOffset:CGPointMake(0,0) animated:YES];
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 6) {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_NUMERICS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnNationalityClicked:(id)sender {
    
    SelectNationalityViewController *selectnation = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"SelectNationalityViewController"];
    [self.navigationController pushViewController:selectnation animated:YES];
    
}
- (IBAction)btnRegisterClicked:(id)sender {

    
    RegistrationVO   *regVO = [[RegistrationVO alloc]init];
    //checking whether data is entered in textfields and making registration service call
    if (tfofUserName.text.length<=0)
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_FIRSTNAME];
    }
    else
    {
        regVO.firstName=tfofUserName.text;
        if (tfofUserLastName.text.length<=0)
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_LASTNAME];
        }
        else
        {
            regVO.lastName=tfofUserLastName.text;
            if (tfofEmialId.text.length<=0)
            {
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_EMAILID];
            }
            else if (![SMSCountryUtils validateEmail:[tfofEmialId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
                
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_VALID_EMAILID];
            }
            else
            {
                regVO.mailId=tfofEmialId.text;
                if (tfofPassword.text.length<=0)
                {
                    [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_PASSWORD];
                }
                
                else
                {
                    if (tfofConfirmPassword.text.length<=0)
                    {
                        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_CONFIRM_PASSWORD];
                    }
                    else
                    {
                        if (![tfofPassword.text isEqualToString:tfofConfirmPassword.text])
                        {
                            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:MISSMATCH_OF_PASSWORDS];
                        }
                        else if (tfofPassword.text.length <6){
                            
                             [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_VALID_PASSWORD];
                        }
                        else
                        {
//                            
                            if ([btnNationality.titleLabel.text isEqualToString:@"Nationality"]) {
                                
                                [btnNationality setTitle:@" " forState:UIControlStateNormal];
                                
//                                 [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SELECT_NATIONALITY];
                                
                            }
//                            else{
                            
                            regVO.nationality = btnNationality.titleLabel.text;
                            regVO.password=tfofPassword.text;
                            regVO.confirmPassword=tfofConfirmPassword.text;
                            if (tfofMobileNumber.text.length<=0)
                            {
                                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_PHONE_NUMBER];
                            }
                            else if (tfofMobileNumber.text.length < 8){
                                
                                 [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_VALID_PHONE_NUMBER];
                                
                            }
                            else
                            {
                                
                                if (tfofcountryCode.text.length <=0) {
                                    
                                    [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SELECT_PHONE_PREFIX];
                                }
                                else{
                                
                                NSString *phnPrefx = [tfofcountryCode.text stringByReplacingOccurrencesOfString:@"+"withString:@""];
                                regVO.phonePrefix=phnPrefx;
                                regVO.phone=tfofMobileNumber.text;
                                regVO.fid  = @"";
                                [self userRegistrationWithRegistrationVO:regVO];
                                }
                            }
//                            }
                        }
                    }
                }
            }
            
        }
    }
    
}




#pragma mark
#pragma mark SMSCountry Service Calls
#pragma mark

-(void)userRegistrationWithRegistrationVO:(RegistrationVO *)registerVO
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn userRegistrationWithUserVO:registerVO withDeviceToken:delegateApp.strDeviceToken];
    [connectionsArr addObject:conn];
}


#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:REGISTRATION]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        RegistrationParseOperation *rParser = [[RegistrationParseOperation alloc] initWithData:data delegate:self andRequestMessage:REGISTRATION];
        [queue addOperation:rParser];
        [parsersArr addObject:rParser];
        data = nil;
    }
}

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
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
}

#pragma mark
#pragma mark CommonParserOperation Delegate methods
#pragma mark

- (void)didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr {
    
    if ([reqMsg isEqualToString:REGISTRATION]) {
        [self performSelectorOnMainThread:@selector(handleLoadedRegistration:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:REGISTRATION]) {
        [self performSelectorOnMainThread:@selector(handleParserError:) withObject:error waitUntilDone:NO];
    }
    queue = nil;
}
#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark

- (void) handleLoadedRegistration:(NSArray *)parsedArr {
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    // if parsed Arr count is greater then zero. Now we can insert the user into localdb
    if (parsedArr.count > 0)
    {
        NSMutableDictionary *registerDictionary = [parsedArr objectAtIndex:0];
        if ([[registerDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[registerDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            UserVO *uservo             = [registerDictionary valueForKey:USER_OBJECT];
            uservo.password = tfofPassword.text;
            uservo.status = 1;
            
            
            [SMSCountryLocalDB deleteAllUsers];
            
            
            
            if ([SMSCountryLocalDB isUserExists:uservo.serverId])
            {
                [SMSCountryLocalDB updateloginUserwithUserVO:uservo];
            }
            else
            {
                [SMSCountryLocalDB insertUser:uservo];
            }
            singleTon.cureentLoginUser=uservo;
            
            MobileNumVerifyViewController *verifyVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"MobileNumVerifyViewController"];
            NSString *tempPrefx        = [tfofcountryCode.text stringByReplacingOccurrencesOfString:@"+"withString:@""];
            tempPrefx = [tempPrefx stringByReplacingOccurrencesOfString:@" " withString:@""];
            verifyVC.phnePrefix        = tempPrefx;
            verifyVC.phoneNumber       = tfofMobileNumber.text;
            verifyVC.userServerID      = uservo.serverId;
            verifyVC.isfromRegistation = YES;
            [self.navigationController pushViewController:verifyVC animated:YES];
            
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
- (void) handleParserError:(NSError *) error {
    
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
}





- (IBAction)btnCancelClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnAlreadyHaveAccountClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnBackClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
