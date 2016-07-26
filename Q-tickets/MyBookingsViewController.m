//
//  MyBookingsViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "MyBookingsViewController.h"
#import "MyBookingsTableViewCell.h"
#import "Q-ticketsConstants.h"
#import "QticketsSingleton.h"
#import "SMSCountryConnections.h"
#import "SMSCountryLocalDB.h"
#import "SMSCountryUtils.h"
#import "UserBookingParseOperation.h"
#import "UserVO.h"
#import "TicketCancelViewController.h"
#import "AppDelegate.h"
#import "UINavigationController+MenuNavi.h"
#import "HomeViewController.h"

@interface MyBookingsViewController ()<UITableViewDataSource,UITableViewDelegate,CommonParseOperationDelegate,SMSCountryConnectionDelegate>{
    
   

     IBOutlet UITableView *tbofMybookings;
     IBOutlet UILabel     *lblofViewTitle;
     IBOutlet UIView      *viewofBottomMenu;
     QticketsSingleton    *singleton;
     NSMutableArray       *connectionsArr;
     NSMutableArray       *parsersArr;
     NSOperationQueue     *queue;
    NSMutableArray       *arrofBookedHistory,*arrofAllBookings;
    AppDelegate          *delegateApp;
    BOOL isPastMovies;
    
}
//cell animation
@property (assign, nonatomic) CATransform3D initialTransformation;


@end



@implementation MyBookingsViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    delegateApp       = QTicketsAppDelegate;
    connectionsArr    = [[NSMutableArray alloc] init];
    parsersArr        = [[NSMutableArray alloc] init];
    queue             = [[NSOperationQueue alloc] init];
    arrofBookedHistory= [[NSMutableArray alloc] init];
    arrofAllBookings   = [[NSMutableArray alloc] init];
    isPastMovies      = NO;
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    
    [arrofAllBookings removeAllObjects];
    [arrofBookedHistory removeAllObjects];
    
    singleton = [QticketsSingleton sharedInstance];
    
    if (singleton.cureentLoginUser.status == 1)
    {
        [self userbookingHistoryByUserID:singleton.cureentLoginUser.serverId];
    }

}


-(void)CellRowAnimation{
    
    CGFloat       rotationAngleDegree  = 10;
    CGFloat       rotationAngleRadius  = rotationAngleDegree * (M_PI/180);
    CGPoint       offsetPositing       = CGPointMake(0, 60);
    CATransform3D Tranasform           = CATransform3DIdentity;
    Tranasform                         = CATransform3DRotate(Tranasform, rotationAngleRadius, 1.0, 1.0, 1.0);
    Tranasform                         = CATransform3DTranslate(Tranasform, offsetPositing.x, offsetPositing.y, 0.0);
    _initialTransformation             = Tranasform;

}


#pragma mark
#pragma mark SMSCountry Service Calls
#pragma mark

-(void)userbookingHistoryByUserID:(NSString *)userID
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn getUserBookingByUserId:userID];
    [connectionsArr addObject:conn];
}

#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:USER_BOOKINGS]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        UserBookingParseOperation *bParser = [[UserBookingParseOperation alloc] initWithData:data delegate:self andRequestMessage:USER_BOOKINGS];
        [queue addOperation:bParser];
        [parsersArr addObject:bParser];
        data = nil;
    }
}

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
        [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:error.description];
}

#pragma mark
#pragma mark CommonParserOperation Delegate methods
#pragma mark

