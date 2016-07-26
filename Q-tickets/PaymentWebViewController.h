//
//  PaymentWebViewController.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 21/05/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingViewController.h"

@interface PaymentWebViewController : UIViewController
{
    
    
}

@property (nonatomic,assign) int SelectedBankIndexIs;
@property (nonatomic,retain) NSString *strTransactionIdis;
@property (nonatomic,retain) NSString *strNationalityIS;

@property (nonatomic, retain) SeatSelection             *currentSelec;

@end
