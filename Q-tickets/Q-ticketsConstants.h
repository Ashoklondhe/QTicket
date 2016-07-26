//
//  Q-ticketsConstants.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#ifndef Q_tickets_Q_ticketsConstants_h
#define Q_tickets_Q_ticketsConstants_h



#define SelectionCellHeight 30
#define SelectionCellWidth 150
#define ViewAnimationDuration 1.0


#define MenutopStripHei 56
#define MenuWidth 150

#define iPhone4Width 320
#define iPhone6Width 375
#define iPhone6PlusWidth 414

#define iPhone4Height 480
#define iPhone5Height 568

#define  ViewWidth  self.view.frame.size.width
#define  ViewHeight  self.view.frame.size.height

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:1.0]




#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)




#define CONNECTION_BASE_URL                   @"https://api.q-tickets.com/v2.1/"



#pragma mark Database related constants

#define DB_FILE_NAME                        @"QTickets_v2.2.sqlite"


#pragma mark HUD CONSTANTS

#define LOGIN_CONSTANT                      @"Login Processing..."
#define REGISTRATION_CONSTANT               @"Registration Processing..."
#define VERIFICATION_CONSTANT               @"Verification Processing..."
#define PROCESSING                          @"Processing..."
#define PROFILE_UPDATING                    @"Profile Updation..."
#define TICKET_CANCELING                    @"Cancelation Processing..."
#define TICKET_CONFIRMATING                 @"Ticket Confirmating..."


#pragma mark SERVICES RELATED CONSTANTS

#pragma mark USERLOGIN CONSTANTS

#define USER_LOGIN                          @"loginmobile?"
#define USER_LOGIN_PARAM_1_KEY              @"username"
#define USER_LOGIN_PARAM_2_KEY              @"password"
#define USER_LOGIN_PARAM_3_KEY              @"token"


#pragma mark USERREGISTRATION CONSTANTS

#define REGISTRATION                        @"Registration"
#define REGISTRATION_PARAM_1_KEY            @"firstname"
#define REGISTRATION_PARAM_2_KEY            @"lastname"
#define REGISTRATION_PARAM_3_KEY            @"prefix"
#define REGISTRATION_PARAM_4_KEY            @"phone"
#define REGISTRATION_PARAM_5_KEY            @"mailid"
#define REGISTRATION_PARAM_6_KEY            @"pwd"
#define REGISTRATION_PARAM_7_KEY            @"confirmpwd"
#define REGISTRATION_PARAM_8_KEY            @"fid"
#define REGISTRATION_PARAM_9_KEY            @"nationality"
#define REGISTRATION_PARAM_10_KEY           @"token"



#pragma mark CHNAGE PASSWORD CONSTANT

#define CHANGE_PASSWORD                        @"changepassword"
#define CHANGE_PASSWORD_PARAM_1_KEY            @"userid"
#define CHANAGE_PASSWORD_PARAM_2_KEY           @"newpwd"
#define CHANAGE_PASSWORD_PARAM_3_KEY           @"oldpwd"


#pragma mark MOBILE VERIFICATION CONSTANTS

#define PHONE_VERIFICATION                   @"PhoneVerification"
#define PHONE_VERIFICATION_PARAM_1_KEY       @"prefix"
#define PHONE_VERIFICATION_PARAM_2_KEY       @"phone"
#define PHONE_VERIFICATION_PARAM_3_KEY       @"code"


#pragma mark RESEND VERIFICATION CODE

#define RESEND_CODE                         @"generate"
#define RESEND_PARAM_1_KEY                  @"userid"
#define RESEND_PARAM_2_KEY                  @"mobile"
#define RESEND_PARAM_3_KEY                  @"prefix"


#pragma mark MOVIE THEATER LOCATION

#define GET_ALL_LOCATIONS                    @"GetAllLocations"


#pragma mark MOVIES LIST CONSTATNTS

#define GET_MOVIES_BY_LANG_AND_THEATERID     @"GetMoviesbyLangAndTheatreid"


#pragma mark SEAT LAYOUT CONSTANTS

#define GET_SEAT_LAYOUT                      @"GetSeatLayout"
#define SEAT_LAYOUT_PARAM_1_KEY              @"showtimeid"


#pragma mark USER BOOKINGS CONSTANTS

#define USER_BOOKINGS                        @"userbookings?"
#define USER_BOOKINGS_PARAM_1_KEY            @"userid"



#pragma mark BLOCK SEATS QTICKETS CONSTANTS

#define BLOCK_SEATS_QTICKETS                    @"block_seats_qtickets"
#define BLOCK_WITH_PARAAM_1_KEY                 @"showid"
#define BLOACK_WITH_PARAAM_2_KEY                @"seats"
#define BLOACK_WITH_PARAAM_3_KEY                @"AppSource"


#pragma mark SEND LOCK REQUEST CONSTANTS

#define SEND_LOCK_REQUEST                   @"send_lock_request"
#define LOCK_REQUEST_PARAAM_1_KEY           @"Transaction_Id"
#define LOCK_REQUEST_PARAAM_2_KEY           @"userid"
#define LOCK_REQUEST_PARAAM_3_KEY           @"name"
#define LOCK_REQUEST_PARAAM_4_KEY           @"email"
#define LOCK_REQUEST_PARAAM_5_KEY           @"mobile"
#define LOCK_REQUEST_PARAAM_6_KEY           @"prefix"
//by krishna
#define LOCK_REQUEST_PARAM_7_KEY            @"VoucherCodes"
#define LOCK_REQUEST_PARAM_8_KEY            @"token"


