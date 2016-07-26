//
//  PaymentWebViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 21/05/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "PaymentWebViewController.h"
#import "MarqueeLabel.h"
#import "AppDelegate.h"
#import "SMSCountryUtils.h"
#import "Q-ticketsConstants.h"
#import "TicketConfirmViewController.h"
#import "QticketsSingleton.h"
#import "CancelRequestParseOpeartion.h"
#import "Movies_EventsViewController.h"


@interface PaymentWebViewController ()<UIWebViewDelegate,CommonParseOperationDelegate>
{
    IBOutlet UIWebView *webviewforBrowse;
    IBOutlet MarqueeLabel *lblofViewTitle;
    AppDelegate      *delegateApp;
    SMSCountryUtils  *sutilits;
    
    NSMutableArray            *connectionsArr;
    NSOperationQueue          *queue;
    NSMutableArray            *parsersArr;
    
//    NSTimer                   *cardtransactionTimer;
    int                        timeOutInMin;
    NSTimer                   *timerfortrans;
    QticketsSingleton *singleTon;
    UIAlertView *alertTransti;

}
@end

@implementation PaymentWebViewController
@synthesize SelectedBankIndexIs,strNationalityIS,strTransactionIdis,currentSelec;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    delegateApp      = QTicketsAppDelegate;
    sutilits         = [[SMSCountryUtils alloc] init];
    connectionsArr   = [[NSMutableArray alloc] init];
    parsersArr       = [[NSMutableArray alloc] init];
    queue            = [[NSOperationQueue alloc] init];
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
    }
    NSURL *requestUrl;
    NSString *bodyis;
    if (self.SelectedBankIndexIs == 3) {
        //for doha bank
        requestUrl = [NSURL URLWithString:@"https://api.q-tickets.com/Qpayment-registration.aspx?"];
        bodyis = [NSString stringWithFormat:@"Transaction_Id=%@&paymenttype=1&nationality=%@",self.strTransactionIdis,self.strNationalityIS];
    }
    else{
        //for qpay
        requestUrl = [NSURL URLWithString:@"https://api.q-tickets.com/Qpayment-registration1.aspx?"];
        bodyis = [NSString stringWithFormat:@"Transaction_Id=%@&paymenttype=3&nationality=%@",self.strTransactionIdis,self.strNationalityIS];
    }
    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc]initWithURL: requestUrl];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [bodyis dataUsingEncoding: NSUTF8StringEncoding]];
    [webviewforBrowse loadRequest: request];
    singleTon = [QticketsSingleton sharedInstance];
    timeOutInMin=self.currentSelec.timeOutInMin;
    timerfortrans = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(lockConfirmMethodPayWeb:) userInfo:@"" repeats:YES];

    
}

