//
//  Utility.h
//  QunarClient
//
//  Created by huangqing on 10/12/10.
//  Copyright 2010 nanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface Utility : NSObject

// 得到周几
+ (NSString *)getShortWeekend:(NSInteger)index;

// 得到星期几
+ (NSString *)getFullWeekend:(NSInteger)index;

// 将传的double转换成字符串，去掉无效的0
+ (NSString *)double2String:(double)value;

// 获取文件或者文件夹的大小
+ (long long)fileSizeAtPath:(NSString *)filePath;
+ (long long)folderSizeAtPath:(NSString *)folderPath;

// 判断JPEG格式文件有效性
+ (BOOL)isJPEGValid:(NSData *)jpeg;

// GCD utility
+ (void)performOnMainThread:(dispatch_block_t)block;
+ (void)performInBackground:(dispatch_block_t)block;
@end
