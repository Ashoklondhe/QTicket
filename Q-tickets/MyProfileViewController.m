//
//  MyProfileViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "MyProfileViewController.h"
#import "Q-ticketsConstants.h"
#import "QticketsSingleton.h"
#import "UserVO.h"
#import "SelectNationalityViewController.h"
#import "SMSCountryConnections.h"
#import "SMSCountryLocalDB.h"
#import "SMSCountryUtils.h"
#import "ProfileUpdationParseOperation.h"
#import "CommonParseOperation.h"
#import "CountryInfo.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface MyProfileViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,SMSCountryConnectionDelegate,CommonParseOperationDelegate>{
    
    
     IBOutlet UIImageView *imgviewofnamgbg;
     IBOutlet UITextField *tfofUsername;
     IBOutlet UIImageView *imgviewofmobilebg;
     IBOutlet UITextField *tfofMobilenumber;
     IBOutlet UIImageView *imgviewofNationalitybg;
     IBOutlet UIButton    *btnofNationality;
     IBOutlet UIImageView *imgviewofEmailbg;
     IBOutlet UITextField *tfofEmailid;
     QticketsSingleton    *singleTon;
     UIPickerView         *countryCodePicker;
     IBOutlet UITextField   *tfofcountryCode;
     NSInteger              textFieldTag;
     IBOutlet UIScrollView *scrollviewofInfo;
     BOOL                  isUpdate;
    
    NSMutableArray         *connectionsArr;
    NSMutableArray         *parseArrNew;
    NSOperationQueue       *queue;
    AppDelegate            *delegateApp;
   

}

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }
    
    delegateApp     = QTicketsAppDelegate;
    connectionsArr  = [[NSMutableArray alloc] init];
    parseArrNew        = [[NSMutableArray alloc] init];
    queue           = [[NSOperationQueue alloc] init];

    
    isUpdate = NO;
    
    if ([SMSCountryUtils isIphone]) {
        [scrollviewofInfo setContentSize:CGSizeMake(ViewWidth-20, ViewHeight-150)];
    }
    else{
        [scrollviewofInfo setContentSize:CGSizeMake(ViewWidth-40, ViewHeight-200)];
    }
    
//    int countryIndex = 0;
//    
//    NSInteger selectdTimeIndex = [countryCodePicker selectedRowInComponent:0];
//    if(selectdTimeIndex!=-1){
//        
//        
//        for (int k = 0; k< singleTon.arrofCountryDetails.count; k++) {
//            CountryInfo *countrydetol = [singleTon.arrofCountryDetails objectAtIndex:k];
//            if ([countrydetol.CountryName isEqualToString:@"Qatar"]) {
//                
//                countryIndex = k;
//            }
//            
//        }
//        
//        
//        
//        CountryInfo *countrydet = [singleTon.arrofCountryDetails objectAtIndex:countryIndex];
//        
//        [countryCodePicker selectRow:countryIndex inComponent:0 animated:YES];
//        
//        [tfofcountryCode setText:[NSString stringWithFormat:@"%@",countrydet.CountryPrefix]];
//    }

    
    
    

    [self initialSetup];
    

}

-(UIToolbar *)toolbarWithUIBarButtonItem12
{
    UIToolbar *pickertoolbar = [[UIToolbar alloc] init];
    pickertoolbar.barStyle = UIBarStyleBlack;
    pickertoolbar.translucent = YES;
    pickertoolbar.tintColor = nil;
    [pickertoolbar sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneButtonClicked1:)];
    [pickertoolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    
    return pickertoolbar;
}
-(void)doneButtonClicked1:(id)sender{
    
    [tfofcountryCode resignFirstResponder];
    [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];

    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    if (delegateApp.fromMYPR) {
        
   
    NSString *selectedCountry = [USERDEFAULTS objectForKey:@"CountrySelected"];
    
    if (selectedCountry == nil) {
        
        [btnofNationality setTitle:@"Nationality" forState:UIControlStateNormal];
    }
    else{
        [btnofNationality setTitle:selectedCountry forState:UIControlStateNormal];
    }
    }
}



