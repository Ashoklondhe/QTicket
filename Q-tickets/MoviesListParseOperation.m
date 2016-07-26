//
//  MoviesListParseOperation.m
//  SMSCountry
//
//  Created by Tejasree on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "MoviesListParseOperation.h"
#import "Q-ticketsConstants.h"
#import "SMSCountryUtils.h"
#import "QticketsSingleton.h"



@implementation MoviesListParseOperation
@synthesize status,errorCode,message,scUtils,movieDict,tempMovieArr;

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    outputArr = [[NSMutableArray alloc] init];
    movieDict = [[NSMutableDictionary alloc]init];
    tempMovieArr = [[NSMutableArray alloc]init];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParse];
	[parser setDelegate:self];
    [parser parse];
  
    if (![self isCancelled])
    {
        // notify our delegate that the parsing is complete
        
        if (!self.isErrorOccurred) {
            [self.delegate didFinishParsingWithRequestMessage:requestMessage parsedArray:outputArr];
        }
    }
    
    self.outputArr = nil;
    dataToParse = nil;  // this is a local variable i.e,. we will not use self.
    
    [parser release];
	[pool release];
}

-(void)dealloc
{
    [super dealloc];
}

#pragma mark
#pragma mark NSXMLParser Delegate Methods
#pragma mark