- (void)didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr {
    if ([reqMsg isEqualToString:USER_BOOKINGS]) {
        [self performSelectorOnMainThread:@selector(handleLoadedBookingHistorymyboo:) withObject:parseArr waitUntilDone:NO];
           queue = nil;   // we are finished with the queue and our ParseOperation
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    if ([reqMsg isEqualToString:USER_BOOKINGS]) {
        [self performSelectorOnMainThread:@selector(handleParserErrormyb:) withObject:error waitUntilDone:NO];
    }
     queue = nil;
}

#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark
- (void) handleLoadedBookingHistorymyboo:(NSArray *)parsedArr
{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    // if parsed Arr count is greater then zero. Now we can insert bookinghistory into localdb
    if (parsedArr.count>0)
    {
        [arrofBookedHistory addObjectsFromArray:parsedArr];
        [arrofAllBookings addObjectsFromArray:parsedArr];
        [tbofMybookings reloadData];
    }
    else //obtaining data from localdb
    {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ALERT_WARNING_NO_BOOKING_HISTORY];
            [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) handleParserErrormyb:(NSError *) error {
    
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];
}

#pragma Movies Tableview Delegate methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([SMSCountryUtils isIphone]) {
        
        return 155.0;
    }
    else{
    
    return 250.0;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrofBookedHistory.count;


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        MyBookingsTableViewCell *mybookingsCell = (MyBookingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyBookingsTableViewCell"];
        if (mybookingsCell == nil) {
            
            mybookingsCell = [[[NSBundle mainBundle]loadNibNamed:@"MyBookingsTableViewCell" owner:self options:nil] objectAtIndex:0];
            
        }
    mybookingsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BookingHistoryVO *bkgHistVO = [arrofBookedHistory objectAtIndex:indexPath.row];
    UIImage *loaderimg;
    if ([SMSCountryUtils isIphone]) {
        
        
        if(ViewWidth == iPhone6PlusWidth)
        {
            loaderimg = [UIImage imageNamed:@"bg_p@3x.png"];
            
        }
        else{
            
            if ([SMSCountryUtils isRetinadisplay]) {
                
                loaderimg = [UIImage imageNamed:@"bg_p@2x.png"];
            }
            else{
                
                loaderimg = [UIImage imageNamed:@"bg_p.png"];
                
            }
            
            
        }
        
    }
    else{
        
        if ([SMSCountryUtils isRetinadisplay]) {
            loaderimg = [UIImage imageNamed:@"bg_p@2x~ipad.png"];
        }
        else{
            loaderimg = [UIImage imageNamed:@"bg_p~ipad.png"];
        }
        
        
    }

    mybookingsCell.imgofMovie          = [mybookingsCell.imgofMovie initWithPlaceholderImage:loaderimg];
    [mybookingsCell.imgofMovie setTag:indexPath.row];
    mybookingsCell.imgofMovie.imageURL = [NSURL URLWithString:bkgHistVO.streMovieBannerurlis];
    mybookingsCell.lblnameofMovie.marqueeType    = MLContinuous;
    mybookingsCell.lblnameofMovie.trailingBuffer = 15.0f;
    [mybookingsCell.lblnameofMovie setTextAlignment:NSTextAlignmentCenter];
    mybookingsCell.lblnameofMovie.text           = bkgHistVO.movieName;
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"dd-MM-yyyy hh:mm a"];
    NSDate *newdate = [dateFormate dateFromString:bkgHistVO.showDate];
    dateFormate.dateFormat=@"MMM dd,yyyy";
    NSDateFormatter *timeFormate = [[NSDateFormatter alloc]init];
    [timeFormate setDateFormat:@"dd-MM-yyyy hh:mm a"];
    NSDate *newtime = [timeFormate dateFromString:bkgHistVO.showDate];
    timeFormate.dateFormat=@"hh:mm a";
    NSString *strDate = [NSString stringWithFormat:@"%@ %@",[dateFormate stringFromDate:newdate],[timeFormate stringFromDate:newtime]];
    mybookingsCell.lbldateofMovie.text = strDate;
//    NSString *strSeats = [NSString stringWithFormat:@"%d seats : %@",bkgHistVO.seatsCount,bkgHistVO.seatsSelected];
//    mybookingsCell.lblnumberofseats.text = strSeats;
    
    mybookingsCell.lblnumberofseats.text = [NSString stringWithFormat:@"Admit : %d",bkgHistVO.seatsCount];

    mybookingsCell.lblamountofMovie.text = [NSString stringWithFormat:@"%.2f QAR",bkgHistVO.totalCost];
    mybookingsCell.lblplaceofMovie.text = bkgHistVO.theatreName;
    
    
    NSDate *dt1 = [NSDate date];
    NSString *bookedate = [NSString stringWithFormat:@"%@",bkgHistVO.showDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm a"];
    NSDate *dt2 = [[NSDate alloc] init];
    dt2 = [dateFormatter dateFromString:bookedate];
    NSComparisonResult result = [dt1 compare:dt2];
    
    switch (result) {
        case NSOrderedAscending:
            //ntg
            if ([bkgHistVO.strBookingStatus isEqualToString:@"Cancel"]) {
                
                [mybookingsCell.btnCancel setHidden:NO];
                [mybookingsCell.btnCancel setEnabled:YES];
                [mybookingsCell.btnCancel addTarget:self action:@selector(btnCanceledClicked:) forControlEvents:UIControlEventTouchUpInside];
                [mybookingsCell.lblConfirmationCode setHidden:NO];
                mybookingsCell.lblConfirmationCode.text = [NSString stringWithFormat:@"%@",bkgHistVO.reservationCode];
            }
            else{
                [mybookingsCell.btnCancel setHidden:YES];
            }

            break;
        case NSOrderedDescending:
            [mybookingsCell.lblConfirmationCode setHidden:YES];
             [mybookingsCell.btnCancel setHidden:YES];
            break;
        case NSOrderedSame:
            //ntg
            [mybookingsCell.lblConfirmationCode setHidden:NO];
            mybookingsCell.lblConfirmationCode.text = [NSString stringWithFormat:@"%@",bkgHistVO.reservationCode];
            if ([bkgHistVO.strBookingStatus isEqualToString:@"Cancel"]) {
                
                [mybookingsCell.btnCancel setHidden:NO];
                [mybookingsCell.btnCancel setEnabled:YES];
                [mybookingsCell.btnCancel addTarget:self action:@selector(btnCanceledClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else{
                [mybookingsCell.btnCancel setHidden:YES];
            }
            break;
        default:
            break;
    }

    [mybookingsCell.btnCancel setTag:indexPath.row];

    
    
        return mybookingsCell;
        
}


-(void)btnCanceledClicked:(id)sender{
    
    
    //go for ticket canceling
    UIButton *tbnCancel = (UIButton *)sender;
    BookingHistoryVO *bookedhis = [arrofBookedHistory objectAtIndex:tbnCancel.tag];
    NSString *strreservationcode  =[NSString stringWithFormat:@"%@",bookedhis.reservationCode];
    
    TicketCancelViewController *ticketCan = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"TicketCancelViewController"];
    [ticketCan setStrReservationCode:strreservationcode];
    [self.navigationController pushViewController:ticketCan animated:YES];
    
}


-(IBAction)btnAllClicked:(id)sender
{
    if (arrofBookedHistory.count > 0) {
        
        [arrofBookedHistory removeAllObjects];
    }
    isPastMovies = NO;
    [arrofBookedHistory addObjectsFromArray:arrofAllBookings];
    [tbofMybookings reloadData];
    
}

-(IBAction)btnFutureClicked:(id)sender
{
    if (arrofBookedHistory.count > 0) {
        
        [arrofBookedHistory removeAllObjects];
    }
    for (int k =0; k < arrofAllBookings.count; k++) {
        
        NSDate *dt1 = [NSDate date];
        BookingHistoryVO *bookhis = [arrofAllBookings objectAtIndex:k];
        NSString *bookedate = [NSString stringWithFormat:@"%@",bookhis.showDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm a"];
        NSDate *dt2 = [[NSDate alloc] init];
        dt2 = [dateFormatter dateFromString:bookedate];
        NSComparisonResult result = [dt1 compare:dt2];
        
        switch (result) {
            case NSOrderedAscending:
                isPastMovies = NO;
                [arrofBookedHistory addObject:bookhis];
                [tbofMybookings reloadData];
                break;
            case NSOrderedDescending:
                break;
            case NSOrderedSame:
                //ntg
                break;
            default:
                break;
        }
        
    }

}
-(IBAction)btnPastClicked:(id)sender
{
    if (arrofBookedHistory.count > 0) {
        
        [arrofBookedHistory removeAllObjects];
    }
    for (int k =0; k < arrofAllBookings.count; k++) {
     
    NSDate *dt1 = [NSDate date];
    BookingHistoryVO *bookhis = [arrofAllBookings objectAtIndex:k];
    NSString *bookedate = [NSString stringWithFormat:@"%@",bookhis.showDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm a"];
    NSDate *dt2 = [[NSDate alloc] init];
    dt2 = [dateFormatter dateFromString:bookedate];
    NSComparisonResult result = [dt1 compare:dt2];
        
        switch (result) {
            case NSOrderedAscending:
                //ntg
                break;
            case NSOrderedDescending:
                isPastMovies = YES;
                [arrofBookedHistory addObject:bookhis];
                [tbofMybookings reloadData];
                break;
            case NSOrderedSame:
                //ntg
                break;
            default:
                break;
        }
    
}

}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
//    cell.layer.transform  = self.initialTransformation;
//    cell.layer.opacity    = 0.8;
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.layer.transform = CATransform3DIdentity;
//        cell.layer.opacity   = 1;
//    }];
    
}










- (IBAction)btnBackClickede:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
  /*  NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
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
