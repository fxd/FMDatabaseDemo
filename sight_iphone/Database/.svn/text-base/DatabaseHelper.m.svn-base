//
//  DatabaseHelper.m
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//


#import "DatabaseHelper.h"
#import "FMDatabase.h"
//#import "sqlite3.h"

@interface DatabaseHelper()

@property (nonatomic, assign) BOOL opened;

-(int)DBVersion;
-(void)setDBVersion:(NSUInteger)version;
-(BOOL)initDB;
-(void)openDB;

@end

@implementation DatabaseHelper
@synthesize opened;

-(FMDatabase *)database
{
    [self openDB];
    return _dbHandler;
}

- (id)init
{
    self = [super init];
    if (self) {
        _dbHandler = [[FMDatabase alloc]initWithPath:nil];
        _dbVersion = 1;
        
    }
    
    return self;
}


-(id) initWithPath:(NSString *)aPath version:(NSUInteger) version{
    self = [super init];
    if(self){
        _dbHandler = [[FMDatabase alloc] initWithPath:aPath];
        _dbVersion = version;
    }
    return self;
}


-(BOOL) initDB
{
    BOOL op = YES;
#ifdef DEBUG
    _dbHandler.crashOnErrors = YES;
#endif
    
    int version = [self DBVersion];
    if(version != _dbVersion){
        @try {
            [_dbHandler beginTransaction];
            if(version == 0){
                [self createDatabase:_dbHandler];
            }
            else if (version < _dbVersion) {
                [self updateDatabase:_dbHandler from:version to:_dbVersion];
            }
            else {
                SSAssertDebug(NO, @"Database:%@ can degrade from version %d to version %lu. Please reinstall your app!", [[_dbHandler databasePath] lastPathComponent], version, (unsigned long)_dbVersion);
            }
            [self setDBVersion:_dbVersion];
            [_dbHandler commit];
        }
        @catch (NSException *exception) {
            [_dbHandler rollback];
            op = NO;
        }
    }
    return op;
}

-(void)openDB
{
    if(self.opened){
        return;
    }
    
    if([_dbHandler open]){
        if ([self initDB]) {
            self.opened = YES;
        } else {
            SSAssertDebug(NO, @"ERROR: initlize database failed!!!");
        }
    } else {
        [_dbHandler close];
        _dbHandler = nil;
        SSAssertDebug(YES, @"ERROR: open database failed!!!");
    }
}


-(int)DBVersion
{
    int userVersion = 0;
    FMResultSet* rs = [_dbHandler executeQuery:@"PRAGMA user_version;"];
    while ([rs next]) {
        userVersion = [rs intForColumnIndex:0];
        break;
    }
    return userVersion;
}

-(void)setDBVersion:(NSUInteger)version
{
    NSString *sql = [NSString stringWithFormat:@"PRAGMA user_version=%lu;", (unsigned long)version];
    [_dbHandler executeUpdate:sql];
    if ([_dbHandler hadError]) {
        NSLog(@"[ERROR] SQL error code: %d, message: %@", [_dbHandler lastErrorCode], [_dbHandler lastErrorMessage]);
    }
}

-(void)createDatabase:(FMDatabase *)dbHandler
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

-(void) updateDatabase:(FMDatabase *) dbHandler from: (NSUInteger) oldVersion to: (NSUInteger) newVersion
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
