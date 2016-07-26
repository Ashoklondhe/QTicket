//
//  SMSCountryConnections.m
//  SMSCountry
//
//  Created by Tejasree on 03/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "SMSCountryConnections.h"
#import "Q-ticketsConstants.h"
#import "QticketsSingleton.h"


@implementation SMSCountryConnections

@synthesize delegate = _delegate,responseData,requestMessage,myConnection,appDelegate,scUtils;

- (id) initWithDelegate:(id)del {
    
    self = [super init];
    if (self) {
        responseData = [[NSMutableData alloc] init];
        [self setDelegate:del];
        scUtils = [[SMSCountryUtils alloc] init];
    }
    return self;
}

- (void)dealloc {
    [responseData release];
    [requestMessage release];
    [myConnection release];
    [scUtils release];
    [super dealloc];
}

#pragma mark
#pragma mark Utility Methods
#pragma mark

- (void) cancelServerConnection {
    
    [myConnection cancel];
    
    [self setDelegate:nil];
}

#pragma mark
#pragma mark Service related methods
#pragma mark

-(void)userLoginWithUserName:(NSString *)username andPassword:(NSString *)password wihtDeviceToken:(NSString *)strDeviceToken
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:USER_LOGIN];
    
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",USER_LOGIN_PARAM_1_KEY,username,USER_LOGIN_PARAM_2_KEY,password,USER_LOGIN_PARAM_3_KEY,strDeviceToken,@"source",@"3"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,USER_LOGIN]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:LOGIN_CONSTANT];
    
    
}


-(void)userRegistrationWithUserVO:(RegistrationVO *)registrationVO withDeviceToken:(NSString *)strDeviceToken
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self setRequestMessage:REGISTRATION];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",REGISTRATION_PARAM_1_KEY,registrationVO.firstName,REGISTRATION_PARAM_2_KEY,registrationVO.lastName,REGISTRATION_PARAM_3_KEY,registrationVO.phonePrefix,REGISTRATION_PARAM_4_KEY,registrationVO.phone,REGISTRATION_PARAM_5_KEY,registrationVO.mailId,REGISTRATION_PARAM_6_KEY,registrationVO.password,REGISTRATION_PARAM_7_KEY,registrationVO.confirmPassword,REGISTRATION_PARAM_8_KEY,registrationVO.fid,REGISTRATION_PARAM_9_KEY,registrationVO.nationality,REGISTRATION_PARAM_10_KEY,strDeviceToken,@"source",@"3"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,REGISTRATION]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:REGISTRATION_CONSTANT];
    
    
    
}
-(void)userPhoneVerificationWithPrefix:(NSString *)prefix andWithPhone:(NSString *)mobileNumber andCode:(NSString *)code;
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self setRequestMessage:PHONE_VERIFICATION];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",PHONE_VERIFICATION_PARAM_1_KEY,prefix,PHONE_VERIFICATION_PARAM_2_KEY,mobileNumber,PHONE_VERIFICATION_PARAM_3_KEY,code];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,PHONE_VERIFICATION]]];
    
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:VERIFICATION_CONSTANT];
    
    
}


-(void)resendVerificationCodeWithUserID:(NSString *)useID andMobile:(NSString *)mobile withPrefix:(NSString *)prefix
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self setRequestMessage:RESEND_CODE];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",RESEND_PARAM_1_KEY,useID,RESEND_PARAM_2_KEY,mobile,RESEND_PARAM_3_KEY,prefix];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,RESEND_CODE]]];
    
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:VERIFICATION_CONSTANT];
    
    
}
-(void)getAllTheatersLocations
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:GET_ALL_LOCATIONS];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,GET_ALL_LOCATIONS]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
   // [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
    
    
}

-(void)getMoviesByLanguageAndTheaterId
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:GET_MOVIES_BY_LANG_AND_THEATERID];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,GET_MOVIES_BY_LANG_AND_THEATERID]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
  //  [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
    
}
-(void)getSeatLayoutByShowTimeId:(NSString*)showTimeId
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self setRequestMessage:GET_SEAT_LAYOUT];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@",SEAT_LAYOUT_PARAM_1_KEY,showTimeId];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,GET_SEAT_LAYOUT]]];
    
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
    
    
    
}
-(void)getUserBookingByUserId:(NSString *)userId
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:USER_BOOKINGS];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@",USER_BOOKINGS_PARAM_1_KEY,userId];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,USER_BOOKINGS]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
    
}

-(void)changePasswordWither:(NSString *)userID withNewPassword:(NSString *)newPwd andOldPwd:(NSString *)oldpwd
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:CHANGE_PASSWORD];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",CHANGE_PASSWORD_PARAM_1_KEY,userID,CHANAGE_PASSWORD_PARAM_2_KEY,newPwd,CHANAGE_PASSWORD_PARAM_3_KEY,oldpwd];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,CHANGE_PASSWORD]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
}


