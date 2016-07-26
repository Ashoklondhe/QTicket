//
//  PaymentParseOperation.h
//  QTickets
//
//  Created by Shiva Kumar on 28/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonParseOperation.h"

@interface PaymentParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    NSDictionary            *paymentDictionary;
    
}
@property (nonatomic,retain) NSDictionary         *paymentDictionary;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;

@property (retain, nonatomic) NSString            *transactionResponse;


@end
