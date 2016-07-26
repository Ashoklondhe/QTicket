//
//  ForgotPasswordParseOperation.h
//  QTickets
//
//  Created by Tejasree on 05/05/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonParseOperation.h"

@interface ForgotPasswordParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    NSMutableDictionary     *forgotPwdDictionary;
    
    
}


@property (nonatomic, retain) NSMutableDictionary *forgotPwdDictionary;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;



@end