-(void)initialSetup{
    
    
    [imgviewofEmailbg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofEmailbg.layer setBorderWidth: 1.0];
    
    [imgviewofmobilebg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofmobilebg.layer setBorderWidth: 1.0];
    
    [imgviewofnamgbg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofnamgbg.layer setBorderWidth: 1.0];
    
    [imgviewofNationalitybg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofNationalitybg.layer setBorderWidth: 1.0];

    //[tfofcountryCode setUserInteractionEnabled:NO];
   // [tfofMobilenumber setUserInteractionEnabled:NO];
    //[tfofUsername setUserInteractionEnabled:NO];
    //[btnofNationality setEnabled:NO];
    
    
    countryCodePicker = [[UIPickerView alloc]init];
    countryCodePicker.delegate=self;
    countryCodePicker.dataSource=self;
    [countryCodePicker sizeToFit];
    countryCodePicker.showsSelectionIndicator=YES;
    
    tfofcountryCode.inputView=countryCodePicker;
    tfofcountryCode.inputAccessoryView=[self toolbarWithUIBarButtonItem12];

//    cntryCodesArr = [[NSMutableArray alloc]initWithObjects:@"+61",@"+973",@"+822",@"+20",@"+33",@"+49",@"+91",@"+98",@"+964",@"+353",@"+39",@"+92",@"+63",@"+974",@"+966",@"+34",@"+963",@"+66",@"+44",@"+1", nil];
    
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneClickeddetp:)];
    UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                                       style:UIBarButtonItemStylePlain target:self
                                                                      action:@selector(previousBtnClickeddetp:)];
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(nextBtnClickeddetp:)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:previousButton,nextButton,doneButton, nil]];
    
    tfofUsername.inputAccessoryView=keyboardDoneButtonView;
    tfofEmailid.inputAccessoryView=keyboardDoneButtonView;
    tfofMobilenumber.inputAccessoryView=keyboardDoneButtonView;
    
   
    
    singleTon     = [QticketsSingleton sharedInstance];
    if (singleTon.cureentLoginUser.status == 1) {
        
        UserVO *loginUser = singleTon.cureentLoginUser;
        tfofEmailid.text  = loginUser.emailId;
        tfofMobilenumber.text = loginUser.phoneNumber;
        tfofUsername.text = loginUser.userName;
        tfofcountryCode.text = [NSString stringWithFormat:@"+%@",loginUser.prefix];

        if ([loginUser.nationality isEqualToString:@"(null)"]) {
            
            [btnofNationality setTitle:@"Nationality" forState:UIControlStateNormal];
            

        }
        else{
        [btnofNationality setTitle:[NSString stringWithFormat:@"%@",loginUser.nationality] forState:UIControlStateNormal];
        
        }
        
        
    }
    
    
    
    
}



-(void)nextBtnClickeddetp:(id)sender
{
    if (textFieldTag == tfofUsername.tag)
    {
        [tfofUsername resignFirstResponder];
        [tfofMobilenumber becomeFirstResponder];
    }
    else if (textFieldTag == tfofcountryCode.tag)
    {
        [tfofcountryCode resignFirstResponder];
        [tfofMobilenumber becomeFirstResponder];
    }
    else if (textFieldTag == tfofMobilenumber.tag)
    {
        [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofMobilenumber resignFirstResponder];
        
    }
    
}

