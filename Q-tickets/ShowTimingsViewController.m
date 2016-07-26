//
//  ShowTimingsViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 14/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "ShowTimingsViewController.h"
#import "iCarousel.h"
#import "Q-ticketsConstants.h"
#import "DatesVO.h"
#import "LoginViewController.h"
#import "BookingViewController.h"
#import "HomeViewController.h"

#import "LoginViewController.h"
#import "MyBookingsViewController.h"
#import "MyProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "MyVouchersViewController.h"
#import "MobileNumVerifyViewController.h"

#import "AppDelegate.h"

#import "MarqueeLabel.h"
#import "EGOImageView.h"
#import "UINavigationController+MenuNavi.h"

#import "SectionInfo.h"
#import "SectionView.h"
#import "ShowTimesCustomCell.h"
#import "Movies_EventsViewController.h"
#import "MovieVO.h"


@interface ShowTimingsViewController ()<iCarouselDataSource,iCarouselDelegate,UITableViewDataSource,UITableViewDelegate,ShowDateCustomCellDelegate,ShowDateViewDelegate,SectionView>{
    
    
     IBOutlet UIView       *homeView;
     IBOutlet MarqueeLabel *lblviewTitle;
     IBOutlet UIButton     *btnBack;
     IBOutlet iCarousel    *icarouselofDates;
     NSMutableArray         *previousDatesArr;
     NSMutableArray         *nextDatesArr;
     NSMutableArray         *avlblDatesArr;
     UILabel                *datelabel;
     NSInteger              selectedIndexis;
     BOOL                   mClicked;
     AppDelegate            *delegateApp;
     IBOutlet  EGOImageView *imgviewforBackground;
    
    NSInteger           selectedSection;
    NSInteger           selcetedDateIndex;
    NSMutableArray      *theatersArr;
    NSInteger            openSectionIndex;
    NSMutableArray       *sectionInfoArray;
    
    IBOutlet UITableView *tbofShowTimings;
    BOOL                isMinimize;
    
    NSMutableArray     *tempArrayofDates;

}

@end

@implementation ShowTimingsViewController
@synthesize selectedDateIndex,datesArr, selectedTheater;


- (void)viewDidLoad {
    
    [super viewDidLoad];

    sectionInfoArray    = [[NSMutableArray alloc] init];
    theatersArr         = [[NSMutableArray alloc] init];
    
    
    [icarouselofDates setHidden:NO];
    delegateApp            = QTicketsAppDelegate;
    
    selectedTheater = delegateApp.strTheaterNameis;
    
    [self setMovieData];
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }

    
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
    previousDatesArr      = [[NSMutableArray alloc]init];
    nextDatesArr          = [[NSMutableArray alloc] init];
    avlblDatesArr         = [[NSMutableArray alloc] init];
    datesArr              = [[NSMutableArray alloc] init];
    
    [self creatingPreviousAndNextDates];
    
 
    icarouselofDates.type = iCarouselTypeLinear;
    [icarouselofDates setDelegate:self];
    [icarouselofDates setDataSource:self];
    selectedIndexis      = 0;
    if([SMSCountryUtils isIphone]){
        [icarouselofDates scrollToOffset:1.3 duration:1];
    }
    else{
    [icarouselofDates scrollToOffset:2.3 duration:1];
    }
        //    [icarouselofDates scrollToItemAtIndex:0 animated:NO];
    [icarouselofDates.layer setBorderColor: [[UIColor colorWithRed:0.41764 green:0.41764 blue:0.41764 alpha:1] CGColor]];
    [icarouselofDates.layer setBorderWidth: 2.5];

    
    
    //available dates last index
    
    if (avlblDatesArr.count > 0) {
        
        
        //if its not in 0 index
        
        
        for (int k=0; k<avlblDatesArr.count; k++) {
            
            NSString *strDate = [NSString stringWithFormat:@"%@",[avlblDatesArr objectAtIndex:k]];
            
            if ([tempArrayofDates containsObject:strDate]) {
                
                [self creatingTheaterArrWithSelectedDate:strDate];
                
//                NSLog(@"inde is :%lu",(unsigned long)[avlblDatesArr indexOfObject:strDate]);
                
                
                selectedIndexis = [avlblDatesArr indexOfObject:strDate];
                
                break;
                
                
            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        NSString *strDate = [NSString stringWithFormat:@"%@",[avlblDatesArr objectAtIndex:0]];
//        if ([tempArrayofDates containsObject:strDate]) {
//            
//            [self creatingTheaterArrWithSelectedDate:strDate];
//        }
//        else{
//            [self creatingTheaterArrWithSelectedDate:[NSString stringWithFormat:@"%@",[avlblDatesArr objectAtIndex:1]]];
//            selectedIndexis = 1;
// 
//            
//        }

    }
    
    
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeClicked:)];
    [homeView addGestureRecognizer:swiperight];
    
    
    
    if (ViewHeight == 480) {
        
        [tbofShowTimings setFrame:CGRectMake(tbofShowTimings.frame.origin.x, tbofShowTimings.frame.origin.y+10, tbofShowTimings.frame.size.width, tbofShowTimings.frame.size.height)];
    }
    
    

}


