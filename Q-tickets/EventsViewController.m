//
//  EventsViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 01/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "EventsViewController.h"
#import "Q-ticketsConstants.h"
#import "Moview_EventsTableViewCell.h"
#import "MenuViewController.h"
#import "DescriptionViewController.h"
#import "ShowTimingsViewController.h"
#import "EventsBookingViewController.h"
#import "EventsWebViewController.h"

#import "LoginViewController.h"
#import "MyBookingsViewController.h"
#import "MyProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "MyVouchersViewController.h"
#import "MobileNumVerifyViewController.h"
#import "HomeViewController.h"


#import "EventsVO.h"
#import "AppDelegate.h"
#import "EventsTableViewCell.h"
#import "EventDescriptionViewController.h"
#import "Movies_EventsViewController.h"
#import "UINavigationController+Fade.h"
#import "UINavigationController+MenuNavi.h"

@interface EventsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tbofEvents;
    NSMutableArray       *arrofPictures;
    IBOutlet UILabel     *lblofTitle;
    IBOutlet UIImageView *imgviewofNavMov;
    IBOutlet UIView      *homeView;
    BOOL                 mClicked;
    //bottom view
    IBOutlet UIView     *viewofBottomOptions;
    IBOutlet UIButton   *bottomButton1;
    IBOutlet UIButton   *bottomButton2;
    IBOutlet UIButton   *bottomButton3;
    BOOL                bottomViewvisible;
    CGFloat             yOffset;
    //left side menu
    IBOutlet UITableView *tbofSelectionView;
    NSMutableArray       *arrofLeftSelections;
    BOOL                 leftsideSelectionViewVisible;
    CGFloat              CoorY;
    CGFloat              tbselleftHeight;
    //right side menu
    IBOutlet UITableView *tbofRightSideSelectionView;
    NSMutableArray       *arrofRightSelection;
    BOOL                 rightsideSelectionViewVisible;
    CGFloat              RightCoorY;
    CGFloat              tbselrightHeight;
    NSMutableArray       *arrofTableviewData;
    SMSCountryUtils      *scutilits;
    AppDelegate          *delegateApp;
    NSInteger            selectedCategoryIndex,selectedvenueIndex;
    NSString             *strselectedCategory,*strselectedVenue;
    NSInteger            selectedSet;
    BOOL                 eventsAvailable;

}
@property (assign, nonatomic) CATransform3D initialTransformation;

@end

@implementation EventsViewController
@synthesize initialTransformation,fromMovies,fromHome;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"960x1140_bg.png"]]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"960x1140_bg.png"]]];
        
    }
    
    yOffset                          = 0.0;
    arrofTableviewData               = [[NSMutableArray alloc]init];
    arrofLeftSelections              = [[NSMutableArray alloc]init];
    arrofRightSelection              = [[NSMutableArray alloc]init];
    scutilits                        = [[SMSCountryUtils alloc]init];
    delegateApp                      = QTicketsAppDelegate;
    selectedCategoryIndex            = 0;
    selectedvenueIndex               = 0;
    leftsideSelectionViewVisible     = NO;
    rightsideSelectionViewVisible    = NO;
    eventsAvailable                  = NO;
    strselectedCategory              = @"ALL";
    strselectedVenue                 = @"ALL";
    
    
    [self CreateMenu];
    
    selectedSet           = [[delegateApp.dictforData objectForKey:@"SelectedOption"] integerValue];
    
    [self setViewObjects:selectedSet];
    
    
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeClicked:)];
    [homeView    addGestureRecognizer:swiperight];
    
    UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gotoHomeSwipeClicked:)];
    [swipeleft setDirection:UISwipeGestureRecognizerDirectionRight];
    [homeView    addGestureRecognizer:swipeleft];

    //for animation of cells
    CGFloat       rotationAngleDegree  = 8;
    CGFloat       rotationAngleRadius  = rotationAngleDegree * (M_PI/180);
    CGPoint       offsetPositing       = CGPointMake(0, 40);
    CATransform3D Tranasform           = CATransform3DIdentity;
    Tranasform                         = CATransform3DRotate(Tranasform, rotationAngleRadius, 1.0, 1.0, 1.0);
    Tranasform                         = CATransform3DTranslate(Tranasform, offsetPositing.x, offsetPositing.y, 0.0);
    initialTransformation             = Tranasform;

    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
   // [rightMenu LoadData];
    self.navigationController.navigationBarHidden = true;
    
    bottomViewvisible                = NO;
    
    
    if (bottomViewvisible == NO) {
        
        [UIView animateWithDuration:ViewAnimationDuration animations:^{
            
            if ([SMSCountryUtils isIphone]) {
                [viewofBottomOptions setFrame:CGRectMake(0, ViewHeight, ViewWidth, 50)];
                [viewofBottomOptions setFrame:CGRectMake(0, ViewHeight-50, ViewWidth, 50)];
            }
            else{
                
                [viewofBottomOptions setFrame:CGRectMake(0, ViewHeight, ViewWidth, 100)];
                [viewofBottomOptions setFrame:CGRectMake(0, ViewHeight-100, ViewWidth, 100)];
            }
            
        } completion:^(BOOL finished) {
            
            bottomViewvisible = YES;
            
        }];
        
    }
    else{
        
        [UIView animateWithDuration:ViewAnimationDuration animations:^{
            
            if ([SMSCountryUtils isIphone]) {
                
                [viewofBottomOptions setFrame:CGRectMake(0, ViewHeight-50, ViewWidth, 50)];
                [viewofBottomOptions setFrame:CGRectMake(0, ViewHeight, ViewWidth, 50)];
                
            }
            else{
                [viewofBottomOptions setFrame:CGRectMake(0, ViewHeight-100, ViewWidth, 100)];
                [viewofBottomOptions setFrame:CGRectMake(0, ViewHeight, ViewWidth, 100)];
                
                
            }
            
            
            
        } completion:^(BOOL finished) {
            
            bottomViewvisible = NO;
            
        }];
        
        
    }
    
}

