//
//  Bus_Stop.h
//  complexbus
//
//  Created by csjan on 3/9/15.
//  Copyright (c) 2015 tapgo. All rights reserved.
//

#import "RLMObject.h"

@interface Bus_Stop : RLMObject
@property int stop_id;
@property NSString *stop_name;
@property int go_back;
@property int route_id;
@end
