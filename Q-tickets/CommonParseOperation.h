//
//  CommonParseOperation.h
//  TicketDada
//
//  Created by Laxmikanth Reddy on 23/08/12.
//  Copyright (c) 2012 Outset Apps Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommonParseOperationDelegate

- (void) didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr;

- (void) parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error;

@end

@interface CommonParseOperation : NSOperation {
    
    id <CommonParseOperationDelegate>       delegate;

    NSData                                  *dataToParse;
    
    NSString                                *currentElement;
    
    NSString                                *currentElementCharacters;
    
    NSMutableArray                          *outputArr;
    
    NSString                                *requestMessage;
}

@property (nonatomic, retain) id <CommonParseOperationDelegate> delegate;

@property (nonatomic, assign) BOOL              isErrorOccurred;

@property (nonatomic, retain) NSString          *currentElement;

@property (nonatomic, retain) NSString          *currentElementCharacters;

@property (nonatomic, retain) NSMutableArray    *outputArr;

@property (nonatomic, retain) NSString          *requestMessage;

@property (nonatomic, retain) NSData            *dataToParse;


#pragma mark methods

- (id)initWithData:(NSData *)data delegate:(id <CommonParseOperationDelegate>)theDelegate andRequestMessage:(NSString *)reqMsg;

@end
