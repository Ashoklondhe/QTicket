//
//  UINavigationController+MenuNavi.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 08/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "UINavigationController+MenuNavi.h"



#import "LoginViewController.h"
#import "MyBookingsViewController.h"
#import "MyProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "MyVouchersViewController.h"
#import "MobileNumVerifyViewController.h"
#import "Q-ticketsConstants.h"
#import "HomeViewController.h"
#import "TicketCancelViewController.h"
#import "QticketsSingleton.h"
#import "SMSCountryLocalDB.h"
#import "SMSCountryUtils.h"



@implementation UINavigationController (MenuNavi)



-(void)NavigatetoViewControllerwithSelectedIndex:(NSInteger)indexSelected{
    
    LoginViewController *loginVc            = nil;
    MyProfileViewController *myProfile      =  nil;
    MyBookingsViewController *myBookings    =  nil;
    ChangePasswordViewController *changePwd = nil;
    MyVouchersViewController *myVouchers    = nil;
    MobileNumVerifyViewController *mbVC     = nil;
    HomeViewController           *homeVc    = nil;
    TicketCancelViewController  *bookingCan = nil;
    
    AppDelegate                *delegateApp = QTicketsAppDelegate;
    
    
    NSInteger loginVal     = [USERDEFAULTS integerForKey:@"LoginStatus"];
    
    NSInteger fromhomeVal     = [[USERDEFAULTS valueForKey:FromHome] integerValue];
    NSInteger fromMybookinVal = [[USERDEFAULTS valueForKey:FromMyBooings] integerValue];
    NSInteger fromChangePwd   = [[USERDEFAULTS valueForKey:FromChangePwd] integerValue];
    NSInteger fromTicketCan   = [[USERDEFAULTS valueForKey:FromTicketCancel] integerValue];
    NSInteger fromMyProfile   = [[USERDEFAULTS valueForKey:FromMyProfile] integerValue];
    NSInteger fromMyEvouc     = [[USERDEFAULTS valueForKey:FromMyVoucher] integerValue];
    
        switch (indexSelected) {
        case 0:
               
               if( fromhomeVal == 1)
               {
                   break;
                   
               }
               else{
                   
                   homeVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                  [self pushViewController:homeVc animated:NO];
                  break;
            
                 }
        case 1:
            
            if (loginVal != 1) {
                
                loginVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self pushViewController:loginVc animated:YES];
                break;
                
            }
            else{
                if (fromMybookinVal == 1) {
                 
                    break;
                }
                
                else{
                myBookings = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"MyBookingsViewController"];
                [self pushViewController:myBookings animated:YES];
                break;
                }
            }
            
        case 2:
            if (loginVal != 1) {
                
                loginVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self pushViewController:loginVc animated:YES];
                break;
            }
            else{
                if (fromMyProfile == 1) {
                    
                    break;
                }
                else{
                    
                myProfile = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
                [self pushViewController:myProfile animated:YES];
                break;
                }
            }
        case 3:
            if (loginVal != 1) {
                
                loginVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self pushViewController:loginVc animated:YES];
                break;
            }
            else{
                if (fromChangePwd == 1) {
                    
                    break;
                }
                else{
                
                changePwd = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
                [self pushViewController:changePwd animated:YES];
                break;
                }
            }
            
        case 4:
            
            if (loginVal != 1) {
                
                loginVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self pushViewController:loginVc animated:YES];
                break;
            }
            else{
                
                if (fromMyEvouc == 1) {
                    
                    break;
                }
                else{
                
                myVouchers = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"MyVouchersViewController"];
                [self pushViewController:myVouchers animated:YES];
                break;
                }
            }
            
//        case 5:
//                if (fromTicketCan == 1) {
//                    
//                    break;
//                }
//                else{
//                
//                bookingCan = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"TicketCancelViewController"];
//                [bookingCan setStrReservationCode:@""];
//                [self pushViewController:bookingCan animated:YES];
//                break;
//                }
        case 5:
                if (loginVal != 1) {
                    loginVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    [self pushViewController:loginVc animated:YES];
                    break;
                }
                else{
                    
                    SMSCountryUtils *scutilits = [[SMSCountryUtils alloc] init];
                    [scutilits showLoaderWithTitle:Nil andSubTitle:@"Logout Processing..."];
                    NSInteger login = 0;
                    [USERDEFAULTS setInteger:login forKey:@"LoginStatus"];
                    USERDEFAULTSAVE;
                    QticketsSingleton *singleton = [QticketsSingleton sharedInstance];
                    [SMSCountryLocalDB deleteAllUsers];
                    singleton.cureentLoginUser=nil;
                   
                    [self performSelector:@selector(hideLoaderofuser:) withObject:scutilits afterDelay:3];
                    
                    
                    break;
                }
            
        case 6:
                
                if (loginVal != 1) {
                    
                    loginVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    [self pushViewController:loginVc animated:YES];
                    break;
                }
                else{
                    
                    mbVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"MobileNumVerifyViewController"];
                    [self pushViewController:mbVC animated:YES];
                    break;
                }
        default:
            break;
    }    
    
}


-(void)hideLoaderofuser:(SMSCountryUtils *)scutilits{
    
    
    [scutilits hideLoader];

    
}


@end