-(void)blockSeatQticketsWithShowId:(NSString *)showId andSeatNumber:(NSString *)seatnumber withiPhoneAppSource:(NSString *)strAppSource withMovieId:(NSString *)strMovieId withScheduleDate:(NSString *)strScheduleDate withShowTime:(NSString *)strShowTime
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:BLOCK_SEATS_QTICKETS];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",BLOCK_WITH_PARAAM_1_KEY,showId,BLOACK_WITH_PARAAM_2_KEY,seatnumber,BLOACK_WITH_PARAAM_3_KEY,@"3",@"movie_id",strMovieId,@"schedule_date",strScheduleDate,@"show_time",strShowTime];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,BLOCK_SEATS_QTICKETS]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
}

//by krishna

-(void)sendLockRequestWithUserVO:(UserVO *)userVO andTransactionId:(NSString *)transactionId withEvouchers:(NSString *)Evouchers withDeviceToken:(NSString *)strDeviceToken{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:SEND_LOCK_REQUEST];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",LOCK_REQUEST_PARAAM_1_KEY,transactionId,LOCK_REQUEST_PARAAM_2_KEY,userVO.serverId,LOCK_REQUEST_PARAAM_3_KEY,userVO.userName,LOCK_REQUEST_PARAAM_4_KEY,userVO.emailId,LOCK_REQUEST_PARAAM_5_KEY,userVO.phoneNumber,LOCK_REQUEST_PARAAM_6_KEY,userVO.prefix,LOCK_REQUEST_PARAM_7_KEY,Evouchers,LOCK_REQUEST_PARAM_8_KEY,strDeviceToken,@"source",@"3"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,SEND_LOCK_REQUEST]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];

    
    
    
}


-(void)lockConfirmationRequest:(NSString *)transactionId
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:LOCK_CONFIRMATION];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@",LOCK_CONFIRMATION_PARAM_1_KEY,transactionId,@"AppVersion",@"2.3.2"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,LOCK_CONFIRMATION]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];

}
-(void)paymentForTicketsWithTransactionID:(NSString *)transactionId andName:(NSString *)name  andAmount:(NSString *)amount andCardNumber:(NSString *)cardNum andexpiryDate:(NSString *)expiryDate andScode:(NSString *)scode withNationality:(NSString *)nationality
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    QticketsSingleton *single = [QticketsSingleton sharedInstance];
    if (single.selectedBankis == 1) {
        
        [self setRequestMessage:PAYMENT_FOR_TICKETS];

    }
    else{
        
        [self setRequestMessage:PAYMENT_FOR_TICKETS_AMEX];

    }
    
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",PAYMENT_PARAM_1_KEY,transactionId,PAYMENT_PARAM_2_KEY,name,PAYMENT_PARAM_3_KEY,amount,PAYMENT_PARAM_4_KEY,cardNum,PAYMENT_PARAM_5_KEY,expiryDate,PAYMENT_PARAM_6_KEY,scode,PAYMENT_PARAM_7_KEY,nationality];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    
    if (single.selectedBankis == 1) {
        
 [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,PAYMENT_FOR_TICKETS]]];
    }
    else{
        
 [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,PAYMENT_FOR_TICKETS_AMEX]]];
    }
    
    
   
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];

    
}

-(void)confirmTicketsWithTransactionID:(NSString *)transactionID
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:CONFIRM_TICKETS];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@",CONFIRM_TICKETS_PARAM_1_KEY,transactionID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,CONFIRM_TICKETS]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
}
-(void)cancelRequestWithTransactionId:(NSString *)transactionID
{

    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:CANCEL_CONFIRMATION];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@",CANCEL_CONFIRMATION_PARAM_1_KEY,transactionID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,CANCEL_CONFIRMATION]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];

}
-(void)forgotPasswordWithEmailID:(NSString *)userEmailID
{
 
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:FORGOT_PASSWORD];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@",FORGOT_PASSWORD_PARAM_1_KEY,userEmailID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,FORGOT_PASSWORD]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
    

}






#pragma  mark --- for events

-(void)getAllEventsByCategory{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self setRequestMessage:GET_ALL_EVENTSBYCATEGORY];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,GET_ALL_EVENTSBYCATEGORY]]];

    [request setHTTPMethod:HTTP_REQUEST_POST];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
//    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
}

