//
//  PaymentDetailsViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "PaymentDetailsViewController.h"
#import "Q-ticketsConstants.h"
#import "TicketConfirmViewController.h"
#import "AppDelegate.h"
#import "EGOImageView.h"
#import "MarqueeLabel.h"
#import "QticketsSingleton.h"
#import "SMSCountryConnections.h"
#import "SMSCountryLocalDB.h"
#import "SMSCountryUtils.h"
#import "CommonParseOperation.h"
#import "PaymentParseOperation.h"
#import "CancelRequestParseOpeartion.h"
#import "HomeViewController.h"
#import "SelectNationalityViewController.h"
#import "PaymentWebViewController.h"
#import "SMSCountryUtils.h"



@interface PaymentDetailsViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,SMSCountryConnectionDelegate,CommonParseOperationDelegate,UIAlertViewDelegate>{
    
    
     IBOutlet UILabel       *lblViewtitle;
    
    //for movie details
    IBOutlet EGOImageView *imgforMovie;
    IBOutlet MarqueeLabel  *lblMoviebnamewithRating;
    IBOutlet UILabel      *lbldateOfmovie;
    IBOutlet UILabel      *lbltimeofMovie;
    IBOutlet MarqueeLabel *lblplaceofMovie;
    IBOutlet UILabel      *lblscrennOfmovie;
    
    //for seat deatails
    IBOutlet UILabel      *lblTicketPriceValue;
    IBOutlet UILabel      *lblofServieChargeValue;
    IBOutlet UILabel      *lblofFinalTotalValue;

    
    
    
    
    
     IBOutlet UIScrollView  *scrollviewofDetails;
     IBOutlet UIImageView   *imgviewofNameofCardbg;
     IBOutlet UITextField   *tfofNameofCard;
     IBOutlet UIImageView   *imgviewofCardNum;
     IBOutlet UIImageView  *imgviewiofMM;
     IBOutlet UIImageView  *imgviewiofYYYY;
     IBOutlet UIImageView  *imgviewofScode;
     IBOutlet UITextField  *tfofCardNumber;
     IBOutlet UITextField  *tfofScodeNumber;

        //for custom alertview
    IBOutlet UIView        *viewforAlertView;
    
    IBOutlet EGOImageView  *imgviewofBg;
    AppDelegate            *delegateApp;
    
    IBOutlet UILabel          *lblSelectedSeatNumbers;
    
    IBOutlet UILabel          *lblTimerdetails;
    
    
    NSMutableArray            *connectionsArr;
    NSOperationQueue          *queue;
    NSMutableArray            *parsersArr;
    NSString                  *transactionresponse;
//    NSTimer                   *cardtransactionTimer;
    int                        timeOutInMin;
    int                        timercount;
    NSInteger                  textFieldTag;
    NSArray *monthArr;
    NSMutableArray *yearArr;

    
    UIPickerView *monthPicker;
    UIPickerView *yearPicker;
    
    IBOutlet UITextField   *tfofExpireMonth;
    IBOutlet UITextField   *tfofExpireYear;
    IBOutlet UILabel       *lblImdbrating;
    IBOutlet UILabel       *lblofNoofSeats;
    
    IBOutlet UIButton      *btnSubmit;
    IBOutlet UIButton      *btnCancel;
    IBOutlet UILabel       *lbloftopBlusstrip;
    IBOutlet UIImageView   *imgviewofCardType;
    NSTimer *timerfortrans;
    
    IBOutlet UIImageView   *imgviewofNationalitybg;
    IBOutlet UIImageView   *imgviewofNationalityIcon;
    IBOutlet UIButton      *btnNationality;
    IBOutlet UIImageView   *imgviewofUserIcon;
    IBOutlet UIImageView   *imgviewofCvvIcon;
    
    
    
    IBOutlet UIButton      *btnVisaMasterCard;
    IBOutlet UIButton      *btnAmericanExpres;
    IBOutlet UIButton      *btnDohaBank;
    IBOutlet UIButton      *btnNapsTransfer;

    int selectedCardIndex;
    
    CGFloat natBgYCoor,natIconYCoor,natBtnYCoor,submitbtnYCoor,cancelbtnYCoor,blacklineYCoor,bottombgimgviewYCoor,bottomlogoimgViewYCoor;
    BOOL visaCardClicked;
    
    IBOutlet UILabel      *lblblackline;
    IBOutlet UIImageView  *imgviewofbottombg;
    IBOutlet UIImageView  *imgviewofbottomlogo;
    IBOutlet UIImageView  *imgviewofimdblogo;

    QticketsSingleton     *singlton;
    int cardNumberCount,CvvCount;
    SMSCountryUtils   *scutilits;
    
    BOOL forpushneedtoCancel;
    
}

@end

