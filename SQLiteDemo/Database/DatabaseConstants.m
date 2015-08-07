//
//  DatabaseConstants.m
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//


#import "DatabaseConstants.h"

// _id, integer, primary key, for all tables
#define kTableColumnPrimaryIDKey @"_id"

#pragma mark - databases
NSString * const UserDatabase           = @"user.db";

NSString * const QunarDatabase          = @"qunar.db";


#pragma mark - Rework table
NSString * const StaffTable             = @"staff";
NSString * const ColumnID               = kTableColumnPrimaryIDKey;
NSString * const ColumnName             = @"name";
NSString * const ColumnSex              = @"sex";
NSString * const ColumnWork             = @"work";
NSString * const ColumnBU               = @"bu";

