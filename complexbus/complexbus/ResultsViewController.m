//
//  ResultsViewController.m
//  complexbus
//
//  Created by csjan on 3/3/15.
//  Copyright (c) 2015 tapgo. All rights reserved.
//

#import "ResultsViewController.h"
#import "ISO8601DateFormatter.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import <Realm/Realm.h>
#import "Bus_Stop.h"

@interface ResultsViewController ()

@end

NSMutableArray *estimate_time_array;

@implementation ResultsViewController
@synthesize route_id;
@synthesize route_name;

- (void)viewDidLoad {
    [super viewDidLoad];
    estimate_time_array = [[NSMutableArray alloc] init];
    [self getEstimateTime:[NSNumber numberWithInt:route_id]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [estimate_time_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1)
    {
        //去程 table
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gocell"];
        NSDictionary *est_dict = [estimate_time_array objectAtIndex:indexPath.row];
        NSNumber *time_nsnum = est_dict[@"EstimateTime"];
        NSString *time_str = [NSString stringWithFormat:@"%@", time_nsnum];
        if ([time_nsnum intValue] == -1)
        {
            time_str = @"未發車";
        }
        NSString *stop_id = est_dict[@"StopID"];
        cell.textLabel.text = [NSString stringWithFormat:@"stop:%@, time:%@",stop_id, time_str];
        return cell;
    }
    else
    {
        //返程 table
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gocell"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

//指定一路(的id), 取得站點id(stopid), 往返(goback), 以及預計下班到達時間(estimatetime)
- (void) getEstimateTime: (NSNumber *) busid
{
    
    NSString *urlstr = [NSString stringWithFormat:@"http://app.tapgo.cc/api/simplebus/1/estimate/route/%@", busid];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *nonce = [[NSUUID UUID] UUIDString];
    NSData *nonceData = [nonce dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Nonce = [nonceData base64EncodedStringWithOptions:0];
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    formatter.includeTime = true;
    NSString *createdat = [formatter stringFromDate:[NSDate date]];
    [request setValue:@"Yzg1MDU4YTdiOTRkOWRhNzY4MzU2OWJjNTIyYTk1" forHTTPHeaderField:@"x-appgo-appid"];
    [request setValue:base64Nonce forHTTPHeaderField:@"x-appgo-nonce"];
    [request setValue:createdat forHTTPHeaderField:@"x-appgo-createdat"];
    NSString *source = [nonce stringByAppendingString:[createdat stringByAppendingString:@"YzFmNGQ1Yjk3NTI1MGQxZDFhZGQyMDUzZDQxZDYw" ]];
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSData *digestData = [NSData dataWithBytes:(const void *)digest length:CC_SHA1_DIGEST_LENGTH];
    NSString *digestString = [digestData base64EncodedStringWithOptions:0];
    [request setValue:digestString forHTTPHeaderField:@"x-appgo-digest"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getEstimateTime success: %@", responseObject);
        //NSDictionary *raw_result = (NSDictionary *)responseObject;
        //estimate_time_array = [raw_result objectForKey:@"estimateTime"];
        //[self.result_table_go reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"DETAILS: %@", [error userInfo]);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
}

//指定一路(的id), 並取得id, 中文名, 路徑array, 之後將路徑array之元素逐一塞入database, 其中屬性包含往返, 中文名, stopid
- (void) setupStop: (NSNumber *) busid
{
    NSString *urlstr = [NSString stringWithFormat:@"http://app.tapgo.cc/api/simplebus/1/route/%@", busid];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *nonce = [[NSUUID UUID] UUIDString];
    NSData *nonceData = [nonce dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Nonce = [nonceData base64EncodedStringWithOptions:0];
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    formatter.includeTime = true;
    NSString *createdat = [formatter stringFromDate:[NSDate date]];
    [request setValue:@"Yzg1MDU4YTdiOTRkOWRhNzY4MzU2OWJjNTIyYTk1" forHTTPHeaderField:@"x-appgo-appid"];
    [request setValue:base64Nonce forHTTPHeaderField:@"x-appgo-nonce"];
    [request setValue:createdat forHTTPHeaderField:@"x-appgo-createdat"];
    NSString *source = [nonce stringByAppendingString:[createdat stringByAppendingString:@"YzFmNGQ1Yjk3NTI1MGQxZDFhZGQyMDUzZDQxZDYw"]];
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSData *digestData = [NSData dataWithBytes:(const void *)digest length:CC_SHA1_DIGEST_LENGTH];
    NSString *digestString = [digestData base64EncodedStringWithOptions:0];
    [request setValue:digestString forHTTPHeaderField:@"x-appgo-digest"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *raw_result = (NSDictionary *)responseObject;
        NSLog(@"route and stop results: %@", raw_result);
        NSArray *route_array = [raw_result objectForKey:@"route"];
        NSDictionary *route_dict = [route_array objectAtIndex:0];
        NSArray *path_array = [route_dict objectForKey:@"path"];
        for (NSDictionary *somestop in path_array)
        {
            NSString *nameZh = [somestop objectForKey:@"nameZh"];
            if (nameZh != (id)[NSNull null])
            {
                NSNumber *goback_nsnum = [somestop objectForKey:@"goBack"];
                NSNumber *stop_id_nsnum = [somestop objectForKey:@"stopId"];
                int bus_id = [busid intValue];
                
                Bus_Stop *stop = [[Bus_Stop alloc] init];
                stop.stop_name = nameZh;
                stop.stop_id = [stop_id_nsnum intValue];
                stop.route_id = bus_id;
                stop.go_back = [goback_nsnum intValue];
                
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [realm addObject:stop];
                [realm commitWriteTransaction];
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    
    [operation start];
}


- (IBAction)back_action:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
