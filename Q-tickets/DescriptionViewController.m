//
//  DescriptionViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 13/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "DescriptionViewController.h"
#import "StrechyParallaxScrollView.h"
#import "Q-ticketsConstants.h"
#import "ShowTimingsViewController.h"
#import "EventsBookingViewController.h"
#import "EGOImageView.h"
#import "SMSCountryUtils.h"
#import "AppDelegate.h"
#import "MarqueeLabel.h"
#import "Movies_EventsViewController.h"


@interface DescriptionViewController ()<UIScrollViewDelegate>
{
    
     IBOutlet UIView                    *topviewforScroll;
     IBOutlet UIView                    *descriptionviewofContent;
     IBOutlet UITextView                *tvofDescriptionofpic;
     IBOutlet UIImageView               *imgofNav;
     IBOutlet MarqueeLabel              *lblofViewTitle;
     IBOutlet UIImageView               *imgviewofBottom;
     IBOutlet UIButton                  *btnogBooknow;
     IBOutlet UIButton                  *btnBack;
     IBOutlet UIScrollView              *DescriptionScrollview;
     IBOutlet EGOImageView              *imgviewofMovie;
     IBOutlet StrechyParallaxScrollView *wholeScrollview;
     IBOutlet UILabel                   *lbltypeofMovie;
     IBOutlet UILabel                   *lblratingofMovie;
     IBOutlet UILabel                   *lbltimeofMovie;
     IBOutlet UITextView                *tvofcastingofMovie;
     IBOutlet UIImageView               *imgoftypeofMovie;
     IBOutlet UIImageView               *imgofratingofMovie;
     IBOutlet UIImageView               *imgofdurationofMovie;
     IBOutlet UIImageView               *imgofcastingofMovie;
     AppDelegate                        *delegateApp;
     IBOutlet EGOImageView              *imgviewofBackground;
     IBOutlet UIImageView               *imgviewofBackArrow;
     NSString                           *strMovieTrailerUrl;
    BOOL                                 playingfirsttime;
    
}

@end

@implementation DescriptionViewController
@synthesize strViewtitle,strTheaterName,youtubeVideoPlayer;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    delegateApp                 = QTicketsAppDelegate;
    lblofViewTitle.marqueeType  = MLContinuous;
    lblofViewTitle.trailingBuffer = 15.0f;
    playingfirsttime = NO;
    [lblofViewTitle setText:delegateApp.selectedMovie.movieName];
    
    //for scrollview

    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
    }

    if ([SMSCountryUtils isIphone]) {
        
    wholeScrollview           = [[StrechyParallaxScrollView alloc] initWithFrame:CGRectMake(0, 0,ViewWidth,ViewHeight-50) andTopView:topviewforScroll];
    [topviewforScroll setFrame:CGRectMake(0, 0, ViewWidth, 200)];
    [DescriptionScrollview setFrame:CGRectMake(0, 200, ViewWidth, 483)];
    [DescriptionScrollview setContentSize:CGSizeMake(ViewWidth,530)];
    [wholeScrollview setContentSize:CGSizeMake(ViewWidth,ViewHeight+200)];
        
    }
    else{
        
          wholeScrollview           = [[StrechyParallaxScrollView alloc] initWithFrame:CGRectMake(0, 0,ViewWidth,ViewHeight-100) andTopView:topviewforScroll];
        [topviewforScroll setFrame:CGRectMake(0, 0, ViewWidth, 400)];
        [DescriptionScrollview setFrame:CGRectMake(0, 400, ViewWidth, 700)];
        [DescriptionScrollview setContentSize:CGSizeMake(ViewWidth,700)];
        [wholeScrollview setContentSize:CGSizeMake(ViewWidth,ViewHeight+200)];
        

        
    }
    [descriptionviewofContent.layer setBorderColor: [[UIColor colorWithRed:0.25490 green:0.25490 blue:0.25490 alpha:1] CGColor]];
    [descriptionviewofContent.layer setBorderWidth: 1.0];

    [wholeScrollview addSubview:DescriptionScrollview];
    [self.view addSubview:wholeScrollview];
    [self.view bringSubviewToFront:imgofNav];
    [self.view bringSubviewToFront:lblofViewTitle];
    [self.view bringSubviewToFront:imgviewofBackArrow];
    [self.view bringSubviewToFront:btnBack];
    [self.view bringSubviewToFront:self.youtubeVideoPlayer];
    [self.view bringSubviewToFront:imgviewofBottom];
    [self.view bringSubviewToFront:btnogBooknow];
    [self setMovieContent];

    
    
}

