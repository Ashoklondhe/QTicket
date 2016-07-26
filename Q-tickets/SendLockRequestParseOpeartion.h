//
//  SendLockRequestParseOpeartion.h
//  QTickets
//
//  Created by Shiva Kumar on 28/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonParseOperation.h"
#import "UserVO.h"

@interface SendLockRequestParseOpeartion : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    NSDictionary            *sendLockDictionary;
    
}
@property (nonatomic,retain)  NSDictionary         *sendLockDictionary;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;

@property (retain, nonatomic) NSString            *timedoutInMin;

@property (retain, nonatomic) NSString            *requestedTimeInSec;

@property (nonatomic, retain) UserVO               *userVO;

@end