-(void)lockConfirmMethodPayWeb:(NSTimer *)sender
{
    
    
    if ( singleTon.timerforPaymentConfirm == 0) {
        
        if (timerfortrans != nil) {
            
            [timerfortrans invalidate];
            timerfortrans = nil;
        }

        singleTon.transactiontimerCount=1;
        alertTransti=[[UIAlertView alloc]initWithTitle:@"" message:TRANSACTION_TIME_OUT delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [timerfortrans invalidate];
        timerfortrans = nil;
        alertTransti.tag=TRANSACTIONTIME_OUT;
        [alertTransti show];
            }
    
    else{
         singleTon.timerforPaymentConfirm =  singleTon.timerforPaymentConfirm -1;
    }
    
    
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TRANSACTIONTIME_OUT)
    {
        if (buttonIndex == 0)
        {
            [self cancelRequestWithTransactionId:singleTon.seatCnfmtn.transactionID];
        }
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    [sutilits showLoaderWithTitle:nil andSubTitle:@"Processing..."];
    
    
    NSString *url = [[request URL] absoluteString];
    
    
    static NSString *urlPrefix = @"https://";
    if ([url hasPrefix:urlPrefix]) {
        if ([url hasPrefix:urlPrefix]) {
            NSString *paramsString = [url substringFromIndex:[urlPrefix length]];
            NSArray *paramsArray = [paramsString componentsSeparatedByString:@"/"];
            
            if ([[paramsArray objectAtIndex:1] isEqualToString:@"event_booked_ticket.aspx"]) {
                
                
                if (timerfortrans != nil) {
                    
                    [timerfortrans invalidate];
                    timerfortrans = nil;
                }
 
                TicketConfirmViewController *ticketConVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"TicketConfirmViewController"];
                [ticketConVC setCurrentSelec:self.currentSelec];
                singleTon.transactiontimerCount =  1;
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
    
    [self cancelRequestWithTransactionId:singleTon.seatCnfmtn.transactionID];



}

#pragma mark
#pragma mark Service Calls
#pragma mark

-(void)cancelRequestWithTransactionId:(NSString *)transactnID
{
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn cancelRequestWithTransactionId:transactnID];
    [connectionsArr addObject:conn];
}
- (void) finishedReceivingData:(NSData *)data withRequestMessage:(NSString *)reqMessage {
    if ([reqMessage isEqualToString:CANCEL_CONFIRMATION]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        CancelRequestParseOpeartion *cParser = [[CancelRequestParseOpeartion alloc] initWithData:data delegate:self andRequestMessage:CANCEL_CONFIRMATION];
        [queue addOperation:cParser];
        [parsersArr addObject:cParser];
        data = nil;
    }
}
- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage {
    
    if ([reqMessage isEqualToString:CANCEL_CONFIRMATION])
    {

        if (timerfortrans != nil) {
            
            [timerfortrans invalidate];
            timerfortrans = nil;
        }
        singleTon.seatCnfmtn=nil;
        singleTon.transactiontimerCount=1;

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_NOT_RESPONDING delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
    }
}
- (void)didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr {
    if ([reqMsg isEqualToString:CANCEL_CONFIRMATION]) {
        [self performSelectorOnMainThread:@selector(handleLoadedCancelRequest:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
}
- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    if ([reqMsg isEqualToString:CANCEL_CONFIRMATION]) {
        [self performSelectorOnMainThread:@selector(handleCancelCnfmntParserError:) withObject:error waitUntilDone:NO];
    }
    queue = nil;
}

-(void)handleLoadedCancelRequest:(NSArray *)parserArr
{
    //  NSLog(@"parser response for cancel the payment :%@",parserArr);
    
    
    if([parserArr count]>0)
    {
        NSMutableDictionary *cancelDictionary = [parserArr objectAtIndex:0];
        
        if ([[cancelDictionary valueForKey:STATUS] isEqualToString:@"True"])
        {
            if (timerfortrans != nil) {
                
                [timerfortrans invalidate];
                timerfortrans = nil;
            }
            singleTon.seatCnfmtn=nil;
            singleTon.transactiontimerCount=1;
            
            
             [sutilits hideLoader];
            
            //got to ticket confirm with cancel status msg
            
            NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            
            for (UIViewController *aViewController in arrofNavoagtionsCon) {
                if ([aViewController isKindOfClass:[Movies_EventsViewController class]]) {
                    [self.navigationController popToViewController:aViewController animated:YES];
                    break;
                }
                else{
                    Movies_EventsViewController *MoviesviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"Movies_EventsViewController"];
                    [self.navigationController pushViewController:MoviesviewVC animated:YES];
                    break;
                }
            }
            
            
            
        }
    }
    else
    {
        if (timerfortrans != nil) {
            
            [timerfortrans invalidate];
            timerfortrans = nil;
        }
        singleTon.seatCnfmtn=nil;
        singleTon.transactiontimerCount=1;

         [sutilits hideLoader];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:SERVER_ERROR delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=SERVER_ERROR_ALERT;
        [alert show];
        
    }
}

-(void)handleCancelCnfmntParserError:(NSError *)error
{

    if (timerfortrans != nil) {
        
        [timerfortrans invalidate];
        timerfortrans = nil;
    }
    singleTon.seatCnfmtn=nil;
    singleTon.transactiontimerCount=1;

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=SERVER_ERROR_ALERT;
    [alert show];
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