-(void)setMovieContent{
    
    
    UIImage *placeholderimage;
    
    if ([SMSCountryUtils isIphone]) {
        
        placeholderimage = [UIImage imageNamed:@"movie-loading-icon.png"];
    }
    else{
        
        placeholderimage = [UIImage imageNamed:@"movie-loading-icon~ipad.png"];
        
    }
    
            imgviewofMovie                = [imgviewofMovie initWithPlaceholderImage:placeholderimage];
    
        imgviewofMovie.imageURL       = [NSURL URLWithString:[NSString stringWithFormat:@"%@",delegateApp.selectedMovie.strMovieBannerurlis]];
        lbltypeofMovie.text           =  delegateApp.selectedMovie.movieType;
        lblratingofMovie.text          = delegateApp.selectedMovie.censor;
        SMSCountryUtils *smsuti       = [[SMSCountryUtils alloc]init];
        lbltimeofMovie.text           = [smsuti timeFormatted:[delegateApp.selectedMovie.duration intValue]];
        tvofDescriptionofpic.text     = [NSString stringWithFormat:@"%@",delegateApp.selectedMovie.description];
         tvofcastingofMovie.text      = [NSString stringWithFormat:@"%@",delegateApp.selectedMovie.strmovieCasting];
    
    CGSize newTagdesc = [tvofDescriptionofpic sizeThatFits:CGSizeMake(ViewWidth, CGFLOAT_MAX)];
    
    strMovieTrailerUrl = [NSString stringWithFormat:@"%@",delegateApp.selectedMovie.strTrailerUrlIs];
    if ([strMovieTrailerUrl isEqualToString:@""]) {
        
        [self.youtubeVideoPlayer setHidden:YES];
    }
    
    else{
        
        [self.youtubeVideoPlayer setHidden:NO];
    strMovieTrailerUrl = [strMovieTrailerUrl stringByReplacingOccurrencesOfString:@"http://www.youtube.com/embed/" withString:@""];
    
    strMovieTrailerUrl = [strMovieTrailerUrl stringByReplacingOccurrencesOfString:@"?autoplay=0" withString:@""];

    
         [self.youtubeVideoPlayer loadWithVideoId:strMovieTrailerUrl];
        [self.youtubeVideoPlayer setDelegate:self];

    

    if ([SMSCountryUtils isIphone]) {
            
        [tvofDescriptionofpic setFrame:CGRectMake(tvofDescriptionofpic.frame.origin.x, tvofDescriptionofpic.frame.origin.y, ViewWidth, newTagdesc.height+30)];
        
         [youtubeVideoPlayer setFrame:CGRectMake(youtubeVideoPlayer.frame.origin.x, tvofDescriptionofpic.frame.origin.y+tvofDescriptionofpic.frame.size.height+20, youtubeVideoPlayer.frame.size.width, youtubeVideoPlayer.frame.size.height)];
        
          [DescriptionScrollview setFrame:CGRectMake(0, 200, ViewWidth, youtubeVideoPlayer.frame.origin.y+youtubeVideoPlayer.frame.size.height)];
        
        [DescriptionScrollview setContentSize:CGSizeMake(ViewWidth,youtubeVideoPlayer.frame.origin.y+youtubeVideoPlayer.frame.size.height)];
        
        [wholeScrollview setContentSize:CGSizeMake(ViewWidth,DescriptionScrollview.frame.origin.y+DescriptionScrollview.contentSize.height)];
        }
    else{
        
        [tvofDescriptionofpic setFrame:CGRectMake(tvofDescriptionofpic.frame.origin.x, tvofDescriptionofpic.frame.origin.y, ViewWidth, newTagdesc.height)];
        
          [youtubeVideoPlayer setFrame:CGRectMake(youtubeVideoPlayer.frame.origin.x, tvofDescriptionofpic.frame.origin.y+tvofDescriptionofpic.frame.size.height+30, youtubeVideoPlayer.frame.size.width, youtubeVideoPlayer.frame.size.height+110)];
        
         [DescriptionScrollview setFrame:CGRectMake(0, 400, ViewWidth, youtubeVideoPlayer.frame.origin.y+youtubeVideoPlayer.frame.size.height)];

     
    }
    }
//    NSLog(@"descreiption frame is :%@",NSStringFromCGRect(tvofDescriptionofpic.frame));
//    NSLog(@"video frame is :%@",NSStringFromCGRect(youtubeVideoPlayer.frame));

}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state)
    {
        case kYTPlayerStatePlaying:
              if([SMSCountryUtils isIphone]){
            if (playingfirsttime == NO) {
                
                  playingfirsttime = YES;
                  [self.youtubeVideoPlayer loadWithVideoId:strMovieTrailerUrl];
            }
            else{
                [self.youtubeVideoPlayer loadWithVideoId:strMovieTrailerUrl];
            }
              }
            break;
        case kYTPlayerStateEnded:
            if ([SMSCountryUtils isIphone]) {
                
                
            }
            else{
                   [self.youtubeVideoPlayer loadWithVideoId:strMovieTrailerUrl];
            }
            break;
        case kYTPlayerStateBuffering:
            break;
        case kYTPlayerStatePaused:
            break;
        case kYTPlayerStateQueued:
            break;
        case kYTPlayerStateUnknown:
            break;
        case kYTPlayerStateUnstarted:
            [self.youtubeVideoPlayer setHidden:YES];
            self.youtubeVideoPlayer = nil;
            break;
        default:
            break;
    }
}
- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error{
    
    [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Trailer not getting" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
}

-(IBAction)btnBackClciked:(id)sender{
    
    [self.youtubeVideoPlayer stopVideo];
    self.youtubeVideoPlayer = nil;

//    [self.navigationController popViewControllerAnimated:YES];
    
    NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    int index = 0;
    for(int i=0 ; i<[arrofNavoagtionsCon count] ; i++)
    {
        if([[arrofNavoagtionsCon objectAtIndex:i] isKindOfClass:NSClassFromString(@"Movies_EventsViewController")])
        {
            index = i;
            break;
        }
    }
    if (index != 0) {
        [self.navigationController popToViewController:[arrofNavoagtionsCon objectAtIndex:index] animated:YES];
        
    }
    else{
        
        Movies_EventsViewController *moviesviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"Movies_EventsViewController"];
        [self.navigationController pushViewController:moviesviewVC animated:NO];
        
    }
    
}

-(IBAction)btnBooknowClicked:(id)sender
{
    [self.youtubeVideoPlayer stopVideo];
    self.youtubeVideoPlayer = nil;

    ShowTimingsViewController  *showtim    = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"ShowTimingsViewController"];
    
//     [showtim setSelectedTheater:[NSString stringWithFormat:@"%@",delegateApp.strTheaterNameis]];
    [self.navigationController pushViewController:showtim animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
