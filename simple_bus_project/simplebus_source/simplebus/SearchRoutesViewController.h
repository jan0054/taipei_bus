//
//  SearchRoutesViewController.h
//  simplebus
//
//  Created by csjan on 1/16/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <RestKit/RestKit.h>
#import "HTAutocompleteManager.h"

@interface SearchRoutesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *SearchResultTable;

@property NSMutableArray *autocomplete;
@property NSMutableArray *autocompletefull;
@property NSMutableArray *finalroutearray;
@property NSMutableArray *finalroutearrayfull;
@property (strong, nonatomic) IBOutlet UITextField *search_field;
@property NSNumber *selectedrouteid;
@property NSString *selectedroutename;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *keyboard_switch;
- (IBAction)kyeboard_switch_tap:(UIBarButtonItem *)sender;
@property NSMutableArray *routearray;
@end
