//
//  UserBookingParseOperation.m
//  SMSCountry
//
//  Created by Tejasree on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "UserBookingParseOperation.h"
#import "Q-ticketsConstants.h"
#import "SMSCountryUtils.h"

@implementation UserBookingParseOperation
@synthesize status,errorCode,message,bookngHistVO;

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    outputArr = [[NSMutableArray alloc] init];
   
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

#pragma mark
#pragma mark NSXMLParser Delegate Methods
#pragma mark


- (void)parserDidStartDocument:(NSXMLParser *)parser {
    status = [[NSMutableString alloc]init];
    errorCode = [[NSMutableString alloc]init];
    message = [[NSMutableString alloc]init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:RESPONSE]) {
        status = [attributeDict objectForKey:STATUS];
        errorCode = [attributeDict objectForKey:ERRORCODE];
        message = [attributeDict objectForKey:ERROR_MESSAGE];
        
    }
    
    if ([currentElement isEqualToString:BOOKING_HISTORY])
    {
        bookngHistVO = [[BookingHistoryVO alloc]init];
        bookngHistVO.serverId=[attributeDict objectForKey:BOOKING_HISTORY_ID];
        bookngHistVO.movieName=[attributeDict objectForKey:BOOKING_HISTORY_MOVIE];
        bookngHistVO.theatreName=[attributeDict objectForKey:BOOKING_HISTORY_THEATRE];
        bookngHistVO.address=[attributeDict objectForKey:BOOKING_HISTORY_AREA];
        bookngHistVO.bookedTime=[attributeDict objectForKey:BOOKING_HISTORY_BOOKEDTIME];
        bookngHistVO.showDate=[attributeDict objectForKey:BOOKING_HISTORY_SHOWDATE];
        bookngHistVO.seatsSelected=[attributeDict objectForKey:BOOKING_HISTORY_SEATS];
        bookngHistVO.seatsCount=[[attributeDict objectForKey:BOOKING_HISTORY_SEATSCOUNT] intValue];
        bookngHistVO.reservationCode=[attributeDict objectForKey:BOOKING_HISTORY_CONFIRMATION_CODE];
        bookngHistVO.barCodeURL=[attributeDict objectForKey:BOOKING_HISTORY_BARCODEURL];
        bookngHistVO.ticketCost=[[attributeDict objectForKey:BOOKING_HISTORY_TICKET_COST] floatValue];
        bookngHistVO.bookingFees=[[attributeDict objectForKey:BOOKING_HISTORY_BOOKINGFEES] floatValue];
          bookngHistVO.totalCost=[[attributeDict objectForKey:BOOKING_HISTORY_TOTALCOST] floatValue];
        bookngHistVO.movieThumbnail=[attributeDict objectForKey:BOOKING_HISTORY_THUMBNAIL];
        bookngHistVO.movieServerID=[attributeDict objectForKey:BOOKING_HISTORY_MOVIEID];
        bookngHistVO.strBookingStatus = [attributeDict objectForKey:BOOKING_HISTORY_CHECKCANCELSTATUS];
        bookngHistVO.streMovieBannerurlis = [attributeDict objectForKey:BOOKING_HISTRORY_BANNERURL];
        [outputArr addObject:bookngHistVO];
        [bookngHistVO release];
    }
    
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
  
    
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
