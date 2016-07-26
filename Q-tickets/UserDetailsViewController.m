//
//  UserDetailsViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "VoucherTableViewCell.h"
#import "PaymentDetailsViewController.h"
#import "Q-ticketsConstants.h"
#import "EGOImageView.h"
#import "AppDelegate.h"
#import "SMSCountryConnections.h"
#import "SMSCountryLocalDB.h"
#import "SMSCountryUtils.h"
#import "CommonParseOperation.h"
#import "QticketsSingleton.h"
#import "MarqueeLabel.h"

#import "SendLockRequestParseOpeartion.h"
#import "LockConformationParseOperation.h"
#import "CancelRequestParseOpeartion.h"
#import "CheckVocuherValidityParseOperation.h"
#import "TandCViewController.h"
#import "TicketConfirmViewController.h"
#import "TermsAndConditionsParseOperation.h"
#import "EventBlockSeatsParseOperation.h"
#import "UserVoucherParseOperation.h"
#import "CountryInfo.h"
#import "WebViewController.h"
#import "BookingViewController.h"




@interface UserDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SMSCountryConnectionDelegate,CommonParseOperationDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>{
    
     IBOutlet UILabel      *lblofViewTitle;
   
    //for movie details
     IBOutlet UIView       *viewofMovieDetails;
     IBOutlet EGOImageView *imgforMovie;
     IBOutlet MarqueeLabel  *lblMoviebnamewithRating;
     IBOutlet MarqueeLabel  *lbldateOfmovie;
     IBOutlet UILabel      *lbltimeofMovie;
     IBOutlet MarqueeLabel  *lblplaceofMovie;
     IBOutlet MarqueeLabel *lblscrennOfmovie;

     //for seat deatails
     IBOutlet UIView       *viewofSeatInfo;
     IBOutlet UILabel      *lblTicketPriceValue;
     IBOutlet UILabel      *lblofServieChargeValue;
     IBOutlet UILabel      *lblofFinalTotalValue;
    
    //for uderdetails
    IBOutlet UIScrollView  *scrollofUserDetails;
    IBOutlet UIImageView   *imgviewofNamebg;
    IBOutlet UITextField   *tfofNameofUser;
    IBOutlet UIImageView   *imgviewofMobilebg;
    IBOutlet UITextField   *tfofMobileNumber;
    IBOutlet UIImageView   *imgviewofEmailid;
    IBOutlet UITextField   *tfofUserEmail;
    IBOutlet UIButton      *btnforEvoucherEnable;
    IBOutlet UITextField   *tfofVoucherValue;
    IBOutlet UIButton      *btnApplyVoucher;
    
    //for payment details
     IBOutlet UIView       *viewforPayment;
     IBOutlet UIButton     *btnProceedtoPayment;
     IBOutlet UIButton     *btnCancel;

    //for voucher
     IBOutlet UIView       *viewforVoucherDetails;
     IBOutlet UITableView  *tbofVoucherDetails;
     IBOutlet UIView           *viewforBlanceAmount;
     IBOutlet UILabel      *lblofVoucherAmountValue;
     IBOutlet UILabel      *lblofBalnceAmountValue;
     BOOL                  VoucerClicked;
    
    //for custom alertview
     IBOutlet UIView        *viewforCustomALert;
     IBOutlet EGOImageView  *imgviewforbgimg;
     AppDelegate            *delegateApp;
    
    NSTimer                    *lockRequestTimer;
    BOOL                       isCanceled;
//    NSTimer                    *timeOutTimer;
    int                        timeOutInMin;
    int                        timercount;
    int                        timeOutcount;
    SMSCountryUtils            *scUtils;
    
     UIPickerView *countryCodePicker;
    IBOutlet UITextField   *tfofcountryCode;

    
    NSInteger              textFieldTag;

    
    UIAlertView *cancelalert;
    UIAlertView *backalertalert;
    
    NSOperationQueue          *queue;
    NSMutableArray            *parsersArr;
    NSMutableArray            *connectionsArr;
    
    IBOutlet UILabel          *lblSelectedSeatNumbers;
    NSMutableArray            *arrofUserVouchers;
    float                     vouchersPrice;
    QticketsSingleton         *singleTon;
    NSMutableArray            *arrofSelectedVoucherIndex;
    int                       noofTimesVoucherCalled;
    NSMutableArray            *arrofCouponCodes;
    IBOutlet UILabel       *lblImdbrating;
    

    
    
    //varibale for calcu
    float allVoucherAmounts,totalTicketAmount;
    
    IBOutlet UILabel         *lblofNoofSeats;
    BOOL                      tandcBool;
    IBOutlet UIButton        *btntcCheckMark;
//    BOOL                     amountNeed;
    NSMutableDictionary      *dicofTermsCondi;
    NSArray                  *arrofTermsConditions;
    NSMutableArray           *arrofUsedVouchers,*arrofvoucherImp;
    
    
    IBOutlet UIImageView    *imgviewofPlace;
    IBOutlet UIImageView    *imgviewofScreen;
    IBOutlet UIImageView    *imgviewofImdb;
    
    
    //for events
    IBOutlet UIImageView    *imgviewofEventRating;
    IBOutlet UILabel        *lblofEventRating;
    IBOutlet UIImageView    *imgviewofEvetLocation;
    IBOutlet UILabel        *lblofEventLcoation;
    IBOutlet UILabel        *lbloftopBlusstrip;
    NSString *strBalanceAmount,*strVoucherAmount,*strTicketAmount;
    
    BOOL singleVoucherApplied;
    
    IBOutlet UILabel        *lblevoucherHeader;
    IBOutlet UILabel        *lblbalanceHeader;
    
    NSTimer *checkseatBlockremaining;
    
    BOOL forpushneedtoCancel;
    
}

@end

@implementation UserDetailsViewController
@synthesize currentSelec,dictofEvebntData;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    delegateApp    = QTicketsAppDelegate;
    connectionsArr = [[NSMutableArray alloc] init];
    parsersArr     = [[NSMutableArray alloc] init];
    queue          = [[NSOperationQueue alloc] init];
    singleTon      = [QticketsSingleton sharedInstance];
    arrofSelectedVoucherIndex = [[NSMutableArray alloc] init];
    arrofCouponCodes          = [[NSMutableArray alloc] init];
    dicofTermsCondi           = [[NSMutableDictionary alloc] init];
    arrofTermsConditions      = [[NSMutableArray alloc] init];
    arrofUserVouchers         = [[NSMutableArray alloc] init];
    arrofvoucherImp           = [[NSMutableArray alloc] init];
    
    
    timercount = 5;
    singleTon.timerforSeatBlock=1.0;
    NSString *str = @"fromUD";
    [USERDEFAULTS setObject:str forKey:@"toBackGround"];
    USERDEFAULTSAVE;

    forpushneedtoCancel = NO;
    
    
    scUtils = [[SMSCountryUtils alloc] init];
    vouchersPrice    = 0;
    singleVoucherApplied = NO;
    noofTimesVoucherCalled = 0;
    
    allVoucherAmounts  = 0;
    
    if (singleTon.isMovieSelected) {
        
        totalTicketAmount   =  singleTon.seatCnfmtn.totalPrice;

    }
    
    else{
        
        totalTicketAmount   =  [[NSString stringWithFormat:@"%@",[self.dictofEvebntData objectForKey:@"TicketsCost"]] floatValue];

    }
    tandcBool          = NO;
    
    
    [viewforCustomALert setHidden:YES];
    [self.view bringSubviewToFront:viewforCustomALert];
    [self setInitialSetup];
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }

    if (ViewHeight == 480) {
        
        [scrollofUserDetails setFrame:CGRectMake(scrollofUserDetails.frame.origin.x, scrollofUserDetails.frame.origin.y+30, scrollofUserDetails.frame.size.width, scrollofUserDetails.frame.size.height)];
        [lbloftopBlusstrip setFrame:CGRectMake(lbloftopBlusstrip.frame.origin.x, lbloftopBlusstrip.frame.origin.y+30, lbloftopBlusstrip.frame.size.width, lbloftopBlusstrip.frame.size.height)];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequestforPushUD) name:@"PushClicked" object:nil];
    

    
    
    //check if the event is QTA Summer Festival
    
    if ([delegateApp.selectedEvent.serverId isEqualToString:QTA_SUMMER_FESTIVAL_EVENTID]) {
        
        [viewofSeatInfo setHidden:YES];
    }
    else{
        
        [viewofSeatInfo setHidden:NO];
    }
    
}



-(void)cancelRequestforPushUD{
    
    forpushneedtoCancel = YES;
    
    if (checkseatBlockremaining != nil)
    {
        [checkseatBlockremaining invalidate];
        checkseatBlockremaining=nil;
    }
    
    if (lockRequestTimer != nil)
    {
        [lockRequestTimer invalidate];
        lockRequestTimer=nil;
    }
    
    [viewforCustomALert setHidden:NO];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    QticketsSingleton *singlton = [QticketsSingleton sharedInstance];
    if (singlton.isTermsAndConditions) {
        
        [btntcCheckMark setSelected:YES];
        tandcBool = YES;
    }
    else{
        
        [btntcCheckMark setSelected:NO];
        tandcBool = NO;
    }
    
   
}


