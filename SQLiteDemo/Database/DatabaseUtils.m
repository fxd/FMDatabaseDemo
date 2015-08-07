//
//  DatabaseUtils.m
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import "DatabaseUtils.h"
#import "AppUtils.h"
#import "DatabaseManager.h"
#import "DatabaseConstants.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"

#define isEmptyString(s)  (((s) == nil) || ([(s) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0))


static NSString *DBConflictPolicyString[] = {
    @"OR ROLLBACK", 
    @"OR ABORT", 
    @"OR FAIL", 
    @"OR IGNORE", 
    @"OR REPLACE"
};

@implementation DatabaseUtils

+ (FMDatabaseQueue *) guestUserDatabaseQueue
{
    NSString *path = [[AppUtils defaultUserPath] stringByAppendingPathComponent:UserDatabase];
    return [[DatabaseManager sharedInstance] databaseQueueWithPath:path];
}

+ (FMDatabaseQueue *) currentUserDatabaseQueue
{
    NSString *path = [[AppUtils currentUserPath] stringByAppendingPathComponent:UserDatabase];
    return [[DatabaseManager sharedInstance] databaseQueueWithPath:path];
}

+ (FMDatabaseQueue *) userDatabaseQueueWithUserID:(NSNumber *)uid
{
    NSString *path = [[AppUtils userPathWithUserID:uid] stringByAppendingPathComponent:UserDatabase];
    return [[DatabaseManager sharedInstance] databaseQueueWithPath:path];
}

+ (FMDatabaseQueue *) databaseQueueWithName:(NSString *)dbName
{
    NSString *path = [[AppUtils appFilePath] stringByAppendingPathComponent:dbName];
    return [[DatabaseManager sharedInstance] databaseQueueWithPath:path];
}
@end


#pragma mark - DatabaseRow -

@interface DatabaseRow()
@property (nonatomic, retain) NSMutableArray *columnData;
@end

@implementation DatabaseRow
@synthesize columnData;

- (id) initWithDatabaseRowSet:(DatabaseRowSet *)set
{
    self = [super init];
    if (self) {
        dbRowSet = set;
        self.columnData = [NSMutableArray array];
    }
    return self;
}


- (int)intForColumn:(NSString*)columnName
{
    return [self intForColumnIndex:[dbRowSet columnIndexForName:columnName]];
}

- (int)intForColumnIndex:(int)columnIdx
{
    return [[self.columnData objectAtIndex:columnIdx] intValue];
}

- (long)longForColumn:(NSString*)columnName
{
    return [self longForColumnIndex:[dbRowSet columnIndexForName:columnName]];
}
- (long)longForColumnIndex:(int)columnIdx
{
    return [[self.columnData objectAtIndex:columnIdx] longValue];
}

- (BOOL)boolForColumn:(NSString*)columnName
{
    return [self boolForColumnIndex:[dbRowSet columnIndexForName:columnName]];
}
- (BOOL)boolForColumnIndex:(int)columnIdx
{
    return [[self.columnData objectAtIndex:columnIdx] boolValue];
}

- (double)doubleForColumn:(NSString*)columnName
{
    return [self doubleForColumnIndex:[dbRowSet columnIndexForName:columnName]];
}
- (double)doubleForColumnIndex:(int)columnIdx
{
    return [[self.columnData objectAtIndex:columnIdx] doubleValue];
}

- (NSString*)stringForColumn:(NSString*)columnName
{
    return [self stringForColumnIndex:[dbRowSet columnIndexForName:columnName]];
}
- (NSString*)stringForColumnIndex:(int)columnIdx
{
    id value =  [self.columnData objectAtIndex:columnIdx];
    return (value == [NSNull null]) ? nil : value;
}

- (NSDate*)dateForColumn:(NSString*)columnName
{
    return [self dateForColumnIndex:[dbRowSet columnIndexForName:columnName]];
}
- (NSDate*)dateForColumnIndex:(int)columnIdx
{
    id value = [self.columnData objectAtIndex:columnIdx];
    return (value == [NSNull null]) ? nil : value;
}

- (NSData *) dataForColumn:(NSString *)columnName
{
    return [self dataForColumnIndex:[dbRowSet columnIndexForName:columnName]];
}
- (NSData *) dataForColumnIndex:(int)columnIdx
{
    id value = [self.columnData objectAtIndex:columnIdx];
    return (value == [NSNull null]) ? nil : value;
}

- (id) objectForColumn:(NSString *)columnName
{
    return [self objectForColumnIndex:[dbRowSet columnIndexForName:columnName]];
}
- (id) objectForColumnIndex:(int)columnIdx
{
    id value = [self.columnData objectAtIndex:columnIdx];
    return (value == [NSNull null]) ? nil : value;
}

@end

@interface DatabaseRowSet()
@property (nonatomic, retain) NSMutableArray *columnNames;
@property (nonatomic, retain) NSMutableArray *resultRows;
@end

