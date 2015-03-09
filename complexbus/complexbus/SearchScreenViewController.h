//
//  SearchScreenViewController.h
//  complexbus
//
//  Created by csjan on 3/3/15.
//  Copyright (c) 2015 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchScreenViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *search_table;
@property (strong, nonatomic) IBOutlet UITextField *search_input;


@end
