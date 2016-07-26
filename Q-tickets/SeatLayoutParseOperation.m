//
//  SeatLayoutParseOperation.m
//  SMSCountry
//
//  Created by Tejasree on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "SeatLayoutParseOperation.h"
#import "Q-ticketsConstants.h"
#import "SMSCountryUtils.h"

@implementation SeatLayoutParseOperation
@synthesize status,errorCode,message,seatLayoutDictionary;

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    outputArr = [[NSMutableArray alloc] init];
    seatLayoutDictionary = [[NSMutableDictionary alloc]init];
    
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

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:RESPONSE])
    {
        status = [attributeDict objectForKey:STATUS];
        [outputArr addObject:status];
    }
    
    if ([currentElement isEqualToString:THEATER_SEAT_LAYOUT_CLASSES]) {
        
        SeatLayoutVO *tempSeatLayoutVO = [[SeatLayoutVO alloc] init];
        
        tempSeatLayoutVO.maxBooking = [[attributeDict objectForKey:THEATER_SEAT_LAYOUT_CLASSES_MAX_BOOKING] intValue];
        tempSeatLayoutVO.bookingFees = [[attributeDict objectForKey:THEATER_SEAT_LAYOUT_CLASSES_BOOKING_FEES] floatValue];
        tempSeatLayoutVO.screenURL =[attributeDict objectForKey:THEATER_SEAT_LAYOUT_CLASSES_FULL_SCREEN_URL];
        
        [outputArr addObject:tempSeatLayoutVO];
        [tempSeatLayoutVO release];
    }
    
    if ([currentElement isEqualToString:THEATER_SEAT_LAYOUT_CLASS]) {
        
        SeatLayoutVO *bClassesVORef = [outputArr lastObject];
        
        BookingClassVO *bClassVO = [[BookingClassVO alloc] init];
        
        bClassVO.classId = [attributeDict objectForKey:THEATER_SEAT_LAYOUT_CLASS_ID];
        [bClassVO setClassName:[attributeDict objectForKey:THEATER_SEAT_LAYOUT_CLASS_NAME]];
        [bClassVO setCost:[[attributeDict objectForKey:THEATER_SEAT_LAYOUT_CLASS_COST] floatValue]];
        [bClassVO setNoOfRows:[[attributeDict objectForKey:THEATER_SEAT_LAYOUT_CLASS_NO_OF_ROWS] intValue]];
        [bClassesVORef.bookingClassesArr addObject:bClassVO];
        [bClassVO release];
    }

    if ([currentElement isEqualToString:THEATER_SEAT_LAYOUT_ROW]) {
        
        SeatLayoutVO *bClassesVORef = [outputArr lastObject];
        BookingClassVO  *classVORef = [bClassesVORef.bookingClassesArr lastObject];
        
        // creating a new row
        
        BookingRowVO *bRowVO = [[BookingRowVO alloc] init];
        
        [bRowVO setBookingClassVO:classVORef];
        [bRowVO setRowName:[attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_LETTER]];
        [bRowVO setTotalSeats:[[attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_NO_OF_SEATS] intValue]];
        [bRowVO setAvailableSeatsCount:[[attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_AVAILABLE_COUNT] intValue]];
        [bRowVO setNoOfGangwaySeats:[[attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_GANGWAY_COUNTS] intValue]];
        [bRowVO setIsFamily:[[attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_ISFAMILY] boolValue]];
        [bRowVO setIsInitialGangway:[[attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_INITIAL_GANGWAY] boolValue]];
        [bRowVO setIsInitialGangwayCount:[[attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_INITIAL_GANGWAY_COUNT] intValue]];
        
        // get the available seat numbers from the server
        NSString *availableSeatsStr = [attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_AVAILABLE_SEATS];
        
        NSArray *availableSeatsArr=[[[NSArray alloc] init] autorelease];
        
        BOOL isFamilyBookingRow = [[attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_ISFAMILY] boolValue];
        
        
        
        if (availableSeatsStr != nil) {
            availableSeatsArr = [availableSeatsStr componentsSeparatedByString:@","];
        }
    
        
        if (isFamilyBookingRow)
        {
           // NSLog(@"family booking seats");
        }
        
        // get the gangway seat numbers from the server if at all gangway is available
        NSString *gangwaySeatsStr;
        NSArray *gangwaySeatsArr=[[[NSArray alloc]init]autorelease];
        
        // get the gangway count for each and every gangway
        NSString *gangwayCountsStr;
        NSArray *gangwayCountsArr=[[[NSArray alloc]init]autorelease];
        
        if ([[attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_IS_GANGWAY] boolValue]) {
            gangwaySeatsStr = [attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_GANGWAY_SEATS];
            gangwaySeatsArr = [gangwaySeatsStr componentsSeparatedByString:@","];
            [bRowVO setNoOfGangwaySeats:(int)gangwaySeatsArr.count];
            
            gangwayCountsStr = [attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_GANGWAY_COUNTS];
            gangwayCountsArr = [gangwayCountsStr componentsSeparatedByString:@","];
        }
        
        
        NSString *allSeatsStr = [attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_ALL_SEATS];
        
        NSArray *allSeatsArr = [allSeatsStr componentsSeparatedByString:@","];
        
        // create all the seats, by default we set it the status as NOT_AVAILABLE
        for (int i = 0; i < allSeatsArr.count ; i ++) {
            
            NSString *tempSeatLbl = [allSeatsArr objectAtIndex:i];
            
            BookingSeatVO *tempSeatVO = [[BookingSeatVO alloc] init];
            
            [tempSeatVO setBookingRowVO:bRowVO];
            
            [tempSeatVO setSeatNumber:tempSeatLbl];
            
            
            if (availableSeatsArr.count>0)
            {
                for (NSString *availableServerSeat in availableSeatsArr) {
                    
                     [tempSeatVO setSeatStatus:NOT_AVAILABLE];
                    if ([tempSeatVO.seatNumber isEqualToString:availableServerSeat]) {
                        [tempSeatVO setSeatStatus:AVAILABLE];
                        //NSLog(@"seats available:%@",tempSeatVO.seatNumber);
                        break;
                    }
                    
                }
               
            }
       
            if ([[attributeDict objectForKey:THEATER_SEAT_LAYOUT_ROW_IS_GANGWAY] boolValue]) {
                for (int i = 0 ; i < gangwaySeatsArr.count ; i++) {
                    NSString *gangWayServerSeat = [gangwaySeatsArr objectAtIndex:i];
                    if ([tempSeatVO.seatNumber isEqualToString:gangWayServerSeat]) {
                        [tempSeatVO setIsNextGangway:YES];
                        [tempSeatVO setGangwayCount:[[gangwayCountsArr objectAtIndex:i] intValue]];
                        //                        [tempSeatVO setGangWayCount:1];
                       // NSLog(@"gangaway seats:%@",tempSeatVO.seatNumber);
                        break;
                    }
                }
            }
            
            [bRowVO.seatsArr addObject:tempSeatVO];
            [tempSeatVO release];
        }
        
        [classVORef.bookingRowsArr addObject:bRowVO];
        [bRowVO release];
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
