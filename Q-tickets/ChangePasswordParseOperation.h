//
//  ChangePasswordParseOperation.h
//  SMSCountry
//
//  Created by Tejasree on 10/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CommonParseOperation.h"
#import "UserVO.h"

@interface ChangePasswordParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
 
}
@property (nonatomic, retain) UserVO              *userVO;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;

@property (nonatomic, retain) NSMutableDictionary *chngePwdDict;


@end
