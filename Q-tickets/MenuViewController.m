//
//  MenuViewController.m
//  Q-Tickets
//
//  Created by SMS_MINIMAC on 12/03/15.
//  Copyright (c) 2015 SMS_MINIMAC. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuViewControllerCell.h"
#import "Q-ticketsConstants.h"
#import "QticketsSingleton.h"



@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
     IBOutlet UITableView *tbofMenuOptions;
     NSMutableArray       *arrofMenuOptions;
     NSMutableArray       *arrodMenuIcons;
     QticketsSingleton    *singleton;
    
}

@end

@implementation MenuViewController
@synthesize setDelegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
   // [self.view setBackgroundColor:[UIColor blackColor]];
    
 //   [self LoadData];
    
  }

-(void)LoadData{
    
    NSInteger loginstatus = [USERDEFAULTS integerForKey:@"LoginStatus"];
    
    singleton             = [QticketsSingleton sharedInstance];
    
    if (loginstatus == 1) {
        
        if ( [singleton.cureentLoginUser.verify isEqualToString:@"True"]) {
            
            arrofMenuOptions = [[NSMutableArray alloc] initWithObjects:@"Home",@"My Bookings",@"My Profile",@"Change Password",@"E-Vouchers",@"Logout", nil];
            
            if ([SMSCountryUtils isIphone]) {
                arrodMenuIcons   = [[NSMutableArray alloc] initWithObjects:@"QIcon.png",@"MyBookingsIcon.png",@"MyProfileIcon.png",@"ChangePasswordIcon.png",@"EVouchersIcon.png",@"LoginIcon.png", nil];
                
            }
            else{
                
                arrodMenuIcons   = [[NSMutableArray alloc] initWithObjects:@"QIcon@2x.png",@"MyBookingsIcon@2x.png",@"MyProfileIcon@2x.png",@"ChangePasswordIcon@2x.png",@"EVouchersIcon@2x.png",@"LoginIcon@2x.png", nil];
            }
            
        }
       
        else{
        arrofMenuOptions = [[NSMutableArray alloc] initWithObjects:@"Home",@"My Bookings",@"My Profile",@"Change Password",@"E-Vouchers",@"Logout",@"Verify Mobile", nil];
        
            if ([SMSCountryUtils isIphone]) {
                
               arrodMenuIcons   = [[NSMutableArray alloc] initWithObjects:@"QIcon.png",@"MyBookingsIcon.png",@"MyProfileIcon.png",@"ChangePasswordIcon.png",@"EVouchersIcon.png",@"LoginIcon.png",@"VerifyMobilenumIcon.png", nil];
            }
            else{
                
                arrodMenuIcons   = [[NSMutableArray alloc] initWithObjects:@"QIcon@2x.png",@"MyBookingsIcon@2x.png",@"MyProfileIcon@2x.png",@"ChangePasswordIcon@2x.png",@"EVouchersIcon@2x.png",@"LoginIcon@2x.png",@"VerifyMobilenumIcon.png", nil];
            }
            
        
        }
        
    }
    else{
        
        arrofMenuOptions = [[NSMutableArray alloc] initWithObjects:@"Home",@"My Bookings",@"My Profile",@"Change Password",@"E-Vouchers",@"Login",@"Verify Mobile", nil];
        
        if ([SMSCountryUtils isIphone]) {
          
            arrodMenuIcons   = [[NSMutableArray alloc] initWithObjects:@"QIcon.png",@"MyBookingsIcon.png",@"MyProfileIcon.png",@"ChangePasswordIcon.png",@"EVouchersIcon.png",@"LoginIcon.png",@"VerifyMobilenumIcon.png", nil];
            
        }
        else{
            
            arrodMenuIcons   = [[NSMutableArray alloc] initWithObjects:@"QIcon@2x.png",@"MyBookingsIcon@2x.png",@"MyProfileIcon@2x.png",@"ChangePasswordIcon@2x.png",@"EVouchersIcon@2x.png",@"LoginIcon@2x.png",@"VerifyMobilenumIcon@2x.png", nil];
        }
        
        
        
    }
    
    [tbofMenuOptions setDelegate:self];
    [tbofMenuOptions setDataSource:self];
    [tbofMenuOptions reloadData];
    
    

    
}


#pragma MenuTableviewDataSourceMethods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrofMenuOptions.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([SMSCountryUtils isIphone]) {
        return 50.0f;
    }
    else{
    return 100.0f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MenuViewControllerCell *menuCell = (MenuViewControllerCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuViewControllerCell"];
    if (menuCell == nil) {
        
        menuCell= [[[NSBundle mainBundle]loadNibNamed:@"MenuViewControllerCell" owner:self options:nil] objectAtIndex:0];
        
    }
    
    if ([SMSCountryUtils isIphone]) {
        
        [menuCell.lblofMenuOptions setFont:[UIFont fontWithName:LATO_REGULAR size:13]];

    }
    else{
        [menuCell.lblofMenuOptions setFont:[UIFont fontWithName:LATO_REGULAR size:25]];

    }
    [menuCell.lblofMenuOptions setText:[NSString stringWithFormat:@" %@",[arrofMenuOptions objectAtIndex:indexPath.row]]];
    [menuCell.imgviewofMenuOption setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrodMenuIcons objectAtIndex:indexPath.row]]]];
    
    menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return menuCell;
    
    
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = cell.contentView.backgroundColor;
}



#pragma MenuTableviewDelegateMethods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (self.setDelegate && [self.setDelegate respondsToSelector:@selector(selectedMenuOption:)]) {
        
        [self.setDelegate selectedMenuOption:indexPath.row];

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
