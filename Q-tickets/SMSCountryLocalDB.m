//
//  SMSCountryLocalDB.m
//  SMSCountry
//
//  Created by Tejasree on 05/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "SMSCountryLocalDB.h"
#import "SMSCountryUtils.h"
#import "Q-ticketsConstants.h"

@interface SMSCountryLocalDB ()
{
    NSObject *tempVO;
}
@end


@implementation SMSCountryLocalDB

@synthesize database;

static SMSCountryLocalDB *sharedInstance = nil;
static sqlite3 *database;

-(void)dealloc
{
    [super dealloc];
}

+ (SMSCountryLocalDB*) sharedManager {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
	
}


- (id) copyWithZone: (NSZone *) zone {
    return self;
}

- (id) retain {
    return self;
}

- (NSUInteger) retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id) autorelease {
    return self;
}


#pragma mark
#pragma mark Private Methods
#pragma mark

+ (void)openDatabase {
    
	NSString *path = [SMSCountryUtils getDatabasePath];
	// Open the database, The database was prepared outside the application
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        
		// DB Opened
	} else {
		// Even though the open failed, call close to properly clean up resources.
		sqlite3_close(database);
		NSAssert1(0,@"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
    
  //  NSLog(@"opned database path :%@",path);
    
}

+ (void)closeDatabase {
    
    sqlite3_close(database);
    database = nil;
}

static sqlite3_stmt *get_last_row_id_stmt = nil;

+(int)getLastRowIdForTable:(NSString *)tableName {
    
    
    int lastInsertedRowid = 0;
    
    NSString * selectmaxid = [NSString stringWithFormat:@"SELECT MAX(ID) FROM %@",tableName];
    
    if(sqlite3_prepare_v2(database, [selectmaxid UTF8String], -1, &get_last_row_id_stmt, NULL) == SQLITE_OK)
    {
        sqlite3_step(get_last_row_id_stmt);
        if ((char *)sqlite3_column_text(get_last_row_id_stmt, 0) != NULL) {
            lastInsertedRowid = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(get_last_row_id_stmt, 0)] intValue];
        }
    }
    else
    {
    //    NSLog(@"Not able to execute your statement and an error");
    }
    
    sqlite3_finalize(get_last_row_id_stmt);
    
    return lastInsertedRowid;
}

#pragma mark
#pragma mark Users related
#pragma mark

static sqlite3_stmt *insert_user_stmt = nil;
static sqlite3_stmt *delete_user_stmt = nil;
static sqlite3_stmt *delete_all_users_stmt = nil;
static sqlite3_stmt *logged_in_user_stmt = nil;
static sqlite3_stmt *all_users_stmt = nil;
static sqlite3_stmt *update_login_user_stmt = nil;
static sqlite3_stmt *login_user_stmt = nil;
static sqlite3_stmt *logout_user_stmt = nil;
static sqlite3_stmt *user_exists_stmt=nil;
static sqlite3_stmt *user_email_exists_stmt=nil;

+(BOOL)insertUser:(UserVO *)userVO {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO Users(serverid, name,prefix, phone, address, email, password,verify,status, nationality) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &insert_user_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    sqlite3_bind_text(insert_user_stmt, 1, [[userVO serverId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_user_stmt, 2, [[userVO userName] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_user_stmt, 3, [[userVO prefix] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_user_stmt, 4, [[userVO phoneNumber] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_user_stmt, 5, [[userVO address] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_user_stmt, 6, [[userVO emailId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_user_stmt, 7, [[userVO password] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_user_stmt, 8, [[userVO verify] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(insert_user_stmt, 9, [userVO status]);
    sqlite3_bind_text(insert_user_stmt, 10, [[userVO nationality] UTF8String],-1,SQLITE_TRANSIENT);
    
    if (SQLITE_DONE != sqlite3_step(insert_user_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(insert_user_stmt);
    
    return YES;
}

+(UserVO *) getLoggedInUser {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    UserVO *tmpUser = nil;
    
    NSString *sql = @"select * from Users where status = 1";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &logged_in_user_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    while (sqlite3_step(logged_in_user_stmt) == SQLITE_ROW) {
        
        tmpUser = [[[UserVO alloc] init]autorelease];
        
        [tmpUser setLocalUserId:sqlite3_column_int(logged_in_user_stmt, 0)];
        
        [tmpUser setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(logged_in_user_stmt, 1)]];
        
        [tmpUser setUserName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(logged_in_user_stmt, 2)]];
        
        [tmpUser setPrefix:[NSString stringWithUTF8String:(char *)sqlite3_column_text(logged_in_user_stmt, 3)]];
        
        [tmpUser setPhoneNumber:[NSString stringWithUTF8String:(char *)sqlite3_column_text(logged_in_user_stmt, 4)]];
        
        [tmpUser setAddress:[NSString stringWithUTF8String:(char *)sqlite3_column_text(logged_in_user_stmt, 5)]];
        
        [tmpUser setEmailId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(logged_in_user_stmt, 6)]];
        
        [tmpUser setPassword:[NSString stringWithUTF8String:(char *)sqlite3_column_text(logged_in_user_stmt, 7)]];
        
        [tmpUser setVerify:[NSString stringWithUTF8String:(char *)sqlite3_column_text(logged_in_user_stmt, 8)]];
        
        [tmpUser setStatus:sqlite3_column_int(logged_in_user_stmt, 9)];
        
//       [tmpUser setNationality:[NSString stringWithUTF8String:(char *)sqlite3_column_text(logged_in_user_stmt, 10)]];

        
    }
    
    sqlite3_finalize(logged_in_user_stmt);
    
    return tmpUser;
}

+(BOOL) deleteUser:(UserVO *)userVO {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"delete from Users where id = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_user_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(delete_user_stmt, 1, userVO.localUserId);
    
    if (SQLITE_DONE != sqlite3_step(delete_user_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    sqlite3_finalize(delete_user_stmt);
    
    return YES;
}

+(BOOL)deleteAllUsers {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"DELETE from Users"];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_all_users_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    if (SQLITE_DONE != sqlite3_step(delete_all_users_stmt)) {
        NSAssert1(0,@"Error while deleting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_all_users_stmt);
    
    
    return YES;
}

+(NSMutableArray *) getAllUsers {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSMutableArray *usersArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from Users";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &all_users_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    while (sqlite3_step(all_users_stmt) == SQLITE_ROW) {
        
        UserVO  *tmpUser = [[UserVO alloc] init];
        
        [tmpUser setLocalUserId:sqlite3_column_int(all_users_stmt, 0)];
        
        [tmpUser setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_users_stmt, 1)]];
        
        [tmpUser setUserName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_users_stmt, 2)]];
        
        [tmpUser setPrefix:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_users_stmt, 3)]];
        
        
        [tmpUser setPhoneNumber:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_users_stmt, 4)]];
        
        [tmpUser setAddress:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_users_stmt, 5)]];
        
        [tmpUser setEmailId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_users_stmt, 6)]];
        
        [tmpUser setPassword:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_users_stmt, 7)]];
        
        [tmpUser setVerify:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_users_stmt, 8)]];
        
        [tmpUser setStatus:sqlite3_column_int(all_users_stmt, 9)];
        
        [tmpUser setNationality:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_users_stmt, 10)]];
        
        [usersArr addObject:tmpUser];
        [tmpUser release];
    }
    
    sqlite3_finalize(all_users_stmt);
    
    
    return usersArr;
}

