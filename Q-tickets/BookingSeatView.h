//
//  SeatView.h
//  SeatLayout
//
//  Created by Laxmikanth Reddy on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatLayoutVO.h"

@protocol BookingSeatviewDelegate

- (void)seatSelected:(BookingSeatVO *)svo seatView:(id)sview;

@end

@interface BookingSeatView : UIView {

    BookingSeatVO  *seatVO;
    id<BookingSeatviewDelegate> bookingRowViewRef;
}

@property (nonatomic, retain) BookingSeatVO    *seatVO;
@property (nonatomic, retain) id<BookingSeatviewDelegate>   bookingRowViewRef;

- (id)initWithRowView:(id)rview;
- (void)changeSeatStateTo:(SeatStatus)status;

@end
