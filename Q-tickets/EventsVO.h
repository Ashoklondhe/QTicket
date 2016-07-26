//
//  EventsVO.h
//  Q-tickets
//
//  Created by KrishnaSunkara on 15/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EventsVO : NSObject

@property (nonatomic, assign) int               localEventId;
@property (nonatomic, retain) NSString          *serverId;
@property (nonatomic, retain) NSString          *EventName;
@property (nonatomic, retain) NSString          *EventDescription;
@property (nonatomic, retain) NSString          *startDate;
@property (nonatomic, retain) NSString          *endDate;
@property (nonatomic, retain) NSString          *thumbnailURL;
@property (nonatomic, retain) NSString          *startTime;
@property (nonatomic, retain) NSString          *endTime;
@property (nonatomic, retain) NSString          *category;
@property (nonatomic, retain) NSString          *categoryId;
@property (nonatomic, retain) NSString          *venue;
@property (nonatomic, retain) NSString          *venueId;
@property (nonatomic, retain) NSString          *VenueDescription;
@property (nonatomic, retain) NSString          *locationLatitude;
@property (nonatomic, retain) NSString          *locationLongitude;
@property (nonatomic, retain) NSString          *entryRestriction;
@property (nonatomic, retain) NSString          *isAlcoholic;
@property (nonatomic, retain) NSString          *contactPersonName;
@property (nonatomic, retain) NSString          *contactPersonEmail;
@property (nonatomic, retain) NSString          *ContactPersonNumber;
@property (nonatomic, retain) NSString          *seatLayoutUrl;
@property (nonatomic, retain) NSString          *posterUrl;
@property (nonatomic, retain) NSString          *colorcode;
@property (nonatomic, retain) NSString          *btncolorcode;
@property (nonatomic, retain) NSString          *bgColorCode;
@property (nonatomic, retain) NSString          *bgBorderColorCode;
@property (nonatomic, retain) NSString          *backgroundColorcode;
@property (nonatomic, retain) NSString          *titleColorCode;
@property (nonatomic, retain) NSMutableArray    *eventTicketsArray;
@property (nonatomic, retain) NSString          *eventUrl;
@property (nonatomic, retain) NSString          *strNoOfTktCategory;
@property (nonatomic, retain) NSString          *strEventUrlIs;
@property (nonatomic, retain) NSString          *strBannerUrl;
@property (nonatomic, retain) NSString          *strEventType;
@property (nonatomic, retain) NSString          *strEventCategoryUrlis;
@property (nonatomic, retain) NSString          *strlastModifiedDateis;



@end


@interface TicketTypes : NSObject

@property (nonatomic, assign) int                 localTicketId;
@property (nonatomic, retain) NSString            *ticketType;
@property (nonatomic, retain) NSString            *totalTickets;
@property (nonatomic, retain) NSString            *noofAvailableTickets;
@property (nonatomic, retain) NSString            *ticketAdmit;
@property (nonatomic, retain) NSString            *ticketPrice;
@property (nonatomic, retain) NSString            *ticketServiceCharge;
@property (nonatomic, retain) NSString            *ticketMasterId;
@property (nonatomic, retain) NSString            *ticketPriceId;
@property (nonatomic, retain) NSString            *strEventDateasPerCate;
@property (nonatomic, retain) NSString            *strnoofTicketsPerTransaction;
@property (nonatomic, retain) NSString            *strTicketPaidrFree;

@end
