//
//  RegistrationVO.h
//  SMSCountry
//
//  Created by Lakshmikanth on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationVO : NSObject

@property (nonatomic, retain)   NSString    *firstName;
@property (nonatomic, retain)   NSString    *lastName;
@property (nonatomic, retain)   NSString    *phone;
@property (nonatomic, retain)   NSString    *mailId;
@property (nonatomic, retain)   NSString    *password;
@property (nonatomic, retain)   NSString    *confirmPassword;
@property (nonatomic, retain)   NSString    *phonePrefix;
@property (nonatomic, retain)   NSString    *fid;
@property (nonatomic, retain)   NSString    *nationality;

@end
