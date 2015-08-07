//
//  BookInfo.h
//  sight_iphone
//
//  Created by fengshaobo on 15/4/7.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffInfo : NSObject

@property (nonatomic, assign) NSInteger ID;

// 姓名
@property (nonatomic, strong) NSString *name;

// 性别
@property (nonatomic, strong) NSString *sex;

// 工种
@property (nonatomic, strong) NSString *work;

// 部门
@property (nonatomic, strong) NSString *bu;

- (void)printInfo;

@end