+(BOOL)updateloginUserwithUserVO:(UserVO *)userVO{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"Update Users SET name = ?,prefix = ?,phone = ?,address = ?,email = ?,password =?,verify = ?,status = ? where serverid = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &update_login_user_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    sqlite3_bind_text(update_login_user_stmt, 1, [[userVO userName] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_login_user_stmt, 2, [[userVO prefix] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_login_user_stmt, 3, [[userVO phoneNumber] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_login_user_stmt, 4, [[userVO address] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_login_user_stmt, 5, [[userVO emailId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_login_user_stmt, 6, [[userVO password] UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(update_login_user_stmt, 7, [[userVO verify] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(update_login_user_stmt, 8,1);
    
    sqlite3_bind_text(update_login_user_stmt, 9, [[userVO serverId]UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(update_login_user_stmt, 10, [[userVO nationality] UTF8String], -1, SQLITE_TRANSIENT);

    
    
    if (SQLITE_DONE != sqlite3_step(update_login_user_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(update_login_user_stmt);
    
    
    return YES;
}

+(BOOL) logInUser:(NSString *)serverId {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"Update Users SET status = 1 where serverid = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &login_user_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(login_user_stmt, 1, [serverId UTF8String], -1, SQLITE_TRANSIENT);
    
    
    if (SQLITE_DONE != sqlite3_step(login_user_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(login_user_stmt);
    
    
    return YES;
}

+(BOOL) logoutUser:(NSString *)serverId {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"Update Users SET status = 0 where serverid = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &logout_user_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(logout_user_stmt, 1, [serverId UTF8String], -1, SQLITE_TRANSIENT);
    
    
    if (SQLITE_DONE != sqlite3_step(logout_user_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(logout_user_stmt);
    
    
    return YES;
}
+(BOOL)isUserExists:(NSString *)serverId {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString *sql = @"select * from Users where serverid = ?";
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &user_exists_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(user_exists_stmt, 1, [serverId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(user_exists_stmt) == SQLITE_ROW) {
        
        sqlite3_finalize(user_exists_stmt);
        
        return YES;
    }
    
    sqlite3_finalize(user_exists_stmt);
    
    return NO;
    
}

+(UserVO *)getUserExistWithEmailId:(NSString *)emailId andPassword:(NSString *)password
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    UserVO *tmpUser = nil;
    
    NSString *sql = @"select * from Users where email = ? AND password = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &user_email_exists_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(user_email_exists_stmt, 1, [emailId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(user_email_exists_stmt, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
    
    
    while (sqlite3_step(user_email_exists_stmt) == SQLITE_ROW) {
        
        tmpUser = [[[UserVO alloc] init]autorelease];
        
        [tmpUser setLocalUserId:sqlite3_column_int(user_email_exists_stmt, 0)];
        
        [tmpUser setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(user_email_exists_stmt, 1)]];
        
        [tmpUser setUserName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(user_email_exists_stmt, 2)]];
        
        [tmpUser setPhoneNumber:[NSString stringWithUTF8String:(char *)sqlite3_column_text(user_email_exists_stmt, 3)]];
        
        [tmpUser setAddress:[NSString stringWithUTF8String:(char *)sqlite3_column_text(user_email_exists_stmt, 4)]];
        
        [tmpUser setEmailId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(user_email_exists_stmt, 5)]];
        
        [tmpUser setPassword:[NSString stringWithUTF8String:(char *)sqlite3_column_text(user_email_exists_stmt, 6)]];
        
        [tmpUser setStatus:sqlite3_column_int(user_email_exists_stmt, 7)];
        
        [tmpUser setNationality:[NSString stringWithUTF8String:(char *)sqlite3_column_text(user_email_exists_stmt, 10)]];

    }
    
    sqlite3_finalize(user_email_exists_stmt);
    
    return tmpUser;
    
}
#pragma mark
#pragma mark Movies related Methods
#pragma mark

static sqlite3_stmt *insert_movie_stmt=nil;
static sqlite3_stmt *movie_exists_stmt=nil;
static sqlite3_stmt *movie_details_stmt=nil;
static sqlite3_stmt *modify_movie_stmt=nil;
static sqlite3_stmt *all_movie_details_stmt=nil;
static sqlite3_stmt *delete_localId_movie_stmt=nil;
static sqlite3_stmt *delete_serverId_movie_stmt=nil;
static sqlite3_stmt *delete_all_movies_stmt=nil;

+(BOOL)insertMovie:(MovieVO *)movieVO
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO Movies(serverId, movieName, releaseDate, thumbnailURL, language, censor, duration,description,movieType,cellColorCode,btnColorCode) VALUES (?, ?, ?, ?, ?, ?, ?,?,?,?,?)"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &insert_movie_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(insert_movie_stmt, 1, [[movieVO serverId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_movie_stmt, 2, [[movieVO movieName] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_movie_stmt, 3, [[movieVO releaseDate] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_movie_stmt, 4, [[movieVO thumbnailURL] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_movie_stmt, 5, [[movieVO language] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_movie_stmt, 6, [[movieVO censor] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_movie_stmt, 7, [[movieVO duration] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_movie_stmt, 8, [[movieVO description] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_movie_stmt, 9, [[movieVO movieType] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_movie_stmt, 10, [[movieVO colorcode] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_movie_stmt, 11, [[movieVO btncolorcode] UTF8String], -1, SQLITE_TRANSIENT);
    
    if (SQLITE_DONE != sqlite3_step(insert_movie_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(insert_movie_stmt);
    
    
    // here get last inserted row id for Movies table, and then insert theatres.
    
    int moviesLastRowId = [self getLastRowIdForTable:@"Movies"];
    
    [movieVO.movieTheatresArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MovieTheatreVO *tmpMovieTheatreVO = (MovieTheatreVO *)obj;
        
        [self insertMovieTheatre:tmpMovieTheatreVO movieId:moviesLastRowId];
        
    }];
    
    return YES;
}

+(BOOL)isMovieExists:(NSString *)serverId {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString *sql = @"select * from Movies where serverId = ?";
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &movie_exists_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(movie_exists_stmt, 1, [serverId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(movie_exists_stmt) == SQLITE_ROW) {
        
        sqlite3_finalize(movie_exists_stmt);
        
        return YES;
    }
    
    sqlite3_finalize(movie_exists_stmt);
    
    return NO;
    
}
+(MovieVO *)getMovie:(NSString *)serverId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    MovieVO *tmpMovie = nil;
    
    NSString *sql = @"select * from Movies where serverId = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &movie_details_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(movie_details_stmt, 1,[serverId UTF8String],-1,SQLITE_TRANSIENT);
    
    while (sqlite3_step(movie_details_stmt) == SQLITE_ROW) {
        
        tmpMovie = [[[MovieVO alloc] init]autorelease];
        
        [tmpMovie setLocalMovieId:sqlite3_column_int(movie_details_stmt, 0)];
        
        [tmpMovie setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt, 1)]];
        
        [tmpMovie setMovieName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt, 2)]];
        
        [tmpMovie setReleaseDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt, 3)]];
        
        [tmpMovie setThumbnailURL:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt, 4)]];
        
        [tmpMovie setLanguage:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt, 5)]];
        
        [tmpMovie setCensor:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt, 6)]];
        
        [tmpMovie setDuration:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt, 7)]];
        
        [tmpMovie setDescription:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt,8)]];
        
        [tmpMovie setMovieType:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt,9)]];
        
        [tmpMovie setColorcode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt,10)]];
        
        [tmpMovie setBtncolorcode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(movie_details_stmt,11)]];
        
    }
    
    sqlite3_finalize(movie_details_stmt);
    
    // get more details for movie object
    [self getMoreDetailsForMovieVO:tmpMovie];
    
    return tmpMovie;
    
    
}
+(BOOL) updateMovie:(MovieVO *)movieVO
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString *sql = @"update Movies set movieName = ?, releaseDate = ? , thumbnailURL = ? , language = ? , censor = 1, duration = ?,description=?,movieType=?, cellColorCode=?, btnColorCode=? where serverId = ?";
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &modify_movie_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    sqlite3_bind_text(modify_movie_stmt, 1, [[movieVO movieName] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_movie_stmt, 2, [[movieVO releaseDate] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_movie_stmt, 3, [[movieVO thumbnailURL] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_movie_stmt, 4, [[movieVO language] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_movie_stmt, 5, [[movieVO censor] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_movie_stmt, 6, [[movieVO duration] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_movie_stmt, 7, [[movieVO description] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_movie_stmt, 8, [[movieVO movieType] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_movie_stmt, 9, [[movieVO serverId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_movie_stmt, 10, [[movieVO colorcode] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_movie_stmt, 11, [[movieVO btncolorcode] UTF8String], -1, SQLITE_TRANSIENT);
    
    
    if (SQLITE_DONE != sqlite3_step(modify_movie_stmt)) {
        
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(modify_movie_stmt);
    
    return YES;
    
}

+(void)deleteAllMovies
{
    [self deleteAllShowTimes];
    [self deleteAllShowDates];
    [self deleteAllMovieTheatres];
    
    NSString * sql = [NSString stringWithFormat:@"DELETE from Movies"];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_all_movies_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    if (SQLITE_DONE != sqlite3_step(delete_all_movies_stmt)) {
        NSAssert1(0,@"Error while deleting data %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(delete_all_movies_stmt);
    
}

+(NSMutableArray *)getAllMovies
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    MovieVO *tmpMovie = nil;
    NSMutableArray *moviesArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from Movies";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &all_movie_details_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    while (sqlite3_step(all_movie_details_stmt) == SQLITE_ROW) {
        
        tmpMovie = [[MovieVO alloc] init];
        
        [tmpMovie setLocalMovieId:sqlite3_column_int(all_movie_details_stmt, 0)];
        
        [tmpMovie setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt, 1)]];
        
        [tmpMovie setMovieName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt, 2)]];
        
        [tmpMovie setReleaseDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt, 3)]];
        
        [tmpMovie setThumbnailURL:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt, 4)]];
        
        [tmpMovie setLanguage:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt, 5)]];
        
        [tmpMovie setCensor:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt, 6)]];
        
        [tmpMovie setDuration:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt, 7)]];
        
        [tmpMovie setDescription:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt,8)]];
        
        [tmpMovie setMovieType:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt,9)]];
        
        [tmpMovie setColorcode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt,10)]];
        
        [tmpMovie setBtncolorcode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_movie_details_stmt,11)]];
        
        
        [moviesArr addObject:tmpMovie];
        [tmpMovie release];
    }
    
    sqlite3_finalize(all_movie_details_stmt);
    
    // get more details for each of the movie object
    [moviesArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MovieVO *tmpMovie = (MovieVO *)obj;
        [self getMoreDetailsForMovieVO:tmpMovie];
    }];
    
    return moviesArr;
}