-(void)viewDidAppear:(BOOL)animated{
    
    if (mClicked ) {
        
        [self hideMenuBar];
    }

   
    
   }

-(void)setMovieData{
    
    
    [lblviewTitle setText:delegateApp.selectedMovie.movieName];
    lblviewTitle.marqueeType = MLContinuous;
    lblviewTitle.trailingBuffer = 15.0f;
    
}


-(void)rightSwipeClicked:(UISwipeGestureRecognizer *)swipeGes{

    
    if (mClicked == YES) {
        
        [self hideMenuBar];
    }
    
}

-(void)tapGestureClicked:(UIGestureRecognizer *)tapGes{
    
    if (mClicked == YES) {
        
        [self hideMenuBar];
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


-(void)showMenuBar{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //  [homeView setFrame:CGRectMake(-MenuWidth, 0, ViewWidth, ViewHeight)];
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

-(void)creatingPreviousAndNextDates
{
    NSDate *now                  = [NSDate date];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"EEE dd MMM yyyy"];
    //obtaining previous 7 dates from current date
    NSCalendar *calendar         = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear
                                    | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:[NSDate date]];
    
    
    for (int i = 0; i <=1; ++i)
    {
        NSDate *date             = [calendar dateFromComponents:components];
        --components.day;
        [previousDatesArr addObject:[dateFormate stringFromDate:date]];
    }
    //obtaining next 7 dates from current date
    
    for (int j=1;j<7;j++)
    {
               
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:j];
        NSCalendar *cal              = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
        NSDate *newDate2             = [cal dateByAddingComponents:components toDate:now options:0];
        [nextDatesArr addObject:[dateFormate stringFromDate:newDate2]];
    }
    
    //adding both previous and next dates to array
    [avlblDatesArr addObjectsFromArray:[[previousDatesArr reverseObjectEnumerator] allObjects]];
    [avlblDatesArr addObjectsFromArray:nextDatesArr];
    [nextDatesArr addObject:[dateFormate stringFromDate:[NSDate date]]];
    
    
    
    //check in that dates movie show is available or not
    
    
     NSMutableArray *temparr = [[NSMutableArray alloc] init];
    
    
    NSMutableArray *movieThear = [[NSMutableArray alloc] initWithArray:delegateApp.selectedMovie.movieTheatresArr];
    
    
    for (int k = 0; k<movieThear.count; k++) {
        
        MovieTheatreVO *mve = [movieThear objectAtIndex:k];
       
        
        for (int l = 0; l<mve.showDatesArr.count;l++ ) {
            
        ShowDateVO *dateVO = [mve.showDatesArr objectAtIndex:l];
        
        NSDateFormatter *dateFormate2 = [[NSDateFormatter alloc]init];
        [dateFormate2 setDateFormat:@"MM/dd/yyyy"];
        NSDate *newDate = [dateFormate2 dateFromString:dateVO.showDate];
        [dateFormate2 setDateFormat:@"EEE \n dd \n MMM \n yyyy"];
        NSString *str = [dateFormate stringFromDate:newDate];
        
       
        
        if ([avlblDatesArr containsObject:str]) {
            if (![temparr containsObject:str]) {
                
                [temparr addObject:str];

            }
            
          //  [avlblDatesArr removeObject:str];
        }
        
        }


    }
    
    tempArrayofDates = [[NSMutableArray alloc] initWithArray:temparr];
    
//    [avlblDatesArr removeAllObjects];
//    [avlblDatesArr addObjectsFromArray:temparr];
//
    
    

    for (int i=0;i<avlblDatesArr.count;i++)
    {
        DatesVO *dateVO = [[DatesVO alloc]init];
        dateVO.datesStr = [avlblDatesArr objectAtIndex:i];
        [datesArr addObject:dateVO];
    }
    
}



