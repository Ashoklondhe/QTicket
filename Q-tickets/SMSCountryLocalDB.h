//
//  SMSCountryLocalDB.h
//  SMSCountry
//
//  Created by Tejasree on 05/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "UserVO.h"
#import "MovieVO.h"

@interface SMSCountryLocalDB : NSObject
{
    sqlite3                 *database;
}

@property (nonatomic) sqlite3 *database;


+ (SMSCountryLocalDB*) sharedManager;


#pragma mark
#pragma mark Private Methods
#pragma mark

+(void)openDatabase;
+(void)closeDatabase;
+(int)getLastRowIdForTable:(NSString *)tableName;


#pragma mark
#pragma mark Users related
#pragma mark

//nationality

+(BOOL)insertUser:(UserVO *)userVO;
+ (UserVO *) getLoggedInUser;
+(BOOL)deleteUser:(UserVO *)userVO;
+(BOOL)deleteAllUsers;
+(NSMutableArray *) getAllUsers;
+(BOOL)updateloginUserwithUserVO:(UserVO *)userVO;
+(BOOL)logInUser: (NSString *)serverId;
+(BOOL)logoutUser: (NSString *)serverId;
+(BOOL)isUserExists:(NSString *)serverId;
+(UserVO *)getUserExistWithEmailId:(NSString *)emailId andPassword:(NSString *)password;

#pragma mark
#pragma mark Movies related
#pragma mark

+(BOOL)insertMovie:(MovieVO *)movieVO;
+(BOOL)isMovieExists:(NSString *)serverId;
+(MovieVO *)getMovie:(NSString *)serverId;
+(BOOL) updateMovie:(MovieVO *)movieVO;
+(BOOL) deleteMovie:(MovieVO *)movieVO;
+(BOOL) deleteMovieByLocalId:(int)localMovieId;
+(BOOL) deleteMovieByServerId:(NSString *)serverId;
+(void) deleteAllMovies;
+(void) deleteMoviesArr:(NSMutableArray *)moviesArr;
+(NSMutableArray *)getAllMovies;
+(void)getMoreDetailsForMovieVO:(MovieVO *)tmpMovie;

#pragma mark
#pragma mark Movie Theatres related
#pragma mark

+(BOOL) insertMovieTheatre:(MovieTheatreVO *)movieTheatreVO movieId:(int)movieId;
+(NSMutableArray *)getMovieTheatresByLocalMovieId:(int)localMovieId;
+(BOOL) deleteMovieTheatreByLocalMovieId:(int)movieId;
+(BOOL) deleteMovieTheatre:(MovieTheatreVO *)movieTheatreVO;
+(BOOL) deleteMovieTheatreByLocalId:(int)localMovieTheatreId;
+(void) deleteMovieTheatres:(NSMutableArray *)movieTheatresArr;
+(void) deleteAllMovieTheatres;

#pragma mark
#pragma mark Theatres related
#pragma mark

+(BOOL) insertTheatre:(TheatreVO *)theatreVO;
+(BOOL) isTheatreExistsByTheatreServerId:(NSString *)theatreServerId;
+(TheatreVO *) getTheatreByTheatreServerId:(NSString *)theatreServerId;
+(BOOL) deleteTheatre:(TheatreVO *)theatreVO;
+(BOOL) deleteTheatreByServerId:(NSString *)serverId;
+(BOOL) deleteTheatreByLocalId:(int)localId;
+(NSMutableArray *)getAllTheatres;
+(void) deleteAllTheatres;

#pragma mark
#pragma mark ShowDates related
#pragma mark

+(BOOL) insertShowDate:(ShowDateVO *)showDateVO movieTheatreId:(int)movieTheatreId;
+(BOOL) isShowDateExists:(int)localMovieTheatreId andshowDateServerId:(NSString *)showDateServerId;
+(NSMutableArray *)getShowDatesIds:(int)localMovieTheatreId;
+(NSMutableArray *) getShowDatesByLocalMovieTheatreId:(int)localMovieTheatreId;
+(BOOL) updateShowDates:(id)showDateVO andLocalMovieTheatreId:(int)localMovieTheatreId;
+(BOOL) deleteShowDatesByLocalId:(int)localShowDateId;
+(BOOL) deleteShowDate:(ShowDateVO *)showDateVO;
+(BOOL) deleteShowDatesByServerId:(NSString *)serverId;
+(void) deleteAllShowDates;
+(void) deleteShowDates:(NSMutableArray *)showDatesArr;
+(NSMutableArray *)getAllShowDates;


#pragma mark
#pragma mark ShowTimes related
#pragma mark

+(BOOL) insertShowTimes:(ShowTimeVO *)showTimeVO showDateId:(int)showDateId;
+(BOOL) isShowTimeExists:(int)localShowDateId andshowTimeServerId:(NSString *)showTimeServerId;
+(NSMutableArray *)getShowTimesIds:(int)localShowDateId;
+(NSMutableArray *) getShowTimesByLocalShowDateId:(int)localShowDateId;
+(BOOL) updateShowTimes:(ShowTimeVO *) showTimeVO andLocalShowDateId:(int)localShowDateId;
+(BOOL) deleteShowTimeByLocalId:(int)localShowTimeId;
+(BOOL) deleteShowTime:(ShowTimeVO *)showTimeVO;
+(BOOL) deleteShowTimesByServerId:(NSString *)serverId;
+(void) deleteAllShowTimes;
+(void) deleteShowTimes:(NSMutableArray *)showTimesArr;
+(NSMutableArray *)getAllShowTimes;


#pragma mark
#pragma mark BookingHistory related
#pragma mark

+(NSMutableArray*)getAllBookedHistories;
+(NSMutableArray*)getBookedHistotyForlocalUserId:(NSString*)localuserId;
+(BookingHistoryVO *)getBookedHistoryByServerId:(NSString *)serverId;
+(BOOL)isBookingExists:(NSString*)serverId;
+(BOOL)insertBookedHistory:(BookingHistoryVO *)bHistrory forLocalUserId:(NSString*)uid;
+(void)insertAllBookingHistories:(NSMutableArray *)bookingHistoriesArr forUserId:(NSString *)uid;
+(BOOL)deleteBookedHistory:(int)bookingHistoryId;
+(void)deleteAllBookingHistoriesForUserId:(NSString *)uid;



//by krishna
#pragma mark
#pragma mark VoucherId Details  
#pragma mark




//VoucherDetails tb name :: serverid(integer),userid(interger),voucherValue(text),voucherBalanceValue(text),vouchergenerationDate(text),voucherexpireDate(text),VoucherStatus(text)


+(NSMutableArray *)getAllVouchers;
+(NSMutableArray *)getVoucherDetailsForlocalUserId:(NSString *)localuserId;
+(UserVoucherVO *)getVoucerDetailsbyServerId:(NSString *)ServerId;
+(BOOL)isVoucherExists:(NSString *)serverId;
+(BOOL)insertVoucherDetails:(UserVoucherVO *)VoucherDetails forLocalUserId:(NSString *)localUserid;
+(void)insertAllVoucherDetails:(NSMutableArray *)voucherDetailsArray forUserId:(NSString *)uid;
+(BOOL)deleteVoucherDetails:(int)voucherDetailsId;
+(void)deleteAllVoucherDetailsForUserId:(NSString *)uid;



@end