-(UIToolbar *)toolbarWithUIBarButtonItem1
{
    UIToolbar *pickertoolbar = [[UIToolbar alloc] init];
    pickertoolbar.barStyle = UIBarStyleBlack;
    pickertoolbar.translucent = YES;
    pickertoolbar.tintColor = nil;
    [pickertoolbar sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneButtonClicked1:)];
    [pickertoolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    
    return pickertoolbar;
}
-(void)doneButtonClicked1:(id)sender{
    
    [tfofcountryCode resignFirstResponder];
    [scrollofUserDetails setContentOffset:CGPointMake(0,0) animated:YES];

}


-(void)setInitialSetup{
    
    if ([SMSCountryUtils isIphone]) {
        [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-10, ViewHeight)];

    }
    else{
        [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-20, ViewHeight)];

    }
    
    VoucerClicked   = NO;
    [imgviewofNamebg.layer   setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofNamebg.layer   setBorderWidth: 1.0];
    
    [imgviewofMobilebg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofMobilebg.layer setBorderWidth: 1.0];
    
    [imgviewofEmailid.layer  setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofEmailid.layer  setBorderWidth: 1.0];

    
      countryCodePicker = [[UIPickerView alloc]init];
    countryCodePicker.delegate=self;
    countryCodePicker.dataSource=self;
    [countryCodePicker sizeToFit];
    countryCodePicker.showsSelectionIndicator=YES;
    int countryIndex = 0;
    //default value in datepicker is present date
    NSInteger selectdTimeIndex = [countryCodePicker selectedRowInComponent:0];
    if(selectdTimeIndex!=-1){
        
        for (int k = 0; k< singleTon.arrofCountryDetails.count; k++) {
            CountryInfo *countrydetol = [singleTon.arrofCountryDetails objectAtIndex:k];
            if ([countrydetol.CountryName isEqualToString:@"Qatar"]) {
                
                countryIndex = k;
            }
            
        }
        
        CountryInfo *countrydet = [singleTon.arrofCountryDetails objectAtIndex:countryIndex];
        [countryCodePicker selectRow:countryIndex inComponent:0 animated:YES];
        [tfofcountryCode setText:[NSString stringWithFormat:@"%@",countrydet.CountryPrefix]];
    }

    tfofcountryCode.inputView=countryCodePicker;
    tfofcountryCode.inputAccessoryView=[self toolbarWithUIBarButtonItem1];
    if (singleTon.cureentLoginUser.status == 1)
    {
        tfofNameofUser.text=[NSString stringWithFormat:@"      %@",singleTon.cureentLoginUser.userName];
        tfofUserEmail.text=[NSString stringWithFormat:@"       %@",singleTon.cureentLoginUser.emailId];
        [tfofcountryCode setText:[NSString stringWithFormat:@"+%@",singleTon.cureentLoginUser.prefix]];
        tfofMobileNumber.text=singleTon.cureentLoginUser.phoneNumber;
        
        //get user voucher details......
        [self userVoucherDetails:singleTon.cureentLoginUser.serverId];
        
      
    }
    else
    {
        tfofUserEmail.userInteractionEnabled=YES;
        tfofMobileNumber.userInteractionEnabled=YES;
        tfofcountryCode.userInteractionEnabled=YES;
        tfofNameofUser.userInteractionEnabled=YES;
        
    }
    

    //hide voucher detals
    [viewforVoucherDetails setHidden:YES];
    CGFloat   voucheryCoor = tfofVoucherValue.frame.origin.y;
    [tfofVoucherValue setHidden:YES];
    [btnApplyVoucher  setHidden:YES];
    
    //set scrollview contant size
    [viewforPayment setFrame:CGRectMake(0, voucheryCoor, ViewWidth-20, viewforPayment.frame.size.height)];
    if ([SMSCountryUtils isIphone]) {
        
        [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-10, 400)];

    }
    else{
        
        [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-20, 800)];

    }
    lblMoviebnamewithRating.marqueeType    = MLContinuous;
    lblMoviebnamewithRating.trailingBuffer = 15.0f;
    lblscrennOfmovie.marqueeType    = MLContinuous;
    lblscrennOfmovie.trailingBuffer = 15.0f;
    lblplaceofMovie.marqueeType    = MLContinuous;
    lblplaceofMovie.trailingBuffer  = 15.0;
    lbldateOfmovie.marqueeType     = MLContinuous;
    lbldateOfmovie.trailingBuffer  = 15.0;

    
    if (singleTon.isMovieSelected) {
        
        [lblofNoofSeats setHidden:NO];
        [imgviewofImdb setHidden:NO];
        [lblImdbrating setHidden:NO];
        [lblplaceofMovie setHidden:NO];
        [lblscrennOfmovie setHidden:NO];
        [imgviewofPlace setHidden:NO];
        [imgviewofScreen setHidden:NO];
        
        
        [imgviewofEventRating setHidden:YES];
        [lblofEventRating setHidden:YES];
        [imgviewofEvetLocation setHidden:YES];
        [lblofEventLcoation setHidden:YES];

        //placing an alert with pagesession time
        checkseatBlockremaining =   [NSTimer scheduledTimerWithTimeInterval:1
                                                                     target:self
                                                                   selector:@selector(targetMethod:)
                                                                   userInfo:nil
                                                                    repeats:YES];

        
        
        imgviewofPlace.image = [UIImage imageNamed:@"MiconTheatre.png"];
        imgviewofScreen.image = [UIImage imageNamed:@"MiconScreen.png"];
        
        imgforMovie                 = [imgforMovie initWithPlaceholderImage:[UIImage imageNamed:@"bg.png"]];
        imgforMovie.imageURL        = [NSURL URLWithString:[NSString stringWithFormat:@"%@",delegateApp.selectedMovie.strMovieThumurlis]];
        lblMoviebnamewithRating.text           = [NSString stringWithFormat:@"%@ (%@)",self.currentSelec.movieName,self.currentSelec.movieCensor];
        NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
        [dateFormate setDateFormat:@"MM/dd/yyyy"];
        NSDate *date = [dateFormate dateFromString:self.currentSelec.date];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
        NSInteger weekday = [components weekday];
        NSString *weekdayName = [dateFormate weekdaySymbols][weekday - 1];
        NSString *showDayis  =[weekdayName substringToIndex:3];
        dateFormate.dateFormat=@"dd";
        NSString *showDateis=[dateFormate stringFromDate:date];
        dateFormate.dateFormat=@"MMM";
        NSString *showMonthis=[[dateFormate stringFromDate:date] uppercaseStringWithLocale:[NSLocale currentLocale]];
        lbldateOfmovie.text = [NSString stringWithFormat:@"%@-%@,%@",showDayis,showDateis,showMonthis];
        lblplaceofMovie.text = [NSString stringWithFormat:@"%@ , %@",[self.currentSelec.theaterName uppercaseStringWithLocale:[NSLocale currentLocale]],self.currentSelec.strTheaterNameArabic];
        lbltimeofMovie.text  = self.currentSelec.showTime;
        lblscrennOfmovie.text = self.currentSelec.screenName;
        if ([self.currentSelec.movieimdbRating isEqualToString:@"NA"]) {
            
            [lblImdbrating setHidden:YES];
            [imgviewofImdb setHidden:YES];
            
        }
        else{
            [lblImdbrating setHidden:NO];
            [imgviewofImdb setHidden:NO];
             lblImdbrating.text    = [NSString stringWithFormat:@"%@/10",self.currentSelec.movieimdbRating];
        }
        
        
       
        lblSelectedSeatNumbers.text=[NSString stringWithFormat:@"%@",[self.currentSelec.selectedSeatsArr objectAtIndex:0]];
        lblofNoofSeats.text      = [NSString stringWithFormat:@"%lu",(unsigned long)[[[self.currentSelec.selectedSeatsArr objectAtIndex:0]componentsSeparatedByString:@","]count]];
        lblTicketPriceValue.text=[NSString stringWithFormat:@"%.2f QAR",singleTon.seatCnfmtn.ticketprice];
        lblofServieChargeValue.text=[NSString stringWithFormat:@"%.2f QAR",singleTon.seatCnfmtn.serviceCharges];
        lblofFinalTotalValue.text= [NSString stringWithFormat:@"%.2f QAR",singleTon.seatCnfmtn.totalPrice];
        
    }
    else{
        
        [lblofNoofSeats setHidden:NO];
        [imgviewofImdb setHidden:YES];
        [lblImdbrating setHidden:YES];
        [lblplaceofMovie setHidden:YES];
        [lblscrennOfmovie setHidden:YES];
        [imgviewofPlace setHidden:YES];
        [imgviewofScreen setHidden:YES];
        
        
        [imgviewofEventRating setHidden:NO];
        [lblofEventRating setHidden:NO];
        [imgviewofEvetLocation setHidden:NO];
        [lblofEventLcoation setHidden:NO];

        
       
        
        NSString *imagtThumbnailurl = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.thumbnailURL];
        imagtThumbnailurl           =    [imagtThumbnailurl stringByReplacingOccurrencesOfString:@"/App_Images/" withString:@"/movie_Images/"];
        imagtThumbnailurl           =  [imagtThumbnailurl stringByReplacingOccurrencesOfString:@"_banner." withString:@"_thumb."];
        imgforMovie                 = [imgforMovie initWithPlaceholderImage:[UIImage imageNamed:@"bg.png"]];
        imgforMovie.imageURL        = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imagtThumbnailurl]];
       
        lblMoviebnamewithRating.text           = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.EventName];
        
        if ([[self.dictofEvebntData objectForKey:@"EventDateIs"] isEqualToString:@""]) {
            
            lbldateOfmovie.text = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.startDate];
            
        }
        else{
            
            lbldateOfmovie.text = [NSString stringWithFormat:@"%@",[self.dictofEvebntData objectForKey:@"EventDateIs"]];
        }
        
        
        lblofEventRating.text = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.entryRestriction];
        lbltimeofMovie.text  = delegateApp.selectedEvent.startTime;
        lblofEventLcoation.text = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.venue];
        lblofNoofSeats.text = [NSString stringWithFormat:@"%@",[self.dictofEvebntData objectForKey:@"NoofTickets"]];
        lblSelectedSeatNumbers.text=[NSString stringWithFormat:@"%@",[self.dictofEvebntData objectForKey:@"SeatDesc"]];
        lblTicketPriceValue.text=[NSString stringWithFormat:@"%@ QAR",[self.dictofEvebntData objectForKey:@"TicketsCost"]];
        lblofServieChargeValue.text=[NSString stringWithFormat:@"%@ QAR",[self.dictofEvebntData objectForKey:@"TicketServiceCost"]];
        CGFloat totalCost = [[self.dictofEvebntData objectForKey:@"TicketsCost"] floatValue] + [[self.dictofEvebntData objectForKey:@"TicketServiceCost"] floatValue];
        lblofFinalTotalValue.text= [NSString stringWithFormat:@"%.2f QAR",totalCost];
        
        strTicketAmount = [NSString stringWithFormat:@"%.2f",totalCost];
        
        
    }
    
    
    
   
                                                                           
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneClickeddet:)];
    UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                                       style:UIBarButtonItemStylePlain target:self
                                                                      action:@selector(previousBtnClickeddet:)];
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(nextBtnClickeddet:)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:previousButton,nextButton,doneButton, nil]];
    
    tfofNameofUser.inputAccessoryView=keyboardDoneButtonView;
    tfofUserEmail.inputAccessoryView=keyboardDoneButtonView;
    tfofMobileNumber.inputAccessoryView=keyboardDoneButtonView;
    
}