@implementation PaymentDetailsViewController
@synthesize currentSelec;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *str = @"fromPY";
    [USERDEFAULTS setObject:str forKey:@"toBackGround"];
    USERDEFAULTSAVE;
    singlton = [QticketsSingleton sharedInstance];
    

    connectionsArr   = [[NSMutableArray alloc] init];
    parsersArr       = [[NSMutableArray alloc] init];
    queue            = [[NSOperationQueue alloc] init];
    timercount = 1;
    selectedCardIndex = 1;
    visaCardClicked = YES;
    forpushneedtoCancel = NO;
    [self SetSelectedBack:selectedCardIndex];
    
    
    yearArr = [[NSMutableArray alloc]init];
    [viewforAlertView setHidden:YES];
    
    delegateApp   = QTicketsAppDelegate;
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
    }

    if (ViewHeight == 480) {
    
        [btnSubmit setFrame:CGRectMake(btnSubmit.frame.origin.x, btnSubmit.frame.origin.y+90, btnSubmit.frame.size.width, btnSubmit.frame.size.height)];
        [btnCancel setFrame:CGRectMake(btnCancel.frame.origin.x,btnCancel.frame.origin.y+90, btnCancel.frame.size.width, btnCancel.frame.size.height)];
        
        [lblblackline setFrame:CGRectMake(lblblackline.frame.origin.x, btnCancel.frame.origin.y+btnCancel.frame.size.height+25, lblblackline.frame.size.width, lblblackline.frame.size.height)];
        
        [imgviewofbottombg setFrame:CGRectMake(imgviewofbottombg.frame.origin.x, lblblackline.frame.origin.y+2, imgviewofbottombg.frame.size.width, imgviewofbottombg.frame.size.height)];
        [imgviewofbottomlogo setFrame:CGRectMake(imgviewofbottomlogo.frame.origin.x, lblblackline.frame.origin.y+2, imgviewofbottomlogo.frame.size.width, imgviewofbottomlogo.frame.size.height)];
        
        [scrollviewofDetails setContentSize:CGSizeMake(ViewWidth-20, ViewHeight+100)];
        

    }
    
    
    [self setInitialSetupforPayment];
    
    
    [tfofCardNumber addTarget:self action:@selector(textFieldChangedforCard:) forControlEvents:UIControlEventEditingChanged];
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequestforPushPD) name:@"PushClicked" object:nil];

    
    
}


-(void)cancelRequestforPushPD{
    
    forpushneedtoCancel = YES;
    
    
    
    [viewforAlertView setHidden:NO];

    
    
        
//        NSLog(@"for pusher cancel request called. payment..");
//    QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
//    [self cancelRequestWithTransactionId:singleTon.seatCnfmtn.transactionID];
    
    
    
    
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

-(void)setInitialSetupforPayment{

    [imgviewofNameofCardbg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofNameofCardbg.layer setBorderWidth: 1.0];
    
    
    [imgviewofCardNum.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofCardNum.layer setBorderWidth: 1.0];
    
    
    [imgviewiofMM.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewiofMM.layer setBorderWidth: 1.0];
    
    [imgviewiofYYYY.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewiofYYYY.layer setBorderWidth: 1.0];
    
    
    [imgviewofScode.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofScode.layer setBorderWidth: 1.0];

    [imgviewofNationalitybg.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [imgviewofNationalitybg.layer setBorderWidth: 1.0];

    singlton.timerforPaymentConfirm = self.currentSelec.timeOutInMin;
    timeOutInMin=self.currentSelec.timeOutInMin;

    timerfortrans = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(lockConfirmMethod:) userInfo:@"" repeats:YES];
    
    monthArr = [[NSArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    monthPicker = [[UIPickerView alloc]init];
    monthPicker.delegate=self;
    monthPicker.dataSource=self;
    monthPicker.tag = MONTHS_PICKER;
    [monthPicker sizeToFit];
    monthPicker.showsSelectionIndicator=YES;
    tfofExpireMonth.inputView=monthPicker;
    tfofExpireMonth.inputAccessoryView=[self toolbarWithUIBarButtonItemWithTag:tfofExpireMonth.tag];
    
    yearPicker = [[UIPickerView alloc]init];
    yearPicker.delegate=self;
    yearPicker.dataSource=self;
    [yearPicker sizeToFit];
    yearPicker.tag=YEARS_PICKER;
    yearPicker.showsSelectionIndicator=YES;
   
    tfofExpireYear.inputView=yearPicker;
    tfofExpireYear.inputAccessoryView=[self toolbarWithUIBarButtonItemWithTag:tfofExpireYear.tag];
    
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
               style:UIBarButtonItemStylePlain target:self action:@selector(doneClickedpay:)];
    UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self
                   action:@selector(previousBtnClickedpay:)];
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
           style:UIBarButtonItemStylePlain target:self   action:@selector(nextBtnClickedpay:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:previousButton,nextButton,doneButton, nil]];
    
    tfofNameofCard.inputAccessoryView=keyboardDoneButtonView;
    tfofCardNumber.inputAccessoryView=keyboardDoneButtonView;
    tfofScodeNumber.inputAccessoryView=keyboardDoneButtonView;
    
    imgforMovie                 = [imgforMovie initWithPlaceholderImage:[UIImage imageNamed:@"bg.png"]];
    imgforMovie.imageURL        = [NSURL URLWithString:[NSString stringWithFormat:@"%@",delegateApp.selectedMovie.strMovieThumurlis]];
    
    lblMoviebnamewithRating.marqueeType    = MLContinuous;
    lblMoviebnamewithRating.trailingBuffer = 15.0f;
    
    lblplaceofMovie.marqueeType            = MLContinuous;
    lblplaceofMovie.trailingBuffer         = 15.0;
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
    
    lbldateOfmovie.text = [NSString stringWithFormat:@"%@,%@,%@",showDayis,showDateis,showMonthis];
    
    lblplaceofMovie.text = [NSString stringWithFormat:@"%@ , %@",[self.currentSelec.theaterName uppercaseStringWithLocale:[NSLocale currentLocale]],self.currentSelec.strTheaterNameArabic];
    
    lbltimeofMovie.text  = self.currentSelec.showTime;
    
    lblscrennOfmovie.text = self.currentSelec.screenName;
    if ([self.currentSelec.movieimdbRating isEqualToString:@"NA"]) {
        
        [lblImdbrating setHidden:YES];
        [imgviewofimdblogo setHidden:YES];
        
    }
    else{
        
        [lblImdbrating setHidden:NO];
        [imgviewofimdblogo setHidden:NO];
        lblImdbrating.text    = [NSString stringWithFormat:@"%@/10",self.currentSelec.movieimdbRating];
    }
    

//    lblImdbrating.text    = [NSString stringWithFormat:@"%@/10",self.currentSelec.movieimdbRating];
    lblSelectedSeatNumbers.text   = [NSString stringWithFormat:@"%@",[self.currentSelec.selectedSeatsArr objectAtIndex:0]];
    
    lblofNoofSeats.text=[NSString stringWithFormat:@"%lu",(unsigned long)[[[self.currentSelec.selectedSeatsArr objectAtIndex:0]componentsSeparatedByString:@","]count]];

    QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
    
    lblTicketPriceValue.text=[NSString stringWithFormat:@"%.2f QAR",singleTon.seatCnfmtn.ticketprice];
    lblofServieChargeValue.text=[NSString stringWithFormat:@"%.2f QAR",singleTon.seatCnfmtn.serviceCharges];
    lblofFinalTotalValue.text= [NSString stringWithFormat:@"%.2f QAR",singleTon.seatCnfmtn.totalPrice];

    if ([SMSCountryUtils isIphone]) {
        [scrollviewofDetails setContentSize:CGSizeMake(ViewWidth-20, ViewHeight+100)];
    }
    else{
        
        [scrollviewofDetails setContentSize:CGSizeMake(ViewWidth-20, ViewHeight-200)];
    }
    
    
    [self getNextTenYearsFromCurrentYear];
    
}

