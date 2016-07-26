//
//  SMSCountryUtils.h
//  SMSCountry
//
//  Created by Tejasree on 03/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface SMSCountryUtils : NSObject<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property(nonatomic,retain)AppDelegate *appdelegate;


+(void)writeDatetoPath:(NSData*)filepath;
+(NSData *)readDateFromPath;

#pragma mark
#pragma mark UserDefaults Related Methods
#pragma mark

+ (void)setUserDefaults:(id)value forKey:(NSString *)key;

+ (NSString*)getUserDefaults:(NSString *)key;

+(void)setDeviceToken:(id)value forkey:(NSString *)key;

+(id)getDeviceToken:(NSString *)key;



#pragma mark
#pragma mark Alerts Related Methods
#pragma mark

+ (void) showAlertMessageWithTitle:(NSString *)title Message:(NSString *)message;

+ (void) showAlertMessageWithTitle:(NSString *)title Message:(NSString *)message withDelegate:(id)delegate withCancelBtn:(BOOL)cancelBtn withOkBtn:(BOOL)okBtn;

+ (void) showAlertMessageWithTitle:(NSString *)title Message:(NSString *)message withDelegate:(id)delegate withCancelBtn:(BOOL)cancelBtn withOkBtn:(BOOL)okBtn withTag:(int)tagVal;

#pragma mark
#pragma mark - Background color cretion method
#pragma mark


+ (unsigned int)intFromHexString:(NSString *)hexStr;

#pragma mark
#pragma mark Loader Related Methods
#pragma mark

- (void)hudWasHidden:(MBProgressHUD *)hud;

- (void) showLoaderWithTitle:(NSString *)title andSubTitle:(NSString *)subtitle;

- (void) hideLoader;

#pragma mark
#pragma mark Database Related Methods
#pragma mark

+(NSString *)getDatabasePath;

- (NSString *)timeFormatted:(int)totalSeconds;

+ (BOOL)validateEmail: (NSString *) emailAddress;

#pragma mark for device verify

+(BOOL)isIphone;

+(BOOL)isRetinadisplay;

+(BOOL)netAvailableorNot;


#pragma mark -- custom preloader

+(NSMutableArray *)arrofPlaceholders;





@end
