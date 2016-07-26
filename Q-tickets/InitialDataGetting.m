//
//  InitialDataGetting.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 06/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "InitialDataGetting.h"
#import "TermsAndConditionsParseOperation.h"
#import "QticketsSingleton.h"
#import "CountriesMobilePrefixesOperationParser.h"
#import "EGOCache.h"
#import "EGOImageLoader.h"
#import "EGOImageView.h"


@implementation InitialDataGetting



//to get theater data
-(void)getAllContentData{
    
    
    connectionsArray       = [[NSMutableArray alloc]init];
    operationsArray        = [[NSMutableArray alloc]init];
    parsersArray           = [[NSMutableArray alloc]init];
    moviesArray            = [[NSMutableArray alloc]init];
    theaterLocationsArray  = [[NSMutableArray alloc]init];
    scUtils                = [[SMSCountryUtils alloc]init];
    eventVenuesArray       = [[NSMutableArray alloc]init];
    delegateApp            = QTicketsAppDelegate;
    eventsArray            = [[NSMutableArray alloc]init];
    
//    if ([SMSCountryUtils netAvailableorNot]) {
    
        SMSCountryConnections  *connections = [[SMSCountryConnections alloc]initWithDelegate:self];
        [connections getAllTheatersLocations];
        [connectionsArray addObject:connections];
        
//    }
//    else{
//        
//        [SMSCountryUtils showAlertMessageWithTitle:@"Alert" Message:@"Network is Not Available" withDelegate:nil withCancelBtn:NO withOkBtn:YES];
//    }
    
}

#pragma mark --- getting all movieslist


-(void)getMoviesByLanguageAndTheaterId{
    
    SMSCountryConnections  *connections = [[SMSCountryConnections alloc]initWithDelegate:self];
    [connections getMoviesByLanguageAndTheaterId];
    [connectionsArray addObject:connections];
}


#pragma mark Handling Evnets data parser data methods

-(void)handleLoadAllEventsList:(NSArray *)parsedArr{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    if (parsedArr.count >0)
    {
        NSMutableDictionary *movieDictionary = [parsedArr objectAtIndex:0];
        
        if ([[movieDictionary valueForKey:STATUS] isEqualToString:@"true"]||[[movieDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            
            [eventsArray addObjectsFromArray:[movieDictionary valueForKey:EVENTS]];
            NSMutableDictionary   *dicReceiceddata    = [[NSMutableDictionary alloc]init];
            [dicReceiceddata setObject:theaterLocationsArray forKey:@"TheatersLocations"];
            [dicReceiceddata setObject:moviesArray forKey:@"MoviesData"];
            [dicReceiceddata setObject:eventVenuesArray forKey:@"EventVenues"];
            [dicReceiceddata setObject:eventsArray forKey:@"EventsData"];
            [delegateApp setDictforData:dicReceiceddata];
            
            
            NSInteger nowCountIs = moviesArray.count;
            
            NSInteger storedCountis = [USERDEFAULTS integerForKey:@"MLostModified"];
            
            if (nowCountIs != storedCountis) {
                
                [EGOCache.currentCache clearCache];
                
            }
            
            NSInteger previousCount = moviesArray.count;
            
            [USERDEFAULTS setInteger:previousCount forKey:@"MLostModified"];
            USERDEFAULTSAVE;

            
            //api call for terms and conditons
            [self getTermsandConditions];
            [connectionsArray removeAllObjects];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyUser" object:nil];
//            [self performSelector:@selector(callforNotify) withObject:nil afterDelay:5];
            
             [scUtils hideLoader];
        }
        else if ([[movieDictionary valueForKey:STATUS] isEqualToString:@"false"]||[[movieDictionary valueForKey:STATUS] isEqualToString:@"False"])
        {
                [scUtils hideLoader];
                [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:ALERT_WARNING_NO_EVENTS_FOUND];
        }
    }
    else
    {
//            [scUtils hideLoader];
//            [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:ALERT_WARNING_NO_EVENTS_FOUND];
    }

}

//-(void)callforNotify{
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyUser" object:nil];
//}


-(void)handleLoadAllEventsError:(NSError *)error{
    
         [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:ALERT_WARNING_NO_EVENTS_FOUND];
    
}

-(void)getTermsandConditions{
    
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn getTermsandConditionsforBooking];
    [connectionsArray addObject:conn];
}


-(void)GetCountryCodesWithMobilePrefixes{
    
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn getCountriesWithMobileNumbers];
    [connectionsArray addObject:conn];
}



#pragma mark Handling Parsed data methods

#pragma  mark ---- theatres list

