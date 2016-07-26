//
//  BookingViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 16/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "BookingViewController.h"
#import "Q-ticketsConstants.h"
#import "SMSCountryUtils.h"
#import "SeatLayoutParseOperation.h"
#import "SeatLayoutVO.h"
#import "SeatLayoutView.h"
#import "SMSCountryLocalDB.h"
#import "QticketsSingleton.h"
#import "BlockSeatParseOpeartion.h"
#import "LoginViewController.h"
#import "UserDetailsViewController.h"
#import "EGOImageView.h"
#import "HomeViewController.h"


#import "LoginViewController.h"
#import "MyBookingsViewController.h"
#import "MyProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "MyVouchersViewController.h"
#import "MobileNumVerifyViewController.h"
#import "SMSCountryUtils.h"

#import "AppDelegate.h"
#import "MarqueeLabel.h"

#import "UINavigationController+MenuNavi.h"
#import "SplashLoaderViewController.h"


@implementation SeatSelection

@synthesize movieId,movieName,theaterId,theaterName,showId,showTime,selectedSeatsArr,totalCost,userId,date,movieThumbnail,movieThumbnailSrc,movieReleaseDate,movieLanguage,movieCensor,bookingFees,screenName,timeOutInMin,requestedTimeInSec,movieimdbRating,strTheaterNameArabic,totalnoofSeats;

@end



@interface BookingViewController (){
    
    
     IBOutlet MarqueeLabel *lblofViewTitle;
     IBOutlet EGOImageView *imgviewofMovie;
     IBOutlet MarqueeLabel  *lblofMovieName;
     IBOutlet UILabel      *lbldateofmovie;
     IBOutlet UILabel      *lbltimeofMovie;
     IBOutlet MarqueeLabel  *lblplaceofMovie;
     IBOutlet UILabel      *lblscreenofMovie;
     IBOutlet UILabel      *lblnoofseatesSelected;
     IBOutlet UIButton     *btnbookNow;
     IBOutlet UIView       *homeView;
     IBOutlet UIView       *viewforFamilyAlert;
     IBOutlet EGOImageView *bgselectedImage;
     BOOL                  mClicked;
     SMSCountryUtils       *scutilites;
     AppDelegate           *delegateApp;

    NSMutableArray         *connectionsArr;
    NSOperationQueue       *queue;
    NSMutableArray         *parsersArr;
    SeatLayoutView *sView ;
    IBOutlet UILabel       *lblImdbrating;
    IBOutlet UIImageView   *imgviewofImdb;
    

}

@end

@implementation BookingViewController

@synthesize selectedSeats,currSeatSelection,bookingFees,fullScreenURL,selectedBoxOfficeSeatids,seatClassId,seatClassName,bkdHistArr;


- (id)initWithSeatSelection:(SeatSelection *)seatSelection {
    
    self = [super init];
    if (self) {
        [self setCurrSeatSelection:seatSelection];
        
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }

    
    connectionsArr         = [[NSMutableArray alloc] init];
    parsersArr             = [[NSMutableArray alloc] init];
    queue                  = [[NSOperationQueue alloc] init];
    scutilites             = [[SMSCountryUtils alloc]init];
    delegateApp            = QTicketsAppDelegate;
    mClicked               = NO;
    rightMenu              = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    rightMenu.setDelegate  = self;
    if ([SMSCountryUtils isIphone]) {
        
        [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight-MenutopStripHei)];
        
    }
    else{
        
        [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+50, MenuWidth+150, ViewHeight-MenutopStripHei+50)];
    }

    [self.view addSubview:rightMenu.view];
    [self setSelectedData];
   
    
    //currSeatSelection     = [[SeatSelection alloc]init];
    [viewforFamilyAlert setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowFamilyAlertView:) name:@"ShowFamilyAlert" object:nil];
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeClicked:)];
    [homeView addGestureRecognizer:swiperight];
    
    
    
    
  }



    




