//
//  RouteList.h
//  simplebus
//
//  Created by csjan on 5/29/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RouteList : NSManagedObject

@property (nonatomic, retain) NSString * pathAttributeName;
@property (nonatomic, retain) NSString * nameZh;
@property (nonatomic, retain) NSString * providername;
@property (nonatomic, retain) NSNumber * routeid;

@end
