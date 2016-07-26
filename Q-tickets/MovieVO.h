//
//  MovieVO.h
//  SMSCountry
//
//  Created by Lakshmikanth on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MovieVO : NSObject

@property (nonatomic, assign) int               localMovieId;
@property (nonatomic, retain) NSString          *serverId;
@property (nonatomic, retain) NSString          *movieName;
@property (nonatomic, retain) NSString          *releaseDate;
@property (nonatomic, retain) NSString          *thumbnailURL;
@property (nonatomic, retain) NSString          *language;
@property (nonatomic, retain) NSString          *censor;
@property (nonatomic, retain) NSString          *duration;
@property (nonatomic, retain) NSString          *description;
@property (nonatomic, retain) NSString          *movieType;
@property (nonatomic, retain) NSMutableArray    *movieTheatresArr;
@property (nonatomic,retain)  UIImage           *cellThumbnailImg;
@property (nonatomic,retain)  UIImage           *detailThumbnailImg;
@property (nonatomic, retain) NSString          *colorcode;
@property (nonatomic, retain) NSString          *btncolorcode;
@property (nonatomic, retain) NSString          *bgColorCode;
@property (nonatomic, retain) NSString          *bgBorderColorCode;
@property (nonatomic, retain) NSString          *titleColorCode;
@property (nonatomic, retain) NSString          *strmovieCasting;
@property (nonatomic, retain) NSString          *strimdbRating;
@property (nonatomic, retain) NSString          *strMovieUrlIs;
@property (nonatomic, retain) NSString          *strMovieThumurlis;
@property (nonatomic, retain) NSString          *strMovieBannerurlis;
@property (nonatomic, retain) NSString          *strMovieiPhoneHomeurlis;
@property (nonatomic, retain) NSString          *strMovieiPadHomeurlis;
@property (nonatomic, retain) NSString          *strTrailerUrlIs;
@property (nonatomic, retain) NSString          *strAgeRestrictRating;


@end

@interface TheatreVO : NSObject

@property (nonatomic, assign) int               localTheatreId;
@property (nonatomic, retain) NSString          *serverId;
@property (nonatomic, retain) NSString          *theatreName;
@property (nonatomic, retain) NSString          *address;
@property (nonatomic, retain) NSString          *phone;
@property (nonatomic, retain) NSString          *logoURL;
@property (nonatomic, retain) NSMutableArray    *showDatesArr;
@property (nonatomic, retain) NSString          *strArabicName;

@end

@interface MovieTheatreVO : TheatreVO

@property (nonatomic, assign) int               localMovieTheatreId;
@property (nonatomic, assign) int               movieId;
@property (nonatomic, retain) NSString          *logoURL;
@property (nonatomic, retain) NSString          *address;
@end


@interface ShowDateVO : NSObject

@property (nonatomic, assign) int               localShowDateId;
@property (nonatomic, retain) NSString          *serverId;
@property (nonatomic, retain) NSString          *showDate;
@property (nonatomic, retain) NSMutableArray    *showTimesArr;

@end

@interface ShowTimeVO : NSObject

@property (nonatomic, assign) int               localShowTimeId;
@property (nonatomic, retain) NSString          *serverId;
@property (nonatomic, retain) NSString          *showTime;
@property (nonatomic, assign) int               availableCount;
@property (nonatomic, assign) int               totalCount;
@property (nonatomic, retain) NSString          *showType;
@property (nonatomic, retain) NSString          *isEnable;
@property (nonatomic, retain) NSString          *screenId;
@property (nonatomic, retain) NSString          *screenName;

@end