-(NSMutableArray*)creatingTheaterArrWithSelectedDate:(NSString *)selectedDate
{
    // this is to avoid crash if there are any sections already opened for previous date
    openSectionIndex = NSNotFound;
    
    if (theatersArr.count>0)
    {
        [theatersArr removeAllObjects];
    }
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"EEE \n dd \n MMM \n yyyy"];
    NSDate *newDate = [dateFormate dateFromString:selectedDate];
    [dateFormate setDateFormat:@"MM/dd/yyyy"];
    
    
    MovieTheatreVO *theaterVO;
    
    //obtaining new sorted theater based on selcted date and theater show date
    
    for (int i=0;i<[delegateApp.selectedMovie.movieTheatresArr count];i++)
    {
        MovieTheatreVO *mve = [delegateApp.selectedMovie.movieTheatresArr objectAtIndex:i];
        for (int j=0; j<[mve.showDatesArr count];j++)
        {
            ShowDateVO *dateVO = [mve.showDatesArr objectAtIndex:j];
            if ([dateVO.showDate isEqualToString:[dateFormate stringFromDate:newDate]])
            {
                if ([mve.theatreName isEqualToString:selectedTheater] || [selectedTheater isEqualToString:@"Cinemas"])
                {
                    theaterVO = [[MovieTheatreVO alloc]init];
                    theaterVO.serverId=mve.serverId;
                    theaterVO.theatreName=mve.theatreName;
                    theaterVO.logoURL=mve.logoURL;
                    theaterVO.address=mve.address;
                    theaterVO.strArabicName = mve.strArabicName;
                    [theaterVO.showDatesArr addObject:dateVO];
                    [sectionInfoArray addObject:theaterVO];
                    [theatersArr addObject:theaterVO];
                    
                }
            }
        }
    }
    NSMutableArray *tmparray = [[NSMutableArray alloc] init];
    for (theaterVO in theatersArr) {
        SectionInfoTheatre *sectionTheater = [[SectionInfoTheatre alloc] init];
        sectionTheater.theaterVO = theaterVO;
        sectionTheater.open = YES;//by default section is opened
        [tmparray addObject:sectionTheater];
    }
    sectionInfoArray = tmparray;
    [tbofShowTimings reloadData];
    
    return theatersArr;
}



