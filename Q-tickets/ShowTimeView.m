//
//  ShowDateView.m
//  TestCustomCellWithButtons
//
//  Created by Laxmikanth Reddy on 28/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowTimeView.h"
#import "SMSCountryUtils.h"
#import "Q-ticketsConstants.h"
@implementation ShowTimeView

@synthesize showDateCellRef,showTimeVO;

- (id)initWithDelegate:(id<ShowDateViewDelegate>)delegate {
    self = [super init];
    if (self) {
        showDateCellRef = delegate;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userClicked:)];
        
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}


- (void)userClicked:(UITapGestureRecognizer *)recognizer {

    if([[showTimeVO showType] isEqualToString:SHOW_TIME_SOLDOUT])
    {
//        [TicketDadaUtils showAlertMessageWithTitle:@"Warning" Message:@"Tickets are already sold out"];
    }
    else if([[showTimeVO isEnable] isEqualToString:@"false"])
    {
//        [TicketDadaUtils showAlertMessageWithTitle:@"Warning" Message:@"Booking time is over"];
    }
    else if ([[showTimeVO showType] isEqualToString:SHOW_TIME_AVAILABLE] || [[showTimeVO showType]isEqualToString:@"Available"]) // && [[showtimeVO isEnable] isEqualToString:@"true"])
    {
//        int noofTotlaseats = showTimeVO.totalCount;
//        int noofAvaialbeleseats = showTimeVO.availableCount;
//        
//        CGFloat percentageIs = (noofAvaialbeleseats * 100) / noofTotlaseats;
         [showDateCellRef showDateSelected:showTimeVO];
    }
    else if ([[showTimeVO showType] isEqualToString:SHOW_TIME_COMPLETED]) // && [[showtimeVO isEnable] isEqualToString:@"true"])
    {
        //[showDateCellRef showDateSelected:showTimeVO];
    }
    else if ([[showTimeVO showType] isEqualToString:SHOW_TIME_DELAYED]) // && [[showtimeVO isEnable] isEqualToString:@"true"])
    {
        //[showDateCellRef showDateSelected:showTimeVO];
    }
}

@end
