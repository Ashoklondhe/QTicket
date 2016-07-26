//
//  SectionView.m
//  CustomTableTest
//
//  Created by Punit Sindhwani on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SectionView.h"
#import <QuartzCore/QuartzCore.h>
#import "Q-ticketsConstants.h"
#import "EGOImageView.h"
#import "SMSCountryUtils.h"

@implementation SectionView

@synthesize section;
@synthesize sectionTitle;
@synthesize discButton;
@synthesize delegate;

+ (Class)layerClass {
    
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame WithTitle: (NSString *) title WithImage:(NSString *)theatreImg Section:(NSInteger)sectionNumber delegate: (id <SectionView>) Delegate
{
    self = [super initWithFrame:frame];
    if (self) {
   
        
        UIImageView  *imgviewofBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, self.bounds.size.width, self.bounds.size.height)];
        [imgviewofBg setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:imgviewofBg];

        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(discButtonPressed:)];
        [self addGestureRecognizer:tapGesture];
      
        self.userInteractionEnabled = YES;

        self.section = sectionNumber;
        self.delegate = Delegate;
        
        UIImageView *separatorImg = [[UIImageView alloc]init];
        if ([SMSCountryUtils isIphone]) {
            
            [separatorImg setFrame:CGRectMake(3,frame.origin.y,frame.size.width-6,2)];
            
        }
        else{
            
            [separatorImg setFrame:CGRectMake(3,frame.origin.y,frame.size.width-6,2)];

        }
        separatorImg.backgroundColor=UIColorFromRGB(0xe5e5e5);
//        separatorImg.hidden=YES;
//        [self addSubview:separatorImg];
        
        if (section != 0)
        {
            separatorImg.hidden=NO;
        }
        else if(section == 0)
        {
            separatorImg.hidden=YES;
        }

        //by krishna
        EGOImageView *theaterImgVIew = [[EGOImageView alloc]init];
        theaterImgVIew.imageURL      = [NSURL URLWithString:theatreImg];
        if ([SMSCountryUtils isIphone]) {
            
            theaterImgVIew.frame         = CGRectMake(10,frame.origin.y+8,20,20);

        }
        else{
            theaterImgVIew.frame         = CGRectMake(10,frame.origin.y+8,40,40);

        }
        [self addSubview:theaterImgVIew];
        
        
        
        
//        UIImageView *theaterImg = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:theatreImg]];
//        theaterImg.frame=CGRectMake(10,frame.origin.y+12,24,24);
//        [self addSubview:theaterImg];
        
        CGRect LabelFrame = CGRectMake(theaterImgVIew.frame.size.width+20,0, self.bounds.size.width, self.bounds.size.height);
//        if ([SMSCountryUtils isIphone]) {
//            LabelFrame.size.width -= 80;
//
//        }
//        else{
//            LabelFrame.size.width -= 20;
//
//        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:LabelFrame];
        label.text = [title uppercaseStringWithLocale:[NSLocale currentLocale]];
        
        if ([SMSCountryUtils isIphone]) {
            
            label.font = [UIFont fontWithName:LATO_REGULAR size:FONT_SIZE_14];

        }
        else{
            label.font = [UIFont fontWithName:LATO_REGULAR size:FONT_SIZE_18];

        }
        
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        
        //by krishna
        UILabel *lblhearderSepe = [[UILabel alloc]init];
        if ([SMSCountryUtils isIphone]) {
            
            [lblhearderSepe setFrame:CGRectMake(15, 30,self.bounds.size.width-20, 1.5)];
        }
        else{
            
            [lblhearderSepe setFrame:CGRectMake(15, 50,self.bounds.size.width-20, 3)];

        }
        [lblhearderSepe setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
        [self addSubview:lblhearderSepe];
        
        
        [self addSubview:label];
        self.sectionTitle = label;
        
        CGRect buttonFrame ;
        if ([SMSCountryUtils isIphone]) {
            
            buttonFrame = CGRectMake(LabelFrame.size.width, 0, 50, LabelFrame.size.height);
        }
        else{
            buttonFrame = CGRectMake(LabelFrame.size.width, 0, 80, LabelFrame.size.height);
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonFrame;
        //[button setImage:[UIImage imageNamed:@"Red_Arrow.png"] forState:UIControlStateNormal];
       // [button setImage:[UIImage imageNamed:@"Gray_Arrow.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(discButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
       //[self addSubview:button];
       // self.discButton = button;
        static NSMutableArray *colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:3];
            UIColor *color = nil;
            color = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            [colors addObject:(id)[color CGColor]];
        }

    }
    return self;
}

- (void) discButtonPressed : (id) sender
{
    [self toggleButtonPressed:TRUE];
}

- (void) toggleButtonPressed : (BOOL) flag
{
    //to stop button action of section click this code is commented
    
//    self.discButton.selected = !self.discButton.selected;
//    if(flag)
//    {
//        if (self.discButton.selected) 
//        {
//            if ([self.delegate respondsToSelector:@selector(sectionOpened:)]) 
//            {
//                [self.delegate sectionOpened:self.section];
//            }
//        } else
//        {
//            if ([self.delegate respondsToSelector:@selector(sectionClosed:)]) 
//            {
//                [self.delegate sectionClosed:self.section];
//            }
//        }
//    }
    
}

@end
