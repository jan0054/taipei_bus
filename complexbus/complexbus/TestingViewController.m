//
//  TestingViewController.m
//  complexbus
//
//  Created by csjan on 3/3/15.
//  Copyright (c) 2015 tapgo. All rights reserved.
//

#import "TestingViewController.h"
#import <Realm/Realm.h>
#import "Route_simple.h"

@interface TestingViewController ()

@end

RLMResults *routelist;

@implementation TestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getStoredRouteList];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return routelist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testcell"];
    Route_simple *route = [routelist objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ -- %i",route.nameZh, route.routeid];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void) getStoredRouteList {
    routelist = [Route_simple allObjects];
    [self.test_table reloadData];
}


@end