-(void)getNextTenYearsFromCurrentYear
{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"yyyy"];
    
    //obtaining next 7 dates from current date
    
    for (int j=0;j<=10;j++)
    {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:j];
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
        NSDate *newDate2 = [cal dateByAddingComponents:components toDate:now options:0];
        [yearArr addObject:[dateFormate stringFromDate:newDate2]];
    }
    
    // NSLog(@"ß®YearsArr:%i",yearArr.count);
    
}

-(UIToolbar *)toolbarWithUIBarButtonItemWithTag:(NSInteger)tag
{
    UIToolbar *pickertoolbar = [[UIToolbar alloc] init];
    pickertoolbar.barStyle = UIBarStyleBlack;
    pickertoolbar.translucent = YES;
    pickertoolbar.tintColor = nil;
    [pickertoolbar sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneButtonClicked:)];
    [doneButton setTag:tag];
    [pickertoolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    
    return pickertoolbar;
}

- (void)doneButtonClicked:(id)sender
{
    if ([sender tag] == tfofExpireMonth.tag)
    {
        [tfofExpireMonth resignFirstResponder];
        [scrollviewofDetails setContentOffset:CGPointMake(0,0) animated:YES];
    }
    else  if ([sender tag] == tfofExpireYear.tag)
    {
        [tfofExpireYear resignFirstResponder];
        [scrollviewofDetails setContentOffset:CGPointMake(0,0) animated:YES];
    }
    
}

-(void)nextBtnClickedpay:(id)sender
{
    if (textFieldTag == tfofNameofCard.tag)
    {
        [tfofNameofCard resignFirstResponder];
        [tfofCardNumber becomeFirstResponder];
    }
    else if (textFieldTag == tfofCardNumber.tag)
    {
        [tfofCardNumber resignFirstResponder];
        [tfofExpireMonth becomeFirstResponder];
    }
    else if (textFieldTag == tfofExpireMonth.tag)
    {
        [tfofExpireMonth resignFirstResponder];
        [tfofExpireYear becomeFirstResponder];
        
    }
    else if (textFieldTag == tfofExpireYear.tag)
    {
        [tfofExpireYear resignFirstResponder];
        [tfofScodeNumber becomeFirstResponder];
        
    }
    else if (textFieldTag == tfofScodeNumber.tag)
    {
        [scrollviewofDetails setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofScodeNumber resignFirstResponder];
        
    }
    
}

