//
//  InitUpdateViewController.h
//  simplebus
//
//  Created by csjan on 5/28/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteList.h"
#import "StopList.h"

@class RouteList;
@class StopList;

@interface InitUpdateViewController : UIViewController
@property (nonatomic) RouteList *route;
@property (nonatomic) StopList *stop;
@property (strong, nonatomic) IBOutlet UILabel *infolabel;
@property (strong, nonatomic) IBOutlet UILabel *progresslabel;

@end