-(void)blockSeatsforEventswithEventId:(NSString *)eventId withEventVenueId:(NSString *)venueId withNoofSeats:(NSString *)noofSeats{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self setRequestMessage:BLOCKSETS_FOREVETNS];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",BLOCKSETS_FOREVETNS_PARAM_1_KEY,eventId,BLOCKSETS_FOREVETNS_PARAM_2_KEY,venueId,BLOCKSETS_FOREVETNS_PARAM_3_KEY,noofSeats];
    
    NSData  *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLenght = [NSString stringWithFormat:@"%lu",(unsigned long) [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init]autorelease];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,BLOCKSETS_FOREVETNS]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLenght forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    
    NSURLConnection *conn =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
    
}

-(void)sendEventsLockRequestwithUserVO:(UserVO *)userVO withTransationId:(NSString *)transactionId{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self setRequestMessage:SEND_EVENTSSEAT_LOCKREQUEST];
    
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_1_KEY,transactionId,SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_2_KEY,userVO.serverId,SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_3_KEY,userVO.userName,SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_4_KEY,userVO.emailId,SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_5_KEY,userVO.phoneNumber,SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_6_KEY,userVO.prefix];

   
    NSData  *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLenght = [NSString stringWithFormat:@"%lu",(unsigned long) [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init]autorelease];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,SEND_EVENTSSEAT_LOCKREQUEST]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLenght forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    
    NSURLConnection *conn =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];

    
    
    
}







#pragma mark --- for my vouchers


-(void)getUserVoucherwithUserID:(NSString *)userId{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self setRequestMessage:GET_ALLEVOUCHERS];
    
   
    NSString *post = [NSString stringWithFormat:@"%@=%@",GET_ALLVOUCHERS_PARAM_1_KEY,userId];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,GET_ALLEVOUCHERS]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
//    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];

    
}




-(void)checkVoucherValiditywithUserEmailId:(NSString *)userEmailId withVoucherId:(NSString *)voucherId withShowid:(NSString *)showid{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self setRequestMessage:CHECK_VOUCHER];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",CHECK_VOUCHER_PARAM_1_KEY,userEmailId,CHECK_VOUCHER_PARAM_2_KEY,voucherId,CHECK_VOUCHER_PARAM_3_KEY,showid];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,CHECK_VOUCHER]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    [scUtils showLoaderWithTitle:@"" andSubTitle:@"Checking..."];
    
}



#pragma mark --- to get terms and conditons

-(void)getTermsandConditionsforBooking{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self setRequestMessage:GET_TERMS_AND_CONDITIONS];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,GET_TERMS_AND_CONDITIONS]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    //[scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
    
    
}



#pragma mark --- for user prifole updation

-(void)updateyourProfileusingUserId:(NSString *)userId withusername:(NSString *)userName withuseremail:(NSString *)userEmail withPrefix:(NSString *)prefix withPhonenumber:(NSString *)phonenum withNationality:(NSString *)nationality{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self setRequestMessage:USER_PROFILE_UPDATION];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",USER_PROFILE_UPDATION_PARAM_1_KEY,userId,USER_PROFILE_UPDATION_PARAM_2_KEY,userName,USER_PROFILE_UPDATION_PARAM_3_KEY,userEmail,USER_PROFILE_UPDATION_PARAM_4_KEY,phonenum,USER_PROFILE_UPDATION_PARAM_5_KEY,prefix,USER_PROFILE_UPDATION_PARAM_6_KEY,nationality];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,USER_PROFILE_UPDATION]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROFILE_UPDATING];
    

    
}




#pragma mark -- for Cancelation of Booked ticket

-(void)cancelBookedTicketwithReservationCode:(NSString *)confirmationCode withUserId:(NSString *)userId withUserEmail:(NSString *)userEmail withPrefix:(NSString *)prefix withPhonenumber:(NSString *)phonenum withCheckStatus:(NSString *)checkStatus withAppsource:(NSString *)AppSource{
    

    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self setRequestMessage:CANCEL_BOOKING];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",CANCEL_BOOKING_PARAM_1_KEY,userId,CANCEL_BOOKING_PARAM_2_KEY,userEmail,CANCEL_BOOKING_PARAM_3_KEY,phonenum,CANCEL_BOOKING_PARAM_4_KEY,prefix,CANCEL_BOOKING_PARAM_5_KEY,confirmationCode,CANCEL_BOOKING_PARAM_6_KEY,checkStatus,CANCEL_BOOKING_PARAM_7_KEY,AppSource];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,CANCEL_BOOKING]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:TICKET_CANCELING];

    
    
}


//for check release status


//checkreleasestatus?confirmationcode=53567141
-(void)checkCancelBookingStatuswithConfirmationCode:(NSString *)confirmationcode{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self setRequestMessage:CANCEL_BOOKING_CHECKSTATUS];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@",CANCEL_BOOKING_CHECKSTATUS_PARAM_1_KEY,confirmationcode];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,CANCEL_BOOKING_CHECKSTATUS]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:TICKET_CANCELING];
    

    
}





