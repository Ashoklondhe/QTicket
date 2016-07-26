//
//  LockConformationParseOperation.m
//  QTickets
//
//  Created by Shiva Kumar on 28/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "LockConformationParseOperation.h"
#import "Q-ticketsConstants.h"

@implementation LockConformationParseOperation
@synthesize status,errorCode,message,lockDictionary,transactionID;

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    outputArr = [[NSMutableArray alloc] init];
    lockDictionary=[[NSMutableDictionary alloc]init];
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
    transactionID=[[NSString alloc]init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:RESULT])
    {
        status = [attributeDict objectForKey:STATUS];
        [lockDictionary setValue:status forKey:STATUS];
        errorCode = [attributeDict objectForKey:ERRORCODE];
        [lockDictionary setValue:errorCode forKey:ERRORCODE];
        message = [attributeDict objectForKey:ERROR_MESSAGE];
        [lockDictionary setValue:message forKey:ERROR_MESSAGE];
        
        if ([attributeDict objectForKey:LOCK_CONFIRMATION_PARAM_1_KEY])
        {
            transactionID =[attributeDict objectForKey:LOCK_CONFIRMATION_PARAM_1_KEY];
            [lockDictionary setValue:transactionID forKey:LOCK_CONFIRMATION_OBJ];
            NSString *strbalan = [attributeDict objectForKey:LOCK_CONFIRMATION_PARAM_2_KEY];
            [lockDictionary setValue:strbalan forKey:LOCK_CONFIRMATION_PARAM_2_KEY];
        }
        
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:RESPONSE])
    {
        [outputArr addObject:lockDictionary];
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
