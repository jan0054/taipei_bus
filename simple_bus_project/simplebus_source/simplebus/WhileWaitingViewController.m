//
//  WhileWaitingViewController.m
//  simplebus
//
//  Created by csjan on 1/16/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "WhileWaitingViewController.h"

@interface WhileWaitingViewController ()

@end

@implementation WhileWaitingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [[NSURL alloc] initWithString:@"http://tapgo.cc/tw/?page_id=9"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.BoringWebView loadRequest:request];

}


@end
