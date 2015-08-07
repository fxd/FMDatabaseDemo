//
//  DatabaseManager.m
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//


#import "DatabaseManager.h"
#import "FMDatabase.h"
#import "DatabaseHelper.h"
#import "FMDatabaseQueue.h"

@interface DatabaseInfo : NSObject
@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *path;
@property (nonatomic)       NSInteger    version;
@property (nonatomic, copy) NSString    *creatorName;
@end

@implementation DatabaseInfo
@end

//////////////////////////////////////////////////////////////////////////

@interface DBhandler : DatabaseHelper

@property (nonatomic, retain) DatabaseInfo *databaseInfo;

- (id) initWithDatabaseInfo:(DatabaseInfo *)info;
@end

@implementation DBhandler
@synthesize databaseInfo;

- (id) initWithDatabaseInfo:(DatabaseInfo *) info
{
    
    self = [super initWithPath:info.path version:info.version];
    if (self) {
        self.databaseInfo = info;
    }
    return self;
}


- (void)createDatabase:(FMDatabase *)dbHandler
{
    id creator = [[NSClassFromString(self.databaseInfo.creatorName) alloc] init];
    NSAssert(creator && [creator conformsToProtocol:@protocol(DatabaseCreator)], @"invalid creator: %@", self.databaseInfo.creatorName);
    [creator createDatabase:self.databaseInfo.name databaseHandler:dbHandler];
}

- (void) updateDatabase:(FMDatabase *)dbHandler from:(NSUInteger)oldVersion to:(NSUInteger)newVersion
{
    id creator = [[NSClassFromString(self.databaseInfo.creatorName) alloc] init];
    NSAssert(creator && [creator conformsToProtocol:@protocol(DatabaseCreator)], @"invalid creator: %@", self.databaseInfo.creatorName);
    [creator updateDatabase:self.databaseInfo.name fromVersion:oldVersion toVersion:newVersion databaseHandler:dbHandler];
}

@end

////////////////////////////////////////////////////////////////////////////////////

@interface FMDatabaseQueue(Database)
+ (instancetype)databaseQueueWithDatabase:(FMDatabase *)database path:(NSString *)path;
- (instancetype)initWithDatabase:(FMDatabase *)database path:(NSString *)path;

@end

@implementation FMDatabaseQueue(Database)

+ (instancetype)databaseQueueWithDatabase:(FMDatabase *)database path:(NSString *)path
{
    FMDatabaseQueue *q = [[self alloc] initWithDatabase:database path:path];
    FMDBAutorelease(q);
    return q;
}

- (instancetype)initWithDatabase:(FMDatabase *)database path:(NSString *)path
{
    self = [super init];
    if (self) {
        _db = FMDBReturnRetained(database);
        _path = FMDBReturnRetained(path);
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
    }
    return self;
}

@end


////////////////////////////////////////////////////////////////////////////

@interface DatabaseManager()
@property (nonatomic, retain) NSMutableDictionary *databaseDic;
@property (nonatomic, retain) NSMutableDictionary *databaseQueueDic;
@end


@implementation DatabaseManager
@synthesize databaseDic, databaseQueueDic;

SYNTHESIZE_SINGLETON(DatabaseManager)

- (DBhandler *)DBHelperWithPath:(NSString *)path
{
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Databases" ofType:@"plist"]];
    
    NSString *dbName = [path lastPathComponent];
    NSLog(@"dbName=%@", dbName);
    
    NSDictionary *dic = [config objectForKey:dbName];
    NSAssert(dic && dic.count > 0, @"invalid user database configuration, check Databases.plist");
    DatabaseInfo *info = [[DatabaseInfo alloc] init];
    info.name = dbName;
    info.path = path;
    info.version = [[dic objectForKey:@"version"] intValue];
    info.creatorName = [dic objectForKey:@"creator"];
    DBhandler *helper = [[DBhandler alloc] initWithDatabaseInfo:info];
    return helper;
}

#pragma mark - public methods

- (FMDatabase *)databaseWithPath:(NSString *)path
{
    @synchronized([DatabaseManager class]){
        if (self.databaseDic == nil) {
            self.databaseDic = [NSMutableDictionary dictionary];
        }
        id obj = [self.databaseDic objectForKey:path];
        if ( obj == nil ) {
            @autoreleasepool {
                DBhandler *helper = [self DBHelperWithPath:path];
                obj = [helper database];
                [self.databaseDic setObject:obj forKey:path];
            }
        }
        NSAssert(obj && [obj isKindOfClass:[FMDatabase class]], @"invalid DBHandler:%@", obj);
        return obj;
    }
}

- (FMDatabaseQueue *)databaseQueueWithPath:(NSString *)path
{
    @synchronized([DatabaseManager class]) {
        if (self.databaseQueueDic == nil) {
            self.databaseQueueDic = [NSMutableDictionary dictionary];
        }
        FMDatabaseQueue *dbQueue = [self.databaseQueueDic objectForKey:path];
        if (dbQueue == nil) {
            @autoreleasepool {
                DBhandler *helper = [self DBHelperWithPath:path];
                dbQueue = [FMDatabaseQueue databaseQueueWithDatabase:[helper database] path:helper.databaseInfo.path];
                [self.databaseQueueDic setObject:dbQueue forKey:path];
            }
        }
        return dbQueue;
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    for (FMDatabase *db in [self.databaseDic objectEnumerator]) {
        [db close];
    }
    self.databaseDic = nil;
    
    for (FMDatabaseQueue *q in [self.databaseQueueDic objectEnumerator]) {
        [q close];
    }
    self.databaseQueueDic = nil;
    
}

@end


