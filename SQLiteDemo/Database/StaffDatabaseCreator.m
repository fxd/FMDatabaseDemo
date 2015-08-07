//
//  StaffDatabaseCreator.m
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import "StaffDatabaseCreator.h"
#import "FMDatabase.h"
#import "DatabaseConstants.h"
#import "DatabaseUtils.h"
#import "FMDatabaseAdditions.h"


@implementation StaffDatabaseCreator

#pragma mark - 创建表
- (void) createDatabase:(NSString *)name databaseHandler:(FMDatabase *)dbHandler
{
    // create Rework table;
    [self createReworkTable:dbHandler];
}

// Rework table
- (void)createReworkTable:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ("
                     "%@ INTEGER PRIMARY KEY, "
                     "%@ TEXT, "
                     "%@ TEXT, "
                     "%@ TEXT, "
                     "%@ TEXT);",
                     
                     StaffTable,
                     ColumnID,
                     ColumnName,
                     ColumnSex,
                     ColumnWork,
                     ColumnBU
                     ];
    
    [db executeSQL:sql throwExceptionWhenError:YES];
}


#pragma mark - 数据库升级
- (void) updateDatabase:(NSString *)name fromVersion:(NSUInteger)oldversion toVersion:(NSUInteger)newVersion databaseHandler:(FMDatabase *)dbHandler
{
    NSLog(@"db name = %@, USER old version = %lu, new version = %lu",name, (unsigned long)oldversion, (unsigned long)newVersion);
    
    if (oldversion < 2) {
        //update table
    }
    
    if (oldversion < 3) {
        //update table
    }
    
    if (oldversion < 4) {
        //update table
    }
}


@end
