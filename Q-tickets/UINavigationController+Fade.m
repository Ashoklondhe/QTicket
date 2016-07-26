//
//  UINavigationController+Fade.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 01/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "UINavigationController+Fade.h"

@implementation UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self pushViewController:viewController animated:NO];
}

- (void)popFadeViewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popViewControllerAnimated:NO];
}

-(void)pushFlipViewController:(UIViewController *)viewController{
    
    UIStoryboard  *storyBoard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
    
    UIViewController *viewC = [storyBoard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@",viewController.restorationIdentifier]];

//    EventsViewController  *eventsView = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsViewController"];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self pushViewController:viewC animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];

    
}
-(void)popFlipViewController{
    
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    completion:nil];
}
@end
