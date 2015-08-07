//
//  UILabel+Utility.m
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import "UILabel+Utility.h"
 #import "NSString+Utility.h"

#define kUILabelDefaultTextColor kUIColorOfHex(0x333333)

@implementation UILabel (Utility)

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText
{
	if((self = [self initWithFrame:CGRectZero]) != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
		[self setTextColor:kUILabelDefaultTextColor];
		[self setFont:initFont];
		[self setText:initText];
        CGSize labelSize = [initText sizeWithAttributes:@{NSFontAttributeName: initFont}];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
	}
	
	return self;
}

// 创建Label
- (id)initWithFont:(UIFont *)initFont andTag:(NSInteger)initTag
{
	if((self = [self initWithFrame:CGRectZero]) != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
		[self setTextColor:kUILabelDefaultTextColor];
		[self setFont:initFont];
		[self setTag:initTag];
	}
	
	return self;
}

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andTag:(NSInteger)initTag
{
	if((self = [self initWithFrame:CGRectZero]) != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
		[self setTextColor:kUILabelDefaultTextColor];
		[self setFont:initFont];
		[self setText:initText];
		[self setTag:initTag];
        CGSize labelSize = [initText sizeWithAttributes:@{NSFontAttributeName: initFont}];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
	}
	
	return self;
}

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor
{
    if((self = [self initWithFrame:CGRectZero]) != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
		[self setTextColor:kUILabelDefaultTextColor];
		[self setFont:initFont];
		[self setText:initText];
        [self setTextColor:textColor];
        CGSize labelSize = [initText sizeWithAttributes:@{NSFontAttributeName: initFont}];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
	}
	
	return self;
}

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor andTag:(NSInteger)initTag
{
    if((self = [self initWithFrame:CGRectZero]) != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
		[self setTextColor:kUILabelDefaultTextColor];
		[self setFont:initFont];
		[self setText:initText];
		[self setTag:initTag];
        [self setTextColor:textColor];
        CGSize labelSize = [initText sizeWithAttributes:@{NSFontAttributeName: initFont}];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
	}
	
	return self;
}

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if((self = [self initWithFrame:CGRectZero]) != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
		[self setTextColor:kUILabelDefaultTextColor];
		[self setFont:initFont];
		[self setText:initText];
        [self setTextColor:textColor];
        [self setNumberOfLines:0];
        [self setLineBreakMode:lineBreakMode];
        CGSize labelSize = [initText sizeWithFontCompatible:initFont constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
	}
	
	return self;
}

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode andTag:(NSInteger)initTag
{
    if((self = [self initWithFrame:CGRectZero]) != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
		[self setTextColor:kUILabelDefaultTextColor];
		[self setFont:initFont];
		[self setText:initText];
        [self setTextColor:textColor];
        [self setNumberOfLines:0];
        [self setTag:initTag];
        [self setLineBreakMode:lineBreakMode];
        CGSize labelSize = [initText sizeWithFontCompatible:initFont constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
	}
	
	return self;
}

- (void)setMinimumFontSizeCompatible:(CGFloat)minFontSize
{
    if([self respondsToSelector:@selector(setMinimumScaleFactor:)] == YES)
    {
        CGFloat fontSize = self.font.pointSize;
        CGFloat fontScale = minFontSize / fontSize;
        [self setMinimumScaleFactor:fontScale];
    }
    else
    {
        
        SEL selector = @selector(setMinimumFontSize:);
        NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        [invocation setArgument:&minFontSize atIndex:2];
        [invocation retainArguments];
        [invocation invoke];
    }
}

@end
