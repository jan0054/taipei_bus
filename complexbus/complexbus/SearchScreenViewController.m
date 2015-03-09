//
//  SearchScreenViewController.m
//  complexbus
//
//  Created by csjan on 3/3/15.
//  Copyright (c) 2015 tapgo. All rights reserved.
//

#import "SearchScreenViewController.h"
#import "Route_simple.h"
#import <Realm/Realm.h>
#import "HTAutocompleteTextField.h"
#import "ResultsViewController.h"

@interface SearchScreenViewController ()

@end

RLMResults *routelist;
NSMutableArray *routelist_simple;     //only stores path attribute name
NSMutableArray *autocomplete_array;   //only stores path attribute name
NSMutableArray *autocomplete_full;    //stores full Route_simple object
int selected_routeid;
NSString *selected_route_name;

@implementation SearchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.search_input.delegate = self;
    routelist_simple = [[NSMutableArray alloc] init];
    autocomplete_array = [[NSMutableArray alloc] init];
    autocomplete_full = [[NSMutableArray alloc] init];
    self.search_input.keyboardType = UIKeyboardTypeNumberPad;
    
    [self getStoredRouteList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autocomplete_full.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchcell"];
    Route_simple *route = [autocomplete_full objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",route.pathAttributeName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger routeindex = indexPath.row;
    Route_simple *route = [autocomplete_full objectAtIndex:routeindex];
    selected_routeid = route.routeid;
    selected_route_name = route.pathAttributeName;
    [self performSegueWithIdentifier:@"searchresultsegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ResultsViewController *controller = [segue destinationViewController];
    controller.route_id = selected_routeid;
    controller.route_name = selected_route_name;
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
    [autocomplete_array removeAllObjects];
    [autocomplete_full removeAllObjects];
    for(NSString *curString in routelist_simple) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocomplete_array addObject:curString];
            NSInteger curindex = [routelist_simple indexOfObject:curString];
            Route_simple *route = [routelist objectAtIndex:curindex];
            [autocomplete_full addObject:route];
        }
    }
    [self.search_table reloadData];
}

- (void) getStoredRouteList {
    routelist = [Route_simple allObjects];
    for (Route_simple *route in routelist)
    {
        [routelist_simple addObject:route.pathAttributeName];
    }
}



@end