@implementation DatabaseRowSet
@synthesize columnNames, resultRows;

- (id) init
{
    self = [super init];
    if (self) {
        self.columnNames = [NSMutableArray array];
        self.resultRows = [NSMutableArray array];
    }
    return self;
}

+ (id) rowSetFromResultSet:(FMResultSet *)set
{
    if (set == nil) {
        return nil;
    }
    
    DatabaseRowSet *rowSet = [[DatabaseRowSet alloc] init];
    sqlite3_stmt * stmt = [set.statement statement];
    int columnCount = sqlite3_column_count(stmt);
    for (int colIdx = 0; colIdx < columnCount; ++ colIdx) {
        [rowSet.columnNames addObject:[[NSString stringWithUTF8String:sqlite3_column_name(stmt, colIdx)] lowercaseString]];
    }
    NSAssert(rowSet.columnNames.count == columnCount, @"ERROR: column names count not equal to column count.");
    while ([set next]) {
        DatabaseRow *row = [[DatabaseRow alloc] initWithDatabaseRowSet:rowSet];
        for (int colIdx = 0; colIdx < columnCount; ++colIdx) {
            [row.columnData addObject:[set objectForColumnIndex:colIdx]];
        }
        [rowSet.resultRows addObject:row];
    }
    return rowSet;
}

- (NSUInteger) count
{
    return self.resultRows.count;
}

- (DatabaseRow *) rowAtIndex:(NSUInteger)index
{
    return [self.resultRows objectAtIndex:index];
}

- (NSUInteger) columnIndexForName:(NSString *)name
{
    return [self.columnNames indexOfObject:[name lowercaseString]];
}


- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [self.resultRows countByEnumeratingWithState:state objects:buffer count:len];
}

@end

@implementation FMDatabase (DatabaseUtils)

- (void)executeSQL:(NSString *)sql throwExceptionWhenError:(BOOL)throwException
{
    BOOL exeRet = [self executeUpdate:sql];
    if(!exeRet){
        if (throwException) {
            [NSException raise:NSInternalInconsistencyException format:@"SQL execution error, sql:%@; error:%@", sql, [self lastError]];
        } else {
            NSLog(@"SQL execution error, SQL:%@, ERROR:%@", sql, [self lastError]);
        }
    }
}


- (FMResultSet *) queryFromTable:(NSString *)table columnNames:(NSArray *)columns where:(NSString *)where whereArgs:(NSArray *)args orderby:(NSString *)orderby groupby:(NSString *)groupby limit:(NSString *)limit
{
    NSMutableString *sql = [NSMutableString stringWithString: @"SELECT "];
    NSMutableString *colstr = nil;
    if(columns != nil && columns.count > 0) {
        for(NSString * col in columns){
            if(colstr == nil) {
                colstr = [NSMutableString stringWithString:col];
            } else {
                [colstr appendFormat:@", %@", col];
            }
        }
    }
    if(colstr == nil){
        [sql appendString:@"* "];
    } else {
        [sql appendString:colstr];
    }
    
    [sql appendFormat:@" FROM %@", table];
    
    if (where != nil) {
        [sql appendFormat:@" WHERE %@", where];
    }
    
    if(groupby != nil) {
        [sql appendFormat:@" GROUP BY %@", groupby];
    }
    
    if (orderby != nil) {
        [sql appendFormat:@" ORDER BY %@", orderby];
    }
    
    if (limit != nil) {
        [sql appendFormat:@" LIMIT %@", limit];
    }
    
    NSLog(@"SQL: %@", sql);
    
    return [self executeQuery:sql withArgumentsInArray:args];
}


- (NSUInteger) insertIntoTable:(NSString *)table withContentValues:(NSDictionary *)values
{
    return [self insertIntoTable:table withContentValues:values conflictPolicy:ABORT];
}

- (NSUInteger) insertIntoTable:(NSString *)table withContentValues:(NSDictionary *)values conflictPolicy:(DBConflictPolicy)policy
{
    
    NSMutableString *colNames = [NSMutableString string];
    NSMutableString *colArgs = [NSMutableString string];
    NSMutableArray *colArgVal = [[NSMutableArray alloc] initWithCapacity:values.count];
    for (NSString *key in [values keyEnumerator] ) {
        if (colNames.length > 0) {
            [colNames appendFormat:@", %@", key];
            [colArgs appendString:@", ?"];
        } else {
            [colNames appendString:key];
            [colArgs appendString:@"?"];
        }
        [colArgVal addObject:[values objectForKey:key]];
    }
    NSUInteger retCode = NSNotFound;
    NSString *sql = [NSString stringWithFormat:@"INSERT %@ INTO %@ (%@) VALUES (%@)", DBConflictPolicyString[policy], table, colNames, colArgs];
    NSLog(@"SQL: %@", sql);
    
    if ([self executeUpdate:sql withArgumentsInArray:colArgVal]) {
        retCode = [self lastInsertRowId];
    } else {
        NSLog(@"SQL Error: %@", [self lastError]);
    }
    return retCode;
}

