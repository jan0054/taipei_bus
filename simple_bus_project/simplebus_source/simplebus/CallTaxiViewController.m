//
//  CallTaxiViewController.m
//  simplebus
//
//  Created by csjan on 1/16/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "CallTaxiViewController.h"
#import "UIColor+UIColor_ProjectColors.h"

@interface CallTaxiViewController ()

@end

@implementation CallTaxiViewController
@synthesize calltaxi1_button;
@synthesize calltaxi2_button;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.calltaxi1_button.tintColor = [UIColor main_green];
    self.calltaxi2_button.tintColor = [UIColor main_green];
}


- (IBAction)calltaxi1:(UIButton *)sender {
    NSString *phoneNumber = [@"tel:" stringByAppendingString:@"55178"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)calltaxi2:(UIButton *)sender {
    NSString *phoneNumber = [@"tel:" stringByAppendingString:@"55688"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
@end