#pragma mark -
#pragma mark - UITableView delegate methods
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (theatersArr.count>0)
    {
        return [theatersArr count];
    }
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"" Message:@"Show Times Not Available"];
        
         
        
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionInfoTheatre *array = [sectionInfoArray objectAtIndex:section];
    NSInteger rows = [[array.theaterVO showDatesArr] count];
    return (array.open) ? rows : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieTheatreVO* theatreVO = [theatersArr objectAtIndex:[indexPath section]];
    ShowDateVO* datevO =[[theatreVO showDatesArr] objectAtIndex:indexPath.row];
    int showTimes = (int)datevO.showTimesArr.count;
    int horizontalTiles = SHOW_NO_OF_HORIZONTAL_TILES;
    int verticalTiles = showTimes/horizontalTiles;
    if (showTimes % horizontalTiles != 0) {
        verticalTiles += 1;
    }
    if ([SMSCountryUtils isIphone]) {
        
        return (verticalTiles *SHOW_TILE_HEIGHT) + (3 * SHOW_TILE_HEIGHT_DIFF) + SHOW_TITLE_HEIGHT;
    }
    else{
    return (verticalTiles *(SHOW_TILE_HEIGHT+20)) + (3 * (SHOW_TILE_HEIGHT_DIFF+8)) + SHOW_TITLE_HEIGHT+20; // here we are adding difference to show the padding on top and bottom of the cell.
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    CGFloat sectionHeaderHeight;
    if ([SMSCountryUtils isIphone]) {
        
         sectionHeaderHeight = 30;

    }
    else{
         sectionHeaderHeight = 50;

    }
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MovieTheatreVO* theatreVO = [theatersArr objectAtIndex:[indexPath section]];
    ShowDateVO* dateVO = [[theatreVO showDatesArr] objectAtIndex:indexPath.row];
    ShowTimesCustomCell *cell = (ShowTimesCustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ShowTimesCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setDelegate:self];
    }
    
    int showTimes =(int) dateVO.showTimesArr.count;
    int horizontalTiles = SHOW_NO_OF_HORIZONTAL_TILES;
    int verticalTiles = showTimes/horizontalTiles;
    if (showTimes % horizontalTiles != 0) {
        verticalTiles += 1;
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setDatesArr:dateVO.showTimesArr];
    [cell createShowTimes:horizontalTiles andVerticalRows:verticalTiles];
    
//    [cell.layer setBorderWidth:4];
//    [cell.layer setCornerRadius:8];
//    
//    [cell.layer setBorderColor:[UIColor whiteColor].CGColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([SMSCountryUtils isIphone]) {
        
        return 30;
    }
    else{
    return 50;
    }
}

- (CGFloat)tableView:(UITableView*)tableView
heightForFooterInSection:(NSInteger)section {
    
    return 5.0;
}

- (UIView*)tableView:(UITableView*)tableView
viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    SectionInfoTheatre *array  = [sectionInfoArray objectAtIndex:section];
    if (!array.sectionView)
    {
        NSString *title = array.theaterVO.theatreName;
        NSString *titleinArabic = array.theaterVO.strArabicName;
     
        SectionView *tempView;
               if ([SMSCountryUtils isIphone]) {
            
                   tempView = [[SectionView alloc] initWithFrame:CGRectMake(0,0, tbofShowTimings.bounds.size.width, 30) WithTitle:[NSString stringWithFormat:@"%@  %@, %@",title,titleinArabic,array.theaterVO.address] WithImage:[NSString stringWithFormat:@"%@",array.theaterVO.logoURL] Section:section delegate:self];

        }
               else{
                  tempView = [[SectionView alloc] initWithFrame:CGRectMake(0,0, tbofShowTimings.bounds.size.width, 50) WithTitle:[NSString stringWithFormat:@"%@  %@, %@",title,titleinArabic,array.theaterVO.address] WithImage:[NSString stringWithFormat:@"%@",array.theaterVO.logoURL] Section:section delegate:self];

               }
        
        [tempView setBackgroundColor:[UIColor clearColor]];
        array.sectionView = tempView;
        
//        [array.sectionView.layer setBorderWidth:4];
//        [array.sectionView.layer setCornerRadius:8];
//        [array.sectionView.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        //[TicketDadaUtils setGradientBackground:tempView];
    }
    
    return array.sectionView;
}
- (void)sectionTapped:(UIButton*)btn {
    
    isMinimize = !isMinimize;
    selectedSection = [btn tag];
    [tbofShowTimings reloadData];
    
}
#pragma mark ShowDateCustomCellDelegate methods

