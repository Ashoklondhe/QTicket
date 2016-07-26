//
//  EventsTableViewCell.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 01/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//
#import "MarqueeLabel.h"
#import "EGOImageView.h"
#import <UIKit/UIKit.h>

@interface EventsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet MarqueeLabel *lblNameofEvent;
@property (strong, nonatomic) IBOutlet EGOImageView *imgivewOfEvent;
@property (strong, nonatomic) IBOutlet UIImageView  *imgviewforBackground;
@property (strong, nonatomic) IBOutlet UIImageView  *imgviewforEventBackground;
@property (strong, nonatomic) IBOutlet UILabel *lblDateofEvent;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeofEvent;
@property (strong, nonatomic) IBOutlet UIButton *btnBooknow;
@property (strong, nonatomic) IBOutlet EGOImageView  *imgviewEveType;
@property (strong, nonatomic) IBOutlet EGOImageView  *imgviewEveRestriction;
@property (strong, nonatomic) IBOutlet EGOImageView  *imgviewQTAEvent;
@property (strong, nonatomic) IBOutlet UILabel  *lblFreerPaid;


@end