-(void)setSelectedData{
    
    lblofViewTitle.marqueeType    = MLContinuous;
    lblofViewTitle.trailingBuffer = 15.0;
    [lblofViewTitle setText:[NSString stringWithFormat:@"%@",self.currSeatSelection.movieName]];
    
    
    if (![delegateApp.selectedMovie.strAgeRestrictRating isEqualToString:@""]) {
        
        [[[UIAlertView alloc]initWithTitle:@"Attention" message:[NSString stringWithFormat:@"%@",delegateApp.selectedMovie.strAgeRestrictRating] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    

    
    imgviewofMovie                = [imgviewofMovie initWithPlaceholderImage:[UIImage imageNamed:@"bg.png"]];
    imgviewofMovie.imageURL       = [NSURL URLWithString:[NSString stringWithFormat:@"%@",delegateApp.selectedMovie.strMovieThumurlis]];
    
    lblofMovieName.marqueeType    = MLContinuous;
    lblofMovieName.trailingBuffer = 15.0;
    
    lblplaceofMovie.marqueeType   = MLContinuous;
    lblplaceofMovie.trailingBuffer = 15.0;
    
    lblofMovieName.text           = [NSString stringWithFormat:@"%@ (%@)",self.currSeatSelection.movieName,self.currSeatSelection.movieCensor];

   // [lblofMovieName setText:delegateApp.selectedMovie.movieName];
  
    
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [dateFormate dateFromString:self.currSeatSelection.date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [components weekday];
    NSString *weekdayName = [dateFormate weekdaySymbols][weekday - 1];
    NSString *showDayis  =[weekdayName substringToIndex:3];
    dateFormate.dateFormat=@"dd";
    NSString *showDateis=[dateFormate stringFromDate:date];
    dateFormate.dateFormat=@"MMM";
    NSString *showMonthis=[[dateFormate stringFromDate:date] uppercaseStringWithLocale:[NSLocale currentLocale]];
    

    
    lbldateofmovie.text = [NSString stringWithFormat:@"%@ %@,%@",showDayis,showDateis,showMonthis];
    
    lblplaceofMovie.text = [NSString stringWithFormat:@"%@ , %@",[self.currSeatSelection.theaterName uppercaseStringWithLocale:[NSLocale currentLocale]],self.currSeatSelection.strTheaterNameArabic];
    
    lbltimeofMovie.text  = self.currSeatSelection.showTime;

    lblscreenofMovie.text = self.currSeatSelection.screenName;
    
    if ([self.currSeatSelection.movieimdbRating isEqualToString:@"NA"]) {
        
        [lblImdbrating setHidden:YES];
        [imgviewofImdb setHidden:YES];
        
    }
    else{
        [lblImdbrating setHidden:NO];
        [imgviewofImdb setHidden:NO];
        lblImdbrating.text    = [NSString stringWithFormat:@"%@/10",self.currSeatSelection.movieimdbRating];
    }
    
    
    


}

-(void)rightSwipeClicked:(UISwipeGestureRecognizer *)swipeGes{
    
    if (mClicked == YES) {
        
        [self hideMenuBarBo];
    }
    
}


-(IBAction)btnMenuClicked:(id)sender{
 
     [rightMenu LoadData];
    
    if (mClicked == NO) {
        
        [self showMenuBarBo];
        
    }
    else{
        
        [self hideMenuBarBo];
        
    }
    
    
    
}



-(void)showMenuBarBo{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //   [homeView setFrame:CGRectMake(-MenuWidth, 0, ViewWidth, ViewHeight)];
        if ([SMSCountryUtils isIphone]) {
            
            [rightMenu.view setFrame:CGRectMake(ViewWidth-MenuWidth, MenutopStripHei, MenuWidth, ViewHeight- MenutopStripHei)];
        }
        else{
            
            [rightMenu.view setFrame:CGRectMake(ViewWidth-MenuWidth-150, MenutopStripHei+56, MenuWidth+150, ViewHeight- MenutopStripHei+56)];
        }

    } completion:^(BOOL finished) {
        mClicked = YES;
    }];

}

-(void)hideMenuBarBo{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if ([SMSCountryUtils isIphone]) {
            
            [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight-MenutopStripHei)];
        }
        
        else{
            [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+56, MenuWidth+150, ViewHeight - MenutopStripHei+56)];
        }
        // [homeView setFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    } completion:^(BOOL finished) {
        mClicked = NO;
    }];
    
    

}


