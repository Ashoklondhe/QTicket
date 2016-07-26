//
//  AppDelegate.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MovieVO.h"
#import "EventsVO.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,assign)            int timeatForeground;
@property (nonatomic,retain)            MovieVO *selectedMovie;
@property (nonatomic,retain)            EventsVO *selectedEvent;
@property (nonatomic,retain)            NSMutableDictionary *dictforData;
@property (nonatomic,retain)            UIStoryboard *selectedStoryboard;
@property (nonatomic,retain)            NSString *strUserEmailis;
@property (nonatomic,retain)            NSString *strnoofEventTickets;
@property (nonatomic,retain)            NSString *strEventTicketNum;
@property (nonatomic,retain)            NSString *strEventDateasPerCate;

@property (nonatomic,retain)            NSMutableArray *arrofMovieSearchRes;
@property (nonatomic,retain)            NSMutableArray *arofEventSearchRes;

@property (nonatomic,assign)            BOOL fromMYPR;
@property (nonatomic,assign)            BOOL inTandC;

@property (nonatomic, retain)           NSString *strDeviceToken;

@property (nonatomic, retain)           NSString *pushType;
@property (nonatomic, retain)           NSString *pushIdIs;
@property (nonatomic, retain)           NSString *strTheaterNameis;


@property (nonatomic, retain)           NSString *strSelectedActivityforEvent;



-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;
-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)           showActivityIndicator;
-(void)           removeActivityIndicator;
-(void)           actionforPush;
@end

