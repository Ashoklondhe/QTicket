//
//  Movies_EventsViewController.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"


@interface Movies_EventsViewController : UIViewController<MenuViewControllerDelegate>{
    
    MenuViewController *rightMenu;
    
}


@property (nonatomic,retain) NSMutableDictionary *dictofPassedData;

@property (nonatomic,assign) BOOL fromEvents;
@property (nonatomic,assign) BOOL fromHomeVc;



@end
