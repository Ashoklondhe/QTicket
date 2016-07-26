//
//  MyBookingsTableViewCell.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "MarqueeLabel.h"

@interface MyBookingsTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet EGOImageView *imgofMovie;
@property (weak, nonatomic) IBOutlet MarqueeLabel *lblnameofMovie;
@property (weak, nonatomic) IBOutlet UILabel *lblplaceofMovie;
@property (weak, nonatomic) IBOutlet UILabel *lbldateofMovie;
@property (weak, nonatomic) IBOutlet UILabel *lblnumberofseats;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblamountofMovie;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmationCode;

@end
