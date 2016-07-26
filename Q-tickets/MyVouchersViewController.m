//
//  MyVouchersViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 17/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "MyVouchersViewController.h"
#import "MyVouchersTableViewCell.h"
#import "Q-ticketsConstants.h"
#import "SMSCountryConnections.h"
#import "SMSCountryLocalDB.h"
#import "SMSCountryUtils.h"
#import "QticketsSingleton.h"
#import "CommonParseOperation.h"
#import "UserVoucherParseOperation.h"
#import "SMSCountryUtils.h"
#import "AppDelegate.h"
#import "HomeViewController.h"


@interface MyVouchersViewController ()<UITableViewDelegate,UITableViewDataSource,CommonParseOperationDelegate>{
    
     IBOutlet UITableView *tbofMyVouchers;
    
     IBOutlet UILabel *lblofviewTitle;
    
    QticketsSingleton    *singleton;
    NSMutableArray       *connectionsArr;
    NSMutableArray       *parsersArr;
    NSOperationQueue     *queue;
    NSMutableArray       *arrofVoucherDetails;
    SMSCountryUtils      *scutil;
   
    AppDelegate          *delegateApp;
    
}
//cell animation


@end

@implementation MyVouchersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegateApp = QTicketsAppDelegate;
    
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }
    
    connectionsArr    = [[NSMutableArray alloc] init];
    parsersArr        = [[NSMutableArray alloc] init];
    queue             = [[NSOperationQueue alloc] init];
    arrofVoucherDetails= [[NSMutableArray alloc] init];

    scutil             = [[SMSCountryUtils alloc] init];
    
   
    
    singleton = [QticketsSingleton sharedInstance];
    
    
    if (singleton.cureentLoginUser.status == 1)
    {
            [self userVoucherDetails:singleton.cureentLoginUser.serverId];
    }
    
    
  
    
}

#pragma mark ----- calling for voucher detials


-(void)userVoucherDetails:(NSString *)userId{
    
    SMSCountryConnections *conn = [[SMSCountryConnections alloc]initWithDelegate:self];
    [conn getUserVoucherwithUserID:userId];
    [connectionsArr addObject:conn];
    [scutil showLoaderWithTitle:@"" andSubTitle:PROCESSING];
    
}


- (void) finishedReceivingData:(NSData*)data withRequestMessage:(NSString *)reqMessage{
    
    if ([reqMessage isEqualToString:GET_ALLEVOUCHERS]) {
        
        NSOperationQueue *tmpQueue = [[NSOperationQueue alloc] init];
        queue = tmpQueue;
        UserVoucherParseOperation *bParser = [[UserVoucherParseOperation alloc] initWithData:data delegate:self andRequestMessage:GET_ALLEVOUCHERS];
        [queue addOperation:bParser];
        [parsersArr addObject:bParser];
        data = nil;
        
    }

}
- (void) errorReceivingData:(NSString *)error withRequestMessage:(NSString *)reqMessage{
    
    if ([reqMessage isEqualToString:GET_ALLEVOUCHERS]) {
        
        if ([SMSCountryLocalDB  getVoucherDetailsForlocalUserId:singleton.cureentLoginUser.serverId].count>0)
        {
            [arrofVoucherDetails addObjectsFromArray:[SMSCountryLocalDB getVoucherDetailsForlocalUserId:singleton.cureentLoginUser.serverId]];
            [tbofMyVouchers reloadData];
        }
        else
        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:VOUCHERDETAILS_NOT_AVAILABLE];
        }
    }
    else
    {
        [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:error.description];
    }

    
    
}



#pragma mark  ---- VoucherDetails Parsing Delegate methods

- (void)didFinishParsingWithRequestMessage:(NSString *)reqMsg parsedArray:(NSArray *)parseArr {
    if ([reqMsg isEqualToString:GET_ALLEVOUCHERS]) {
        [self performSelectorOnMainThread:@selector(handleUserVoucherDetails:) withObject:parseArr waitUntilDone:NO];
        queue = nil;   // we are finished with the queue and our ParseOperation
    }
}

- (void)parseErrorOccurredWithRequestMessage:(NSString *) reqMsg parsingError:(NSError *)error {
    if ([reqMsg isEqualToString:GET_ALLEVOUCHERS]) {
        [self performSelectorOnMainThread:@selector(handleParserErrorVOU:) withObject:error waitUntilDone:NO];
    }
    queue = nil;
}



