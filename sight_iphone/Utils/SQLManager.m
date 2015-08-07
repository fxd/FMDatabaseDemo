//
//  SQLManager.m
//  sight_iphone
//
//  Created by fengshaobo on 15/4/7.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import "SQLManager.h"
#import "DatabaseUtils.h"

@implementation SQLManager

+ (void)initDatabase {
    
    NSArray *items = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"staff" ofType:@"plist"]];
    
    if (items.count > 0) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dict in items) {
            StaffInfo *data = [[StaffInfo alloc] init];
            data.ID = [[dict objectForKey:ColumnID] integerValue];
            data.name = [dict objectForKey:ColumnName];
            data.sex = [dict objectForKey:ColumnSex];
            data.work = [dict objectForKey:ColumnWork];
            data.bu = [dict objectForKey:ColumnBU];
            [array addObject:data];
        }
        
        [self insertInfo:array intoTable:StaffTable];
    }
    
}

+ (NSMutableArray *)queryFromTable:(NSString *)table {
    FMDatabaseQueue *dbQueue = [DatabaseUtils databaseQueueWithName:QunarDatabase];
    
    __block NSMutableArray *array = [NSMutableArray array];
//    NSString *matchString = [NSString stringWithFormat:@"%%%@%%", chapter];
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db queryFromTable:table
                                 columnNames:nil
                                       where:nil//[NSString stringWithFormat:@"%@ LIKE ? ", ColumnName]
                                   whereArgs:nil//[NSArray arrayWithObjects:matchString, nil]
                                     orderby:nil
                                     groupby:nil
                                       limit:nil];
        
        while ([rs next]) {
            StaffInfo *data = [[StaffInfo alloc] init];
            data.ID = [rs intForColumn:ColumnID];
            data.name = [rs stringForColumn:ColumnName];
            data.sex = [rs stringForColumn:ColumnSex];
            data.work = [rs stringForColumn:ColumnWork];
            data.bu = [rs stringForColumn:ColumnBU];
            [array addObject:data];

        }
    }];
    return array;
}

+ (NSArray *)queryFromTable:(NSString *)table from:(NSInteger)from count:(NSInteger)count {
    
    FMDatabaseQueue *dbQueue = [DatabaseUtils databaseQueueWithName:QunarDatabase];
    
    __block NSMutableArray *array = [NSMutableArray array];
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db queryFromTable:table
                                 columnNames:nil
                                       where:nil
                                   whereArgs:nil
                                     orderby:nil
                                     groupby:nil
                                       limit:[NSString stringWithFormat:@"%ld offset %ld", count, from]];
        
        while ([rs next]) {
            StaffInfo *data = [[StaffInfo alloc] init];
            data.ID = [rs intForColumn:ColumnID];
            data.name = [rs stringForColumn:ColumnName];
            data.sex = [rs stringForColumn:ColumnSex];
            data.work = [rs stringForColumn:ColumnWork];
            data.bu = [rs stringForColumn:ColumnBU];
            [array addObject:data];
        }
    }];
    return array;
}

+ (void)insertInfo:(NSArray *)info intoTable:(NSString *)table
{
    FMDatabaseQueue *dbQueue = [DatabaseUtils databaseQueueWithName:QunarDatabase];
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for(StaffInfo *data in info) {
            if(data) {
                NSString *sql = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@) values (?, ?, ?, ?, ?)",
                                 table,
                                 ColumnID,
                                 ColumnName,
                                 ColumnSex,
                                 ColumnWork,
                                 ColumnBU
                                 ];
                [db executeUpdate:sql,
                 [NSNumber numberWithInteger:data.ID],
                 data.name,
                 data.sex,
                 data.work,
                 data.bu
                 ];
            }
        }
    }];
}


+ (void)deleteInfo:(StaffInfo *)staffInfo {
    
}

+ (void)changeInfo:(StaffInfo *)oldInfo newInfo:(StaffInfo*)newInfo {
    
}

@end
