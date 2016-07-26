//
//  EventBlockSeatsParseOperation.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 16/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "EventBlockSeatsParseOperation.h"
#import "Q-ticketsConstants.h"

@implementation EventBlockSeatsParseOperation
@synthesize status,errorCode,message,dictofEvnetsBooking;

- (void)main
{
    outputArr = [[NSMutableArray alloc] init];
    dictofEvnetsBooking = [[NSMutableDictionary alloc] init];
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
//    if ([currentElement isEqualToString:RESPONSE])
//    {
//        status = [attributeDict objectForKey:STATUS];
//        [dictofEvnetsBooking setObject:status forKey:STATUS];
//        
//        
//    }
    
    if ([currentElement isEqualToString:RESULT])
    {
        status = [attributeDict objectForKey:STATUS];
        [dictofEvnetsBooking setObject:status forKey:STATUS];
        
        if ([[attributeDict allKeys] containsObject:EVENT_TICKET_ORDERID]) {
            
             [dictofEvnetsBooking setObject:[attributeDict objectForKey:EVENT_TICKET_ORDERID] forKey:EVENT_TICKET_ORDERID];
        }
        if ([[attributeDict allKeys] containsObject:EVENT_TICKET_BALANCE_AMOUNT]) {
            [dictofEvnetsBooking setObject:[attributeDict objectForKey:EVENT_TICKET_BALANCE_AMOUNT] forKey:EVENT_TICKET_BALANCE_AMOUNT];
        }
       
        
        [outputArr addObject:dictofEvnetsBooking];
    }
    
   
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
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
