//
//  CancelBookingParseOperation.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 23/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "CancelBookingParseOperation.h"
#import "Q-ticketsConstants.h"

@implementation CancelBookingParseOperation
@synthesize status,message,cancelBookingDict,errorCode;
- (void)main
{
    
    outputArr = [[NSMutableArray alloc] init];
    cancelBookingDict = [[NSMutableDictionary alloc]init];
    
    
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
    cancelBookingDict = [[NSMutableDictionary alloc]init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:RESPONSE]) {
        
        status = [attributeDict objectForKey:STATUS];
        [cancelBookingDict setValue:status forKey:STATUS];
//        errorCode = [attributeDict objectForKey:ERRORCODE];
//        [cancelBookingDict setValue:errorCode forKey:ERRORCODE];
//        message = [attributeDict objectForKey:ERROR_MESSAGE];
//        [cancelBookingDict setValue:message forKey:ERROR_MESSAGE];
        
        
    }
    if ([currentElement isEqualToString:CANCEL_BOOKING_MYBOOKING]) {
        
        if ([[attributeDict allKeys] containsObject:CANCEL_BOOKING_STATUS]) {
            
            [cancelBookingDict setObject:[attributeDict objectForKey:CANCEL_BOOKING_STATUS] forKey:CANCEL_BOOKING_STATUS];

        }
        if ([[attributeDict allKeys] containsObject:CANCEL_BOOKING_MESSAGE]) {
             [cancelBookingDict setObject:[attributeDict objectForKey:CANCEL_BOOKING_MESSAGE] forKey:CANCEL_BOOKING_MESSAGE];
        }
        
        if ([[attributeDict allKeys] containsObject:CANCEL_BOOKING_CONFIRMATION_CODE]) {
               [cancelBookingDict setObject:[attributeDict objectForKey:CANCEL_BOOKING_CONFIRMATION_CODE] forKey:CANCEL_BOOKING_CONFIRMATION_CODE];
        }
        if ([[attributeDict allKeys] containsObject:CANCEL_BOOKING_ERRORCODE]) {
            
            [cancelBookingDict setObject:[attributeDict objectForKey:CANCEL_BOOKING_ERRORCODE] forKey:CANCEL_BOOKING_ERRORCODE];
        }
        
        if ([[attributeDict allKeys] containsObject:CANCEL_BOOKING_CHECKINTERVAL]) {
            
             [cancelBookingDict setObject:[attributeDict objectForKey:CANCEL_BOOKING_CHECKINTERVAL] forKey:CANCEL_BOOKING_CHECKINTERVAL];
        }
        if ([[attributeDict allKeys] containsObject:CANCEL_BOOKING_CHECKTIME]) {
            
        [cancelBookingDict setObject:[attributeDict objectForKey:CANCEL_BOOKING_CHECKTIME] forKey:CANCEL_BOOKING_CHECKTIME];
            
        }
     
        [outputArr addObject:cancelBookingDict];
        
        
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