- (void) showDateSelected:(ShowTimeVO *)showtimeVO atIndexPath:(NSIndexPath *)indexPath {
    
    [tbofShowTimings setSeparatorColor:[UIColor clearColor]];
    MovieTheatreVO* theatreVO = [theatersArr objectAtIndex:[indexPath section]];
    ShowDateVO* showDateVO = [[theatreVO showDatesArr] objectAtIndex:indexPath.row];
    
    SeatSelection *tempSeatSelection = [[SeatSelection alloc] init];
    [tempSeatSelection setMovieId:[NSString stringWithFormat:@"%@",delegateApp.selectedMovie.serverId]];
    [tempSeatSelection setMovieName:delegateApp.selectedMovie.movieName];
    [tempSeatSelection setTheaterId:[NSString stringWithFormat:@"%@",theatreVO.serverId]];
    [tempSeatSelection setTheaterName:theatreVO.theatreName];
    [tempSeatSelection setShowId:[NSString stringWithFormat:@"%@",showtimeVO.serverId]];
    [tempSeatSelection setShowTime:showtimeVO.showTime];
    [tempSeatSelection setDate:showDateVO.showDate];
    [tempSeatSelection setStrTheaterNameArabic:theatreVO.strArabicName];
    [tempSeatSelection setMovieThumbnail:delegateApp.selectedMovie.detailThumbnailImg];
    [tempSeatSelection setMovieThumbnailSrc:delegateApp.selectedMovie.thumbnailURL];
    [tempSeatSelection setMovieReleaseDate:delegateApp.selectedMovie.releaseDate];
    [tempSeatSelection setMovieLanguage:delegateApp.selectedMovie.language];
    [tempSeatSelection setMovieCensor:delegateApp.selectedMovie.censor];
    [tempSeatSelection setScreenName:showtimeVO.screenName];
    [tempSeatSelection setTotalnoofSeats:showtimeVO.totalCount];
    [tempSeatSelection setMovieimdbRating:delegateApp.selectedMovie.strimdbRating];
    
    
    //have to navigate bookingviewvcontroller
    
    BookingViewController  *bookingVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"BookingViewController"];
    [bookingVC setCurrSeatSelection:tempSeatSelection];
    [self.navigationController pushViewController:bookingVC animated:YES];
    
    
    
}

#pragma mark SectionView delegate methods

- (void) sectionClosed : (NSInteger) section{
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    SectionInfo *sectionInfo = [sectionInfoArray objectAtIndex:section];
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [tbofShowTimings numberOfRowsInSection:section];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        
        [tbofShowTimings beginUpdates];
        [tbofShowTimings deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
        [tbofShowTimings endUpdates];
    }
    openSectionIndex = NSNotFound;
    [tbofShowTimings setSeparatorColor:[UIColor clearColor]];
}

- (void) sectionOpened : (NSInteger) section
{
    [tbofShowTimings setSeparatorColor:[UIColor clearColor]];
    SectionInfoTheatre *array = [sectionInfoArray objectAtIndex:section];
    array.open = YES;
    NSInteger count = [array.theaterVO.showDatesArr count];
    NSMutableArray *indexPathToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<count;i++)
    {
        [indexPathToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenIndex = openSectionIndex;
    if (previousOpenIndex != NSNotFound)
    {
        SectionInfoTheatre *sectionArray = [sectionInfoArray objectAtIndex:previousOpenIndex];
        sectionArray.open = NO;
        NSInteger counts = [sectionArray.theaterVO.showDatesArr count];
        [sectionArray.sectionView toggleButtonPressed:FALSE];
        for (NSInteger i = 0; i<counts; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenIndex]];
        }
    }
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenIndex == NSNotFound || section < previousOpenIndex)
    {
        insertAnimation = UITableViewRowAnimationFade;
        deleteAnimation = UITableViewRowAnimationFade;
    }
    else
    {
        insertAnimation = UITableViewRowAnimationFade;
        deleteAnimation = UITableViewRowAnimationFade;
    }
    [tbofShowTimings beginUpdates];
    [tbofShowTimings insertRowsAtIndexPaths:indexPathToInsert withRowAnimation:insertAnimation];
    [tbofShowTimings deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [tbofShowTimings endUpdates];
    openSectionIndex = section;
    
}


