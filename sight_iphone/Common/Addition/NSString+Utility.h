//
//  NSString+Utility.h
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSString (Utility)

// URLEncoding
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

// XQueryComponents
- (NSString *)stringByDecodingURLFormat;
- (NSString *)stringByEncodingURLFormat;
- (NSDictionary *)dictionaryFromQueryComponents;
- (NSDictionary *)dictionaryFromParamComponents;    // 对于参数中不带＝的，用@“”作为参数值

// Encoding
- (NSString *)getSHA1;
- (NSString *)getMD5;

// Valid
- (BOOL)isRangeValidFromIndex:(NSInteger)index withSize:(NSInteger)rangeSize;

// get Random String
- (NSString *)getRandomStringByLength:(NSInteger)len;

// String2Date
- (NSString *)getYYMMDDFWW;

//用 ****替换部分字符
- (NSString *)getHidenPartString;

// 产生 hash code
+ (NSString *)hashString:(NSString *)data withSalt:(NSString *)salt;

- (BOOL)isStringSafe;

// Trim
- (NSString *)trimSpaceString;

// 适配函数
- (CGSize)sizeWithFontCompatible:(UIFont *)font;
- (CGSize)sizeWithFontCompatible:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (void)drawAtPointCompatible:(CGPoint)point withFont:(UIFont *)font;
- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font;
- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

@end