+(void)getMoreDetailsForMovieVO:(MovieVO *)tmpMovie {
    // get the movie theatres
    NSMutableArray *tmpMovieTheatresArr = [self getMovieTheatresByLocalMovieId:tmpMovie.localMovieId];
    
    [tmpMovieTheatresArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // looping each movie theatre to get the theatre details from Theatres table
        MovieTheatreVO *tmpMovieTheatre = (MovieTheatreVO *)obj;
        
        TheatreVO *tmpTheatre = [self getTheatreByTheatreServerId:tmpMovieTheatre.serverId];
        
        [tmpMovieTheatre setLocalTheatreId:tmpTheatre.localTheatreId];
        [tmpMovieTheatre setTheatreName:tmpTheatre.theatreName];
        [tmpMovieTheatre setPhone:tmpTheatre.phone];
        [tmpMovieTheatre setAddress:tmpTheatre.address];
        
        // get show dates arr for each Movie theatre
        NSMutableArray *tmpShowDatesArr = [self getShowDatesByLocalMovieTheatreId:tmpMovieTheatre.localMovieTheatreId];
        
        [tmpShowDatesArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            ShowDateVO *tmpShowDate = (ShowDateVO *)obj;
            
            // get show times arr for each show date
            NSMutableArray *tmpShowTimesArr = [self getShowTimesByLocalShowDateId:tmpShowDate.localShowDateId];
            
            [tmpShowDate setShowTimesArr:tmpShowTimesArr];
        }];
        
        [tmpMovieTheatre setShowDatesArr:tmpShowDatesArr];
        
    }];
    
    [tmpMovie setMovieTheatresArr:tmpMovieTheatresArr];
}

+(void)deleteMoviesArr:(NSMutableArray *)moviesArr
{
    [moviesArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self deleteMovie:obj];
    }];
}

+(BOOL)deleteMovie:(MovieVO *)movieVO
{
    if (movieVO.localMovieId!=0)
    {
        [self deleteMovieByLocalId:movieVO.localMovieId];
        return YES;
    }
    else if(movieVO.serverId!=nil)
    {
        [self deleteMovieByServerId:movieVO.serverId];
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)deleteMovieByLocalId:(int)localMovieId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"delete from Movies where id = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_localId_movie_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(delete_localId_movie_stmt, 1, localMovieId);
    
    
    if (SQLITE_DONE != sqlite3_step(delete_localId_movie_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_localId_movie_stmt);
    
    return YES;
    
}
+(BOOL)deleteMovieByServerId:(NSString *)serverId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"delete from Movies where serverId = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_serverId_movie_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(delete_serverId_movie_stmt,1,[serverId UTF8String],-1,SQLITE_TRANSIENT);
    
    
    if (SQLITE_DONE != sqlite3_step(delete_serverId_movie_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_serverId_movie_stmt);
    
    return YES;
    
}

#pragma mark
#pragma mark Movie Theatres related
#pragma mark

static sqlite3_stmt *insert_movie_theatre_stmt=nil;
static sqlite3_stmt *get_movie_theatre_by_local_id_stmt=nil;
static sqlite3_stmt *delete_movie_theatre_by_local_id=nil;
static sqlite3_stmt *delete_movie_theatre_by_local_movie_id=nil;
static sqlite3_stmt *delete_all_movie_theatres=nil;

+(BOOL) insertMovieTheatre:(MovieTheatreVO *)movieTheatreVO movieId:(int)movieId {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO MovieTheatres(movieId, theatreServerId) VALUES (?, ?)"];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &insert_movie_theatre_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    sqlite3_bind_int(insert_movie_theatre_stmt,  1,movieId);
    sqlite3_bind_text(insert_movie_theatre_stmt, 2, [[movieTheatreVO serverId] UTF8String], -1, SQLITE_TRANSIENT);
    
    if (SQLITE_DONE != sqlite3_step(insert_movie_theatre_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(insert_movie_theatre_stmt);
    
    
    // here get last inserted row id for MovieTheatres table, and then insert Show Dates.
    
    int movieTheatreLastRowId = [self getLastRowIdForTable:@"MovieTheatres"];
    
    [movieTheatreVO.showDatesArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ShowDateVO *tmpShowDateVO = (ShowDateVO *)obj;
        
        [self insertShowDate:tmpShowDateVO movieTheatreId:movieTheatreLastRowId];
        
    }];
    
    return YES;
}

+(NSMutableArray *)getMovieTheatresByLocalMovieId:(int)localMovieId {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    MovieTheatreVO *tmpTheatreVO = nil;
    NSMutableArray *movieTheatresArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from MovieTheatres where movieId = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &get_movie_theatre_by_local_id_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(get_movie_theatre_by_local_id_stmt, 1, localMovieId);
    
    while (sqlite3_step(get_movie_theatre_by_local_id_stmt) == SQLITE_ROW) {
        
        tmpTheatreVO = [[MovieTheatreVO alloc] init];
        
        [tmpTheatreVO setLocalMovieTheatreId:sqlite3_column_int(get_movie_theatre_by_local_id_stmt, 0)];
        
        [tmpTheatreVO setMovieId:sqlite3_column_int(get_movie_theatre_by_local_id_stmt, 1)];
        
        [tmpTheatreVO setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(get_movie_theatre_by_local_id_stmt, 2)]];
        
        [movieTheatresArr addObject:tmpTheatreVO];
        [tmpTheatreVO release];
    }
    
    sqlite3_finalize(get_movie_theatre_by_local_id_stmt);
    
    
    return movieTheatresArr;
}

+(BOOL) deleteMovieTheatreByLocalMovieId:(int)movieId {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"delete from MovieTheatres where movieId = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_movie_theatre_by_local_movie_id, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(delete_movie_theatre_by_local_movie_id, 1, movieId);
    
    if (SQLITE_DONE != sqlite3_step(delete_movie_theatre_by_local_movie_id)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_movie_theatre_by_local_movie_id);
    
    return YES;
}

+(BOOL) deleteMovieTheatre:(MovieTheatreVO *)movieTheatreVO {
    
    if (movieTheatreVO.localMovieTheatreId!=0)
    {
        [self deleteMovieTheatreByLocalId:movieTheatreVO.localMovieTheatreId];
        return YES;
    }
    else if(movieTheatreVO.movieId!=0)
    {
        [self deleteMovieTheatreByLocalMovieId:movieTheatreVO.movieId];
        return YES;
    }
    return NO;
}

+(BOOL) deleteMovieTheatreByLocalId:(int)localMovieTheatreId {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"delete from MovieTheatres where id = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_movie_theatre_by_local_id, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(delete_movie_theatre_by_local_id, 1, localMovieTheatreId);
    
    if (SQLITE_DONE != sqlite3_step(delete_movie_theatre_by_local_id)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_movie_theatre_by_local_id);
    
    return YES;
}

+(void) deleteMovieTheatres:(NSMutableArray *)movieTheatresArr {
    
    [movieTheatresArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self deleteMovieTheatre:obj];
    }];
}

