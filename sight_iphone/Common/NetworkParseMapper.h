//
//  NetworkParseMapper.h
//  QunariPhone
//
//  Created by Neo on 3/10/13.
//  Copyright (c) 2013 Qunar.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkParseMapper : NSObject

@property (nonatomic, strong) NSDictionary *dictionaryMapper;	// 对照表

// 根据配置文件，获取Class中某个复合变量的数据Type
+ (NSString *)getVarTypeByVar:(NSString *)varName fromClass:(NSString *)className;

@end
