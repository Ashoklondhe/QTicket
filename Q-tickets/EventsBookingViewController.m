//
//  EventsBookingViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 19/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "EventsBookingViewController.h"
#import "EventInfoTableViewCell.h"
#import "UserDetailsViewController.h"
#import "Q-ticketsConstants.h"
#import "HomeViewController.h"

#import "LoginViewController.h"
#import "MyBookingsViewController.h"
#import "MyProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "MyVouchersViewController.h"
#import "MobileNumVerifyViewController.h"


#import "EGOImageView.h"
#import "MarqueeLabel.h"
#import "AppDelegate.h"

#import "UINavigationController+MenuNavi.h"
#import "QticketsSingleton.h"
#import "EventsViewController.h"


@interface EventsBookingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
     IBOutlet UIView       *homeView;
     IBOutlet UIView       *viewofEventInfo;
     IBOutlet EGOImageView *imgofEvent;
     IBOutlet UILabel      *lblofEventNameRating;
     IBOutlet MarqueeLabel  *lblofEventDate;
     IBOutlet UILabel      *lblofEventTime;
     IBOutlet UILabel      *lblofEventtype;
     IBOutlet UITableView  *tbofEventInfo;
     BOOL                  mClicked;
     IBOutlet EGOImageView *imgviewofmoviebg;
     IBOutlet MarqueeLabel *lblViewtitle;
     AppDelegate           *delegateApp;
    IBOutlet UITableView   *tbofnoofSeatsforEvent;
    BOOL                   tbofSelectSeatsClicked;
    IBOutlet MarqueeLabel       *lblEventVenue;
    NSMutableArray         *arrofEventTickets;
    NSMutableArray         *arrNoofSeatsData;
    NSInteger              noOfrowsforSeatsSelection;
    IBOutlet UILabel       *lblofFinalSelectedSeatDesc;
    NSInteger              selectedEventCategoryIndex;
    NSInteger              noofSeatscountIndex;

    
    
    IBOutlet UIView      *viewforCostDesc;
    
    
    NSMutableArray *arrofSelectedCategoryIndex,*arrofSelectedNoofSeats,*arrofUserTapedIndexes;
    
    
    BOOL      isCategorySelection;
    NSInteger ifCategoryisonlyOne;
    CGFloat overallCost;
    NSMutableString *strTicketPriceIdswithCategoryies;
    
    int noofseats,tottalNoofSeats;
    IBOutlet UIView *viewforEventTicketDetails;
    
    BOOL isToShownoofSeats;
    BOOL ifNoticketsSelected;
    
    IBOutlet UIButton *btnBookNow;
    IBOutlet UIButton *btnReset;
    
    
    
    
}

@end

@implementation EventsBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    delegateApp            = QTicketsAppDelegate;
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }

    mClicked               = NO;
    arrofEventTickets      = [[NSMutableArray alloc] init];
    arrNoofSeatsData       = [[NSMutableArray alloc] init];
    arrofSelectedCategoryIndex = [[NSMutableArray alloc] init];
    arrofSelectedNoofSeats     = [[NSMutableArray alloc] init];
    arrofUserTapedIndexes      = [[NSMutableArray alloc] init];
    noOfrowsforSeatsSelection  = 0;
    noofSeatscountIndex        = 0;
    selectedEventCategoryIndex    = -99;
    ifCategoryisonlyOne           = -99;
    
    [tbofnoofSeatsforEvent setHidden:YES];
    tbofSelectSeatsClicked  = NO;
    isCategorySelection     = NO;
    isToShownoofSeats       = NO;
    ifNoticketsSelected     = NO;
    rightMenu              = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    rightMenu.setDelegate = self;
    if ([SMSCountryUtils isIphone]) {
        
        [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight-MenutopStripHei)];
        
    }
    else{
        
        [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+50, MenuWidth+150, ViewHeight-MenutopStripHei+50)];
        
        
    }

    [self.view addSubview:rightMenu.view];
    [self setSelectedData];

    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeClicked:)];
    [homeView addGestureRecognizer:swiperight];
    
    
    [viewforCostDesc.layer   setBorderColor: [ImgviewBorderColour CGColor]];
    [viewforCostDesc.layer   setBorderWidth: 1.0];
    
    
    UITapGestureRecognizer *taponOutSide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CheckMenuSelection:)];
    [viewforEventTicketDetails addGestureRecognizer:taponOutSide];
    
  
}


