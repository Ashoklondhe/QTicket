//
//  CheckVocuherValidityParseOperation.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 18/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "CommonParseOperation.h"
#import "UserVO.h"

@interface CheckVocuherValidityParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    UserVoucherVO       *VoucherVO;
    
    
}

@property (nonatomic, retain) NSMutableDictionary *VoucherStatusDictionary;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;

@property (retain, nonatomic) UserVoucherVO       *VoucherVO;

@end
