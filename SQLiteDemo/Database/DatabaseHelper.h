//
//  DatabaseHelper.h
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//


#import <Foundation/Foundation.h>

//
// helper class use for user database version control.
//
@class FMDatabase;
@interface DatabaseHelper : NSObject
{
@private
    FMDatabase* _dbHandler;
    
    NSUInteger _dbVersion;
}

-(id) initWithPath:(NSString *)aPath version:(NSUInteger) version;

-(FMDatabase *)database;


//DO NOT call this method in your code! This method should be overrided by subclass, and ONLY can be called by this class.
// this method called when a new database is created. you should create your tables here.
-(void) createDatabase:(FMDatabase *) dbHandler;

//DO NOT call this method in your code! This method should be overrided by subclass, and ONLY can be called by this class.
// this method called when the database is updated to a new version.
-(void) updateDatabase:(FMDatabase *) dbHandler from: (NSUInteger) oldVersion to: (NSUInteger) newVersion;

@end