#pragma mark LOCK CONFIRMATION REQUEST CONSTANT

#define LOCK_CONFIRMATION               @"lock_confirm_request"
#define LOCK_CONFIRMATION_PARAM_1_KEY   @"Transaction_Id"
#define LOCK_CONFIRMATION_OBJ           @"lockconfirm"
#define LOCK_CONFIRMATION_PARAM_2_KEY   @"balance"


#pragma mark CANCEL REQUEST CONSTANT

#define CANCEL_CONFIRMATION               @"cancel_request"
#define CANCEL_CONFIRMATION_PARAM_1_KEY   @"Transaction_Id"


#pragma mark PAYMENT FOR TICKETS


#define PAYMENT_FOR_TICKETS_AMEX        @"payment_forticketUsingAmex?"

#define PAYMENT_FOR_TICKETS             @"payment_forticket?"
#define PAYMENT_PARAM_1_KEY             @"Transaction_Id"
#define PAYMENT_PARAM_2_KEY             @"name"
#define PAYMENT_PARAM_3_KEY             @"amount"
#define PAYMENT_PARAM_4_KEY             @"cardno"
#define PAYMENT_PARAM_5_KEY             @"expiry_date"
#define PAYMENT_PARAM_6_KEY             @"CVV"
#define PAYMENT_PARAM_7_KEY             @"nationality"




#pragma mark CONFIRM TICKETS CONSTANTS

#define CONFIRM_TICKETS                      @"confirm_tickets"
#define CONFIRM_TICKETS_PARAM_1_KEY          @"Transaction_Id"


#pragma mark FORGOT PASSWORD

#define FORGOT_PASSWORD                 @"forgot_password"
#define FORGOT_PASSWORD_PARAM_1_KEY     @"email_id"



//by krishna

#pragma mark GetEventCategories

#define GET_ALL_EVENTSBYCATEGORY            @"getalleventsdetails"

#define GET_TERMS_AND_CONDITIONS            @"termsandconditions"

#define GET_COUNTRIES_WITHMOBILEPREFIXES    @"getallcountries"

//respose objects
#define COUNTRY                            @"country"
#define COUNTRY_ID                         @"Countryid"
#define COUNTRY_NAME                       @"Countryname"
#define COUNTRY_MOBILE_PREFIX              @"Countryprefix"
#define COUNTRY_NATIONALITY                @"CountryNationality"



#define USER_PROFILE_UPDATION              @"profileupdation?"
#define USER_PROFILE_UPDATION_PARAM_1_KEY  @"uid"
#define USER_PROFILE_UPDATION_PARAM_2_KEY  @"name"
#define USER_PROFILE_UPDATION_PARAM_3_KEY  @"email"
#define USER_PROFILE_UPDATION_PARAM_4_KEY  @"mno"
#define USER_PROFILE_UPDATION_PARAM_5_KEY  @"prefix"
#define USER_PROFILE_UPDATION_PARAM_6_KEY  @"nationality"
//response objects
#define USER_PROFILE                       @"MyProfile"
#define USER_PROFILE_DET                   @"Profiles"
#define USER_PROFILE_IS_NUM_VERIFY         @"verify"
#define USER_PROFILE_NATIONALITY           @"nationality"
#define USER_PROFILE_MOBILENUM             @"mobileno"
#define USER_PROFILE_PREFIX                @"prefix"
#define USER_PROFILE_NAME                  @"name"
#define USER_PROFILE_EMAIL_ID              @"email"





#pragma mark --- for Cancel the booked ticket



#define CANCEL_BOOKING                   @"cancelbooking?"
#define CANCEL_BOOKING_PARAM_1_KEY       @"user_id"
#define CANCEL_BOOKING_PARAM_2_KEY       @"email"
#define CANCEL_BOOKING_PARAM_3_KEY       @"mobile"
#define CANCEL_BOOKING_PARAM_4_KEY       @"prefix"
#define CANCEL_BOOKING_PARAM_5_KEY       @"confirmationcode"
#define CANCEL_BOOKING_PARAM_6_KEY       @"checkstatus"
#define CANCEL_BOOKING_PARAM_7_KEY       @"AppSource"


// response parameters

#define CANCEL_BOOKING_ERRORCODE         @"errorcode"
#define CANCEL_BOOKING_MYBOOKING         @"bookingCancel"
#define CANCEL_BOOKING_STATUS            @"status"
#define CANCEL_BOOKING_MESSAGE           @"message"
#define CANCEL_BOOKING_CONFIRMATION_CODE @"confirmationcode"
#define CANCEL_BOOKING_CHECKINTERVAL     @"checkinterval"
#define CANCEL_BOOKING_CHECKTIME         @"checktime"





//check cancel booking status

#define CANCEL_BOOKING_CHECKSTATUS       @"checkreleasestatus?"
#define CANCEL_BOOKING_CHECKSTATUS_PARAM_1_KEY @"confirmationcode"






#pragma mark ---- for Events Ticket Booking

