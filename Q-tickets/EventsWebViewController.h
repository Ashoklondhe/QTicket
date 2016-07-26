//
//  EventsWebViewController.h
//  Q-tickets
//
//  Created by Shivam Mishra on 17/06/16.
//  Copyright © 2016 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsWebViewController : UIViewController

@property (nonatomic,strong) NSString* urlStr;
@property (nonatomic,strong) NSString* ScreenTitle;
@property (weak, nonatomic) IBOutlet UIView *navigationView;

@property (weak, nonatomic) IBOutlet UIWebView *eventWebView;
+ (EventsWebViewController *)initWithTitle:(NSString *)title andWebURL:(NSString *)urlString ;
@end