-(void)nextBtnClickeddet:(id)sender
{
    if (textFieldTag == tfofNameofUser.tag)
    {
        [tfofNameofUser resignFirstResponder];
        [tfofUserEmail becomeFirstResponder];
    }
    else if (textFieldTag == tfofUserEmail.tag)
    {
        [tfofUserEmail resignFirstResponder];
        [tfofMobileNumber becomeFirstResponder];
    }
    else if (textFieldTag == tfofMobileNumber.tag)
    {
        [scrollofUserDetails setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofMobileNumber resignFirstResponder];
        
    }
    
}

-(void)previousBtnClickeddet:(id)sender
{
    if (textFieldTag == tfofNameofUser.tag)
    {
        [scrollofUserDetails setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofNameofUser resignFirstResponder];
    }
    else if (textFieldTag == tfofUserEmail.tag)
    {
        [tfofUserEmail resignFirstResponder];
        [tfofNameofUser becomeFirstResponder];
    }
    else if (textFieldTag == tfofMobileNumber.tag)
    {
        [scrollofUserDetails setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofMobileNumber resignFirstResponder];
        [tfofUserEmail becomeFirstResponder];
    }
}
- (void)doneClickeddet:(id)sender {
    
    [[self.view viewWithTag:tfofNameofUser.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofUserEmail.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofMobileNumber.tag] resignFirstResponder];
    [scrollofUserDetails setContentOffset:CGPointMake(0,0) animated:YES];
}
-(void)targetMethod:(NSTimer *)sender
{
//    timeOutTimer=sender;
    QticketsSingleton *snglton = [QticketsSingleton sharedInstance];
    
    
    if (singleTon.timerforSeatBlock >= [snglton.seatCnfmtn.pageSessionTime intValue] * 60)
    {
       
        [scUtils hideLoader];
        if (cancelalert!=nil)
        {
            [cancelalert dismissWithClickedButtonIndex:-1 animated:YES];
        }
        
        if (backalertalert!=nil)
        {
            [backalertalert dismissWithClickedButtonIndex:-1 animated:YES];
        }
        
        if (checkseatBlockremaining != nil) {
            
            [checkseatBlockremaining invalidate];
            checkseatBlockremaining = nil;
        }

        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"Time Out" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertV.tag=TIMEOUT_ALERT;
        [alertV show];
        

    }
    else
    {
        singleTon.timerforSeatBlock = singleTon.timerforSeatBlock + 1;
    }
   
}

#pragma mark
#pragma mark
#pragma mark TextField Delegate method
#pragma mark
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (textField.tag == tfofcountryCode.tag)
//    {
//        return NO;
//    }
//    else
    
    
        return YES;
    
}
// called when textField start editting.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textFieldTag=textField.tag;
    
    [scrollofUserDetails setContentOffset:CGPointMake(0,textField.center.y-30) animated:YES];

}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}
// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [scrollofUserDetails setContentOffset:CGPointMake(0,textField.center.y-30) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [scrollofUserDetails setContentOffset:CGPointMake(0,0) animated:YES];
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 15) {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_NUMERICS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else{
        return YES;
    }
}

#pragma mark
#pragma mark AlertView Delegate
#pragma mark

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == TIMEOUT_ALERT || alertView.tag == SEATS_BOOKED_ALERT)
    {
        if (buttonIndex == 0)
        {
            isCanceled=true;
            [self cancelRequestWithTransactionId:singleTon.seatCnfmtn.transactionID];
        }
        
    }
    else if (alertView.tag == TRANSACTIONTIME_OUT)
    {
        if (buttonIndex == 0)
        {
            [self cancelRequestWithTransactionId:singleTon.seatCnfmtn.transactionID];
        }
        
    }
    else if (alertView.tag == SERVER_ERROR_ALERT)
    {
        if (buttonIndex == 0)
        {
            
            if (checkseatBlockremaining != nil) {
                
                [checkseatBlockremaining invalidate];
                checkseatBlockremaining = nil;
            }if (lockRequestTimer != nil)
            {
                [lockRequestTimer invalidate];
                lockRequestTimer=nil;
            }
            
            if (delegateApp.inTandC == YES) {
                
                NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                
                int index = 0;
                for(int i=0 ; i<[arrofNavoagtionsCon count] ; i++)
                {
                    if([[arrofNavoagtionsCon objectAtIndex:i] isKindOfClass:NSClassFromString(@"BookingViewController")])
                    {
                        index = i;
                        break;
                    }
                }
                if (index != 0) {
                    [self.navigationController popToViewController:[arrofNavoagtionsCon objectAtIndex:index] animated:YES];
                    
                }
                else{
                    
                    BookingViewController *homeviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"BookingViewController"];
                    [self.navigationController pushViewController:homeviewVC animated:NO];
                    
                }

            }
            else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
 //   NSLog(@"scroling view coor :%f",scrollView.contentSize.height);
    
}
-(IBAction)btnBackClicked:(id)sender{
    
    if (checkseatBlockremaining != nil)
    {
        [checkseatBlockremaining invalidate];
        checkseatBlockremaining=nil;
    }
    
    if (lockRequestTimer != nil)
    {
        [lockRequestTimer invalidate];
        lockRequestTimer=nil;
    }
    
    
    
    
    if (singleTon.isMovieSelected) {
        
        [viewforCustomALert setHidden:NO];
    }
    else{
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }


}

-(IBAction)btnEditClicked:(id)sender{
    
    [tfofNameofUser   setUserInteractionEnabled:YES];
    [tfofMobileNumber setUserInteractionEnabled:YES];
    [tfofUserEmail    setUserInteractionEnabled:YES];
    [tfofNameofUser   becomeFirstResponder];
}

