//
//  UIColor+Utility.h
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithARGB:(NSInteger)ARGBValue;

//! iPhone 4.2版本后使用，按钮和部分Label蓝色 色值：0x1ba9ba
+ (UIColor *)qunarBlueColor;

//! iPhone 4.2版本后使用，按钮点击态蓝色 色值：0x168795
+ (UIColor *)qunarBlueHighlightColor;

//! iPhone 4.2版本后使用，按钮红色 色值：0xff4500
+ (UIColor *)qunarRedColor;

//! iPhone 4.2版本后使用，按钮点击态红色 色值：0xbe3300
+ (UIColor *)qunarRedHighlightColor;

//! iPhone 4.2版本后使用，灰色 色值：0xff3300
+ (UIColor *)qunarTextRedColor;

//! iPhone 4.2版本后使用，黑色 色值：0x333333
+ (UIColor *)qunarTextBlackColor;

//! iPhone 4.2版本后使用，灰色 色值：0x888888
+ (UIColor *)qunarTextGrayColor;

//! iPhone 4.2版本后使用，边线框颜色 色值：0xc7ced4
+ (UIColor *)qunarGrayColor;

//! iPhone 4.2版本后使用，强提示黄色 色值：0xf8facd
+ (UIColor *)warningYellowColor;

//! iPhone 4.2版本后使用，很浅的背景灰色 色值：0xf2f8fb
+ (UIColor *)qunarLightGrayColor;

@end