-(void)setSelectedData{
    
    lblViewtitle.marqueeType    = MLContinuous;
    lblViewtitle.trailingBuffer = 15.0;
    [lblViewtitle setText:[NSString stringWithFormat:@"%@",delegateApp.selectedEvent.EventName]];
    NSString *imagtThumbnailurl   = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.thumbnailURL];
    imagtThumbnailurl             =    [imagtThumbnailurl stringByReplacingOccurrencesOfString:@"/App_Images/" withString:@"/movie_Images/"];
    imagtThumbnailurl             =  [imagtThumbnailurl stringByReplacingOccurrencesOfString:@"_banner." withString:@"_thumb."];
    imgofEvent                    = [imgofEvent initWithPlaceholderImage:[UIImage imageNamed:@"bg.png"]];
    imgofEvent.imageURL       = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imagtThumbnailurl]];
    lblofEventNameRating.text = delegateApp.selectedEvent.EventName;
    lblofEventDate.text       = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.startDate];
    lblofEventTime.text       = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.startTime];
    lblofEventtype.text       = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.entryRestriction];
    [viewforCostDesc setHidden:YES];
    
        
    lblEventVenue.marqueeType    = MLContinuous;
    lblEventVenue.trailingBuffer = 15.0;
    lblofEventDate.marqueeType  = MLContinuous;
    lblofEventDate.trailingBuffer = 15.0;

    lblEventVenue.text        = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.venue];
    
    if ([delegateApp.selectedEvent.strNoOfTktCategory isEqualToString:@"1"]) {
        
        isCategorySelection = YES;
    }
    else{
        
        isCategorySelection = NO;
    }
    
    

    [arrofEventTickets addObjectsFromArray:delegateApp.selectedEvent.eventTicketsArray];
    
    
    
    for (int k = 0; k<arrofEventTickets.count; k++) {
        
        [arrofSelectedCategoryIndex addObject:@"99"];
        [arrofSelectedNoofSeats addObject:@"99"];
        
    }
    
//    if((arrofEventTickets.count * 87) <= 250)
//    {
//    [tbofEventInfo setFrame:CGRectMake(tbofEventInfo.frame.origin.x, tbofEventInfo.frame.origin.y, tbofEventInfo.frame.size.width, (arrofEventTickets.count * 87))];
//    }
//    else{
        [tbofEventInfo setFrame:CGRectMake(tbofEventInfo.frame.origin.x, tbofEventInfo.frame.origin.y, tbofEventInfo.frame.size.width, tbofEventInfo.frame.size.height)];
        
//    }
    [tbofEventInfo reloadData];
    
    
    [viewforEventTicketDetails.layer setBorderColor: [ImgviewBorderColour CGColor]];
    [viewforEventTicketDetails.layer setBorderWidth: 1.0];
    
}


