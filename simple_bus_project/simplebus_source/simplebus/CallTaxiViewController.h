//
//  CallTaxiViewController.h
//  simplebus
//
//  Created by csjan on 1/16/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallTaxiViewController : UIViewController
- (IBAction)calltaxi1:(UIButton *)sender;
- (IBAction)calltaxi2:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *calltaxi1_button;
@property (strong, nonatomic) IBOutlet UIButton *calltaxi2_button;

@end
