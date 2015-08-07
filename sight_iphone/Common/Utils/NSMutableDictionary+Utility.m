//
//  NSMutableDictionary+Utility.m
//  QunariPhone
//
//  Created by Neo on 3/8/13.
//  Copyright (c) 2013 Qunar.com. All rights reserved.
//

#import "NSMutableDictionary+Utility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSMutableDictionary (Utility)

- (void)setObjectSafe:(id)anObject forKey:(id < NSCopying >)aKey
{
	if(anObject != nil)
	{
		[self setObject:anObject forKey:aKey];
	}
}

- (NSString *) md5 {
    
    //按照字典的首字母排序，合成key&value的字符串，然后通过md5加密
    NSArray *keys = [self allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedArray) {
        [sign appendFormat:@"%@=%@&",key,[self objectForKey:key]];
    }
    //md5加密
    const char *cStr = [sign UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
    
}
@end
