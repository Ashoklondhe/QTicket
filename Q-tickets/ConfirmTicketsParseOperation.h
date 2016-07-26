//
//  ConfirmTicketsParseOperation.h
//  QTickets
//
//  Created by Shiva Kumar on 29/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonParseOperation.h"
#import "BookingViewController.h"

@interface ConfirmTicketsParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    NSDictionary            *cnfrmDictionary;
    
}
@property (nonatomic,retain) NSDictionary         *cnfrmDictionary;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;

@property (nonatomic,retain) NSString             *confirmationCode;

@property (nonatomic,retain) NSString             *confirm;

@property (nonatomic,retain) NSString             *qrImgSRC;

@property (nonatomic, retain) SeatSelection       *currentSelection;

@property (nonatomic,retain) NSString             *isRegistrationNow;

@property (nonatomic,retain) NSString             *registrationMessage;

@end
