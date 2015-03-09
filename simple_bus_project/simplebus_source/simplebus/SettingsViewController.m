//
//  SettingsViewController.m
//  simplebus
//
//  Created by csjan on 11/24/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.fence_mapview.delegate = self;
    
    [self center_on_user];
    
}

-(void) center_on_user
{
    MKUserLocation *userLocation = self.fence_mapview.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 1500, 1500);
    [self.fence_mapview setRegion:region animated:YES];
}




@end
