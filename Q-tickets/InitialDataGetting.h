//
//  InitialDataGetting.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 06/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSCountryUtils.h"
#import "SMSCountryConnections.h"
#import "SMSCountryLocalDB.h"
#import "Q-ticketsConstants.h"
#import "CommonParseOperation.h"
#import "TheatersLocationParseOperation.h"
#import "MoviesListParseOperation.h"
#import "EventCategoriesParseOperation.h"
#import "MovieVO.h"
#import "AppDelegate.h"


@protocol InitialDataGetting <NSObject>

-(void)dataSuccessfullyRetrieved;

@end



@interface InitialDataGetting : NSObject<SMSCountryConnectionDelegate,CommonParseOperationDelegate>

{
    
    NSMutableArray       *connectionsArray;
    NSOperationQueue     *operationQueue;
    NSMutableArray       *operationsArray;
    NSMutableArray       *parsersArray;
    NSMutableArray       *moviesArray;
    NSMutableArray       *theaterLocationsArray;
    SMSCountryUtils      *scUtils;
    NSMutableArray       *eventVenuesArray;
    NSMutableArray       *eventsArray;
    NSMutableArray       *arrofMovies;
    AppDelegate          *delegateApp;


}
 
//to get theater data
-(void)getAllContentData;







@end
