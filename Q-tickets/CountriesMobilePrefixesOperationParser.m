//
//  CountriesMobilePrefixesOperationParser.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 29/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "CountriesMobilePrefixesOperationParser.h"
#import "Q-ticketsConstants.h"

@implementation CountriesMobilePrefixesOperationParser
@synthesize CountryDetia,status,errorCode,message,tempCountriesArr,CountriesDict;

- (void)main
{
    
    outputArr = [[NSMutableArray alloc] init];
    tempCountriesArr = [[NSMutableArray alloc] init];
    CountriesDict = [[NSMutableDictionary alloc] init];
    
    
    
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
        [CountriesDict setValue:status forKey:STATUS];

        
        
    }
    if ([currentElement isEqualToString:COUNTRY]) {
        CountryDetia = [[CountryInfo alloc] init];
        CountryDetia.CountryId = [attributeDict objectForKey:COUNTRY_ID];
        CountryDetia.CountryName = [attributeDict objectForKey:COUNTRY_NAME];
        CountryDetia.CountryPrefix = [attributeDict objectForKey:COUNTRY_MOBILE_PREFIX];
        CountryDetia.CountryNationality = [attributeDict objectForKey:COUNTRY_NATIONALITY];
        [tempCountriesArr addObject:CountryDetia];
               
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:RESPONSE])
    {
        [CountriesDict setValue:tempCountriesArr forKeyPath:COUNTRY];
        [outputArr addObject:CountriesDict];
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