-(void)CreateMenu{
    
    rightMenu             = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    rightMenu.setDelegate = self;
    if ([SMSCountryUtils isIphone]) {
        
        [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight-MenutopStripHei)];
        
    }
    else{
        
        [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+50, MenuWidth+150, ViewHeight-MenutopStripHei+50)];
    }    [self.view addSubview:rightMenu.view];
    
    
    
}


#pragma mark --- for right side menu

//for hiding menu
-(void)HideMenu{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if ([SMSCountryUtils isIphone]) {
            
            
            [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight-MenutopStripHei)];
        }
        
        else{
            [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+56, MenuWidth+150, ViewHeight - MenutopStripHei+56)];
        }
        // [homeView setFrame:CGRectMake(0, MenutopStripHei, ViewWidth, ViewHeight-MenutopStripHei)];
        
    } completion:^(BOOL finished) {
        mClicked = NO;
    }];
    
}

//for ShowingMenu
-(void)ShowMeu{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //  [homeView setFrame:CGRectMake(-MenuWidth, MenutopStripHei, ViewWidth, ViewHeight)];
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

-(void)rightSwipeClicked:(UISwipeGestureRecognizer *)swipeGes{
    
    
    if (mClicked == YES) {
        
        [self HideMenu];
        
    }
    
}


-(void)gotoHomeSwipeClicked:(UISwipeGestureRecognizer *)swipeGes{
    
    
    
    if (mClicked == YES) {
        
        [self HideMenu];
    }
    
    
    [self btnHomeClicked:swipeGes];
    
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
                
                [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight - MenutopStripHei)];
            }else{
                
                [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+56, MenuWidth+150, ViewHeight - MenutopStripHei+56)];
            }            //  [homeview setFrame:CGRectMake(0, MenutopStripHei, ViewWidth, ViewHeight - MenutopStripHei)];
            
            
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

#pragma mark  SettingInitial Objects for Movies/Events