+(void) deleteAllMovieTheatres {
    
    NSString * sql = [NSString stringWithFormat:@"DELETE from MovieTheatres"];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_all_movie_theatres, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    if (SQLITE_DONE != sqlite3_step(delete_all_movie_theatres)) {
        NSAssert1(0,@"Error while deleting data %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(delete_all_movie_theatres);
}

#pragma mark
#pragma mark Theatres related Methods
#pragma mark

static sqlite3_stmt *insert_theatre_stmt=nil;
static sqlite3_stmt *theatre_exists_stmt=nil;
static sqlite3_stmt *theatre_by_serverid_stmt=nil;
static sqlite3_stmt *all_theatre_details_stmt=nil;
static sqlite3_stmt *delete_localId_theatre_stmt=nil;
static sqlite3_stmt *delete_serverId_theatre_stmt=nil;
static sqlite3_stmt *delete_all_theatres_stmt=nil;

+(BOOL) insertTheatre:(TheatreVO *)theatreVO
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO Theatres(serverid, name, address, phone) VALUES (?, ?, ?, ?)"];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &insert_theatre_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    sqlite3_bind_text(insert_theatre_stmt, 1, [[theatreVO serverId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_theatre_stmt, 2, [[theatreVO theatreName] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_theatre_stmt, 3, [[theatreVO address] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_theatre_stmt, 4, [[theatreVO phone] UTF8String], -1, SQLITE_TRANSIENT);
    
    if (SQLITE_DONE != sqlite3_step(insert_theatre_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(insert_theatre_stmt);
    
    return YES;
    
}
+(BOOL) isTheatreExistsByTheatreServerId:(NSString *)theatreServerId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString *sql = @"select * from Theaters where serverId = ?";
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &theatre_exists_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(theatre_exists_stmt, 1, [theatreServerId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(theatre_exists_stmt) == SQLITE_ROW) {
        
        sqlite3_finalize(theatre_exists_stmt);
        
        return YES;
    }
    
    sqlite3_finalize(theatre_exists_stmt);
    
    return NO;
}

+(TheatreVO *) getTheatreByTheatreServerId:(NSString *)theatreServerId {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    TheatreVO *tmpTheatre = [[[TheatreVO alloc] init] autorelease];
    
    NSString *sql = @"select * from Theatres where serverId = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &theatre_by_serverid_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(theatre_by_serverid_stmt, 1, [theatreServerId UTF8String], -1, SQLITE_TRANSIENT);
    
    
    while (sqlite3_step(theatre_by_serverid_stmt) == SQLITE_ROW)
    {
        
        [tmpTheatre setLocalTheatreId:sqlite3_column_int(theatre_by_serverid_stmt, 0)];
        [tmpTheatre setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(theatre_by_serverid_stmt, 1)]];
        [tmpTheatre setTheatreName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(theatre_by_serverid_stmt, 2)]];
        [tmpTheatre setAddress:[NSString stringWithUTF8String:(char *)sqlite3_column_text(theatre_by_serverid_stmt, 3)]];
        [tmpTheatre setPhone:[NSString stringWithUTF8String:(char *)sqlite3_column_text(theatre_by_serverid_stmt, 4)]];
    }
    sqlite3_finalize(theatre_by_serverid_stmt);
    
    return tmpTheatre;
}

+(NSMutableArray *)getAllTheatres
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    TheatreVO *tmpTheatre = nil;
    NSMutableArray *theatresArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from Theatres";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &all_theatre_details_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    while (sqlite3_step(all_theatre_details_stmt) == SQLITE_ROW) {
        
        tmpTheatre = [[TheatreVO alloc] init];
        
        [tmpTheatre setLocalTheatreId:sqlite3_column_int(all_theatre_details_stmt, 0)];
        
        [tmpTheatre setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_theatre_details_stmt, 1)]];
        
        [tmpTheatre setTheatreName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_theatre_details_stmt, 2)]];
        
        [tmpTheatre setAddress:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_theatre_details_stmt, 3)]];
        
        [tmpTheatre setPhone:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_theatre_details_stmt, 4)]];
        
        
        [theatresArr addObject:tmpTheatre];
        [tmpTheatre release];
    }
    
    sqlite3_finalize(all_theatre_details_stmt);
    
    return theatresArr;
}

+(BOOL) deleteTheatre:(TheatreVO *)theatreVO
{
    if (theatreVO.localTheatreId!=0)
    {
        [self deleteTheatreByLocalId:theatreVO.localTheatreId];
    }
    else if(theatreVO.serverId!=nil)
    {
        [self deleteTheatreByServerId:theatreVO.serverId];
    }
    
    return NO;
}


+(BOOL) deleteTheatreByLocalId:(int)localTheatreId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"delete from Theatres where id = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_localId_theatre_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(delete_localId_theatre_stmt, 1, localTheatreId);
    
    
    if (SQLITE_DONE != sqlite3_step(delete_localId_theatre_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_localId_theatre_stmt);
    
    return YES;
}

+(BOOL) deleteTheatreByServerId:(NSString *)serverId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"delete from Theatres where serverId = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_serverId_theatre_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(delete_serverId_theatre_stmt,1,[serverId UTF8String],-1,SQLITE_TRANSIENT);
    
    
    if (SQLITE_DONE != sqlite3_step(delete_serverId_theatre_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_serverId_theatre_stmt);
    
    return YES;
}

