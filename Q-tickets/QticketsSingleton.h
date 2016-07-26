//
//  QticketsSingleton.h
//  QTickets
//
//  Created by Tejasree on 22/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserVO.h"
#import "SeatConfirmationVO.h"
#import "LoginViewController.h"
#import "UserDetailsViewController.h"
#import "MobileNumVerifyViewController.h"
#import "BookingViewController.h"

@interface QticketsSingleton : NSObject

@property(nonatomic,retain)LoginViewController         *loginVC;
@property(nonatomic,retain)UserDetailsViewController   *logintoBuyVC;
@property(nonatomic,retain)UserVO                      *cureentLoginUser;
@property(nonatomic,retain)SeatConfirmationVO          *seatCnfmtn;
@property(nonatomic,retain)MobileNumVerifyViewController  *verifyVC;
@property(nonatomic,retain) NSString                   *lastModifiedDate;
@property(nonatomic,retain)SeatSelection               *curselection;
@property(nonatomic,assign)int                          transactiontimerCount;
@property(nonatomic,assign)BOOL                         isTermsAndConditions;
@property(nonatomic,assign)BOOL                         isMovieSelected;
@property(nonatomic,retain)NSMutableArray                *arrofTermsAndConditions;
@property(nonatomic,retain)NSMutableArray                *arrofCountryDetails;
@property(nonatomic,assign) int                          selectedBankis;
@property(nonatomic,assign) int                          EventtransactiontimerCount;
@property(nonatomic,assign) int                          nooflocalNotifications;


//for seats blocking
@property(nonatomic,assign) int                         timerforSeatBlock;
@property(nonatomic,assign) int                         timerforPaymentConfirm;
@property(nonatomic,assign) int                         timerforTicketConfirm;

+ (QticketsSingleton*) sharedInstance;


@end
