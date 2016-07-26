//
//  SeatLayoutView.h
//  SeatLayout
//
//  Created by Laxmikanth Reddy on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatLayoutVO.h"
#import "BookingClassView.h"
#import "BookingRowView.h"

@protocol SeatLayoutViewDelegate

- (void)updateSeatSelection:(NSMutableArray *)selectedSeats;
@end

@interface SeatLayoutView : UIScrollView<BookingClassViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate> {
    
    NSMutableArray                  *seatClasses;
    NSString                        *currentSelectedClassName;
    int                             selectedSeatsCount;
    NSMutableArray                  *selectedSeats;
    int                             maxSeatsSelection;
    BOOL                            isAdvToken;
    NSString                        *advTokenNotes;
    NSString                        *bookingFees;
    
    id<SeatLayoutViewDelegate>      seatLayoutVCRef;
    
    // we are adding this view as the main view for all the classes because this will be zoomable inside the scrollview.
    UIView                          *mainLayoutView;
}

@property (nonatomic, retain) NSMutableArray            *seatClasses;
@property (nonatomic, retain) NSString                  *currentSelectedClassName;
@property (nonatomic, assign) int                       selectedSeatsCount;
@property (nonatomic, retain) NSMutableArray            *selectedSeats;
@property (nonatomic, assign) int                       maxSeatsSelection;
@property (nonatomic, assign) BOOL                      isAdvToken;
@property (nonatomic, retain) NSString                  *advTokenNotes;
@property (nonatomic, retain) NSString                  *bookingFees;
@property (nonatomic, retain) id<SeatLayoutViewDelegate>    seatLayoutVCRef;
@property (nonatomic, retain) UIView                    *mainLayoutView;
@property (nonatomic,retain) id                          stView;
@property (nonatomic,retain)BookingSeatVO                *bkngSeatvo;
@property (nonatomic, assign) BOOL                       familyAlertCount;

- (id)initWithSeatClasses:(NSMutableArray *)lseatClasses maxBooking:(int)maxSelection bookingFees:(float)lbookingFees withController:(id<SeatLayoutViewDelegate>)sLayoutController;
- (void)loadBookingClasses;
- (void)loadBookingClass:(BookingClassVO *)bClassVO forLayoutView:(UIView *)layoutView withParent:(id)parent;
- (void)loadBookingRow:(BookingRowVO *)rowVO forClassView:(id)cview;
- (void)loadBookingSeat:(BookingSeatVO *)seatVO forRowView:(id)rview;



@end