- (NSUInteger) updateTable:(NSString *)table contentValues:(NSDictionary *)values where:(NSString *)where whereArgs:(NSArray *)whereArgs
{
    return [self updateTable:table contentValues:values where:where whereArgs:whereArgs conflictPolicy:ABORT];
}

- (NSUInteger) updateTable:(NSString *)table contentValues:(NSDictionary *)values where:(NSString *)where whereArgs:(NSArray *)whereArgs conflictPolicy:(DBConflictPolicy)policy
{
    
    NSMutableString *changing = [NSMutableString string];
    NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:values.count];
    for (NSString * key in [values keyEnumerator]) {
        if (changing.length > 0) {
            [changing appendFormat:@", %@=?", key];
        } else {
            [changing appendFormat:@"%@=?", key];
        }
        [args addObject:[values objectForKey:key]];
    }
    if (whereArgs && whereArgs.count > 0) {
        [args addObjectsFromArray:whereArgs];
    }
    NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ %@ SET %@", DBConflictPolicyString[policy], table, changing];
    if (!isEmptyString(where)) {
        [sql appendFormat:@" WHERE %@", where];
    }
    
    NSLog(@"SQL: %@", sql);
    
    int changed = NSNotFound;
    if([self executeUpdate:sql withArgumentsInArray:args]){
        changed = [self changes];
    } else {
        NSLog(@"SQL Error: %@", [self lastError]);
    }
    
    return changed;
}

- (NSUInteger) deleteFromTable:(NSString *)table where:(NSString *)where whereArgs:(NSArray *)whereArgs
{
    
    NSMutableString *sqlstring = [NSMutableString stringWithFormat:@"DELETE FROM %@", table];
    if (!isEmptyString(where)) {
        [sqlstring appendFormat:@" WHERE %@", where];
    }
    NSLog(@"SQL: %@", sqlstring);
    NSInteger changed = NSNotFound;
    if([self executeUpdate:sqlstring withArgumentsInArray:whereArgs]) {
        changed = [self changes];
    } else {
        NSLog(@"SQL Error: %@", [self lastError]);
    }
    return changed;
}
@end



@interface FMDatabase (DatabaseQueueUtils)
- (FMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray*)arrayArgs orDictionary:(NSDictionary *)dictionaryArgs orVAList:(va_list)args;
@end

@implementation FMDatabaseQueue (DatabaseUtils)

#define DATABASEQUEUE_RETURN_RESULT_FOR_QUERY(type, sel)     \
    va_list args;                                            \
    va_start(args, sql);                                     \
    NSMutableArray *argsArray = [NSMutableArray array];      \
    for(id arg = va_arg(args, id); arg != nil; arg = va_arg(args, id)) { \
        [argsArray addObject:arg];                           \
    }                                                        \
    va_end(args);                                            \
    __block type val = 0x00;                                 \
    [self inDatabase:^(FMDatabase *db) {                     \
        FMResultSet *set = [db executeQuery:sql withArgumentsInArray:argsArray orDictionary:0x00 orVAList:nil]; \
        while ([set next]) {                                 \
            val = [set sel:0];                               \
            break;                                           \
        }                                                    \
        [set close];                                         \
    }];                                                      \
    return val;

- (int)intForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION
{
    DATABASEQUEUE_RETURN_RESULT_FOR_QUERY(int, intForColumnIndex);
}
- (long)longForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION
{
    DATABASEQUEUE_RETURN_RESULT_FOR_QUERY(long, longForColumnIndex);
}
- (BOOL)boolForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION
{
    DATABASEQUEUE_RETURN_RESULT_FOR_QUERY(BOOL, boolForColumnIndex);
}
- (double)doubleForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION
{
    DATABASEQUEUE_RETURN_RESULT_FOR_QUERY(double, doubleForColumnIndex);
}
- (NSString*)stringForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION
{
    DATABASEQUEUE_RETURN_RESULT_FOR_QUERY(NSString *, stringForColumnIndex);
}
- (NSData*)dataForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION
{
    DATABASEQUEUE_RETURN_RESULT_FOR_QUERY(NSData *, dataForColumnIndex);
}
- (NSDate*)dateForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION
{
    DATABASEQUEUE_RETURN_RESULT_FOR_QUERY(NSDate *, dateForColumnIndex);
}

- (DatabaseRowSet *) rowSetForQuery:(NSString *)sql, ...NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start(args, sql);
    NSMutableArray *argsArray = [NSMutableArray array];
    for(id arg = va_arg(args, id); arg != nil; arg = va_arg(args, id)) {
        [argsArray addObject:arg];
    }
    va_end(args);
    
    __block DatabaseRowSet *set = nil;
    [self inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:argsArray orDictionary:nil orVAList:nil];
        set = [DatabaseRowSet rowSetFromResultSet:rs];
        [rs close];
    }];
	return set;
}



@end
