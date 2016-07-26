//
//  EventsVO.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 15/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "EventsVO.h"

@implementation EventsVO

@synthesize localEventId,endDate,endTime,entryRestriction,EventDescription,EventName,serverId,seatLayoutUrl,startDate,startTime,venue,VenueDescription,venueId,locationLatitude,locationLongitude,bgBorderColorCode,bgColorCode,btncolorcode,category,categoryId,colorcode,contactPersonEmail,contactPersonName,ContactPersonNumber,isAlcoholic,thumbnailURL,titleColorCode,posterUrl,backgroundColorcode,eventTicketsArray,eventUrl,strNoOfTktCategory,strBannerUrl,strEventType,strEventUrlIs,strEventCategoryUrlis,strlastModifiedDateis;

-(id)init
{
    self = [super init];
    if (self) {
        
        colorcode    = [[NSString alloc]init];
        btncolorcode = [[NSString alloc]init];
        eventTicketsArray = [[NSMutableArray alloc] init];
    }
    return self;
}
@end


@implementation TicketTypes

@synthesize localTicketId,ticketAdmit,ticketPrice,ticketServiceCharge,ticketType,totalTickets,noofAvailableTickets,ticketMasterId,ticketPriceId,strEventDateasPerCate,strnoofTicketsPerTransaction,strTicketPaidrFree;

-(id)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}
@end
