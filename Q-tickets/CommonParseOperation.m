//
//  CommonParseOperation.m
//  TicketDada
//
//  Created by Laxmikanth Reddy on 23/08/12.
//  Copyright (c) 2012 Outset Apps Technologies Pvt Ltd. All rights reserved.
//

#import "CommonParseOperation.h"

@interface CommonParseOperation () 

@end

@implementation CommonParseOperation

@synthesize isErrorOccurred,delegate;
@synthesize currentElement,currentElementCharacters,outputArr,dataToParse,requestMessage;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithData:(NSData *)data delegate:(id <CommonParseOperationDelegate>)theDelegate andRequestMessage:(NSString *)reqMsg
{
    self = [super init];
    if (self != nil)
    {
        self.dataToParse = data;
        self.delegate = theDelegate;
        self.requestMessage = reqMsg;
    }
    return self;
}


@end
