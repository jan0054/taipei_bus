//
//  MyRoutesViewController.h
//  simplebus
//
//  Created by csjan on 1/16/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class MyMorningFav;


@interface MyRoutesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *segCtrl;
- (IBAction)segCtrl_action:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UITableView *myfavtable;
- (IBAction)addfav_action:(UIBarButtonItem *)sender;
@property NSMutableArray *mymorningfav_array;
@property UIRefreshControl *pullrefresh;
@property NSMutableDictionary *morningfavdict;
@property int totalfav;
@property int currentfav;
@property MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *update_timer;
- (IBAction)update_time_tap:(UIBarButtonItem *)sender;
@property NSTimer *tii;
@property NSTimer *updatetimer;
@property NSTimer *displaytimer;
@property (strong, nonatomic) IBOutlet UILabel *last_update_label;

@end
