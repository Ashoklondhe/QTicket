//
//  TicketConfirmViewController.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 24/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BookingViewController.h"

@interface TicketConfirmViewController : UIViewController

@property (nonatomic, retain) SeatSelection         *currentSelec;
@property (nonatomic, retain) NSString              *strEventOrderID;
@property (nonatomic, retain) NSString              *noofEventTickets;
@property (nonatomic, retain) NSString              *strTicketNumbers;
@end