-(void)previousBtnClickeddetp:(id)sender
{
    if (textFieldTag == tfofUsername.tag)
    {
        [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofUsername resignFirstResponder];
    }
    else if (textFieldTag == tfofcountryCode.tag)
    {
        [tfofcountryCode resignFirstResponder];
        [tfofUsername becomeFirstResponder];
    }
    else if (textFieldTag == tfofMobilenumber.tag)
    {
        [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofMobilenumber resignFirstResponder];
        [tfofcountryCode becomeFirstResponder];
    }
}
- (void)doneClickeddetp:(id)sender {
    
    [[self.view viewWithTag:tfofUsername.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofMobilenumber.tag] resignFirstResponder];
    [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == tfofUsername.tag
        || textField.tag == tfofcountryCode.tag
        || textField.tag == tfofMobilenumber.tag)
    {
        
        isUpdate = YES;
    }

    return YES;
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textFieldTag=textField.tag;
    
    [scrollviewofInfo setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [scrollviewofInfo setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
        [nextResponder becomeFirstResponder];
    } else {
        [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if (textField.tag == tfofUsername.tag
        || textField.tag == tfofcountryCode.tag
        || textField.tag == tfofMobilenumber.tag)
    {
      
        isUpdate = YES;
    }
    
    if (textField.tag == 21) {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_NUMERICS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else{
        return YES;
    }

}


-(IBAction)btnNationalityClicked:(id)sender
{
    isUpdate = YES;
    SelectNationalityViewController *selectnation = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"SelectNationalityViewController"];
    delegateApp.fromMYPR = YES;
    [self.navigationController pushViewController:selectnation animated:YES];

}


- (IBAction)btnBackclicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnEditClicked:(id)sender {
    /*
    [tfofEmailid setUserInteractionEnabled:YES];
    [tfofMobilenumber setUserInteractionEnabled:YES];
    [tfofUsername setUserInteractionEnabled:YES];
    [tfofcountryCode setUserInteractionEnabled:YES];
    [btnofNationality setEnabled:YES];
    [tfofUsername becomeFirstResponder]; */
}

- (IBAction)btnSaveChangesClicked:(id)sender {
    
    if ([btnofNationality.titleLabel.text isEqualToString:@"Nationality"]) {
        
        isUpdate = YES;
        
    }
    
    
    
    
    if (isUpdate == YES) {
        
        [self UpdateMyProfile];
        [scrollviewofInfo setContentOffset:CGPointMake(0,0) animated:YES];


    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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



#pragma mark ---- api call for profile updation


-(void)UpdateMyProfile{
    
    
    if (tfofUsername.text.length<=0)
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_FIRSTNAME];
    }
    else
    {
       
         if (tfofEmailid.text.length<=0)
            {
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_EMAILID];
            }
            else if (![SMSCountryUtils validateEmail:[tfofEmailid.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
                
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_VALID_EMAILID];
            }
            else
            {
                if (tfofcountryCode.text.length <=0) {
                    
                    [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SELECT_PHONE_PREFIX];

                }
                else{
                    
                    
                    
                    if ([btnofNationality.titleLabel.text isEqualToString:@"Nationality"]) {
                        
//                         [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SELECT_NATIONALITY];
                        
                        [btnofNationality setTitle:@" " forState:UIControlStateNormal];
                        
                    }
//                    else{
                        
                        
                        QticketsSingleton *singleton = [QticketsSingleton sharedInstance];
                        SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
                        [conn updateyourProfileusingUserId:singleton.cureentLoginUser.serverId withusername:tfofUsername.text withuseremail:singleton.cureentLoginUser.emailId withPrefix:tfofcountryCode.text withPhonenumber:tfofMobilenumber.text withNationality:[NSString stringWithFormat:@"%@",btnofNationality.titleLabel.text]];
                        [connectionsArr addObject:conn];

//                    }
                    
                }
                
            }
    }


       
}

#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:USER_PROFILE_UPDATION]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        ProfileUpdationParseOperation *profileup = [[ProfileUpdationParseOperation alloc]initWithData:data delegate:self andRequestMessage:reqMessage];
        [parseArrNew addObject:profileup];
        [queue addOperation:profileup];
        data = nil;
    }
}

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:USER_PROFILE_UPDATION]) {
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
    
    if ([reqMsg isEqualToString:USER_PROFILE_UPDATION]) {
        [self performSelectorOnMainThread:@selector(handleupdateProfile:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:USER_PROFILE_UPDATION]) {
        [self performSelectorOnMainThread:@selector(handleupdateProfileError:) withObject:error waitUntilDone:NO];
    }
    queue = nil;
}
#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark

- (void) handleupdateProfile:(NSArray *)parsedArr {
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    // if parsed Arr count is greater then zero. Now we can insert the user into localdb
    if (parsedArr.count > 0)
    {
        NSMutableDictionary *profileUpdateDictionary = [parsedArr objectAtIndex:0];
        if ([[profileUpdateDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[profileUpdateDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {

            QticketsSingleton *singleton = [QticketsSingleton sharedInstance];
            singleton.cureentLoginUser.userName = [profileUpdateDictionary objectForKey:USER_PROFILE_NAME];
            singleton.cureentLoginUser.prefix = [profileUpdateDictionary objectForKey:USER_PROFILE_PREFIX];
            singleton.cureentLoginUser.phoneNumber = [profileUpdateDictionary objectForKey:USER_PROFILE_MOBILENUM];
            singleton.cureentLoginUser.nationality = [profileUpdateDictionary objectForKey:USER_PROFILE_NATIONALITY];
            singleton.cureentLoginUser.emailId  = [profileUpdateDictionary objectForKey:USER_PROFILE_EMAIL_ID];
            
            if ([[profileUpdateDictionary objectForKey:USER_PROFILE_IS_NUM_VERIFY] isEqualToString:@"1"]) {
                [singleton.cureentLoginUser.verify isEqualToString:@"True"];
            }
            else{
                
                [singleton.cureentLoginUser.verify isEqualToString:@"False"];
            }
            
            [SMSCountryLocalDB updateloginUserwithUserVO:singleton.cureentLoginUser];

            [tfofcountryCode setUserInteractionEnabled:NO];
            [tfofMobilenumber setUserInteractionEnabled:NO];
            [tfofUsername setUserInteractionEnabled:NO];
            [btnofNationality setEnabled:NO];
            [self.navigationController popViewControllerAnimated:YES];
            

            
        }
        else   //Based on error code data will be displayed
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[profileUpdateDictionary valueForKey:ERROR_MESSAGE]];
        }
    }
    
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:RESPONSE Message:SERVER_ERROR];
    }
    
}
- (void) handleupdateProfileError:(NSError *) error {
    
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
