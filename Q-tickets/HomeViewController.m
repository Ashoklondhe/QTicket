//
//  HomeViewController.m
//  Q-Tickets
//
//  Created by SMS_MINIMAC on 12/03/15.
//  Copyright (c) 2015 SMS_MINIMAC. All rights reserved.
//

#import "HomeViewController.h"
#import "Q-ticketsConstants.h"
#import "Movies_EventsViewController.h"
#import "EventsViewController.h"
#import "iCarousel.h"
#import "LoginViewController.h"
#import "MyBookingsViewController.h"
#import "MyProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "MyVouchersViewController.h"
#import "MobileNumVerifyViewController.h"
#import "QticketsSingleton.h"
#import "SMSCountryLocalDB.h"
#import "SMSCountryConnections.h"
#import "SMSCountryUtils.h"
#import "CommonParseOperation.h"
#import "TheatersLocationParseOperation.h"
#import "MoviesListParseOperation.h"
#import "MovieVO.h"
#import "EGOImageView.h"
#import "UINavigationController+Fade.h"
#import "AppDelegate.h"
#import "InitialDataGetting.h"
#import "UINavigationController+MenuNavi.h"
#import "EventsVO.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EventsWebViewController.h"

#define kMoviesURL @"https://m.q-tickets.com/index.aspx"
#define kEventsURL @"https://m.q-tickets.com/events.aspx"

@interface HomeViewController ()<UIGestureRecognizerDelegate>
{

    
    IBOutlet UIView      *homeview;
    BOOL                 mClicked;
    IBOutlet UIImageView *imgviewofHomeBg;
    AppDelegate          *delegateApp;
}

@end

@implementation HomeViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    delegateApp = QTicketsAppDelegate;
    
    
    [self CallforMenu];
    
    
    
    
    //for home image
    
    if (ViewWidth == 320) {
        
        [imgviewofHomeBg setImage:[UIImage imageNamed:@"AppLanding320.png"]];
    }
    else if (ViewWidth == 375){
        
        [imgviewofHomeBg setImage:[UIImage imageNamed:@"AppLanding375.png"]];

    }
    else if (ViewWidth == 414){
        
        [imgviewofHomeBg setImage:[UIImage imageNamed:@"AppLanding414.png"]];

    }
    else if (ViewWidth == 768){
        
        [imgviewofHomeBg setImage:[UIImage imageNamed:@"AppLanding768.png"]];

    }
    

    

    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeClickedHome:)];
    [homeview addGestureRecognizer:swiperight];
    
    
   
    NSInteger kk = [USERDEFAULTS integerForKey:@"PushRec"];
    
    if (kk == 99) {
        
        [delegateApp actionforPush];
        NSLog(@"pusher is this");
    
    }
    

}
-(void)CallforMenu{
    
    mClicked               = NO;
    
    rightMenu              = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    rightMenu.setDelegate = self;
    
    if ([SMSCountryUtils isIphone]) {
        
        [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight-MenutopStripHei)];

    }
    else{
    
    [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+50, MenuWidth+150, ViewHeight-MenutopStripHei+50)];
    }
    
    
    [self.view addSubview:rightMenu.view];

}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    if (mClicked) {
        
        
        [self HideMenu];
    }

   }

-(void)rightSwipeClickedHome:(UISwipeGestureRecognizer *)swipeGes{
    
    
    if (mClicked ) {
        
        [self HideMenu];
        
    }
}


-(IBAction)btnMenuClicked:(id)sender{
    
    if (mClicked == NO) {
        
        [self ShowMenu];
        
    }
    else{
        
      [self HideMenu];
        
    }
    
    
    
}


