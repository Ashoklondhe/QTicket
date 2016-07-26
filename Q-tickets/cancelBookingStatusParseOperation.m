//
//  cancelBookingStatusParseOperation.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 25/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "cancelBookingStatusParseOperation.h"
#import "Q-ticketsConstants.h"

@implementation cancelBookingStatusParseOperation
@synthesize status,message,cancelBookingStatusDict,errorCode;


- (void)main
{
    
    outputArr = [[NSMutableArray alloc] init];
    cancelBookingStatusDict = [[NSMutableDictionary alloc]init];
    
    
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
    cancelBookingStatusDict = [[NSMutableDictionary alloc]init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:RESPONSE]) {
        
        status = [attributeDict objectForKey:STATUS];
        [cancelBookingStatusDict setValue:status forKey:STATUS];
        
        
    }
    if ([currentElement isEqualToString:RESULT]) {
        
        errorCode = [attributeDict objectForKey:CANCEL_BOOKING_ERRORCODE];
        [cancelBookingStatusDict setValue:errorCode forKey:CANCEL_BOOKING_ERRORCODE];
        message = [attributeDict objectForKey:CANCEL_BOOKING_MESSAGE];
        [cancelBookingStatusDict setValue:message forKey:CANCEL_BOOKING_MESSAGE];

        
        
        [outputArr addObject:cancelBookingStatusDict];
        
        
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
