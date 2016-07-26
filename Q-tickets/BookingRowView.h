//
//  RowView.h
//  SeatLayout
//
//  Created by Laxmikanth Reddy on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatLayoutVO.h"
#import "BookingSeatView.h"

@protocol BookingRowViewDelegate

- (void)seatSelected:(BookingSeatVO *)svo seatView:(id)sview;

@end

@interface BookingRowView : UIView <BookingSeatviewDelegate> {
    
    BookingRowVO    *bookingRow;
    id<BookingRowViewDelegate>       bookingClassViewRef;
}

@property (nonatomic, retain) BookingRowVO  *bookingRow;
@property (nonatomic, retain) id<BookingRowViewDelegate>     bookingClassViewRef;

- (id)initWithClassView:(id)cview;

@end
