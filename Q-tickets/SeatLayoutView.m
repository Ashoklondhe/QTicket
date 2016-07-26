//
//  SeatLayoutView.m
//  SeatLayout
//
//  Created by Laxmikanth Reddy on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SeatLayoutView.h"
#import "BookingClassView.h"
#import "BookingRowView.h"
#import "BookingSeatView.h"
#import "SMSCountryUtils.h"
#import "Q-ticketsConstants.h"

#define CLASS_HEIGHT_PADDING    5

#define ROW_NAME_WIDTH      30
#define ROW_HEIGHT          40
#define ROW_HEIGHT_PADDING  5

#define SEAT_WIDTH          35
#define SEAT_HEIGHT         35

#define SEAT_WIDTH_PADDING  6

#define CLASS_NAME_HEIGHT   30

#define EXTRA_SCROLL_VIEW_PADDING   10

#define SCREEN_VIEW_WIDTH   300
#define SCREEN_VIEW_HEIGHT  30

#if !defined (MAX)
#define MAX(A,B)    ((A) > (B) ? (A) : (B))
#endif

#if !defined (MIN)
#define MIN(A,B)    ((A) < (B) ? (A) : (B))
#endif



@implementation SeatLayoutView

@synthesize seatClasses,currentSelectedClassName,selectedSeatsCount,selectedSeats,maxSeatsSelection,isAdvToken,advTokenNotes,bookingFees,seatLayoutVCRef,mainLayoutView,stView,bkngSeatvo,familyAlertCount;

- (id)init {
    self = [super init];
    if (self) {
        
       
    }
    return self;
}

- (id)initWithSeatClasses:(NSMutableArray *)lseatClasses maxBooking:(int)maxSelection bookingFees:(float)lbookingFees withController:(id<SeatLayoutViewDelegate>)sLayoutController {
    
    self = [super init];
    if (self) {
        
        familyAlertCount=YES;
        [self setSeatLayoutVCRef:sLayoutController];
        [self setSeatClasses:lseatClasses];
        
        [self setDelegate:self];
        
        UIView *tempview = [[UIView alloc] initWithFrame:CGRectZero];
        [tempview setUserInteractionEnabled:YES];
        [self setMainLayoutView:tempview];
        [tempview release];
        [self addSubview:mainLayoutView];
        //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"InnerBackground"]]];
        [self loadBookingClasses];
        
        selectedSeats = [[NSMutableArray alloc] init];
        self.maxSeatsSelection = maxSelection;
        self.bookingFees = [NSString stringWithFormat:@"%f",lbookingFees];
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTapRecognizer];
        [doubleTapRecognizer release];
    }
    return self;
}

- (void)dealloc {
    [seatClasses release];
    [currentSelectedClassName release];
    [selectedSeats release];
    [advTokenNotes release];
    [bookingFees release];
    [mainLayoutView release];
    [super dealloc];
}

#pragma mark
#pragma mark Loading Classes
#pragma mark

