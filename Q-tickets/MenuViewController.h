//
//  MenuViewController.h
//  Q-Tickets
//
//  Created by SMS_MINIMAC on 12/03/15.
//  Copyright (c) 2015 SMS_MINIMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate;


@interface MenuViewController : UIViewController
{
    id<MenuViewControllerDelegate> setDelegate;
    
}

@property (nonatomic,retain) id<MenuViewControllerDelegate> setDelegate;


-(void)LoadData;


@end


@protocol MenuViewControllerDelegate <NSObject>

-(void)selectedMenuOption:(NSInteger)selectedIndex;

@end


