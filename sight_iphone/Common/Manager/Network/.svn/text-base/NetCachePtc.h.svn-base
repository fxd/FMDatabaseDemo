//
//  NetCachePtc.h
//  CommonFramework
//
//  Created by Neo on 4/30/14.
//  Copyright (c) 2014 Qunar.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// 网络缓存对象的接口

@protocol NetCachePtc <NSObject>

// 查找Cache
+ (id)findCacheData:(NSString *)cacheKey;

// delete缓存
+ (BOOL)deleteCache:(NSString *)cacheKey;

// 缓存处理函数(通过覆盖来订制)
+ (BOOL)dealWithCache:(id)cacheData toResult:(id)result forCustomInfo:(id)customInfo;

// 写入Cache
+ (BOOL)saveToCache:(id)cacheData withKey:(NSString *)cacheKey;

@end
