//
//  ProfileUpdationParseOperation.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 20/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "ProfileUpdationParseOperation.h"
#import "Q-ticketsConstants.h"
#import "QticketsSingleton.h"
@implementation ProfileUpdationParseOperation
@synthesize status,message,profileUpdationDict,userVO,errorCode;
- (void)main
{
    
    outputArr = [[NSMutableArray alloc] init];
    profileUpdationDict = [[NSMutableDictionary alloc]init];
    
    
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
    profileUpdationDict = [[NSMutableDictionary alloc]init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:RESPONSE]) {
        
        status = [attributeDict objectForKey:STATUS];
        [profileUpdationDict setValue:status forKey:STATUS];
        errorCode = [attributeDict objectForKey:ERRORCODE];
        [profileUpdationDict setValue:errorCode forKey:ERRORCODE];
        message = [attributeDict objectForKey:ERROR_MESSAGE];
        [profileUpdationDict setValue:message forKey:ERROR_MESSAGE];

        
    }
    if ([currentElement isEqualToString:USER_PROFILE_DET]) {
        
        
        [profileUpdationDict setValue:[attributeDict objectForKey:USER_PROFILE_NAME] forKey:USER_PROFILE_NAME];
        [profileUpdationDict setValue:[attributeDict objectForKey:USER_PROFILE_PREFIX] forKey:USER_PROFILE_PREFIX];
        [profileUpdationDict setValue:[attributeDict objectForKey:USER_PROFILE_MOBILENUM] forKey:USER_PROFILE_MOBILENUM];
        [profileUpdationDict setValue:[attributeDict objectForKey:USER_PROFILE_NATIONALITY] forKey:USER_PROFILE_NATIONALITY];
        [profileUpdationDict setValue:[attributeDict objectForKey:USER_PROFILE_EMAIL_ID] forKey:USER_PROFILE_EMAIL_ID];
        [profileUpdationDict setValue:[attributeDict objectForKey:USER_PROFILE_IS_NUM_VERIFY] forKey:USER_PROFILE_IS_NUM_VERIFY];
        
        [outputArr addObject:profileUpdationDict];
        
        
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
