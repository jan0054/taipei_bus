//
//  RKBusStop.h
//  simplebus
//
//  Created by csjan on 5/8/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKBusStop : NSObject
@property (nonatomic, copy) NSNumber *StopID;
@property (nonatomic, copy) NSNumber *GoBack;
@property (nonatomic, copy) NSNumber *RouteID;
@property (nonatomic, copy) NSNumber *EstimateTime;
@property (nonatomic, copy) NSString *nameZh;

@end
