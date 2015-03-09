//
//  MyEveningFav.h
//  simplebus
//
//  Created by csjan on 5/29/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyEveningFav : NSManagedObject

@property (nonatomic, retain) NSNumber * goback;
@property (nonatomic, retain) NSNumber * routeid;
@property (nonatomic, retain) NSString * routenamezh;
@property (nonatomic, retain) NSNumber * stopid;
@property (nonatomic, retain) NSString * stopnamezh;

@end
