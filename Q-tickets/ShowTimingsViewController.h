//
//  ShowTimingsViewController.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 14/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
@interface ShowTimingsViewController : UIViewController<MenuViewControllerDelegate>
{
    MenuViewController *rightMenu;

}


@property (nonatomic, assign) NSInteger              selectedDateIndex;
@property (nonatomic,retain)  NSMutableArray         *datesArr;
@property (nonatomic,retain)  NSString               *selectedTheater;



@end
