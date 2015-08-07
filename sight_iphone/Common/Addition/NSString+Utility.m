//
//  NSString+URLEncoding.m
//  QunarIphone
//
//  Created by Qunar.com on 12-7-9.
//
//

#import "zlib.h"
#import "NSString+Utility.h"
#import <CommonCrypto/CommonHMAC.h>
#import "Utility.h"

@implementation NSString (Utility)

#pragma mark URLEncoding
- (NSString *)URLEncodedString
{
    NSString *result = (__bridge_transfer NSString *)
	CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
											(CFStringRef)self,
											NULL,
											CFSTR("!*'();:@&;=+$,/?%#[] "),
											kCFStringEncodingUTF8);
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (__bridge_transfer NSString *)
	CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
															(CFStringRef)self,
															CFSTR(""),
															kCFStringEncodingUTF8);
    return result;
}

#pragma mark XQueryComponents
- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return result;
}

- (NSString *)stringByEncodingURLFormat
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    result = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return result;
}

- (NSDictionary *)dictionaryFromQueryComponents
{
    NSMutableDictionary *queryComponents = [NSMutableDictionary dictionary];
    
    for(NSString *keyValuePairString in [self componentsSeparatedByString:@"&"])
    {
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if ([keyValuePairArray count] < 2) continue; // Verify that there is at least one key, and at least one value.  Ignore extra = signs
        NSString *key = [[keyValuePairArray objectAtIndex:0] stringByDecodingURLFormat];
        NSString *value = [[keyValuePairArray objectAtIndex:1] stringByDecodingURLFormat];
        NSMutableArray *results = [queryComponents objectForKey:key]; // URL spec says that multiple values are allowed per key
        
        if(!results) // First object
        {
            [queryComponents setObject:value forKey:key];
        }
    }
	
    return queryComponents;
}

- (NSDictionary *)dictionaryFromParamComponents
{
    NSMutableDictionary *paramComponents = [NSMutableDictionary dictionary];
    
    for(NSString *keyValuePairString in [self componentsSeparatedByString:@"&"])
    {
        NSString *value = nil;
        NSString *key = nil;
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        NSInteger pairCount = [keyValuePairArray count];
        if(pairCount == 2)
        {
            key = [[keyValuePairArray objectAtIndex:0] stringByDecodingURLFormat];
            value = [[keyValuePairArray objectAtIndex:1] stringByDecodingURLFormat];
        }
        else if(pairCount == 1)
        {
            key = [[keyValuePairArray objectAtIndex:0] stringByDecodingURLFormat];
            value = @"";
        }
        
        NSMutableArray *results = [paramComponents objectForKey:key];
        
        if(!results) // First object
        {
            [paramComponents setObjectSafe:value forKey:key];
        }
    }
	
    return paramComponents;
}

#pragma mark Encoding
- (NSString *)getSHA1
{
	// 分配hash结果空间
	uint8_t *hashBytes = malloc(CC_SHA1_DIGEST_LENGTH * sizeof(uint8_t));
	if(hashBytes)
	{
		memset(hashBytes, 0x0, CC_SHA1_DIGEST_LENGTH);
        
		// 计算hash值
		NSData *srcData = [self dataUsingEncoding:NSUTF8StringEncoding];
		CC_SHA1((void *)[srcData bytes], (CC_LONG)[srcData length], hashBytes);
        
		// 组建String
		NSMutableString* destString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
		for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
		{
			[destString appendFormat:@"%02X", hashBytes[i]];
		}
		
		// 释放空间
		free(hashBytes);
		
		return destString;
	}
	
	return nil;
}

- (NSString *)getMD5
{
	// 分配MD5结果空间
	uint8_t *md5Bytes = malloc(CC_MD5_DIGEST_LENGTH * sizeof(uint8_t));
	if(md5Bytes)
	{
		memset(md5Bytes, 0x0, CC_MD5_DIGEST_LENGTH);
		
		// 计算hash值
		NSData *srcData = [self dataUsingEncoding:NSUTF8StringEncoding];
		CC_MD5((void *)[srcData bytes], (CC_LONG)[srcData length], md5Bytes);
		
		// 组建String
		NSMutableString* destString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
		for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		{
			[destString appendFormat:@"%02X", md5Bytes[i]];
		}
		
		// 释放空间
		free(md5Bytes);
		
		return destString;
	}
	
	return nil;
}

