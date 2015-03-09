//
//  FavBusTableViewCell.h
//  simplebus
//
//  Created by csjan on 10/23/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavBusTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *busname_label;
@property (strong, nonatomic) IBOutlet UILabel *bustime_label;
@property (strong, nonatomic) IBOutlet UILabel *bustime_min_label;
@property (strong, nonatomic) IBOutlet UILabel *bustime_alt_label;

@end