-(void)previousBtnClickedpay:(id)sender
{
    if (textFieldTag == tfofNameofCard.tag)
    {
        [scrollviewofDetails setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofNameofCard resignFirstResponder];
    }
    else if (textFieldTag == tfofCardNumber.tag)
    {
        [tfofCardNumber resignFirstResponder];
        [tfofNameofCard becomeFirstResponder];
    }
    else if (textFieldTag == tfofExpireMonth.tag)
    {
        [tfofExpireMonth resignFirstResponder];
        [tfofExpireYear becomeFirstResponder];
    }
    else if (textFieldTag == tfofExpireYear.tag)
    {
        [tfofExpireYear resignFirstResponder];
        [tfofCardNumber becomeFirstResponder];
    }
    else if (textFieldTag == tfofScodeNumber.tag)
    {
        [scrollviewofDetails setContentOffset:CGPointMake(0,0) animated:YES];
        [tfofScodeNumber resignFirstResponder];
        [tfofExpireMonth becomeFirstResponder];
    }
    
}
- (void)doneClickedpay:(id)sender {
    
    [[self.view viewWithTag:tfofNameofCard.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofCardNumber.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofExpireMonth.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofExpireYear.tag] resignFirstResponder];
    [[self.view viewWithTag:tfofScodeNumber.tag] resignFirstResponder];
    [scrollviewofDetails setContentOffset:CGPointMake(0,0) animated:YES];
}


-(IBAction)btnVisaMaserCardClicked:(id)sender
{
    btnSubmit.hidden = false;
    selectedCardIndex = 1;
    [self SetSelectedBack:selectedCardIndex];
    
}
-(IBAction)btnAmericanExpreClicked:(id)sender
{
    btnSubmit.hidden = false;
    selectedCardIndex = 2;
    [self SetSelectedBack:selectedCardIndex];
    visaCardClicked = NO;
 

}
-(IBAction)btnDoahBankClicked:(id)sender
{
    btnSubmit.hidden = false;
    selectedCardIndex = 3;
    [self SetSelectedBack:selectedCardIndex];
    visaCardClicked = NO;


}
-(IBAction)btnNapsTransClicked:(id)sender
{

    selectedCardIndex = 4;
    [self SetSelectedBack:selectedCardIndex];
    visaCardClicked = NO;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NAPS_DISABLED_MESSAGE delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    btnSubmit.hidden = true;

}

-(IBAction)btnNationalityClickedonPay:(id)sender{
    
    SelectNationalityViewController *selectnation = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"SelectNationalityViewController"];
    [self.navigationController pushViewController:selectnation animated:YES];

    
}

-(void)SetSelectedBack:(NSInteger )selectedIs{
    
    
    switch (selectedIs) {
        case 1:
            [btnVisaMasterCard setSelected:YES];
            [btnAmericanExpres setSelected:NO];
            [btnDohaBank setSelected:NO];
            [btnNapsTransfer setSelected:NO];
            if (visaCardClicked==NO) {
                [self showCardDetails];
            }
            visaCardClicked = YES;
            cardNumberCount = 16;
            CvvCount = 3;
            break;
        case 2:
            [btnVisaMasterCard setSelected:NO];
            [btnAmericanExpres setSelected:YES];
            [btnDohaBank setSelected:NO];
            [btnNapsTransfer setSelected:NO];
            [self showCardDetails];
            cardNumberCount = 15;
            CvvCount = 4;
            break;
        case 3:
            [btnVisaMasterCard setSelected:NO];
            [btnAmericanExpres setSelected:NO];
            [btnDohaBank setSelected:YES];
            [btnNapsTransfer setSelected:NO];
            [self hideCardDetails];
            break;
        case 4:
            [btnVisaMasterCard setSelected:NO];
            [btnAmericanExpres setSelected:NO];
            [btnDohaBank setSelected:NO];
            [btnNapsTransfer setSelected:YES];
            [self hideCardDetails];
            break;
        default:
            break;
    }
    
    [tfofCardNumber setText:@""];
    [tfofExpireMonth setText:@""];
    [tfofExpireYear setText:@""];
    [tfofNameofCard setText:@""];
    [tfofScodeNumber setText:@""];
    
    if ([SMSCountryUtils isIphone]) {
        
        if (ViewWidth == iPhone6PlusWidth) {
            
            imgviewofCardType.image = [UIImage imageNamed:@"icon-card@3x.png"];
            
        }
        else{
            
            imgviewofCardType.image = [UIImage imageNamed:@"icon-card.png"];
            
            
        }
        
    }
    else{
        imgviewofCardType.image = [UIImage imageNamed:@"icon-card~ipad.png"];
    }
    

    
    
    
}

