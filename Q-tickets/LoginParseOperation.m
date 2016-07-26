//
//  LoginParseOperation.m
//  SMSCountry
//
//  Created by Tejasree on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "LoginParseOperation.h"
#import "SMSCountryUtils.h"
#import "Q-ticketsConstants.h"

@implementation LoginParseOperation
@synthesize status,errorCode,message,userVO,loginDictionary;

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    outputArr = [[NSMutableArray alloc] init];
    loginDictionary = [[NSMutableDictionary alloc]init];
    
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
    
    if ([currentElement isEqualToString:RESULT]) {
        status = [attributeDict objectForKey:STATUS];
        [loginDictionary setValue:status forKey:STATUS];
        errorCode = [attributeDict objectForKey:ERRORCODE];
        [loginDictionary setValue:errorCode forKey:ERRORCODE];
        message = [attributeDict objectForKey:ERROR_MESSAGE];
        [loginDictionary setValue:message forKey:ERROR_MESSAGE];
        
       
    }
    
    if ([currentElement isEqualToString:USER])
    {
        userVO = [[[UserVO alloc]init]autorelease];
        
        if ([attributeDict objectForKey:USER_NAME])
        {
            userVO.userName=[attributeDict objectForKey:USER_NAME];

        }
        else
        {
            userVO.userName=@"";
        }
        if ([attributeDict objectForKey:USER_ID])
        {
            userVO.serverId=[attributeDict objectForKey:USER_ID];
            
        }
        else
        {
            userVO.serverId=@"";
        }
        
        
        if ([attributeDict objectForKey:USER_PREFIX])
        {
            userVO.prefix=[attributeDict objectForKey:USER_PREFIX];
            
        }
        else
        {
            userVO.prefix=@"";
        }
        if ([attributeDict objectForKey:USER_PHONE])
        {
            userVO.phoneNumber=[attributeDict objectForKey:USER_PHONE];
            
        }
        else
        {
            userVO.phoneNumber=@"";
        }
        if ([attributeDict objectForKey:USER_ADDRESS])
        {
            userVO.address=[attributeDict objectForKey:USER_ADDRESS];
            
        }
        else
        {
            userVO.address=@"";
        }
        if ([attributeDict objectForKey:USER_EMAIL])
        {
            userVO.emailId=[attributeDict objectForKey:USER_EMAIL];
            
        }
        else
        {
            userVO.emailId=@"";
        }
        
        if ([attributeDict objectForKey:USER_VERIFY])
        {
            userVO.verify=[attributeDict objectForKey:USER_VERIFY];
            
        }
        else
        {
            userVO.verify=@"";
        }
        if ([[attributeDict allKeys] containsObject:USER_NATIONALITY]) {
            
        if ([attributeDict objectForKey:USER_NATIONALITY]) {
            
            userVO.nationality=[attributeDict objectForKey:USER_NATIONALITY];
        }
        }
        else{
            userVO.nationality= @"";
        }
        [loginDictionary setValue:userVO forKey:USER_OBJECT];

    }
   
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    if ([elementName isEqualToString:RESULT])
    {
        [outputArr addObject:loginDictionary];
    }
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
