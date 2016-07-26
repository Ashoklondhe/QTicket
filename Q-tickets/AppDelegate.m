//
//  AppDelegate.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "AppDelegate.h"
#import "Q-ticketsConstants.h"
#import "SMSCountryUtils.h"
#import "HomeViewController.h"
#import "SMSCountryLocalDB.h"
#import "QticketsSingleton.h"
#import "SMSCountryUtils.h"
#import "SplashLoaderViewController.h"
#import "EGOCache.h"
#import "EGOImageLoader.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "DescriptionViewController.h"
#import "EventDescriptionViewController.h"


#define FACEBOOK_CLIENT_ID [NSString stringWithFormat:@"fb%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"1650959221799616"]]


@interface AppDelegate ()
{
    NSString *dateString;
    NSDate *currDate;
    NSDateFormatter *dateFormatter;
    UINavigationController *navigationController;
    SMSCountryUtils *scUtilits;
    
    
    
    
    
    
    
}
@end

@implementation AppDelegate
@synthesize timeatForeground,selectedMovie,dictforData,selectedEvent,selectedStoryboard,strUserEmailis,strnoofEventTickets,strEventTicketNum,strEventDateasPerCate,arrofMovieSearchRes,arofEventSearchRes,fromMYPR,inTandC,strDeviceToken,pushIdIs,pushType,strTheaterNameis,strSelectedActivityforEvent;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.dictforData  = [[NSMutableDictionary alloc]init];
    self.arrofMovieSearchRes = [[NSMutableArray alloc] init];
    self.arofEventSearchRes = [[NSMutableArray alloc] init];
    
//    [EGOCache.currentCache clearCache];
    
    [self createEditableCopyOfDatabaseIfNeeded];
    [SMSCountryLocalDB openDatabase];

    QticketsSingleton *singleTon = [QticketsSingleton sharedInstance];
    singleTon.cureentLoginUser   =[SMSCountryLocalDB getLoggedInUser];
    singleTon.nooflocalNotifications = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    NSString *strStoryBoardis;
    
    if ([SMSCountryUtils isIphone]) {
        
        strStoryBoardis= @"Main";
    }
    else{
        
        strStoryBoardis = @"Main_iPad";
    }
    
    
    
    self.selectedStoryboard = [UIStoryboard storyboardWithName:strStoryBoardis
                                                             bundle: [NSBundle mainBundle]];
    
    SplashLoaderViewController *splashView = (SplashLoaderViewController *)[self.selectedStoryboard instantiateViewControllerWithIdentifier: @"SplashLoaderViewController"];
       navigationController = [[UINavigationController alloc] initWithRootViewController:splashView];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:navigationController];
    [self.window setBackgroundColor:[UIColor clearColor]];
    [self.window makeKeyAndVisible];

    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else // iOS 7 or earlier
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (localNotif) {

        
        NSLog(@"Recieved Notification %@",localNotif );
        
      
        if([[localNotif valueForKey:@"id"] intValue] != 0)
            {
                self.pushType = [NSString stringWithFormat:@"%@",[localNotif valueForKey:@"type"]];
                
                self.pushIdIs = [NSString stringWithFormat:@"%@",[localNotif valueForKey:@"id"]];
            }
        
        else{
            
            self.pushIdIs = 0;
        }
        NSLog(@"app is not opened -------00000000000");
        int k = 99;
        [USERDEFAULTS setInteger:k forKey:@"PushRec"];
        USERDEFAULTSAVE;


//        [self actionforPush];

        
    }

    [UIApplication sharedApplication].applicationIconBadgeNumber=-1;
    
    
        

    return YES;
    
}










- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
//    NSLog(@"Recieved Notification %@",notif.userInfo);
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notification!" message:notif.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert setTag:15];
    [alert show];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=-1;

    
}



- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    
    self.strDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    self.strDeviceToken = [self.strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", self.strDeviceToken);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
//    NSString * alertMsg    =   (NSString *)[[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
    NSDictionary *dicofPush = [[NSDictionary alloc] initWithDictionary:[userInfo valueForKey:@"aps"]];
    
    NSLog(@"push msg is :%@",userInfo);
    
    
    if ([[userInfo allKeys]containsObject:@"type"] || [[userInfo allKeys]containsObject:@"id"]) {
        
        if([[userInfo objectForKey:@"id"] intValue] != 0)
        {
         self.pushType = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type"]];
        
        self.pushIdIs = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
        }
    }
    else{
        
        self.pushIdIs = 0;
    }
    
    
        
    
    if (application.applicationState == UIApplicationStateActive ) {
        
        NSLog(@"active state.......0987654123.");
        
        
        if (self.pushIdIs == 0) {
            
            UIAlertView *alertofdes = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[dicofPush objectForKey:@"alert"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertofdes show];

        }
        else{
        
        UIAlertView *alertof = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[dicofPush objectForKey:@"alert"]] delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Open", nil];
        [alertof setTag:99];
        [alertof show];
        }
//         [self actionforPush];
        
        
    }
    else if (application.applicationState == UIApplicationStateInactive){
        
        
        NSLog(@"InACtive state.......0987654123.");

        [self actionforPush];
        
    }
    else if (application.applicationState == UIApplicationStateBackground){
        
          NSLog(@"Background... 0987654321");
        
         [self actionforPush];
        //go to bucket list
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 99) {
        
        
        if (buttonIndex == 1) {
            
            NSLog(@"need to go for description of it");
            
               [scUtilits showLoaderWithTitle:@"" andSubTitle:LOGIN_CONSTANT];
            
            
            
            //add notification to remove timer
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushClicked" object:nil];
                       
            
            
//            [self actionforPush];
        }
            
        }
}


