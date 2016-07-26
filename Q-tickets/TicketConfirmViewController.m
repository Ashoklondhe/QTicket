//
//  TicketConfirmViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 24/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "TicketConfirmViewController.h"
#import "HomeViewController.h"
#import "Q-ticketsConstants.h"
#import "SMSCountryUtils.h"
#import "EGOImageView.h"
#import "AppDelegate.h"
#import "QticketsSingleton.h"
#import "ConfirmTicketsParseOperation.h"
#import "CancelRequestParseOpeartion.h"
#import "SMSCountryConnections.h"
#import "MarqueeLabel.h"
#import "EventTicketConfirmationParseOperation.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "EventsViewController.h"
#import "Movies_EventsViewController.h"

@interface TicketConfirmViewController ()<UIAlertViewDelegate,CommonParseOperationDelegate,SMSCountryConnectionDelegate,FBSDKSharingDelegate>
{
    
     IBOutlet EGOImageView *imgviewofBackground;
     IBOutlet EGOImageView *imgviewofMovie;
     IBOutlet MarqueeLabel     *lblMoviewName;
     IBOutlet MarqueeLabel     *lblDate;
     IBOutlet UILabel     *lblTime;
     IBOutlet MarqueeLabel *lblScreen;
     IBOutlet MarqueeLabel *lblPlace;
     IBOutlet UILabel     *lblReservationCode;
     IBOutlet UILabel     *lblAllocatedSeats;
     IBOutlet UIImageView *imgviewofsBg;
     IBOutlet UILabel     *lblreservationsub;
     AppDelegate          *delegateApp;
     IBOutlet UILabel      *lblosPaymentStatus;
     IBOutlet EGOImageView  *imgviewofQRcode;
     IBOutlet UILabel      *lblconfirmtitle1;
     IBOutlet UILabel      *lblconfirmtitle2;
     IBOutlet UIImageView  *imgviewofconfirm;
     IBOutlet UIButton     *btnbookanotherTick;
     IBOutlet UIImageView  *imgviewforSeatsNumb;
    
    
    NSMutableArray        *connectionsArr;
    NSOperationQueue      *queue;
    NSMutableArray        *parsersArr;
//    NSTimer               *paymentRequestTimer;
    int                   timeOutInMin;
    int                    timercount;
    NSTimer               *serviceRequestTimer;
    SMSCountryUtils       *scUtils;

    
    SeatSelection         *currentSeat;
    IBOutlet UIImageView  *imgvoewofTimer;
    IBOutlet UILabel      *lblTimerDetails;
    QticketsSingleton     *singleTon;
    
    IBOutlet UIImageView *imgviewofplace;
    IBOutlet UIImageView *imgviewofScreen;
    IBOutlet UIImageView *imgviewofMoviename;
    IBOutlet UIImageView *imgviewofdate;
    IBOutlet UILabel     *lblofTicketsCount;
    
    IBOutlet UILabel     *lblforSentEmailPwd;
    IBOutlet UIButton    *btnLogin;
    
    
    
    
    

}
@end