#pragma mark Valid
- (BOOL)isRangeValidFromIndex:(NSInteger)index withSize:(NSInteger)rangeSize
{
	NSUInteger stringLength = [self length];
    
    if ((stringLength - index) < rangeSize)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark -- get Random String
- (NSString *)getRandomStringByLength:(NSInteger)len
{
    if (len<=0) {
        return nil;
    }
    
    char data[len];
//    for (int x=0;x<len;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    for (int x=0;x<len;)
    {
        int i = arc4random_uniform(3);
        if (i%3 == 0) {
            data[x++] = (char)('A' + (arc4random_uniform(26)));
        }
        else if (i%3 == 1)
        {
            data[x++] = (char)('a' + (arc4random_uniform(26)));
        }
        else
        {
            data[x++] = (char)('0' + (arc4random_uniform(10)));
        }
        
    }
    
    return [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding];
    
}


#pragma mark String2Date
- (NSString *)getYYMMDDFWW
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale * gregorianLocale = [[NSLocale alloc] initWithLocaleIdentifier:NSCalendarIdentifierGregorian];
    [dateFormatter setLocale:gregorianLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *searchDate = [dateFormatter dateFromString:self];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger weekday = [gregorianCalendar ordinalityOfUnit:
                          NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:searchDate];
    NSString *defaultDateText  = [NSString stringWithFormat:@"%@ %@", self, [Utility getFullWeekend:weekday]];
    return defaultDateText;
}

//隐藏替换部分
- (NSString *)getHidenPartString
{
    NSRange range = NSMakeRange(3, 4);
    if ([self length] < (range.location+range.length))
    {
        return self;
    }
    else
    {
        return  [self stringByReplacingCharactersInRange:range withString:@"****"];
    }
}

+ (NSString *)hashString:(NSString *)data withSalt:(NSString *)salt
{
    if (![data isStringSafe] || ![salt isStringSafe])
    {
        return nil;
    }
    
    const char *cKey  = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    return hash;
}

- (BOOL)isStringSafe
{
    return [self length] > 0;
}

#pragma mark Trim Space
- (NSString *)trimSpaceString
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark 适配函数
- (CGSize)sizeWithFontCompatible:(UIFont *)font
{
    if([self respondsToSelector:@selector(sizeWithAttributes:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGSize stringSize = [self sizeWithAttributes:dictionaryAttributes];
        return CGSizeMake(ceil(stringSize.width), ceil(stringSize.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self sizeWithFont:font];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,};
		
        CGRect stringRect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                               options:NSStringDrawingTruncatesLastVisibleLine
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        CGFloat widthResult = stringRect.size.width;
        if(widthResult - width >= 0.0000001)
        {
            widthResult = width;
        }
        
        return CGSizeMake(widthResult, ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self sizeWithFont:font forWidth:width lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size
{
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGRect stringRect = [self boundingRectWithSize:size
											   options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self sizeWithFont:font constrainedToSize:size];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,};
        CGRect stringRect = [self boundingRectWithSize:size
											   options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}

- (void)drawAtPointCompatible:(CGPoint)point withFont:(UIFont *)font
{
    if([self respondsToSelector:@selector(drawAtPoint:withAttributes:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        [self drawAtPoint:point withAttributes:dictionaryAttributes];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		[self drawAtPoint:point withFont:font];
#pragma clang diagnostic pop
    }
}

- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font
{
    if([self respondsToSelector:@selector(drawWithRect:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        [self drawWithRect:rect
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:dictionaryAttributes
                   context:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		[self drawInRect:rect withFont:font];
#pragma clang diagnostic pop
    }
}

- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    if([self respondsToSelector:@selector(drawWithRect:options:attributes:context:)] == YES)
    {
		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		[paragraphStyle setAlignment:alignment];
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,
											   NSParagraphStyleAttributeName:paragraphStyle};
        [self drawWithRect:rect
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:dictionaryAttributes
                   context:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		[self drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
#pragma clang diagnostic pop
    }
}

@end
