//
//  UINavigationController+Fade.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 01/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController;
- (void)popFadeViewController;

-(void)pushFlipViewController:(UIViewController *)viewController;
-(void)popFlipViewController;

@end