-(void)showCardDetails{
    
    
    
    
    
    [UIView animateWithDuration:0.8 animations:^{
        [imgviewofNationalitybg setFrame:CGRectMake(imgviewofNationalitybg.frame.origin.x, natBgYCoor, imgviewofNationalitybg.frame.size.width, imgviewofNationalitybg.frame.size.height)];
        [imgviewofNationalityIcon setFrame:CGRectMake(imgviewofNationalityIcon.frame.origin.x, natIconYCoor, imgviewofNationalityIcon.frame.size.width, imgviewofNationalityIcon.frame.size.height)];
        [btnNationality setFrame:CGRectMake(btnNationality.frame.origin.x, natBtnYCoor, btnNationality.frame.size.width, btnNationality.frame.size.height)];
        [btnSubmit setFrame:CGRectMake(btnSubmit.frame.origin.x,submitbtnYCoor, btnSubmit.frame.size.width, btnSubmit.frame.size.height)];
        [btnCancel setFrame:CGRectMake(btnCancel.frame.origin.x, cancelbtnYCoor, btnCancel.frame.size.width, btnCancel.frame.size.height)];
        
        [lblblackline setFrame:CGRectMake(lblblackline.frame.origin.x, blacklineYCoor, lblblackline.frame.size.width, lblblackline.frame.size.height)];
        [imgviewofbottombg setFrame:CGRectMake(imgviewofbottombg.frame.origin.x, bottombgimgviewYCoor, imgviewofbottombg.frame.size.width, imgviewofbottombg.frame.size.height)];
        [imgviewofbottomlogo setFrame:CGRectMake(imgviewofbottomlogo.frame.origin.x, bottomlogoimgViewYCoor, imgviewofbottomlogo.frame.size.width, imgviewofbottomlogo.frame.size.height)];

        
    } completion:^(BOOL finished) {
        
        [imgviewofNameofCardbg setHidden:NO];
        [imgviewofUserIcon setHidden:NO];
        [tfofNameofCard setHidden:NO];
        
        [imgviewofCardNum setHidden:NO];
        [imgviewofCardType setHidden:NO];
        [tfofCardNumber setHidden:NO];
        
        [imgviewiofMM setHidden:NO];
        [tfofExpireMonth setHidden:NO];
        
        [imgviewiofYYYY setHidden:NO];
        [tfofExpireYear setHidden:NO];
        
        [imgviewofScode setHidden:NO];
        [imgviewofCvvIcon setHidden:NO];
        [tfofScodeNumber setHidden:NO];
        
        
        if ([SMSCountryUtils isIphone]) {
            [scrollviewofDetails setContentSize:CGSizeMake(ViewWidth-20, ViewHeight+100)];
        }
        else{
            [scrollviewofDetails setContentSize:CGSizeMake(ViewWidth-20, ViewHeight-200)];
        }
        

        
    }];

    
   
    
    
   
}

-(void)hideCardDetails{
    
    
    
    
    [UIView animateWithDuration:0.8 animations:^{
        
        [imgviewofNameofCardbg setHidden:YES];
        [imgviewofUserIcon setHidden:YES];
        [tfofNameofCard setHidden:YES];
        
        [imgviewofCardNum setHidden:YES];
        [imgviewofCardType setHidden:YES];
        [tfofCardNumber setHidden:YES];
        
        [imgviewiofMM setHidden:YES];
        [tfofExpireMonth setHidden:YES];
        
        [imgviewiofYYYY setHidden:YES];
        [tfofExpireYear setHidden:YES];
        
        [imgviewofScode setHidden:YES];
        [imgviewofCvvIcon setHidden:YES];
        [tfofScodeNumber setHidden:YES];
        
        [imgviewofNationalitybg setFrame:imgviewofNameofCardbg.frame];
        [imgviewofNationalityIcon setFrame:imgviewofUserIcon.frame];
        [btnNationality setFrame:CGRectMake(btnNationality.frame.origin.x, tfofNameofCard.frame.origin.y, btnNationality.frame.size.width, btnNationality.frame.size.height)];
        [btnSubmit setFrame:CGRectMake(btnSubmit.frame.origin.x, tfofCardNumber.frame.origin.y, btnSubmit.frame.size.width, btnSubmit.frame.size.height)];
        [btnCancel setFrame:CGRectMake(btnCancel.frame.origin.x, tfofExpireMonth.frame.origin.y, btnCancel.frame.size.width, btnCancel.frame.size.height)];
        [lblblackline setFrame:CGRectMake(lblblackline.frame.origin.x, tfofScodeNumber.frame.origin.y, lblblackline.frame.size.width, lblblackline.frame.size.height)];
        [imgviewofbottombg setFrame:CGRectMake(imgviewofbottombg.frame.origin.x, lblblackline.frame.origin.y+2, imgviewofbottombg.frame.size.width, imgviewofbottombg.frame.size.height)];
        [imgviewofbottomlogo setFrame:CGRectMake(imgviewofbottomlogo.frame.origin.x, imgviewofbottombg.frame.origin.y+2, imgviewofbottomlogo.frame.size.width, imgviewofbottomlogo.frame.size.height)];

        
    } completion:^(BOOL finished) {
        
       
        if ([SMSCountryUtils isIphone]) {
            [scrollviewofDetails setContentSize:CGSizeMake(ViewWidth-20, ViewHeight+100)];
        }
        else{
            [scrollviewofDetails setContentSize:CGSizeMake(ViewWidth-20, 600)];
        }
        
        
        

    }];
    

    
}





-(void)lockConfirmMethod:(NSTimer *)sender
{
    
    
    if (singlton.timerforPaymentConfirm <= 0) {
        
        if (timerfortrans != nil) {
            
            [timerfortrans invalidate];
            timerfortrans = nil;
        }
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:TRANSACTION_TIME_OUT delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=TRANSACTIONTIME_OUT;
        [alert show];
        
    }
    else{
        
        singlton.timerforPaymentConfirm = singlton.timerforPaymentConfirm - 1;

        lblTimerdetails.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Remaining Time %02i:%02i",(singlton.timerforPaymentConfirm/60),(singlton.timerforPaymentConfirm%60)]];
        
        NSMutableAttributedString *text =
        [[NSMutableAttributedString alloc]
         initWithAttributedString: lblTimerdetails.attributedText];
        
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor greenColor]
                     range:NSMakeRange(15, 5)];
        [lblTimerdetails setAttributedText: text];
    }
    
    
    
}



