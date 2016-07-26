//
//  UserBookingParseOperation.h
//  SMSCountry
//
//  Created by Tejasree on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CommonParseOperation.h"
#import "UserVO.h"

@interface UserBookingParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    BookingHistoryVO        *bookngHistVO;
    
}

@property (nonatomic, retain) BookingHistoryVO    *bookngHistVO;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;


@end