#pragma  mark ---- VoucherDetails parser methods




-(void)handleUserVoucherDetails:(NSArray *)parsedArr{
    
#ifdef PRINT_LOGS
    NSLog(@"%s ",__FUNCTION__);
#endif
    // if parsed Arr count is greater then zero. Now we can insert bookinghistory into localdb
    [scutil hideLoader];
    if (parsedArr.count>0)
    {
//        [SMSCountryLocalDB deleteAllVoucherDetailsForUserId:singleton.cureentLoginUser.serverId];
//        
        [arrofVoucherDetails addObjectsFromArray:parsedArr];
//        for (int i=0;i<[arrofVoucherDetails count];i++)
//        {
//            UserVoucherVO *VoucherVO = [arrofVoucherDetails objectAtIndex:i];
//            VoucherVO.status=@"1";
//            [SMSCountryLocalDB insertVoucherDetails:VoucherVO forLocalUserId:singleton.cureentLoginUser.serverId];
//           
//        }
      [tbofMyVouchers reloadData];
    }
    else //obtaining data from localdb
    {
//        if ([SMSCountryLocalDB getVoucherDetailsForlocalUserId:singleton.cureentLoginUser.serverId].count>0)
//        {
//            arrofVoucherDetails = [SMSCountryLocalDB getVoucherDetailsForlocalUserId:singleton.cureentLoginUser.serverId];
//            [tbofMyVouchers reloadData];
//        }
//        else
//        {
            [SMSCountryUtils showAlertMessageWithTitle:@"" Message:ALERT_WARNING_NO_VOUCHERS];
            [self.navigationController popViewControllerAnimated:YES];
//        }
    }

    
    
}


-(void)handleParserErrorVOU:(NSError *)error{
    
    
    [SMSCountryUtils showAlertMessageWithTitle:@"Error" Message:[error localizedDescription]];

    
}


- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
  /*
    NSMutableArray *arrofNavoagtionsCon = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    int index = 0;
    for(int i=0 ; i<[arrofNavoagtionsCon count] ; i++)
    {
        if([[arrofNavoagtionsCon objectAtIndex:i] isKindOfClass:NSClassFromString(@"HomeViewController")])
        {
            index = i;
            break;
        }
    }
    if (index != 0) {
        [self.navigationController popToViewController:[arrofNavoagtionsCon objectAtIndex:index] animated:YES];
        
    }
    else{
        
        HomeViewController *homeviewVC = [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:homeviewVC animated:NO];
        
    }*/

}



#pragma tbofMyvouchers Datasource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([SMSCountryUtils isIphone]) {
        return 140.0;
    }
    else{
        
        return 270.0;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrofVoucherDetails.count;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    MyVouchersTableViewCell *myvouchersCell = (MyVouchersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyVouchersTableViewCell"];
    if (myvouchersCell == nil) {
        
        myvouchersCell = [[[NSBundle mainBundle]loadNibNamed:@"MyVouchersTableViewCell" owner:self options:nil] objectAtIndex:0];
        
    }
    
    UserVoucherVO *voucherDet = [arrofVoucherDetails objectAtIndex:indexPath.row];
    [myvouchersCell.lblofvoucherNumber setText:voucherDet.voucherCoupon];
    [myvouchersCell.lblofVoucherCode setText:voucherDet.voucherCoupon];
    [myvouchersCell.lblofVoucherValue setText:[NSString stringWithFormat:@"%@",voucherDet.voucherValue]];
    [myvouchersCell.lblofVoucherGeneratedDate setText:voucherDet.vocuhergenerationDate];
    [myvouchersCell.lblofVoucherExpiredDate setText:voucherDet.voucherexpireDate];
    [myvouchersCell.lblofVoucherBalance setText:voucherDet.voucherBalanceValue];
    if ([voucherDet.voucherStatus isEqualToString:@"1"] || [voucherDet.voucherStatus isEqualToString:@"2"]) {
        
        [myvouchersCell.lblofVoucherStatus setText:@"Used"];
    }
    else{
        
        [myvouchersCell.lblofVoucherStatus setText:@"Not Used"];
    }
    
    myvouchersCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return myvouchersCell;
    
    
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
//    cell.layer.transform  = self.initialTransformation;
//    cell.layer.opacity    = 0.8;
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.layer.transform = CATransform3DIdentity;
//        cell.layer.opacity   = 1;
//    }];
    
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
