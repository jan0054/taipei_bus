//
//  ResultsViewController.h
//  complexbus
//
//  Created by csjan on 3/3/15.
//  Copyright (c) 2015 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResultsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *result_table_go;   //往, tag=1
@property (strong, nonatomic) IBOutlet UITableView *result_table_back;   //返, tag=2
@property (strong, nonatomic) IBOutlet UIButton *back_button;
- (IBAction)back_action:(UIButton *)sender;

@property NSString *route_name;
@property int route_id;


@end
