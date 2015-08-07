//
//  Utility.m
//  QunarClient
//
//  Created by huangqing on 10/12/10.
//  Copyright 2010 nanjing. All rights reserved.
//

#import "Utility.h"
#import "zlib.h"
#include <sys/stat.h>

@implementation Utility


// 得到星期几
+ (NSString *)getShortWeekend:(NSInteger)index
{
	switch (index)
	{
		case 1:
			return @"周日";
		case 2:
			return @"周一";
		case 3:
			return @"周二";
		case 4:
			return @"周三";
		case 5:
			return @"周四";
		case 6:
			return @"周五";
		case 7:
			return @"周六";
	}
	
	return nil;
}

// 得到星期几
+ (NSString *)getFullWeekend:(NSInteger)index
{
    switch (index)
	{
		case 1:
			return @"星期日";
		case 2:
			return @"星期一";
		case 3:
			return @"星期二";
		case 4:
			return @"星期三";
		case 5:
			return @"星期四";
		case 6:
			return @"星期五";
		case 7:
			return @"星期六";
	}
	
	return nil;
}

// 将传的double转换成字符串，去掉无效的0
+ (NSString *)double2String:(double)value
{
	// 先转换成字符串
    NSString *stringDouble = [NSString stringWithFormat:@"%f", value];
    NSUInteger stringDoubleLen = [stringDouble length];
    
    // 得到小数点的位置
    NSRange dotRange = [stringDouble rangeOfString:@"."];
    NSUInteger dotPos = dotRange.location;
	if(dotPos != NSNotFound)
	{
		NSString *afterDotString = [stringDouble substringFromIndex:(dotPos + 1)];
		NSUInteger afterDotStringLen = [afterDotString length];
		
		// 去掉0
		for(int i = 0; i < afterDotStringLen; i++)
		{
			NSString *subString = [stringDouble substringFromIndex:(stringDoubleLen - 1 - i)];
			if([subString isEqualToString:@"0"] == NO)
			{
				return stringDouble;
			}
			else
			{
				stringDouble = [stringDouble substringToIndex:(stringDoubleLen - 1 - i)];
			}
			
		}
		
		// 小数点后全部都是零
		return [stringDouble substringToIndex:(stringDoubleLen - 1 - afterDotStringLen)];
	}
	
	return stringDouble;
}

+ (long long)fileSizeAtPath:(NSString *)filePath
{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

+ (long long)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (BOOL)isJPEGValid:(NSData *)jpeg
{
    if ([jpeg length] < 4) return NO;
    const unsigned char * bytes = (const unsigned char *)[jpeg bytes];
    if (bytes[0] != 0xFF || bytes[1] != 0xD8) return NO;
    if (bytes[[jpeg length] - 2] != 0xFF || bytes[[jpeg length] - 1] != 0xD9) return NO;
    return YES;
}

// GCD
+ (void)performOnMainThread:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (void)performInBackground:(dispatch_block_t)block
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, block);
}

@end
