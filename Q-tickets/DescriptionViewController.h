//
//  DescriptionViewController.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieVO.h"
#import "YTPlayerView.h"

@interface DescriptionViewController : UIViewController<YTPlayerViewDelegate>{
    
//    IBOutlet YTPlayerView              *youtubeVideoPlayer;

}

@property (nonatomic,retain) NSString *strViewtitle;

@property (nonatomic,retain) NSString *strTheaterName;

@property (nonatomic,weak) IBOutlet YTPlayerView  *youtubeVideoPlayer;


@end
