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


@end
