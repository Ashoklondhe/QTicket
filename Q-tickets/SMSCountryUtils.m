//
//  SMSCountryUtils.m
//  SMSCountry
//
//  Created by Tejasree on 03/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "SMSCountryUtils.h"
#import "Q-ticketsConstants.h"
#import "Reachability.h"


@implementation SMSCountryUtils
@synthesize appdelegate;



#pragma mark
#pragma mark UserDefaults Related Methods
#pragma mark

+ (void)setUserDefaults:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString*)getUserDefaults:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
    
}
+(void)setDeviceToken:(id)value forkey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

+(id)getDeviceToken:(NSString *)key
{
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}



#pragma mark
#pragma mark Alerts Related Methods
#pragma mark

+ (void) showAlertMessageWithTitle:(NSString *)title Message:(NSString *)message {
    
    [SMSCountryUtils showAlertMessageWithTitle:title Message:message withDelegate:nil withCancelBtn:NO withOkBtn:YES];
}

+ (void) showAlertMessageWithTitle:(NSString *)title Message:(NSString *)message withDelegate:(id)delegate withCancelBtn:(BOOL)cancelBtn withOkBtn:(BOOL)okBtn {
    
    [SMSCountryUtils showAlertMessageWithTitle:title Message:message withDelegate:delegate withCancelBtn:cancelBtn withOkBtn:okBtn withTag:0];
}

+ (void) showAlertMessageWithTitle:(NSString *)title Message:(NSString *)message withDelegate:(id)delegate withCancelBtn:(BOOL)cancelBtn withOkBtn:(BOOL)okBtn withTag:(int)tagVal {
    
    NSString *cancelTitle = (cancelBtn) ? @"Cancel" : nil;
    NSString *okTitle = (okBtn) ? @"OK" : nil;
    
    UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle  otherButtonTitles:okTitle, nil];
    
    [tmpAlert setTag:tagVal];
    
    [tmpAlert show];
    
    [tmpAlert release];
}

#pragma mark
#pragma mark Database Related Methods
#pragma mark

+ (NSString *)getDatabasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:DB_FILE_NAME];
    
    return path;
}


#pragma mark
#pragma mark - Background color cretion method
#pragma mark


+ (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}


+(void)writeDatetoPath:(NSData*)filepath
{
    if ( filepath )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@.xml", documentsDirectory,GET_MOVIES_BY_LANG_AND_THEATERID];
        [filepath writeToFile:filePath atomically:YES];
    }
    
}

+(NSData *)readDateFromPath
{
    NSFileManager *filemanager=[NSFileManager defaultManager];
    
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@.xml", documentsDirectory,GET_MOVIES_BY_LANG_AND_THEATERID];
    
    
    
    if ([filemanager fileExistsAtPath:filePath])
    {
     NSData   *tempdata = [NSData dataWithContentsOfFile:filePath];
         return tempdata;
    }
    else
    {
        NSData *tempdata=nil;
        return tempdata;
    }
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
#pragma mark -

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

-(void)showLoaderWithTitle:(NSString *)title andSubTitle:(NSString *)subtitle {
    
    if (HUD == nil) {
        
        appdelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
        HUD = [[MBProgressHUD alloc] initWithView:appdelegate.window];
        [[[UIApplication sharedApplication] keyWindow] addSubview:HUD];
        HUD.delegate = self;
    }
    HUD.labelFont=[UIFont systemFontOfSize:12];
    HUD.labelText = title;
    HUD.detailsLabelFont=[UIFont systemFontOfSize:12];
    HUD.detailsLabelText = subtitle;
	HUD.square = YES;
    [HUD show:YES];
}

- (void) hideLoader {
    [HUD hide:NO];
}


- (NSString *)timeFormatted:(int)totalSeconds
{
    totalSeconds = totalSeconds*60;

    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    NSString *timeString =@"";
    NSString *formatString=@"";
    if(hours > 0){
        formatString=hours==1?@"%d hr":@"%d hr";
        timeString = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,hours]];
    }
    if(minutes > 0 || hours > 0 ){
        formatString=minutes==1?@" %d min":@" %d min";
        timeString = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,minutes]];
    }
    return timeString;
    
}


#pragma mark -- device verify

+(BOOL)isIphone{
    
 return ([[UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone) ?YES:NO;
}
+(BOOL)isRetinadisplay{
    
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0))? YES : NO;
    
}
+(BOOL)netAvailableorNot{
    
   Reachability *reach= [Reachability reachabilityForInternetConnection];
   NetworkStatus netStatus = [reach currentReachabilityStatus];

    if (netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi) {

        return YES;
    }
    else{
        return NO;
    }

}

+ (BOOL)validateEmail: (NSString *) emailAddress
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailAddress];
}


+(NSMutableArray *)arrofPlaceholders{
    
    NSMutableArray *arrofloaders = [[NSMutableArray alloc]init];
    
    for (int i =0; i<=15; i++) {
        
        if (i<=9) {
            //1st
//            [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Preloader_8_0000%d.png",i]]];

            //cube
//             [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"PR_3_0000%d.png",i]]];
          
            
            [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Preloader_2_0000%d.png",i]]];
            
            
        }
        else{
            
            //1st
//             [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Preloader_8_000%d.png",i]]];
            
            //cube
//             [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"PR_3_000%d.png",i]]];
            
             [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Preloader_2_000%d.png",i]]];
        }
    }
    
    
    return arrofloaders;
    
    
}






@end
