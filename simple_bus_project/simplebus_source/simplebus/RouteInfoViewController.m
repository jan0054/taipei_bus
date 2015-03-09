//
//  RouteInfoViewController.m
//  simplebus
//
//  Created by csjan on 5/23/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "RouteInfoViewController.h"
#import "ISO8601DateFormatter.h"
#import <CommonCrypto/CommonDigest.h>
#import "StopList.h"
#import "RouteList.h"
#import "MyMorningFav.h"
#import "MyEveningFav.h"
#import "MyWeekendFav.h"
#import "AFNetworking.h"
#import "UIColor+UIColor_ProjectColors.h"
#import "FavBusTableViewCell.h"

@interface RouteInfoViewController ()

@end

@implementation RouteInfoViewController
@synthesize routeid;
@synthesize finalestarray;
@synthesize routename;
@synthesize gobackseg;
@synthesize viewgoback;
@synthesize selected_stopname;
@synthesize selected_stopid;
@synthesize selected_goback;
@synthesize sel_goback;
@synthesize sel_stopid;
@synthesize pullrefresh;
@synthesize hud;
@synthesize tii;

@synthesize estdict;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.stopinfotable setSeparatorInset:UIEdgeInsetsZero];
    self.gobackseg.tintColor = [UIColor main_green];
    self.viewgoback=0;
    self.gobackseg.selectedSegmentIndex=0;
    self.addroutetofave_outlet.enabled=NO;
    self.finalestarray = [[NSMutableArray alloc] init];
    self.estdict = [[NSMutableDictionary alloc] init];
    
    
    //Pull To Refresh Controls
    self.pullrefresh = [[UIRefreshControl alloc] init];
    [pullrefresh addTarget:self action:@selector(refreshctrl:) forControlEvents:UIControlEventValueChanged];
    [self.stopinfotable addSubview:pullrefresh];
    
    //register notification when app comes up from background
    if(&UIApplicationWillEnterForegroundNotification) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(enteredForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self refreshdata];
}

-(void)viewDidLayoutSubviews
{
    if ([self.stopinfotable respondsToSelector:@selector(layoutMargins)]) {
        self.stopinfotable.layoutMargins = UIEdgeInsetsZero;
    }
}

- (void)enteredForeground:(NSNotification*) not
{
    self.viewgoback = self.gobackseg.selectedSegmentIndex;
    self.finalestarray = [self.finalestarray mutableCopy];
    [self refreshdata];
}

//called when pulling downward on the tableview
- (void)refreshctrl:(id)sender
{
    self.viewgoback = self.gobackseg.selectedSegmentIndex;
    self.finalestarray = [self.finalestarray mutableCopy];
    [self refreshdata];
    
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}

//refresh data, present progress hud
-(void) refreshdata
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self timeOutTimer:1];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self getEstimateTime:routeid];
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
}

//tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
    return self.finalestarray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavBusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"businfocell"];
    NSDictionary *stopdict = [self.finalestarray objectAtIndex:indexPath.row];
    cell.busname_label.text =  [stopdict objectForKey:@"stopname"];
    int estsecs = [[stopdict objectForKey:@"esttime"] intValue];
    if (estsecs==-1)
    {
        cell.bustime_alt_label.text = @"未發車";
        cell.bustime_label.text=@"";
        cell.bustime_min_label.text = @"";
    }
    else
    {
        cell.bustime_alt_label.text = @"";
        int mins = estsecs/60;
        int secs = estsecs % 60;
        cell.bustime_label.text = [NSString stringWithFormat:@":%02d", secs];
        cell.bustime_min_label.text = [NSString stringWithFormat:@"%d", mins];
        if (mins==0 && secs==0)
        {
            cell.bustime_alt_label.text = @"進站中";
            cell.bustime_label.text = @"";
            cell.bustime_min_label.text = @"";
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.addroutetofave_outlet.enabled=YES;
    NSDictionary *selected_stopdict = [self.finalestarray objectAtIndex:indexPath.row];
    self.selected_goback = [[selected_stopdict objectForKey:@"goback"] intValue];
    self.sel_goback = [NSNumber numberWithInteger:selected_goback];
    self.selected_stopid = [[selected_stopdict objectForKey:@"stopid"] integerValue];
    self.sel_stopid = [NSNumber numberWithInteger:selected_stopid];
    self.selected_stopname = [selected_stopdict objectForKey:@"stopname"];
}

//指定一路(的id), 並取得id, 中文名, 路徑array, 之後將路徑array之元素逐一塞入coredata之stop物件, 其中屬性包含往返, 中文名, stopid
- (void) setupRKBus: (NSNumber *) busid
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
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"route results: %@", result);
        NSArray *route_result = [result objectForKey:@"route"];
        NSDictionary *resultdic = [route_result objectAtIndex:0];
        NSArray *path_array = [resultdic objectForKey:@"path"];
        [self.finalestarray removeAllObjects];
        
        for (NSDictionary *somestop in path_array)
        {
            NSString *nameZh = [somestop objectForKey:@"nameZh"];
            if (nameZh != (id)[NSNull null])
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
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"estimate time results: %@", result);
        NSArray *result_array = [result objectForKey:@"estimateTime"];
        
        [self.estdict removeAllObjects];
        
        for (NSDictionary *stopdic in result_array)
        {
            NSNumber *esttime = stopdic[@"EstimateTime"];
            NSString *stopid = stopdic[@"StopID"];
            [self.estdict setObject:esttime forKey:stopid];
        }
        [self setupRKBus:busid];

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

