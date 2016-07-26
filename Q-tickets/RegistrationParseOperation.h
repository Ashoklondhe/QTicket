//
//  RegistrationParseOperation.h
//  SMSCountry
//
//  Created by Tejasree on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CommonParseOperation.h"
#import "UserVO.h"


@interface RegistrationParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    NSMutableDictionary     *registerDictionary;
  
    UserVO                  *userVO;
}

@property (nonatomic, retain) NSMutableDictionary *registerDictionary;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;


@end
