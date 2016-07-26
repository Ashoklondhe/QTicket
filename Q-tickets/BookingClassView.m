//
//  ClassView.m
//  SeatLayout
//
//  Created by Laxmikanth Reddy on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookingClassView.h"

@implementation BookingClassView

@synthesize bookingClassVO,seatLayoutViewRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithSeatLayoutView:(id)slayoutview {
    self = [super init];
    if (self) {
        seatLayoutViewRef = slayoutview;
    }
    return self;
}


- (void)dealloc {
    [bookingClassVO release];
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
    [seatLayoutViewRef seatSelected:svo seatView:sview];
}

@end
