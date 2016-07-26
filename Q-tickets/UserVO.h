//
//  UserVO.h
//  SMSCountry
//
//  Created by Lakshmikanth on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserVO : NSObject

@property (nonatomic, assign) int            localUserId;
@property (nonatomic, retain) NSString       *serverId;
@property (nonatomic, retain) NSString       *userName;
@property (nonatomic, retain) NSString       *prefix;
@property (nonatomic, retain) NSString       *phoneNumber;
@property (nonatomic, retain) NSString       *address;
@property (nonatomic, retain) NSString       *emailId;
@property (nonatomic, retain) NSString       *password;
@property (nonatomic, retain) NSMutableArray *bookingHistoryArr;
@property (nonatomic, retain) NSString       *verify;
@property (nonatomic, assign) int            status;
@property (nonatomic, retain) NSString       *nationality;

@end


@interface BookingHistoryVO : NSObject

@property (nonatomic, assign) int      localBookingId;
@property (nonatomic, retain) NSString *serverId;
@property (nonatomic, retain) NSString *movieName;
@property (nonatomic, retain) NSString *theatreName;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *bookedTime;
@property (nonatomic, retain) NSString *showDate;
@property (nonatomic, retain) NSString *seatsSelected;
@property (nonatomic, assign) int       seatsCount;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *reservationCode;
@property (nonatomic, retain) NSString *barCodeURL;
@property (nonatomic, assign) float     ticketCost;
@property (nonatomic, assign) float     bookingFees;
@property (nonatomic, retain) NSString *movieThumbnail;
@property (nonatomic, retain) NSString *movieServerID;
@property (nonatomic,retain)  UIImage  *cellThumbnailImg;
@property (nonatomic, retain) NSString *colorStr;
@property (nonatomic, assign) float totalCost;
@property (nonatomic, retain) NSString *strBookingStatus;
@property (nonatomic, retain) NSString *streMovieBannerurlis;


@end



@interface UserVoucherVO : NSObject

@property (nonatomic, assign) int localVoucherId;
@property (nonatomic, retain) NSString *serverId;
@property (nonatomic, retain) NSString *voucherValue;
@property (nonatomic, retain) NSString *voucherBalanceValue;
@property (nonatomic, retain) NSString *vocuhergenerationDate;
@property (nonatomic, retain) NSString *voucherexpireDate;
@property (nonatomic, retain) NSString *voucherCoupon;
@property (nonatomic, retain) NSString *voucherStatus;
@property (nonatomic, retain) NSString *status;


@end