-(IBAction)btnEvoucherclicked:(id)sender{
    
    //move payment details to dowm
    

    
        __block CGFloat   voucheryCoor;
    if (VoucerClicked == NO) {
    [UIView animateWithDuration:0.8 animations:^{
        
        CGFloat viewPaymentYis;
        
        if ([SMSCountryUtils isIphone]) {
            
            viewPaymentYis = 230;
            
        }
        else{
            
            viewPaymentYis = 380;
        }
        
        [viewforPayment setFrame:CGRectMake(0, viewPaymentYis, ViewWidth-20, viewforPayment.frame.size.height)];
       
    } completion:^(BOOL finished) {
        
        if (singleTon.cureentLoginUser.status == 1) {
            
            
            if (arrofUserVouchers.count > 0) {
                
                [lblbalanceHeader setHidden:NO];
                [lblevoucherHeader setHidden:NO];
                
            }
            else{
                
                [lblevoucherHeader setHidden:YES];
                [lblbalanceHeader  setHidden:YES];
            }
            
            
            [arrofUserVouchers removeAllObjects];
            [arrofUserVouchers addObjectsFromArray:arrofvoucherImp];
            [tbofVoucherDetails reloadData];
            [UIView animateWithDuration:0.8 animations:^{
                
                
                CGFloat rowHeight,uservoucherheight;
                
                if ([SMSCountryUtils isIphone]) {
                    
                    rowHeight = 45;
                    
                    uservoucherheight = 40;
                }
                else {
                    
                    rowHeight = 70;
                    uservoucherheight = 80;
                }
                
                [viewforVoucherDetails setFrame:CGRectMake(viewforVoucherDetails.frame.origin.x, tfofVoucherValue.frame.origin.y+uservoucherheight, viewforVoucherDetails.frame.size.width, viewforVoucherDetails.frame.size.height)];
                
                [tbofVoucherDetails setFrame:CGRectMake(tbofVoucherDetails.frame.origin.x, tbofVoucherDetails.frame.origin.y, ViewWidth-10, (arrofUserVouchers.count * rowHeight))];
                
                [tbofVoucherDetails setScrollEnabled:NO];
                
                
                
                [viewforBlanceAmount setFrame:CGRectMake(viewforBlanceAmount.frame.origin.x, tbofVoucherDetails.frame.origin.y+tbofVoucherDetails.frame.size.height+20, viewforBlanceAmount.frame.size.width, viewforBlanceAmount.frame.size.height)];
                
                [viewforVoucherDetails setFrame:CGRectMake(viewforVoucherDetails.frame.origin.x, tfofVoucherValue.frame.origin.y+uservoucherheight, viewforVoucherDetails.frame.size.width,viewforBlanceAmount.frame.origin.y+ viewforBlanceAmount.frame.size.height+20)];
                
                
                [viewforPayment setFrame:CGRectMake(viewforPayment.frame.origin.x, viewforVoucherDetails.frame.origin.y+viewforVoucherDetails.frame.size.height, viewforPayment.frame.size.width, viewforPayment.frame.size.height)];
                
                [viewforVoucherDetails setHidden:NO];
                
            } completion:^(BOOL finished) {
                
                if ([SMSCountryUtils isIphone]) {
                    [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-10, viewforPayment.frame.origin.y+viewforPayment.frame.size.height)];
                    
                }
                else{
                    [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-20, viewforPayment.frame.origin.y+viewforPayment.frame.size.height)];
                }
                
                VoucerClicked = YES;
                
                lblofBalnceAmountValue.text    = [NSString stringWithFormat:@"%.2f QAR",totalTicketAmount];
                
                
                [tbofVoucherDetails reloadData];
            }];
            [tfofVoucherValue setHidden:NO];
            [btnApplyVoucher  setHidden:NO];
            VoucerClicked   = YES;
            [btnforEvoucherEnable setSelected:YES];
            
            [tfofVoucherValue setHidden:NO];
            [tfofVoucherValue setText:@""];
            [btnApplyVoucher  setHidden:NO];

            
        }
        else{
            
            [tfofVoucherValue setHidden:NO];
            [btnApplyVoucher  setHidden:NO];
            VoucerClicked   = YES;
            [btnforEvoucherEnable setSelected:YES];

        }
    }];
    }
    else{
        
        
        [UIView animateWithDuration:0.8 animations:^{
            voucheryCoor = tfofVoucherValue.frame.origin.y;
            [tfofVoucherValue setHidden:YES];
            [tfofVoucherValue setText:@""];
            [btnApplyVoucher  setHidden:YES];
            [viewforVoucherDetails setHidden:YES];
            [viewforPayment      setFrame:CGRectMake(0, voucheryCoor, ViewWidth-20, viewforPayment.frame.size.height)];
            if ([SMSCountryUtils isIphone]) {
                [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-10, 400)];

            }
            else{
                [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-20, 571)];

            }
            [btnforEvoucherEnable setSelected:NO];
            [arrofCouponCodes removeAllObjects];
            [arrofUserVouchers removeAllObjects];
            noofTimesVoucherCalled = 0;
            allVoucherAmounts = 0;
            
        } completion:^(BOOL finished) {
            VoucerClicked   = NO;
            
        }];
    }

}

-(IBAction)btnApplyVoucherClicked:(id)sender
{
    
    NSMutableArray *arrofuservoucherCodes = [[NSMutableArray alloc] init];
    
    if (singleTon.cureentLoginUser.status == 1) {
        
        for (int l = 0 ; l< arrofvoucherImp.count; l++) {
            UserVoucherVO *voucherO = [arrofvoucherImp objectAtIndex:l];
            [arrofuservoucherCodes addObject:[NSString stringWithFormat:@"%@",voucherO.voucherCoupon]];
        }
    }
    
    if (tfofUserEmail.text.length<=0)
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_EMAILID];
    }
    else
    {
        if (tfofVoucherValue.text.length <=0) {
            
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_VOUCHER_CODE];
        }
        else{
    
    NSString *strCouponcode = [[NSString stringWithFormat:@"%@",tfofVoucherValue.text] uppercaseString];
    
    if (arrofUserVouchers.count > 0) {
     
                if ([arrofCouponCodes containsObject:strCouponcode]) {
            
            UIAlertView *alertviewofApplied = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Voucher Alredy Applied" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [tfofVoucherValue setText:@""];
            [alertviewofApplied show];
            
            
        }
        
                else if ([arrofuservoucherCodes containsObject:strCouponcode]){
                    
                    UIAlertView *alertviewofApplied = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Voucher Alredy Applied" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [tfofVoucherValue setText:@""];
                    [alertviewofApplied show];
                    

                }
        else{
            
            if (singleTon.isMovieSelected) {
                
            
            
            [self callforVoucherDeatailswithUseremailId:[NSString stringWithFormat:@"%@",tfofUserEmail.text] withvouchercouponCode:strCouponcode withShowid:self.self.currentSelec.showId];
                
            }else{
                
                
                [self callforVoucherDeatailswithUseremailId:[NSString stringWithFormat:@"%@",tfofUserEmail.text] withvouchercouponCode:strCouponcode withShowid:@"0"];
            }

        }
    
    }
    else{
    
    //if voucher is correct and applied
    
        if (singleTon.isMovieSelected) {
            
            
        [self callforVoucherDeatailswithUseremailId:[NSString stringWithFormat:@"%@",tfofUserEmail.text] withvouchercouponCode:strCouponcode withShowid:self.self.currentSelec.showId];
    }
        else{
            
            
              [self callforVoucherDeatailswithUseremailId:[NSString stringWithFormat:@"%@",tfofUserEmail.text] withvouchercouponCode:strCouponcode withShowid:@"0"];
        }
    
    }
        }
    }
    

}




