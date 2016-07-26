//
//  EventInfoTableViewCell.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 19/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbltypeofTicketVal;
@property (weak, nonatomic) IBOutlet UILabel *lblpriceofTicketVal;
@property (weak, nonatomic) IBOutlet UIButton *btnNumberofTickets;
@property (nonatomic, retain) IBOutlet UIView *viewforContent;
@property (nonatomic, retain) IBOutlet UIImageView *imgViewofBackground;


@end
