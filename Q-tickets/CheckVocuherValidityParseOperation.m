//
//  CheckVocuherValidityParseOperation.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 18/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "CheckVocuherValidityParseOperation.h"
#import "Q-ticketsConstants.h"

@implementation CheckVocuherValidityParseOperation
@synthesize status,errorCode,message,VoucherStatusDictionary,VoucherVO;


- (void)main
{
    
    outputArr = [[NSMutableArray alloc] init];
    VoucherStatusDictionary  = [[NSMutableDictionary alloc] init];
    
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
        errorCode = [attributeDict objectForKey:ERRORCODE];
        message = [attributeDict objectForKey:ERROR_MESSAGE];
    }
    
    if ([currentElement isEqualToString:CheckVoucher_Coupons])
    {
        
         VoucherVO   = [[UserVoucherVO alloc] init];
        

        
        VoucherVO.voucherBalanceValue = [NSString stringWithFormat:@"%@",[attributeDict objectForKey:CheckVoucher_Balance]];
        VoucherVO.voucherCoupon        = [NSString stringWithFormat:@"%@",[attributeDict objectForKey:CheckVoucher_CouponCode]];
        [outputArr addObject:VoucherVO];

        
       
       
    }
    
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
//    if ([elementName isEqualToString:RESULT])
//    {
//        [outputArr addObject:VoucherStatusDictionary];
//    }

    
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
