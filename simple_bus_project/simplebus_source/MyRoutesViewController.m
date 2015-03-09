//
//  MyRoutesViewController.m
//  simplebus
//
//  Created by csjan on 1/16/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "MyRoutesViewController.h"
#import "ISO8601DateFormatter.h"
#import <CommonCrypto/CommonDigest.h>
#import "StopList.h"
#import "RouteList.h"
#import "MyMorningFav.h"
//#import <RestKit/RestKit.h>
#import "RKBusRoute.h"
#import "RKBus.h"
#import "RKBusStop.h"
#import "RKMyFav.h"
#import "MyEveningFav.h"
#import "MyWeekendFav.h"
#import "AFNetworking.h"
#import "FavBusTableViewCell.h"
#import "UIColor+UIColor_ProjectColors.h"

@interface MyRoutesViewController ()

@end

int secsrefreshed;

@implementation MyRoutesViewController
@synthesize segCtrl;
@synthesize myfavtable;
@synthesize mymorningfav_array;
@synthesize pullrefresh;
@synthesize morningfavdict;
@synthesize totalfav;
@synthesize currentfav;
@synthesize hud;
@synthesize tii;
@synthesize updatetimer;
@synthesize displaytimer;
@synthesize update_timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segCtrl.tintColor = [UIColor main_green];
    [self.myfavtable setSeparatorInset:UIEdgeInsetsZero];
    self.myfavtable.allowsMultipleSelectionDuringEditing = NO;
    self.morningfavdict = [[NSMutableDictionary alloc] init];
    self.mymorningfav_array = [[NSMutableArray alloc] init];
    self.myfavtable.tableFooterView = [[UIView alloc] init];
    //Pull To Refresh Controls
    self.pullrefresh = [[UIRefreshControl alloc] init];
    [pullrefresh addTarget:self action:@selector(refreshctrl:) forControlEvents:UIControlEventValueChanged];
    [self.myfavtable addSubview:pullrefresh];
    
    //register notification when app comes up from background
    if(&UIApplicationWillEnterForegroundNotification) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(enteredForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }

}

-(void) viewDidLayoutSubviews
{
    if ([self.myfavtable respondsToSelector:@selector(layoutMargins)]) {
        self.myfavtable.layoutMargins = UIEdgeInsetsZero;
    }
}

- (void) date_stuff
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger day = [components weekday];
    if (day ==1 || day==7)
    {
        //sun or sat
        [self.segCtrl setSelectedSegmentIndex:2];
    }
    else
    {
        //weekday
        if ( hour <=12 )
        {
            //上班
            [self.segCtrl setSelectedSegmentIndex:0];
        }
        else
        {
            //下班
            [self.segCtrl setSelectedSegmentIndex:1];
        }
    }
}

- (void)enteredForeground:(NSNotification*) not
{
    [self.morningfavdict removeAllObjects];
    self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
    [self.mymorningfav_array removeAllObjects];
    if (self.segCtrl.selectedSegmentIndex==0)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyMorningFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }
    else if (self.segCtrl.selectedSegmentIndex==1)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyEveningFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }
    else if (self.segCtrl.selectedSegmentIndex==2)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyWeekendFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }

}


-(void) viewDidAppear:(BOOL)animated
{
    //self.updatetimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerrefresh:) userInfo:nil repeats:YES];
    
    [super viewDidAppear:YES];
    
    [self date_stuff];
    [self.morningfavdict removeAllObjects];
    self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
    [self.mymorningfav_array removeAllObjects];
    if (self.segCtrl.selectedSegmentIndex==0)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyMorningFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
        [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }
    else if (self.segCtrl.selectedSegmentIndex==1)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyEveningFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }
    else if (self.segCtrl.selectedSegmentIndex==2)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyWeekendFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }
}

-(void) refreshlist
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self timeOutTimer:1];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int i =0;
        for (MyMorningFav *fav in self.mymorningfav_array)
        {
            NSNumber *stopid = fav.stopid;
            NSNumber *routeid = fav.routeid;
            [self getEstimateTimeforRoute:routeid withStopId:stopid withIndex:i];
            i=i+1;
        }
        self.totalfav=i;
        self.currentfav=0;
        if (self.totalfav==0 )
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self timeOutTimer:0];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
}

- (IBAction)segCtrl_action:(UISegmentedControl *)sender {
    [self.morningfavdict removeAllObjects];
    self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
    [self.mymorningfav_array removeAllObjects];
    
    NSInteger selected = sender.selectedSegmentIndex;
    if (selected==0)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyMorningFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }
    else if (selected==1)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyEveningFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }
    else if (selected==2)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyWeekendFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }

}

- (IBAction)addfav_action:(UIBarButtonItem *)sender {
    //switch to the search tab
    self.tabBarController.selectedIndex=1;
}

//tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return self.morningfavdict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavBusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myfavcell"];
    int i = (int)indexPath.row;
    NSDictionary *favdict = [self.morningfavdict objectForKey:[NSString stringWithFormat:@"%d",i]];

    NSString *stopnamestr =  [favdict objectForKey:@"stopname"];
    NSString *routenamestr = [favdict objectForKey:@"routename"];
    int favgoback = [[favdict objectForKey:@"goback"] integerValue];
    if (favgoback ==0)
    {
        cell.busname_label.text = [NSString stringWithFormat:@"%@(去): %@ ", routenamestr, stopnamestr];
    }
    else if (favgoback ==1)
    {
        cell.busname_label.text = [NSString stringWithFormat:@"%@(返): %@ ", routenamestr, stopnamestr];
    }
    
    NSString *eststr = [favdict objectForKey:@"esttime"];
    NSLog(@"TIMESTRING: %@", eststr);
    int estsecs = [eststr intValue];
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void) getEstimateTimeforRoute: (NSNumber *) routeid withStopId:(NSNumber *) stopid withIndex: (int) favindex
{
        

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
    [request setValue:digestString forHTTPHeaderField:@"x-appgo-digest"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"AAA: %@", result);
        NSDictionary *resultdic = [result objectForKey:@"estimateTime"];
        
        //RKMyFav *fav = result.array[0];
        NSString *esttime = [NSString stringWithFormat:@"%@", resultdic[@"EstimateTime"]];
        StopList *thisstop = [StopList MR_findFirstByAttribute:@"stopid" withValue:resultdic[@"StopID"]];
        NSString *stopname = thisstop.nameZh;
        NSNumber *goback = resultdic[@"GoBack"];
        RouteList *thisroute = [RouteList MR_findFirstByAttribute:@"routeid" withValue:resultdic[@"RouteID"]];
        NSString *routename = thisroute.nameZh;
        NSMutableDictionary *favdict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:routename, @"routename", stopname, @"stopname", resultdic[@"RouteID"], @"routeid",esttime, @"esttime", resultdic[@"StopID"], @"stopid", goback, @"goback", nil];
        [self.morningfavdict setObject:favdict forKey:[NSString stringWithFormat:@"%d",favindex]];
        self.currentfav=self.currentfav+1;
        
        //all data loaded, time to write to the table
        if (self.currentfav == self.totalfav)
        {
            [self.myfavtable reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self timeOutTimer:0];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat: @"HH:mm"];
            NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
            self.last_update_label.text = [NSString stringWithFormat:@"最後更新 %@", dateString];
            
            //setup the "time since refreshed" in upper left corner : NOT A GOOD FEATURE
            /*
            secsrefreshed = 0;
            [self.displaytimer invalidate];
            self.displaytimer = nil;
            self.displaytimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update_display:) userInfo:nil repeats:YES];
             */
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

- (void) update_display: (id) sender
{
    
    secsrefreshed += 1;
    int mins = secsrefreshed/60;
    int secs = secsrefreshed % 60;
    NSString *finaldisplay = [NSString stringWithFormat:@"%d:%02d", mins, secs];
    [self.update_timer setTitle:finaldisplay];
    self.update_timer.title = finaldisplay;
    NSLog(@"DISPLAY TIMER FIRED:%@", finaldisplay);

}

//called when pulling downward on the tableview
- (void)refreshctrl:(id)sender
{
    [self manualrefresh];
    
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}

- (void) timerrefresh: (id)sender
{
    [self manualrefresh];
    NSLog(@"TIMER REFRESHED");
}

-(void) manualrefresh
{
    
    [self.morningfavdict removeAllObjects];
    self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
    [self.mymorningfav_array removeAllObjects];
    
    if (self.segCtrl.selectedSegmentIndex==0)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyMorningFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }
    else if (self.segCtrl.selectedSegmentIndex==1)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyEveningFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }
    else if (self.segCtrl.selectedSegmentIndex==2)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.mymorningfav_array =[MyWeekendFav MR_findAllInContext:localContext];
        self.mymorningfav_array = [self.mymorningfav_array mutableCopy];
        //refresh the table
        if (self.mymorningfav_array.count > 0)
        {
            [self refreshlist];
        }
        else
        {
            [self.myfavtable reloadData];
        }

    }
}

//for swiping to delete favorites
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
        [self.morningfavdict removeObjectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
        MyMorningFav *favtoremove = [self.mymorningfav_array objectAtIndex:indexPath.row];
        [favtoremove MR_deleteEntity];
        [localContext MR_saveToPersistentStoreAndWait];
        
        [self manualrefresh]; // tell table to refresh now
    }
}

//Process TimeOut for the progress view
- (void) timeOutTimer: (int) onoff {
    if (onoff == 1){
        NSDate *d = [NSDate dateWithTimeIntervalSinceNow: 15.0];
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




- (IBAction)update_time_tap:(UIBarButtonItem *)sender {
    [self manualrefresh];
}


@end