#pragma mark MenuView DelegateMethode

-(void)selectedMenuOption:(NSInteger)selectedIndex{
    
    
    [USERDEFAULTS setValue:@"0" forKey:FromHome];
    [USERDEFAULTS setValue:@"0" forKey:FromMyBooings];
    [USERDEFAULTS setValue:@"0" forKey:FromMyProfile];
    [USERDEFAULTS setValue:@"0" forKey:FromChangePwd];
    [USERDEFAULTS setValue:@"0" forKey:FromMyVoucher];
    [USERDEFAULTS setValue:@"0" forKey:FromTicketCancel];
    USERDEFAULTSAVE;


    
    if (mClicked == YES) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            if ([SMSCountryUtils isIphone]) {
                
                [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight-MenutopStripHei)];
            }
            
            else{
                [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+56, MenuWidth+150, ViewHeight - MenutopStripHei+56)];
            }
            //  [homeview setFrame:CGRectMake(0, MenutopStripHei, ViewWidth, ViewHeight - MenutopStripHei)];
            
            
        } completion:^(BOOL finished) {
            mClicked = NO;
            
            
            [self.navigationController NavigatetoViewControllerwithSelectedIndex:selectedIndex];
            
            
        }];
    }
    else
    {
        [self.navigationController NavigatetoViewControllerwithSelectedIndex:selectedIndex];
        
        
        
        
    }
    
}


-(void)ShowFamilyAlertView:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"ShowFamilyAlert"]) {
        
        [viewforFamilyAlert setHidden:NO];
        [homeView addSubview:viewforFamilyAlert];
        [homeView bringSubviewToFront:viewforFamilyAlert];
        
    }
}

-(IBAction)btnCancelClicked:(id)sender
{
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"NO",@"value", nil];
   // NSString  *permi = @"NO";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FamilyNotifiClicked" object:dict];
    [viewforFamilyAlert setHidden:YES];
    
}
-(IBAction)btnOkClicked:(id)sender{
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"YES",@"value", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FamilyNotifiClicked" object:dict];
    [viewforFamilyAlert setHidden:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    
    
    if (self.currSeatSelection.selectedSeatsArr.count > 0)
    {
        [self.currSeatSelection.selectedSeatsArr removeAllObjects];
        [lblnoofseatesSelected setText:@""];
        [btnbookNow setTitle:@"BOOK NOW" forState:UIControlStateNormal];

    }
    [sView removeFromSuperview];
    [self getSeatLayoutByShowTimeId:self.currSeatSelection.showId];
    
    
    
//    if (self.currSeatSelection.selectedSeatsArr.count > 0)
//    {
//        [self.currSeatSelection.selectedSeatsArr removeAllObjects];
//        [lblnoofseatesSelected setText:@""];
//        [btnbookNow setTitle:@"BOOK NOW" forState:UIControlStateNormal];
//    }
    
//    NSString *showid = @"113164";
    
   // [self getSeatLayoutByShowTimeId:self.currSeatSelection.showId];
   // [self getSeatLayoutByShowTimeId:showid];
    
}

#pragma mark Service Calls
-(void)getSeatLayoutByShowTimeId:(NSString *)showID
{
    SMSCountryConnections *conn  = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn getSeatLayoutByShowTimeId:showID];
    [connectionsArr addObject:conn];
}

-(void)blockSeatQticketsWithShowId:(NSString *)showId andSeatNumber:(NSString *)seatnumber withMovieId:(NSString *)strMovieId withSchuduleDate:(NSString *)strSchuduleDate withShowTime:(NSString *)strShowTime
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    
    [conn blockSeatQticketsWithShowId:showId andSeatNumber:seatnumber withiPhoneAppSource:@"3" withMovieId:strMovieId withScheduleDate:strSchuduleDate withShowTime:strShowTime];
    [connectionsArr addObject:conn];
  //  [conn release];
}

