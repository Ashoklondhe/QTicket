//
//  CancelRequestParseOpeartion.h
//  QTickets
//
//  Created by Shiva Kumar on 29/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CommonParseOperation.h"

@interface CancelRequestParseOpeartion : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    NSDictionary            *lockDictionary;
    
}
@property (nonatomic,retain) NSDictionary         *lockDictionary;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;


@end
