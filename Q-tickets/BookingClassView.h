//
//  ClassView.h
//  SeatLayout
//
//  Created by Laxmikanth Reddy on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatLayoutVO.h"
#import "BookingRowView.h"

@protocol BookingClassViewDelegate

- (void)seatSelected:(BookingSeatVO*)svo seatView:(id)sview;

@end

@interface BookingClassView : UIView <BookingRowViewDelegate> {
    
    BookingClassVO  *bookingClassVO;
    id<BookingClassViewDelegate>  seatLayoutViewRef;
}

@property (nonatomic, retain) BookingClassVO    *bookingClassVO;
@property (nonatomic, retain) id<BookingClassViewDelegate>    seatLayoutViewRef;

- (id)initWithSeatLayoutView:(id)slayoutview;

@end