#pragma mark
#pragma mark AlertView Delegate
#pragma mark

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (alertView.tag == CANCEL_ALERT)
//    {
//        if (buttonIndex == 1)
//        {
//            QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
//            [self cancelRequestWithTransactionId:singleTon.seatCnfmtn.transactionID];
//        }
//    }
//    else
    
        if (alertView.tag == TRANSACTIONTIME_OUT)
    {
        if (buttonIndex == 0)
        {
            QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
            
            [scutilits showLoaderWithTitle:@"" andSubTitle:PROCESSING];

            [self cancelRequestWithTransactionId:singleTon.seatCnfmtn.transactionID];
        }
    }
    else if (alertView.tag == SERVER_ERROR_ALERT)
    {
        if (buttonIndex == 0)
        {
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


//-(void)cancelNumberPad{
//    [tfofCardNumber resignFirstResponder];
//    tfofCardNumber.text = @"";
//}
//
//-(void)doneWithNumberPad{
//    [tfofCardNumber resignFirstResponder];
//}
//
//




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)btnSubmitClicked:(id)sender{
    
    
    
    /*
    TicketConfirmViewController *ticktconfirmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TicketConfirmViewController"];
    [ticktconfirmvc setPaymentStatus:YES];
    [self.navigationController pushViewController:ticktconfirmvc animated:YES];*/
    
    if (selectedCardIndex == 1|| selectedCardIndex == 2) {
        
  
    if (tfofNameofCard.text.length<=0)
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_NAME_ON_CARD];
    }
    else
    {
        if (tfofCardNumber.text.length<=0)
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_CARD_NUMEBR];
        }
        else if (tfofCardNumber.text.length < cardNumberCount){
            
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_VALID_CARD_NUMEBR];
        }
        else
        {
            if (tfofExpireMonth.text.length<=0)
            {
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_EXPIRY_DATE];
            }
            else if (tfofExpireYear.text.length<=0){
                
                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_EXPIRY_MONTH];
            }
            else
            {
                if (tfofScodeNumber.text.length<=0)
                {
                    [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_SCODE];
                }
                else if (tfofScodeNumber.text.length < CvvCount){
                    
                     [SMSCountryUtils showAlertMessageWithTitle:@"" Message:PLEASE_ENTER_VALID_SCODE];
                }
                else
                {
                    if ([btnNationality.titleLabel.text isEqualToString:@"Nationality"]) {
                        
//                        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SELECT_NATIONALITY];
                        
                        [btnNationality setTitle:@"  " forState:UIControlStateNormal];
                        
                    }
//                    else{
//
                    
                            QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
                            singleTon.selectedBankis = selectedCardIndex;
                            [self paymentForTicketsWithTransactionID:singleTon.seatCnfmtn.transactionID andName:tfofNameofCard.text andAmount:[NSString stringWithFormat:@"%f",singleTon.seatCnfmtn.totalPrice] andCardNumber:tfofCardNumber.text andexpiryDate:[NSString stringWithFormat:@"%@%@",[tfofExpireYear.text substringFromIndex: [tfofExpireYear.text length] - 2],tfofExpireMonth.text] andScode:tfofScodeNumber.text withNationality:[NSString stringWithFormat:@"%@",btnNationality.titleLabel.text]];
                      
//                      }
                }
            }
        }
    }
    }
    else{
        if ([btnNationality.titleLabel.text isEqualToString:@"Nationality"]) {
            
//            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SELECT_NATIONALITY];
            
            [btnNationality setTitle:@" " forState:UIControlStateNormal];
            
        }
//        else{
        
            PaymentWebViewController *paymentDetails = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"PaymentWebViewController"];
            [paymentDetails setCurrentSelec:self.currentSelec];
            [paymentDetails setSelectedBankIndexIs:selectedCardIndex];
            [paymentDetails setStrNationalityIS:[NSString stringWithFormat:@"%@",btnNationality.titleLabel.text]];
             QticketsSingleton *singleTon2 = [QticketsSingleton sharedInstance];
            [paymentDetails setStrTransactionIdis:singleTon2.seatCnfmtn.transactionID];
            [self.navigationController pushViewController:paymentDetails animated:YES];
            
            
//        }

        
    }

}


-(IBAction)btnCancelClicked:(id)sender{
    
    [viewforAlertView setHidden:NO];
    
}
-(IBAction)btnAlertCancelClicked:(id)sender
{
    
    [viewforAlertView setHidden:YES];
}

-(IBAction)btnAlertOkClicked:(id)sender
{
    //cancel the payment and go...confirmation
    
    [viewforAlertView setHidden:YES];
    
    QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
    [self cancelRequestWithTransactionId:singleTon.seatCnfmtn.transactionID];


}
#pragma mark
#pragma mark Service Calls
#pragma mark

-(void)cancelRequestWithTransactionId:(NSString *)transactnID
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn cancelRequestWithTransactionId:transactnID];
    [connectionsArr addObject:conn];
}

-(void)paymentForTicketsWithTransactionID:(NSString *)transactnId andName:(NSString *)name andAmount:(NSString *)totalPaid andCardNumber:(NSString *)cardNumber andexpiryDate:(NSString *)expirDate andScode:(NSString *)scode withNationality:(NSString *)nationality
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn paymentForTicketsWithTransactionID:transactnId andName:name andAmount:totalPaid andCardNumber:cardNumber andexpiryDate:expirDate andScode:scode withNationality:nationality];
    [connectionsArr addObject:conn];
}