@implementation TicketConfirmViewController
@synthesize currentSelec,strEventOrderID,noofEventTickets,strTicketNumbers;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    NSString *str = @"fromTC";
    [USERDEFAULTS setObject:str forKey:@"toBackGround"];
    USERDEFAULTSAVE;
    
    
    connectionsArr = [[NSMutableArray alloc] init];
    parsersArr     = [[NSMutableArray alloc] init];
    queue          = [[NSOperationQueue alloc] init];
    
    timercount=5;
    scUtils = [[SMSCountryUtils alloc] init];
    singleTon     = [QticketsSingleton sharedInstance];
    
    
    delegateApp   = QTicketsAppDelegate;
    
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }

    
    lblMoviewName.marqueeType  = MLContinuous;
    lblMoviewName.trailingBuffer = 15.0f;
    lblScreen.marqueeType  = MLContinuous;
    lblScreen.trailingBuffer = 15.0f;
    lblPlace.marqueeType     = MLContinuous;
    lblPlace.trailingBuffer  = 15.0;
    lblDate.marqueeType      = MLContinuous;
    lblDate.trailingBuffer   = 15.0;

    singleTon.timerforTicketConfirm = 180;

    [btnLogin setHidden:YES];
    [btnbookanotherTick setHidden:YES];
    [lblforSentEmailPwd setHidden:YES];
    
    //hide all
    [imgviewofsBg setHidden:YES];
    [lblReservationCode setHidden:YES];
    [lblreservationsub setHidden:YES];
    [lblAllocatedSeats setHidden:YES];
    [lblofTicketsCount setHidden:YES];
    [imgviewforSeatsNumb setHidden:YES];
    [lblosPaymentStatus setHidden:YES];
    [imgviewofQRcode setHidden:YES];
    [lblconfirmtitle1 setHidden:YES];
    [lblconfirmtitle2 setHidden:YES];
    [imgviewofconfirm setHidden:YES];
    [imgviewofMovie setHidden:YES];
    [lblMoviewName setHidden:YES];
    [lblDate setHidden:YES];
    [lblTime setHidden:YES];
    [lblPlace setHidden:YES];
    [lblScreen setHidden:YES];
    [imgviewofplace setHidden:YES];
    [imgviewofScreen setHidden:YES];
    [imgviewofMoviename setHidden:YES];
    [imgviewofdate setHidden:YES];
//    [imgvoewofTimer setHidden:YES];
//    [lblTimerDetails setHidden:YES];
    
    
    
    
    //for iphone 4
    [imgviewofsBg.layer setCornerRadius:5];
    [imgviewofsBg.layer setBorderWidth:1.5];
    [imgviewofsBg.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.view bringSubviewToFront:lblreservationsub];
    [self.view bringSubviewToFront:lblReservationCode];
    [self.view bringSubviewToFront:lblAllocatedSeats];
    
    if (singleTon.isMovieSelected) {
        [scUtils showLoaderWithTitle:@"" andSubTitle:@"Getting ticket confirmation..."];
        timeOutInMin=self.currentSelec.timeOutInMin;
       serviceRequestTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(serviceCallTimer:) userInfo:@"" repeats:YES];
        imgviewofplace.image = [UIImage imageNamed:@"MiconTheatre.png"];
        imgviewofScreen.image = [UIImage imageNamed:@"MiconScreen.png"];
        if ([SMSCountryUtils isIphone]) {
            
            imgviewofMovie.imageURL    = [NSURL URLWithString:[NSString stringWithFormat:@"%@",delegateApp.selectedMovie.strMovieiPhoneHomeurlis]];

        }
        else {
            imgviewofMovie.imageURL    = [NSURL URLWithString:[NSString stringWithFormat:@"%@",delegateApp.selectedMovie.strMovieiPadHomeurlis]];
        }
       
    }
    else{
        
        imgviewofplace.image = [UIImage imageNamed:@"Event_Rating.png"];
        imgviewofScreen.image = [UIImage imageNamed:@"Event_Location.png"];
        
        NSString *imagtThumbnailurl = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.thumbnailURL];
        imagtThumbnailurl           =    [imagtThumbnailurl stringByReplacingOccurrencesOfString:@"/App_Images/" withString:@"/movie_Images/"];
        imagtThumbnailurl           =  [imagtThumbnailurl stringByReplacingOccurrencesOfString:@"_banner." withString:@"_thumb."];
        imgviewofMovie.imageURL        = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imagtThumbnailurl]];
        
        //call for event ticket confirmation
        [self confirmEventTicketwithOrderID:self.strEventOrderID];
    }
}

-(void)serviceCallTimer:(NSTimer *)sender
{
//    
//    serviceRequestTimer=sender;
    if ( singleTon.timerforTicketConfirm <= 0)
    {
        if (serviceRequestTimer != nil)
        {
            [serviceRequestTimer invalidate];
            serviceRequestTimer=nil;
        }
        
        [scUtils hideLoader];
               singleTon.transactiontimerCount=1;
//        lblTimerDetails.hidden=YES;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please contact QTickets team" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=TRANSACTIONTIME_OUT;
        [alert show];
       
    }
    else
    {
         singleTon.timerforTicketConfirm =  singleTon.timerforTicketConfirm - 1;
   
        [self confirmTicketsWithTransactionID:singleTon.seatCnfmtn.transactionID];
    }
    

}




