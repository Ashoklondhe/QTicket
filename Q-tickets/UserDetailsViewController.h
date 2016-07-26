//
//  UserDetailsViewController.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingViewController.h"


@interface UserDetailsViewController : UIViewController


@property (nonatomic, retain) SeatSelection             *currentSelec;

//for Events
@property (nonatomic,retain) NSMutableDictionary *dictofEvebntData;



@end
