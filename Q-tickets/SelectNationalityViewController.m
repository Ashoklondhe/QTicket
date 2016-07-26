//
//  SelectNationalityViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 31/03/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "SelectNationalityViewController.h"
#import "Q-ticketsConstants.h"
#import "CountryInfo.h"
#import "QticketsSingleton.h"

@interface SelectNationalityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tbofCountries;
    NSInteger            Langindex;
    QticketsSingleton    *singleTon;
    
}
@end

@implementation SelectNationalityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    singleTon = [QticketsSingleton sharedInstance];
    
//    NSInteger lo = -1;
//    
//    [USERDEFAULTS setInteger:lo forKey:@"SelectedCountryIndex"];
//    USERDEFAULTSAVE;

}


#pragma mark -- tableview delegate methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return singleTon.arrofCountryDetails.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([SMSCountryUtils isIphone]) {
        
        return 40;
    }
    else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    CountryInfo *countryinf  = [singleTon.arrofCountryDetails objectAtIndex:indexPath.row];
    
    cell.textLabel.text         = [NSString stringWithFormat:@"%@",countryinf.CountryNationality];
    
    if ([SMSCountryUtils isIphone]) {
        [cell.textLabel setFont:[UIFont fontWithName:LATO_REGULAR size:14]];

        
    }
    else{
        
        [cell.textLabel setFont:[UIFont fontWithName:LATO_REGULAR size:20]];

    }
    
    UIImageView *imgofCheckmark;
    if ([SMSCountryUtils isIphone]) {
        
        if(ViewWidth == iPhone6PlusWidth)
        {
            imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark@3x.png"]];
            
        }
        else{
            
            if ([SMSCountryUtils isRetinadisplay]) {
                
                imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark@2x.png"]];                    }
            else{
                
                imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark.png"]];
                
            }
            
            
        }
        
    }
    else{
        
        if ([SMSCountryUtils isRetinadisplay]) {
            
            imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark@2x~ipad.png"]];
            
        }
        else{
            
            imgofCheckmark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick-mark~ipad.png"]];
        }
        
    }

    if(indexPath.row == [USERDEFAULTS integerForKey:@"SelectedCountryIndex"])
    {
       
        cell.accessoryView     = imgofCheckmark;
        cell.accessoryType      = UITableViewCellAccessoryCheckmark;
        
    }
    else{
        cell.accessoryView     = nil;
        cell.accessoryType      = UITableViewCellAccessoryNone;
    }
    
    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
//
//    if (theCell.accessoryType == UITableViewCellAccessoryCheckmark) {
//        
//          theCell.accessoryType      = UITableViewCellAccessoryNone;
//
//    }
//    else{
//        
//           theCell.accessoryType      = UITableViewCellAccessoryCheckmark;
//    }
    
    
   
    
    
    [USERDEFAULTS setInteger:indexPath.row forKey:@"SelectedCountryIndex"];
    USERDEFAULTSAVE;

    NSString  *strCountry = [NSString stringWithFormat:@"%@",theCell.textLabel.text];
    
    [USERDEFAULTS setObject:strCountry forKey:@"CountrySelected"];
    USERDEFAULTSAVE;
    
    [tbofCountries reloadData];
    
    NSString *selectedCountry = [USERDEFAULTS objectForKey:@"CountrySelected"];
    if (selectedCountry == nil) {
        
        CountryInfo *countryis = [singleTon.arrofCountryDetails objectAtIndex:0];
        NSString  *strCountry = [NSString stringWithFormat:@"%@",countryis.CountryNationality];
        [USERDEFAULTS setObject:strCountry forKey:@"CountrySelected"];
        USERDEFAULTSAVE;
        
    }
    [self.navigationController popViewControllerAnimated:YES];

}


-(IBAction)btnBackClicked:(id)sender{
    
      NSString *selectedCountry = [USERDEFAULTS objectForKey:@"CountrySelected"];
    if (selectedCountry == nil) {
        
        CountryInfo *countryis = [singleTon.arrofCountryDetails objectAtIndex:0];
        NSString  *strCountry = [NSString stringWithFormat:@"%@",countryis.CountryNationality];
        [USERDEFAULTS setObject:strCountry forKey:@"CountrySelected"];
        USERDEFAULTSAVE;
        
    }
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