#pragma mark --- Event TicketBooking



-(void)confirmTicketForEventwithEventId:(NSString *)eventId withTicketId:(NSString *)ticketId withTicketTotalCost:(NSString *)ticketCost withnoOfTickets:(NSString *)noofTickets withTiketsasPerCategory:(NSString *)ticketsperCategory withUserEmail:(NSString *)userEmail withUserName:(NSString *)userName withUserPhoneNum:(NSString *)phoneNum withPrefix:(NSString *)prefix withEventDate:(NSString *)eventDate withEventStartTime:(NSString *)eventStartTime withBalanceAmount:(NSString *)balanceAmount withCouponAmount:(NSString *)couponAmount withCouponCodes:(NSString *)couponCodes{
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self setRequestMessage:EVENT_TICKET_BOOKING];
    
    NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",EVENT_TICKET_BOOKING_PARAM_1_KEY,eventId,EVENT_TICKET_BOOKING_PARAM_2_KEY,ticketId,EVENT_TICKET_BOOKING_PARAM_3_KEY,ticketCost,EVENT_TICKET_BOOKING_PARAM_4_KEY,noofTickets,EVENT_TICKET_BOOKING_PARAM_5_KEY,ticketsperCategory,EVENT_TICKET_BOOKING_PARAM_6_KEY,userEmail,EVENT_TICKET_BOOKING_PARAM_7_KEY,userName,EVENT_TICKET_BOOKING_PARAM_8_KEY,phoneNum,EVENT_TICKET_BOOKING_PARAM_9_KEY,prefix,EVENT_TICKET_BOOKING_PARAM_10_KEY,eventDate,EVENT_TICKET_BOOKING_PARAM_11_KEY,eventStartTime,EVENT_TICKET_BOOKING_PARAM_12_KEY,balanceAmount,EVENT_TICKET_BOOKING_PARAM_13_KEY,couponAmount,EVENT_TICKET_BOOKING_PARAM_14_KEY,couponCodes,
        @"AppSource",@"3",@"AppVersion",@"2.3.2"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,EVENT_TICKET_BOOKING]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:PROCESSING];
    
}

-(void)checkEventBookingwithEventOrderId:(NSString *)eventOrderId{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self setRequestMessage:EVENT_TICKET_CONFIRMATION];
    
    
    NSString *post = [NSString stringWithFormat:@"%@=%@",EVENT_TICKET_CONFIRMATION_PARAM_1_KEY,eventOrderId];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,EVENT_TICKET_CONFIRMATION]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    [request setValue:postLength forHTTPHeaderField:HTTP_HEADER_CONTENT_LENGTH];
    [request setValue:HTTP_HEADER_CONTENT_TYPE_VALUE forHTTPHeaderField:HTTP_HEADER_CONTENT_TYPE];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];
    
    [scUtils showLoaderWithTitle:@"" andSubTitle:TICKET_CONFIRMATING];

    
    
    
    
}



#pragma mark --- get user countries and mobile numbers
-(void)getCountriesWithMobileNumbers{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self setRequestMessage:GET_COUNTRIES_WITHMOBILEPREFIXES];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc]init]autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CONNECTION_BASE_URL,GET_COUNTRIES_WITHMOBILEPREFIXES]]];
    [request setHTTPMethod:HTTP_REQUEST_POST];
    
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self setMyConnection:conn];
    [conn release];

    
    
}


#pragma mark
#pragma mark NSURLConnection Delegate Methods
#pragma mark

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
	[responseData appendData:data];
    
    if (_delegate!=nil) {
        
         
    }
    
#ifdef PRINT_LOGS
    NSString *serverOutput  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding ];
    
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"Received Data: %@", serverOutput);
    [serverOutput release];
#endif
    
}


- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    if ([challenge previousFailureCount] > 0) {
        
        // do something may be alert message
        
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Authentication Failure" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }
    else
    {
        
        NSURLCredential *credential = [NSURLCredential credentialWithUser:@"96nhGq65BfCXWwvK"password:@"gMRk65gQbqpA9tkcmmDZfqeyK"persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    }
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
#ifdef PRINT_LOGS
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"ERROR : %@",[error localizedDescription]);
#endif
    
    if (_delegate != nil) {
        
        [_delegate errorReceivingData:[error localizedDescription] withRequestMessage:requestMessage];
        
    }
    [scUtils hideLoader];
    [self hideLoader];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [scUtils hideLoader];
    
    if (_delegate != nil) {
        [_delegate finishedReceivingData:responseData withRequestMessage:requestMessage];
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
        
        appDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
        HUD = [[MBProgressHUD alloc] initWithView:appDelegate.window];
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

@end