-(void)setViewObjects:(NSInteger)intselectedSet{
    
    
    [arrofTableviewData  removeAllObjects];
    [arrofLeftSelections removeAllObjects];
    [arrofRightSelection removeAllObjects];
    
    
    lblofTitle.text     = @"Events";
    arrofPictures       = [[NSMutableArray alloc]initWithArray:[delegateApp.dictforData objectForKey:@"EventsData"]];
    [self getEventCategoryByEventsArr:arrofPictures];
    [self getEventVenuesByEventsArr:arrofPictures];
    [self sortEventsByCategory];
    
    
    
    if (arrofLeftSelections.count>6) {
        
        if ([SMSCountryUtils isIphone]) {
            
            CoorY           = self.view.frame.size.height - 50 - (6 * SelectionCellHeight );
            tbselleftHeight = 180.0f;
            
        }
        else{
            
            CoorY           = self.view.frame.size.height - 50 - (6 * (SelectionCellHeight+30) );
            tbselleftHeight = 360.0f;
            
        }
        
        
    }
    else{
        
        if ([SMSCountryUtils isIphone]) {
            CoorY           = self.view.frame.size.height - 50 - (arrofLeftSelections.count * SelectionCellHeight );
            tbselleftHeight = arrofLeftSelections.count * SelectionCellHeight;
            
            
        }else{
            
            CoorY           = self.view.frame.size.height - 50 - (arrofLeftSelections.count * (SelectionCellHeight+30) );
            tbselleftHeight = arrofLeftSelections.count * (SelectionCellHeight+30);
            
        }
        
    }
    if ([SMSCountryUtils isIphone]) {
        
        [tbofSelectionView setFrame:CGRectMake(-SelectionCellWidth, CoorY, SelectionCellWidth,tbselleftHeight)];
        
    }
    else{
        
        [tbofSelectionView setFrame:CGRectMake(-SelectionCellWidth-150, CoorY-50, SelectionCellWidth+150,tbselleftHeight)];
        
        
    }
    
    [tbofSelectionView setHidden:YES];
    
    
    if (arrofRightSelection.count>6) {
        
        if ([SMSCountryUtils isIphone]) {
            
            RightCoorY       = self.view.frame.size.height - 50 - (6 * SelectionCellHeight );
            tbselrightHeight = 180.0f;
        }
        else{
            
            RightCoorY       = self.view.frame.size.height - 50 - (6 * (SelectionCellHeight +30));
            tbselrightHeight = 360.0f;
        }
        
        
    }
    else{
        
        if ([SMSCountryUtils isIphone]) {
            
            RightCoorY       = self.view.frame.size.height - 50 - (arrofRightSelection.count * SelectionCellHeight );
            tbselrightHeight = arrofRightSelection.count * SelectionCellHeight;
        }
        else{
            
            RightCoorY       = self.view.frame.size.height - 50 - (arrofRightSelection.count * (SelectionCellHeight+30) );
            tbselrightHeight = arrofRightSelection.count * (SelectionCellHeight+30);
        }
    }
    if ([SMSCountryUtils isIphone]) {
        
        [tbofRightSideSelectionView setFrame:CGRectMake(ViewWidth, RightCoorY, SelectionCellWidth,tbselrightHeight)];
    }
    else{
        
        [tbofRightSideSelectionView setFrame:CGRectMake(ViewWidth, RightCoorY-50, SelectionCellWidth+150,tbselrightHeight)];
        
    }
    [tbofRightSideSelectionView setHidden:YES];
    
    
    
    [bottomButton1 addTarget:self action:@selector(btnBottomButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButton3 addTarget:self action:@selector(btnBottomButton3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomButton2 addTarget:self action:@selector(btnBottomButton2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [tbofEvents reloadData];
    [tbofRightSideSelectionView reloadData];
    [tbofSelectionView reloadData];
    
    
    [scutilits hideLoader];
}



#pragma mark ----- for Event category,venus


-(void)getEventCategoryByEventsArr:(NSMutableArray *)evnetsArray{
    
    NSMutableArray *tempLangArr = [[NSMutableArray alloc]init];
    
    for (EventsVO *eventVO in evnetsArray)
    {
        [tempLangArr addObject:eventVO.category];
    }
    [arrofLeftSelections addObject:@"ALL"];
    if (tempLangArr.count>0)
    {
        [arrofLeftSelections addObjectsFromArray:[[NSSet setWithArray:tempLangArr] allObjects]];
    }

}


-(void)getEventVenuesByEventsArr:(NSMutableArray *)eventsArray{
    
    NSMutableArray *tempLangArr = [[NSMutableArray alloc]init];
    
    for (EventsVO *eventVO in eventsArray)
    {
        [tempLangArr addObject:eventVO.venue];
    }
    [arrofRightSelection addObject:@"ALL"];
    if (tempLangArr.count>0)
    {
        [arrofRightSelection addObjectsFromArray:[[NSSet setWithArray:tempLangArr] allObjects]];
    }

    
    
}


-(void)sortEventsByCategory{
    
    
    
    NSMutableArray *sortedTempArr = [[NSMutableArray alloc]init];
    
    
    arrofPictures       = [[NSMutableArray alloc]initWithArray:[delegateApp.dictforData objectForKey:@"EventsData"]];
    
    
    if([strselectedCategory isEqualToString:@"ALL"]){
        
        
        [USERDEFAULTS setInteger:0 forKey:@"SelectedCate"];
        [USERDEFAULTS synchronize];
        
        [sortedTempArr addObjectsFromArray:arrofPictures];
    }
    else{
        
        for (int k = 0; k < arrofPictures.count; k++) {
            
            EventsVO *EventOb = [arrofPictures objectAtIndex:k];
            
            if ([EventOb.category isEqualToString:strselectedCategory]) {
                
                [sortedTempArr addObject:EventOb];
            }
        }
    }
    [self sortByVenuesWithSortedArray:sortedTempArr];
    
}


-(void)sortByVenuesWithSortedArray:(NSMutableArray *)sortedTempArr{
    
    
    if (arrofPictures.count > 0) {
        
        [arrofPictures removeAllObjects];
    }
    
    NSMutableArray *sortedfinalArr = [[NSMutableArray alloc]init];
    
    if ([strselectedVenue isEqualToString:@"ALL"]) {
        
        [USERDEFAULTS setInteger:0 forKey:@"SelectedVenue"];
        [USERDEFAULTS synchronize];
        [sortedfinalArr addObjectsFromArray:sortedTempArr];
    }
    else{
        
        for (int k = 0; k<sortedTempArr.count; k++) {
            
                EventsVO *eventObj  = [sortedTempArr objectAtIndex:k];


                if ([eventObj.venue isEqualToString:strselectedVenue]) {
                
                    [sortedfinalArr addObject:eventObj];
                
            }
        }
    }
    
    [arrofPictures addObjectsFromArray:sortedfinalArr];
    
    if (arrofPictures.count > 0) {
        
        [delegateApp.arofEventSearchRes removeAllObjects];
        [delegateApp.arofEventSearchRes addObjectsFromArray:arrofPictures];
        
        eventsAvailable = YES;
        [tbofEvents reloadData];
        [tbofSelectionView reloadData];
        [tbofRightSideSelectionView reloadData];
        
    }
    else{
        
        [arrofPictures addObjectsFromArray:delegateApp.arofEventSearchRes];
        [tbofEvents reloadData];
        [tbofSelectionView reloadData];
        [tbofRightSideSelectionView reloadData];
        
        eventsAvailable = NO;
        
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Events are not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
   
    
}





-(IBAction)btnBottomButton2Clicked:(id)sender{
    
    if (mClicked) {
        [self HideMenu];
    }
    if (leftsideSelectionViewVisible) {
        [self HideLeftsideMenu];
    }
    if (rightsideSelectionViewVisible) {
        [self HideRightSideMenu];
    }
    
    
    Movies_EventsViewController  *moviesVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"Movies_EventsViewController"];
    if (self.fromHome) {
        [moviesVc setFromEvents:YES];

        
    }
    else{
        [moviesVc setFromEvents:NO];

    }
    
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:moviesVc animated:NO];
    if (self.fromMovies) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    }
    else{
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    }
    [UIView commitAnimations];
    moviesVc = Nil;
    
}

//for right side menu

#pragma mark ---- Right side Selction Menu

-(void)ShowRightSideMenu{
    
    [tbofRightSideSelectionView reloadData];
    
    [UIView animateWithDuration:ViewAnimationDuration animations:^{
        
        
        if ([SMSCountryUtils isIphone]) {
            
            [tbofRightSideSelectionView setFrame:CGRectMake(ViewWidth, RightCoorY, SelectionCellWidth,tbselrightHeight)];
            
            [tbofRightSideSelectionView setFrame:CGRectMake(ViewWidth-SelectionCellWidth, RightCoorY, SelectionCellWidth, tbselrightHeight)];
            
            
        }
        else{
            
            [tbofRightSideSelectionView setFrame:CGRectMake(ViewWidth, RightCoorY-50, SelectionCellWidth+150,tbselrightHeight)];
            
            [tbofRightSideSelectionView setFrame:CGRectMake(ViewWidth-SelectionCellWidth-150, RightCoorY-50, SelectionCellWidth+150, tbselrightHeight)];
            
            
            
        }
        
        
        
    } completion:^(BOOL finished) {
        
        rightsideSelectionViewVisible = YES;
        
    }];
}

-(void)HideRightSideMenu{
    
    
    [UIView animateWithDuration:ViewAnimationDuration animations:^{
        
        if ([SMSCountryUtils isIphone]) {
            
            [tbofRightSideSelectionView setFrame:CGRectMake(ViewWidth-SelectionCellWidth, RightCoorY, SelectionCellWidth, tbselrightHeight)];
            
            [tbofRightSideSelectionView setFrame:CGRectMake(ViewWidth, RightCoorY, SelectionCellWidth,tbselrightHeight)];
        }
        else{
            
            [tbofRightSideSelectionView setFrame:CGRectMake(ViewWidth-SelectionCellWidth-150, RightCoorY-50, SelectionCellWidth+150, tbselrightHeight)];
            
            [tbofRightSideSelectionView setFrame:CGRectMake(ViewWidth, RightCoorY-50, SelectionCellWidth+150,tbselrightHeight)];
            
        }
        
        
    } completion:^(BOOL finished) {
        
        rightsideSelectionViewVisible = NO;
        
        [tbofRightSideSelectionView setHidden:YES];
        
    }];
    
}



-(IBAction)btnBottomButton3Clicked:(id)sender{
    
    [tbofRightSideSelectionView setHidden:NO];
    
    if (leftsideSelectionViewVisible) {
        [self HideLeftsideMenu];
    }
    if (rightsideSelectionViewVisible == NO) {
        
        [self ShowRightSideMenu];
    }
    else{
        [self HideRightSideMenu];
    }
}

//for leftside selection menu
#pragma mark ---- Left side Selction Menu

-(void)ShowLeftSideMenu{
    
    
   // NSLog(@"coorY is :%f arrcount is :%lu",CoorY,(unsigned long)arrofLeftSelections.count);
    
    
    
    [UIView animateWithDuration:ViewAnimationDuration animations:^{
        
        if ([SMSCountryUtils isIphone]) {
            
            [tbofSelectionView setFrame:CGRectMake(-SelectionCellWidth, CoorY, SelectionCellWidth,tbselleftHeight)];
            [tbofSelectionView setFrame:CGRectMake(0, CoorY, SelectionCellWidth, tbselleftHeight)];
        }
        else{
            [tbofSelectionView setFrame:CGRectMake(-SelectionCellWidth-150, CoorY-50, SelectionCellWidth+150,tbselleftHeight)];
            [tbofSelectionView setFrame:CGRectMake(0, CoorY-50, SelectionCellWidth+150, tbselleftHeight)];
        }
    } completion:^(BOOL finished) {
        
        leftsideSelectionViewVisible = YES;
    }];
    
}

-(void)HideLeftsideMenu{
    
    
    [UIView animateWithDuration:ViewAnimationDuration animations:^{
        
        if ([SMSCountryUtils isIphone]) {
            
            [tbofSelectionView setFrame:CGRectMake(0, CoorY, SelectionCellWidth, tbselleftHeight)];
            
            [tbofSelectionView setFrame:CGRectMake(-SelectionCellWidth, CoorY, SelectionCellWidth,tbselleftHeight)];
        }
        else{
            
            [tbofSelectionView setFrame:CGRectMake(0, CoorY-50, SelectionCellWidth+150, tbselleftHeight)];
            
            [tbofSelectionView setFrame:CGRectMake(-SelectionCellWidth-150, CoorY-50, SelectionCellWidth+150,tbselleftHeight)];
            
        }
        
        
    } completion:^(BOOL finished) {
        
        leftsideSelectionViewVisible = NO;
        
        [tbofSelectionView setHidden:YES];
        
        
    }];
    
    
}


-(IBAction)btnBottomButton1Clicked:(id)sender{
    
    
    [tbofSelectionView setHidden:NO];
    
    if (rightsideSelectionViewVisible){
        [self HideRightSideMenu];
    }
    
    if (leftsideSelectionViewVisible == NO) {
        
        [self ShowLeftSideMenu];
    }
    else{
        
        [self HideLeftsideMenu];
        
    }
    
}


-(IBAction)btnMenuClicked:(id)sender{
    
    [rightMenu LoadData];

    if (leftsideSelectionViewVisible) {
        [self HideLeftsideMenu];
    }
    if (rightsideSelectionViewVisible) {
        [self HideRightSideMenu];
    }
    
    if (mClicked == NO) {
        
        [self ShowMeu];
        
    }
    else{
        
        [self HideMenu];
    }
    
}



-(IBAction)btnHomeClicked:(id)sender
{
    [tbofSelectionView setHidden:YES];
    [tbofRightSideSelectionView setHidden:YES];
    
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
//        
//        CATransition* transition = [CATransition animation];
//        transition.duration = 0.4f;
//        transition.type = kCATransitionMoveIn;
//        transition.subtype = kCATransitionFromBottom;
//        [self.navigationController.view.layer addAnimation:transition
//                                                    forKey:kCATransition];

        [self.navigationController popToViewController:[arrofNavoagtionsCon objectAtIndex:index] animated:YES];
        
    }
    else{
        
        HomeViewController *homeviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//        CATransition* transition = [CATransition animation];
//        transition.duration = 0.4f;
//        transition.type = kCATransitionMoveIn;
//        transition.subtype = kCATransitionFromBottom;
//        [self.navigationController.view.layer addAnimation:transition
//                                                    forKey:kCATransition];

        [self.navigationController pushViewController:homeviewVC animated:YES];
        
    }
}


#pragma mark Movies_Events TableviewDataSourceMethods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1) {
        
        return [arrofPictures count];
    }
    else if(tableView.tag == 2){
        
        return [arrofLeftSelections count];
        
    }
    else if(tableView.tag == 3){
        
        return [arrofRightSelection count];
        
    }
    else{
        
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        if ([SMSCountryUtils isIphone]) {
            
            return 200.0;
        }
        else{
            
            return 400.0;
        }
    }
    if ([SMSCountryUtils isIphone]) {
        return 30;
    }
    else{
        return 60;
    }

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (tableView.tag == 1) {
        
            EventsTableViewCell *evetnCell = (EventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EventsTableViewCell"];
            
            if (evetnCell == nil) {
                
                evetnCell = [[[NSBundle mainBundle] loadNibNamed:@"EventsTableViewCell" owner:self options:nil] objectAtIndex:0];
            }
        
        EventsVO *newEvent        = [arrofPictures objectAtIndex:indexPath.row];
//      unsigned int bgTitleColorValue = [SMSCountryUtils intFromHexString:[NSString stringWithFormat:@"%@#",newEvent.bgBorderColorCode]];
    
        if ([SMSCountryUtils isIphone]) {
            
            evetnCell.imgivewOfEvent               = [evetnCell.imgivewOfEvent initWithPlaceholderImage:[UIImage imageNamed:@"event-details-bg.png"]];
        }
        else{
            evetnCell.imgivewOfEvent               = [evetnCell.imgivewOfEvent initWithPlaceholderImage:[UIImage imageNamed:@"event-details-bg~ipad.png"]];
        }
        
            NSString *imagtThumbnailurl            = [NSString stringWithFormat:@"%@",newEvent.strBannerUrl];
            imagtThumbnailurl                      =  [imagtThumbnailurl stringByReplacingOccurrencesOfString:@"/App_Images/" withString:@"/movie_Images/"];
            evetnCell.imgivewOfEvent.imageURL      = [NSURL URLWithString:imagtThumbnailurl];
            [evetnCell.imgviewforEventBackground setBackgroundColor:[UIColor whiteColor]];
            evetnCell.lblNameofEvent.text          = [NSString stringWithFormat:@"%@",newEvent.EventName];
//            [evetnCell.lblNameofEvent setTextColor:UIColorFromRGB(bgTitleColorValue)];
            evetnCell.lblNameofEvent.marqueeType    = MLContinuous;
            evetnCell.lblNameofEvent.trailingBuffer = 15.0f;
        
        NSString *strEventStartDate = [NSString stringWithFormat:@"%@",newEvent.startDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFromString = [dateFormatter dateFromString:strEventStartDate];
       [dateFormatter setDateFormat:@"EEEE MMMM d, YYYY"];
       evetnCell.lblDateofEvent.text           = [NSString stringWithFormat:@"%@ | %@",[dateFormatter stringFromDate:dateFromString],newEvent.startTime];
        [evetnCell.lblTimeofEvent setHidden:YES];
            [evetnCell.btnBooknow setTag:indexPath.row];
            [evetnCell.btnBooknow addTarget:self action:@selector(btnBooknowEventsClicked:) forControlEvents:UIControlEventTouchUpInside];
        [evetnCell.btnBooknow.layer setCornerRadius:8];
        
        evetnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        evetnCell.imgviewEveType.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",newEvent.strEventCategoryUrlis]];
        
        [evetnCell.imgviewQTAEvent setHidden:YES];
        
        
        
        //for qta events
        if ([newEvent.category isEqualToString:@"Qatar Tourism Authority events"]) {
            [evetnCell.imgviewQTAEvent setHidden:NO];
        }
        
        //for free r paid
        /*NSMutableArray *arrofTicketsTypes = [[NSMutableArray alloc] init];
        [arrofTicketsTypes addObjectsFromArray:newEvent.eventTicketsArray];
        TicketTypes *ticketIS = [[TicketTypes alloc] init];
        ticketIS = [arrofTicketsTypes objectAtIndex:0];
        [evetnCell.lblFreerPaid setHidden:YES];
        if ([ticketIS.strTicketPaidrFree isEqualToString:@"Free Admission"]) {
            [evetnCell.lblFreerPaid setHidden:NO];
        }*/
        
        [evetnCell.lblFreerPaid setHidden:YES];
        
        
        
        
        
   

       //for 21+
        if ([newEvent.entryRestriction isEqualToString:@"21+"]) {
            
            if ([SMSCountryUtils isIphone]) {
                
                if (ViewWidth == iPhone6PlusWidth) {
                    
                    evetnCell.imgviewEveRestriction.image = [UIImage imageNamed:@"18@3x.png"];
                }
                else if([SMSCountryUtils isRetinadisplay]){
                    
                    evetnCell.imgviewEveRestriction.image = [UIImage imageNamed:@"18@2x.png"];
                }
                else{
                    
                    evetnCell.imgviewEveRestriction.image = [UIImage imageNamed:@"18.png"];
                }
            }
            else{
                if ([SMSCountryUtils isRetinadisplay]) {
                    
                    evetnCell.imgviewEveRestriction.image = [UIImage imageNamed:@"18~ipad.png"];
                }
                else{
                    evetnCell.imgviewEveRestriction.image = [UIImage imageNamed:@"18@2x~ipad.png"];
                }
            }
        }
        //for general
       else if ([newEvent.entryRestriction isEqualToString:@"General"]) {
            
            if ([SMSCountryUtils isIphone]) {
                
                if (ViewWidth == iPhone6PlusWidth) {
                    
                    evetnCell.imgviewEveRestriction.image = [UIImage imageNamed:@"Family18@3x.png"];
                }
                else if([SMSCountryUtils isRetinadisplay]){
                    evetnCell.imgviewEveRestriction.image = [UIImage imageNamed:@"Family18@2x.png"];
                }
                else{
                    evetnCell.imgviewEveRestriction.image = [UIImage imageNamed:@"Family18.png"];
                }
            }
            else{
                if ([SMSCountryUtils isRetinadisplay]) {
                    evetnCell.imgviewEveRestriction.image = [UIImage imageNamed:@"Family18~ipad.png"];
                }
                else{
                    evetnCell.imgviewEveRestriction.image = [UIImage imageNamed:@"Family18@2x~ipad.png"];
                }
            }
        }

            return evetnCell;
    }
    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        if (tableView.tag == 2) {
            cell.textLabel.text         = [NSString stringWithFormat:@"%@",[arrofLeftSelections objectAtIndex:indexPath.row]];
            NSInteger Langindex         = [USERDEFAULTS integerForKey:@"SelectedCate"];
            UIImageView *imgofCheckmark;
            if ([SMSCountryUtils isIphone]) {
                
                if(ViewWidth == iPhone6PlusWidth)
                {
                    imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark@3x.png"]];
                    
                }
                else{
                    
                    if ([SMSCountryUtils isRetinadisplay]) {
                        
                        imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark@2x.png"]];                    }
                    else{
                        
                        imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark.png"]];
                        
                    }
                    
                    
                }
                
            }
            else{
                
                if ([SMSCountryUtils isRetinadisplay]) {
                    
                    imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark@2x~ipad.png"]];
                    
                }
                else{
                    
                  imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark~ipad.png"]];
                }

            }
            if(indexPath.row == Langindex)
            {
                cell.accessoryView     = imgofCheckmark;
                
                cell.accessoryType      = UITableViewCellAccessoryCheckmark;
                
            }
            else{
                
                cell.accessoryView      =  nil;
                cell.accessoryType      = UITableViewCellAccessoryNone;
            }
            
        }
        else if(tableView.tag == 3){
            
            cell.textLabel.text         = [NSString stringWithFormat:@"%@",[arrofRightSelection objectAtIndex:indexPath.row]];
            NSInteger Langindex         = [USERDEFAULTS integerForKey:@"SelectedVenue"];
            UIImageView *imgofCheckmark;
            if ([SMSCountryUtils isIphone]) {
                
                if(ViewWidth == iPhone6PlusWidth)
                {
                    imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark@3x.png"]];
                    
                }
                else{
                    
                    if ([SMSCountryUtils isRetinadisplay]) {
                        
                        imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark@2x.png"]];                    }
                    else{
                        
                        imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark.png"]];
                        
                    }
                    
                    
                }
                
            }
            else{
                
                if ([SMSCountryUtils isRetinadisplay]) {
                    
                    imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark@2x~ipad.png"]];
                    
                }
                else{
                    
                    imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark~ipad.png"]];
                }
                
            }

            if(indexPath.row == Langindex)
            {
                cell.accessoryView     = imgofCheckmark;
                
                cell.accessoryType      = UITableViewCellAccessoryCheckmark;
                
            }
            else{
                
                cell.accessoryView      =  nil;
                cell.accessoryType      = UITableViewCellAccessoryNone;
            }
            

        }
        
        if ([SMSCountryUtils isIphone]) {
            [cell.textLabel setFont:[UIFont fontWithName:LATO_REGULAR size:12]];
            
        }
        else{
            [cell.textLabel setFont:[UIFont fontWithName:LATO_REGULAR size:24]];
            
        }
        cell.backgroundColor    = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (tableView.tag==1) {
    //
    //        [cell setBackgroundColor:[UIColor clearColor]];
    //        cell.layer.transform  = self.initialTransformation;
    //        cell.layer.opacity    = 0.8;
    //        [UIView animateWithDuration:0.5 animations:^{
    //            cell.layer.transform = CATransform3DIdentity;
    //            cell.layer.opacity   = 1;
    //        }];
    //
    //
    //    }
    cell.backgroundColor = cell.contentView.backgroundColor;
}





-(void)btnBooknowEventsClicked:(id)sender
{
    UIButton *btnBook                   = (UIButton *)sender;
    /*EventsBookingViewController *eventBook = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventsBookingViewController"];
    [self.navigationController pushViewController:eventBook animated:YES];*/
    EventsVO *selectedEvent       = [arrofPictures objectAtIndex:btnBook.tag];
    [delegateApp setSelectedEvent:selectedEvent];
    [self eventsTapped:selectedEvent];

    
}

#pragma mark Movies_Events TableviewDelegateMethods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 1)
    {
        
        if (leftsideSelectionViewVisible) {
            [self HideLeftsideMenu];
        }
        if (rightsideSelectionViewVisible) {
            [self HideRightSideMenu];
        }
        if (mClicked) {
            
        [UIView animateWithDuration:0.5 animations:^{
            
            if ([SMSCountryUtils isIphone]) {
                [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight-MenutopStripHei)];
            }
            else{
                
                [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+56, MenuWidth+150, ViewHeight-MenutopStripHei-56)];
            }

            
        } completion:^(BOOL finished) {
            mClicked = NO;
            
//            EventDescriptionViewController *eventDesc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventDescriptionViewController"];
//            EventsVO *selectedEvent       = [arrofPictures objectAtIndex:indexPath.row];
//            [delegateApp setSelectedEvent:selectedEvent];
//            [self.navigationController pushViewController:eventDesc animated:YES];

        }];
    }
    else{
        EventsVO *selectedEvent = [arrofPictures objectAtIndex:indexPath.row];

        [self eventsTapped:selectedEvent];
        
//        EventDescriptionViewController *eventDesc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventDescriptionViewController"];
//        EventsVO *selectedEvent       = [arrofPictures objectAtIndex:indexPath.row];
//        [delegateApp setSelectedEvent:selectedEvent];
//        [self.navigationController pushViewController:eventDesc animated:YES];

    }

    
    }
    else if (tableView.tag == 2){
        
        [self HideLeftsideMenu];
        
        strselectedCategory               = [NSString stringWithFormat:@"%@",[arrofLeftSelections objectAtIndex:indexPath.row]];
        [self sortEventsByCategory];

        if (eventsAvailable) {
            [USERDEFAULTS setInteger:indexPath.row forKey:@"SelectedCate"];
            [USERDEFAULTS synchronize];

        }
        else{
            
            strselectedCategory = @"ALL";
        }
        
        

                     
        
    }
    else if (tableView.tag == 3){
        
        [self HideRightSideMenu];
        
      
        strselectedVenue     = [NSString stringWithFormat:@"%@",[arrofRightSelection objectAtIndex:indexPath.row]];
        [self sortEventsByCategory];

        if (eventsAvailable) {
            [USERDEFAULTS setInteger:indexPath.row forKey:@"SelectedVenue"];
            [USERDEFAULTS synchronize];
        }
        else{
            
            strselectedVenue = @"ALL";
        }
       
        
        

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventsTapped:(EventsVO*)selectedEvent{
    [delegateApp setSelectedEvent:selectedEvent];
    NSString * str = [self getUrlForEvent:selectedEvent.EventName];
    if ([str isEqualToString:@"Not Applicable"]){
        EventDescriptionViewController *eventDesc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventDescriptionViewController"];
        [self.navigationController pushViewController:eventDesc animated:YES];
        
    }
    else{
        EventsWebViewController * webView = [[EventsWebViewController alloc] initWithNibName:@"EventsWebViewController" bundle:nil];
        webView.urlStr = str;
        webView.title = selectedEvent.EventName;
        [self.navigationController pushViewController:webView animated:true];
    }
}

- (NSString*)getUrlForEvent:(NSString*)event{
    if ([[event lowercaseString] isEqualToString:@"desert safari"]){
        return @"https://m.q-tickets.com/events/desert-safari-doha";
    }
    else if ([[event lowercaseString] isEqualToString:@"dhow cruise"]){
        return @"https://m.q-tickets.com/events/DhowCruise-Doha";
    }
    else if ([[event lowercaseString] isEqualToString:@"la brasserie ramadan special iftar"]){
        return @"https://m.q-tickets.com/events/La-Brasserie-Ramadan-Iftar";
    }
    else if ([[event lowercaseString] isEqualToString:@"tangia restaurant"]){
        return @"https://m.q-tickets.com/events/Tangia-Restaurant-Ramadan-Kareem";
    }
    else if ([[event lowercaseString] isEqualToString:@"ramadanak tent"]){
        return @"https://m.q-tickets.com/events/Ramadanak-Tent";
    }
    else if ([[event lowercaseString] containsString:@"euro cup fanzone"]){
        return @"https://m.q-tickets.com/events/EURO-CUP-FANZONE";
    }
    else if ([[event lowercaseString] containsString:@"al qasr restaurant"]){
        return @"https://m.q-tickets.com/events/AL-QASR-RESTAURANT";
    }
    else if ([[event lowercaseString] containsString:@"grand gourmet"]){
        return @"https://m.q-tickets.com/events/GRAND-GOURMET";
    }
    else{
        return @"Not Applicable";
    }
    
}

@end



















