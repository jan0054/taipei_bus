//
//  SettingsViewController.h
//  simplebus
//
//  Created by csjan on 11/24/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SettingsViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *geo_background_view;
@property (strong, nonatomic) IBOutlet MKMapView *fence_mapview;
@property CLLocationManager *locationManager;

@end
