//
//  SQLManager.h
//  sight_iphone
//
//  Created by fengshaobo on 15/4/7.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseConstants.h"
#import "StaffInfo.h"

@interface SQLManager : NSObject

+ (void)initDatabase;

+ (void)insertInfo:(NSArray *)info intoTable:(NSString *)table;

+ (void)deleteInfo:(StaffInfo *)staffInfo;

+ (void)changeInfo:(StaffInfo *)oldInfo newInfo:(StaffInfo*)newInfo;

+ (NSMutableArray *)queryFromTable:(NSString *)table;

+ (NSArray *)queryFromTable:(NSString *)table from:(NSInteger)from count:(NSInteger)count;

@end
