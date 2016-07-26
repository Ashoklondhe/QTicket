 //
//  SendLockRequestParseOpeartion.m
//  QTickets
//
//  Created by Shiva Kumar on 28/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "SendLockRequestParseOpeartion.h"
#import "SMSCountryUtils.h"
#import "Q-ticketsConstants.h"

@implementation SendLockRequestParseOpeartion

@synthesize status,errorCode,message,sendLockDictionary,userVO,requestedTimeInSec,timedoutInMin;

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    outputArr = [[NSMutableArray alloc] init];
    sendLockDictionary=[[NSMutableDictionary alloc]init];
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
    requestedTimeInSec=[[NSString alloc]init];
    timedoutInMin=[[NSString alloc]init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	
    currentElement = [elementName copy];
    
    
    
    if ([currentElement isEqualToString:RESULT])
    {
        status = [attributeDict objectForKey:STATUS];
        [sendLockDictionary setValue:status forKey:STATUS];
        errorCode = [attributeDict objectForKey:ERRORCODE];
        [sendLockDictionary setValue:errorCode forKey:ERRORCODE];
        message = [attributeDict objectForKey:ERROR_MESSAGE];
        [sendLockDictionary setValue:message forKey:ERROR_MESSAGE];
        
        userVO=[[UserVO alloc]init];
        if ([attributeDict objectForKey:SEAT_LOCK_USERID])
        {
            userVO.serverId=[attributeDict objectForKey:SEAT_LOCK_USERID];
        }
        if ([attributeDict objectForKey:SEAT_LOCK_NAME])
        {
            userVO.userName=[attributeDict objectForKey:SEAT_LOCK_NAME];
        }
        if ([attributeDict objectForKey:SEAT_LOCK_EMAIL])
        {
            userVO.emailId=[attributeDict objectForKey:SEAT_LOCK_EMAIL];
            
        }
        if ([attributeDict objectForKey:SEAT_LOCK_MOBILE])
        {
            userVO.phoneNumber=[attributeDict objectForKey:SEAT_LOCK_MOBILE];
            
        }
        if ([attributeDict objectForKey:SEAT_LOCK_PREFIX])
        {
            userVO.prefix=[attributeDict objectForKey:SEAT_LOCK_PREFIX];
            
        }
        
        if ([attributeDict objectForKey:SEAT_LOCK_REQUESTED_TIMEIN_SEC])
        {
            requestedTimeInSec=[attributeDict objectForKey:SEAT_LOCK_REQUESTED_TIMEIN_SEC];
            
            [sendLockDictionary setValue:requestedTimeInSec forKey:SEAT_LOCK_REQUESTED_TIMEIN_SEC];
            
            
        }
        
        if ([attributeDict objectForKey:SEAT_LOCK_TIMED_OUT_IN_MIN])
        {
            timedoutInMin=[attributeDict objectForKey:SEAT_LOCK_TIMED_OUT_IN_MIN];
            
            [sendLockDictionary setValue:timedoutInMin forKey:SEAT_LOCK_TIMED_OUT_IN_MIN];
            
        }
        if (userVO!=nil)
        {
            [sendLockDictionary setValue:userVO forKey:USER_OBJECT];
            
        }
        

    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:RESPONSE])
    {
        [outputArr addObject:sendLockDictionary];
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