#define EVENT_TICKET_BOOKING              @"eventbookings?"
#define EVENT_TICKET_BOOKING_PARAM_1_KEY  @"eventid"
#define EVENT_TICKET_BOOKING_PARAM_2_KEY  @"ticket_id"
#define EVENT_TICKET_BOOKING_PARAM_3_KEY  @"amount"
#define EVENT_TICKET_BOOKING_PARAM_4_KEY  @"tkt_count"
#define EVENT_TICKET_BOOKING_PARAM_5_KEY  @"NoOftktPerid"
#define EVENT_TICKET_BOOKING_PARAM_6_KEY  @"email"
#define EVENT_TICKET_BOOKING_PARAM_7_KEY  @"name"
#define EVENT_TICKET_BOOKING_PARAM_8_KEY  @"phone"
#define EVENT_TICKET_BOOKING_PARAM_9_KEY  @"prefix"
#define EVENT_TICKET_BOOKING_PARAM_10_KEY @"bdate"
#define EVENT_TICKET_BOOKING_PARAM_11_KEY @"btime"
#define EVENT_TICKET_BOOKING_PARAM_12_KEY @"balamount"
#define EVENT_TICKET_BOOKING_PARAM_13_KEY @"camount"
#define EVENT_TICKET_BOOKING_PARAM_14_KEY @"couponcodes"

//response parameters

#define EVENT_TICKET_ORDERID              @"orderid"
#define EVENT_TICKET_BALANCE_AMOUNT       @"balanceamount"




#pragma mark --- for chcek Event Ticket Confirmation

#define EVENT_TICKET_CONFIRMATION             @"ticketconfirmstatus?"
#define EVENT_TICKET_CONFIRMATION_PARAM_1_KEY @"OrderID"

//response parameters

#define EVENT_TICKET_RESERVATION_CODE         @"confirmationcode"
#define EVENT_TICKET_BOOKEDQRCODE_URL         @"qrcodeurl"
#define EVENT_TICKET_isREGISTERORNOT          @"isRegister"






#pragma mark BLOCKSEATS FOR EVENTS

#define BLOCKSETS_FOREVETNS                @"block_seats_events"
#define BLOCKSETS_FOREVETNS_PARAM_1_KEY    @"eventId"
#define BLOCKSETS_FOREVETNS_PARAM_2_KEY    @"venueId"
#define BLOCKSETS_FOREVETNS_PARAM_3_KEY    @"noofSeats"


#pragma mark SEND LOCK REQUEST FOR EVENTS

#define SEND_EVENTSSEAT_LOCKREQUEST                        @"send_lock_request_events"
#define SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_1_KEY           @"Transaction_Id"
#define SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_2_KEY           @"userid"
#define SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_3_KEY           @"name"
#define SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_4_KEY           @"email"
#define SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_5_KEY           @"mobile"
#define SEND_EVENTSSEAT_LOCKREQUEST_PARAAM_6_KEY           @"prefix"





#define GET_ALLEVOUCHERS                   @"getallusercoupons?"
#define GET_ALLVOUCHERS_PARAM_1_KEY        @"userid"


#define CHECK_VOUCHER                      @"checkcouponstatus?"
#define CHECK_VOUCHER_PARAM_1_KEY          @"email"
#define CHECK_VOUCHER_PARAM_2_KEY          @"coupon"
#define CHECK_VOUCHER_PARAM_3_KEY          @"sid"



#pragma mark COMMON CONSTANTS OVER PARSING

#define RESPONSE                            @"response"
#define RESULT                              @"result"
#define STATUS                              @"status"
#define ERRORCODE                           @"errorcode"
#define ERROR_MESSAGE                       @"errormsg"

#define SERVER_ERROR                        @"SERVER ERROR"
#define INTERNET_CONNECTION_OFFLINE         @"The Internet connection appears to be offline."
#define CHECK_INTERNET_CONNECTION           @"Please check your Internet Connection"
#define SERVER_NOT_RESPONDING               @"Server Not Responding"



#pragma mark LOGIN PARSER RELATED CONSTANTS

#define USER                                @"user"
#define USER_NAME                           @"name"
#define USER_ID                             @"id"
#define USER_EMAIL                          @"email"
#define USER_PASSWORD                       @"password"
#define USER_PHONE                          @"mobile"
#define USER_VERIFY                         @"verify"
#define USER_PREFIX                         @"prefix"
#define USER_ADDRESS                        @"address"
#define USER_OBJECT                         @"UserObject"
#define USER_NATIONALITY                    @"nationality"


#pragma mark THEATER PARSER RELATED CONSTANTS


#define THEATRES                            @"Theatres"
#define THEATRE                             @"Theatre"
#define THEATRE_ID                          @"id"
#define THEATRE_NAME                        @"name"
#define THEATRE_LOGO                        @"logo"
#define THEATRE_ADDRESS                     @"address"
#define THEATRE_ARADICNAME                  @"arabicname"


#pragma mark MOVIESLIST PARSER RELATED CONSTANTS

