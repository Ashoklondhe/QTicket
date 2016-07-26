//
//  ShowTimesCustomCell.m
//  QTickets
//
//  Created by Tejasree on 11/04/14.
//  Copyright (c) 2014 Tejasree. All rights reserved.
//

#import "ShowTimesCustomCell.h"
#import "Q-ticketsConstants.h"


@implementation ShowTimesCustomCell
@synthesize datesArr,delegate;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) createShowTimes:(int)horizontalRows andVerticalRows:(int)verticalRows {
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    [self removeAllShowTimeViews];
    int noOfVerticalTiles = verticalRows;
    int childCount = 0;
    for (int i = 0; i < noOfVerticalTiles; i ++) {
        int noOfHorizontalTiles;
        if ([SMSCountryUtils isIphone]) {
        noOfHorizontalTiles = horizontalRows;
        }
        else{
            
            noOfHorizontalTiles = horizontalRows+1;
        }
        for (int j = 0; j < noOfHorizontalTiles; j ++) {
            
            CGRect tileFrame;
            
            if ([SMSCountryUtils isIphone]) {
                
                tileFrame =  CGRectMake(SHOW_FIRST_TILE_X_VALUE + (SHOW_TILE_WIDTH+SHOW_TILE_WIDTH_DIFF)*j , SHOW_FIRST_TILE_Y_VALUE+ (SHOW_TILE_HEIGHT+SHOW_TILE_HEIGHT_DIFF)*i,SHOW_TILE_WIDTH,SHOW_TILE_HEIGHT);
            }
            else{
                
                tileFrame =  CGRectMake(SHOW_FIRST_TILE_X_VALUE + ((2*SHOW_TILE_WIDTH)+SHOW_TILE_WIDTH_DIFF+12)*j , SHOW_FIRST_TILE_Y_VALUE+ (SHOW_TILE_HEIGHT+40+SHOW_TILE_HEIGHT_DIFF+4)*i,SHOW_TILE_WIDTH+60,SHOW_TILE_HEIGHT+30);
            }
            
            
            childCount ++;
            
            if (childCount <= datesArr.count) {
                
                ShowTimeVO *showTimeTemp = [datesArr objectAtIndex:childCount - 1];
                NSIndexPath *indexPathTemp;
                
                if (SYSTEM_VERSION_GREATER_THAN(@"7.0"))
                {
                    
                indexPathTemp = [(UITableView *)self.superview.superview indexPathForCell: self];
                }
                else
                {
                indexPathTemp = [(UITableView *)self.superview indexPathForCell: self];
                }
                NSString *sTag = [NSString stringWithFormat:@"%li%li%i",(long)indexPathTemp.section,(long)indexPathTemp.row,childCount];
                
                ShowTimeView *sDateView = (ShowTimeView *)[self.contentView viewWithTag:[sTag integerValue]];
               
                if (sDateView == nil) {
                    sDateView = [[ShowTimeView alloc] initWithDelegate:self];
                    
                    [sDateView setTag:[sTag integerValue]];
                    
                    [sDateView setShowTimeVO:showTimeTemp];
                    
                    [sDateView setFrame:tileFrame];
                    
                    [self.contentView addSubview:sDateView];
                    
                    
                    
                    UILabel *dateLbl = [[UILabel alloc] init];
                    //[dateLbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"showTime.png"]]];
                   
                    
//                    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
//                    [dateFormate setDateFormat:@"hh:mm a"];
//                    NSDate *newdate = [dateFormate dateFromString:showTimeTemp.showTime];
//                    dateFormate.dateFormat=@"hh:mm a";
                    [dateLbl setTextAlignment:NSTextAlignmentCenter];
                    [dateLbl setText:[NSString stringWithFormat:@"%@",showTimeTemp.showTime]];
                    [dateLbl setTextColor:[UIColor blackColor]];
                 //   [dateLbl setNumberOfLines:1];
                  //  [dateLbl setLineBreakMode:NSLineBreakByTruncatingTail];
                    if ([SMSCountryUtils isIphone]) {
                        [dateLbl setFont:[UIFont fontWithName:LATO_REGULAR size:FONT_SIZE_12]];
                        
                    }
                    else{
                        [dateLbl setFont:[UIFont fontWithName:LATO_REGULAR size:FONT_SIZE_20]];
                    }
                    
                    
                    if ([[showTimeTemp isEnable] isEqualToString:@"true"]) {
                        if ([[showTimeTemp showType]isEqualToString:SHOW_TIME_AVAILABLE] || [[showTimeTemp showType]isEqualToString:@"Available"])
                        {
                            int noofTotlaseats = showTimeTemp.totalCount;
                            int noofAvaialbeleseats = showTimeTemp.availableCount;

                            CGFloat percentageIs = (noofAvaialbeleseats * 100) / noofTotlaseats;
                            
                            if (percentageIs < 30) {
                                
                                [dateLbl setBackgroundColor:[UIColor colorWithRed:0.9960 green:0.7490 blue:0.2352 alpha:1]];
                                [dateLbl setTextColor:[UIColor blackColor]];
                                
                            }
                            else{
                            //by krishna rgb : 167,206,49
                            [dateLbl setBackgroundColor:[UIColor colorWithRed:0.5960 green:0.7960 blue:0.0011 alpha:1]];
                            [dateLbl setTextColor:[UIColor blackColor]];
                            }
                        }else if ([[showTimeTemp showType]isEqualToString:@"Fast Filling"]) {
                            
                            //by krishna rgb:248,197,94
                            [dateLbl setBackgroundColor:[UIColor colorWithRed:0.9960 green:0.7490 blue:0.2352 alpha:1]];
                            [dateLbl setTextColor:[UIColor blackColor]];
                        } else if ([[showTimeTemp showType]isEqualToString:SHOW_TIME_SOLDOUT]) {
                           
                            //by krishna  rgb:248,110,113
                            [dateLbl setBackgroundColor:[UIColor colorWithRed:0.97254 green:0.43137 blue:0.44313 alpha:1]];
                            [dateLbl setTextColor:[UIColor blackColor]];
                        }
                        else if ([[showTimeTemp showType]isEqualToString:SHOW_TIME_COMPLETED]) {
                          //  [dateLbl setTextColor:UIColorFromRGB(0xa72d26)];
                            //by krishna
                            [dateLbl setBackgroundColor:[UIColor colorWithRed:0.97254 green:0.43137 blue:0.44313 alpha:1]];
                             [dateLbl setTextColor:[UIColor blackColor]];
                        }
                        else if ([[showTimeTemp showType]isEqualToString:SHOW_TIME_DELAYED]) {
                           // [dateLbl setTextColor:UIColorFromRGB(0xa72d26)];
                            //by krishna
                            [dateLbl setBackgroundColor:[UIColor colorWithRed:0.97254 green:0.43137 blue:0.44313 alpha:1]];
                            [dateLbl setTextColor:[UIColor blackColor]];
                        }
                    }
                    
                    [dateLbl setFrame:CGRectMake(3, 0, sDateView.frame.size.width, sDateView.frame.size.height)];
                    [sDateView addSubview:dateLbl];
                   
                }
            }
        }
    }
}
- (void)removeAllShowTimeViews {
    
    for (UIView *tempview in self.contentView.subviews) {
        
        if ([tempview isKindOfClass:[ShowTimeView class]]) {
            [tempview removeFromSuperview];
        }
    }
}
#pragma mark ShowDateViewDelegate

- (void)showDateSelected:(ShowTimeVO *)showTimeVO {
    
    if (SYSTEM_VERSION_GREATER_THAN(@"7.0"))
    {

    NSIndexPath *indexPathTemp = [(UITableView *)self.superview.superview indexPathForCell: self];
        //NSLog(@"user selected date for indexpath: %@",[indexPathTemp description]);
        
        [delegate showDateSelected:showTimeVO atIndexPath:indexPathTemp];

    }
    else
    {
        NSIndexPath *indexPathTemp = [(UITableView *)self.superview indexPathForCell: self];
        //NSLog(@"user selected date for indexpath: %@",[indexPathTemp description]);
        
        [delegate showDateSelected:showTimeVO atIndexPath:indexPathTemp];

    }
    
    }

@end