+(void) deleteAllTheatres {
    
    NSString * sql = [NSString stringWithFormat:@"DELETE from Theatres"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_all_theatres_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    if (SQLITE_DONE != sqlite3_step(delete_all_theatres_stmt)) {
        NSAssert1(0,@"Error while deleting data %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(delete_all_theatres_stmt);
    
}

#pragma mark
#pragma mark ShowDates related Methods
#pragma mark

static sqlite3_stmt *insert_showdates_stmt=nil;
static sqlite3_stmt *showdate_exists_stmt=nil;
static sqlite3_stmt *showdate_ids_stmt=nil;
static sqlite3_stmt *showdate_details_stmt=nil;
static sqlite3_stmt *modify_showdate_stmt=nil;
static sqlite3_stmt *all_showdates_details_stmt=nil;
static sqlite3_stmt *delete_localId_showdate_stmt=nil;
static sqlite3_stmt *delete_serverId_showdate_stmt=nil;
static sqlite3_stmt *delete_all_show_dates_stmt=nil;

+(BOOL) insertShowDate:(ShowDateVO *)showDateVO movieTheatreId:(int)movieTheatreId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO ShowDates(serverid, movieTheatreId, showDate) VALUES (?, ?, ?)"];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &insert_showdates_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    sqlite3_bind_text(insert_showdates_stmt, 1, [[showDateVO serverId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(insert_showdates_stmt,2,movieTheatreId);
    sqlite3_bind_text(insert_showdates_stmt, 3, [[showDateVO showDate] UTF8String], -1, SQLITE_TRANSIENT);
    
    
    if (SQLITE_DONE != sqlite3_step(insert_showdates_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(insert_showdates_stmt);
    
    
    // here get last inserted row id for ShowDates table, and then insert Show Times.
    
    int showDateLastRowId = [self getLastRowIdForTable:@"ShowDates"];
    
    [showDateVO.showTimesArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ShowTimeVO *tmpShowTimeVO = (ShowTimeVO *)obj;
        
        [self insertShowTimes:tmpShowTimeVO showDateId:showDateLastRowId];
        
    }];
    
    return YES;
    
}
+(BOOL) isShowDateExists:(int)localMovieTheatreId andshowDateServerId:(NSString *)showDateServerId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString *sql = @"select * from ShowDates where movieTheatreId = ? AND serverId = ?";
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &showdate_exists_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(showdate_exists_stmt, 1,localMovieTheatreId);
    sqlite3_bind_text(showdate_exists_stmt, 2, [showDateServerId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(showdate_exists_stmt) == SQLITE_ROW) {
        
        sqlite3_finalize(showdate_exists_stmt);
        
        return YES;
    }
    
    sqlite3_finalize(showdate_exists_stmt);
    
    return NO;
    
    
}
+(NSMutableArray *)getShowDatesIds:(int)localMovieTheatreId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSMutableArray *showDateArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select serverId from ShowDates where movieTheatreId = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &showdate_ids_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(showdate_ids_stmt, 1,localMovieTheatreId);
    
    while (sqlite3_step(showdate_ids_stmt) == SQLITE_ROW) {
        
        ShowDateVO *tmpShowDate=[[ShowDateVO alloc]init];
        
        [tmpShowDate setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(showdate_ids_stmt, 1)]];
        
        [showDateArr addObject:tmpShowDate];
        [tmpShowDate release];
    }
    
    sqlite3_finalize(showdate_ids_stmt);
    return showDateArr;
    
}
+(NSMutableArray *) getShowDatesByLocalMovieTheatreId:(int)localMovieTheatreId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSMutableArray *showDateArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from ShowDates where movieTheatreId = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &showdate_details_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(showdate_details_stmt, 1,localMovieTheatreId);
    
    
    while (sqlite3_step(showdate_details_stmt) == SQLITE_ROW) {
        
        
        ShowDateVO *tmpShowDate=[[ShowDateVO alloc]init];
        
        [tmpShowDate setLocalShowDateId:sqlite3_column_int(showdate_details_stmt, 0)];
        
        [tmpShowDate setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(showdate_details_stmt, 1)]];
        
        [tmpShowDate setShowDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(showdate_details_stmt, 3)]];
        
        
        [showDateArr addObject:tmpShowDate];
        [tmpShowDate release];
    }
    
    sqlite3_finalize(showdate_details_stmt);
    
    return showDateArr;
    
    
}
+(BOOL) updateShowDates:(id)showDateVO andLocalMovieTheatreId:(int)localMovieTheatreId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString *sql = @"update ShowDates set showDate = ? where serverId = ? AND movieTheatreId = ?";
    
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &modify_showdate_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    sqlite3_bind_text(modify_showdate_stmt, 1, [[showDateVO showDate] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_showdate_stmt, 2, [[showDateVO serverId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(modify_showdate_stmt,3,localMovieTheatreId);
    
    if (SQLITE_DONE != sqlite3_step(modify_showdate_stmt)) {
        
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(modify_showdate_stmt);
    
    
    return YES;
    
    
}
+(void) deleteAllShowDates
{
    NSString * sql = [NSString stringWithFormat:@"DELETE from ShowDates"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_all_show_dates_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    if (SQLITE_DONE != sqlite3_step(delete_all_show_dates_stmt)) {
        NSAssert1(0,@"Error while deleting data %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(delete_all_show_dates_stmt);
}

+(NSMutableArray *)getAllShowDates
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSMutableArray *showDatesArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from ShowDates";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &all_showdates_details_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    while (sqlite3_step(all_showdates_details_stmt) == SQLITE_ROW) {
        
        ShowDateVO *tmpShowDate=[[ShowDateVO alloc]init];
        
        [tmpShowDate setLocalShowDateId:sqlite3_column_int(all_showdates_details_stmt, 0)];
        
        [tmpShowDate setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_showdates_details_stmt, 1)]];
        
        [tmpShowDate setShowDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_showdates_details_stmt, 3)]];
        
        [showDatesArr addObject:tmpShowDate];
        [tmpShowDate release];
        
    }
    
    sqlite3_finalize(all_showdates_details_stmt);
    
    return showDatesArr;
}

+(void) deleteShowDates:(NSMutableArray *)showDatesArr
{
    [showDatesArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self deleteShowDate:obj];
    }];
    
}
+(BOOL) deleteShowDate:(ShowDateVO *)showDateVO
{
    if (showDateVO.localShowDateId!=0)
    {
        [self deleteTheatreByLocalId:showDateVO.localShowDateId];
        return YES;
    }
    else if(showDateVO.serverId!=nil)
    {
        [self deleteTheatreByServerId:showDateVO.serverId];
        return YES;
    }
    
    return NO;
}
+(BOOL) deleteShowDatesByLocalId:(int)localShowDateId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"delete from ShowDates where id = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_localId_showdate_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(delete_localId_showdate_stmt, 1, localShowDateId);
    
    
    if (SQLITE_DONE != sqlite3_step(delete_localId_showdate_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_localId_showdate_stmt);
    
    return YES;
    
    
}

+(BOOL) deleteShowDatesByServerId:(NSString *)serverId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"delete from ShowDates where serverId = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_serverId_showdate_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(delete_serverId_showdate_stmt,1,[serverId UTF8String],-1,SQLITE_TRANSIENT);
    
    
    if (SQLITE_DONE != sqlite3_step(delete_serverId_showdate_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_serverId_showdate_stmt);
    
    return YES;
    
}

#pragma mark
#pragma mark ShowTimes related
#pragma mark

static sqlite3_stmt *insert_showtimes_stmt=nil;
static sqlite3_stmt *showtime_exists_stmt=nil;
static sqlite3_stmt *showtime_ids_stmt=nil;
static sqlite3_stmt *showtime_details_stmt=nil;
static sqlite3_stmt *modify_showtime_stmt=nil;
static sqlite3_stmt *all_showtimes_details_stmt=nil;
static sqlite3_stmt *delete_localId_showtime_stmt=nil;
static sqlite3_stmt *delete_serverId_showtime_stmt=nil;
static sqlite3_stmt *delete_all_show_times_stmt=nil;

