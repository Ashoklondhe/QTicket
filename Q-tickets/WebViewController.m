//
//  WebViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "WebViewController.h"
#import "Q-ticketsConstants.h"
#import "LoginViewController.h"
#import "MyProfileViewController.h"
#import "MyBookingsViewController.h"
#import "ChangePasswordViewController.h"
#import "MyVouchersViewController.h"
#import "MobileNumVerifyViewController.h"
#import "AppDelegate.h"
#import "MarqueeLabel.h"
#import "TicketConfirmViewController.h"
#import "SMSCountryUtils.h"
#import "EventsViewController.h"

@interface WebViewController ()<UIWebViewDelegate>{
    
     IBOutlet UIView *homeView;
    
     IBOutlet UIWebView *webviewforBrowse;
    
     IBOutlet MarqueeLabel *lblofViewTitle;
    AppDelegate      *delegateApp;
    SMSCountryUtils  *sutilits;
}

@end

@implementation WebViewController
@synthesize strTitleofView,strEventOrderId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    delegateApp   = QTicketsAppDelegate;
    sutilits      = [[SMSCountryUtils alloc] init];
    lblofViewTitle.marqueeType    = MLContinuous;
    lblofViewTitle.trailingBuffer = 15.0f;
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }
    
   
     NSURL *url = [NSURL URLWithString: @"https://api.q-tickets.com/eventpaymentpage.aspx?"];
    
    NSString *body = [NSString stringWithFormat: @"OrderId=%@",self.strEventOrderId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [webviewforBrowse loadRequest: request];
    
    
}





- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
     [sutilits showLoaderWithTitle:nil andSubTitle:@"Processing..."];
    
    
    NSString *url = [[request URL] absoluteString];
    
    
    static NSString *urlPrefix = @"https://";
//
    if ([url hasPrefix:urlPrefix]) {
        if ([url hasPrefix:urlPrefix]) {
            NSString *paramsString = [url substringFromIndex:[urlPrefix length]];
            NSArray *paramsArray = [paramsString componentsSeparatedByString:@"/"];
            
            if ([[paramsArray objectAtIndex:1] isEqualToString:@"event_booked_ticket.aspx"]) {
                
                
                
                TicketConfirmViewController *ticketConVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"TicketConfirmViewController"];
                
                [ticketConVC setStrEventOrderID:self.strEventOrderId];
                [self.navigationController pushViewController:ticketConVC animated:YES];
                
            }
            
         
        }
        
        
    }
    
    
    return YES;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [sutilits hideLoader];


}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
    
    
}

- (IBAction)btnBackClicked:(id)sender {
    
    [webviewforBrowse stopLoading];
    webviewforBrowse= nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
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
        
        EventsViewController *eventVc = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"EventsViewController"];
        [self.navigationController pushViewController:eventVc animated:NO];
        
    }
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
