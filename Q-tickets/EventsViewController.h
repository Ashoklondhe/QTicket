//
//  EventsViewController.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 01/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface EventsViewController : UIViewController<MenuViewControllerDelegate>
{
    
    MenuViewController *rightMenu;
    
}


@property (nonatomic,retain) NSMutableDictionary *dictofPassedData;
@property (nonatomic,assign) BOOL fromMovies;
@property (nonatomic,assign) BOOL fromHome;


@end