#define MOVIES                              @"Movies"
#define MOVIE                               @"movie"
#define MOVIE_ID                            @"id"
#define MOVIE_NAME                          @"name"
#define MOVIE_RELEASE_DATE                  @"rdate"
#define MOVIE_THUMBNAIL_URL                 @"thumbURL"
#define MOVIE_LANGUAGE_ID                   @"Languageid"
#define MOVIE_CENSOR                        @"Censor"
#define MOVIE_DURATION                      @"Duration"
#define MOVIE_DESCRIPTION                   @"Description"
#define MOVIE_TYPE                          @"MovieType"
#define TWO_D                               @"2D"
#define THREE_D                             @"3D"
#define NO_NAME                             @"NO_TYPE"
#define MOVIE_COLOR_CODE                    @"colorcode"
#define MOVIE_BUTTON_COLOR_CODE             @"btncolorcode"
#define MOVIE_LAST_MODIFIED                 @"LastModified"
#define MOVIE_BG_COLOR_CODE                 @"bgcolorcode"
#define MOVIE_BG_BORDER_COLOR_CODE          @"bgbordercolorcode"
#define MOVIE_TITLE_COLOR_CODE              @"titlecolorcode"
#define MOVIE_CASTING_DETAILS               @"CastAndCrew"
#define MOVIE_IMDB_RATING                   @"IMDB_rating"
#define MOVIE_MOVIE_URL                     @"Movieurl"
#define MOVIE_THUMBNAIL_URLIS               @"thumbnail"
#define MOVIE_BANNER_URLIS                  @"banner"
#define MOVIE_iPHONEHOME_URLIS              @"iphonethumb"
#define MOVIE_iPADHOME_URLIS                @"ipadthumb"
#define MOVIE_TRAILER_URLIS                 @"TrailerURL"
#define MOVIE_AGERESTRICTIONMSG             @"AgeRestrictRating"


//by krishna
#pragma mark EventsList parser related constants

#define EVENTS                              @"EventDetails"
#define EVENT                               @"eventdetail"
#define EVENT_ID                            @"eventid"
#define EVENT_NAME                          @"eventname"
#define EVENT_DESCRIPTION                   @"EDescription"
#define EVENT_STARTDATE                     @"startDate"
#define EVENT_ENDDATE                       @"endDate"
#define EVENT_THUMBNAIL_URL                 @"thumbURL"
#define EVENT_STARTTIME                     @"StartTime"
#define EVENT_ENDTIME                       @"endTime"
#define EVENT_CATEGORY                      @"Category"
#define EVENT_CATEGORY_ID                   @"CategoryId"
#define EVENT_VENUEID                       @"VenueId"
#define EVENT_VENUENAME                     @"Venue"
#define EVENT_VENUEDETAILS                  @"VDescription"
#define EVENT_LOCATIONLATITUDE              @"Latitude"
#define EVENT_LOCATIONLONGITUDE             @"Longitude"
#define EVENT_ENTRYRESTRICTION              @"admission"
#define EVENT_ISALCHOLIE                    @"alochol"
#define EVENT_CONTACTPERSONNAME             @"ContactPerson"
#define EVENT_CONTECTPERSONEMAIL            @"ContactPersonEmail"
#define EVENT_CONTECTPERSONNUMBER           @"ContactPersonNo"
#define EVENT_SEATLAYOUT                    @"SeatLayout"
#define EVENT_NO_SEATLAYOUT                 @"noLayout"
#define EVENT_POSTERURL                     @"posterURL"
#define EVENT_COLOR_CODE                    @"colorcode"
#define EVENT_BG_COLOR_CODE                 @"bgcolorcode"
#define EVENT_BORDER_COLOR_CODE             @"bgbordercolorcode"
#define EVENT_BTN_COLOR_CODE                @"btncolorcode"
#define EVENT_TITLE_COLOR_CODE              @"titlecolorcode"
#define EVENTS_LAST_MODIFIED                @"date_modified"
#define EVENT_EVENTURL                      @"EventUrl"
#define EVENT_NO_OF_SEATS_FOR_CATEGORY      @"bookingType"
#define EVENT_EVENTSHARE_PATH               @"EventQTurlPath"
#define EVENT_BANNERURL                     @"bannerURL"
#define EVENT_TYPEOFEVENT                   @"EventType"
#define EVENT_CATEGORYURLIS                 @"categoryIcon"







#pragma mark Event TicketType related constants

#define TICKETDETAILS                       @"TicketDetails"
#define TICKET                              @"Ticket"
#define TICKET_MASTERID                     @"tktmasterid"
#define TICKET_PRICEID                      @"tktpriceid"
#define TICKET_TYPE                         @"TicketName"
#define TICKET_TOTAL_NOOF_TICKETS           @"TotalTickets"
#define TICKETS_NOOF_AVAILABLETICKETS       @"Availability"
#define TICKET_ADMIT                        @"Admit"
#define TICKET_TICKETPRICE                  @"TicketPrice"
#define TICKET_SERVICECHARGE                @"ServiceCharge"
#define TICKET_DATEASPERCATEGORY            @"Date"
#define TICKET_NOOFTICKETSPERTRANS          @"NoOfTicketsPerTransaction"
//new update
#define TICKET_FREE_PAID                    @"TicketType"



#pragma mark UserVoucher Details related constants

#define USERVOUCHERS                       @"UserEvouchers"
#define USER_VOUCHER                       @"Evoucher"
#define VOUCHER_ID                         @"id"
#define VOUCHER_VALUE                      @"voucherValue"
#define VOUCHER_BALANCEVALUE               @"balanceValue"
#define VOUCHER_GENERATIONDATE             @"generationDate"
#define VOUCHER_EXPIREDATE                 @"expireDate"
#define VOUCHER_STATUS                     @"voucherStatus"
#define VOUCHER_COUPONCODE                 @"couponCode"