- (void)loadBookingClasses {
    
    for (int i = 0; i < seatClasses.count; i ++) {
        
        BookingClassVO *bClassVO = [seatClasses objectAtIndex:i];
        CGRect  classRect = CGRectZero;
        
        int classX = 5;
        int classY = 5;
        float classWidth = 0;
        float classHeight = 0;
        int maxSeats = 0;
        int maxGangwaySeats = 0;
        
        if (i > 0) {
            BookingClassVO *prevClassVO = [seatClasses objectAtIndex:i-1];
            classY = prevClassVO.classFrame.origin.y + prevClassVO.classFrame.size.height + CLASS_HEIGHT_PADDING;
        }
        
        for (BookingRowVO *rvo in bClassVO.bookingRowsArr) {
            
            if (maxSeats < rvo.totalSeats) {
                maxSeats = rvo.totalSeats;
                
                if (rvo.isInitialGangway)
                {
                    maxSeats += rvo.isInitialGangwayCount;
                }
                
                if (rvo.noOfGangwaySeats > 0) {
                    int gangwaycounts = 0;
                    for (BookingSeatVO *tempSeat in rvo.seatsArr) {
                        if (tempSeat.isNextGangway) {
                            gangwaycounts += tempSeat.gangwayCount;
                        }
                    }
                    
                    maxGangwaySeats = gangwaycounts;
                }
            }
        }
        
        maxSeats += maxGangwaySeats;
        // last we have done classX*2 because there is a gap in front and the same gap should be kept at the end.
        
        classWidth = ROW_NAME_WIDTH + SEAT_WIDTH_PADDING + maxSeats * (SEAT_WIDTH + SEAT_WIDTH_PADDING) + classX * 2 + ROW_NAME_WIDTH;
        classHeight = CLASS_NAME_HEIGHT + ROW_HEIGHT_PADDING + bClassVO.noOfRows * (ROW_HEIGHT + ROW_HEIGHT_PADDING)+50;
        classRect = CGRectMake(classX, classY, classWidth, classHeight);
        [bClassVO setClassFrame:classRect];
        float newWidth = MAX(self.contentSize.width, classWidth);
        float newHeight = self.contentSize.height + classHeight;
        CGSize newSize = CGSizeMake(newWidth + EXTRA_SCROLL_VIEW_PADDING,newHeight + EXTRA_SCROLL_VIEW_PADDING);
        
        [mainLayoutView setFrame:CGRectMake(0, 0, newSize.width, newSize.height)];
        [self setContentSize:newSize];
        
        [self loadBookingClass:bClassVO forLayoutView:mainLayoutView withParent:self];
    }
    // adding screen view
    BookingClassVO *lastClassVO = [seatClasses lastObject];
    UIImage *image;
    if ([SMSCountryUtils isIphone]) {
        
        
//        
//            if ([SMSCountryUtils isRetinadisplay]) {
//                
//                 image = [UIImage imageNamed:@"theatre-screen@2x.png"];
//            }
//            else{
//                
//                 image = [UIImage imageNamed:@"theatre-screen.png"];
//                
//        }

        
        image = [UIImage imageNamed:@"theatre-screen.png"];

    }
    else{
        
//        if ([SMSCountryUtils isRetinadisplay]) {
//            
//            image = [UIImage imageNamed:@"theatre-screen@2x~ipad.png"];
//        }
//        else{
//            
//            image = [UIImage imageNamed:@"theatre-screen~ipad.png"];
//            
//            
        
            
//        }
        image = [UIImage imageNamed:@"theatre-screen@2x.png"];

    }
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image];
    [imageView1 setFrame:CGRectMake(lastClassVO.classFrame.origin.x-2, lastClassVO.classFrame.origin.y+lastClassVO.classFrame.size.height+CLASS_HEIGHT_PADDING, lastClassVO.classFrame.size.width, SCREEN_VIEW_HEIGHT)];
   // [imageView1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"theatreBg.png"]]];
    [mainLayoutView addSubview:imageView1];
    [imageView1 release];
    //[mainLayoutView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"theatreBg.png"]]];

}

#pragma mark
#pragma mark Loading Class
#pragma mark

// here we have added extra parameter as "parent" this parent will be the layout reference which acts as a delegate when seat is selected that will be called back in the layoutVC, where as "layoutView" parameter is only view reference all the classes will be added to this view which acts as a parent view for all.

