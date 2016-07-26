//
//  LoginViewController.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonParseOperation.h"
#import "SMSCountryConnections.h"
#import "UserVO.h"





@interface LoginViewController : UIViewController<CommonParseOperationDelegate,SMSCountryConnectionDelegate>{
    
    
    NSMutableArray                      *connectionsArr;
    NSOperationQueue                    *queue;
    NSMutableArray                      *parsersArr;
    
    
}

@property (nonatomic, retain) NSMutableArray            *connectionsArr;
@property (nonatomic, retain) NSOperationQueue          *queue;
@property (nonatomic, retain) NSMutableArray            *parsersArr;
@property (nonatomic, assign) BOOL                      isValue;




@end
