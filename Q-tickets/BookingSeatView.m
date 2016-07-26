//
//  SeatView.m
//  SeatLayout
//
//  Created by Laxmikanth Reddy on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookingSeatView.h"
#import "SMSCountryUtils.h"


@implementation BookingSeatView

@synthesize seatVO,bookingRowViewRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithRowView:(id)rview {
    self = [super init];
    if (self) {
        bookingRowViewRef = rview;
        [self setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *singletapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:singletapGesture];
//        [singletapGesture release];
    }
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer {
    
    if (seatVO.seatStatus == NOT_AVAILABLE || seatVO.seatStatus == DISABLED) {
        return;
    }
    
    if (seatVO.seatStatus == AVAILABLE) {
        [self changeSeatStateTo:RESERVED];
        [bookingRowViewRef seatSelected:seatVO seatView:self];
        
    }
    else if (seatVO.seatStatus == RESERVED) {
        [self changeSeatStateTo:AVAILABLE];
        [bookingRowViewRef seatSelected:seatVO seatView:self];
    }
}

- (void)changeSeatStateTo:(SeatStatus)status {
    
    [self setBackgroundColor:[UIColor clearColor]];

    switch (status) {

        case NOT_AVAILABLE:
            
            if ([SMSCountryUtils isIphone]) {
                
                  [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"soldout.png"]]];
            }else{
                
                  [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"soldout@2x.png"]]];
            }
            
          

            seatVO.seatStatus = NOT_AVAILABLE;
            break;
            
        case AVAILABLE:
            if(seatVO.bookingRowVO.isFamily)
            {
                if ([SMSCountryUtils isIphone]) {
                    
                    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"family.png"]]];
                }
                else{
                    
                    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"family@2x.png"]]];
                }
                
            }
            else
            {
                
                if ([SMSCountryUtils isIphone]) {
                    
                    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"available.png"]]];
                }
                else{
                    
                    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"available@2x.png"]]];
                }
            
            }
            seatVO.seatStatus = AVAILABLE;
            break;

        case RESERVED:
            
            if ([SMSCountryUtils isIphone]) {
                
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"yourSelection.png"]]];
            }
            else{
                
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"yourSelection@2x.png"]]];
            }
            

            seatVO.seatStatus = RESERVED;

            break;
            
        default:
            break;
    }
}

- (void)dealloc {
//    [seatVO release];
//    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