-(void)handleLoadedTheatresList:(NSArray *)parsedArr
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    //if parsed array count is greater then zero then delete all theaters and insert parsed data in localdb
    if (parsedArr.count>0)
    {
        [SMSCountryLocalDB deleteAllTheatres];
        //adding all to select all theaters
        [theaterLocationsArray addObject:@"ALL"];
        [theaterLocationsArray addObjectsFromArray:parsedArr];
        //making movies service call
        [self getMoviesByLanguageAndTheaterId];
    }
    else
    {   //if parsed count is zero and if data exists in localdb will be displayed
//        [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:ALERT_WARNING_NO_THEATRES_FOUND];
    }
}

- (void) handleTheaterParserError:(NSError *) error
{
    //if error obtains during parsing then data from localdb will be displayed
    
    if ([SMSCountryLocalDB getAllTheatres].count>0)
    {
        //adding all to select all theaters
        [theaterLocationsArray addObject:@"ALL"];
        [theaterLocationsArray addObjectsFromArray:[SMSCountryLocalDB getAllTheatres]];
        //making movies service call
        [self getMoviesByLanguageAndTheaterId];
    }
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:ALERT_WARNING_NO_THEATRES_FOUND];
    }
}
#pragma  mark ---- movies list

- (void) handleLoadedMoviesList:(NSArray *)parsedArr {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    //if parsed array count is greater then zero then delete all movies and insert parsed data in localdb
    
    if (parsedArr.count >0)
    {
        NSMutableDictionary *movieDictionary = [parsedArr objectAtIndex:0];
        
        if ([[movieDictionary valueForKey:STATUS] isEqualToString:@"true"]||[[movieDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            [moviesArray addObjectsFromArray:[movieDictionary valueForKey:MOVIES] ];
            
            //now need to call forther api calls
            //getallevents
            SMSCountryConnections  *connections = [[SMSCountryConnections alloc]initWithDelegate:self];
            [connections getAllEventsByCategory];
            [connectionsArray addObject:connections];
            
        }
        else if ([[movieDictionary valueForKey:STATUS] isEqualToString:@"false"]||[[movieDictionary valueForKey:STATUS] isEqualToString:@"False"])
        {
            
                [scUtils hideLoader];
                [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:ALERT_WARNING_NO_MOVIES_FOUND];
        }
        
    }
    else
    {
//            [scUtils hideLoader];
//            [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:ALERT_WARNING_NO_MOVIES_FOUND];
    }
}

- (void) handleMoviesParserError:(NSError *) error
{
    
        [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:ALERT_WARNING_NO_MOVIES_FOUND];
    
}
#pragma mark --- APIresponse methods
#pragma mark --  sucess

- (void) finishedReceivingData:(NSData*)data withRequestMessage:(NSString *)reqMessage{
    
    if ([reqMessage isEqualToString:GET_ALL_LOCATIONS]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        
        operationQueue = tmpQueue;
        
        TheatersLocationParseOperation *tParser = [[TheatersLocationParseOperation alloc] initWithData:data delegate:self andRequestMessage:GET_ALL_LOCATIONS];
        [operationQueue addOperation:tParser];
        [parsersArray addObject:tParser];
        
        data = nil;
        
    }
    if ([reqMessage isEqualToString:GET_MOVIES_BY_LANG_AND_THEATERID]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        
        operationQueue = tmpQueue;
        
        MoviesListParseOperation   *moviParser  = [[MoviesListParseOperation alloc]initWithData:data delegate:self andRequestMessage:GET_MOVIES_BY_LANG_AND_THEATERID];
        [operationQueue addOperation:moviParser];
        [parsersArray addObject:moviParser];
        
        data = nil;
        
    }
    
    if ([reqMessage isEqualToString:GET_ALL_EVENTSBYCATEGORY]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        
        operationQueue = tmpQueue;
        
        EventCategoriesParseOperation   *eventParser  = [[EventCategoriesParseOperation alloc]initWithData:data delegate:self andRequestMessage:GET_ALL_EVENTSBYCATEGORY];
        [operationQueue addOperation:eventParser];
        [parsersArray addObject:eventParser];
        
        data = nil;
        
    }
    
    if ([reqMessage isEqualToString:GET_TERMS_AND_CONDITIONS]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        operationQueue = tmpQueue;
        TermsAndConditionsParseOperation *tandCParser = [[TermsAndConditionsParseOperation alloc] initWithData:data delegate:self andRequestMessage:GET_TERMS_AND_CONDITIONS];
        [operationQueue addOperation:tandCParser];
        [parsersArray addObject:tandCParser];
        data = nil;
    }

    if ([reqMessage isEqualToString:GET_COUNTRIES_WITHMOBILEPREFIXES]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        operationQueue = tmpQueue;
        CountriesMobilePrefixesOperationParser *tandCParser = [[CountriesMobilePrefixesOperationParser alloc] initWithData:data delegate:self andRequestMessage:GET_COUNTRIES_WITHMOBILEPREFIXES];
        [operationQueue addOperation:tandCParser];
        [parsersArray addObject:tandCParser];
        data = nil;
    }
    

    
    
    
}
- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
    
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:SERVER_NOT_RESPONDING delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

}


#pragma mark -- Parser delegate methods

- (void)didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr {
    
    
    if ([reqMsg isEqualToString:GET_ALL_LOCATIONS]) {
        [self performSelectorOnMainThread:@selector(handleLoadedTheatresList:) withObject:parseArr waitUntilDone:NO];
        operationQueue = nil;   // we are finished with the queue and our ParseOperation
    }
    
    if ([reqMsg isEqualToString:GET_MOVIES_BY_LANG_AND_THEATERID]) {
        [self performSelectorOnMainThread:@selector(handleLoadedMoviesList:) withObject:parseArr waitUntilDone:NO];
        operationQueue = nil;   // we are finished with the queue and our ParseOperation
    }
    if ([reqMsg isEqualToString:GET_ALL_EVENTSBYCATEGORY]) {
        
        [self performSelectorOnMainThread:@selector(handleLoadAllEventsList:) withObject:parseArr waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:GET_TERMS_AND_CONDITIONS]) {
        
        [self performSelectorOnMainThread:@selector(handleTermsandContions:) withObject:parseArr waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:GET_COUNTRIES_WITHMOBILEPREFIXES]) {
        
        [self performSelectorOnMainThread:@selector(handleCountryDetails:) withObject:parseArr waitUntilDone:NO];
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    
    if ([reqMsg isEqualToString:GET_ALL_LOCATIONS]) {
        [self performSelectorOnMainThread:@selector(handleTheaterParserError:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:GET_MOVIES_BY_LANG_AND_THEATERID]) {
        [self performSelectorOnMainThread:@selector(handleMoviesParserError:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:GET_ALL_EVENTSBYCATEGORY]) {
        
        [self performSelectorOnMainThread:@selector(handleLoadAllEventsError:) withObject:error waitUntilDone:NO];
    }
    if ([reqMsg isEqualToString:GET_TERMS_AND_CONDITIONS]) {
        
        [self performSelectorOnMainThread:@selector(handleTermsCondiErrorUserDe:) withObject:error waitUntilDone:NO];
        
    }
    if ([reqMsg isEqualToString:GET_COUNTRIES_WITHMOBILEPREFIXES]) {
        
        [self performSelectorOnMainThread:@selector(handleCountryDetaErrorUserDe:) withObject:error waitUntilDone:NO];
        
    }
    
    operationQueue = nil;
}



-(void)handleCountryDetails:(NSArray *)parsedArr{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    QticketsSingleton *single = [QticketsSingleton sharedInstance];
    
    if([parsedArr count]>0)
    {
        NSMutableDictionary *CountryInfoDictionary = [parsedArr objectAtIndex:0];
        
        if ([[CountryInfoDictionary valueForKey:STATUS] isEqualToString:@"True"] || [[CountryInfoDictionary valueForKey:STATUS] isEqualToString:@"true"])
        {
          
            single.arrofCountryDetails = [[NSMutableArray alloc]initWithArray:[CountryInfoDictionary objectForKey:COUNTRY]];
                       
        }
        else   //Based on error code data will be displayed
        {
            
        }
        
    }
    else{
        
//        [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:@"Country Codes not Available"];

    }

    
    
    
}

-(void)handleCountryDetaErrorUserDe:(NSError *)error{
    
    [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:@"Country Codes not Available"];
}










-(void)handleTermsandContions:(NSArray *)parsedArr{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    QticketsSingleton *single = [QticketsSingleton sharedInstance];
    
    if([parsedArr count]>0)
    {
        NSMutableDictionary *loginDictionary = [parsedArr objectAtIndex:0];
        
        if ([[loginDictionary valueForKey:STATUS] isEqualToString:@"True"] || [[loginDictionary valueForKey:STATUS] isEqualToString:@"true"])
        {
            NSMutableString *strTermsConditiosn = [[NSMutableString alloc] initWithString:[loginDictionary objectForKey:Terms_Conditions]];
            
            single.arrofTermsAndConditions = [[NSMutableArray alloc]initWithArray:[strTermsConditiosn componentsSeparatedByString:@"$"]];
            
            
            [self GetCountryCodesWithMobilePrefixes];
            
            
        }
        else   //Based on error code data will be displayed
        {
            
        }
        
    }
    else{
//        [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:@"Terms and Conditions not Available"];
    }
}




-(void)handleTermsCondiErrorUserDe:(NSError *)error{
    
    [SMSCountryUtils showAlertMessageWithTitle:ALERT_TITLE_WARNING Message:@"Terms and Conditions not Available"];
    
}





@end
