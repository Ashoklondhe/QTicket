//
//  Movies_EventsViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "Movies_EventsViewController.h"
#import "Q-ticketsConstants.h"
#import "Moview_EventsTableViewCell.h"
#import "MenuViewController.h"
#import "DescriptionViewController.h"
#import "ShowTimingsViewController.h"
#import "EventsBookingViewController.h"


#import "LoginViewController.h"
#import "MyBookingsViewController.h"
#import "MyProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "MyVouchersViewController.h"
#import "MobileNumVerifyViewController.h"
#import "HomeViewController.h"


#import "MovieVO.h"
#import "AppDelegate.h"
#import "EventsTableViewCell.h"
#import "UINavigationController+Fade.h"
#import "EventsViewController.h"
#import "UINavigationController+MenuNavi.h"


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 



@interface Movies_EventsViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    
    IBOutlet UITableView *tbofMovies_Events;
    NSMutableArray       *arrofPictures;
    IBOutlet UILabel     *lblofTitle;
    IBOutlet UIImageView *imgviewofNavMov;
    IBOutlet UIView      *homeView;
    BOOL                 mClicked;
    NSMutableArray       *arrofAllMoviesData;
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
    SMSCountryUtils      *scutilits;
    AppDelegate          *delegateApp;
   
    
    NSInteger            selectedLangIndex,selectedTheaterIndex;
    NSString             *strselectedLang,*strselectedTheater;
    NSInteger            selectedSet;
    BOOL                 moviesAvailable;
    
}
//cell animation

@end

@implementation Movies_EventsViewController
@synthesize dictofPassedData,fromEvents,fromHomeVc;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }

    yOffset                          = 0.0;
    arrofAllMoviesData               = [[NSMutableArray alloc] init];
    arrofPictures                    = [[NSMutableArray alloc] init];
    arrofLeftSelections              = [[NSMutableArray alloc]init];
    arrofRightSelection              = [[NSMutableArray alloc]init];
    scutilits                        = [[SMSCountryUtils alloc]init];
    delegateApp                      = QTicketsAppDelegate;
    selectedLangIndex                = 0;
    selectedTheaterIndex             = 0;
    strselectedLang                  = @"ALL";
    strselectedTheater               = @"ALL";
    moviesAvailable                  = NO;

    [self CreateMenu];
   
    [USERDEFAULTS setInteger:selectedLangIndex forKey:@"SelectedLang"];
    [USERDEFAULTS synchronize];
    
    [USERDEFAULTS setInteger:selectedTheaterIndex forKey:@"SelectedTheater"];
    [USERDEFAULTS synchronize];

    NSMutableArray *arrofEvents      = [[NSMutableArray alloc]initWithArray:[delegateApp.dictforData objectForKey:@"EventsData"]];
    if (arrofEvents.count>0) {
        
        [bottomButton2 setEnabled:YES];
    }
    else{
        [bottomButton2 setEnabled:NO];
    }


    selectedSet           = [[delegateApp.dictforData objectForKey:@"SelectedOption"] integerValue];
    [arrofAllMoviesData addObjectsFromArray:[delegateApp.dictforData objectForKey:@"MoviesData"]];
    [self setViewObjects:selectedSet];
   
    
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeClicked:)];
    [homeView    addGestureRecognizer:swiperight];
    
    UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gotoHomeSwipeClicked:)];
    [swipeleft setDirection:UISwipeGestureRecognizerDirectionRight];
    [homeView    addGestureRecognizer:swipeleft];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
  //  [rightMenu LoadData];
    
    bottomViewvisible                = NO;
  
    
    if (mClicked ) {
        
        [self HideMenu];
    }
    
    
    
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
    }
    [self.view addSubview:rightMenu.view];
    
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

    } completion:^(BOOL finished) {
        mClicked = NO;
    }];
    
}

