//
//  InitUpdateViewController.m
//  simplebus
//
//  Created by csjan on 5/28/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "InitUpdateViewController.h"
#import "ISO8601DateFormatter.h"
#import <CommonCrypto/CommonDigest.h>
#import "StopList.h"
#import "RouteList.h"
//#import <RestKit/RestKit.h>
#import "RKBusRoute.h"
#import "RKBus.h"
#import "RKBusStop.h"
#import "AFNetworking.h"



@interface InitUpdateViewController ()

@end
NSDate *lastupdatedate;
@implementation InitUpdateViewController
@synthesize progresslabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day]+1;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"lastupdatedate"])
    {
        lastupdatedate = [NSDate date];
    }
    else
    {
        lastupdatedate = [defaults objectForKey:@"lastupdatedate"];
    }
    
    NSDate *rightnow = [NSDate date];
    int updatedays = [self daysBetween:rightnow and:lastupdatedate];
    
    if (![defaults integerForKey:@"init"])
    {
        [self setupRKRouteList];
        /*
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self setupRKRouteList];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        });
        */
        [defaults setInteger:1 forKey:@"init"];
        [defaults synchronize];
    }
    else if ([defaults integerForKey:@"init"]==1)
    {
        if (updatedays>=7)
        {
            [self setupRKRouteList];
            /*
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self setupRKRouteList];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            });
             */
        }
        
        else
        {
            [self performSegueWithIdentifier:@"initdonesegue" sender:self];
        }
    }


    
    
}



//取得所有路線, 並存下中文名稱, id, 以及廠商名到coredata的route物件
-(void) setupRKRouteList
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
        NSLog(@"route list results: %@", result);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        for (NSDictionary *routedic in result)
        {
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            self.route = [RouteList MR_createEntity];
            self.route.nameZh = routedic[@"nameZh"];
            self.route.routeid = routedic[@"Id"];
            self.route.providername = routedic[@"providerName"];
            NSString *pAN = routedic[@"pathAttributeName"];
            if (pAN.length!=0)
            {
                self.route.pathAttributeName = pAN;
            }
            else if (pAN.length==0)
            {
                self.route.pathAttributeName = routedic[@"nameZh"];
            }
            
            NSDate *rightnow = [NSDate date];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:rightnow forKey:@"lastupdatedate"];
            [defaults synchronize];
            
            [localContext MR_saveToPersistentStoreAndWait];
        }
        [self performSegueWithIdentifier:@"initdonesegue" sender:self];
        
        
        
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


@end
