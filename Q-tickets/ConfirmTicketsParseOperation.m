//
//  ConfirmTicketsParseOperation.m
//  QTickets
//
//  Created by Shiva Kumar on 29/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "ConfirmTicketsParseOperation.h"
#import "Q-ticketsConstants.h"

@implementation ConfirmTicketsParseOperation
@synthesize status,errorCode,message,cnfrmDictionary,confirmationCode,confirm,qrImgSRC,isRegistrationNow,registrationMessage,currentSelection;

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    outputArr = [[NSMutableArray alloc] init];
    cnfrmDictionary=[[NSMutableDictionary alloc]init];
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
    confirmationCode=[[NSString alloc]init];
    confirm=[[NSString alloc]init];
    currentSelection=[[SeatSelection alloc]init];
    qrImgSRC=[[NSString alloc]init];
    isRegistrationNow=[[NSString alloc]init];
    registrationMessage=[[NSString alloc]init];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:RESULT])
    {
        status = [attributeDict objectForKey:STATUS];
        [cnfrmDictionary setValue:status forKey:STATUS];
        errorCode = [attributeDict objectForKey:ERRORCODE];
        [cnfrmDictionary setValue:errorCode forKey:ERRORCODE];
        message = [attributeDict objectForKey:ERROR_MESSAGE];
        [cnfrmDictionary setValue:message forKey:ERROR_MESSAGE];
        if ([attributeDict objectForKey:CONFIRM_TICKETS_TAG])
        {
        confirm=[attributeDict objectForKey:CONFIRM_TICKETS_TAG];
        [cnfrmDictionary setValue:confirm forKey:CONFIRM_TICKETS_TAG];
        }
        
    
        if ([attributeDict objectForKey:CONFIRM_IMAGE])
        {
            currentSelection.movieThumbnailSrc=[attributeDict objectForKey:CONFIRM_IMAGE];
        }
        if ([attributeDict objectForKey:CONFIRM_QR_IMAGE])
        {
            qrImgSRC = [attributeDict objectForKey:CONFIRM_QR_IMAGE];
            [cnfrmDictionary setValue:qrImgSRC forKey:CONFIRM_QR_IMAGE];
            
        }
        if ([attributeDict objectForKey:CONFIRM_MOVIE_NAME])
        {
            currentSelection.movieName=[attributeDict objectForKey:CONFIRM_MOVIE_NAME];
        }
        if ([attributeDict objectForKey:CONFIRM_CINEMA_NAME])
        {
            currentSelection.theaterName=[attributeDict objectForKey:CONFIRM_CINEMA_NAME];
        }
        
        if ([attributeDict objectForKey:CONFIRM_DATE_TIME])
        {
            currentSelection.date=[attributeDict objectForKey:CONFIRM_DATE_TIME];
        }
        
        if ([attributeDict objectForKey:CONFIRM_SEAT_NAME])
        {
            currentSelection.selectedSeatsArr=[attributeDict objectForKey:CONFIRM_SEAT_NAME];
        }
        
        if ([attributeDict objectForKey:CONFIRM_SCREEN_NAME])
        {
            currentSelection.screenName=[attributeDict objectForKey:CONFIRM_SCREEN_NAME];
        }
        
        if ([attributeDict objectForKey:CONFIRM_RESERVATION_CODE])
        {
            confirmationCode =[attributeDict objectForKey:CONFIRM_RESERVATION_CODE];
            [cnfrmDictionary setValue:confirmationCode forKey:CONFIRM_RESERVATION_CODE];
        }
        if ([attributeDict objectForKey:CONFIRM_ISREGISTRATIONNOW])
        {
            isRegistrationNow=[attributeDict objectForKey:CONFIRM_ISREGISTRATIONNOW];
            [cnfrmDictionary setValue:isRegistrationNow forKey:CONFIRM_ISREGISTRATIONNOW];
        }
        if ([attributeDict objectForKey:CONFIRM_REGISTRATIONMESSAGE])
        {
            registrationMessage=[attributeDict objectForKey:CONFIRM_REGISTRATIONMESSAGE];
            [cnfrmDictionary setValue:registrationMessage forKey:CONFIRM_REGISTRATIONMESSAGE];
        }
        if (currentSelection!=nil)
        {
            [cnfrmDictionary setValue:currentSelection forKey:CONFIRM_OBJECT];
            
        }
        
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:RESPONSE])
    {
        [outputArr addObject:cnfrmDictionary];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    
}


- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    [self setIsErrorOccurred:YES];
    
    [delegate parseErrorOccurredWithRequestMessage:requestMessage parsingError:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}






@end