-(void)ShowMenu{
    
    [rightMenu LoadData];

    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //   [homeview setFrame:CGRectMake(-MenuWidth, MenutopStripHei, ViewWidth, ViewHeight- MenutopStripHei)];
        
        
        if ([SMSCountryUtils isIphone]) {
            
            [rightMenu.view setFrame:CGRectMake(ViewWidth-MenuWidth, MenutopStripHei, MenuWidth, ViewHeight- MenutopStripHei)];
        }
        else{
            
        [rightMenu.view setFrame:CGRectMake(ViewWidth-MenuWidth-150, MenutopStripHei+56, MenuWidth+150, ViewHeight- MenutopStripHei+56)];
        }
        
        
        

    } completion:^(BOOL finished) {
        mClicked = YES;
    }];
    
    
}


#pragma mark MenuView DelegateMethode

-(void)selectedMenuOption:(NSInteger)selectedIndex{
    
    
     [USERDEFAULTS setValue:@"1" forKey:FromHome];
     [USERDEFAULTS setValue:@"0" forKey:FromMyBooings];
     [USERDEFAULTS setValue:@"0" forKey:FromMyProfile];
     [USERDEFAULTS setValue:@"0" forKey:FromChangePwd];
     [USERDEFAULTS setValue:@"0" forKey:FromMyVoucher];
     [USERDEFAULTS setValue:@"0" forKey:FromTicketCancel];
      USERDEFAULTSAVE;
    
    
    
    
   
    if (mClicked == YES) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            if ([SMSCountryUtils isIphone]) {
                
                [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight - MenutopStripHei)];
            }else{
                
                 [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+56, MenuWidth+150, ViewHeight - MenutopStripHei+56)];
            }
            
            //  [homeview setFrame:CGRectMake(0, MenutopStripHei, ViewWidth, ViewHeight - MenutopStripHei)];
            
            
        } completion:^(BOOL finished) {
            mClicked = NO;
        
            
            
            [self.navigationController NavigatetoViewControllerwithSelectedIndex:selectedIndex];
    
          
        }];
         }
         else
         {
             
             [self.navigationController NavigatetoViewControllerwithSelectedIndex:selectedIndex];
             

             
             
         }
    
    
   
}


-(void)HideMenu{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if ([SMSCountryUtils isIphone]) {
            
            
            [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei, MenuWidth, ViewHeight-MenutopStripHei)];
        }
        
        else{
         [rightMenu.view setFrame:CGRectMake(ViewWidth, MenutopStripHei+56, MenuWidth+150, ViewHeight - MenutopStripHei+56)];
        }
        //  [homeview setFrame:CGRectMake(0, MenutopStripHei, ViewWidth, ViewHeight-MenutopStripHei)];
        
        
    } completion:^(BOOL finished) {
        mClicked = NO;
        
       
    }];

}



-(IBAction)btnMoviesClicked:(id)sender
{
    
    
    if (mClicked) {
        [self HideMenu];
        
    }
    else{
        
        [self navigateToMovieWebview];
    }
    
    
}

-(void)navigateToMovieWebview{
    
    EventsWebViewController *eventsWebviewController = [EventsWebViewController initWithTitle:@"Movies" andWebURL:kMoviesURL];
    [self.navigationController pushViewController:eventsWebviewController animated:YES];
    
}

-(void)navigatetoMovieView{
    
    Movies_EventsViewController *movies_events = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"Movies_EventsViewController"];
    [movies_events setFromHomeVc:YES];
    [self.navigationController pushViewController:movies_events animated:YES];
}

-(IBAction)btnEventsClicked:(id)sender
{
    
    if (mClicked) {
        [self HideMenu];
    }
    else {
        
        [self navigatetoEventsWebView];
    }
  
}
-(void)navigatetoEventsView{
    
    
    EventsViewController    *eventsVC  = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventsViewController"];
    [eventsVC setFromHome:YES];
    [self.navigationController pushViewController:eventsVC animated:YES];

}


-(void)navigatetoEventsWebView{
    
    EventsWebViewController *eventsWebviewController = [EventsWebViewController initWithTitle:@"Events" andWebURL:kEventsURL];
    [self.navigationController pushViewController:eventsWebviewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
