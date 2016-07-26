//
//  SeatLayoutVO.h
//  SMSCountry
//
//  Created by Lakshmikanth on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    AVAILABLE = 1,      // green color.
    NOT_AVAILABLE,
    FAMILY,               // already booked seat.
    RESERVED,            // yellow color, user selected seat to book the same
    DISABLED            // this is used for the seats which are not for internet booking
} SeatStatus;


@interface SeatLayoutVO : NSObject

@property (nonatomic, assign) int                       maxBooking;
@property (nonatomic, assign) float                     bookingFees;
@property (nonatomic, retain) NSString                  *screenURL;
@property (nonatomic, retain) NSMutableArray            *bookingClassesArr;
@end

@interface BookingClassVO : NSObject

@property (nonatomic, retain) NSString                  *classId;
@property (nonatomic, retain) NSString                  *className;
@property (nonatomic, assign) float                     cost;
@property (nonatomic, assign) int                       noOfRows;
@property (nonatomic, retain) NSMutableArray            *bookingRowsArr;
@property (nonatomic, assign) CGRect                    classFrame;

@end


@interface BookingRowVO : NSObject

@property (nonatomic, retain) BookingClassVO            *bookingClassVO;
@property (nonatomic, retain) NSString                  *rowName;
@property (nonatomic, assign) int                       totalSeats;
@property (nonatomic, assign) int                       availableSeatsCount;
@property (nonatomic, assign) BOOL                      isFamily;
@property (nonatomic, assign) int                       noOfGangwaySeats;
@property (nonatomic, retain) NSMutableArray            *seatsArr;
@property (nonatomic, assign) CGRect                    rowFrame;
@property (nonatomic, assign) BOOL                      isInitialGangway;
@property (nonatomic, assign) int                       isInitialGangwayCount;

@end


@interface BookingSeatVO : NSObject

@property (nonatomic, retain) BookingRowVO              *bookingRowVO;
@property (nonatomic, retain) NSString                  *seatNumber;
@property (nonatomic, assign) SeatStatus                seatStatus;
@property (nonatomic, assign) BOOL                      isNextGangway;
@property (nonatomic, assign) int                       gangwayCount;
@property (nonatomic, assign) CGRect                    seatFrame;
@property (nonatomic, assign) BOOL                      isFamilyRow;


@end