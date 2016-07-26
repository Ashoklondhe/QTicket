//
//  TermsAndConditionsParseOperation.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 20/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "TermsAndConditionsParseOperation.h"
#import "Q-ticketsConstants.h"

@implementation TermsAndConditionsParseOperation
@synthesize status,errorCode,message,termsAndConditionsDictionary,strTermsConditi;

- (void)main
{
    
    outputArr = [[NSMutableArray alloc] init];
    termsAndConditionsDictionary  = [[NSMutableDictionary alloc] init];
    
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

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:RESPONSE]) {
        status = [attributeDict objectForKey:STATUS];
        [termsAndConditionsDictionary setValue:status forKey:STATUS];
        errorCode = [attributeDict objectForKey:ERRORCODE];
        [termsAndConditionsDictionary setValue:errorCode forKey:ERRORCODE];
        message = [attributeDict objectForKey:ERROR_MESSAGE];
        [termsAndConditionsDictionary setValue:message forKey:ERROR_MESSAGE];
        
    }
    
    if ([currentElement isEqualToString:Conditons])
    {
        strTermsConditi = [[NSMutableString alloc] init];
    }
    
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:Conditons])
    {
        [termsAndConditionsDictionary setObject:strTermsConditi forKey:Terms_Conditions];
        [outputArr addObject:termsAndConditionsDictionary];
    }
    
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    
    if ([currentElement isEqualToString:Conditons]) {
        [strTermsConditi appendString:string];
    }
    
}


- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    [self setIsErrorOccurred:YES];
    
    [delegate parseErrorOccurredWithRequestMessage:requestMessage parsingError:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}




@end