+(BOOL) insertShowTimes:(ShowTimeVO *)showTimeVO showDateId:(int)showDateId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO ShowTimes(serverid, showDateId, showTime,screenId,screenName,enable,type) VALUES (?, ?, ?, ?, ?, ?, ?)"];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &insert_showtimes_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    sqlite3_bind_text(insert_showtimes_stmt, 1, [[showTimeVO serverId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(insert_showtimes_stmt,2,showDateId);
    sqlite3_bind_text(insert_showtimes_stmt, 3, [[showTimeVO showTime] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_showtimes_stmt, 4, [[showTimeVO screenId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_showtimes_stmt, 5, [[showTimeVO screenName] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_showtimes_stmt, 6, [[showTimeVO isEnable] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_showtimes_stmt, 7, [[showTimeVO showType] UTF8String], -1, SQLITE_TRANSIENT);
    
    
    
    if (SQLITE_DONE != sqlite3_step(insert_showtimes_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    
    sqlite3_finalize(insert_showtimes_stmt);
    
    return YES;
    
}
+(BOOL) isShowTimeExists:(int)localShowDateId andshowTimeServerId:(NSString *)showTimeServerId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString *sql = @"select * from ShowTimes where showDateId = ? AND serverId = ?";
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &showtime_exists_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(showtime_exists_stmt, 1,localShowDateId);
    sqlite3_bind_text(showtime_exists_stmt, 2, [showTimeServerId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(showtime_exists_stmt) == SQLITE_ROW) {
        
        sqlite3_finalize(showtime_exists_stmt);
        
        
        return YES;
    }
    
    sqlite3_finalize(showtime_exists_stmt);
    
    return NO;
    
}
+(NSMutableArray *)getShowTimesIds:(int)localShowDateId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSMutableArray *showtimeArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select serverId from ShowTimes where showDateId = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &showtime_ids_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(showtime_ids_stmt, 1,localShowDateId);
    
    while (sqlite3_step(showtime_ids_stmt) == SQLITE_ROW) {
        
        
        ShowTimeVO *tmpShowTime=[[ShowTimeVO alloc]init];
        
        [tmpShowTime setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(showtime_ids_stmt, 1)]];
        
        [showtimeArr addObject:tmpShowTime];
        [tmpShowTime release];
        
        
    }
    
    sqlite3_finalize(showtime_ids_stmt);
    return showtimeArr;
    
    
}
+(NSMutableArray *) getShowTimesByLocalShowDateId:(int)localShowDateId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSMutableArray *showtimeArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from ShowTimes where showDateId = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &showtime_details_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(showtime_details_stmt, 1,localShowDateId);
    
    
    while (sqlite3_step(showtime_details_stmt) == SQLITE_ROW)
    {
        ShowTimeVO *tmpShowTime=[[[ShowTimeVO alloc]init]autorelease];
        
        [tmpShowTime setLocalShowTimeId:sqlite3_column_int(showtime_details_stmt, 0)];
        [tmpShowTime setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(showtime_details_stmt, 1)]];
        [tmpShowTime setShowTime:[NSString stringWithUTF8String:(char *)sqlite3_column_text(showtime_details_stmt,3)]];
        [tmpShowTime setScreenId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(showtime_details_stmt,4)]];
        [tmpShowTime setScreenName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(showtime_details_stmt,5)]];
        [tmpShowTime setIsEnable:[NSString stringWithUTF8String:(char *)sqlite3_column_text(showtime_details_stmt,6)]];
        [tmpShowTime setShowType:[NSString stringWithUTF8String:(char *)sqlite3_column_text(showtime_details_stmt,7)]];
        [showtimeArr addObject:tmpShowTime];
        
    }
    
    sqlite3_finalize(showtime_details_stmt);
    
    return showtimeArr;
}
+(BOOL) updateShowTimes:(ShowTimeVO *) showTimeVO andLocalShowDateId:(int)localShowDateId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString *sql = @"update ShowTimes set showTime = ?,screenId = ?,screenName=?, enable = ?, type = ? where id = ? AND showDateId = ?";
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &modify_showtime_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    sqlite3_bind_text(modify_showtime_stmt, 1, [[showTimeVO showTime] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_showtime_stmt, 2, [[showTimeVO screenId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_showtime_stmt, 3, [[showTimeVO screenName] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_showtime_stmt, 4, [[showTimeVO isEnable] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_showtime_stmt, 5, [[showTimeVO showType] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(modify_showtime_stmt, 6, [[showTimeVO serverId] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(modify_showtime_stmt,7,localShowDateId);
    
    
    if (SQLITE_DONE != sqlite3_step(modify_showtime_stmt)) {
        
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    sqlite3_finalize(modify_showtime_stmt);
    
    return YES;
}

+(void) deleteAllShowTimes
{
    NSString * sql = [NSString stringWithFormat:@"DELETE from ShowTimes"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_all_show_times_stmt, NULL) != SQLITE_OK)
    {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    if (SQLITE_DONE != sqlite3_step(delete_all_show_times_stmt)) {
        NSAssert1(0,@"Error while deleting data %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(delete_all_show_times_stmt);
}

+(NSMutableArray *)getAllShowTimes
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSMutableArray *showtimesArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from ShowTimes";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &all_showtimes_details_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    while (sqlite3_step(all_showtimes_details_stmt) == SQLITE_ROW) {
        
        ShowTimeVO *tmpShowTime=[[ShowTimeVO alloc]init];
        
        [tmpShowTime setLocalShowTimeId:sqlite3_column_int(all_showtimes_details_stmt, 0)];
        [tmpShowTime setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_showtimes_details_stmt, 1)]];
        [tmpShowTime setShowTime:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_showtimes_details_stmt,3)]];
        [tmpShowTime setScreenId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_showtimes_details_stmt,4)]];
        [tmpShowTime setScreenName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_showtimes_details_stmt,5)]];
        [tmpShowTime setIsEnable:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_showtimes_details_stmt,6)]];
        [tmpShowTime setShowType:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_showtimes_details_stmt,7)]];
        
        
        [showtimesArr addObject:tmpShowTime];
        [tmpShowTime release];
    }
    
    sqlite3_finalize(all_showtimes_details_stmt);
    
    return showtimesArr;
    
}

+(void) deleteShowTimes:(NSMutableArray *)showTimesArr
{
    [showTimesArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self deleteShowTime:obj];
    }];
}

+(BOOL) deleteShowTime:(ShowTimeVO *)showTimeVO
{
    if (showTimeVO.localShowTimeId!=0)
    {
        [self deleteTheatreByLocalId:showTimeVO.localShowTimeId];
        return YES;
    }
    else if(showTimeVO.serverId!=nil)
    {
        [self deleteTheatreByServerId:showTimeVO.serverId];
        return YES;
    }
    
    return NO;
}

+(BOOL) deleteShowTimeByLocalId:(int)localShowTimeId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"delete from ShowTimes where id = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_localId_showtime_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(delete_localId_showtime_stmt, 1, localShowTimeId);
    
    
    if (SQLITE_DONE != sqlite3_step(delete_localId_showtime_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_localId_showtime_stmt);
    
    return YES;
}

+(BOOL) deleteShowTimesByServerId:(NSString *)serverId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"delete from ShowTimes where serverId = ?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_serverId_showtime_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(delete_serverId_showtime_stmt,1,[serverId UTF8String],-1,SQLITE_TRANSIENT);
    
    
    if (SQLITE_DONE != sqlite3_step(delete_serverId_showtime_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_serverId_showtime_stmt);
    return YES;
    
}

#pragma mark
#pragma mark BookingHistory related
#pragma mark

static sqlite3_stmt *insert_bookedhist_stmt=nil;
static sqlite3_stmt *delete_bookedhist_stmt=nil;
static sqlite3_stmt *delete_all_bookedhist_stmt=nil;
static sqlite3_stmt *bookedhist_exists_stmt=nil;
static sqlite3_stmt *booked_hist_stmt=nil;
static sqlite3_stmt *all_bookedhist_stmt=nil;
static sqlite3_stmt *bookedhist_by_serverid_stmt=nil;

+(NSMutableArray*)getAllBookedHistories
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    BookingHistoryVO *tmpbkgHist;
    
    NSMutableArray *bookingHistArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from BookingHistories";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &all_bookedhist_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    
    while (sqlite3_step(all_bookedhist_stmt) == SQLITE_ROW) {
        
        
        tmpbkgHist=[[[BookingHistoryVO alloc]init]autorelease];
        
        [tmpbkgHist setLocalBookingId:sqlite3_column_int(all_bookedhist_stmt, 0)];
        [tmpbkgHist setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt, 1)]];
        [tmpbkgHist setMovieName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,3)]];
        [tmpbkgHist setTheatreName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,4)]];
        [tmpbkgHist setAddress:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,5)]];
        [tmpbkgHist setBookedTime:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,6)]];
        [tmpbkgHist setShowDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,7)]];
        [tmpbkgHist setSeatsSelected:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,8)]];
        [tmpbkgHist setSeatsCount:sqlite3_column_int(all_bookedhist_stmt, 9)];
        [tmpbkgHist setStatus:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,10)]];
        [tmpbkgHist setReservationCode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,11)]];
        [tmpbkgHist setBarCodeURL:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,12)]];
        [tmpbkgHist setTicketCost:sqlite3_column_int(all_bookedhist_stmt, 13)];
        [tmpbkgHist setBookingFees:sqlite3_column_int(all_bookedhist_stmt, 14)];
        [tmpbkgHist setTotalCost:sqlite3_column_int(all_bookedhist_stmt, 15)];
        [tmpbkgHist setMovieThumbnail:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,16)]];
        [tmpbkgHist setMovieServerID:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_bookedhist_stmt,17)]];
        
        [bookingHistArr addObject:tmpbkgHist];
        
    }
    
    sqlite3_finalize(all_bookedhist_stmt);
    
    return bookingHistArr;
    
    
}