#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:GET_SEAT_LAYOUT]) {
        NSOperationQueue *tmpQueue        = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        SeatLayoutParseOperation *sParser = [[SeatLayoutParseOperation alloc] initWithData:data delegate:self andRequestMessage:GET_SEAT_LAYOUT];
        [queue addOperation:sParser];
        [parsersArr addObject:sParser];
        data = nil;
    }
    if ([reqMessage isEqualToString:BLOCK_SEATS_QTICKETS])
    {
        NSOperationQueue *tmpQueue       = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        BlockSeatParseOpeartion *bParser = [[BlockSeatParseOpeartion alloc] initWithData:data delegate:self andRequestMessage:BLOCK_SEATS_QTICKETS];
        [queue addOperation:bParser];
        [parsersArr addObject:bParser];
        data = nil;
    }
}

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:GET_SEAT_LAYOUT]) {
        
        if ([error.description isEqualToString:INTERNET_CONNECTION_OFFLINE])
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:CHECK_INTERNET_CONNECTION];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:error.description];
        }
    }
    
    if ([reqMessage isEqualToString:BLOCK_SEATS_QTICKETS]) {
        
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
    
    if ([reqMsg isEqualToString:GET_SEAT_LAYOUT]) {
        [self performSelectorOnMainThread:@selector(handleLoadedSeatLayout:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
        
    }
    
    if ([reqMsg isEqualToString:BLOCK_SEATS_QTICKETS]) {
        [self performSelectorOnMainThread:@selector(handleLoadedBlockedSeats:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
        
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:GET_SEAT_LAYOUT]) {
        [self performSelectorOnMainThread:@selector(handleParserError:) withObject:error waitUntilDone:NO];
    }

    if ([reqMsg isEqualToString:BLOCK_SEATS_QTICKETS]) {
        [self performSelectorOnMainThread:@selector(handleblockSeatParserError:) withObject:error waitUntilDone:NO];
    }
    queue = nil;
}

#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark

- (void) handleLoadedSeatLayout:(NSArray *)parsedArr {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    
    if (parsedArr.count>0) {
        
        if ([[parsedArr objectAtIndex:0] isEqualToString:@"true"] || [[parsedArr objectAtIndex:0] isEqualToString:@"True"])
        {
            SeatLayoutVO *tempBookingClassesRef = [parsedArr lastObject];
          
            for (UIView *tempView in self.view.subviews) {
                if ([tempView isKindOfClass:[SeatLayoutView class]]) {
                    [tempView removeFromSuperview];
                    break;
                }
            }
            sView               = [[SeatLayoutView alloc] initWithSeatClasses:tempBookingClassesRef.bookingClassesArr maxBooking:tempBookingClassesRef.maxBooking  bookingFees:tempBookingClassesRef.bookingFees withController:self];
            bookingFees                         = tempBookingClassesRef.bookingFees;
            self.currSeatSelection.bookingFees=bookingFees;
            UILabel *limitLbl                   = (UILabel*)[self.view viewWithTag:SELECTED_SEAT_LIMIT_MESSAGE_TAG];
            limitLbl.text                       = [NSString stringWithFormat:@"You can only select %d seats",tempBookingClassesRef.maxBooking];
            [sView setBackgroundColor:[UIColor clearColor]];
            
            if ([SMSCountryUtils isIphone]) {
                if (ViewWidth == iPhone4Width) {
                    if (ViewHeight == iPhone5Height) {
                         [sView setFrame:CGRectMake(5, 180, 310, 330)];
                    }
                    else{
                        [sView setFrame:CGRectMake(5, 190, 310, 230)];
                    }
                }
                else if(ViewWidth == iPhone6Width){
                     [sView setFrame:CGRectMake(5, 200, 360, 395)];
                }
                else if (ViewWidth == iPhone6PlusWidth)
                {
                    [sView setFrame:CGRectMake(10, 200, 395, 470)];
                }
                sView.minimumZoomScale  = 0.6;
                sView.maximumZoomScale  = 1.5f;

            }
            else{
                [sView setFrame:CGRectMake(15, 360, 738, 580)];
                if (self.currSeatSelection.totalnoofSeats < 110) {
                    sView.minimumZoomScale  = 1.5;
                }
                else{
                sView.minimumZoomScale  = 0.75;
                }
                sView.maximumZoomScale  = 2.5f;
            }
             sView.zoomScale         = sView.minimumZoomScale;
            [homeView addSubview:sView];
        }
        else if ([[parsedArr objectAtIndex:0] isEqualToString:@"false"] || [[parsedArr objectAtIndex:0] isEqualToString:@"False"])
        {
            [scutilites hideLoader];
            [self.navigationController popViewControllerAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Data Not Available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
    else
    {
        [scutilites hideLoader];
        [self.navigationController popViewControllerAnimated:YES];
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ERROR_MSG_ERROR_IN_SERVER];
    }
}



- (void) handleParserError:(NSError *) error {
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
}

-(void)handleLoadedBlockedSeats:(NSArray *)parserArr
{
    
    if (parserArr.count>0)
    {
        NSMutableDictionary *bkdSeatDictionary = [parserArr objectAtIndex:0];
        if ([[bkdSeatDictionary valueForKey:STATUS] isEqualToString:@"True"] || [[bkdSeatDictionary valueForKey:STATUS] isEqualToString:@"true"])
        {
            SeatConfirmationVO *seatcnfmvO     = [bkdSeatDictionary valueForKey:BLOCK_SEAT];
            QticketsSingleton *snglTon         = [QticketsSingleton sharedInstance];
            snglTon.seatCnfmtn                 = seatcnfmvO;
            snglTon.isMovieSelected            = YES;
            
            UserDetailsViewController *userdetailsvc    = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"UserDetailsViewController"];
            [userdetailsvc setCurrentSelec:self.currSeatSelection];
            snglTon.curselection            = self.currSeatSelection;
            [self.navigationController pushViewController:userdetailsvc animated:YES];

        
        }
        else
        {
            if ([[bkdSeatDictionary valueForKey:ERRORCODE] isEqualToString:@"112"])
            {
                if (self.currSeatSelection.selectedSeatsArr.count > 0)
                {
                    [self.currSeatSelection.selectedSeatsArr removeAllObjects];
                    [lblnoofseatesSelected setText:@""];
                    [btnbookNow bringSubviewToFront:lblnoofseatesSelected];
                    [btnbookNow setTitle:@"BOOK NOW" forState:UIControlStateNormal];
                }
                [sView removeFromSuperview];
                [self getSeatLayoutByShowTimeId:self.currSeatSelection.showId];
            }
            else if ([[bkdSeatDictionary valueForKey:ERRORCODE] isEqualToString:@"133"]){
                
//                if (self.currSeatSelection.selectedSeatsArr.count > 0)
//                {
//                    [self.currSeatSelection.selectedSeatsArr removeAllObjects];
//                    [lblnoofseatesSelected setText:@""];
//                    [btnbookNow bringSubviewToFront:lblnoofseatesSelected];
//                    [btnbookNow setTitle:@"BOOK NOW" forState:UIControlStateNormal];
//                }
//                [sView removeFromSuperview];
                
                
                UIAlertView *alertviewforErr = [[UIAlertView alloc] initWithTitle:@"Alert" message:[bkdSeatDictionary valueForKey:ERROR_MESSAGE] delegate:self cancelButtonTitle:@"Reload" otherButtonTitles:nil];
                alertviewforErr.tag =  99;
                [alertviewforErr show];
                
//                [SMSCountryUtils showAlertMessageWithTitle:@"" Message:[bkdSeatDictionary valueForKey:ERROR_MESSAGE]];
                
                
            }
            
        }
    }
}

-(void)handleblockSeatParserError:(NSError *)error
{
    [SMSCountryUtils showAlertMessageWithTitle:@"ERROR" Message:[error localizedDescription]];
}
#pragma mark
#pragma mark SeatLayoutViewDelegate
#pragma mark

- (void)updateSeatSelection:(NSMutableArray *)selectedSeatsArr
{
    
    selectedSeats               = [[NSMutableString alloc]init];
    selectedBoxOfficeSeatids    = [[NSMutableString alloc] init];
    self.currSeatSelection.totalCost = 0;
    [self.currSeatSelection.selectedSeatsArr removeAllObjects];
    for (BookingSeatVO *tempSeat in selectedSeatsArr)
    {
        // NSLog(@"selected seats: %@,",tempSeat.seatNumber);
        [selectedSeats appendString:tempSeat.seatNumber];
        [selectedSeats appendString:@","];
        self.currSeatSelection.selectedSeatsArr=[[NSMutableArray alloc]initWithObjects:selectedSeats, nil];
        [self setSeatClassId:[tempSeat.bookingRowVO.bookingClassVO.classId intValue]];
        [self setSeatClassName:tempSeat.bookingRowVO.bookingClassVO.className];
        self.currSeatSelection.totalCost += tempSeat.bookingRowVO.bookingClassVO.cost;
        
    }
    // to remove the last comma(,) in selected seats
    if(![selectedSeats isEqualToString:@""])
        [selectedSeats deleteCharactersInRange:NSMakeRange([selectedSeats length]-1, 1)];
    
    if(![selectedBoxOfficeSeatids isEqualToString:@""])
        [selectedBoxOfficeSeatids deleteCharactersInRange:NSMakeRange([selectedBoxOfficeSeatids length]-1, 1)];
    
    UILabel *lbl = (UILabel*)[self.view viewWithTag:SELECTED_SEAT_TAG];
    [lbl setText:[NSString stringWithFormat:@"%@",selectedSeats]];
    
    if (self.currSeatSelection.selectedSeatsArr.count>0)
    {
        NSString *selectedSeatsCount = [NSString stringWithFormat:@"%lu", (unsigned long)[[[self.currSeatSelection.selectedSeatsArr objectAtIndex:0]componentsSeparatedByString:@","]count]];
        
//        _bookNowLbl.font=[UIFont fontWithName:OPEN_SANS_CONDENSED_BOLD size:FONT_SIZE_14];
//        _bookNowLbl.textColor=UIColorFromRGB(0xffffff);
        
        if (![selectedSeatsCount isEqualToString:@"1"])
        {
            
            [lblnoofseatesSelected setLineBreakMode:NSLineBreakByWordWrapping];
            [lblnoofseatesSelected setNumberOfLines:2];
            [lblnoofseatesSelected setText:[NSString stringWithFormat:@"%@",selectedSeatsCount]];
            [btnbookNow bringSubviewToFront:lblnoofseatesSelected];
            [btnbookNow setTitle:@"BOOK NOW" forState:UIControlStateNormal];
            
        }
        else
        {
            [lblnoofseatesSelected setLineBreakMode:NSLineBreakByWordWrapping];
            [lblnoofseatesSelected setNumberOfLines:2];
            [lblnoofseatesSelected setText:[NSString stringWithFormat:@"%@",selectedSeatsCount]];
            [btnbookNow bringSubviewToFront:lblnoofseatesSelected];
            [btnbookNow setTitle:@"BOOK NOW" forState:UIControlStateNormal];
            
        }
    }
    else
    {
        [lblnoofseatesSelected setText:@""];
        [btnbookNow setTitle:@"BOOK NOW" forState:UIControlStateNormal];
    }
}

#pragma mark
#pragma mark UIAlertViewDelegate Methods
#pragma mark

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        
        //navigate to splash screen
        
        SplashLoaderViewController *splashScreen = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"SplashLoaderViewController"];
        [self.navigationController pushViewController:splashScreen animated:YES];
        

    }
    else{
    
    [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)btnBooknowClicked:(id)sender{
    
    
    if(self.currSeatSelection.selectedSeatsArr.count>0)
    {
                
        [self blockSeatQticketsWithShowId:self.currSeatSelection.showId andSeatNumber:[self.currSeatSelection.selectedSeatsArr objectAtIndex:0] withMovieId:self.currSeatSelection.movieId withSchuduleDate:self.currSeatSelection.date withShowTime:self.currSeatSelection.showTime];
    }
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SELECT_ATLEAST_ONE_SEAT];
    }

}

-(IBAction)btnBackClicked:(id)sender{
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