- (void)loadBookingClass:(BookingClassVO *)bClassVO forLayoutView:(UIView *)layoutView withParent:(id)parent {
    
    BookingClassView *bClassView = [[BookingClassView alloc] initWithSeatLayoutView:parent];
   // [bClassView setBackgroundColor:[UIColor lightGrayColor]];
 //   [bClassView setBackgroundColor:[UIColor colorWithRed:0.50196 green:0.50196 blue:0.50196 alpha:0.5]];
    [bClassView setBackgroundColor:[UIColor whiteColor]];
    [bClassView setBookingClassVO:bClassVO];
    [bClassView setFrame:bClassVO.classFrame];
    UILabel *classLbl = [[UILabel alloc] init];
    [classLbl setFrame:CGRectMake(bClassVO.classFrame.origin.x, bClassVO.classFrame.origin.x, 200, CLASS_NAME_HEIGHT)];
    [classLbl setBackgroundColor:[UIColor clearColor]];
    [classLbl setText:bClassVO.className];
    [classLbl setTextColor:[UIColor colorWithRed:.2 green:.2 blue:.7 alpha:1]];
    [classLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:18]];
    [bClassView addSubview:classLbl];
    [classLbl release];
    // creating rows
    for (int i = 0; i < bClassVO.bookingRowsArr.count; i ++) {
        BookingRowVO *bRowVO = [bClassVO.bookingRowsArr objectAtIndex:i];
        
        CGRect  rowRect = CGRectZero;
        
        int rowX = bClassVO.classFrame.origin.x;
        int rowY = CLASS_NAME_HEIGHT + ROW_HEIGHT_PADDING;
        
        if(i > 0) {
            BookingRowVO *prevRowVO = [bClassVO.bookingRowsArr objectAtIndex:i -1];
            rowY =  prevRowVO.rowFrame.origin.y + prevRowVO.rowFrame.size.height + ROW_HEIGHT_PADDING;
        }
        
        int gangwaycounts = 0;
        
        for (BookingSeatVO *tempSeat in bRowVO.seatsArr) {
            if (tempSeat.isNextGangway) {
                gangwaycounts += tempSeat.gangwayCount;
            }
        }
        
        int initialGanwayCount=0;
        
        if (bRowVO.isInitialGangway)
        {
            initialGanwayCount +=bRowVO.isInitialGangwayCount;
        }
        
        float rowWidth = ROW_NAME_WIDTH + SEAT_WIDTH_PADDING + (bRowVO.totalSeats + gangwaycounts + initialGanwayCount) * (SEAT_WIDTH + SEAT_WIDTH_PADDING) + ROW_NAME_WIDTH;
        //NSLog(@"rowwidth:%f",rowWidth);
        
        float rowHeight = ROW_HEIGHT;
        rowRect = CGRectMake(rowX, rowY, rowWidth, rowHeight);
        [bRowVO setRowFrame:rowRect];
        [self loadBookingRow:bRowVO forClassView:bClassView];
    }
    [layoutView addSubview:bClassView];
    [bClassView release];
}

#pragma mark
#pragma mark Loading Row
#pragma mark