+(NSMutableArray*)getBookedHistotyForlocalUserId:(NSString *)localuserId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSMutableArray *bookhistArr = [[[NSMutableArray alloc]init]autorelease];
    
    NSString *sql = @"select * from BookingHistories where userid = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &booked_hist_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    sqlite3_bind_text(booked_hist_stmt,1,[localuserId UTF8String],-1,SQLITE_TRANSIENT);
    
    while (sqlite3_step(booked_hist_stmt) == SQLITE_ROW) {
        
        
        BookingHistoryVO *tmpbkgHist=[[BookingHistoryVO alloc]init];
        
        [tmpbkgHist setLocalBookingId:sqlite3_column_int(booked_hist_stmt, 0)];
        [tmpbkgHist setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt, 1)]];
        [tmpbkgHist setMovieName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,3)]];
        [tmpbkgHist setTheatreName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,4)]];
        [tmpbkgHist setAddress:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,5)]];
        [tmpbkgHist setBookedTime:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,6)]];
        [tmpbkgHist setShowDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,7)]];
        [tmpbkgHist setSeatsSelected:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,8)]];
        [tmpbkgHist setSeatsCount:sqlite3_column_int(booked_hist_stmt, 9)];
        [tmpbkgHist setStatus:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,10)]];
        [tmpbkgHist setReservationCode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,11)]];
        [tmpbkgHist setBarCodeURL:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,12)]];
        [tmpbkgHist setTicketCost:sqlite3_column_int(booked_hist_stmt, 13)];
        [tmpbkgHist setBookingFees:sqlite3_column_int(booked_hist_stmt, 14)];
        [tmpbkgHist setTotalCost:sqlite3_column_int(booked_hist_stmt, 15)];
        [tmpbkgHist setMovieThumbnail:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,16)]];
        [tmpbkgHist setMovieServerID:[NSString stringWithUTF8String:(char *)sqlite3_column_text(booked_hist_stmt,17)]];
        [bookhistArr addObject:tmpbkgHist];
        [tmpbkgHist release];
        
    }
    
    sqlite3_finalize(booked_hist_stmt);
    
    return bookhistArr;
    
    
}

+(BOOL)isBookingExists:(NSString*)serverId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString *sql = @"select * from BookingHistories where serverId = ? ";
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &bookedhist_exists_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(bookedhist_exists_stmt,1,[serverId UTF8String] ,-1,SQLITE_TRANSIENT);
    
    
    while (sqlite3_step(bookedhist_exists_stmt) == SQLITE_ROW) {
        
        sqlite3_finalize(bookedhist_exists_stmt);
        
        return YES;
    }
    
    sqlite3_finalize(bookedhist_exists_stmt);
    
    return NO;
    
}

+(BOOL)insertBookedHistory:(BookingHistoryVO *)bHistrory forLocalUserId:(NSString*)uid
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO BookingHistories(serverid,userid,moviename,theatreName,address,bookedTime,showDate,seatsSelected,seatsCount,status,reservationCode,barCodeURL,ticketCost,bookingFees,totalCost,movieImageURL,movieServerID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &insert_bookedhist_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(insert_bookedhist_stmt,1,[[bHistrory serverId] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_bookedhist_stmt,2,[uid UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_bookedhist_stmt,3,[[bHistrory movieName] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_bookedhist_stmt,4,[[bHistrory theatreName] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_bookedhist_stmt,5,[[bHistrory address] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_bookedhist_stmt,6,[[bHistrory bookedTime] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_bookedhist_stmt,7,[[bHistrory showDate] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_bookedhist_stmt,8,[[bHistrory seatsSelected] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_int(insert_bookedhist_stmt,9,[bHistrory seatsCount]);
    sqlite3_bind_text(insert_bookedhist_stmt,10,[[bHistrory status] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_bookedhist_stmt,11,[[bHistrory reservationCode] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_bookedhist_stmt,12,[[bHistrory barCodeURL] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_int(insert_bookedhist_stmt,13,[bHistrory ticketCost]);
    sqlite3_bind_int(insert_bookedhist_stmt,14,[bHistrory bookingFees]);
      sqlite3_bind_int(insert_bookedhist_stmt,15,[bHistrory totalCost]);
    sqlite3_bind_text(insert_bookedhist_stmt,16,[[bHistrory movieThumbnail] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_bookedhist_stmt,17,[[bHistrory movieServerID] UTF8String],-1,SQLITE_TRANSIENT);
    
    if (SQLITE_DONE != sqlite3_step(insert_bookedhist_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    
    sqlite3_finalize(insert_bookedhist_stmt);
    
    
    return YES;
    
    
}

+(void)insertAllBookingHistories:(NSMutableArray *)bookingHistoriesArr forUserId:(NSString *)uid
{
    for (BookingHistoryVO* bHistory in bookingHistoriesArr) {
        [self insertBookedHistory:bHistory forLocalUserId:uid];
    }
    
}

+(BookingHistoryVO *)getBookedHistoryByServerId:(NSString *)serverId
{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    BookingHistoryVO *tmpbkgHist = nil;
    
    NSString *sql = @"select * from BookingHistories where serverId = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &bookedhist_by_serverid_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(bookedhist_by_serverid_stmt, 1,[serverId UTF8String],-1,SQLITE_TRANSIENT);
    
    while (sqlite3_step(bookedhist_by_serverid_stmt) == SQLITE_ROW) {
        
        tmpbkgHist = [[[BookingHistoryVO alloc] init]autorelease];
        
        [tmpbkgHist setLocalBookingId:sqlite3_column_int(bookedhist_by_serverid_stmt, 0)];
        [tmpbkgHist setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt, 1)]];
        [tmpbkgHist setMovieName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt,3)]];
        [tmpbkgHist setTheatreName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt,4)]];
        [tmpbkgHist setAddress:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt,5)]];
        [tmpbkgHist setBookedTime:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt,6)]];
        [tmpbkgHist setShowDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt,7)]];
        [tmpbkgHist setSeatsSelected:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt,8)]];
        [tmpbkgHist setSeatsCount:sqlite3_column_int(bookedhist_by_serverid_stmt, 9)];
        [tmpbkgHist setReservationCode:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt,11)]];
        [tmpbkgHist setBarCodeURL:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt,12)]];
        [tmpbkgHist setTicketCost:sqlite3_column_int(bookedhist_by_serverid_stmt, 13)];
        [tmpbkgHist setBookingFees:sqlite3_column_int(bookedhist_by_serverid_stmt, 14)];
        [tmpbkgHist setTotalCost:sqlite3_column_int(bookedhist_by_serverid_stmt, 15)];
        [tmpbkgHist setMovieThumbnail:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt,16)]];
        [tmpbkgHist setMovieServerID:[NSString stringWithUTF8String:(char *)sqlite3_column_text(bookedhist_by_serverid_stmt,17)]];
    }
    
    sqlite3_finalize(bookedhist_by_serverid_stmt);
    
    return tmpbkgHist;
    
    
    
}

+(BOOL)deleteBookedHistory:(int)localbookingHistoryId
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"delete from BookingHistories Where id=?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_bookedhist_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(delete_bookedhist_stmt, 1, localbookingHistoryId);
    
    if (SQLITE_DONE != sqlite3_step(delete_bookedhist_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_bookedhist_stmt);
    
    return YES;
    
}

