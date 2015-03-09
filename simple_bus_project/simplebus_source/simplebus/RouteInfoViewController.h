//
//  RouteInfoViewController.h
//  simplebus
//
//  Created by csjan on 5/23/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <RestKit/RestKit.h>
#import "RKBusRoute.h"
#import "RKBus.h"
#import "RKBusStop.h"
#import "MBProgressHUD.h"

@class RouteList;
@class StopList;

@interface RouteInfoViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *stopinfotable;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gobackseg;
- (IBAction)gobackseg_action:(UISegmentedControl *)sender;
@property NSNumber *routeid;
@property NSString *routename;
@property (nonatomic) RouteList *route;
@property (nonatomic) StopList *stop;
@property NSMutableArray *finalestarray;
- (IBAction)addroutetofav_action:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addroutetofave_outlet;
@property NSInteger viewgoback;

@property NSString *selected_stopname;
@property NSInteger selected_stopid;
@property NSInteger selected_goback;
@property NSNumber *sel_stopid;
@property NSNumber *sel_goback;
@property UIRefreshControl *pullrefresh;
@property MBProgressHUD *hud;
@property NSTimer *tii;
@property NSMutableDictionary *estdict;
@end