#pragma tableview of voucher details

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrofUserVouchers.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VoucherTableViewCell *voucherCell = (VoucherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VoucherTableViewCell"];
    if (voucherCell == nil) {
        
        voucherCell = [[[NSBundle mainBundle]loadNibNamed:@"VoucherTableViewCell" owner:self options:nil] objectAtIndex:0];
        
    }
    if (!singleVoucherApplied) {

        if (singleTon.cureentLoginUser.status == 1) {
            
            
        UserVoucherVO *uservoucher = [arrofUserVouchers objectAtIndex:indexPath.row];
        voucherCell.lblofVoucherValue.text    = [NSString stringWithFormat:@"%@",uservoucher.voucherCoupon];
        voucherCell.lblofVoucherAmount.text = [NSString stringWithFormat:@"%@ QAR",uservoucher.voucherBalanceValue];
        [voucherCell.btnVoucherCheckmark setTag:indexPath.row];
        [voucherCell.btnVoucherCheckmark addTarget:self action:@selector(btnCheckmarkClicked:) forControlEvents:UIControlEventTouchUpInside];

            
        }
        else{
            
            //no records are there
            
        }

    }
    else{
        
        UserVoucherVO *uservoucher = [arrofUserVouchers objectAtIndex:indexPath.row];
        voucherCell.lblofVoucherValue.text    = [NSString stringWithFormat:@"%@",uservoucher.voucherCoupon];
        voucherCell.lblofVoucherAmount.text = [NSString stringWithFormat:@"%@ QAR",uservoucher.voucherBalanceValue];
    [voucherCell.btnVoucherCheckmark setTag:indexPath.row];
    [voucherCell.btnVoucherCheckmark addTarget:self action:@selector(btnCheckmarkClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (arrofSelectedVoucherIndex.count > 0) {
        
        for (int kl = 0; kl<arrofSelectedVoucherIndex.count; kl++) {
            
            NSInteger indexis = [[arrofSelectedVoucherIndex objectAtIndex:kl] integerValue];
            if (indexPath.row == indexis) {
                [voucherCell.btnVoucherCheckmark setSelected:YES];
            }
        }
       }
    }
    
    voucherCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return voucherCell;

}


-(void)btnCheckmarkClicked:(id)sender{
    
    
   
    
    UIButton *btnChcekmark = (UIButton *)sender;
    
    NSString *btntagstr = [NSString stringWithFormat:@"%ld",(long)btnChcekmark.tag];
    

    
        UserVoucherVO *voucherObj = [arrofUserVouchers objectAtIndex:btnChcekmark.tag];
        CGFloat vouchersPrice2    = [[NSString stringWithFormat:@"%@",voucherObj.voucherBalanceValue] floatValue];
        
        if ([arrofSelectedVoucherIndex containsObject:btntagstr]) {
            
            allVoucherAmounts -= vouchersPrice2;
            [btnChcekmark setSelected:NO];
            [arrofSelectedVoucherIndex removeObject:btntagstr];
            [arrofCouponCodes removeObject:[NSString stringWithFormat:@"%@",voucherObj.voucherCoupon]];
        }
        else{
            
            allVoucherAmounts += vouchersPrice2;
            [btnChcekmark setSelected:YES];
            [arrofSelectedVoucherIndex addObject:btntagstr];
            [arrofCouponCodes addObject:[NSString stringWithFormat:@"%@",voucherObj.voucherCoupon]];
            
        }
    if (allVoucherAmounts > totalTicketAmount) {
        
        lblofVoucherAmountValue.text = [NSString stringWithFormat:@"%.2f QAR",totalTicketAmount];
        lblofBalnceAmountValue.text    = [NSString stringWithFormat:@"%@ QAR",@"0.00"];
        strBalanceAmount =[NSString stringWithFormat:@"%@ QAR",@"0.00"];
        
    
    }
    else{
        
        lblofVoucherAmountValue.text = [NSString stringWithFormat:@"%.2f QAR",allVoucherAmounts];
        lblofBalnceAmountValue.text    = [NSString stringWithFormat:@"%.2f QAR",totalTicketAmount-allVoucherAmounts];
        
        //after updated modifications
         strBalanceAmount = [NSString stringWithFormat:@"%.2f",totalTicketAmount-allVoucherAmounts];
        
    }
    

    
    
    
    
}


-(IBAction)btnProccedPAymentClicked:(id)sender
{
    
    UserVO *userVO= [[UserVO alloc]init];
    
    if (tfofNameofUser.text.length<=0)
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_YOUR_NAME];
    }
    else
    {
        userVO.userName=[tfofNameofUser.text stringByReplacingOccurrencesOfString:@" "  withString:@""];
        
        if (tfofUserEmail.text.length<=0)
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_EMAIL_ID];
        }
       else if (![SMSCountryUtils validateEmail:[tfofUserEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
            
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_VALID_EMAILID];
        }
        else
        {
            userVO.emailId=[tfofUserEmail.text stringByReplacingOccurrencesOfString:@" "  withString:@""];
            
            if (tfofMobileNumber.text.length<=0)
            {
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_PHONE_NUMBER];
            }
            else if (tfofMobileNumber.text.length < 8){
                
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ENTER_VALID_PHONE_NUMBER];
                
            }
            else
            {
                if (tfofcountryCode.text.length <=0 ) {
                    
                    [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SELECT_PHONE_PREFIX];
                }
                else{
                if (tandcBool == NO) {
                    
                    [SMSCountryUtils showAlertMessageWithTitle:@"Alert" Message:@"Please Accept the  terms and conditions"];
                }
                else{
                
                if (singleTon.cureentLoginUser!=nil)
                {
                    userVO.serverId=singleTon.cureentLoginUser.serverId;
                }
                else
                {
                    userVO.serverId=@"";
                }
                userVO.address=@"";
                userVO.phoneNumber=tfofMobileNumber.text;
                userVO.status=0;
                NSString *phonepreifx =[tfofcountryCode.text stringByReplacingOccurrencesOfString:@"+"withString:@""];
                phonepreifx = [phonepreifx stringByReplacingOccurrencesOfString:@" " withString:@""];
                userVO.prefix=phonepreifx;
//                if (timeOutTimer != nil)
//                {
//                    [timeOutTimer invalidate];
//                    timeOutTimer=nil;
//                }
                    
             NSMutableString *strEvouchers =  [[NSMutableString alloc] init];
                    
                    
                    if (arrofCouponCodes.count ==1) {
                        
                         [strEvouchers appendString:[NSString stringWithFormat:@"%@",[arrofCouponCodes objectAtIndex:0]]];
                        
                    }
                    else{
                    
                    
                    for (int j=0; j<arrofCouponCodes.count; j++) {
                        
                        [strEvouchers appendString:[NSString stringWithFormat:@",%@",[arrofCouponCodes objectAtIndex:j]]];
                    }
                    
                    }
                    
                    [delegateApp setStrUserEmailis:[NSString stringWithFormat:@"%@",tfofUserEmail.text]];
                    
                    if (singleTon.isMovieSelected) {
                        
                        [checkseatBlockremaining invalidate];
                        checkseatBlockremaining = nil;
                        
                        [self sendLockRequestWithUserVO:userVO andTransactionId:singleTon.seatCnfmtn.transactionID withEvouchers:strEvouchers];
                    }
                    else{
                        
                             [self bookEventTicketsWithUserVO:userVO withEvouchers:strEvouchers];
                    }
            }
                
            }
            
        }
        }
    }
}

#pragma mark
#pragma mark Service Calls
#pragma mark


-(void)userVoucherDetails:(NSString *)userId{
    
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn getUserVoucherwithUserID:userId];
    [connectionsArr addObject:conn];
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
    
}

-(void)bookEventTicketsWithUserVO:(UserVO *)userVO withEvouchers:(NSString *)Evouchers{
    
    SMSCountryConnections *conn = [[SMSCountryConnections alloc] initWithDelegate:self];

    
    [conn confirmTicketForEventwithEventId:delegateApp.selectedEvent.serverId withTicketId:[self.dictofEvebntData objectForKey:@"TicketTypeId"] withTicketTotalCost:[NSString stringWithFormat:@"%ld",(long)[strTicketAmount integerValue]] withnoOfTickets:[NSString stringWithFormat:@"%@",delegateApp.strnoofEventTickets] withTiketsasPerCategory:[self.dictofEvebntData objectForKey:@"TicketsPerCategory"] withUserEmail:userVO.emailId withUserName:userVO.userName withUserPhoneNum:userVO.phoneNumber withPrefix:userVO.prefix withEventDate:[NSString stringWithFormat:@"%@",lbldateOfmovie.text] withEventStartTime:delegateApp.selectedEvent.startTime withBalanceAmount:[NSString stringWithFormat:@"%ld",(long)[strBalanceAmount integerValue]] withCouponAmount:[NSString stringWithFormat:@"%ld",(long)[strVoucherAmount integerValue]] withCouponCodes:Evouchers];
    [connectionsArr addObject:conn];
    
}


-(void)sendLockRequestWithUserVO:(UserVO *)useVO andTransactionId:(NSString *)transactnID withEvouchers:(NSString *)Evouchers
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn sendLockRequestWithUserVO:useVO andTransactionId:transactnID withEvouchers:Evouchers withDeviceToken:delegateApp.strDeviceToken];
    [connectionsArr addObject:conn];
}

-(void)lockConfirmationRequestWithTransactionID:(NSString *)transactionID
{
    QticketsSingleton *singelTon = [QticketsSingleton sharedInstance];
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn lockConfirmationRequest:singelTon.seatCnfmtn.transactionID];
    [connectionsArr addObject:conn];
}

-(void)cancelRequestWithTransactionId:(NSString *)transactnID
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn cancelRequestWithTransactionId:transactnID];
    [connectionsArr addObject:conn];
}

-(void)callforVoucherDeatailswithUseremailId:(NSString *)emailid withvouchercouponCode:(NSString *)couponcode withShowid:(NSString *)showID{
    
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn checkVoucherValiditywithUserEmailId:emailid withVoucherId:couponcode withShowid:showID];
    [connectionsArr addObject:conn];
}