#pragma MARK VoucherStatus related constants

#define CheckVoucher                      @"checkcouponstatus"
#define CheckVoucher_Coupons              @"Coupons"
#define CheckVoucher_CouponValidorNot     @"coupon"
#define CheckVoucher_CouponCode           @"couponCode"
#define CheckVoucher_Balance              @"balance"
//response objects
#define VoucherValidorNot                   @"ValidorNot"
#define VoucherBalance                      @"balance"
#define VoucherCode                         @"voucherCode"



#pragma mark --- for terms and conditons

#define Terms_Conditions                 @"Termsandcondition"
#define Terms_Conditions_conditions      @"conditions"
#define Conditons                        @"condition"




#pragma mark SHOWDATES PARSER RELATED CONSTANTS

#define SHOW_DATES                          @"ShowDates"
#define SHOW_DATE                           @"showDate"
#define SHOW_DATE_ID                        @"id"
#define DATE                                @"Date"

#pragma mark SHOWTIMES PARSER RELATED CONSTANTS

#define SHOW_TIMES                          @"ShowTimes"
#define SHOW_TIME                           @"showTime"
#define SHOW_TIME_ID                        @"id"
#define TIME                                @"time"
#define SHOW_TIME_AVALIABLE                 @"avaliable"
#define SHOW_TIME_AVAILABLE                 @"available"
#define SHOW_TIME_TOTALCOUNT                @"total"
#define SHOW_TIME_COMPLETED                 @"completed"
#define SHOW_TIME_DELAYED                   @"Delayed"
#define SHOW_TIME_SOLDOUT                   @"soldout"
#define SHOW_TIME_TYPE                      @"type"
#define SHOW_TIME_ENABLE                    @"enable"
#define SCREEN_ID                           @"screenId"
#define SCREEN_NAME                         @"screenName"


#pragma mark USERBOOKING PARSER RELATED CONSTANTS

#define BOOKING_HISTORIES                   @"BookingHistories"
#define BOOKING_HISTORY                     @"bookinghistory"
#define BOOKING_HISTORY_ID                  @"id"
#define BOOKING_HISTORY_MOVIE               @"movie"
#define BOOKING_HISTORY_THEATRE             @"theater"
#define BOOKING_HISTORY_AREA                @"area"
#define BOOKING_HISTORY_BOOKEDTIME          @"bookedtime"
#define BOOKING_HISTORY_SHOWDATE            @"showdate"
#define BOOKING_HISTORY_SEATS               @"seats"
#define BOOKING_HISTORY_SEATSCOUNT          @"seatsCount"
#define BOOKING_HISTORY_CONFIRMATION_CODE   @"confirmationCode"
#define BOOKING_HISTORY_BARCODEURL          @"barcodeURL"
#define BOOKING_HISTORY_TICKET_COST         @"ticket_Cost"
#define BOOKING_HISTORY_BOOKINGFEES         @"bookingfees"
#define BOOKING_HISTORY_TOTALCOST           @"total_Cost"
#define BOOKING_HISTORY_THUMBNAIL           @"movieImageURL"
#define BOOKING_HISTORY_MOVIEID             @"movieServerID"
#define USER_BOOKING_HISTORY                @"bookingHistory"
#define BOOKING_HISTORY_CHECKCANCELSTATUS   @"checkcancelstatus"
#define BOOKING_HISTRORY_BANNERURL          @"moviebannerURL"



#pragma mark THEATRE LAYOUT PARSER RELATED CONSTANTS

#define THEATER_SEAT_LAYOUT_CLASSES                                 @"Classes"
#define THEATER_SEAT_LAYOUT_CLASSES_MAX_BOOKING                     @"maxBooking"
#define THEATER_SEAT_LAYOUT_CLASSES_BOOKING_FEES                    @"bookingFees"
#define THEATER_SEAT_LAYOUT_CLASSES_FULL_SCREEN_URL                 @"url"

#define THEATER_SEAT_LAYOUT_CLASS                                   @"Class"
#define THEATER_SEAT_LAYOUT_CLASS_ID                                @"id"
#define THEATER_SEAT_LAYOUT_CLASS_NAME                              @"name"
#define THEATER_SEAT_LAYOUT_CLASS_COST                              @"cost"
#define THEATER_SEAT_LAYOUT_CLASS_NO_OF_ROWS                        @"noOfRows"

#define THEATER_SEAT_LAYOUT_ROW                                     @"Row"
#define THEATER_SEAT_LAYOUT_ROW_LETTER                              @"letter"
#define THEATER_SEAT_LAYOUT_ROW_NO_OF_SEATS                         @"noOfSeats"
#define THEATER_SEAT_LAYOUT_ROW_AVAILABLE_COUNT                     @"availableCount"
#define THEATER_SEAT_LAYOUT_ROW_AVAILABLE_SEATS                     @"Availableseats"
#define THEATER_SEAT_LAYOUT_ROW_ISFAMILY                            @"isFamily"
#define THEATER_SEAT_LAYOUT_ROW_IS_GANGWAY                          @"isGangway"
#define THEATER_SEAT_LAYOUT_ROW_GANGWAY_SEATS                       @"gangwaySeats"
#define THEATER_SEAT_LAYOUT_ROW_GANGWAY_COUNTS                      @"gangwayCounts"
#define THEATER_SEAT_LAYOUT_ROW_ALL_SEATS                           @"AllSeats"
#define THEATER_SEAT_LAYOUT_ROW_INITIAL_GANGWAY                     @"isInitialGangway"
#define THEATER_SEAT_LAYOUT_ROW_INITIAL_GANGWAY_COUNT               @"isInitialGangwayCount"

