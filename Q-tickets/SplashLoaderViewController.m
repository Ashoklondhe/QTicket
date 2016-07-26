//
//  SplashLoaderViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 06/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "SplashLoaderViewController.h"

#import "InitialDataGetting.h"
#import "HomeViewController.h"

#import "QticketsSingleton.h"
#import "SMSCountryLocalDB.h"
#import "SMSCountryConnections.h"
#import "SMSCountryUtils.h"
#import "CommonParseOperation.h"
#import "AppDelegate.h"


@interface SplashLoaderViewController (){
  
    IBOutlet UIImageView *imgviewforPlaceholder;
    InitialDataGetting *initialData;
    AppDelegate    *delegateApp;
    
    BOOL alreadyPushed;
}

@end

@implementation SplashLoaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    delegateApp    =  QTicketsAppDelegate;
    alreadyPushed  = NO;
    
    NSMutableArray *arrofloaders = [[NSMutableArray alloc]init];
    
    for (int i =1; i<=5; i++) {
        
        if ([SMSCountryUtils isIphone]) {
            
            if (ViewWidth == iPhone6PlusWidth) {
                
                [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Loading0%d@3x.png",i]]];
            }
            else if (ViewWidth == iPhone6Width){
                
                [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Loading0%d@2x.png",i]]];
            }
            else{
            
            [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Loading0%d.png",i]]];
                
            }
        }
        else{
            
            if ([SMSCountryUtils isRetinadisplay]) {
                [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Loading0%d~ipad.png",i]]];
            }
            else{
                
                [arrofloaders addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Loading0%d@2x~ipad.png",i]]];
            }
            
        }
        
        }
    
    
    imgviewforPlaceholder.animationImages = arrofloaders;
    
    imgviewforPlaceholder.animationDuration = 3;
    [imgviewforPlaceholder startAnimating];
    
    
    if ([SMSCountryUtils netAvailableorNot]) {
        
        initialData = [[InitialDataGetting alloc]init];
       // [initialData getAllContentData];
        [self dataSuccessfullyRetrieved];
      
    }
    else{
        
        [SMSCountryUtils showAlertMessageWithTitle:@"Alert" Message:@"Network is Not Available" withDelegate:nil withCancelBtn:NO withOkBtn:YES];
        [imgviewforPlaceholder stopAnimating];
        if ([SMSCountryUtils isIphone]) {
            
            if (ViewWidth == iPhone6PlusWidth) {
                
                [imgviewforPlaceholder setImage:[UIImage imageNamed:@"Loading01@3x.png"]];
            }
            else if (ViewWidth == iPhone6Width){
                
                [imgviewforPlaceholder setImage:[UIImage imageNamed:@"Loading01@2x.png"]];
            }
            else{
                
                [imgviewforPlaceholder setImage:[UIImage imageNamed:@"Loading01.png"]];
            }
        }
        else{
            
            if ([SMSCountryUtils isRetinadisplay]) {
                
                [imgviewforPlaceholder setImage:[UIImage imageNamed:@"Loading01~ipad.png"]];
            }
            else{
                
                [imgviewforPlaceholder setImage:[UIImage imageNamed:@"Loading01@2x~ipad.png"]];
            }
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callfordata) name:@"NotifyUser" object:nil];

    [self.view bringSubviewToFront:imgviewforPlaceholder];
    
    
}

-(void)callfordata{
    
    
    if (alreadyPushed == NO) {
        
        

    [imgviewforPlaceholder stopAnimating];
    
    
      
    HomeViewController *homeVC= [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:homeVC  animated:YES];
     
        alreadyPushed = YES;
    }
    
}


-(void)dataSuccessfullyRetrieved{
    
   HomeViewController *homeVC= [delegateApp.selectedStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
  [self.navigationController pushViewController:homeVC  animated:YES];
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