- (void)parserDidStartDocument:(NSXMLParser *)parser {
    status = [[NSMutableString alloc]init];
    errorCode = [[NSMutableString alloc]init];
    message = [[NSMutableString alloc]init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	
    currentElement = [elementName copy];
    if ([currentElement isEqualToString:RESPONSE])
    {
        status = [attributeDict objectForKey:STATUS];
        
       
        
        QticketsSingleton *snglton = [QticketsSingleton sharedInstance];
          snglton.lastModifiedDate=[attributeDict objectForKey:MOVIE_LAST_MODIFIED];
       
        [movieDict setValue:status forKeyPath:STATUS];
    }
    
    if ([currentElement isEqualToString:MOVIE])
    {
        MovieVO  *tmpMovieVO = [[[MovieVO alloc]init]autorelease];
        tmpMovieVO.serverId=[attributeDict objectForKey:MOVIE_ID];
        tmpMovieVO.movieName=[attributeDict objectForKey:MOVIE_NAME];
        tmpMovieVO.releaseDate=[attributeDict objectForKey:MOVIE_RELEASE_DATE];
        tmpMovieVO.thumbnailURL=[attributeDict objectForKey:MOVIE_THUMBNAIL_URL];
        tmpMovieVO.language=[[attributeDict objectForKey:MOVIE_LANGUAGE_ID] uppercaseStringWithLocale:[NSLocale currentLocale]];
        tmpMovieVO.censor=[attributeDict objectForKey:MOVIE_CENSOR];
        tmpMovieVO.duration=[attributeDict objectForKey:MOVIE_DURATION];
        tmpMovieVO.description=[attributeDict objectForKey:MOVIE_DESCRIPTION];
//        tmpMovieVO.colorcode=[attributeDict objectForKey:MOVIE_COLOR_CODE];
//        tmpMovieVO.btncolorcode=[attributeDict objectForKey:MOVIE_BUTTON_COLOR_CODE];
//        tmpMovieVO.bgColorCode = [attributeDict objectForKeyedSubscript:MOVIE_BG_COLOR_CODE];
//        tmpMovieVO.bgBorderColorCode = [attributeDict objectForKeyedSubscript:MOVIE_BG_BORDER_COLOR_CODE];
//        tmpMovieVO.titleColorCode = [attributeDict objectForKeyedSubscript:MOVIE_TITLE_COLOR_CODE];
        tmpMovieVO.strmovieCasting = [attributeDict objectForKey:MOVIE_CASTING_DETAILS];
        tmpMovieVO.strimdbRating   = [attributeDict objectForKeyedSubscript:MOVIE_IMDB_RATING];
        
        if ([attributeDict objectForKey:MOVIE_TYPE]!=nil || ![[attributeDict objectForKey:MOVIE_TYPE ] isEqualToString:@""])
        {
            tmpMovieVO.movieType=[attributeDict objectForKey:MOVIE_TYPE];
        }
        else 
        {
            tmpMovieVO.movieType=NO_NAME;
        }
        tmpMovieVO.strMovieUrlIs = [attributeDict objectForKey:MOVIE_MOVIE_URL];
        tmpMovieVO.strMovieThumurlis = [attributeDict objectForKey:MOVIE_THUMBNAIL_URLIS];
        tmpMovieVO.strMovieBannerurlis = [attributeDict objectForKey:MOVIE_BANNER_URLIS];
        tmpMovieVO.strMovieiPhoneHomeurlis = [attributeDict objectForKey:MOVIE_iPHONEHOME_URLIS];
        tmpMovieVO.strMovieiPadHomeurlis = [attributeDict objectForKey:MOVIE_iPADHOME_URLIS];
        tmpMovieVO.strTrailerUrlIs = [attributeDict objectForKey:MOVIE_TRAILER_URLIS];
        tmpMovieVO.strAgeRestrictRating = [attributeDict objectForKey:MOVIE_AGERESTRICTIONMSG];
        [tempMovieArr addObject:tmpMovieVO];
        
    }
    
    if ([currentElement isEqualToString:THEATRE])
    {
        MovieVO *tmpMovie = (MovieVO *)[tempMovieArr lastObject];
        
        MovieTheatreVO *tmpMovieTheatreVO = [[[MovieTheatreVO alloc]init]autorelease];
        tmpMovieTheatreVO.serverId=[attributeDict objectForKey:THEATRE_ID];
        tmpMovieTheatreVO.theatreName=[attributeDict objectForKey:THEATRE_NAME];
        tmpMovieTheatreVO.logoURL=[attributeDict objectForKey:THEATRE_LOGO];
        tmpMovieTheatreVO.address=[attributeDict objectForKey:THEATRE_ADDRESS];
        tmpMovieTheatreVO.strArabicName = [attributeDict objectForKey:THEATRE_ARADICNAME];
        [tmpMovie.movieTheatresArr addObject:tmpMovieTheatreVO];
    }
    
    if ([currentElement isEqualToString:SHOW_DATE])
    {
        MovieVO *tmpMovieVO = (MovieVO *)[tempMovieArr lastObject];
        MovieTheatreVO *tmpMovieTheatreVO = (MovieTheatreVO *)[tmpMovieVO.movieTheatresArr lastObject];

        ShowDateVO *tmpShowDateVO = [[[ShowDateVO alloc]init]autorelease];
        tmpShowDateVO.serverId=[attributeDict objectForKey:SHOW_DATE_ID];
        tmpShowDateVO.showDate=[attributeDict objectForKey:DATE];
        [tmpMovieTheatreVO.showDatesArr addObject:tmpShowDateVO];
        
    }
    
    if ([currentElement isEqualToString:SHOW_TIME])
    {
        MovieVO *tmpMovieVO = (MovieVO *)[tempMovieArr lastObject];
        MovieTheatreVO *tmpMovieTheatreVO = (MovieTheatreVO *)[tmpMovieVO.movieTheatresArr lastObject];
        ShowDateVO *tmpShowDateVO = (ShowDateVO *)[tmpMovieTheatreVO.showDatesArr lastObject];
        
        ShowTimeVO *tmpShowTimeVO = [[[ShowTimeVO alloc]init]autorelease];
        tmpShowTimeVO.serverId=[attributeDict objectForKey:SHOW_TIME_ID];
        tmpShowTimeVO.showTime=[attributeDict objectForKey:TIME];
        tmpShowTimeVO.availableCount=[[attributeDict objectForKey:SHOW_TIME_AVALIABLE] intValue];
        tmpShowTimeVO.totalCount = [[attributeDict objectForKey:SHOW_TIME_TOTALCOUNT] intValue];
        tmpShowTimeVO.showType=[attributeDict objectForKey:SHOW_TIME_TYPE];
        tmpShowTimeVO.isEnable=[attributeDict objectForKey:SHOW_TIME_ENABLE];
        tmpShowTimeVO.screenId=[attributeDict objectForKey:SCREEN_ID];
        tmpShowTimeVO.screenName=[attributeDict objectForKey:SCREEN_NAME];

        [tmpShowDateVO.showTimesArr addObject:tmpShowTimeVO];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:RESPONSE])
    {
        [movieDict setValue:tempMovieArr forKeyPath:MOVIES];
        [outputArr addObject:movieDict];
    }

 
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    

}


- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    [self setIsErrorOccurred:YES];
    
    [delegate parseErrorOccurredWithRequestMessage:requestMessage parsingError:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

@end
