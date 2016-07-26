//
//  BlockSeatParseOpeartion.h
//  QTickets
//
//  Created by Shiva Kumar on 28/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonParseOperation.h"
#import "SeatConfirmationVO.h"

@interface BlockSeatParseOpeartion : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    NSDictionary            *bkngSeatDictionary;
    
}
@property (nonatomic,retain) NSDictionary         *bkngSeatDictionary;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;

@property (nonatomic,retain) SeatConfirmationVO   *seatCnfmtn;


@end