#pragma mark BLOCK SEATS QTICKETS

#define BLOCK_SEATS_TRANSACTION_ID                                            @"Transaction_Id"
#define BLOCK_SEATS_PAGE_SEESION_TIME                                         @"PageSessionTime"
#define BLOCK_SEATS_TRANSACTION_TIME                                          @"TransactionTime"
#define BLOCK_SEATS_TICKET_PRICE                                              @"ticketprice"
#define BLOCK_SEATS_SERVICE_CHARGES                                           @"servicecharges"
#define BLOCK_SEATS_TOTAL_PRICE                                               @"totalprice"
#define BLOCK_SEAT                                                            @"blockSeat"
#define  BLOCK_SEATS_CURRENCY                                                 @"currency"


#pragma mark SEAT LOCK REQUEST

#define SEAT_LOCK_USERID                                                     @"userid"
#define SEAT_LOCK_NAME                                                       @"name"
#define SEAT_LOCK_EMAIL                                                      @"emailID"
#define SEAT_LOCK_MOBILE                                                     @"mobile"
#define SEAT_LOCK_PREFIX                                                     @"prefix"
#define SEAT_LOCK_REQUESTED_TIMEIN_SEC                                       @"requestedtimeinsec"
#define SEAT_LOCK_TIMED_OUT_IN_MIN                                           @"timedoutinmins"




#pragma mark PAYMENT FOR PARSER RELATED TICKETS

#define PAYMENT_OBJ                     @"payment"
#define PAYMENT_TRANSACTION_RESPONSE    @"TxnResponseCode"


#pragma mark CONFIRM TICKETS

#define CONFIRM_OBJECT                  @"ConfirmTickets"
#define CONFIRM_TICKETS_TAG             @"confirm"
#define CONFIRM_RESERVATION_CODE        @"reservation_code"
#define CONFIRM_IMAGE                   @"image"
#define CONFIRM_QR_IMAGE                @"qr_image"
#define CONFIRM_MOVIE_NAME              @"movie_name"
#define CONFIRM_CINEMA_NAME             @"cinema_name"
#define CONFIRM_DATE_TIME               @"Date_time"
#define CONFIRM_SEAT_INFO               @"seatsinfo"
#define CONFIRM_SEAT_NAME               @"seatname"
#define CONFIRM_SCREEN_NAME             @"screenname"
#define CONFIRM_ISREGISTRATIONNOW       @"isregisternow"
#define CONFIRM_REGISTRATIONMESSAGE     @"registrationmessage"



#pragma mark LOGINVC RELATED  CONSTANT

#define ENTER_EMAIL_ID                                              @"Please Enter Email ID"
#define ENTER_PASSWORD                                              @"Please Enter Password"


#pragma mark REGISTRATIONVC RELATED CONSTANT

#define ENTER_FIRSTNAME                                             @"Please Enter First Name"
#define ENTER_LASTNAME                                              @"Please Enter Last Name"
#define ENTER_EMAILID                                               @"Please Enter Email ID"
#define ENTER_VALID_EMAILID                                         @"Please Enter Valid Email ID"
#define PLEASE_ENTER_PASSWORD                                       @"Please Enter Password"
#define PLEASE_ENTER_VALID_PASSWORD                                 @"Password must be greter than 6 characters"
#define ENTER_CONFIRM_PASSWORD                                      @"Please Enter Confirm Password"
#define ENTER_PHONE_NUMBER                                          @"Please Enter Phone Number"
#define ENTER_VALID_PHONE_NUMBER                                    @"Please Enter Valid Phone Number"
#define SELECT_PHONE_PREFIX                                         @"Please Select Your CountryCode"
#define MISSMATCH_OF_PASSWORDS                                      @"Missmatch of Password and Confirm Password"
#define SELECT_NATIONALITY                                          @"Please Select Nationality"


#pragma mark VERIFICATIONVC RELATED CONSTANT

#define ENTER_PHONE_VERIFICATION_CODE                               @"Please Enter Verification Code"
#define VERFICIATION_SUCCESSFULL                                    @"Verification Successfull"


#pragma mark BOOKINGHISTORYVC RELATED CONSTANTS

#define BOOKING_HISTORY_NOT_AVAILABLE                               @"Booking History data not avilable"
#define VOUCHERDETAILS_NOT_AVAILABLE                                @"User does't contains Vocuher"




#pragma mark CHANGEPASSWORD RELATED CONSTANTS

#define PLEASE_ENTER_OLD_PASSWORD                                   @"Please Enter Old Password"
#define PLEASE_ENTER_NEW_PASSWORD                                   @"Please Enter New Password"
#define PLEASE_ENTER_CONFIRM_PWD                                    @"Please Enter Confirm Password"
#define MISSMATCH_PWD                                               @"Missmatch of Password and confirm Password"
#define PWD_CHANGED_SUCCESSFULLY                                    @"Password Changed Successfull"

#pragma mark SEATLAYOUTVC RELATED CONSTANTS

