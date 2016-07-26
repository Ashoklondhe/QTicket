//
//  QticketsSingleton.m
//  QTickets
//
//  Created by Tejasree on 22/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "QticketsSingleton.h"

@implementation QticketsSingleton

@synthesize loginVC,logintoBuyVC,cureentLoginUser,seatCnfmtn,verifyVC,lastModifiedDate,curselection,transactiontimerCount,isTermsAndConditions,isMovieSelected,arrofTermsAndConditions,arrofCountryDetails,selectedBankis,EventtransactiontimerCount,timerforSeatBlock,timerforPaymentConfirm,timerforTicketConfirm;

static  QticketsSingleton *sharedInstance = nil;


+ (QticketsSingleton*) sharedInstance
{
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[QticketsSingleton alloc] init];
    });
    
    return sharedInstance;
}


@end
