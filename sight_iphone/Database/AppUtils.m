//
//  AppUtils.m
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import "AppUtils.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation AppUtils

NSString * const DefaultUser          = @"default";
NSString * const UserPathFormat       = @"user_%@"; //eg: user_default, user_1001


#pragma mark - system info
+ (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documemtPath = [paths objectAtIndex:0];
    return documemtPath;
}

+ (NSString *)libraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (NSString *)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths objectAtIndex: 0];
	return cacheDir;
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)appFilePath
{
    NSString *path = [[self libraryPath] stringByAppendingPathComponent:@"ss"];
    NSLog(@"----- path = %@",path);
    [self mkdir:path];
    return path;
}


+ (NSString *)appVersion
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSDictionary* infoDictionary =  [mainBundle infoDictionary];
    NSString *key = @"CFBundleShortVersionString";
    return [infoDictionary objectForKey:key];
}

+ (NSString *)buildVersion
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSDictionary* infoDictionary =  [mainBundle infoDictionary];
    NSString *key = @"CFBundleVersion";
    return [infoDictionary objectForKey:key];
}

+ (NSString *)appIdentifier
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSDictionary* infoDictionary =  [mainBundle infoDictionary];
    NSString *key = @"CFBundleIdentifier";
    return [infoDictionary objectForKey:key];
}

+ (NSString *)preferredLanguage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [userDefault objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

+ (NSString *)currentUserPath
{
    return [self defaultUserPath];
}

+ (NSString *)defaultUserPath
{
    return [self userPathWithUserID:nil];
}

+ (NSString *)userPathWithUserID:(NSNumber *)uid
{
    NSString *user = uid == nil ? DefaultUser : [uid stringValue];
    NSString *userPath = [[self appFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:UserPathFormat, user]];
    [self mkdir:userPath];

    return userPath;
}

+ (void)mkdir:(NSString *)path
{
    NSError * error;
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]){
        NSLog(@"Can not create directory: %@; error:%@", path, error);
    }
}

+ (BOOL)saveUserData:(id)data key:(NSString *)key {
    if (isEmptyString(key)) {
        return NO;
    } else {
        NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];
        [userD setObject:data forKey:key];
        return [userD synchronize];
    }
}

+ (id) fetchUserDataForKey:(NSString *)key {
    return isEmptyString(key) ? nil : [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (BOOL)hasLogin {
    NSString *token = [self fetchUserDataForKey:@"token"];
    return NO == isEmptyString(token);
}

/*
 ts 时间戳
 uuid 设备id
 version app客户端版本号
 platform 平台 比如 iphone7.2
 os    8.3(ios版本)
 sign  请求签名
 */

+ (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

//获得当前的时间戳
+ (NSString *)getTimeStamp
{
    //系统当前时间
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];

    NSString *ts = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    return ts;
}


#pragma mark -- 通用参数
+ (NSMutableDictionary *)getGeneralParameters
{
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSString *strName = [self getDeviceVersion];;
    NSString *platform = [strName stringByReplacingOccurrencesOfString:@"," withString:@"."];

    NSString *currentKey = (NSString *)kCFBundleVersionKey;

    NSString *version = [NSBundle mainBundle].infoDictionary[currentKey];

    NSString *os = [[UIDevice currentDevice] systemVersion];

    NSString *ts = [self getTimeStamp];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObjectSafe:uuid forKey:@"uuid"];
    [dic setObjectSafe:platform forKey:@"platform"];
    [dic setObjectSafe:version forKey:@"version"];
    [dic setObjectSafe:os forKey:@"os"];
    [dic setObjectSafe:ts forKey:@"ts"];
    return dic;
}

@end
