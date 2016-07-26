//
//  SeatConfirmationVO.h
//  QTickets
//
//  Created by Shiva Kumar on 29/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeatConfirmationVO : NSObject

@property(nonatomic,retain)NSString         *transactionID;
@property(nonatomic,retain)NSString         *pageSessionTime;
@property(nonatomic,retain)NSString         *transactionTime;
@property(nonatomic,assign)float            ticketprice;
@property(nonatomic,assign)float            serviceCharges;
@property(nonatomic,assign)float            totalPrice;
@property(nonatomic,retain)NSString         *currency;

@end