#define SELECT_ATLEAST_ONE_SEAT                                     @"Select atleast one seat"
#define SELECT_ATLEAST_ONE_TICKETTYPE                                    @"Select atleast one tickettype"
#pragma mark USERDEATILVC RELATED CONSTANTS

#define ENTER_YOUR_NAME                                             @"Please Enter Your Name"
#define TRANSACTION_TIME_OUT                                        @"Transaction Time Out"
#define DO_YOU_CANCEL_TANSACTION                                    @"Do you want to cancel the transaction"
#define ENTER_VOUCHER_CODE                                          @"Please Enter Your CouponCode"
#define NAPS_DISABLED_MESSAGE                                       @"This service is temporarily unavailable due to maintenance  & enhancement activities. Sorry for the Inconvenience"

#define ENTER_RESERVATION_CODE                                     @"Please Enter Your ReservationCode"

#define ENTER_VALID_RESERVATION_CODE                                     @"Please Enter Valid ReservationCode"

#define SELECT_COUNTRY_CODE                                         @"Please Select Your CountryCode"

//
//#define CHANGEPWD_OLDPWD_TAG        70
//#define CHANGPWD_NEWPWD_TAG         71
//#define CHANGEPWD_CNFRMPWD_TAG      72


#pragma mark CARD DETAILSVC RELATED CONSTANTS

#define PLEASE_ENTER_NAME_ON_CARD                                   @"Please enter your name as on card"
#define PLEASE_ENTER_CARD_NUMEBR                                    @"Please enter your card number"
#define PLEASE_ENTER_VALID_CARD_NUMEBR                              @"Please enter valid card number"
#define PLEASE_ENTER_EXPIRY_DATE                                    @"Please enter expiry date of your card"
#define  PLEASE_ENTER_EXPIRY_MONTH                                  @"Please enter expiry month of your card"
#define PLEASE_ENTER_SCODE                                          @"Please enter CVV"
#define PLEASE_ENTER_VALID_SCODE                                    @"Please enter valid CVV"


#define MONTHS_PICKER   78
#define YEARS_PICKER    79

#pragma mark MOVIESLIST RELATED CONSTANTS




#pragma mark USER DETAIL CONSTANTS

#define CANCEL_ALERT                        54
#define BACK_ALERT                          55
#define TIMEOUT_ALERT                       56
#define SEATS_BOOKED_ALERT                  57
#define TRANSACTIONTIME_OUT                 58
#define SERVER_ERROR_ALERT                  59
#define USER_DETAIL_NAME_TAG                67
#define USER_DETAIL_EMAIL_TAG               68
#define USER_DETAIL_MOBILE_TAG              69
#define EVENT_TICKET_CANCEL_TAG             99

#pragma mark REGISTRATIONVC CONSTANTS




#pragma mark NETWORK ERROR/SUCCESS RELATED CONSTANTS

#define ALERT_NETWORK_ERROR_MESSAGE                         @"Network Error"
#define ALERT_ERROR_MESSAGE                                 @"Error Message"
#define ALERT_SUCCESS_MESSAGE                               @"Success Message"
#define ALERT_WARNING_MESSAGE                               @"Warning Message"
#define ALERT_WARNING_NO_RECORDS                            @"No Records Found."
#define ALERT_TITLE_WARNING                                 @"Warning"
#define ALERT_WARNING_NO_MOVIES_FOUND                       @"Movies Not Available"
#define ALERT_WARNING_NO_EVENTS_FOUND                       @"Events Not Available"
#define ALERT_WARNING_NO_THEATRES_FOUND                     @"Theaters Not Available"
#define ALERT_WARNING_NO_BOOKING_HISTORY                    @"Booking History Not Available"
#define ALERT_WARNING_NO_VOUCHERS                           @"User does't contain any Vouchers"


#pragma mark FONT SIZE CONSTANTS


#define FONT_SIZE_8                                 8
#define FONT_SIZE_10                                10
#define FONT_SIZE_12                                12
#define FONT_SIZE_14                                14
#define FONT_SIZE_15                                15
#define FONT_SIZE_16                                16
#define FONT_SIZE_17                                17
#define FONT_SIZE_18                                18
#define FONT_SIZE_20                                20
#define FONT_SIZE_21                                21
#define FONT_SIZE_22                                22
#define FONT_SIZE_24                                24
#define FONT_SIZE_26                                26
#define FONT_SIZE_30                                30





#pragma mark FONT NAME CONSTANTS

#define OPEN_SANS_CONDENSED_LIGHT                          @"OpenSans-CondensedLight"
#define OPEN_SANS_CONDENSED_BOLD                           @"OpenSans-CondensedBold"
#define ARIAL                                              @"Arial"
#define AGENCY_FB                                          @"AgencyFB-Bold"



#define LATO_BOLD                                          @"Lato-Bold"
#define LATO_REGULAR                                       @"Lato-Regular"
#define LATO_BLACKITALIC                                   @"Lato-BlackItalic"


#pragma mark DATE FORMATE RELATED CONSTANTS


#define DATE_FORMAT_YYYY_MM_DD          @"yyyy-MM-dd"
#define DATE_FORMAT_DD_MMM_YYYY         @"dd MMM yyyy"
#define DATE_FORMAT_MM_DD_YYYY         @"MM-dd-yyyy"
#define DATE_FORMAT_MMDDYYYY         @"MM/dd/yyyy"
#define DATE_FORMAT_DD_MM_YYYY         @"dd-MM-yyyy"


