//
//  EventTicketConfirmationParseOperation.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 06/05/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "EventTicketConfirmationParseOperation.h"
#import "Q-ticketsConstants.h"

@implementation EventTicketConfirmationParseOperation
@synthesize confirmEventTicket,status,message,errorCode;

- (void)main
{
    
    outputArr          = [[NSMutableArray alloc] init];
    confirmEventTicket = [[NSMutableDictionary alloc] init];
    
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
    
    if ([currentElement isEqualToString:RESPONSE]) {
        
        status = [attributeDict objectForKey:STATUS];
        [confirmEventTicket setObject:status forKey:STATUS];
       
        
        
    }
    if ([currentElement isEqualToString:RESULT]) {
       
        
        if ([[attributeDict allKeys] containsObject:ERRORCODE]) {
            
            [confirmEventTicket setObject:[attributeDict objectForKey:ERRORCODE] forKey:ERRORCODE];
        }
        if ([[attributeDict allKeys] containsObject:ERROR_MESSAGE]) {
            
            [confirmEventTicket setObject:[attributeDict objectForKey:ERROR_MESSAGE] forKey:ERROR_MESSAGE];
        }
       
        if ([[attributeDict allKeys] containsObject:EVENT_TICKET_RESERVATION_CODE]) {
            
            [confirmEventTicket setObject:[attributeDict objectForKey:EVENT_TICKET_RESERVATION_CODE] forKey:EVENT_TICKET_RESERVATION_CODE];
        }
        if ([[attributeDict allKeys] containsObject:EVENT_TICKET_BOOKEDQRCODE_URL]) {
            [confirmEventTicket setObject:[attributeDict objectForKey:EVENT_TICKET_BOOKEDQRCODE_URL] forKey:EVENT_TICKET_BOOKEDQRCODE_URL];
        }
        if ([[attributeDict allKeys] containsObject:EVENT_TICKET_isREGISTERORNOT]) {
            [confirmEventTicket setObject:[attributeDict objectForKey:EVENT_TICKET_isREGISTERORNOT] forKey:EVENT_TICKET_isREGISTERORNOT];
        }
        
        
        [outputArr addObject:confirmEventTicket];
        
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
       
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
