//
//  HomeScreenViewController.m
//  complexbus
//
//  Created by csjan on 3/3/15.
//  Copyright (c) 2015 tapgo. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "ISO8601DateFormatter.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import "Route_simple.h"
#import <Realm/Realm.h>

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) setupRouteList
{
    
    NSURL *url = [NSURL URLWithString:@"http://app.tapgo.cc/api/simplebus/1/route"];
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
        
        NSArray *result = (NSArray *)responseObject;
        NSLog(@"route list query results: %@", result);
        
        
        for (NSDictionary *route_dic in result)
        {
            [self new_route_simple:route_dic];
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

- (void) new_route_simple: (NSDictionary *) route_dic {
    Route_simple *route = [[Route_simple alloc] init];
    route.nameZh = route_dic[@"nameZh"];
    route.routeid = [route_dic[@"Id"] intValue];
    route.providername = route_dic[@"providerName"];
    NSString *pAN = route_dic[@"pathAttributeName"];
    if (pAN.length!=0)
    {
        route.pathAttributeName = pAN;
    }
    else if (pAN.length==0)
    {
        route.pathAttributeName = route_dic[@"nameZh"];
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:route];
    [realm commitWriteTransaction];
}


- (IBAction)get_list_action:(UIButton *)sender {
    [self setupRouteList];
}


@end
