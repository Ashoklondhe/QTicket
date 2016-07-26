//
//  MyVouchersTableViewCell.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyVouchersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblofvoucherNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblofVoucherValue;
@property (weak, nonatomic) IBOutlet UILabel *lblofVoucherStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblofVoucherBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblofVoucherGeneratedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblofVoucherExpiredDate;
@property (weak, nonatomic) IBOutlet UILabel *lblofVoucherCode;

@end
