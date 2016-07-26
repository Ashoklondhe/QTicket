//
//  EventDescriptionViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 01/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "EventDescriptionViewController.h"
#import "StrechyParallaxScrollView.h"
#import "MarqueeLabel.h"
#import "EGOImageView.h"
#import "Q-ticketsConstants.h"
#import "SMSCountryUtils.h"
#import "AppDelegate.h"
#import "ShowTimingsViewController.h"
#import "EventsBookingViewController.h"
#import "EventLocationViewController.h"
#import <MessageUI/MessageUI.h>
#import "EventsViewController.h"

@interface EventDescriptionViewController ()<MFMailComposeViewControllerDelegate,UIScrollViewDelegate>{
    
    IBOutlet MarqueeLabel                   *lblviewTitle;
    IBOutlet StrechyParallaxScrollView *wholeScrollview;
    IBOutlet UIScrollView              *scrollviewofEventDescription;
    IBOutlet UIView                    *viewofTopview;
    IBOutlet EGOImageView              *imgviewforEvent;
    IBOutlet UIView                    *viewofEventinfo;
    IBOutlet UIView                    *viewofEventDesc;
    IBOutlet UILabel                   *lblDateofEvent;
    IBOutlet UILabel                   *lblTimeofEvent;
    IBOutlet UILabel                   *lblAddressofEvent;
    IBOutlet UILabel                   *lblTypeofEvent;
    IBOutlet UITextView                *tvofEventDescription;
    IBOutlet UIImageView               *imgofNav;
    AppDelegate                        *delegateApp;
    IBOutlet UIImageView               *imgviewofArrow;
    IBOutlet UIButton                  *btnBack;
    IBOutlet UIImageView               *imgviewofBottom;
    IBOutlet UIButton                  *btnBooknow;
    IBOutlet UIButton                  *btnCallnow;
    IBOutlet UIButton                  *btnEmailnow;
    IBOutlet UIView                    *viewforinfoActions;

    
    
}

@end