#pragma mark
#pragma mark AlertView Delegate
#pragma mark

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TRANSACTIONTIME_OUT)
    {
        if (buttonIndex == 0)
        {
            //got to ticket confirm with cancel status msg
            
            NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            
            for (UIViewController *aViewController in arrofNavoagtionsCon) {
                if ([aViewController isKindOfClass:[Movies_EventsViewController class]]) {
                    [self.navigationController popToViewController:aViewController animated:YES];
                    break;
                }
                else{
                    Movies_EventsViewController *MoviesviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"Movies_EventsViewController"];
                    [self.navigationController pushViewController:MoviesviewVC animated:YES];
                    break;
                }
            }
            
        }
    }
    else if (alertView.tag == SERVER_ERROR_ALERT)
    {
        if (buttonIndex == 0)
        {
            
            if (serviceRequestTimer != nil)
            {
                [serviceRequestTimer invalidate];
                serviceRequestTimer=nil;
            }

            //got to ticket confirm with cancel status msg
            
            NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            
            for (UIViewController *aViewController in arrofNavoagtionsCon) {
                if ([aViewController isKindOfClass:[Movies_EventsViewController class]]) {
                    [self.navigationController popToViewController:aViewController animated:YES];
                    break;
                }
                else{
                    Movies_EventsViewController *MoviesviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"Movies_EventsViewController"];
                    [self.navigationController pushViewController:MoviesviewVC animated:YES];
                    break;
                }
            }
            

            }
    }
    else if (alertView.tag == EVENT_TICKET_CANCEL_TAG)
    {
        
        if (serviceRequestTimer != nil)
        {
            [serviceRequestTimer invalidate];
            serviceRequestTimer=nil;
        }
 
        
        if (buttonIndex == 0) {
            
            NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            int index = 0;
            
            for(int i=0 ; i<[arrofNavoagtionsCon count] ; i++)
            {
                if([[arrofNavoagtionsCon objectAtIndex:i] isKindOfClass:NSClassFromString(@"EventsViewController")])
                {
                    index = i;
                    break;
                }
            }
            if (index != 0) {
                
                [self.navigationController popToViewController:[arrofNavoagtionsCon objectAtIndex:index] animated:YES];
            }
            else{
                
                EventsViewController *eventVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventsViewController"];
                [self.navigationController pushViewController:eventVC animated:NO];
                
            }

        }
        
    }
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
-(void)confirmTicketsWithTransactionID:(NSString *)transactionID
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn confirmTicketsWithTransactionID:transactionID];
    [connectionsArr addObject:conn];
}
-(void)confirmEventTicketwithOrderID:(NSString *)OrderId
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn checkEventBookingwithEventOrderId:OrderId];
    [connectionsArr addObject:conn];
}



#pragma mark
#pragma mark SMSCountry Connection Delegate Methods
#pragma mark

- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:CONFIRM_TICKETS]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        ConfirmTicketsParseOperation *cParser = [[ConfirmTicketsParseOperation alloc] initWithData:data delegate:self andRequestMessage:CONFIRM_TICKETS];
        [queue addOperation:cParser];
        [parsersArr addObject:cParser];
        data = nil;
    }
    
    if ([reqMessage isEqualToString:CANCEL_CONFIRMATION]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        CancelRequestParseOpeartion *cancelParser = [[CancelRequestParseOpeartion alloc] initWithData:data delegate:self andRequestMessage:CANCEL_CONFIRMATION];
        [queue addOperation:cancelParser];
        [parsersArr addObject:cancelParser];
        data = nil;
    }
    
    if ([reqMessage isEqualToString:EVENT_TICKET_CONFIRMATION]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        EventTicketConfirmationParseOperation *eveParser = [[EventTicketConfirmationParseOperation alloc] initWithData:data delegate:self andRequestMessage:EVENT_TICKET_CONFIRMATION];
        [queue addOperation:eveParser];
        [parsersArr addObject:eveParser];
        data = nil;
    }

}

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:CONFIRM_TICKETS])
    {
        if (serviceRequestTimer != nil)
        {
            [serviceRequestTimer invalidate];
            serviceRequestTimer=nil;
        }
        [scUtils hideLoader];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
    if ([reqMessage isEqualToString:CANCEL_CONFIRMATION])
    {
        if (serviceRequestTimer != nil)
    {
        [serviceRequestTimer invalidate];
        serviceRequestTimer=nil;
    }
        [scUtils hideLoader];

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
    if ([reqMessage isEqualToString:EVENT_TICKET_CONFIRMATION])
    {
        if (serviceRequestTimer != nil)
        {
            [serviceRequestTimer invalidate];
            serviceRequestTimer=nil;
        }
        [scUtils hideLoader];

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
    
}

#pragma mark
#pragma mark CommonParserOperation Delegate methods
#pragma mark

- (void)didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr {
    
    if ([reqMsg isEqualToString:CONFIRM_TICKETS]) {
        [self performSelectorOnMainThread:@selector(handleLoadedpayment:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
    if ([reqMsg isEqualToString:EVENT_TICKET_CONFIRMATION]) {
        [self performSelectorOnMainThread:@selector(handleeventTicketConfirm:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:CONFIRM_TICKETS]) {
        [self performSelectorOnMainThread:@selector(handleParserErrorti:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:EVENT_TICKET_CONFIRMATION]) {
        [self performSelectorOnMainThread:@selector(handleParserErroreventTi:) withObject:error waitUntilDone:NO];
    }
    queue = nil;
}



#pragma mark
#pragma mark Handling Parsed data methods
#pragma mark


-(void)handleeventTicketConfirm:(NSArray *)parsedArr{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
  //  NSLog(@"parser response for payment success for ticktes at ticket confirm :%@",parsedArr);
    
    
    
    // if parsed Arr count is greater then zero. Now we can insert the user into localdb if user doesnot exist, if user exists then update localdb data
    if([parsedArr count]>0)
    {
        NSMutableDictionary *cnfmDictionary = [parsedArr objectAtIndex:0];
        
        if ([[cnfmDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[cnfmDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            
//            if (serviceRequestTimer != nil)
//            {
//                [serviceRequestTimer invalidate];
//                serviceRequestTimer=nil;
//            }
//            
            
            [scUtils hideLoader];

            lblMoviewName.text = delegateApp.selectedEvent.EventName;
            lblTime.text       = delegateApp.selectedEvent.startTime;
            if ([delegateApp.strEventDateasPerCate isEqualToString:@""]) {
                
                lblDate.text = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.startDate];
                
            }
            else{
                
                lblDate.text = [NSString stringWithFormat:@"%@",delegateApp.strEventDateasPerCate];
            }

//            lblDate.text       = delegateApp.strEventDateasPerCate;
            lblScreen.text     = delegateApp.selectedEvent.venue;
            lblPlace.text      = delegateApp.selectedEvent.entryRestriction;
//            lblofTicketsCount.text = [NSString stringWithFormat:@"%@",delegateApp.strnoofEventTickets];
            lblAllocatedSeats.text = [NSString stringWithFormat:@"%@",delegateApp.strnoofEventTickets];
            
            
            
            [lblReservationCode setText:[cnfmDictionary objectForKey:EVENT_TICKET_RESERVATION_CODE]];
            imgviewofQRcode.imageURL  = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[cnfmDictionary objectForKey:EVENT_TICKET_BOOKEDQRCODE_URL]]];
//            [lblAllocatedSeats setText:self.noofEventTickets];
            
            
            
            
                [imgviewofsBg setHidden:NO];
                [imgviewofQRcode setHidden:NO];
                [lblReservationCode setHidden:NO];
                [lblreservationsub setHidden:NO];
                [lblconfirmtitle1 setHidden:NO];
                [lblconfirmtitle2 setHidden:NO];
                [imgviewofconfirm setHidden:NO];
                [imgviewofMovie setHidden:NO];
                [lblMoviewName setHidden:NO];
                [lblDate setHidden:NO];
                [lblTime setHidden:NO];
                [lblPlace setHidden:NO];
                [lblScreen setHidden:NO];
                [imgviewofplace setHidden:NO];
                [imgviewofScreen setHidden:NO];
                [imgviewofMoviename setHidden:NO];
                [imgviewofdate setHidden:NO];
                [imgviewforSeatsNumb setHidden:NO];
                [lblAllocatedSeats setHidden:NO];
           

            
            if ([[cnfmDictionary objectForKey:EVENT_TICKET_isREGISTERORNOT] isEqualToString:@"1"]) {
                
            
                [lblforSentEmailPwd setText:[NSString stringWithFormat:@"we have registered your email and sent a confirmation email with password to : %@",delegateApp.strUserEmailis]];
                [lblforSentEmailPwd setHidden:NO];
                [btnLogin setHidden:NO];
                [btnbookanotherTick setHidden:NO];
                
            
            }
            else{
                
                
                [btnbookanotherTick setHidden:NO];
                
                [btnbookanotherTick setFrame:CGRectMake(ViewWidth/2-btnbookanotherTick.frame.size.width/2, btnbookanotherTick.frame.origin.y, btnbookanotherTick.frame.size.width, btnbookanotherTick.frame.size.height)];

            }
        
            
        }

        
   
    else if ([[cnfmDictionary valueForKey:STATUS] isEqualToString:@"false"] || [[cnfmDictionary valueForKey:STATUS] isEqualToString:@"False"])
    {
        
//        if (serviceRequestTimer != nil)
//        {
//            [serviceRequestTimer invalidate];
//            serviceRequestTimer=nil;
//        }
        
        [scUtils hideLoader];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[cnfmDictionary valueForKey:ERROR_MESSAGE] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=EVENT_TICKET_CANCEL_TAG;
        [alert show];
       
        

    }
 }
    else
    {
        
//        if (serviceRequestTimer != nil)
//        {
//            [serviceRequestTimer invalidate];
//            serviceRequestTimer=nil;
//        }
        
        [scUtils hideLoader];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
        

    }

    
    
}



-(void)handleParserErroreventTi:(NSError *)error{
    
    
}


- (void) handleLoadedpayment:(NSArray *)parsedArr {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
  //  NSLog(@"parser response for payment success for ticktes at ticket confirm :%@",parsedArr);
    
    
    
    // if parsed Arr count is greater then zero. Now we can insert the user into localdb if user doesnot exist, if user exists then update localdb data
    if([parsedArr count]>0)
    {
        NSMutableDictionary *cnfmDictionary = [parsedArr objectAtIndex:0];
        
        if ([[cnfmDictionary valueForKey:STATUS] isEqualToString:@"true"] || [[cnfmDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            if ([[cnfmDictionary valueForKey:CONFIRM_TICKETS_TAG] isEqualToString:@"1"])
            {

                if (serviceRequestTimer != nil)
                {
                    [serviceRequestTimer invalidate];
                    serviceRequestTimer=nil;
                }
//                lblTimerDetails.hidden=YES;
//                imgvoewofTimer.hidden=YES;
                [scUtils hideLoader];
                currentSeat = [cnfmDictionary valueForKey:CONFIRM_OBJECT];
                [lblosPaymentStatus setHidden:YES];
                
                lblMoviewName.text=delegateApp.selectedMovie.movieName;
                NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
                [dateFormate setDateFormat:@"MMM dd ,yyyy hh:mma"];
                NSDate *newdate = [dateFormate dateFromString:currentSeat.date];
                dateFormate.dateFormat=@"MMM dd,yyyy";
                lblDate.text=[dateFormate stringFromDate:newdate];
                
                NSDateFormatter *timeFormate = [[NSDateFormatter alloc]init];
                [timeFormate setDateFormat:@"MMM dd ,yyyy hh:mma"];
                NSDate *newtime = [timeFormate dateFromString:currentSeat.date];
                timeFormate.dateFormat=@"hh:mm a";
                lblTime.text=[timeFormate stringFromDate:newtime];
               
              
                
                lblofTicketsCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[[currentSelec.selectedSeatsArr objectAtIndex:0]componentsSeparatedByString:@","]count]];
                
                lblAllocatedSeats.text= [NSString stringWithFormat:@"%@",[self.currentSelec.selectedSeatsArr objectAtIndex:0]];
           //     NSLog(@"%@ ------ %@",lblofTicketsCount.text,lblAllocatedSeats.text);
                
                
                lblScreen.text=self.currentSelec.screenName;
                lblPlace.text =  [NSString stringWithFormat:@"%@ , %@",[self.currentSelec.theaterName uppercaseStringWithLocale:[NSLocale currentLocale]],self.currentSelec.strTheaterNameArabic];
                lblReservationCode.text=[cnfmDictionary objectForKey:CONFIRM_RESERVATION_CODE];
                imgviewofQRcode.imageURL=[NSURL URLWithString:[cnfmDictionary objectForKey:CONFIRM_QR_IMAGE]];
                
                [self CreateNotificationWithConfiCode:[cnfmDictionary objectForKey:CONFIRM_RESERVATION_CODE]];
                
                
                [imgviewofsBg setHidden:NO];
                [lblReservationCode setHidden:NO];
                [lblreservationsub setHidden:NO];
                [lblAllocatedSeats setHidden:NO];
                [lblofTicketsCount setHidden:NO];
                [imgviewforSeatsNumb setHidden:NO];
                [imgviewofQRcode setHidden:NO];
                [lblconfirmtitle1 setHidden:NO];
                [lblconfirmtitle2 setHidden:NO];
                [imgviewofconfirm setHidden:NO];
                [imgviewofMovie setHidden:NO];
                [lblMoviewName setHidden:NO];
                [lblDate setHidden:NO];
                [lblTime setHidden:NO];
                [lblPlace setHidden:NO];
                [lblScreen setHidden:NO];
                [imgviewofplace setHidden:NO];
                [imgviewofScreen setHidden:NO];
                [imgviewofMoviename setHidden:NO];
                [imgviewofdate setHidden:NO];

                
                if ([[cnfmDictionary objectForKey:CONFIRM_ISREGISTRATIONNOW] isEqualToString:@"1"]){
                    
                    [lblforSentEmailPwd setText:[NSString stringWithFormat:@"we have registered your email and sent a confirmation email with password to : %@",delegateApp.strUserEmailis]];
                    [lblforSentEmailPwd setHidden:NO];
                    [btnLogin setHidden:NO];
                    [btnbookanotherTick setHidden:NO];
                }
                else{
                    
                    [btnbookanotherTick setHidden:NO];
                    
                     [btnbookanotherTick setFrame:CGRectMake(ViewWidth/2-btnbookanotherTick.frame.size.width/2, btnbookanotherTick.frame.origin.y, btnbookanotherTick.frame.size.width, btnbookanotherTick.frame.size.height)];
                }
            }
        }
        else if ([[cnfmDictionary valueForKey:STATUS] isEqualToString:@"false"] || [[cnfmDictionary valueForKey:STATUS] isEqualToString:@"False"])
        {
            
            if (serviceRequestTimer != nil)
            {
                [serviceRequestTimer invalidate];
                serviceRequestTimer=nil;
            }
                       [scUtils hideLoader];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[cnfmDictionary valueForKey:ERROR_MESSAGE] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag=SERVER_ERROR_ALERT;
            [alert show];
            
        }
    }
    else
    {
        if (serviceRequestTimer != nil)
        {
            [serviceRequestTimer invalidate];
            serviceRequestTimer=nil;
        }
        [scUtils hideLoader];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
 
    }
}


-(void)CreateNotificationWithConfiCode:(NSString *)strconfirmatinCode{
    
    NSString *notificationTimeis = [NSString stringWithFormat:@"%@ %@",self.currentSelec.date,self.currentSelec.showTime];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate *pickerDate = [[NSDate alloc] init];
    pickerDate = [dateFormatter dateFromString:notificationTimeis];
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:pickerDate];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:pickerDate];
    // Set up the fire time
    if (dateComponents != nil) {
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        [dateComps setDay:[dateComponents day]];
        [dateComps setMonth:[dateComponents month]];
        [dateComps setYear:[dateComponents year]];
        [dateComps setHour:[timeComponents hour]];
        [dateComps setMinute:[timeComponents minute]-30];
        [dateComps setSecond:[timeComponents second]];
        NSDate *itemDate = [calendar dateFromComponents:dateComps];
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = itemDate;
        localNotif.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        localNotif.alertBody = [NSString stringWithFormat:@"%@ is about to begin in 30 minutes at %@,%@",self.currentSelec.movieName,self.currentSelec.theaterName,self.currentSelec.screenName];
        localNotif.alertAction = @"View";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        singleTon.nooflocalNotifications = singleTon.nooflocalNotifications+1;
        localNotif.applicationIconBadgeNumber = singleTon.nooflocalNotifications;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:localNotif];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString  stringWithFormat:@"%@",strconfirmatinCode]];
        
    }

}



-(IBAction)btnLoginClicked:(id)sender{
    
    
    LoginViewController *loginVc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVc animated:YES];
    
}


- (void) handleParserErrorti:(NSError *) error
{
    
    if (serviceRequestTimer != nil)
    {
        [serviceRequestTimer invalidate];
        serviceRequestTimer=nil;
    }
    [scUtils hideLoader];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=SERVER_ERROR_ALERT;
    [alert show];
    
    
}

-(void)handleLoadedCancelRequest:(NSArray *)parserArr
{
    if([parserArr count]>0)
    {
        NSMutableDictionary *cancelDictionary = [parserArr objectAtIndex:0];
        
        if ([[cancelDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            singleTon.seatCnfmtn=nil;
            singleTon.transactiontimerCount=1;

            
            if (serviceRequestTimer != nil)
            {
                [serviceRequestTimer invalidate];
                serviceRequestTimer=nil;
            }
            
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
    }
    else
    {
        if (serviceRequestTimer != nil)
        {
            [serviceRequestTimer invalidate];
            serviceRequestTimer=nil;
        }

               [scUtils hideLoader];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
        
    }
}

-(void)handleCancelCnfmntParserError:(NSError *)error
{
    
    if (serviceRequestTimer != nil)
    {
        [serviceRequestTimer invalidate];
        serviceRequestTimer=nil;
    }

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=SERVER_ERROR_ALERT;
    [alert show];
    
   
   
}



-(IBAction)btnBookAnotherTicketClicked:(id)sender
{
    
    NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *aViewController in arrofNavoagtionsCon) {
        if ([aViewController isKindOfClass:[HomeViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
            break;
        }
        else{
            HomeViewController *homeviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            [self.navigationController pushViewController:homeviewVC animated:NO];
            break;
        }
    }
    
    
}

-(IBAction)btnShareClicked:(id)sender
{
    
    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
    
    FBSDKShareLinkContent *sharecontent =[[FBSDKShareLinkContent alloc] init];
    
    if (singleTon.isMovieSelected) {
        
        sharecontent.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",delegateApp.selectedMovie.strMovieUrlIs]];

    }
    else{
       sharecontent.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",delegateApp.selectedEvent.strEventUrlIs]];

    }
    
    
    [shareDialog setShareContent:sharecontent];
    shareDialog.mode = FBSDKShareDialogModeWeb;
    shareDialog.delegate = self;
    [shareDialog show];

}



#pragma mark - fbshare delegate methods
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
   // NSLog(@"rere e re rer e:%@",results);
    
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
  //  NSLog(@"errererer is :%@",error);
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
    
  //  NSLog(@"sahre is calcned");
    
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
