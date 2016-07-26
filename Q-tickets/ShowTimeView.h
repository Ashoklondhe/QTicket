//
//  ShowDateView.h
//  TestCustomCellWithButtons
//
//  Created by Laxmikanth Reddy on 28/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieVO.h"
#import "BookingViewController.h"

@protocol ShowDateViewDelegate

- (void)showDateSelected:(ShowTimeVO *)showTimeVO;

@end

@interface ShowTimeView : UIView  {
    
    ShowTimeVO        *showTimeVO;
}

@property (nonatomic, retain) ShowTimeVO      *showTimeVO;
@property (nonatomic, assign) id<ShowDateViewDelegate> showDateCellRef;

- (id)initWithDelegate:(id<ShowDateViewDelegate>)delegate;

@end
