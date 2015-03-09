//
//  SearchRoutesViewController.m
//  simplebus
//
//  Created by csjan on 1/16/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "SearchRoutesViewController.h"
#import "RouteList.h"
#import "RouteInfoViewController.h"
#import "AFNetworking.h"
#import "UIColor+UIColor_ProjectColors.h"
#import "SearchCell.h"

@interface SearchRoutesViewController ()

@end
int cur_keyboard;

@implementation SearchRoutesViewController
@synthesize autocomplete;
@synthesize autocompletefull;
@synthesize finalroutearray;
@synthesize finalroutearrayfull;
@synthesize SearchResultTable;
@synthesize selectedrouteid;
@synthesize selectedroutename;
@synthesize routearray;
@synthesize keyboard_switch;

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.routearray = [NSMutableArray arrayWithArray:[RouteList MR_findAll]];
    self.finalroutearray = [[NSMutableArray alloc] init];
    self.finalroutearrayfull = [[NSMutableArray alloc] init];
    self.autocomplete = [[NSMutableArray alloc] init];
    self.autocompletefull = [[NSMutableArray alloc] init];
    
    
    
    for (RouteList *routeobj in routearray)
    {
        [finalroutearray addObject:routeobj.pathAttributeName];
        NSDictionary *routedict = [[NSDictionary alloc] initWithObjectsAndKeys:routeobj.routeid, @"routeid", routeobj.pathAttributeName, @"routename", nil];
        [finalroutearrayfull addObject:routedict];
    }
    
    //register notification when app comes up from background
    if(&UIApplicationWillEnterForegroundNotification) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(enteredForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
}

- (void)enteredForeground:(NSNotification*) not
{
    [self.SearchResultTable reloadData];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.search_field.delegate=self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    cur_keyboard = 0;
    self.search_field.keyboardType= UIKeyboardTypeNumberPad;
    self.keyboard_switch.tintColor = [UIColor clearColor];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.search_field resignFirstResponder];
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.search_field.text = @"";
    self.keyboard_switch.tintColor = [UIColor main_green];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    self.keyboard_switch.tintColor = [UIColor clearColor];
    
}

//autocompletion and text field methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocomplete array
    // The items in this array is what will show up in the table view
    [autocomplete removeAllObjects];
    [autocompletefull removeAllObjects];
    for(NSString *curString in finalroutearray) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocomplete addObject:curString];
            NSInteger curindex = [finalroutearray indexOfObject:curString];
            NSDictionary *routedict = [finalroutearrayfull objectAtIndex:curindex];
            [autocompletefull addObject:routedict];
        }
    }
    [self.SearchResultTable reloadData];
}

//tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autocomplete.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchresultcell"];
    cell.busname_label.text = [autocomplete objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger routeindex = indexPath.row;
    NSDictionary *routedict = [self.autocompletefull objectAtIndex:routeindex];
    self.selectedrouteid = [routedict objectForKey:@"routeid"];
    self.selectedroutename = [routedict objectForKey:@"routename"];
    NSLog(@"SELECTED INFO: %@, %@", selectedrouteid, selectedroutename);
    [self performSegueWithIdentifier:@"routeinfosegue" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RouteInfoViewController *routeinfoview = [segue destinationViewController];
    routeinfoview.routeid = self.selectedrouteid;
    routeinfoview.routename = self.selectedroutename;
    routeinfoview.navigationItem.title = self.selectedroutename;
}

- (IBAction)kyeboard_switch_tap:(UIBarButtonItem *)sender {
    //self.search_field.text = @"";
    if (cur_keyboard==1)
    {
        cur_keyboard=0;
        self.search_field.keyboardType= UIKeyboardTypeNumberPad;
        [self.keyboard_switch setTitle:@"鍵盤"];
        [self.search_field resignFirstResponder];
        [self.search_field becomeFirstResponder];
    }
    else if (cur_keyboard==0)
    {
        cur_keyboard=1;
        self.search_field.keyboardType = UIKeyboardTypeDefault;
        [self.keyboard_switch setTitle:@"數字"];
        [self.search_field resignFirstResponder];
        [self.search_field becomeFirstResponder];
    }
}

@end