#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:PAYMENT_FOR_TICKETS]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        PaymentParseOperation *pParser = [[PaymentParseOperation alloc] initWithData:data delegate:self andRequestMessage:PAYMENT_FOR_TICKETS];
        
        [queue addOperation:pParser];
        [parsersArr addObject:pParser];
        data = nil;
    }
    
    if ([reqMessage isEqualToString:PAYMENT_FOR_TICKETS_AMEX]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        PaymentParseOperation *pParser = [[PaymentParseOperation alloc] initWithData:data delegate:self andRequestMessage:PAYMENT_FOR_TICKETS_AMEX];
        
        [queue addOperation:pParser];
        [parsersArr addObject:pParser];
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
}

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:PAYMENT_FOR_TICKETS])
    {
        if (timerfortrans != nil) {
            
            [timerfortrans invalidate];
            timerfortrans = nil;
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
    if ([reqMessage isEqualToString:CANCEL_CONFIRMATION])
    {
        if (timerfortrans != nil) {
            
            [timerfortrans invalidate];
            timerfortrans = nil;
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
}
#pragma mark
#pragma mark CommonParserOperation Delegate methods
#pragma mark

- (void)didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr {
    
    if ([reqMsg isEqualToString:PAYMENT_FOR_TICKETS]) {
        [self performSelectorOnMainThread:@selector(handleLoadedpayment:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
    if ([reqMsg isEqualToString:PAYMENT_FOR_TICKETS_AMEX]) {
        [self performSelectorOnMainThread:@selector(handleLoadedpayment:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
    
    if ([reqMsg isEqualToString:CANCEL_CONFIRMATION]) {
        [self performSelectorOnMainThread:@selector(handleLoadedCancelRequest:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:PAYMENT_FOR_TICKETS]) {
        [self performSelectorOnMainThread:@selector(handleParserError:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:PAYMENT_FOR_TICKETS_AMEX]) {
        [self performSelectorOnMainThread:@selector(handleParserError:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:CANCEL_CONFIRMATION]) {
        [self performSelectorOnMainThread:@selector(handleCancelCnfmntParserError:) withObject:error waitUntilDone:NO];
    }
    queue = nil;
}

#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark

- (void) handleLoadedpayment:(NSArray *)parsedArr {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    
    // if parsed Arr count is greater then zero. Now we can insert the user into localdb if user doesnot exist, if user exists then update localdb data
    if([parsedArr count]>0)
    {
        NSMutableDictionary *paymentDictionary = [parsedArr objectAtIndex:0];
        
        if ([[paymentDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[paymentDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            transactionresponse = [paymentDictionary valueForKey:PAYMENT_TRANSACTION_RESPONSE];
            
            if ([[paymentDictionary valueForKey:ERRORCODE] isEqualToString:@"114"])
            {
               
                TicketConfirmViewController  *ticketConVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"TicketConfirmViewController"];
                [ticketConVC setCurrentSelec:self.currentSelec];
                QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
                singleTon.transactiontimerCount =  1;
                [self.navigationController pushViewController:ticketConVC animated:YES];
                
                
            }
            
        }
        else   //Based on error code data will be displayed
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[paymentDictionary valueForKey:ERROR_MESSAGE]];
        }
    }
    else
    {
        if (timerfortrans != nil) {
            
            [timerfortrans invalidate];
            timerfortrans = nil;
        }

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
}

- (void) handleParserError:(NSError *) error
{

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=SERVER_ERROR_ALERT;
    [alert show];
    
}

#pragma mark --- cancel the booking parse data methods


-(void)handleLoadedCancelRequest:(NSArray *)parserArr
{
  //  NSLog(@"parser response for cancel the payment :%@",parserArr);
    
    
    if([parserArr count]>0)
    {
        NSMutableDictionary *cancelDictionary = [parserArr objectAtIndex:0];
        
        if ([[cancelDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {

            if (timerfortrans != nil) {
                
                [timerfortrans invalidate];
                timerfortrans = nil;
            }
            QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
            singleTon.seatCnfmtn=nil;
            singleTon.transactiontimerCount=1;
            
            
            if (forpushneedtoCancel == NO) {
                
                
            
            
            //got to ticket confirm with cancel status msg
            
            NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            
            for (UIViewController *aViewController in arrofNavoagtionsCon) {
                if ([aViewController isKindOfClass:[HomeViewController class]]) {
                    [self.navigationController popToViewController:aViewController animated:YES];
                    break;
                }
                else{
                    HomeViewController *homeviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    [self.navigationController pushViewController:homeviewVC animated:YES];
                    break;
                }
            }
            
              [scutilits hideLoader];
            
            
           // [self.navigationController popToRootViewControllerAnimated:YES];
        }
            else{
                
                
                NSLog(@"cancelled succesfully in payme....");
                
                [delegateApp actionforPush];
            }
        }
        
    }
    else
    {
        if (timerfortrans != nil) {
            
            [timerfortrans invalidate];
            timerfortrans = nil;
        }

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
        
    }
}

-(void)handleCancelCnfmntParserError:(NSError *)error
{

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=SERVER_ERROR_ALERT;
    [alert show];
}


//Inorder to have a proper scrolling this method is used
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [scrollviewofDetails layoutIfNeeded];
    
    natBgYCoor = imgviewofNationalitybg.frame.origin.y;
    natIconYCoor = imgviewofNationalityIcon.frame.origin.y;
    natBtnYCoor = btnNationality.frame.origin.y;
    submitbtnYCoor = btnSubmit.frame.origin.y;
    cancelbtnYCoor = btnCancel.frame.origin.y;
    blacklineYCoor = lblblackline.frame.origin.y;
    bottombgimgviewYCoor = imgviewofbottombg.frame.origin.y;
    bottomlogoimgViewYCoor = imgviewofbottomlogo.frame.origin.y;

//    scrollviewofDetails.contentSize=scrollviewofDetails.frame.size;
}

#pragma mark
#pragma mark
#pragma mark TextField Delegate method
#pragma mark
// called when textField start editting.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textFieldTag=textField.tag;
    [scrollviewofDetails setContentOffset:CGPointMake(0,textField.center.y-50) animated:YES];
  
}



-(void)textFieldChangedforCard:(UITextField *)textField{
    
    
    if (textField.text.length == 1) {
        
        NSString *strfirstdigitIs = textField.text;
        strfirstdigitIs = [strfirstdigitIs substringToIndex:1];
        
        //master
        if ([strfirstdigitIs isEqualToString:@"5"]) {
            if ([SMSCountryUtils isIphone]) {
                
                if (ViewWidth == iPhone6PlusWidth) {
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"MasterCard@3x.png"];
                    
                }
                else if ([SMSCountryUtils isRetinadisplay]){
                    imgviewofCardType.image = [UIImage imageNamed:@"MasterCard@2x.png"];

                }
                
                else{
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"MasterCard.png"];

                    
                }
                
            }
            else{
                
                if ([SMSCountryUtils isRetinadisplay]) {
                 
                    imgviewofCardType.image = [UIImage imageNamed:@"MasterCard@2x~ipad.png"];

                    
                }
                else{
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"MasterCard~ipad.png"];

                }
                
                
            }
            
            
        }
        //american
        else if([strfirstdigitIs isEqualToString:@"3"])
        {
            if ([SMSCountryUtils isIphone]) {
                
                if (ViewWidth == iPhone6PlusWidth) {
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"Amex@3x.png"];
                    
                }
                else if ([SMSCountryUtils isRetinadisplay]){
                    imgviewofCardType.image = [UIImage imageNamed:@"Amex@2x.png"];
                    
                }
                
                else{
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"Amex.png"];
                    
                    
                }
                
            }
            else{
                
                if ([SMSCountryUtils isRetinadisplay]) {
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"Amex@2x~ipad.png"];
                    
                    
                }
                else{
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"Amex~ipad.png"];
                    
                }
                
                
            }

            
        }
        //visa
        else if ([strfirstdigitIs isEqualToString:@"4"]){
            
            if ([SMSCountryUtils isIphone]) {
                
                if (ViewWidth == iPhone6PlusWidth) {
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"Visa@3x.png"];
                    
                }
                else if ([SMSCountryUtils isRetinadisplay]){
                    imgviewofCardType.image = [UIImage imageNamed:@"Visa@2x.png"];
                    
                }
                
                else{
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"Visa.png"];
                    
                    
                }
                
            }
            else{
                
                if ([SMSCountryUtils isRetinadisplay]) {
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"Visa@2x~ipad.png"];
                    
                    
                }
                else{
                    
                    imgviewofCardType.image = [UIImage imageNamed:@"Visa~ipad.png"];
                    
                }
                
                
            }
            
        }
        
    }
    else if(tfofCardNumber.text.length == 0){
        
        if ([SMSCountryUtils isIphone]) {
            
            if (ViewWidth == iPhone6PlusWidth) {
                
                imgviewofCardType.image = [UIImage imageNamed:@"icon-card@3x.png"];
                
            }
            else{
            
                imgviewofCardType.image = [UIImage imageNamed:@"icon-card.png"];
                
                
            }
            
        }
        else{
                imgviewofCardType.image = [UIImage imageNamed:@"icon-card~ipad.png"];
        }

        
    }
    
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
        [scrollviewofDetails setContentOffset:CGPointMake(0,textField.center.y-50) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [scrollviewofDetails setContentOffset:CGPointMake(0,0) animated:YES];
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 18 || textField.tag == 21) {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_NUMERICS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else{
        return YES;
    }
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
    switch (pickerView.tag) {
        case MONTHS_PICKER:
            return  monthArr.count;
            break;
        case YEARS_PICKER:
            return  yearArr.count;
            break;
            
        default:
            return 0;
            break;
    }
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
    switch (pickerView.tag) {
        case MONTHS_PICKER:
            return  [monthArr objectAtIndex:row];
            break;
        case YEARS_PICKER:
            return  [yearArr objectAtIndex:row];
            break;
            
        default:
            return @"";
            break;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    switch (pickerView.tag) {
        case MONTHS_PICKER:
            return  [tfofExpireMonth setText:[monthArr objectAtIndex:row]];
            break;
        case YEARS_PICKER:
            return  [tfofExpireYear setText:[yearArr objectAtIndex:row]];
            break;
        default:
            break;
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