//Add to fav methods
- (IBAction)addroutetofav_action:(UIBarButtonItem *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"加入最愛" message:@"選擇加入路線種類" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"上班", @"下班", @"其它", nil];
    [alert show];
    
}
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1){
        //add to 上班 fav
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        
        StopList *favstop = [StopList MR_createEntity];
        favstop.goback = sel_goback;
        favstop.nameZh = selected_stopname;
        favstop.stopid = sel_stopid;
        favstop.route = [RouteList MR_findFirstByAttribute:@"routeid" withValue:self.routeid];

        MyMorningFav *myfav = [MyMorningFav MR_createEntity];
        myfav.stopid=sel_stopid;
        myfav.routeid=self.routeid;
        myfav.goback=sel_goback;
        myfav.stopnamezh=selected_stopname;
        myfav.routenamezh=self.routename;
        [localContext MR_saveToPersistentStoreAndWait];

        self.addroutetofave_outlet.enabled=NO;
    }
    else if(buttonIndex==2){
        //add to 下班 fav
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        
        StopList *favstop = [StopList MR_createEntity];
        favstop.goback = sel_goback;
        favstop.nameZh = selected_stopname;
        favstop.stopid = sel_stopid;
        favstop.route = [RouteList MR_findFirstByAttribute:@"routeid" withValue:self.routeid];
        
        MyEveningFav *myfav = [MyEveningFav MR_createEntity];
        myfav.stopid=sel_stopid;
        myfav.routeid=self.routeid;
        myfav.goback=sel_goback;
        myfav.stopnamezh=selected_stopname;
        myfav.routenamezh=self.routename;
        [localContext MR_saveToPersistentStoreAndWait];
        self.addroutetofave_outlet.enabled=NO;
    }
    else if(buttonIndex==3){
        //add to 其它 fav
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        
        StopList *favstop = [StopList MR_createEntity];
        favstop.goback = sel_goback;
        favstop.nameZh = selected_stopname;
        favstop.stopid = sel_stopid;
        favstop.route = [RouteList MR_findFirstByAttribute:@"routeid" withValue:self.routeid];
        
        MyWeekendFav *myfav = [MyWeekendFav MR_createEntity];
        myfav.stopid=sel_stopid;
        myfav.routeid=self.routeid;
        myfav.goback=sel_goback;
        myfav.stopnamezh=selected_stopname;
        myfav.routenamezh=self.routename;
        [localContext MR_saveToPersistentStoreAndWait];
        self.addroutetofave_outlet.enabled=NO;
    }
}

//選擇往返
- (IBAction)gobackseg_action:(UISegmentedControl *)sender {
    NSInteger selected = sender.selectedSegmentIndex;
    if (selected==0)
    {
        self.viewgoback=0;
        [self refreshdata];
    }
    else if (selected==1)
    {
        self.viewgoback=1;
        [self refreshdata];
    }
}

//Process TimeOut for the progress view
- (void) timeOutTimer: (int) onoff {
    if (onoff == 1){
        NSDate *d = [NSDate dateWithTimeIntervalSinceNow: 7.0];
        tii = [[NSTimer alloc] initWithFireDate: d
                                       interval: 5
                                         target: self
                                       selector:@selector(timeOutWarning:)
                                       userInfo:nil repeats:NO];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:tii forMode: NSDefaultRunLoopMode];
    }
    else if (onoff == 0) {
        [tii invalidate];
        tii = nil;
    }
}
- (void) timeOutWarning: (NSTimer *)timer {
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"連線失敗", nil)]
                                                     message:[NSString stringWithFormat:NSLocalizedString(@"請檢查網路連線", nil)]
                                                    delegate:nil
                                           cancelButtonTitle:[NSString stringWithFormat:NSLocalizedString(@"確定", nil)]
                                           otherButtonTitles:nil];
    [alert1 show];
    [timer invalidate];
    timer = nil;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


@end