@implementation EventDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    delegateApp               = QTicketsAppDelegate;
    
    lblviewTitle.marqueeType  = MLContinuous;
    lblviewTitle.trailingBuffer = 15.0f;
    lblviewTitle.text         = delegateApp.selectedEvent.EventName;
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }

    
    if ([SMSCountryUtils isIphone]) {
        
        wholeScrollview           = [[StrechyParallaxScrollView alloc] initWithFrame:CGRectMake(0, 0,ViewWidth, ViewHeight-50) andTopView:viewofTopview];
        [viewofTopview setFrame:CGRectMake(0, 0, ViewWidth, 200)];
        [scrollviewofEventDescription setFrame:CGRectMake(0, 200, ViewWidth, 380)];
        [scrollviewofEventDescription setContentSize:CGSizeMake(ViewWidth,380)];
        [wholeScrollview setContentSize:CGSizeMake(ViewWidth,ViewHeight)];
        [wholeScrollview addSubview:scrollviewofEventDescription];

    }
    else{
        
        wholeScrollview           = [[StrechyParallaxScrollView alloc] initWithFrame:CGRectMake(0, 0,ViewWidth, ViewHeight-100) andTopView:viewofTopview];
        [viewofTopview setFrame:CGRectMake(0, 0, ViewWidth, 400)];
        [scrollviewofEventDescription setFrame:CGRectMake(0, 400, ViewWidth, 600)];
        [scrollviewofEventDescription setContentSize:CGSizeMake(ViewWidth,600)];
        [wholeScrollview setContentSize:CGSizeMake(ViewWidth,ViewHeight)];
        [wholeScrollview addSubview:scrollviewofEventDescription];

        
    }
    
    
    [self.view addSubview:wholeScrollview];
    [self.view bringSubviewToFront:imgofNav];
    [self.view bringSubviewToFront:lblviewTitle];
    [self.view bringSubviewToFront:imgviewofArrow];
    [self.view bringSubviewToFront:btnBack];
    [wholeScrollview bringSubviewToFront:imgviewofBottom];
    [wholeScrollview bringSubviewToFront:btnBooknow];
    
    
    

    [viewofEventinfo.layer setBorderColor: [[UIColor colorWithRed:0.25490 green:0.25490 blue:0.25490 alpha:1] CGColor]];
    [viewofEventinfo.layer setBorderWidth: 1.0];
    
    NSString *imagtThumbnailurl   = [NSString stringWithFormat:@"%@",delegateApp.selectedEvent.strBannerUrl];
    imagtThumbnailurl = [imagtThumbnailurl stringByReplacingOccurrencesOfString:@"/App_Images/" withString:@"/movie_Images/"];
    if ([SMSCountryUtils isIphone]) {
        imgviewforEvent                = [imgviewforEvent initWithPlaceholderImage:[UIImage imageNamed:@"event-loading-image.png"]];

    }
    else{
        imgviewforEvent                = [imgviewforEvent initWithPlaceholderImage:[UIImage imageNamed:@"event-loading-image~ipad.png"]];

        
    }
       imgviewforEvent.imageURL       = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imagtThumbnailurl]];
    
 
    lblDateofEvent.text           =  delegateApp.selectedEvent.startDate;
    lblTypeofEvent.text           =  delegateApp.selectedEvent.entryRestriction;
    
    NSString *streventDesc        =[NSString stringWithFormat:@"%@",delegateApp.selectedEvent.EventDescription];
    NSRange range;
    while ((range = [streventDesc rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        streventDesc = [streventDesc stringByReplacingCharactersInRange:range withString:@""];

    streventDesc = [[streventDesc componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    
    tvofEventDescription.text     = streventDesc;
    

    lblTimeofEvent.text           = delegateApp.selectedEvent.startTime;
    lblAddressofEvent.text        = delegateApp.selectedEvent.venue;
    lblTypeofEvent.text           = delegateApp.selectedEvent.entryRestriction;
    

     CGSize newTagdesc = [tvofEventDescription sizeThatFits:CGSizeMake(ViewWidth, CGFLOAT_MAX)];
    
    [viewofEventDesc setFrame:CGRectMake(0, viewofEventDesc.frame.origin.y, ViewWidth, tvofEventDescription.frame.size.height+10)];

    [tvofEventDescription setFrame:CGRectMake(tvofEventDescription.frame.origin.x, tvofEventDescription.frame.origin.y, ViewWidth, newTagdesc.height)];
    
    
    CGFloat extraHeight;
    
    if ([SMSCountryUtils isIphone]) {
        
        extraHeight = 50;
        
    }
    else
    {
        extraHeight = 100;
    }
    
    
    [viewforinfoActions setFrame:CGRectMake(0,tvofEventDescription.frame.origin.y+tvofEventDescription.frame.size.height+extraHeight, ViewWidth, viewforinfoActions.frame.size.height)];
    

    
    [scrollviewofEventDescription setContentSize:CGSizeMake(ViewWidth, viewforinfoActions.frame.origin.y+viewforinfoActions.frame.size.height+20)];

}



-(IBAction)btnViewMapClicked:(id)sender
{
    EventLocationViewController *EvnetInMap = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventLocationViewController"];
    [self.navigationController pushViewController:EvnetInMap animated:YES];
}



-(IBAction)btnSendEmailClicked:(id)sender
{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[NSString stringWithFormat:@"Regarding %@",delegateApp.selectedEvent.EventName]];
        [mailViewController setToRecipients:[NSArray arrayWithObjects:@"thomas@q-tickets.com",nil]];
        [self presentViewController:mailViewController animated:YES completion:Nil];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Configure Gmail In Device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag=3;
        [alert show];
    }


}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Mail Sent Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case MFMailComposeResultFailed:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Configure Gmail In Device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}


-(IBAction)btnPhoneNoClicked:(id)sender
{
    NSString *strcellnumber = delegateApp.selectedEvent.ContactPersonNumber;
    UIDevice *device = [UIDevice currentDevice];
    UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:nil message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    NSString * strPhoneNumber = [strcellnumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [strcellnumber length])];
    
            if ([[device model] isEqualToString:@"iPhone"] )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[@"telprompt://" stringByAppendingString:strPhoneNumber]]]];
            } else {
                [notPermitted show];
            }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBackClicked:(id)sender {

//    [self.navigationController popViewControllerAnimated:YES];
    
    
    NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    int index = 0;
    for(int i=0 ; i<[arrofNavoagtionsCon count] ; i++)
    {
        if([[arrofNavoagtionsCon objectAtIndex:i] isKindOfClass:NSClassFromString(@"EventsViewController")])
        {
            index = i;
            break;
        }
    }
    if (index != 0) {
        [self.navigationController popToViewController:[arrofNavoagtionsCon objectAtIndex:index] animated:YES];
        
    }
    else{
        
        EventsViewController *eventsviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventsViewController"];
        [self.navigationController pushViewController:eventsviewVC animated:NO];
        
    }
    
    
}
- (IBAction)btnBooknowClicked:(id)sender {
    
    
    EventsBookingViewController *eventBook = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventsBookingViewController"];
    [self.navigationController pushViewController:eventBook animated:YES];
   

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
