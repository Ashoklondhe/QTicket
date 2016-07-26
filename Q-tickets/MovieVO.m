//
//  MovieVO.m
//  SMSCountry
//
//  Created by Lakshmikanth on 08/03/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "MovieVO.h"

@implementation MovieVO
@synthesize localMovieId,serverId,movieName,releaseDate,thumbnailURL,language,censor,duration,description,movieTheatresArr,movieType,cellThumbnailImg,detailThumbnailImg,colorcode,btncolorcode,strmovieCasting,strimdbRating,strMovieUrlIs,strMovieiPhoneHomeurlis,strMovieBannerurlis,strMovieiPadHomeurlis,strMovieThumurlis,strTrailerUrlIs,strAgeRestrictRating;

-(id)init
{
    self = [super init];
	if (self) {
        
		 movieTheatresArr = [[NSMutableArray alloc]init];
        movieType = [[NSString alloc]init];
        colorcode=[[NSString alloc]init];
        btncolorcode=[[NSString alloc]init];
        strmovieCasting = [[NSString alloc] init];

	}
    return self;
}



@end

@implementation MovieTheatreVO

@synthesize localMovieTheatreId,movieId,logoURL,address;


@end


@implementation TheatreVO
@synthesize localTheatreId,serverId,theatreName,address,phone,showDatesArr,logoURL,strArabicName;

-(id)init
{
    self = [super init];
	if (self) {
    showDatesArr = [[NSMutableArray alloc]init];
    }
    return self;
}



@end

@implementation ShowDateVO
@synthesize localShowDateId,serverId,showDate,showTimesArr;

-(id)init
{
    self = [super init];
	if (self) {
    showTimesArr = [[NSMutableArray alloc]init];
    }
    return self;
}



@end


@implementation ShowTimeVO
@synthesize localShowTimeId,serverId,showTime,availableCount,showType,isEnable,screenId,screenName,totalCount;

-(id)init
{
    self = [super init];
	if (self) {
        serverId = [[NSString alloc]init];
        showTime = [[NSString alloc]init];
        showType = [[NSString alloc]init];
        isEnable = [[NSString alloc]init];
        screenId = [[NSString alloc]init];
        screenName = [[NSString alloc]init];
    }
    return self;
}


@end







