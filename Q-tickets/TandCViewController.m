//
//  TandCViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 20/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "TandCViewController.h"
#import "Q-ticketsConstants.h"
#import "QticketsSingleton.h"
#import "AppDelegate.h"
@interface TandCViewController ()
{
    IBOutlet UITextView *tvofTermsandConditons;
    QticketsSingleton   *singleTon;
    AppDelegate *delegateApp;
}

@end

@implementation TandCViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([SMSCountryUtils isIphone]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:BackgroundImage2x]];
        
    }
    delegateApp = QTicketsAppDelegate;
    delegateApp.inTandC = YES;
    singleTon  = [QticketsSingleton sharedInstance];

    NSMutableString *strString = [[NSMutableString alloc] init];
    NSMutableArray *arrofTandC = [[NSMutableArray alloc]initWithArray:singleTon.arrofTermsAndConditions];
    
    if (!singleTon.isMovieSelected) {
        
        [arrofTandC replaceObjectAtIndex:0 withObject:@""];
        [arrofTandC replaceObjectAtIndex:1 withObject:@""];
        [arrofTandC replaceObjectAtIndex:2 withObject:@""];
        [arrofTandC replaceObjectAtIndex:3 withObject:@""];
        [arrofTandC replaceObjectAtIndex:4 withObject:@""];

    }
    
    [arrofTandC removeObject:@""];
    
    
    
    
    for (int k=0; k<arrofTandC.count; k++) {
        
        [strString appendString:[NSString stringWithFormat:@"%d. %@ \n \n ",(k+1),[arrofTandC objectAtIndex:k]]];
        
    }
     [tvofTermsandConditons setText:strString];
    

 
}


-(IBAction)btnBackClicked:(id)sender
{
    delegateApp.inTandC = NO;
    singleTon.isTermsAndConditions = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)btnCancelClicked:(id)sender
{
    delegateApp.inTandC = NO;
    singleTon.isTermsAndConditions = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnOkayClicked:(id)sender
{
    delegateApp.inTandC = NO;
    singleTon.isTermsAndConditions = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
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
