//
//  VoucherTableViewCell.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblofVoucherValue;

@property (weak, nonatomic) IBOutlet UILabel *lblofVoucherAmount;

@property (weak, nonatomic) IBOutlet UIButton *btnVoucherCheckmark;

@end