- (void)loadBookingRow:(BookingRowVO *)rowVO forClassView:(id)cview {
    BookingRowView *bRowView = [[BookingRowView alloc] initWithClassView:cview];
    [bRowView setBookingRow:rowVO];
    [bRowView setFrame:rowVO.rowFrame];
    
    UILabel *rowLbl = [[UILabel alloc] init];
    [rowLbl setFrame:CGRectMake(rowVO.rowFrame.origin.x, rowVO.rowFrame.origin.x-5, ROW_NAME_WIDTH, ROW_HEIGHT)];
    [rowLbl setBackgroundColor:[UIColor clearColor]];
   // [rowLbl setTextColor:[UIColor whiteColor]];
    [rowLbl setText:rowVO.rowName];
    if ([SMSCountryUtils isIphone]) {
        
        [rowLbl setFont:[UIFont fontWithName:ARIAL size:FONT_SIZE_24]];

    }
    else{
        [rowLbl setFont:[UIFont fontWithName:ARIAL size:FONT_SIZE_30]];

    }
    
    [bRowView addSubview:rowLbl];
    [rowLbl release];
    
    int seatX = ROW_NAME_WIDTH + SEAT_WIDTH_PADDING;
    int seatY = 2;//rowVO.rowFrame.origin.y;
    
    if (rowVO.isInitialGangway)
    {
        BookingSeatVO *prevSeatVO = [rowVO.seatsArr lastObject];
        int seatXval = prevSeatVO.seatFrame.origin.x;
        for (int l=1; l<=rowVO.isInitialGangwayCount;l++)
        {
            seatX =  seatXval + SEAT_WIDTH * (l + 1 ) + SEAT_WIDTH_PADDING * ( 1 + l);
        }
    }
    
    for (int i = 0; i < rowVO.seatsArr.count; i ++) {
        BookingSeatVO *sVO = [rowVO.seatsArr objectAtIndex:i];
        sVO.isFamilyRow=rowVO.isFamily;
        CGRect  seatRect = CGRectZero;
        
        if(i > 0) {
            BookingSeatVO *prevSeatVO = [rowVO.seatsArr objectAtIndex:i -1];
            
            if (prevSeatVO.isNextGangway) {
                seatX =  prevSeatVO.seatFrame.origin.x + SEAT_WIDTH * (prevSeatVO.gangwayCount + 1) + SEAT_WIDTH_PADDING * (prevSeatVO.gangwayCount + 1); // here we have added +1 because we need to add the width of prevSeatVO class + children, so we have added +1.
            } else {
                seatX =  prevSeatVO.seatFrame.origin.x + prevSeatVO.seatFrame.size.width + SEAT_WIDTH_PADDING;
            }
        }
        seatRect = CGRectMake(seatX, seatY, SEAT_WIDTH, SEAT_HEIGHT);
        [sVO setSeatFrame:seatRect];
        [self loadBookingSeat:sVO forRowView:bRowView];
        if (sVO.isNextGangway) {
            BookingSeatVO *prevGangwaySeat = nil;
            for (int j = 0; j < sVO.gangwayCount; j ++) {
                BookingSeatVO *tempGangwaySeat = [[BookingSeatVO alloc] init];
                [tempGangwaySeat setSeatNumber:@"Way"];
                
                if (prevGangwaySeat == nil) {
                    seatX =  sVO.seatFrame.origin.x + sVO.seatFrame.size.width + SEAT_WIDTH_PADDING;
                    
                } else {
                    seatX =  prevGangwaySeat.seatFrame.origin.x + prevGangwaySeat.seatFrame.size.width + SEAT_WIDTH_PADDING;
                }
                
                seatRect = CGRectMake(seatX, seatY, SEAT_WIDTH, SEAT_HEIGHT);
                [tempGangwaySeat setSeatFrame:seatRect];
                [self loadBookingSeat:tempGangwaySeat forRowView:bRowView];
                prevGangwaySeat = tempGangwaySeat;
                [tempGangwaySeat release];
            }
        }
    }
    
    // adding row title
    UILabel *rowendLbl = [[UILabel alloc] init];
    [rowendLbl setFrame:CGRectMake(rowVO.rowFrame.size.width-ROW_NAME_WIDTH, rowVO.rowFrame.origin.x-5, ROW_NAME_WIDTH, ROW_HEIGHT)];
    [rowendLbl setBackgroundColor:[UIColor clearColor]];
    [rowendLbl setText:rowVO.rowName];
//    [rowendLbl setTextColor:[UIColor whiteColor]];

    if ([SMSCountryUtils isIphone]) {
        [rowendLbl setFont:[UIFont fontWithName:ARIAL size:FONT_SIZE_24]];

    }
    else{
        [rowendLbl setFont:[UIFont fontWithName:ARIAL size:FONT_SIZE_30]];

    }
//    [bRowView addSubview:rowendLbl];
    [rowendLbl release];
    [cview addSubview:bRowView];
    [bRowView release];
}

#pragma mark
#pragma mark Loading Seat
#pragma mark

- (void)loadBookingSeat:(BookingSeatVO *)seatVO forRowView:(id)rview {
    BookingSeatView *bSeatView = [[BookingSeatView alloc] initWithRowView:rview];
    [bSeatView setSeatVO:seatVO];
    [bSeatView setFrame:seatVO.seatFrame];
    //    [bSeatView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *seatNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bSeatView.frame.size.width, bSeatView.frame.size.height)];
    [seatNumLbl setTextAlignment:NSTextAlignmentCenter];
    
    
    [seatNumLbl setBackgroundColor:[UIColor clearColor]];
    [seatNumLbl setFont:[UIFont fontWithName:@"OpenSans-Bold" size:16]];
    [seatNumLbl setTextColor:[UIColor orangeColor]];
    [bSeatView addSubview:seatNumLbl];
    
    if (seatVO.seatStatus == AVAILABLE && seatVO.isFamilyRow==true) {
        
        if ([SMSCountryUtils isIphone]) {
            
            [bSeatView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"family.png"]]];
        }
        else{
            
            [bSeatView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"family@2x.png"]]];
        }
        
    }
    else if (seatVO.seatStatus == AVAILABLE && seatVO.isFamilyRow==false)
    {
        if ([SMSCountryUtils isIphone]) {
            
             [bSeatView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"available.png"]]];
        }
        else{
             [bSeatView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"available@2x.png"]]];
        }
       
    }
    else if (seatVO.seatStatus == NOT_AVAILABLE) {
        if ([SMSCountryUtils isIphone]) {
            
            [bSeatView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"soldout.png"]]];
        }
        else{
            [bSeatView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"soldout@2x.png"]]];
        }
    }
    [seatNumLbl release];
    //NSLog(@"seatrow:%@",[bSeatView description]);
    [rview addSubview:bSeatView];
    [bSeatView release];
}

