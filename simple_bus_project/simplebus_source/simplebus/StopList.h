//
//  StopList.h
//  simplebus
//
//  Created by csjan on 5/29/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RouteList;

@interface StopList : NSManagedObject

@property (nonatomic, retain) NSNumber * estimatetime;
@property (nonatomic, retain) NSNumber * goback;
@property (nonatomic, retain) id nameZh;
@property (nonatomic, retain) NSNumber * stopid;
@property (nonatomic, retain) RouteList *route;

@end
