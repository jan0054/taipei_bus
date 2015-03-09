//
//  LegacyWebcodeViewController.m
//  simplebus
//
//  Created by csjan on 10/23/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "LegacyWebcodeViewController.h"

@interface LegacyWebcodeViewController ()

@end

@implementation LegacyWebcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKBusRoute class]];
 [mapping addAttributeMappingsFromDictionary:@{
 @"Id":   @"Id",
 @"providerName":     @"providerName",
 @"nameZh":        @"nameZh",
 @"pathAttributeName": @"pathAttributeName"
 }];
 
 RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"" statusCodes:nil];
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
 NSLog(@"digestString: %@", digestString);
 
 [request setValue:digestString forHTTPHeaderField:@"x-appgo-digest"];
 
 RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
 
 [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 for (RKBusRoute *routeobj in result.array)
 {
 NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
 self.route = [RouteList MR_createEntity];
 self.route.nameZh = routeobj.nameZh;
 self.route.routeid = routeobj.Id;
 self.route.providername = routeobj.providerName;
 if (routeobj.pathAttributeName.length!=0)
 {
 self.route.pathAttributeName = routeobj.pathAttributeName;
 }
 else if (routeobj.pathAttributeName.length==0)
 {
 self.route.pathAttributeName = routeobj.nameZh;
 }
 
 NSDate *rightnow = [NSDate date];
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 [defaults setObject:rightnow forKey:@"lastupdatedate"];
 [defaults synchronize];
 
 [localContext MR_saveToPersistentStoreAndWait];
 }
 [self performSegueWithIdentifier:@"initdonesegue" sender:self];
 
 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
 RKLogError(@"Operation failed with error: %@", error);
 }];
 [operation start];
 */
/*
 RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKMyFav class]];
 [mapping addAttributeMappingsFromDictionary:@{
 @"StopID" : @"StopID",
 @"EstimateTime" : @"EstimateTime",
 @"GoBack" : @"GoBack",
 @"RouteID" : @"RouteID"
 }];
 
 RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"estimateTime" statusCodes:nil];
 NSString *urlstr = [NSString stringWithFormat:@"http://app.tapgo.cc/api/simplebus/1/estimate/route/%@/%@", routeid, stopid];
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
 NSLog(@"digestString: %@", digestString);
 [request setValue:digestString forHTTPHeaderField:@"x-appgo-digest"];
 RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
 [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
 
 RKMyFav *fav = result.array[0];
 NSString *esttime = [NSString stringWithFormat:@"%@", fav.EstimateTime];
 StopList *thisstop = [StopList MR_findFirstByAttribute:@"stopid" withValue:fav.StopID];
 NSString *stopname = thisstop.nameZh;
 NSNumber *goback = fav.GoBack;
 RouteList *thisroute = [RouteList MR_findFirstByAttribute:@"routeid" withValue:fav.RouteID];
 NSString *routename = thisroute.nameZh;
 NSMutableDictionary *favdict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:routename, @"routename", stopname, @"stopname", fav.RouteID, @"routeid",esttime, @"esttime", fav.StopID, @"stopid", goback, @"goback", nil];
 [self.morningfavdict setObject:favdict forKey:[NSString stringWithFormat:@"%d",favindex]];
 self.currentfav=self.currentfav+1;
 
 //all data loaded, time to write to the table
 if (self.currentfav == self.totalfav)
 {
 [self.myfavtable reloadData];
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 [self timeOutTimer:0];
 }
 
 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
 RKLogError(@"Operation failed with error: %@", error);
 }];
 [operation start];
 */
/*
 RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKBus class]];
 [mapping addAttributeMappingsFromDictionary:@{
 @"Id":   @"Id",
 @"nameZh":        @"nameZh",
 @"path": @"path"
 }];
 RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"route" statusCodes:nil];
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
 NSString *source = [nonce stringByAppendingString:[createdat stringByAppendingString:@"YzFmNGQ1Yjk3NTI1MGQxZDFhZGQyMDUzZDQxZDYw" ]];
 NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
 uint8_t digest[CC_SHA1_DIGEST_LENGTH];
 CC_SHA1(data.bytes, data.length, digest);
 NSData *digestData = [NSData dataWithBytes:(const void *)digest length:CC_SHA1_DIGEST_LENGTH];
 NSString *digestString = [digestData base64EncodedStringWithOptions:0];
 NSLog(@"digestString: %@", digestString);
 [request setValue:digestString forHTTPHeaderField:@"x-appgo-digest"];
 RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
 [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
 [self.finalestarray removeAllObjects];
 RKBus *busline = (RKBus *)result.array[0];
 for (NSDictionary *somestop in busline.path)
 {
 if ([somestop objectForKey:@"nameZh"] != (id)[NSNull null])
 {
 NSMutableDictionary *stopdict = [[NSMutableDictionary alloc] init];
 [stopdict setObject:[somestop objectForKey:@"nameZh"] forKey:@"stopname"];
 [stopdict setObject:[somestop objectForKey:@"goBack"] forKey:@"goback"];
 [stopdict setObject:[somestop objectForKey:@"stopId"] forKey:@"stopid"];
 NSString *stopidstr = [NSString stringWithFormat:@"%@",[somestop objectForKey:@"stopId"]];
 if ([self.estdict objectForKey:stopidstr])
 {
 NSNumber *estnsnum = [self.estdict objectForKey:stopidstr];
 [stopdict setObject:estnsnum forKey:@"esttime"];
 }
 else
 {
 [stopdict setObject:[NSNumber numberWithInt:-1] forKey:@"esttime"];
 }
 if ([[somestop objectForKey:@"goBack"] intValue] == self.viewgoback)
 {
 [self.finalestarray addObject:stopdict];
 }
 }
 }
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 [self timeOutTimer:0];
 [self.stopinfotable reloadData];
 
 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
 RKLogError(@"Operation failed with error: %@", error);
 }];
 [operation start];
 */
/*
 RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKBusStop class]];
 [mapping addAttributeMappingsFromDictionary:@{
 @"StopID" : @"StopID",
 @"EstimateTime" : @"EstimateTime",
 @"GoBack" : @"GoBack"
 }];
 RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"estimateTime" statusCodes:nil];
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
 NSLog(@"digestString: %@", digestString);
 [request setValue:digestString forHTTPHeaderField:@"x-appgo-digest"];
 RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
 [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
 [self.estdict removeAllObjects];
 for (RKBusStop *busstop in result.array)
 {
 NSNumber *esttime = busstop.EstimateTime;
 NSString *stopid = [NSString stringWithFormat:@"%@", busstop.StopID ];
 [self.estdict setObject:esttime forKey:stopid];
 }
 [self setupRKBus:busid];
 
 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
 RKLogError(@"Operation failed with error: %@", error);
 }];
 [operation start];
 */


@end
