//
//  UserVO.m
//  SMSCountry
//
//  Created by Lakshmikanth on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "UserVO.h"

@implementation UserVO

@synthesize localUserId,serverId,userName,phoneNumber,address,emailId,password,bookingHistoryArr,status,prefix;

@end

@implementation BookingHistoryVO

@synthesize localBookingId,serverId,movieName,theatreName,address,bookedTime,showDate,seatsSelected,seatsCount,status,reservationCode,barCodeURL,ticketCost,bookingFees,movieThumbnail,movieServerID,cellThumbnailImg,colorStr,totalCost,strBookingStatus,streMovieBannerurlis;


@end


@implementation UserVoucherVO

@synthesize localVoucherId,serverId,voucherCoupon,voucherValue,vocuhergenerationDate,voucherBalanceValue,voucherexpireDate,voucherStatus,status;


@end