//
//  ProfileUpdationParseOperation.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 20/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "CommonParseOperation.h"
#import "UserVO.h"

@interface ProfileUpdationParseOperation : CommonParseOperation<NSXMLParserDelegate>
{
    NSMutableString         *status;
    
    NSMutableString         *errorCode;
    
    NSMutableString         *message;
    
    
}
@property (nonatomic, retain) UserVO              *userVO;

@property (retain, nonatomic) NSMutableString     *status;

@property (retain, nonatomic) NSMutableString     *errorCode;

@property (retain, nonatomic) NSMutableString     *message;

@property (nonatomic, retain) NSMutableDictionary *profileUpdationDict;



@end
