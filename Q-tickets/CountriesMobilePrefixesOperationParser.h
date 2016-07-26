//
//  CountriesMobilePrefixesOperationParser.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 29/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "CommonParseOperation.h"
#import "CountryInfo.h"

@interface CountriesMobilePrefixesOperationParser : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    
}

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;

@property (nonatomic, retain) CountryInfo         *CountryDetia;

@property (nonatomic, retain)NSMutableArray  *tempCountriesArr;
@property (nonatomic,retain)NSDictionary     *CountriesDict;


@end