+(void)deleteAllBookingHistoriesForUserId:(NSString *)uid
{
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"delete from BookingHistories Where userid=?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_all_bookedhist_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(delete_all_bookedhist_stmt, 1, [uid UTF8String], -1, SQLITE_TRANSIENT);
    
    if (SQLITE_DONE != sqlite3_step(delete_all_bookedhist_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(delete_all_bookedhist_stmt);
    
}



#pragma mark
#pragma mark VoucherDetails
#pragma mark


static sqlite3_stmt *insert_voucherdetails_stmt=nil;
static sqlite3_stmt *delete_voucherdetails_stmt=nil;
static sqlite3_stmt *delete_all_voucherdetails_stmt=nil;
static sqlite3_stmt *voucherdetails_exists_stmt=nil;
static sqlite3_stmt *voucherdetails_stmt=nil;
static sqlite3_stmt *all_voucherdetails_stmt=nil;
static sqlite3_stmt *voucherdetails_by_voucherid_stmt=nil;





+(NSMutableArray *)getAllVouchers{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    UserVoucherVO *tmpuserVouchers;
    
    NSMutableArray *userVoucherArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from VoucherDetails";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &all_voucherdetails_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
        while (sqlite3_step(all_bookedhist_stmt) == SQLITE_ROW) {
        
        tmpuserVouchers=[[[UserVoucherVO alloc]init]autorelease];
        
        [tmpuserVouchers setLocalVoucherId:sqlite3_column_int(all_voucherdetails_stmt, 0)];
        [tmpuserVouchers setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_voucherdetails_stmt, 1)]];
        [tmpuserVouchers setVoucherValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_voucherdetails_stmt, 3)]];
        [tmpuserVouchers setVoucherBalanceValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_voucherdetails_stmt, 4)]];
        [tmpuserVouchers setVocuhergenerationDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_voucherdetails_stmt, 5)]];
        [tmpuserVouchers setVoucherexpireDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_voucherdetails_stmt, 6)]];
        [tmpuserVouchers setVoucherStatus:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_voucherdetails_stmt, 7)]];
        [tmpuserVouchers setVoucherCoupon:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_voucherdetails_stmt, 8)]];

        [userVoucherArr addObject:tmpuserVouchers];
       [tmpuserVouchers release];
            
        
    }
    
    sqlite3_finalize(all_voucherdetails_stmt);
    
    return userVoucherArr;
    

    
}


+(NSMutableArray *)getVoucherDetailsForlocalUserId:(NSString *)localuserId{
    
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSMutableArray *userVoucherArr = [[[NSMutableArray alloc] init]autorelease];
    
    NSString *sql = @"select * from VoucherDetails where userid = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &voucherdetails_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    sqlite3_bind_text(voucherdetails_stmt,1,[localuserId UTF8String],-1,SQLITE_TRANSIENT);
    
    while (sqlite3_step(voucherdetails_stmt) == SQLITE_ROW) {
        
        
       UserVoucherVO  *tmpuserVouchers=[[[UserVoucherVO alloc]init]autorelease];
        
        [tmpuserVouchers setLocalVoucherId:sqlite3_column_int(all_voucherdetails_stmt, 0)];
        [tmpuserVouchers setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_stmt, 1)]];
        [tmpuserVouchers setVoucherValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_stmt, 3)]];
        [tmpuserVouchers setVoucherBalanceValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_stmt, 4)]];
        [tmpuserVouchers setVocuhergenerationDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_stmt, 5)]];
        [tmpuserVouchers setVoucherexpireDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_stmt, 6)]];
        [tmpuserVouchers setVoucherStatus:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_stmt, 7)]];
        [tmpuserVouchers setVoucherCoupon:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_stmt, 8)]];

        [userVoucherArr addObject:tmpuserVouchers];
        [tmpuserVouchers release];
        
    }
    
    sqlite3_finalize(voucherdetails_stmt);
    
    return userVoucherArr;
    
}

+(UserVoucherVO *)getVoucerDetailsbyServerId:(NSString *)serverId{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    UserVoucherVO *tmpVoucherDet = nil;
    
    NSString *sql = @"select * from VocuherDetails where serverid = ?";
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &voucherdetails_by_voucherid_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(voucherdetails_by_voucherid_stmt, 1,[serverId UTF8String],-1,SQLITE_TRANSIENT);
    
    while (sqlite3_step(voucherdetails_by_voucherid_stmt) == SQLITE_ROW) {
        
        tmpVoucherDet=[[[UserVoucherVO alloc]init]autorelease];
        
        [tmpVoucherDet setLocalVoucherId:sqlite3_column_int(voucherdetails_by_voucherid_stmt, 0)];
        [tmpVoucherDet setServerId:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_by_voucherid_stmt, 1)]];
        [tmpVoucherDet setVoucherValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_by_voucherid_stmt, 3)]];
        [tmpVoucherDet setVoucherBalanceValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_by_voucherid_stmt, 4)]];
        [tmpVoucherDet setVocuhergenerationDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_by_voucherid_stmt, 5)]];
        [tmpVoucherDet setVoucherexpireDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_by_voucherid_stmt, 6)]];
        [tmpVoucherDet setVoucherStatus:[NSString stringWithUTF8String:(char *)sqlite3_column_text(voucherdetails_by_voucherid_stmt, 7)]];
        [tmpVoucherDet setVoucherCoupon:[NSString stringWithUTF8String:(char *)sqlite3_column_text(all_voucherdetails_stmt, 8)]];

        
    }
    
    sqlite3_finalize(voucherdetails_by_voucherid_stmt);
    
    return tmpVoucherDet;

    
}
+(BOOL)isVoucherExists:(NSString *)serverId{
    
    
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString *sql = @"select * from VoucherDetails where serverid = ? ";
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &voucherdetails_exists_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(voucherdetails_exists_stmt,1,[serverId UTF8String] ,-1,SQLITE_TRANSIENT);
    
    
    while (sqlite3_step(voucherdetails_exists_stmt) == SQLITE_ROW) {
        
        sqlite3_finalize(voucherdetails_exists_stmt);
        
        return YES;
    }
    
    sqlite3_finalize(voucherdetails_exists_stmt);
    
    return NO;

    
}
+(BOOL)insertVoucherDetails:(UserVoucherVO *)VoucherDetails forLocalUserId:(NSString *)localUserid{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO VoucherDetails(serverid,userid,voucherValue,voucherBalanceValue,vouchergenerationDate,voucherexpireDate,voucherStatus,couponcode) VALUES(?,?,?,?,?,?,?,?)"];
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &insert_voucherdetails_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &insert_voucherdetails_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    sqlite3_bind_text(insert_voucherdetails_stmt,1,[[VoucherDetails serverId] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_voucherdetails_stmt,2,[localUserid UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_voucherdetails_stmt,3,[[VoucherDetails voucherValue] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_voucherdetails_stmt,4,[[VoucherDetails voucherBalanceValue] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_voucherdetails_stmt,5,[[VoucherDetails vocuhergenerationDate] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_voucherdetails_stmt,6,[[VoucherDetails voucherexpireDate] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_voucherdetails_stmt,7,[[VoucherDetails voucherStatus] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_voucherdetails_stmt,8,[[VoucherDetails voucherCoupon] UTF8String],-1,SQLITE_TRANSIENT);
    
    if (SQLITE_DONE != sqlite3_step(insert_voucherdetails_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        
        return NO;
    }
    
    
    sqlite3_finalize(insert_voucherdetails_stmt);
    
    
    return YES;
    
}


+(void)insertAllVoucherDetails:(NSMutableArray *)voucherDetailsArray forUserId:(NSString *)uid{
    
    for (UserVoucherVO* userVo in voucherDetailsArray) {
        [self insertVoucherDetails:userVo forLocalUserId:uid];
    }
    
    
}

+(BOOL)deleteVoucherDetails:(int)voucherDetailsId{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    
    NSString * sql = [NSString stringWithFormat:@"delete from VoucherDetails Where id=?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_voucherdetails_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_int(delete_voucherdetails_stmt, 1, voucherDetailsId);
    
    if (SQLITE_DONE != sqlite3_step(delete_voucherdetails_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
        return NO;
    }
    
    sqlite3_finalize(delete_voucherdetails_stmt);
    
    return YES;
    

    
}
+(void)deleteAllVoucherDetailsForUserId:(NSString *)uid{
    
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    
    NSString * sql = [NSString stringWithFormat:@"delete from VoucherDetails Where userid=?"];
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &delete_all_voucherdetails_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0,@"Error while creating statement %s",sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(delete_all_voucherdetails_stmt, 1, [uid UTF8String], -1, SQLITE_TRANSIENT);
    
    if (SQLITE_DONE != sqlite3_step(delete_all_voucherdetails_stmt)) {
        NSAssert1(0,@"Error while inserting data %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(delete_all_voucherdetails_stmt);

    
}

@end
