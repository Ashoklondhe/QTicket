//
//  RowView.m
//  SeatLayout
//
//  Created by Laxmikanth Reddy on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookingRowView.h"

@implementation BookingRowView

@synthesize bookingRow,bookingClassViewRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithClassView:(id)cview {
    self = [super init];
    if (self) {
        bookingClassViewRef = cview;
    }
    return self;
}

- (void)dealloc {
    [bookingRow release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)seatSelected:(BookingSeatVO *)svo seatView:(id)sview {
    [bookingClassViewRef seatSelected:svo seatView:sview];
}

@end
