//
//  MoviesListParseOperation.h
//  SMSCountry
//
//  Created by Tejasree on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonParseOperation.h"
#import "MovieVO.h"
#import "SMSCountryUtils.h"

@interface MoviesListParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
}

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;

@property (retain, nonatomic) SMSCountryUtils     *scUtils;

@property (nonatomic, retain)NSMutableArray  *tempMovieArr;
@property (nonatomic,retain)NSDictionary   *movieDict;

@end
