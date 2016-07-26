//
//  EventLocationViewController.m
//  Q-tickets
//
//  Created by KrishnaSunkara on 01/04/15.
//  Copyright (c) 2015 KrishnaSunkara. All rights reserved.
//

#import "EventLocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Q-ticketsConstants.h"
#import "AppDelegate.h"

@interface EventLocationViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
{
    IBOutlet MKMapView *mapvoewofEventLoc;
    CLLocationManager  *locationManager;
    AppDelegate        *delegateApp;
    
    
}

@end

@implementation EventLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    delegateApp              = QTicketsAppDelegate;
 
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    
    MKCoordinateRegion region  = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude     = [delegateApp.selectedEvent.locationLatitude doubleValue];
    region.center.longitude    = [delegateApp.selectedEvent.locationLongitude doubleValue];
    region.span.longitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([delegateApp.selectedEvent.locationLatitude doubleValue], [delegateApp.selectedEvent.locationLongitude doubleValue]);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:[NSString stringWithFormat:@"%@",delegateApp.selectedEvent.venue]];
    [mapvoewofEventLoc addAnnotation:annotation];
    [mapvoewofEventLoc setRegion:region animated:YES];
    
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
    [mapvoewofEventLoc setRegion:[mapvoewofEventLoc regionThatFits:region] animated:YES];
}
-(IBAction)btnBackClicked:(id)sender{
    
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
