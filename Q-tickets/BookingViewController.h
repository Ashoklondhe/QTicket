//
//  BookingViewController.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 16/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSCountryConnections.h"
#import "CommonParseOperation.h"
#import "SeatLayoutView.h"
#import "MenuViewController.h"

@interface SeatSelection : NSObject{
    
    NSString            *movieId;
    NSString            *movieName;
    NSString            *theaterId;
    NSString            *theaterName;
    NSString            *showId;
    NSString            *showTime;
    NSMutableArray      *selectedSeatsArr;
    float               totalCost;
    NSString            *userId;
    NSString            *date;
    UIImage             *movieThumbnail;
    NSString            *movieThumbnailSrc;
    NSString            *movieReleaseDate;
    NSString            *movieLanguage;
    NSString            *movieCensor;
    float               bookingFees;
    NSString            *screenName;
    int                  timeOutInMin;
    int                 requestedTimeInSec;
    NSString            *movieimdbRating;
    NSString            *strTheaterNameArabic;
    int                  totalnoofSeats;
}

@property (nonatomic, retain)     NSString            *movieId;
@property (nonatomic, retain)     NSString            *movieName;
@property (nonatomic, retain)     NSString            *theaterId;
@property (nonatomic, retain)     NSString            *theaterName;
@property (nonatomic, retain)     NSString            *showId;
@property (nonatomic, retain)     NSString            *showTime;
@property (nonatomic, retain)     NSMutableArray      *selectedSeatsArr;
@property (nonatomic)             float               totalCost;
@property (nonatomic, retain)     NSString            *userId;
@property (nonatomic, retain)     NSString            *date;
@property (nonatomic, retain)     UIImage             *movieThumbnail;
@property (nonatomic, retain)     NSString            *movieThumbnailSrc;
@property (nonatomic, retain)     NSString            *movieReleaseDate;
@property (nonatomic, retain)     NSString            *movieLanguage;
@property (nonatomic, retain)     NSString            *movieCensor;
@property (nonatomic)            float                bookingFees;
@property (nonatomic, retain)     NSString            *screenName;
@property (nonatomic, assign)     int                 timeOutInMin;
@property (nonatomic, assign)     int                 requestedTimeInSec;
@property (nonatomic, retain)     NSString            *movieimdbRating;
@property (nonatomic, retain)     NSString            *strTheaterNameArabic;
@property (nonatomic, assign)     int                 totalnoofSeats;

@end






@interface BookingViewController : UIViewController<SMSCountryConnectionDelegate,CommonParseOperationDelegate,SeatLayoutViewDelegate,UIAlertViewDelegate,MenuViewControllerDelegate>
{
    
       NSMutableString                     *selectedSeats;
    MenuViewController                  *rightMenu;

}

@property (nonatomic, retain) NSMutableString           *selectedSeats;
@property (nonatomic, retain) SeatSelection             *currSeatSelection;
@property (nonatomic, assign) float                     bookingFees;
@property (nonatomic, retain) NSString                  *fullScreenURL;
@property (nonatomic, retain) NSMutableString           *selectedBoxOfficeSeatids;
@property (nonatomic, assign) int                       seatClassId;
@property (nonatomic, retain) NSString                  *seatClassName;
@property (nonatomic, retain) NSMutableArray            *bkdHistArr;


- (id)initWithSeatSelection:(SeatSelection *)seatSelection;


@end
