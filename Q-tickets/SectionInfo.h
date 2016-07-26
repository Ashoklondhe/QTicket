//
//  SectionArray.h
//  CustomTableTest
//
//  Created by Punit Sindhwani on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieVO.h"

@class SectionView;

@interface SectionInfo : NSObject

@property (assign) BOOL open;
@property (strong) SectionView *sectionView;
@property (nonatomic,strong,readonly) NSMutableArray *rowHeights;

- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray;

@end



@interface SectionInfoTheatre : SectionInfo 
@property (nonatomic, retain) MovieTheatreVO     *theaterVO;

@end