-(void)actionforPush{
    
    if (self.pushIdIs != 0) {
        
        
        
        if ([self.pushType isEqualToString:@"0"]) {
            
            
            //its movie
            
            
            NSMutableArray *moviesArris = [[NSMutableArray alloc] initWithArray:[self.dictforData objectForKey:@"MoviesData"]];
            
            
            if (moviesArris.count > 0) {
                
                
                for (int k= 0 ; k< moviesArris.count; k++) {
                    
                    MovieVO *pushMovieIs = [moviesArris objectAtIndex:k];
                    
                    if ([pushMovieIs.serverId isEqualToString:self.pushIdIs]) {
                        
                        NSLog(@"movie is :%@",pushMovieIs);
                        
                        self.selectedMovie = pushMovieIs;
                        
                
                
                
                
                //navigate to movie description
                
                DescriptionViewController *movieDescVC  = [self.selectedStoryboard instantiateViewControllerWithIdentifier:@"DescriptionViewController"];
                self.strTheaterNameis = @"Cinemas";
                [navigationController pushViewController:movieDescVC animated:YES];
                
                    }
                }

            }
            
            
        }
        
        
        
        
        
        else{
            
            
            //its an event
            
            
            NSMutableArray *eventsArris = [[NSMutableArray alloc] initWithArray:[self.dictforData objectForKey:@"EventsData"]];
            
            
            if (eventsArris.count > 0) {
                
                
                for (int j=0; j<eventsArris.count; j++) {
                    
                    EventsVO *eventVo = [eventsArris objectAtIndex:j];
                    
                    if ([eventVo.serverId isEqualToString:self.pushIdIs]) {
                        
                        self.selectedEvent = eventVo;
                
//                [scUtilits hideLoader];

                
                //navigate to event Desc
                EventDescriptionViewController *eventDescVC = [self.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventDescriptionViewController"];
                [navigationController pushViewController:eventDescVC animated:YES];
                        
                    }
                    
                }
            }
            
        }
        
    }
    
    [scUtilits hideLoader];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSDate *bgDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:bgDate forKey:@"background"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    NSDate *fgDate = [NSDate date];
    NSDate *bgDate =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"background"];
   
    if (bgDate==nil)
    {
    }
    else
    {
       
        timeatForeground = [fgDate timeIntervalSinceDate:bgDate];
       
        QticketsSingleton *sngton = [QticketsSingleton sharedInstance];
        
        NSString *strback = [USERDEFAULTS objectForKey:@"toBackGround"];
        if ([strback isEqualToString:@"fromUD"]) {
            
            sngton.timerforSeatBlock = sngton.timerforSeatBlock + timeatForeground;
            
        }
        else if ([strback isEqualToString:@"fromPY"])
        {
            sngton.timerforPaymentConfirm = sngton.timerforPaymentConfirm - timeatForeground;
            
            
        }
        else if ([strback isEqualToString:@"fromTC"]){
            
            sngton.timerforTicketConfirm = sngton.timerforTicketConfirm - timeatForeground;
        }
        
    }

    
    [UIApplication sharedApplication].applicationIconBadgeNumber=-1;
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [SMSCountryLocalDB closeDatabase];

    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "SMSCountrty.Q_tickets" in the application's documents directory.

    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Q_tickets" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL             = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Q_tickets.sqlite"];
    NSError *error              = nil;
    NSString *failureReason     = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict       = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey]             = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



#pragma mark
#pragma mark Sqlite DB Related
#pragma mark
-(void)createEditableCopyOfDatabaseIfNeeded{
    //first test for existence
    
    
    BOOL success;
    
    NSFileManager *filemanager    = [NSFileManager defaultManager];
    
    NSError *error;
    
    NSArray *paths                = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentrydirectory = [paths objectAtIndex:0];
    
    NSString *writableDBpath      = [documentrydirectory stringByAppendingPathComponent:DB_FILE_NAME];
    
    success                       = [filemanager fileExistsAtPath:writableDBpath];
    
    if(success) return;
    
    NSString *defaultDBpath       = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:DB_FILE_NAME];
    success                       = [filemanager copyItemAtPath:defaultDBpath toPath:writableDBpath error:&error];
    
    if(!success)
    {
        NSAssert1(0,@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
//    NSLog(@"copy of datebase  path :%@",defaultDBpath);
    
}




-(void)showActivityIndicator{
    MBProgressHUD * hud = [[MBProgressHUD alloc]initWithView:self.window];
    [hud setLabelText:@"Loading..."];
    [hud show:YES];
    [self.window addSubview:hud];
    
}
-(void)removeActivityIndicator{
    [MBProgressHUD hideHUDForView:self.window animated:YES];
    
    [UIView animateWithDuration:0.33 animations:nil completion:^(BOOL finished) {
        for (UIView * view in self.window.subviews)
        {
            if ([view isKindOfClass:[MBProgressHUD class]])
            {
                [view removeFromSuperview];
                break;
            }
        }
    }];
    
}





@end
