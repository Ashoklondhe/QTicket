//
//  ShowTimesCustomCell.h
//  QTickets
//
//  Created by Tejasree on 11/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieVO.h"
#import "ShowTimeView.h"

@protocol ShowDateCustomCellDelegate

- (void) showDateSelected:(ShowTimeVO *)showtimeVO atIndexPath:(NSIndexPath *)indexPath;

@end
@interface ShowTimesCustomCell : UITableViewCell<ShowDateViewDelegate> {
    
}

@property (nonatomic, assign) id<ShowDateCustomCellDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *datesArr;


- (void) createShowTimes:(int)horizontalRows andVerticalRows:(int)verticalRows;

@end