#pragma mark
#pragma mark BookingClassViewDelegate
#pragma mark

- (void)seatSelected:(BookingSeatVO *)svo seatView:(id)sview {
    
      
    // increment the counter logic
    if (svo.seatStatus == RESERVED) {
        //        increment selection count
        selectedSeatsCount ++;
        [selectedSeats addObject:svo];
        
        if (svo.bookingRowVO.isFamily && selectedSeatsCount <= maxSeatsSelection)
        {
            if (familyAlertCount)
            {
                
                //updated by krishna
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowFamilyAlert" object:nil];
                
                
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Seats" message:@"You are trying to book tickets reserved for families! \n If you are not viewing the movie with family,please select other seats. \n The supervisor reserves the right to reject admission if you are not a family" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                bkngSeatvo=svo;
                stView=sview;
//                [alert show];
//                [alert release];
                
                //by krishna
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClickedOnAlert:) name:@"FamilyNotifiClicked" object:nil];

            }
           
        }
        
    } else if (svo.seatStatus == AVAILABLE) {
        //        decrement selection count
        selectedSeatsCount --;
        [selectedSeats removeObject:svo];
    }
    
    // compare with max selection
    if (selectedSeatsCount > maxSeatsSelection) {
        // NSLog(@"You are allowed to book upto %i seats per day.",maxSeatsSelection);
        [SMSCountryUtils showAlertMessageWithTitle:@"Warning" Message:[NSString stringWithFormat:@"you can book %i seats in a single transaction.",maxSeatsSelection]];
       [sview changeSeatStateTo:AVAILABLE];
        selectedSeatsCount --;
        [selectedSeats removeObject:svo];
        
    } else {
        // compare with class names
        if (currentSelectedClassName == nil) {
            currentSelectedClassName = svo.bookingRowVO.bookingClassVO.className;
            
            [seatLayoutVCRef updateSeatSelection:selectedSeats];
            
            // add or remove the seat from selectedSeatsArr based upon seat status either Booked or Available
            
        } else {
            
            [seatLayoutVCRef updateSeatSelection:selectedSeats];
            
            // add or remove the seat from selectedSeatsArr based upon seat status either Booked or Available
        }
    }
    if (selectedSeatsCount == 0) {
        currentSelectedClassName = nil;
    }
}
#pragma mark
#pragma mark AlertView Delegate
#pragma mark

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        selectedSeatsCount --;
        [selectedSeats removeObject:bkngSeatvo];
       [stView changeSeatStateTo:AVAILABLE];
      [seatLayoutVCRef updateSeatSelection:selectedSeats];
    }
   
    familyAlertCount=NO;
}


//by krishna
-(void)ClickedOnAlert:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"FamilyNotifiClicked"]) {
        
        NSDictionary *userinfo = [[NSDictionary alloc]initWithDictionary:notification.object];
        
        
        if ([userinfo[@"value"] isEqualToString:@"NO"]) {
            
            selectedSeatsCount --;
            [selectedSeats removeObject:bkngSeatvo];
            [stView changeSeatStateTo:AVAILABLE];
            [seatLayoutVCRef updateSeatSelection:selectedSeats];
        }
        
        familyAlertCount=NO;
        
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}



#pragma mark
#pragma mark UIScrollViewDelegate Methods
#pragma mark

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return mainLayoutView;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    
    static BOOL isTappedSecondTime = NO;
    CGFloat newZoomScale;
    if (!isTappedSecondTime) {
        // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
        newZoomScale = self.zoomScale * 1.5f;
    } else {
        // Get a zoom scale that's zoomed out slightly, capped at the minimum zoom scale specified by the scroll view
        newZoomScale = self.zoomScale * -1.5f;
    }
    
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:self.mainLayoutView];
    newZoomScale = MIN(newZoomScale, self.maximumZoomScale);
    // Figure out the rect we want to zoom to, then zoom to it
    CGSize scrollViewSize = self.bounds.size;
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    [self zoomToRect:rectToZoomTo animated:YES];
    isTappedSecondTime = !isTappedSecondTime;
}

@end
