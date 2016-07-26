//
//  BlockSeatParseOpeartion.m
//  QTickets
//
//  Created by Shiva Kumar on 28/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "BlockSeatParseOpeartion.h"
#import "Q-ticketsConstants.h"

@implementation BlockSeatParseOpeartion

@synthesize status,errorCode,message,seatCnfmtn,bkngSeatDictionary;

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    outputArr = [[NSMutableArray alloc] init];
    bkngSeatDictionary=[[NSMutableDictionary alloc]init];
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
    
    
    
    if ([currentElement isEqualToString:RESULT])
    {
        status = [attributeDict objectForKey:STATUS];
        [bkngSeatDictionary setValue:status forKey:STATUS];
        errorCode = [attributeDict objectForKey:ERRORCODE];
        [bkngSeatDictionary setValue:errorCode forKey:ERRORCODE];
        message = [attributeDict objectForKey:ERROR_MESSAGE];
        [bkngSeatDictionary setValue:message forKey:ERROR_MESSAGE];
        seatCnfmtn=[[SeatConfirmationVO alloc]init];
        if ([attributeDict objectForKey:BLOCK_SEATS_TRANSACTION_ID])
        {
            seatCnfmtn.transactionID=[attributeDict objectForKey:BLOCK_SEATS_TRANSACTION_ID];
        }
        if ([attributeDict objectForKey:BLOCK_SEATS_PAGE_SEESION_TIME])
        {
            seatCnfmtn.pageSessionTime=[attributeDict objectForKey:BLOCK_SEATS_PAGE_SEESION_TIME];
        }
        if ([attributeDict objectForKey:BLOCK_SEATS_TRANSACTION_TIME])
        {
            seatCnfmtn.transactionTime=[attributeDict objectForKey:BLOCK_SEATS_TRANSACTION_TIME];
        }
        
        if ([attributeDict objectForKey:BLOCK_SEATS_TICKET_PRICE])
        {
            seatCnfmtn.ticketprice=[[attributeDict objectForKey:BLOCK_SEATS_TICKET_PRICE] floatValue];
            
        }
        if ([attributeDict objectForKey:BLOCK_SEATS_SERVICE_CHARGES])
        {
            seatCnfmtn.serviceCharges=[[attributeDict objectForKey:BLOCK_SEATS_SERVICE_CHARGES] floatValue];
            
        }
        if ([attributeDict objectForKey:BLOCK_SEATS_TOTAL_PRICE])
        {
            seatCnfmtn.totalPrice=[[attributeDict objectForKey:BLOCK_SEATS_TOTAL_PRICE] floatValue];
        }
        
        if ([attributeDict objectForKey:BLOCK_SEATS_CURRENCY])
        {
            seatCnfmtn.currency=[attributeDict objectForKey:BLOCK_SEATS_CURRENCY];
        }
    
        if (seatCnfmtn!=nil)
        {
            [bkngSeatDictionary setValue:seatCnfmtn forKey:BLOCK_SEAT];
            
        }
        
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
 
    if ([elementName isEqualToString:RESPONSE])
    {
        [outputArr addObject:bkngSeatDictionary];
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