#pragma mark HTTP REQUEST CONSTANTS

#define HTTP_REQUEST_GET                        @"GET"
#define HTTP_REQUEST_POST                       @"POST"
#define HTTP_HEADER_CONTENT_LENGTH              @"Content-Length"
#define HTTP_HEADER_CONTENT_TYPE                @"Content-Type"
#define HTTP_HEADER_CONTENT_TYPE_VALUE          @"application/x-www-form-urlencoded"


#pragma mark Thumbnail Related Constants

#define THUMBNAIL_IMG_WIDTH                         305
#define THUMBNAIL_IMG_HEIGHT                        110


#pragma mark ERROR CODES

#define ERROR_IN_SERVER                             100
#define ERROR_IN_DATABASE                           101
#define USER_NOT_REGISTERED                         102
#define INCORRECT_PASSWORD                          103
#define LOGIN_SUCCESSFUL                            104
#define EMAIL_ALREADY_EXIST                         105
#define USER_REGISTRATION_SUCCESSFUL                106
#define WRONG_VERIFICATION_CODE                     107
#define ALREADY_VERIFIED                            108
#define VERIFIED_SUCCESSFULLY                       109
#define PASSWORD_CHANGED_SUCCESSFULLY               110
#define ERROR_IN_GENERATING_SALT                    111
#define PASSWORD_INCORRECT                          112
#define LOCK_CONFIRM                                119
#define SEND_LOCK_REQUEST_AGAIN                     118
#define PAYMENT_NOT_DONE                            115

#define mark ERROR MESSAGES

#define ERROR_MSG_ERROR_IN_SERVER                             @"ERROR IN SERVER"
#define ERROR_MSG_ERROR_IN_DATABASE                           @"ERROR IN DATABASE"
#define ERROR_MSG_USER_NOT_REGISTERED                         @"USER NOT REGISTERED"
#define ERROR_MSG_INCORRECT_PASSWORD                          @"INCORRECT PASSWORD"
#define ERROR_MSG_LOGIN_SUCCESSFUL                            @"LOGIN SUCCESSFULL"
#define ERROR_MSG_EMAIL_ALREADY_EXIST                         @"EMAIL ALREADY EXIST"
#define ERROR_MSG_USER_REGISTRATION_SUCCESSFUL                @"USER REGISTRATION SUCCESSFULL"
#define ERROR_MSG_WRONG_VERIFICATION_CODE                     @"WRONG VERIFICATION CODE"
#define ERROR_MSG_ALREADY_VERIFIED                            @"ALREADY VERIFIED"
#define ERROR_MSG_VERIFIED_SUCCESSFULLY                       @"VERIFIED SUCCESSFULLY"
#define ERROR_MSG_PASSWORD_CHANGED_SUCCESSFULLY               @"PASSWORD CHANGED SUCCESSFULLY"
#define ERROR_MSG_ERROR_IN_GENERATING_SALT                    @"ERROR IN GENERATING SALT"
#define ERROR_MSG_PASSWORD_INCORRECT                          @"PASSWORD INCORRECT"

#pragma mark MovieDetailVC tags

#define SHOW_TITLE_HEIGHT                     25
#define SHOW_TILE_WIDTH                       60
#define SHOW_TILE_HEIGHT                      30
#define SHOW_TILE_WIDTH_DIFF                  12
#define SHOW_TILE_HEIGHT_DIFF                 8
#define SHOW_NO_OF_VERTICAL_TILES             1
#define SHOW_NO_OF_HORIZONTAL_TILES           4  
#define SHOW_FIRST_TILE_X_VALUE               10
#define SHOW_FIRST_TILE_Y_VALUE               10





#pragma SeatLayoutVC Tags

#define SELECTED_SEAT_TAG                                               8001
#define SELECTED_SEAT_COST_TAG                                          8002
#define SELECTED_SEAT_MESSAGE_TAG                                       8003
#define SELECTED_SEAT_LIMIT_MESSAGE_TAG                                 8004





#define ContatUS @"https://www.q-tickets.com/contact-us.aspx"
#define TermsConditions @"https://www.q-tickets.com/privacy.aspx"
#define BackgroundImage [UIImage imageNamed:@"bg.png"]
#define BackgroundImage2x [UIImage imageNamed:@"bg@2x.png"]


#define ImgviewBorderColour [UIColor colorWithRed:0.74901 green:0.74901 blue:0.74901 alpha:1]

//user default constants

#define FromHome         @"fromHome"
#define FromMyBooings    @"fromMybookings"
#define FromMyProfile    @"fromMyprofile"
#define FromTicketCancel @"fromTicketCancel"
#define FromChangePwd    @"fromChangePwd"
#define FromMyVoucher    @"fromMyVoucher"




#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define USERDEFAULTSAVE [[NSUserDefaults standardUserDefaults] synchronize]

#define viewTitle [UIFont fontWithName:@"OpenSans-CondensedBold" size:15]

#define QTicketsAppDelegate (((AppDelegate*) [UIApplication sharedApplication].delegate))

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define ACCEPTABLE_NUMERICS @"0123456789"


#define QTA_SUMMER_FESTIVAL_EVENTID @"16"


#endif
