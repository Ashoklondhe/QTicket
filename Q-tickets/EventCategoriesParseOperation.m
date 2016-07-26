//
//  EventCategoriesParseOperation.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 14/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "EventCategoriesParseOperation.h"
#import "Q-ticketsConstants.h"
#import "EventsVO.h"
#import "QticketsSingleton.h"


@implementation EventCategoriesParseOperation
@synthesize status,errorCode,message,eventsDict,tempEventsArr;

- (void)main
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    outputArr     = [[NSMutableArray alloc] init];
    eventsDict    = [[NSMutableDictionary alloc]init];
    tempEventsArr = [[NSMutableArray alloc]init];
    
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParse];
    [parser setDelegate:self];
    [parser parse];
    
    if (![self isCancelled])
    {
        // notify our delegate that the parsing is complete
        
        if (!self.isErrorOccurred) {
            [self.delegate didFinishParsingWithRequestMessage:requestMessage parsedArray:outputArr];
        }
    }
    
    self.outputArr = nil;
    dataToParse = nil;  // this is a local variable i.e,. we will not use self.
    
}

#pragma mark
#pragma mark NSXMLParser Delegate Methods
#pragma mark


- (void)parserDidStartDocument:(NSXMLParser *)parser {
    status = [[NSMutableString alloc]init];
    errorCode = [[NSMutableString alloc]init];
    message = [[NSMutableString alloc]init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    currentElement = [elementName copy];
    if ([currentElement isEqualToString:RESPONSE])
    {
        status = [attributeDict objectForKey:STATUS];
        QticketsSingleton *snglton = [QticketsSingleton sharedInstance];
        snglton.lastModifiedDate=[attributeDict objectForKey:EVENTS_LAST_MODIFIED];
        [eventsDict setValue:status forKeyPath:STATUS];
    
    }
    
    if ([currentElement isEqualToString:EVENT])
    {
        
        EventsVO *eventsVO = [[EventsVO alloc] init];
        eventsVO.serverId  = [attributeDict objectForKey:EVENT_ID];
        eventsVO.EventName = [attributeDict objectForKey:EVENT_NAME];
        eventsVO.EventDescription = [attributeDict objectForKey:EVENT_DESCRIPTION];
        eventsVO.startDate = [attributeDict objectForKey:EVENT_STARTDATE];
        eventsVO.endDate   = [attributeDict objectForKey:EVENT_ENDDATE];
        eventsVO.startTime = [attributeDict objectForKey:EVENT_STARTTIME];
        eventsVO.endTime   = [attributeDict objectForKey:EVENT_ENDTIME];
        eventsVO.thumbnailURL = [attributeDict objectForKey:EVENT_THUMBNAIL_URL];
        eventsVO.category  = [attributeDict objectForKey:EVENT_CATEGORY];
        eventsVO.categoryId = [attributeDict objectForKey:EVENT_CATEGORY_ID];
        eventsVO.venue     = [attributeDict objectForKey:EVENT_VENUENAME];
        eventsVO.venueId   = [attributeDict objectForKey:EVENT_VENUEID];
        eventsVO.VenueDescription = [attributeDict objectForKey:EVENT_VENUEDETAILS];
        eventsVO.locationLatitude = [attributeDict objectForKey:EVENT_LOCATIONLATITUDE];
        eventsVO.locationLongitude = [attributeDict objectForKey:EVENT_LOCATIONLONGITUDE];
        eventsVO.isAlcoholic  = [attributeDict objectForKey:EVENT_ISALCHOLIE];
        eventsVO.entryRestriction = [attributeDict objectForKey:EVENT_ENTRYRESTRICTION];
        eventsVO.contactPersonName = [attributeDict objectForKey:EVENT_CONTACTPERSONNAME];
        eventsVO.contactPersonEmail = [attributeDict objectForKey:EVENT_CONTECTPERSONEMAIL];
        eventsVO.ContactPersonNumber = [attributeDict objectForKey:EVENT_CONTECTPERSONNUMBER];
        if ([attributeDict objectForKey:EVENT_SEATLAYOUT] != nil || ![[attributeDict objectForKey:EVENT_SEATLAYOUT]isEqualToString:@""]) {
            eventsVO.seatLayoutUrl = [attributeDict objectForKey:EVENT_SEATLAYOUT];
          }
        else{
            eventsVO.seatLayoutUrl = EVENT_NO_SEATLAYOUT;
        }
        eventsVO.posterUrl     = [attributeDict objectForKey:EVENT_POSTERURL];
//        eventsVO.colorcode     = [attributeDict objectForKey:EVENT_COLOR_CODE];
//        eventsVO.bgBorderColorCode = [attributeDict objectForKey:EVENT_BORDER_COLOR_CODE];
//        eventsVO.backgroundColorcode = [attributeDict objectForKey:EVENT_BG_COLOR_CODE];
//        eventsVO.btncolorcode  = [attributeDict objectForKey:EVENT_BTN_COLOR_CODE];
//        eventsVO.titleColorCode = [attributeDict objectForKey:EVENT_TITLE_COLOR_CODE];
        eventsVO.eventUrl       = [attributeDict objectForKey:EVENT_EVENTURL];
        eventsVO.strNoOfTktCategory = [attributeDict objectForKey:EVENT_NO_OF_SEATS_FOR_CATEGORY];
        eventsVO.strEventUrlIs = [attributeDict objectForKey:EVENT_EVENTSHARE_PATH];
        eventsVO.strBannerUrl = [attributeDict objectForKey:EVENT_BANNERURL];
        eventsVO.strEventType = [attributeDict objectForKey:EVENT_TYPEOFEVENT];
        eventsVO.strEventCategoryUrlis = [attributeDict objectForKey:EVENT_CATEGORYURLIS];
        eventsVO.strlastModifiedDateis = [attributeDict objectForKey:EVENTS_LAST_MODIFIED];
        
        
        
        [tempEventsArr addObject:eventsVO];
        
    }
    
    if ([elementName isEqualToString:TICKET]) {
        
        EventsVO *eventlastis = (EventsVO *)[tempEventsArr lastObject];
        TicketTypes *ticketobj = [[TicketTypes alloc] init];
        ticketobj.ticketMasterId = [attributeDict objectForKey:TICKET_MASTERID];
        ticketobj.ticketPriceId = [attributeDict objectForKey:TICKET_PRICEID];
        ticketobj.ticketType   = [attributeDict objectForKey:TICKET_TYPE];
        ticketobj.totalTickets = [attributeDict objectForKey:TICKET_TOTAL_NOOF_TICKETS];
        ticketobj.noofAvailableTickets = [attributeDict objectForKey:TICKETS_NOOF_AVAILABLETICKETS];
        ticketobj.ticketAdmit  = [attributeDict objectForKey:TICKET_ADMIT];
        ticketobj.ticketPrice  = [attributeDict objectForKey:TICKET_TICKETPRICE];
        ticketobj.ticketServiceCharge= [attributeDict objectForKey:TICKET_SERVICECHARGE];
        ticketobj.strEventDateasPerCate = [attributeDict objectForKey:TICKET_DATEASPERCATEGORY];
        ticketobj.strnoofTicketsPerTransaction = [attributeDict objectForKey:TICKET_NOOFTICKETSPERTRANS];
        //new param
        ticketobj.strTicketPaidrFree = [attributeDict objectForKey:TICKET_FREE_PAID];
        [eventlastis.eventTicketsArray addObject:ticketobj];
        
        
    }
    
   
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:RESPONSE])
    {
        [eventsDict setValue:tempEventsArr forKeyPath:EVENTS];
        [outputArr addObject:eventsDict];
    }

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    
}


- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    [self setIsErrorOccurred:YES];
    
    [delegate parseErrorOccurredWithRequestMessage:requestMessage parsingError:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

@end
