//
//  DatabaseManager.h
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SingletonTemplate.h"

@class FMDatabase;
@class FMDatabaseQueue;
@protocol DatabaseCreator <NSObject>

@required
- (void) createDatabase:(NSString *)name databaseHandler:(FMDatabase *)dbHandler;
- (void) updateDatabase:(NSString *)name fromVersion:(NSUInteger) oldversion toVersion:(NSUInteger)newVersion databaseHandler:(FMDatabase *)dbHandler;
@end

#pragma mark -
@interface DatabaseManager : NSObject

DECLARE_SINGLETON(DatabaseManager)

/*!
 * @function - databaseWithPath:
 *
 * @abstract return a FMDatabase object with the specified path.
 *
 * @discussion
 * you CAN NOT use both -databaseWithPath: and -dataaseQueueWithPath: to interact
 * with the same database in you project. YOU CAN ONLY USE ONE OF THEM.
 *
 * @see - databaseQueueWithPath
 */
- (FMDatabase *)databaseWithPath:(NSString *)path;

/*!
 * @function - databaseQueueWithPath:
 *
 * @abstract return a FMDatabaseQueue object with the specified path.
 *
 * @discussion
 * you CAN NOT use both -databaseWithPath: and -dataaseQueueWithPath: to interact
 * with the same database in you project. YOU CAN ONLY USE ONE OF THEM.
 *
 * @see - databaseWithPath
 */
- (FMDatabaseQueue *)databaseQueueWithPath:(NSString *) path;

@end