#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:SEND_LOCK_REQUEST]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        SendLockRequestParseOpeartion *sParser = [[SendLockRequestParseOpeartion alloc] initWithData:data delegate:self andRequestMessage:SEND_LOCK_REQUEST];
        [queue addOperation:sParser];
        [parsersArr addObject:sParser];
        data = nil;
    }
    
    if ([reqMessage isEqualToString:LOCK_CONFIRMATION]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        LockConformationParseOperation *lParser = [[LockConformationParseOperation alloc] initWithData:data delegate:self andRequestMessage:LOCK_CONFIRMATION];
        [queue addOperation:lParser];
        [parsersArr addObject:lParser];
        data = nil;
    }
    
    if ([reqMessage isEqualToString:CANCEL_CONFIRMATION]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        CancelRequestParseOpeartion *cParser = [[CancelRequestParseOpeartion alloc] initWithData:data delegate:self andRequestMessage:CANCEL_CONFIRMATION];
        [queue addOperation:cParser];
        [parsersArr addObject:cParser];
        data = nil;
    }
    
    if ([reqMessage isEqualToString:CHECK_VOUCHER]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        CheckVocuherValidityParseOperation *cParser = [[CheckVocuherValidityParseOperation alloc] initWithData:data delegate:self andRequestMessage:CHECK_VOUCHER];
        [queue addOperation:cParser];
        [parsersArr addObject:cParser];
        [tfofVoucherValue resignFirstResponder];
        data = nil;
    }
   
    if ([reqMessage isEqualToString:EVENT_TICKET_BOOKING]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        EventBlockSeatsParseOperation *eventBlock = [[EventBlockSeatsParseOperation alloc] initWithData:data delegate:self andRequestMessage:EVENT_TICKET_BOOKING];
        [queue addOperation:eventBlock];
        [parsersArr addObject:eventBlock];
        [tfofVoucherValue resignFirstResponder];
        data = nil;
    }
    if ([reqMessage isEqualToString:GET_ALLEVOUCHERS]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        UserVoucherParseOperation *bParser = [[UserVoucherParseOperation alloc] initWithData:data delegate:self andRequestMessage:GET_ALLEVOUCHERS];
        [queue addOperation:bParser];
        [parsersArr addObject:bParser];
        data = nil;
        
    }
}

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:SEND_LOCK_REQUEST])
    {
        if (lockRequestTimer != nil)
        {
            [lockRequestTimer invalidate];
            lockRequestTimer=nil;
        }
        [scUtils hideLoader];

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
    if ([reqMessage isEqualToString:LOCK_CONFIRMATION])
    {
        if (lockRequestTimer != nil)
        {
            [lockRequestTimer invalidate];
            lockRequestTimer=nil;
        }
        [scUtils hideLoader];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
        
    }
    if ([reqMessage isEqualToString:CANCEL_CONFIRMATION])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
    if ([reqMessage isEqualToString:CHECK_VOUCHER])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
   
    if ([reqMessage isEqualToString:EVENT_TICKET_BOOKING]) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        
    }
    if ([reqMessage isEqualToString:GET_ALLEVOUCHERS]) {
        
        if ([SMSCountryLocalDB  getVoucherDetailsForlocalUserId:singleTon.cureentLoginUser.serverId].count>0)
        {
            [arrofUsedVouchers addObjectsFromArray:[SMSCountryLocalDB getVoucherDetailsForlocalUserId:singleTon.cureentLoginUser.serverId]];
            [tbofVoucherDetails reloadData];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:VOUCHERDETAILS_NOT_AVAILABLE];
        }
    }
    
}

#pragma mark
#pragma mark CommonParserOperation Delegate methods
#pragma mark

