//
//  DatabaseUtils.h
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"


typedef enum {
    /**
     *  When a constraint violation occurs, an immediate ROLLBACK occurs,
     * thus ending the current transaction, and the command aborts with a
     * return code of SQLITE_CONSTRAINT. If no transaction is active
     * (other than the implied transaction that is created on every command)
     *  then this algorithm works the same as ABORT.
     */
    ROLLBACK = 0,
    
    /**
     * When a constraint violation occurs,no ROLLBACK is executed
     * so changes from prior commands within the same transaction
     * are preserved. This is the default behavior.
     */
    ABORT,
    
    /**
     * When a constraint violation occurs, the command aborts with a return
     * code SQLITE_CONSTRAINT. But any changes to the database that
     * the command made prior to encountering the constraint violation
     * are preserved and are not backed out.
     */
    FAIL,
    
    /**
     * When a constraint violation occurs, the one row that contains
     * the constraint violation is not inserted or changed.
     * But the command continues executing normally. Other rows before and
     * after the row that contained the constraint violation continue to be
     * inserted or updated normally. No error is returned.
     */
    IGNORE,
    
    /**
     * When a UNIQUE constraint violation occurs, the pre-existing rows that
     * are causing the constraint violation are removed prior to inserting
     * or updating the current row. Thus the insert or update always occurs.
     * The command continues executing normally. No error is returned.
     * If a NOT NULL constraint violation occurs, the NULL value is replaced
     * by the default value for that column. If the column has no default
     * value, then the ABORT algorithm is used. If a CHECK constraint
     * violation occurs then the IGNORE algorithm is used. When this conflict
     * resolution strategy deletes rows in order to satisfy a constraint,
     * it does not invoke delete triggers on those rows.
     *  This behavior might change in a future release.
     */
    REPLACE
} DBConflictPolicy;

@class FMResultSet;
@class DatabaseRowSet;

#pragma mark - DatabaseRow

//
// A wrapper class for access to a row of data from the result set
//
@interface DatabaseRow : NSObject {
@private
    __weak DatabaseRowSet *dbRowSet;
}
- (id) initWithDatabaseRowSet:(DatabaseRowSet *)set;

- (int)intForColumn:(NSString*)columnName;
- (int)intForColumnIndex:(int)columnIdx;

- (long)longForColumn:(NSString*)columnName;
- (long)longForColumnIndex:(int)columnIdx;

- (BOOL)boolForColumn:(NSString*)columnName;
- (BOOL)boolForColumnIndex:(int)columnIdx;

- (double)doubleForColumn:(NSString*)columnName;
- (double)doubleForColumnIndex:(int)columnIdx;

- (NSString*)stringForColumn:(NSString*)columnName;
- (NSString*)stringForColumnIndex:(int)columnIdx;

- (NSDate*)dateForColumn:(NSString*)columnName;
- (NSDate*)dateForColumnIndex:(int)columnIdx;

- (NSData *) dataForColumn:(NSString *)columnName;
- (NSData *) dataForColumnIndex:(int)columnIdx;

- (id) objectForColumn:(NSString *)columnName;
- (id) objectForColumnIndex:(int)columnIdx;
@end


#pragma mark - DatabaseRowSet

//
// A wrapper class, like FMResult, used to store the query results.
// use <b>+ rowSetFromResultSet:</b> to convert FMResultSet to DatabaseRowSet,
// and you can free the statement to reduce concurrent read the statement from multi-threads, 
// (concurrent read statement will cause to "EXC_BAD_ACCESS");
//
@interface DatabaseRowSet : NSObject <NSFastEnumeration>
- (NSUInteger) count;
- (DatabaseRow *) rowAtIndex:(NSUInteger)index;

- (NSUInteger) columnIndexForName:(NSString *)columnName;

+ (id) rowSetFromResultSet:(FMResultSet *)set;

@end

#pragma mark - database utils
@interface DatabaseUtils : NSObject

+ (FMDatabaseQueue *) guestUserDatabaseQueue;
+ (FMDatabaseQueue *) currentUserDatabaseQueue;
+ (FMDatabaseQueue *) userDatabaseQueueWithUserID:(NSNumber *)uid;
/*!
 * @function -databaseQueueWithName:
 *
 * @abstract return a FMDatabaseQueue object with the specified name;
 *
 * @discussion It's suggest to use "Databases.plist" to config your databases.
 * @see DatabaseManager, -currentUserDatabaseQueue:, -userDatabaseQueueWithUserID:
 *
 * @param dbName - the database name, see "Database.plist"
 */
+ (FMDatabaseQueue *) databaseQueueWithName:(NSString *)dbName;

@end

#pragma mark - FMDatabase+DatabaseUtils
@interface FMDatabase(DatabaseUtils)

/*!
 * @function +executeSQL:database
 * @abstract execute a raw SQL, throw an NSException if error.
 *
 * @param sql: raw SQL will be executed
 * @param db: FMDatabase handler.
 * @param throwException: throw exception when error occured.
 */
- (void)executeSQL:(NSString *)sql throwExceptionWhenError:(BOOL)throwException;

- (FMResultSet *) queryFromTable:(NSString *) table
                     columnNames:(NSArray *)columns
                           where:(NSString *)where 
                       whereArgs:(NSArray *)args 
                         orderby:(NSString *)orderby 
                         groupby:(NSString *)groupby 
                           limit:(NSString *)limit;

- (NSUInteger) insertIntoTable:(NSString *)table 
             withContentValues:(NSDictionary *)values;

- (NSUInteger) insertIntoTable:(NSString *)table 
             withContentValues:(NSDictionary *)values 
                conflictPolicy:(DBConflictPolicy) policy;


- (NSUInteger) updateTable:(NSString *)table 
             contentValues:(NSDictionary *)values 
                     where:(NSString*)where 
                 whereArgs:(NSArray *)whereArgs;

- (NSUInteger) updateTable:(NSString *)table
             contentValues:(NSDictionary *)values
                     where:(NSString*)where 
                 whereArgs:(NSArray *)whereArgs  
            conflictPolicy:(DBConflictPolicy) policy;

- (NSUInteger) deleteFromTable:(NSString *)table 
                         where:(NSString *)where 
                     whereArgs:(NSArray *)whereArgs;
@end


#pragma mark - FMDatabaseQueue+DatabaseUtils
@interface FMDatabaseQueue (DatabaseUtils)
- (int)intForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION;
- (long)longForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION;
- (BOOL)boolForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION;
- (double)doubleForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION;
- (NSString*)stringForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION;
- (NSData*)dataForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION;
- (NSDate*)dateForQuery:(NSString*)sql, ...NS_REQUIRES_NIL_TERMINATION;

- (DatabaseRowSet *) rowSetForQuery:(NSString *)sql, ...NS_REQUIRES_NIL_TERMINATION;
@end
