//
//  MobileNumVerifyViewController.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 19/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileNumVerifyViewController : UIViewController



@property (nonatomic, retain) NSString                      *phoneNumber;
@property (nonatomic, retain) NSString                      *phnePrefix;
@property (nonatomic, retain) NSString                      *userServerID;
@property (nonatomic, assign) BOOL                          isVerify;
@property (nonatomic, assign) BOOL                          isfromRegistation;





@end
