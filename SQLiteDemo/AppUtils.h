//
//  AppUtils.h
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const DefaultUser;
extern NSString * const UserPathFormat;

@interface AppUtils : NSObject

+ (NSString *)documentPath;
+ (NSString *)libraryPath;
+ (NSString *)cachePath;
+ (NSString *)tempPath;

+ (NSString *)appFilePath;
+ (NSString *)appVersion;
+ (NSString *)buildVersion;
+ (NSString *)appIdentifier;
+ (NSString *)preferredLanguage;

+ (NSString *)currentUserPath;
+ (NSString *)defaultUserPath;
+ (NSString *)userPathWithUserID:(NSNumber *)uid;


@end