-(void)hideMenuBar{
    
    
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

-(void)showMenuBar{
    
    
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



-(void)viewWillAppear:(BOOL)animated{
    
    
    if (mClicked == YES) {
        
        
        [self hideMenuBar];
    }
    
}


-(void)rightSwipeClicked:(UISwipeGestureRecognizer *)swipeGes{
    
    
    if (mClicked == YES) {
        
        [self hideMenuBar];
    }
    
    
    
    
    
}

-(void)gotoHomeSwipeClicked:(UISwipeGestureRecognizer *)swipeGes{
    
    
    
    if (mClicked == YES) {
        
        [self hideMenuBar];

    }
    
    
    [self btnBackClicked:swipeGes];
    
}


-(void)CheckMenuSelection:(UITapGestureRecognizer *)tapGesture{
    
    
    if (mClicked == YES) {
        
        [self hideMenuBar];
    }
    
    if (isToShownoofSeats) {
        
        [tbofnoofSeatsforEvent setHidden:YES];
        isToShownoofSeats = NO;
        [tbofEventInfo setContentOffset:CGPointMake(0, 0)];
    }
    
}

-(IBAction)btnMenuClicked:(id)sender{
    
    [rightMenu LoadData];

    
    if (mClicked == NO) {
        
        [self showMenuBar];
    }
    else{
        [self hideMenuBar];
    }
    
    
    
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



#pragma mark EventInfo TableviewDataSourceMethods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 22) {
        return [arrofEventTickets count];
    }
    else{
    return noOfrowsforSeatsSelection;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     if (tableView.tag == 22) {
    if ([SMSCountryUtils isIphone]) {
        
        return 40.0;
    }
    else{
        
        return 70.0;
    }
     }
     else{
         
         return 44.0;
     }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    if (tableView.tag == 22) {
        
           EventInfoTableViewCell *evetInfoCell = (EventInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EventInfoTableViewCell"];
        if (evetInfoCell == nil) {
            
            evetInfoCell = [[[NSBundle mainBundle]loadNibNamed:@"EventInfoTableViewCell" owner:self options:nil] objectAtIndex:0];
            
        }
        
        TicketTypes *ticketobj = [[TicketTypes alloc] init];
        ticketobj              = [arrofEventTickets objectAtIndex:indexPath.row];
        
        [evetInfoCell.btnNumberofTickets addTarget:self action:@selector(btnEventTicketsSelect:) forControlEvents:UIControlEventTouchUpInside];
        [evetInfoCell.btnNumberofTickets setTag:indexPath.row];
        
        [evetInfoCell.btnNumberofTickets.layer setBorderWidth:2];
        [evetInfoCell.btnNumberofTickets.layer setCornerRadius:5];
        [evetInfoCell.btnNumberofTickets.layer setBorderColor:[UIColor whiteColor].CGColor];
       
        [evetInfoCell.imgViewofBackground.layer setCornerRadius:3];
        [evetInfoCell.imgViewofBackground.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [evetInfoCell.imgViewofBackground.layer setBorderWidth:2];
        
        if (isCategorySelection) {
            
            if (ifCategoryisonlyOne != -99) {
                
                if(indexPath.row == ifCategoryisonlyOne ){
                
                [evetInfoCell.btnNumberofTickets setTitle:[NSString stringWithFormat:@"%@ Seats",[arrNoofSeatsData objectAtIndex:noofSeatscountIndex]] forState:UIControlStateNormal];
                

            }
            else{
                
                [evetInfoCell.btnNumberofTickets setTitle:@"Select" forState:UIControlStateNormal];
            }
            
            
            }
        }
        else{
            NSInteger indexis = indexPath.row;
            
            if ([arrofSelectedCategoryIndex containsObject:[NSString stringWithFormat:@"%ld",(long)indexis]]) {
                
                [evetInfoCell.btnNumberofTickets setTitle:[NSString stringWithFormat:@"%@ Seats",[arrofSelectedNoofSeats objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                
            }
            else{
                
                [evetInfoCell.btnNumberofTickets setTitle:@"Select" forState:UIControlStateNormal];
            }
            

        }
               
        evetInfoCell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *myBackView = [[UIView alloc] initWithFrame:evetInfoCell.frame];
        myBackView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        evetInfoCell.selectedBackgroundView = myBackView;
        
        evetInfoCell.lbltypeofTicketVal.text = ticketobj.ticketType;
        evetInfoCell.lblpriceofTicketVal.text = [NSString stringWithFormat:@"%@ QAR",ticketobj.ticketPrice];
               
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

        return evetInfoCell;
        
    }

    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[arrNoofSeatsData objectAtIndex:indexPath.row]];
        if ([SMSCountryUtils isIphone]) {
            [cell.textLabel setFont:[UIFont fontWithName:LATO_REGULAR size:12]];

        }
        else{
            [cell.textLabel setFont:[UIFont fontWithName:LATO_REGULAR size:15]];
        }
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        return cell;
    }
}


-(void)btnEventTicketsSelect:(id)sender{
    
    
    UIButton *btnSelect = (UIButton *)sender;
    
    
    selectedEventCategoryIndex = btnSelect.tag;
    
    if (isCategorySelection) {
        
        ifCategoryisonlyOne  = btnSelect.tag;
        
    }
    else{
        
        [arrofSelectedCategoryIndex replaceObjectAtIndex:btnSelect.tag withObject:[NSString stringWithFormat:@"%ld",(long)btnSelect.tag]];
        [arrofSelectedNoofSeats replaceObjectAtIndex:btnSelect.tag withObject:@""];
    }
    
    
    if (isToShownoofSeats) {
        
        [tbofnoofSeatsforEvent setHidden:YES];
        
        isToShownoofSeats = NO;
        
        tbofEventInfo.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

        [tbofEventInfo setContentOffset:CGPointMake(0,0)animated:YES];

    }
    else{
    
        [tbofnoofSeatsforEvent setHidden:NO];
        
 

        
        TicketTypes *ticketobj = [[TicketTypes alloc] init];
        ticketobj              = [arrofEventTickets objectAtIndex:btnSelect.tag];
        
        
        
        [self setSelectSeatsData:[ticketobj.ticketAdmit integerValue] withnofofTickets:[ticketobj.strnoofTicketsPerTransaction integerValue]];
        
        isToShownoofSeats  = YES;

        
        
    CGFloat height;
    
        CGFloat HightofTbis;
        
        if([SMSCountryUtils isIphone])
        {
            HightofTbis = 200;
            height = 42.0f;
        }
        else{
            
            if (noOfrowsforSeatsSelection*44 > 400) {
                HightofTbis = 400;
            }
            else{
                HightofTbis = noOfrowsforSeatsSelection*44;

            }
            
            height = 70.0f;
        }
    
    tbofEventInfo.contentInset = UIEdgeInsetsMake(0, 0, height * btnSelect.tag, 0);
    
    [tbofEventInfo setContentOffset:CGPointMake(0, (btnSelect.tag * height) )animated:YES];
    
        
    [tbofnoofSeatsforEvent setFrame:CGRectMake(btnSelect.frame.origin.x,viewforEventTicketDetails.frame.origin.y+tbofEventInfo.frame.origin.y+btnSelect.frame.origin.y+btnSelect.frame.size.height+2, btnSelect.frame.size.width, HightofTbis)];
    
    
      }
    
}



-(void)setSelectSeatsData:(NSInteger )selctedAdmit withnofofTickets:(NSInteger )noofticketsperTrans{
    [arrNoofSeatsData removeAllObjects];
    switch (selctedAdmit) {
        case 1:
            noOfrowsforSeatsSelection = noofticketsperTrans;
            break;
            case 2:
            noOfrowsforSeatsSelection = noofticketsperTrans;
            break;
            case 3:
            noOfrowsforSeatsSelection = noofticketsperTrans;
            break;
           case 4:
            noOfrowsforSeatsSelection = noofticketsperTrans;
            break;
          case 5:
            noOfrowsforSeatsSelection = noofticketsperTrans;
            break;
        default:
            noOfrowsforSeatsSelection = noofticketsperTrans;
            break;
    }
//    [arrNoofSeatsData addObject:@"0"];
    for (int i=0; i<noOfrowsforSeatsSelection; i++) {
        
     [arrNoofSeatsData addObject:[NSString stringWithFormat:@"%ld",((i+1)*selctedAdmit)]];
    }
   
    [tbofnoofSeatsforEvent setHidden:NO];
    [tbofnoofSeatsforEvent reloadData];
    
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==22) {
        
//        [cell setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
        
    }
    else{
        
        [cell setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView.tag == 33) {
        
        [tbofnoofSeatsforEvent setHidden:YES];
       
        if(indexPath.row>0)
        {
            ifNoticketsSelected = NO;
        }
        else{
            ifNoticketsSelected = YES;
         }
        if (isCategorySelection) {
                noofSeatscountIndex = indexPath.row;
            }
            else{
                [arrofSelectedNoofSeats replaceObjectAtIndex:selectedEventCategoryIndex withObject:[NSString stringWithFormat:@"%@",[arrNoofSeatsData objectAtIndex:indexPath.row]]];
            }
            [tbofEventInfo reloadData];
            [self createOverAllPayment];
            [viewforCostDesc setHidden:NO];
            isToShownoofSeats  = NO;

        
       }
    
    else{
        
       
    
    }
    
   

}



-(void)createOverAllPayment{
    
    noofseats                  = 0;
    overallCost                = 0;
    tottalNoofSeats = 0;

    strTicketPriceIdswithCategoryies = [[NSMutableString alloc] init];
    
    if (isCategorySelection) {
            
            TicketTypes *ticketType = [arrofEventTickets objectAtIndex:selectedEventCategoryIndex];
            noofseats = [[NSString stringWithFormat:@"%@",[arrNoofSeatsData objectAtIndex:noofSeatscountIndex]] intValue];
            noofseats = noofseats * [ticketType.ticketAdmit intValue];
        
            overallCost += noofseats * [ticketType.ticketPrice floatValue];
            tottalNoofSeats = tottalNoofSeats + noofseats;
        
        //need  to add event master id
        
            [strTicketPriceIdswithCategoryies appendString:[NSString stringWithFormat:@"%@-%d,",ticketType.ticketPriceId,tottalNoofSeats]];
            
        
        }
        else{
            
            for (int k = 0; k<arrofEventTickets.count; k++) {
                
                if (![[arrofSelectedNoofSeats objectAtIndex:k] isEqualToString:@"99"]) {
                    
                    TicketTypes *typeis = [arrofEventTickets objectAtIndex:k];
                    noofseats = [[NSString stringWithFormat:@"%@",[arrofSelectedNoofSeats objectAtIndex:k]] intValue];
                    noofseats = noofseats * [typeis.ticketAdmit intValue];
                    overallCost += noofseats * [typeis.ticketPrice floatValue];
                    tottalNoofSeats = tottalNoofSeats + noofseats;
                    int noofticketspercat = 0;
                    noofticketspercat = noofticketspercat + noofseats;
                    [strTicketPriceIdswithCategoryies appendString:[NSString stringWithFormat:@"%@-%d,",typeis.ticketPriceId,noofticketspercat]];
                }
                
            }
            
        }
    
    lblofFinalSelectedSeatDesc.text = [NSString stringWithFormat:@"Number of Guests : %d( %d Persons ) | Total Price : %.2f QAR",tottalNoofSeats,tottalNoofSeats,overallCost];
    
    
    
    
    
    
    
}


-(IBAction)btnResetSeats:(id)sender{
    
    if (tottalNoofSeats>0) {
    
    [arrofSelectedCategoryIndex removeAllObjects];
    [arrNoofSeatsData removeAllObjects];
    
    [arrofSelectedCategoryIndex removeAllObjects];
    [arrofSelectedNoofSeats removeAllObjects];
    
    noOfrowsforSeatsSelection  = 0;
    noofSeatscountIndex        = 0;
    selectedEventCategoryIndex    = -99;
    ifCategoryisonlyOne           = -99;
    if ([delegateApp.selectedEvent.strNoOfTktCategory isEqualToString:@"1"]) {
        
        isCategorySelection = YES;
    }
    else{
        
        isCategorySelection = NO;
    }
    
    for (int k = 0; k<arrofEventTickets.count; k++) {
        
        [arrofSelectedCategoryIndex addObject:@"99"];
        [arrofSelectedNoofSeats addObject:@"99"];
        
    }
    
    [tbofEventInfo reloadData];
    if (tbofnoofSeatsforEvent.hidden == NO) {
        [tbofnoofSeatsforEvent setHidden:YES];
    }

    [viewforCostDesc setHidden:YES];
    isToShownoofSeats = NO;
        noofseats                  = 0;
        overallCost                = 0;
        tottalNoofSeats = 0;
        
    }
    
    
}

- (IBAction)btnBackClicked:(id)sender {
    
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
        
       [self.navigationController popViewControllerAnimated:YES];
    
    }

    
}
- (IBAction)btnBookNowClicked:(id)sender {
    
   

    if (tottalNoofSeats > 0) {
        
    TicketTypes *singleTicketTyep = [delegateApp.selectedEvent.eventTicketsArray objectAtIndex:selectedEventCategoryIndex];
    NSString *strTicketId = [NSString stringWithFormat:@"%@",singleTicketTyep.ticketMasterId];
    NSString *strTicketsCost = [NSString stringWithFormat:@"%.2f",overallCost];
    NSString *strTicketServiceCost = [NSString stringWithFormat:@"%@",singleTicketTyep.ticketServiceCharge];
    NSString *strnoofticketsperTrans = [NSString stringWithFormat:@"%@",strTicketPriceIdswithCategoryies];
    NSString *strseatsDescLab = [NSString stringWithFormat:@"Number of Guests : %d( %d Persons )",tottalNoofSeats,tottalNoofSeats];
    NSString *strDateAsPerCate = [NSString stringWithFormat:@"%@",singleTicketTyep.strEventDateasPerCate];
//    NSString *strnoofTickets  = [NSString stringWithFormat:@"%d",tottalNoofSeats];
    NSMutableDictionary *dictofEvent = [[NSMutableDictionary alloc] init];
    [dictofEvent setObject:strTicketId forKey:@"TicketTypeId"];
    [dictofEvent setObject:strTicketsCost forKey:@"TicketsCost"];
    [dictofEvent setObject:strnoofticketsperTrans forKey:@"TicketsPerCategory"];
    [dictofEvent setObject:strseatsDescLab forKey:@"SeatDesc"];
    [dictofEvent setObject:strTicketServiceCost forKey:@"TicketServiceCost"];
    [dictofEvent setObject:[NSString stringWithFormat:@"%d",tottalNoofSeats] forKey:@"NoofTickets"];
    [dictofEvent setObject:strDateAsPerCate forKey:@"EventDateIs"];


    QticketsSingleton  *singleTon = [QticketsSingleton sharedInstance];
    singleTon.isMovieSelected = NO;
    UserDetailsViewController *userdetailsvc    = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"UserDetailsViewController"];
        [delegateApp setStrEventDateasPerCate:strDateAsPerCate];
    [delegateApp setStrnoofEventTickets:[NSString stringWithFormat:@"%d",tottalNoofSeats]];
    [userdetailsvc setDictofEvebntData:dictofEvent];
    [self.navigationController pushViewController:userdetailsvc animated:YES];
    }
    else{
         [SMSCountryUtils showAlertMessageWithTitle:@"" Message:SELECT_ATLEAST_ONE_TICKETTYPE];
    }
}





//for QTA Summer Festival Event

-(IBAction)btnAllClicked:(id)sender
{
    delegateApp.strSelectedActivityforEvent = @"activitie";
    
    [self NavigatetoUserDetailsScreen];
    
}

-(IBAction)btnCultureClicked:(id)sender
{
    delegateApp.strSelectedActivityforEvent = @"activities_category/culture";

    [self NavigatetoUserDetailsScreen];

}

-(IBAction)btnEatingOutClicked:(id)sender
{
    
    delegateApp.strSelectedActivityforEvent = @"activities_category/eating-out";

    [self NavigatetoUserDetailsScreen];

}

-(IBAction)btnEntertainmentClicked:(id)sender{
    
    delegateApp.strSelectedActivityforEvent = @"activities_category/entertainment";

    [self NavigatetoUserDetailsScreen];

}

-(IBAction)btnOutDoorActiviClicked:(id)sender
{
    delegateApp.strSelectedActivityforEvent = @"activities_category/outdoor-nature";

    [self NavigatetoUserDetailsScreen];

}

-(IBAction)btnShoppingClicked:(id)sender
{
    delegateApp.strSelectedActivityforEvent = @"activities_category/shopping";

    [self NavigatetoUserDetailsScreen];

}

-(IBAction)btnSightseingClicked:(id)sender
{
    
    delegateApp.strSelectedActivityforEvent = @"activities_category/sightseeing";

    [self NavigatetoUserDetailsScreen];

    
}



-(void)NavigatetoUserDetailsScreen{
    
    NSMutableDictionary *dictofEvent = [[NSMutableDictionary alloc] init];
    [dictofEvent setObject:@"0" forKey:@"TicketTypeId"];
    [dictofEvent setObject:@"0" forKey:@"TicketsCost"];
    [dictofEvent setObject:@"0" forKey:@"TicketsPerCategory"];
    [dictofEvent setObject:@"0" forKey:@"SeatDesc"];
    [dictofEvent setObject:@"0" forKey:@"TicketServiceCost"];
    [dictofEvent setObject:@"0" forKey:@"NoofTickets"];
    [dictofEvent setObject:delegateApp.selectedEvent.startDate forKey:@"EventDateIs"];

    
    UserDetailsViewController *userDetailsVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"UserDetailsViewController"];
    [delegateApp setStrEventDateasPerCate:delegateApp.selectedEvent.startDate];
    [delegateApp setStrnoofEventTickets:[NSString stringWithFormat:@"%d",tottalNoofSeats]];
    [userDetailsVC setDictofEvebntData:dictofEvent];
    [self.navigationController pushViewController:userDetailsVC animated:YES];
    
    
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