//for ShowingMenu
-(void)ShowMeu{
    
    [UIView animateWithDuration:0.5 animations:^{
      
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

#pragma mark  SettingInitial Objects for Movies/Events


-(void)setViewObjects:(NSInteger)intselectedSet{
    
   
    [arrofPictures  removeAllObjects];
    [arrofLeftSelections removeAllObjects];
    [arrofRightSelection removeAllObjects];
    
    
    

    
    NSArray *arrofTheatresSele = [[NSArray alloc]initWithArray:[delegateApp.dictforData objectForKey:@"TheatersLocations"]];
    
    
            lblofTitle.text      = @"Movies";
            arrofPictures        = [[NSMutableArray alloc]initWithArray:[delegateApp.dictforData objectForKey:@"MoviesData"]];
            [self getAllLanguagesfromMoviesArray:arrofPictures];
            [self arrageMoviesSortbyLanguage];
            
           [arrofRightSelection    addObjectsFromArray:arrofTheatresSele];

    
            
    
    
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
    
    
    [tbofMovies_Events reloadData];
    [tbofRightSideSelectionView reloadData];
    [tbofSelectionView reloadData];
    
   [scutilits hideLoader];
}


#pragma mark ---  toget languages list from moviesdata

-(void)getAllLanguagesfromMoviesArray:(NSMutableArray *)arrofMovies{
    
    
    
    NSMutableArray *tempLangArr = [[NSMutableArray alloc]init];
    for (MovieVO *movieVO in arrofMovies)
    {
        [tempLangArr addObject:movieVO.language];
    }
    [arrofLeftSelections addObject:@"ALL"];
    if (tempLangArr.count>0)
    {
        [arrofLeftSelections addObjectsFromArray:[[NSSet setWithArray:tempLangArr] allObjects]];
    }
    
    
    
}

-(void)arrageMoviesSortbyLanguage{
    
    
    NSMutableArray *sortedTempArr = [[NSMutableArray alloc]init];

    
    if([strselectedLang isEqualToString:@"ALL"]){
    
        //do nothing
        
        
        [sortedTempArr addObjectsFromArray:arrofAllMoviesData];
    }
    else{
        
        for (int k = 0; k < arrofAllMoviesData.count; k++) {
            
            MovieVO *moviewOb = [arrofAllMoviesData objectAtIndex:k];
            if ([moviewOb.language isEqualToString:strselectedLang]) {
                
                [sortedTempArr addObject:moviewOb];
                
                
            }
            
            
        }
        
     
        
    }
       [self sortByTheaterWithSortedArray:sortedTempArr];
    
}

-(void)sortByTheaterWithSortedArray:(NSMutableArray *)sortedByLang{
    
    if (arrofPictures.count > 0) {
        
        [arrofPictures removeAllObjects];
    }
    
    NSMutableArray *sortedfinalArr = [[NSMutableArray alloc]init];
    
    if ([strselectedTheater isEqualToString:@"ALL"]) {
        
        //do nothing
        
        [sortedfinalArr addObjectsFromArray:sortedByLang];
        
    }
    else{
        
        for (int k = 0; k<sortedByLang.count; k++) {
            
            MovieVO *movieObj  = [sortedByLang objectAtIndex:k];
            
            for (int i = 0; i<movieObj.movieTheatresArr.count; i++) {
                
                TheatreVO *theaterObje = [movieObj.movieTheatresArr objectAtIndex:i];
                
                if ([theaterObje.theatreName isEqualToString:strselectedTheater]) {
                    
                    [sortedfinalArr addObject:movieObj];
                }
                
            }
        }
    }
    
     [arrofPictures addObjectsFromArray:sortedfinalArr];
    
    if (arrofPictures.count > 0) {
        
        [delegateApp.arrofMovieSearchRes removeAllObjects];
        [delegateApp.arrofMovieSearchRes  addObjectsFromArray:arrofPictures];
        moviesAvailable = YES;
        [tbofMovies_Events reloadData];
        [tbofSelectionView reloadData];
        [tbofRightSideSelectionView reloadData];

    }
    else{
        
        [arrofPictures addObjectsFromArray:delegateApp.arrofMovieSearchRes];
        [tbofMovies_Events reloadData];
        [tbofSelectionView reloadData];
        [tbofRightSideSelectionView reloadData];
        
        moviesAvailable = NO;
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Movies are not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
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
    
    EventsViewController  *eventsView = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventsViewController"];
    if (self.fromHomeVc) {
        
        [eventsView setFromMovies:YES];
    }
    else{
        [eventsView setFromMovies:NO];
    }
    [eventsView setFromMovies:YES];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:eventsView animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    eventsView = Nil;
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            return 180.0;
        }
        else{
        
        return 360.0;
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
    
    
    
    TheatreVO *theraters;
    MovieVO   *newmov;
    
    if (tableView.tag == 1) {
        
        
            Moview_EventsTableViewCell *PictureCell = (Moview_EventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Moview_EventsTableViewCell"];
            if (PictureCell == nil) {
                
                PictureCell = [[[NSBundle mainBundle]loadNibNamed:@"Moview_EventsTableViewCell" owner:self options:nil] objectAtIndex:0];
                
            }
            newmov                                = [arrofPictures objectAtIndex:indexPath.row];
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
            PictureCell.imgviewofPicture          = [PictureCell.imgviewofPicture initWithPlaceholderImage:loaderimg];
            [PictureCell.imgviewofPicture setTag:indexPath.row];
        

        

        
        
        PictureCell.imgviewofPicture.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",newmov.strMovieBannerurlis]];
        
       
        
//        unsigned int bgTitleColorValue = [SMSCountryUtils intFromHexString:[NSString stringWithFormat:@"%@#",newmov.titleColorCode]];
//
//         [PictureCell.imgviewofPicture.layer setBorderColor:UIColorFromRGB(bgTitleColorValue).CGColor];
//        [PictureCell.imgviewofPicture.layer setBorderWidth:2];
        
            [PictureCell.imgviewofBackground setBackgroundColor:[UIColor whiteColor]];
            PictureCell.lblofPicName.text         = [NSString stringWithFormat:@" %@",newmov.movieName];
            PictureCell.lblofPicName.marqueeType    = MLContinuous;
            PictureCell.lblofPicName.trailingBuffer = 15.0f;
//        [PictureCell.lblofPicName setTextColor:UIColorFromRGB(bgTitleColorValue)];
//        [PictureCell.lblofPicDesc setTextColor:UIColorFromRGB(bgTitleColorValue)];
            SMSCountryUtils *smsuti                 = [[SMSCountryUtils alloc]init];
            PictureCell.lblofPicDesc.text           = [NSString stringWithFormat:@" %@ | %@ | %@",newmov.language,newmov.censor,[smsuti timeFormatted:[newmov.duration intValue]]];
            [PictureCell.btnofBooknow setTag    :indexPath.row];
            [PictureCell.btnofBooknow addTarget :self action:@selector(BtnBookNowClicked:) forControlEvents:UIControlEventTouchUpInside];
        [PictureCell.btnofBooknow.layer setCornerRadius:8];
        
        
            PictureCell.selectionStyle   = UITableViewCellSelectionStyleNone;
        
            return PictureCell;

    }
    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        
        if (tableView.tag == 2) {
            
            cell.textLabel.text         = [NSString stringWithFormat:@"%@",[arrofLeftSelections objectAtIndex:indexPath.row]];
            
            NSInteger Langindex         = [USERDEFAULTS integerForKey:@"SelectedLang"];
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
           theraters = [arrofRightSelection objectAtIndex:indexPath.row];
            
            
            if (indexPath.row == 0) {
                
                cell.textLabel.text  = @"ALL";
            }
            else{
              cell.textLabel.text  = [NSString stringWithFormat:@"%@", theraters.theatreName];
            }
            
            NSInteger Langindex         = [USERDEFAULTS integerForKey:@"SelectedTheater"];
            
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
    cell.backgroundColor = cell.contentView.backgroundColor;
}

-(void)BtnBookNowClicked:(id)sender{
    
    UIButton *btnBook                   = (UIButton *)sender;
    
    ShowTimingsViewController  *showtim = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"ShowTimingsViewController"];
    
    NSInteger Langindex         = [USERDEFAULTS integerForKey:@"SelectedTheater"];
    
    if (Langindex != 0) {
        
    TheatreVO *theraters =[arrofRightSelection objectAtIndex:Langindex];
        
        [delegateApp setStrTheaterNameis:[NSString stringWithFormat:@"%@",theraters.theatreName]];
        
//    [showtim setSelectedTheater:[NSString stringWithFormat:@"%@",theraters.theatreName]];
    }
    else{
//        [showtim setSelectedTheater:@"Cinemas"];
        [delegateApp setStrTheaterNameis:@"Cinemas"];
    }
    MovieVO *selctedmovie      = [arrofPictures objectAtIndex:btnBook.tag];
    [delegateApp setSelectedMovie:selctedmovie];
    [self.navigationController pushViewController:showtim animated:YES];
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

        if (mClicked ) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                if ([SMSCountryUtils isIphone]) {
                 [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight-MenutopStripHei)];
                }
                else{
                    
                    [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+56, MenuWidth+150, ViewHeight-MenutopStripHei-56)];
                }
                
                
                
            } completion:^(BOOL finished) {
                mClicked = NO;
                
            }];
        }
        else{
            
            [self NavigateDescriptionview:indexPath.row];

        }
    }
    else if (tableView.tag == 2){
        
        [self HideLeftsideMenu];

        
        strselectedLang               = [NSString stringWithFormat:@"%@",[arrofLeftSelections objectAtIndex:indexPath.row]];

       
        [self arrageMoviesSortbyLanguage];
        
        if (moviesAvailable) {
            
            [USERDEFAULTS setInteger:indexPath.row forKey:@"SelectedLang"];
            [USERDEFAULTS synchronize];
        }
        else{
            
            strselectedLang = @"ALL";
        }
        


    }
    else if (tableView.tag == 3){
        
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        
        
        strselectedTheater         = [NSString stringWithFormat:@"%@",selectedCell.textLabel.text];
        
      
        [self HideRightSideMenu];
        
        [self arrageMoviesSortbyLanguage];
        
        
        if (moviesAvailable) {
            
            [USERDEFAULTS setInteger:indexPath.row forKey:@"SelectedTheater"];
            [USERDEFAULTS synchronize];
            
        }
        else{
           
            strselectedTheater = @"ALL";
        }

    }
    
}


-(void)NavigateDescriptionview:(NSInteger)selectedIndex{
    
    DescriptionViewController *descview = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"DescriptionViewController"];
    MovieVO *selctedmovie              = [arrofPictures objectAtIndex:selectedIndex];
    [delegateApp setSelectedMovie:selctedmovie];
    
    NSInteger Langindex         = [USERDEFAULTS integerForKey:@"SelectedTheater"];
    if (Langindex != 0) {
        
        TheatreVO *theraters =[arrofRightSelection objectAtIndex:Langindex];
        
        [delegateApp setStrTheaterNameis:[NSString stringWithFormat:@"%@",theraters.theatreName]];
        
//        [descview setStrTheaterName:[NSString stringWithFormat:@"%@",theraters.theatreName]];
        
    }
    else{
        
//        [descview setStrTheaterName:@"Cinemas"];
        [delegateApp setStrTheaterNameis:@"Cinemas"];
        
    }
    
    [self.navigationController pushViewController:descview animated:YES];
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
