//
//  UILabel+Utility.h
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utility)

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText;

// 创建Label
- (id)initWithFont:(UIFont *)initFont andTag:(NSInteger)initTag;

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andTag:(NSInteger)initTag;

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor;

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor andTag:(NSInteger)initTag;

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode andTag:(NSInteger)initTag;

// 适配函数
- (void)setMinimumFontSizeCompatible:(CGFloat)minFontSize;

@end