#pragma mark ---- Icarousel Datasource methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    
    return [avlblDatesArr count];
    
    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    
    view                            = [[UIView alloc] init];
    
    if ([SMSCountryUtils isIphone]) {
        
        if (ViewHeight == 480) {
            
            [view setFrame:CGRectMake(0, 0, 75, 80)];

        }
        else{
        
        [view setFrame:CGRectMake(0, 0, 75, 100)];
        
        }
    }
    else{
        
        [view setFrame:CGRectMake(0, 0, 120, 150)];
    }
    
    NSString *strCurrindexdate = [avlblDatesArr objectAtIndex:index];
    
    UIImageView *titledayImgview      = [[UIImageView alloc] initWithFrame:view.frame];

    if ([tempArrayofDates containsObject:strCurrindexdate]) {
       
        //if its selected index
        
        if (selectedIndexis == index) {
            
            if ([SMSCountryUtils isIphone]) {
                
                if(ViewWidth == iPhone6PlusWidth)
                {
                    titledayImgview.image             = [UIImage imageNamed:@"activeback@3x.png"];
                    
                }
                else{
                    
                    if ([SMSCountryUtils isRetinadisplay]) {
                        
                        titledayImgview.image             = [UIImage imageNamed:@"activeback@2x.png"];
                    }
                    else{
                        
                        titledayImgview.image             = [UIImage imageNamed:@"activeback.png"];
                        
                        NSLog(@"active indes is :%ld",(long)selectedIndexis);
                    }
                    
                    
                }
                
                
            }
            else{
                
                if ([SMSCountryUtils isRetinadisplay]) {
                    
                    titledayImgview.image             = [UIImage imageNamed:@"activeback@2x~ipad.png"];
                    
                }
                else{
                    
                    titledayImgview.image             = [UIImage imageNamed:@"activeback~ipad.png"];
                }
                
                
                
            }

        }
        else{
            
            
            if ([SMSCountryUtils isIphone]) {
                
                
                if(ViewWidth == iPhone6PlusWidth)
                {
                    titledayImgview.image             = [UIImage imageNamed:@"availableBack@3x.png"];
                    
                }
                else{
                    
                    if ([SMSCountryUtils isRetinadisplay]) {
                        
                        titledayImgview.image             = [UIImage imageNamed:@"availableBack@2x.png"];
                    }
                    else{
                        
                        titledayImgview.image             = [UIImage imageNamed:@"availableBack.png"];
                        
                    }
                    
                    
                }
                
                
            }
            else{
                
                if ([SMSCountryUtils isRetinadisplay]) {
                    
                    titledayImgview.image             = [UIImage imageNamed:@"availableBack@2x~ipad.png"];
                    
                }
                else{
                    
                    titledayImgview.image             = [UIImage imageNamed:@"availableBack~ipad.png"];
                }
                
                
                
            }

            
        }
        
       

    }
    else{
        
        if ([SMSCountryUtils isIphone]) {
            
            if(ViewWidth == iPhone6PlusWidth)
            {
                titledayImgview.image             = [UIImage imageNamed:@"notAvaliable@3x.png"];
                
            }
            else{
                
                if ([SMSCountryUtils isRetinadisplay]) {
                    
                    titledayImgview.image             = [UIImage imageNamed:@"notAvaliable@2x.png"];
                }
                else{
                    
                    titledayImgview.image             = [UIImage imageNamed:@"notAvaliable.png"];
                    
                }
                
                
            }
            
            
            
        }
        else{
            if ([SMSCountryUtils isRetinadisplay]) {
                
                titledayImgview.image             = [UIImage imageNamed:@"notAvaliable@2x~ipad.png"];
                
            }
            else{
                
                titledayImgview.image             = [UIImage imageNamed:@"notAvaliable~ipad.png"];
            }
            
        }

    }
    

    NSArray *datesarr                 = [[avlblDatesArr objectAtIndex:index] componentsSeparatedByString:@" "];
    
    [titledayImgview setBackgroundColor:[UIColor grayColor]];
    UILabel *lblofDay                = [[UILabel alloc] init];
    [lblofDay setText:[NSString stringWithFormat:@"%@",[datesarr objectAtIndex:0]]];
    
    UILabel *lblofMonth              = [[UILabel alloc] init];
    [lblofMonth setText:[NSString stringWithFormat:@"%@",[datesarr objectAtIndex:2]]];
   
    UILabel *lblofDate               = [[UILabel alloc] init];
    
    [lblofDate setText:[NSString stringWithFormat:@"%@",[datesarr objectAtIndex:1]]];
    [lblofDay setTextAlignment:NSTextAlignmentCenter];
    [lblofMonth setTextAlignment:NSTextAlignmentCenter];
    [lblofDate setTextAlignment:NSTextAlignmentCenter];
    
    if ([SMSCountryUtils isIphone]) {
        
        if (ViewHeight == 480) {
            
            [lblofDay setFrame:CGRectMake(13, 3, 50, 20)];
            [lblofMonth setFrame:CGRectMake(16, 30, 50, 20)];
            [lblofDate setFrame:CGRectMake(16, 52, 50, 20)];
            [lblofDay setFont:[UIFont fontWithName:LATO_REGULAR size:14]];
            [lblofMonth setFont:[UIFont fontWithName:LATO_REGULAR size:14]];
            [lblofDate setFont:[UIFont fontWithName:LATO_BOLD size:16]];

        }
        else{
        [lblofDay setFrame:CGRectMake(16, 9, 50, 20)];
        [lblofMonth setFrame:CGRectMake(16, 40, 50, 20)];
        [lblofDate setFrame:CGRectMake(16, 72, 50, 20)];
        [lblofDay setFont:[UIFont fontWithName:LATO_REGULAR size:16]];
        [lblofMonth setFont:[UIFont fontWithName:LATO_REGULAR size:16]];
        [lblofDate setFont:[UIFont fontWithName:LATO_BOLD size:18]];
        }
    }
    else{
        
        [lblofDay setFrame:CGRectMake(25, 9, 70, 40)];
        [lblofMonth setFrame:CGRectMake(25, 60, 70, 40)];
        [lblofDate setFrame:CGRectMake(25, 100, 70, 40)];
        [lblofDay setFont:[UIFont fontWithName:LATO_REGULAR size:25]];
        [lblofMonth setFont:[UIFont fontWithName:LATO_REGULAR size:25]];
        [lblofDate setFont:[UIFont fontWithName:LATO_BOLD size:35]];

    }
    [view addSubview:titledayImgview];
    [view addSubview:lblofDay];
    [view addSubview:lblofMonth];
    [view addSubview:lblofDate];
    return view;
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    
    
    
  
    if ( carousel.scrollOffset == 0) {
        
        
        if([SMSCountryUtils isIphone]){
            [icarouselofDates scrollToOffset:1.3 duration:0.2];
        }
        else{
            [icarouselofDates scrollToOffset:2.3 duration:0.2];
        }
    }
    else if (carousel.scrollOffset == 7){
        
        if ([SMSCountryUtils isIphone]) {
            
            [icarouselofDates scrollToOffset:5.6 duration:0.2];
            
        }
        else{
            
            [icarouselofDates scrollToOffset:4.6 duration:0.2];
        }
        
        
        
    }

    
    
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    
    NSString *strSelectedDate = [avlblDatesArr objectAtIndex:index];
    
    if ([tempArrayofDates containsObject:strSelectedDate]) {
        
//        [icarouselofDates setCenterItemWhenSelected:YES];
        selectedIndexis = index;
        [icarouselofDates reloadData];
        [self creatingTheaterArrWithSelectedDate:[avlblDatesArr objectAtIndex:index]];

    }
    else{
        
        [icarouselofDates scrollToItemAtIndex:selectedIndexis animated:NO];
    }
    
    
  
    
    
}
-(IBAction)btnBackToSele:(id)sender{
    
    [icarouselofDates setHidden:YES];
    
    
    
    NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    int index = 0;
    for(int i=0 ; i<[arrofNavoagtionsCon count] ; i++)
    {
        if([[arrofNavoagtionsCon objectAtIndex:i] isKindOfClass:NSClassFromString(@"Movies_EventsViewController")])
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
