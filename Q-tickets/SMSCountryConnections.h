//
//  SMSCountryConnections.h
//  SMSCountry
//
//  Created by Tejasree on 03/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "SMSCountryUtils.h"
#import "RegistrationVO.h"
#import "UserVO.h"

@protocol SMSCountryConnectionDelegate

- (void) finishedReceivingData:(NSData*)data withRequestMessage:(NSString *)reqMessage;

- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage;

@end

@interface SMSCountryConnections : NSObject <NSURLConnectionDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD           *HUD;
    AppDelegate             *appDelegate;
    SMSCountryUtils         *scUtils;
    
}
@property (nonatomic, assign) id<SMSCountryConnectionDelegate>              delegate;

@property (nonatomic, retain) NSMutableData                                 *responseData;

@property (nonatomic, retain) NSString                                      *requestMessage;

@property (nonatomic, retain) NSURLConnection                               *myConnection;

@property (nonatomic, retain) AppDelegate                                   *appDelegate;

@property (nonatomic, retain) SMSCountryUtils                               *scUtils;

#pragma mark
#pragma mark Utility Methods
#pragma mark

- (id) initWithDelegate:(id)del;

- (void) cancelServerConnection;

#pragma mark
#pragma mark Services Related Methods
#pragma mark

-(void)userLoginWithUserName:(NSString *)username andPassword:(NSString *)password  wihtDeviceToken:(NSString *)strDeviceToken;
-(void)userRegistrationWithUserVO:(RegistrationVO *)registrationVO withDeviceToken:(NSString *)strDeviceToken;
-(void)userPhoneVerificationWithPrefix:(NSString *)prefix andWithPhone:(NSString *)mobileNumber andCode:(NSString *)code;
-(void)resendVerificationCodeWithUserID:(NSString *)useID andMobile:(NSString *)mobile withPrefix:(NSString *)prefix;
-(void)getAllTheatersLocations;
-(void)getMoviesByLanguageAndTheaterId;
-(void)getSeatLayoutByShowTimeId:(NSString*)showTimeId;
-(void)getUserBookingByUserId:(NSString *)userId;
-(void)changePasswordWither:(NSString *)userID withNewPassword:(NSString *)newPwd andOldPwd:(NSString *)oldpwd;
-(void)blockSeatQticketsWithShowId:(NSString *)showId andSeatNumber:(NSString *)seatnumber withiPhoneAppSource:(NSString *)strAppSource withMovieId:(NSString *)strMovieId withScheduleDate:(NSString *)strScheduleDate withShowTime:(NSString *)strShowTime;






//
//-(void)sendLockRequestWithUserVO:(UserVO *)userVO andTransactionId:(NSString *)transactionId withDeviceToken:(NSString *)strDeviceToken;

//updated by krishna

-(void)sendLockRequestWithUserVO:(UserVO *)userVO andTransactionId:(NSString *)transactionId withEvouchers:(NSString *)Evouchers withDeviceToken:(NSString *)strDeviceToken;


-(void)lockConfirmationRequest:(NSString *)transactionId;
-(void)paymentForTicketsWithTransactionID:(NSString *)transactionId andName:(NSString *)name andAmount:(NSString *)amount andCardNumber:(NSString *)cardNum andexpiryDate:(NSString *)expiryDate andScode:(NSString *)scode withNationality:(NSString *)nationality;
-(void)confirmTicketsWithTransactionID:(NSString *)transactionID;
-(void)cancelRequestWithTransactionId:(NSString *)transactionID;
-(void)forgotPasswordWithEmailID:(NSString *)userEmailID;


//by krishna

#pragma mark ---- for events


-(void)getAllEventsByCategory;
-(void)blockSeatsforEventswithEventId:(NSString *)eventId withEventVenueId:(NSString *)venueId withNoofSeats:(NSString *)noofSeats;
-(void)sendEventsLockRequestwithUserVO:(UserVO *)userVO withTransationId:(NSString *)transactionId;




#pragma mark ---- for vouchers

-(void)getUserVoucherwithUserID:(NSString *)userId;

-(void)checkVoucherValiditywithUserEmailId:(NSString *)userEmailId withVoucherId:(NSString *)voucherId withShowid:(NSString *)showid;




#pragma mark --- for profile updation



-(void)updateyourProfileusingUserId:(NSString *)userId withusername:(NSString *)userName withuseremail:(NSString *)userEmail withPrefix:(NSString *)prefix withPhonenumber:(NSString *)phonenum withNationality:(NSString *)nationality;



#pragma mark -- for Terms and Conditions

-(void)getTermsandConditionsforBooking;



#pragma mark --- for cancel booked ticket

-(void)cancelBookedTicketwithReservationCode:(NSString *)confirmationCode withUserId:(NSString *)userId withUserEmail:(NSString *)userEmail withPrefix:(NSString *)prefix withPhonenumber:(NSString *)phonenum withCheckStatus:(NSString *)checkStatus withAppsource:(NSString *)AppSource;

//for confirm cancelation

-(void)checkCancelBookingStatuswithConfirmationCode:(NSString *)confirmationcode;


#pragma mark ---- for event ticket Booking


-(void)confirmTicketForEventwithEventId:(NSString *)eventId withTicketId:(NSString *)ticketId withTicketTotalCost:(NSString *)ticketCost withnoOfTickets:(NSString *)noofTickets withTiketsasPerCategory:(NSString *)ticketsperCategory withUserEmail:(NSString *)userEmail withUserName:(NSString *)userName withUserPhoneNum:(NSString *)phoneNum withPrefix:(NSString *)prefix withEventDate:(NSString *)eventDate withEventStartTime:(NSString *)eventStartTime withBalanceAmount:(NSString *)balanceAmount withCouponAmount:(NSString *)couponAmount withCouponCodes:(NSString *)couponCodes;


-(void)checkEventBookingwithEventOrderId:(NSString *)eventOrderId;




#pragma mark --- for getting mobile number prefix as per country codes
-(void)getCountriesWithMobileNumbers;


@end
