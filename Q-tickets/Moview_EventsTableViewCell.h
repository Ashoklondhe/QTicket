//
//  Moview_EventsTableViewCell.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "MovieVO.h"
#import "MarqueeLabel.h"


@interface Moview_EventsTableViewCell : UITableViewCell


@property (retain, nonatomic) IBOutlet EGOImageView *imgviewofPicture;
@property (weak, nonatomic)   IBOutlet UIImageView *imgviewofBackground;
@property (weak, nonatomic)   IBOutlet MarqueeLabel *lblofPicName;
@property (weak, nonatomic)   IBOutlet UILabel *lblofPicDesc;
@property (weak, nonatomic)   IBOutlet UIButton *btnofBooknow;


@property (nonatomic,retain)  MovieVO   *movieVO;






@end
