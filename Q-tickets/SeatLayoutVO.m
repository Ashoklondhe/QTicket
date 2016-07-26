//
//  SeatLayoutVO.m
//  SMSCountry
//
//  Created by Lakshmikanth on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "SeatLayoutVO.h"

@implementation SeatLayoutVO
@synthesize maxBooking,bookingFees,screenURL,bookingClassesArr;

- (id)init
{
    self = [super init];
    if (self) {
        bookingClassesArr = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation BookingClassVO

@synthesize classId,className,cost,noOfRows,bookingRowsArr,classFrame;

- (id)init
{
    self = [super init];
    if (self) {
        bookingRowsArr = [[NSMutableArray alloc] init];
    }
    return self;
}

@end


@implementation BookingRowVO

@synthesize bookingClassVO,rowFrame,rowName,availableSeatsCount,isFamily,noOfGangwaySeats,seatsArr,isInitialGangway,isInitialGangwayCount;

- (id)init
{
    self = [super init];
    if (self) {
        seatsArr = [[NSMutableArray alloc] init];
    }
    return self;
}


@end


@implementation BookingSeatVO
@synthesize bookingRowVO,seatNumber,seatStatus,isNextGangway,gangwayCount,seatFrame,isFamilyRow;



@end