- (void)didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr {
    
    if ([reqMsg isEqualToString:SEND_LOCK_REQUEST]) {
        [self performSelectorOnMainThread:@selector(handlelockRequestReceived:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
    
    if ([reqMsg isEqualToString:LOCK_CONFIRMATION]) {
        [self performSelectorOnMainThread:@selector(handleLoadedLockConfrmtnUserDe:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
    if ([reqMsg isEqualToString:CANCEL_CONFIRMATION]) {
        [self performSelectorOnMainThread:@selector(handleLoadedCancelRequestUserDe:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
    if ([reqMsg isEqualToString:CHECK_VOUCHER]) {
        
        [self performSelectorOnMainThread:@selector(handleCheckVoucherDet:) withObject:parseArr waitUntilDone:NO];
    }
   
    if ([reqMsg isEqualToString:EVENT_TICKET_BOOKING]) {
        
        [self performSelectorOnMainThread:@selector(handleEventsTicketsBlock:) withObject:parseArr waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:GET_ALLEVOUCHERS]) {
        [self performSelectorOnMainThread:@selector(handleUserVoucherDetailsuserdet:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:SEND_LOCK_REQUEST]) {
        [self performSelectorOnMainThread:@selector(handleParserErrorUserDe:) withObject:error waitUntilDone:NO];
    }
    
    if ([reqMsg isEqualToString:LOCK_CONFIRMATION]) {
        [self performSelectorOnMainThread:@selector(handleLockCnfmntParserErrorUserDe:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:CANCEL_CONFIRMATION]) {
        [self performSelectorOnMainThread:@selector(handleCancelCnfmntParserErrorUserDe:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:CHECK_VOUCHER]) {
        
        [self performSelectorOnMainThread:@selector(handleCheckVoucherErrorUserDe:) withObject:error waitUntilDone:NO];
    }
   
    if ([reqMsg isEqualToString:EVENT_TICKET_BOOKING]) {
        
        [self performSelectorOnMainThread:@selector(handleEventTicketBlockError:) withObject:error waitUntilDone:NO];
        
    }
    if ([reqMsg isEqualToString:GET_ALLEVOUCHERS]) {
        [self performSelectorOnMainThread:@selector(handleParserErrorVOUuserdet:) withObject:error waitUntilDone:NO];
    }
    queue = nil;
}

#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark

-(void)handleUserVoucherDetailsuserdet:(NSArray *)parsedArr{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    // if parsed Arr count is greater then zero. Now we can insert bookinghistory into localdb
    [scUtils hideLoader];
    
    if (parsedArr.count>0)
    {
        

        [arrofvoucherImp removeAllObjects];
        
        [btnforEvoucherEnable setSelected:YES];

        [arrofUserVouchers addObjectsFromArray:parsedArr];
        
        [arrofvoucherImp addObjectsFromArray:parsedArr];
   
        
        [UIView animateWithDuration:0.8 animations:^{
            
            
            CGFloat rowHeight,voucherheight;
            
            if ([SMSCountryUtils isIphone]) {
                
                rowHeight = 45;
                voucherheight = 40;
            }
            else {
                
                rowHeight = 70;
                voucherheight = 80;
            }
            
            [viewforVoucherDetails setFrame:CGRectMake(viewforVoucherDetails.frame.origin.x, tfofVoucherValue.frame.origin.y+voucherheight, viewforVoucherDetails.frame.size.width, viewforVoucherDetails.frame.size.height)];
            
            [tbofVoucherDetails setFrame:CGRectMake(tbofVoucherDetails.frame.origin.x, tbofVoucherDetails.frame.origin.y, ViewWidth-10, (arrofUserVouchers.count * rowHeight))];
            
            [tbofVoucherDetails setScrollEnabled:NO];
            
            
            
            [viewforBlanceAmount setFrame:CGRectMake(viewforBlanceAmount.frame.origin.x, tbofVoucherDetails.frame.origin.y+tbofVoucherDetails.frame.size.height+20, viewforBlanceAmount.frame.size.width, viewforBlanceAmount.frame.size.height)];
            
            [viewforVoucherDetails setFrame:CGRectMake(viewforVoucherDetails.frame.origin.x, tfofVoucherValue.frame.origin.y+voucherheight, viewforVoucherDetails.frame.size.width,viewforBlanceAmount.frame.origin.y+ viewforBlanceAmount.frame.size.height+20)];
            
            
            [viewforPayment setFrame:CGRectMake(viewforPayment.frame.origin.x, viewforVoucherDetails.frame.origin.y+viewforVoucherDetails.frame.size.height, viewforPayment.frame.size.width, viewforPayment.frame.size.height)];
            
            [viewforVoucherDetails setHidden:NO];
            
        } completion:^(BOOL finished) {
           
            if ([SMSCountryUtils isIphone]) {
               [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-10, viewforPayment.frame.origin.y+viewforPayment.frame.size.height)];
                
            }
            else{
                 [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-20, viewforPayment.frame.origin.y+viewforPayment.frame.size.height)];
            }
           
            VoucerClicked = YES;

            lblofBalnceAmountValue.text    = [NSString stringWithFormat:@"%.2f QAR",totalTicketAmount];

            [tfofVoucherValue setHidden:NO];
            [btnApplyVoucher setHidden:NO];
            
            [tbofVoucherDetails reloadData];
        }];
        
     
    }
    else //obtaining data from localdb
    {

        [scUtils hideLoader];
    
    }
    
    
    
}


-(void)handleParserErrorVOUuserdet:(NSError *)error{
    
    [scUtils hideLoader];
    
    //[SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
    
    
}



-(void)handleEventsTicketsBlock:(NSArray *)parsedArr{
    
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    if([parsedArr count]>0)
    {
        NSMutableDictionary *EvnetTickBlock = [parsedArr objectAtIndex:0];
        
        if ([[EvnetTickBlock valueForKey:STATUS] isEqualToString:@"True"] || [[EvnetTickBlock valueForKey:STATUS] isEqualToString:@"true"])
        {
            
            if ([[EvnetTickBlock objectForKey:@"balanceamount"] isEqualToString:@"0"]) {
                
                TicketConfirmViewController *ticketConfi = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"TicketConfirmViewController"];
                singleTon.EventtransactiontimerCount = 1;
                [ticketConfi setNoofEventTickets:[self.dictofEvebntData objectForKey:@"SeatDesc"]];
                [ticketConfi setStrEventOrderID:[EvnetTickBlock objectForKey:@"orderid"]];
                [self.navigationController pushViewController:ticketConfi animated:YES];
                
            }
            else
            {
                //3d payment gateway
                NSString *orderidIs = [EvnetTickBlock objectForKey:EVENT_TICKET_ORDERID];
                WebViewController *webviewVC  =[delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"WebViewController"];
                [webviewVC setStrTitleofView:[NSString stringWithFormat:@"%@",delegateApp.selectedEvent.EventName]];
                singleTon.EventtransactiontimerCount = 1;
                delegateApp.strEventTicketNum   = lblofNoofSeats.text;
                delegateApp.strnoofEventTickets = [self.dictofEvebntData objectForKey:@"SeatDesc"];
                if ([[self.dictofEvebntData objectForKey:@"EventDateIs"] isEqualToString:@""]) {
                    delegateApp.strEventDateasPerCate = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.startDate];
                }
                else{
                    
                    delegateApp.strEventDateasPerCate = [NSString stringWithFormat:@"%@",[self.dictofEvebntData objectForKey:@"EventDateIs"]];
                }
                [webviewVC setStrEventOrderId:orderidIs];
                [self.navigationController pushViewController:webviewVC animated:YES];
            }
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[EvnetTickBlock valueForKey:ERROR_MESSAGE] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}



-(void)handleEventTicketBlockError:(NSError *)error{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}



#pragma mark -- seding lock requesrt resposne received


- (void) handlelockRequestReceived:(NSArray *)parsedArr {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    // if parsed Arr count is greater then zero. Now we can insert the user into localdb if user doesnot exist, if user exists then update localdb data
    
    if([parsedArr count]>0)
    {
        NSMutableDictionary *loginDictionary = [parsedArr objectAtIndex:0];
        
        if ([[loginDictionary valueForKey:STATUS] isEqualToString:@"True"] || [[loginDictionary valueForKey:STATUS] isEqualToString:@"true"])
        {
            UserVO *userVo = [loginDictionary valueForKey:USER_OBJECT];
            userVo.address=@"";
            userVo.password=@"";
            userVo.status=0;
            userVo.verify=@"";
            
            if (![SMSCountryLocalDB isUserExists:userVo.serverId])
            {
                [SMSCountryLocalDB insertUser:userVo];
            }
            
            self.currentSelec.requestedTimeInSec = [[loginDictionary valueForKey:SEAT_LOCK_REQUESTED_TIMEIN_SEC] intValue];
            timeOutInMin=[[loginDictionary valueForKey:SEAT_LOCK_TIMED_OUT_IN_MIN] intValue];
            
            
            
            
            if ([[loginDictionary valueForKey:ERRORCODE] isEqualToString:@"113"])
            {
                [scUtils showLoaderWithTitle:@"" andSubTitle:@"Please wait..."];
                
                [NSTimer scheduledTimerWithTimeInterval:self.currentSelec.requestedTimeInSec target:self selector:@selector(lockConfirmMethoduser:) userInfo:nil repeats:YES];
            }
        }
        else   //Based on error code data will be displayed
        {
            if ([[loginDictionary valueForKey:ERRORCODE] isEqualToString:@"112"])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[loginDictionary valueForKey:ERROR_MESSAGE] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                alert.tag=SEATS_BOOKED_ALERT;
                [alert show];
            }
            else if ([[loginDictionary valueForKey:ERRORCODE] isEqualToString:@"126"])
            {
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[loginDictionary valueForKey:ERROR_MESSAGE]];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[loginDictionary valueForKey:ERROR_MESSAGE] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=SERVER_ERROR_ALERT;
                [alert show];
            }
        }
    }
    else
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
        
    }
    
}
- (void) handleParserErrorUserDe:(NSError *) error
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=SERVER_ERROR_ALERT;
    [alert show];
}


-(void)lockConfirmMethoduser:(NSTimer *)sender
{
    lockRequestTimer=sender;
    if (timercount == timeOutInMin * 60)
    {
        [scUtils hideLoader];
        if (lockRequestTimer != nil)
        {
            [lockRequestTimer invalidate];
            lockRequestTimer=nil;
        }
        timercount=0;
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:TRANSACTION_TIME_OUT delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=TRANSACTIONTIME_OUT;
        [alert show];
    }
    else
    {
        QticketsSingleton *singelTon = [QticketsSingleton sharedInstance];
        [self lockConfirmationRequestWithTransactionID:singelTon.seatCnfmtn.transactionID];
        
        timercount =timercount+5;
       

    }
    
  
    
}


#pragma mark --lock confirmation repsonse received


-(void)handleLoadedLockConfrmtnUserDe:(NSArray *)parserArr
{
    
    if([parserArr count]>0)
    {
        NSMutableDictionary *lockDictionary = [parserArr objectAtIndex:0];
        if ([[lockDictionary valueForKey:STATUS] isEqualToString:@"True"] || [[lockDictionary valueForKey:STATUS] isEqualToString:@"true"])
        {
            if ([[lockDictionary valueForKey:ERRORCODE] isEqualToString:@"119"])
            {
                [scUtils hideLoader];
                if (lockRequestTimer != nil)
                {
                    [lockRequestTimer invalidate];
                    lockRequestTimer=nil;
                }
                
                if (checkseatBlockremaining != nil) {
                    [checkseatBlockremaining invalidate];
                    checkseatBlockremaining = nil;
                }
//                 self.currentSelec.timeOutInMin = 8;
                
                
                self.currentSelec.timeOutInMin = timeOutInMin * 60 - (timercount-10);
                //if lock confirmed then errorcode will be 119 then navigate to next vc
                
                if ([[lockDictionary objectForKey:LOCK_CONFIRMATION_PARAM_2_KEY] isEqualToString:@"0"]) {
                                    
                    TicketConfirmViewController  *ticketConVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"TicketConfirmViewController"];
                    [ticketConVC setCurrentSelec:self.currentSelec];
                    singleTon.transactiontimerCount =  1;
                    [self.navigationController pushViewController:ticketConVC animated:YES];
                }
                else{
                
                PaymentDetailsViewController *paymntVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"PaymentDetailsViewController"];
                [paymntVc setCurrentSelec:self.currentSelec];
                [self.navigationController pushViewController:paymntVc animated:YES];
                }
            }
        }
        else
        {
            if ([[lockDictionary valueForKey:ERRORCODE] isEqualToString:@"112"])
            {
                
                if (lockRequestTimer != nil)
                {
                    [lockRequestTimer invalidate];
                    lockRequestTimer=nil;
                }
                if (checkseatBlockremaining != nil) {
                    [checkseatBlockremaining invalidate];
                    checkseatBlockremaining = nil;
                }
                [scUtils hideLoader];
                
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[lockDictionary valueForKey:ERROR_MESSAGE] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                alert.tag=SEATS_BOOKED_ALERT;
                [alert show];
            }
            else if(![[lockDictionary valueForKey:ERRORCODE] isEqualToString:@"118"])
            {
                if (lockRequestTimer != nil)
                {
                    [lockRequestTimer invalidate];
                    lockRequestTimer=nil;
                }
                if (checkseatBlockremaining != nil) {
                    [checkseatBlockremaining invalidate];
                    checkseatBlockremaining = nil;
                }
                [scUtils hideLoader];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[lockDictionary valueForKey:ERROR_MESSAGE] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=SERVER_ERROR_ALERT;
                [alert show];
            }
        }
    }
    else
    {
        if (lockRequestTimer != nil)
        {
            [lockRequestTimer invalidate];
            lockRequestTimer=nil;
        }
        if (checkseatBlockremaining != nil) {
            [checkseatBlockremaining invalidate];
            checkseatBlockremaining = nil;
        }
        [scUtils hideLoader];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
}
-(void)handleLockCnfmntParserErrorUserDe:(NSError *)error
{
    if (lockRequestTimer != nil)
    {
        [lockRequestTimer invalidate];
        lockRequestTimer=nil;
    }
    if (checkseatBlockremaining != nil) {
        [checkseatBlockremaining invalidate];
        checkseatBlockremaining = nil;
    }
    [scUtils hideLoader];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=SERVER_ERROR_ALERT;
    [alert show];
}

-(void)handleLoadedCancelRequestUserDe:(NSArray *)parserArr
{
  //  NSLog(@"parser response for cancel the booking req :%@",parserArr);
    
    
    if([parserArr count]>0)
    {
        NSMutableDictionary *cancelDictionary = [parserArr objectAtIndex:0];
        
        if ([[cancelDictionary valueForKey:STATUS] isEqualToString:@"True"] || [[cancelDictionary valueForKey:STATUS] isEqualToString:@"true"])
        {
            if (lockRequestTimer != nil)
            {
                [lockRequestTimer invalidate];
                lockRequestTimer=nil;
            }
            if (checkseatBlockremaining != nil) {
                [checkseatBlockremaining invalidate];
                checkseatBlockremaining = nil;
            }
            if (forpushneedtoCancel==NO) {
                
                
           
            if (isCanceled)
            {
                isCanceled = false;
                singleTon.seatCnfmtn=nil;
                if (delegateApp.inTandC == YES) {
                    
                    NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                    
                    int index = 0;
                    for(int i=0 ; i<[arrofNavoagtionsCon count] ; i++)
                    {
                        if([[arrofNavoagtionsCon objectAtIndex:i] isKindOfClass:NSClassFromString(@"BookingViewController")])
                        {
                            index = i;
                            break;
                        }
                    }
                    if (index != 0) {
                        [self.navigationController popToViewController:[arrofNavoagtionsCon objectAtIndex:index] animated:YES];
                        
                    }
                    else{
                        
                        BookingViewController *homeviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"BookingViewController"];
                        [self.navigationController pushViewController:homeviewVC animated:NO];
                        
                    }

                    [scUtils hideLoader];

                    }
                else{
                    
                    [scUtils hideLoader];

                [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else
            {
                singleTon.seatCnfmtn=nil;
                if (delegateApp.inTandC == YES) {
                    
                    NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                    
                    int index = 0;
                    for(int i=0 ; i<[arrofNavoagtionsCon count] ; i++)
                    {
                        if([[arrofNavoagtionsCon objectAtIndex:i] isKindOfClass:NSClassFromString(@"BookingViewController")])
                        {
                            index = i;
                            break;
                        }
                    }
                    if (index != 0) {
                        [self.navigationController popToViewController:[arrofNavoagtionsCon objectAtIndex:index] animated:YES];
                        
                    }
                    else{
                        
                        BookingViewController *homeviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"BookingViewController"];
                        [self.navigationController pushViewController:homeviewVC animated:NO];
                        
                    }

                }
                else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            
                [scUtils hideLoader];

            }
                
            }
            else
            {
                NSLog(@"canceled successfully");
                
                [delegateApp actionforPush];
                
                
                
            }
        }
        else
        {
            if (lockRequestTimer != nil)
            {
                [lockRequestTimer invalidate];
                lockRequestTimer=nil;
            }
            if (checkseatBlockremaining != nil) {
                [checkseatBlockremaining invalidate];
                checkseatBlockremaining = nil;
            }
            [scUtils hideLoader];

            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag=SERVER_ERROR_ALERT;
            [alert show];
        }
    }
    else
    {
        if (lockRequestTimer != nil)
        {
            [lockRequestTimer invalidate];
            lockRequestTimer=nil;
        }
        if (checkseatBlockremaining != nil) {
            [checkseatBlockremaining invalidate];
            checkseatBlockremaining = nil;
        }
        [scUtils hideLoader];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
}

-(void)handleCancelCnfmntParserErrorUserDe:(NSError *)error
{
    if (lockRequestTimer != nil)
    {
        [lockRequestTimer invalidate];
        lockRequestTimer=nil;
    }
    if (checkseatBlockremaining != nil) {
        [checkseatBlockremaining invalidate];
        checkseatBlockremaining = nil;
    }
    [scUtils hideLoader];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=SERVER_ERROR_ALERT;
    [alert show];
}



-(void)handleCheckVoucherDet:(NSArray *)parsedArr{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    if([parsedArr count]>0)
    {
        
            [tfofVoucherValue setText:@""];
        
            singleVoucherApplied = YES;
            
        UserVoucherVO *userVomain = [parsedArr objectAtIndex:0];

        if ([userVomain.voucherBalanceValue isEqualToString:@"0"]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"InValid Voucher" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

        }
        
        else{
        
        if (arrofUserVouchers.count > 0) {
            
            
                UserVoucherVO *userVo = [arrofUserVouchers lastObject];
            
                if (![userVo.voucherCoupon isEqualToString:userVomain.voucherCoupon]) {
                    [arrofUserVouchers addObjectsFromArray:parsedArr];

                }
            
            
        }
        else{
            [arrofUserVouchers addObjectsFromArray:parsedArr];
  
        }
            
        if (arrofCouponCodes.count > 0) {
            
            if (![arrofCouponCodes containsObject:userVomain.voucherCoupon]) {
                 [arrofCouponCodes addObject:[NSString stringWithFormat:@"%@",userVomain.voucherCoupon]];
            }
            
        }
        else{
             [arrofCouponCodes addObject:[NSString stringWithFormat:@"%@",userVomain.voucherCoupon]];
        }
        
            
            NSString *strnoofCalls = [NSString stringWithFormat:@"%lu",(unsigned long)arrofUserVouchers.count-1];
            
            [arrofSelectedVoucherIndex addObject:strnoofCalls];
            
            
//            NSLog(@"arrof selecindes is:%@",arrofSelectedVoucherIndex);
            
            
            [UIView animateWithDuration:0.8 animations:^{
                
                CGFloat rowHeight;
                if ([SMSCountryUtils isIphone]) {
                    
                    rowHeight = 45;
                }
                else{
                    rowHeight = 70;
                }
                
                if (arrofUserVouchers.count > 0) {
                    
                    [lblbalanceHeader setHidden:NO];
                    [lblevoucherHeader setHidden:NO];
                    
                }
                else{
                    
                    [lblevoucherHeader setHidden:YES];
                    [lblbalanceHeader  setHidden:YES];
                }

                [viewforVoucherDetails setFrame:CGRectMake(viewforVoucherDetails.frame.origin.x, tfofVoucherValue.frame.origin.y+40, viewforVoucherDetails.frame.size.width, viewforVoucherDetails.frame.size.height)];
                
                [tbofVoucherDetails setFrame:CGRectMake(tbofVoucherDetails.frame.origin.x, tbofVoucherDetails.frame.origin.y, ViewWidth-10, (arrofUserVouchers.count * rowHeight))];
                
                [tbofVoucherDetails setScrollEnabled:NO];
                
                [viewforBlanceAmount setFrame:CGRectMake(viewforBlanceAmount.frame.origin.x, tbofVoucherDetails.frame.origin.y+tbofVoucherDetails.frame.size.height+20, viewforBlanceAmount.frame.size.width, viewforBlanceAmount.frame.size.height)];
                
                [viewforVoucherDetails setFrame:CGRectMake(viewforVoucherDetails.frame.origin.x, tfofVoucherValue.frame.origin.y+40, viewforVoucherDetails.frame.size.width,viewforBlanceAmount.frame.origin.y+ viewforBlanceAmount.frame.size.height+20)];
                
                
                [viewforPayment setFrame:CGRectMake(viewforPayment.frame.origin.x, viewforVoucherDetails.frame.origin.y+viewforVoucherDetails.frame.size.height, viewforPayment.frame.size.width, viewforPayment.frame.size.height)];

                [viewforVoucherDetails setHidden:NO];
                
                
                

            } completion:^(BOOL finished) {
                
                if ([SMSCountryUtils isIphone]) {
                    
                        [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-10, viewforPayment.frame.origin.y+viewforPayment.frame.size.height)];
                }
                else{
                        [scrollofUserDetails setContentSize:CGSizeMake(ViewWidth-20, viewforPayment.frame.origin.y+viewforPayment.frame.size.height)];
                }
                
                lblofBalnceAmountValue.text    = [NSString stringWithFormat:@"%.2f QAR",totalTicketAmount];
                [lblofVoucherAmountValue setText:[NSString stringWithFormat:@"%@",userVomain.voucherBalanceValue]];
                
              
                
                allVoucherAmounts += [[NSString stringWithFormat:@"%@",userVomain.voucherBalanceValue] floatValue];
                if (allVoucherAmounts > totalTicketAmount) {
                    
                    lblofVoucherAmountValue.text = [NSString stringWithFormat:@"%.2f QAR",totalTicketAmount];
                    
                    lblofBalnceAmountValue.text    = [NSString stringWithFormat:@"%@ QAR",@"0.00"];
                    strBalanceAmount = @"0";
                    strVoucherAmount = [NSString stringWithFormat:@"%.2f",totalTicketAmount];
                    
                }
                else{
                    
                     lblofVoucherAmountValue.text = [NSString stringWithFormat:@"%.2f QAR",allVoucherAmounts];
                    lblofBalnceAmountValue.text    = [NSString stringWithFormat:@"%.2f QAR",totalTicketAmount-allVoucherAmounts];
                    strBalanceAmount = [NSString stringWithFormat:@"%.2f",totalTicketAmount-allVoucherAmounts];
                     strVoucherAmount = [NSString stringWithFormat:@"%.2f",allVoucherAmounts];
                }
                
               
                
                [tbofVoucherDetails reloadData];
            }];

            
            noofTimesVoucherCalled ++;
            
            
    }
    }
    else{
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Invalid Coupon" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    
        
}

-(void)handleCheckVoucherErrorUserDe:(NSError *)error{
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}



#pragma mark
#pragma mark PickerView Datasource Methods
#pragma mark

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  singleTon.arrofCountryDetails.count;
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


-(IBAction)btnTandCclikced:(id)sender
{
    
    TandCViewController *tandC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"TandCViewController"];
    [self.navigationController pushViewController:tandC animated:YES];
    
    
}




-(IBAction)btnTandCChekcmarClicked:(id)sender
{
    if (tandcBool == NO) {
        
        [btntcCheckMark setSelected:YES];
        tandcBool = YES;
    }
    else{
        [btntcCheckMark setSelected:NO];
        tandcBool = NO;
    }
}


-(IBAction)btnCacelClicked:(id)sender{
    
    [viewforCustomALert setHidden:NO];
    [scrollofUserDetails  bringSubviewToFront:viewforCustomALert];
    
    
    
}


- (IBAction)btnAlertCancelClicked:(id)sender {
    
    [viewforCustomALert setHidden:YES];
}


- (IBAction)btnAlertOkClicked:(id)sender {
    
    [viewforCustomALert setHidden:YES];

    if (singleTon.isMovieSelected) {
        [self cancelRequestWithTransactionId:singleTon.seatCnfmtn.transactionID];
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
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
