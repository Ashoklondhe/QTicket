//
//  EventsWebViewController.m
//  Q-tickets
//
//  Created by Shivam Mishra on 17/06/16.
//  Copyright © 2016 KrishnaSunkara. All rights reserved.
//

#import "EventsWebViewController.h"
#import "MBProgressHUD.h"
#import "SMSCountryUtils.h"
@interface EventsWebViewController ()<UIWebViewDelegate>{
    SMSCountryUtils  *sutilits;
        __weak IBOutlet UILabel *titleLabel;
    
    
    
}

@end

@implementation EventsWebViewController

+ (EventsWebViewController *)initWithTitle:(NSString *)title andWebURL:(NSString *)urlString {
    EventsWebViewController *eventsWebViewController = [[EventsWebViewController alloc] initWithNibName:@"EventsWebViewController" bundle:[NSBundle mainBundle]];
    eventsWebViewController.title = title;
    eventsWebViewController.urlStr = urlString;
    return eventsWebViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventWebView.delegate = self;
    sutilits = [[SMSCountryUtils alloc] init];
    titleLabel.adjustsFontSizeToFitWidth = false;
    if ([SMSCountryUtils isIphone]){
        titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:18.0];
    }
    else{
        titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:28.0];
    }
    titleLabel.text = self.title;
    
    //to set the color of navigation bar
    if ([self.title isEqualToString:@"Events"]) {
        self.navigationView.backgroundColor=[UIColor colorWithRed:229/256.0 green:122/256.0 blue:56/256.0 alpha:1.0f];
    }else{
        self.navigationView.backgroundColor=[UIColor colorWithRed:26/256.0 green:89/256.0 blue:189/256.0 alpha:1.0f];
        
    }

    
    NSURL * url = [NSURL URLWithString:self.urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [self.eventWebView loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [sutilits showLoaderWithTitle:nil andSubTitle:@"Processing..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [sutilits hideLoader];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [sutilits hideLoader];
}

- (IBAction)btnBackTap:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
