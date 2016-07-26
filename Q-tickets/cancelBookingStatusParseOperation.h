//
//  cancelBookingStatusParseOperation.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 25/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "CommonParseOperation.h"

@interface cancelBookingStatusParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    
}

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;

@property (nonatomic, retain) NSMutableDictionary *cancelBookingStatusDict;




@end
