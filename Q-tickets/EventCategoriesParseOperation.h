//
//  EventCategoriesParseOperation.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 14/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "CommonParseOperation.h"

@interface EventCategoriesParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    NSMutableString         *errorCode;
    NSMutableString         *message;
    
    
}

@property (retain, nonatomic) NSMutableString     *status;
@property (retain, nonatomic) NSMutableString     *errorCode;
@property (retain, nonatomic) NSMutableString     *message;
@property (nonatomic, retain) NSMutableArray      *tempEventsArr;
@property (nonatomic, retain) NSDictionary        *eventsDict;

@end
