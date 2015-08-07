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

+ (NSMutableArray *)queryFromTable:(NSString *)table;

+ (NSArray *)queryFromTable:(NSString *)table from:(NSInteger)from count:(NSInteger)count;

// 作业： 实现
+ (void)deleteInfo:(StaffInfo *)staffInfo;

+ (void)modifyInfo:(StaffInfo *)oldInfo newInfo:(StaffInfo*)newInfo;


@end
