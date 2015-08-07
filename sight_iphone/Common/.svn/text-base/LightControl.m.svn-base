//
//  Button.m
//  QunarIphone
//
//  Created by Neo on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LightControl.h"

@interface LightControl ()

@property (nonatomic, strong) UIImage *imageNormal;
@property (nonatomic, strong) UIImage *imageHighlight;
@property (nonatomic, strong) UIImage *imageDisable;

// 设置子控件高亮
- (void)setSubHighlighted:(BOOL)highlightedNew forView:(UIView *)viewParent;

// 设置子控件禁用
- (void)setSubEnabled:(BOOL)enableNew forView:(UIView *)viewParent;

@end;

@implementation LightControl


// =======================================================================
// 接口函数
// =======================================================================
// 创建
- (id)initWithFrame:(CGRect)newFrame
{
	if((self = [super initWithFrame:newFrame]) != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
		_imageNormal = nil;
		_imageHighlight	= nil;
		_imageDisable = nil;
		
		return self;
	}
	
	return nil;
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	// 刷新界面
	[self setNeedsDisplay];
}

// 设置背景image
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)stateNew
{
	if(stateNew == UIControlStateNormal)
	{
		_imageNormal = image;
		
		// 设置高亮状态下的Image
		if(_imageHighlight == nil)
		{
			_imageHighlight = image;
		}
		
		// 设置禁用状态下的Image
		if(_imageDisable == nil)
		{
			_imageDisable = image;
		}
	}
	else if(stateNew == UIControlStateHighlighted)
	{
		_imageHighlight = image;
	}
	else if(stateNew == UIControlStateDisabled)
	{
		_imageDisable = image;
	}
	
	// 刷新界面
	[self setNeedsDisplay];
}

// 设置高亮
- (void)setHighlighted:(BOOL)highlightedNew
{
	[super setHighlighted:highlightedNew];
	
	// 刷新子界面和自己的界面
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

// 设置禁用
- (void)setEnabled:(BOOL)enabledNew
{
	[super setEnabled:enabledNew];
	
	// 刷新子界面和自己的界面
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

- (void)layoutSubviews
{
	[self setSubHighlighted:[self isHighlighted] forView:self];
	[self setSubEnabled:[self isEnabled] forView:self];
}

// 绘制
- (void)drawRect:(CGRect)rect 
{
	[super drawRect:rect];
	
	// 绘制图片
	if([self isEnabled] == NO)
	{
		if(_imageDisable != nil)
		{
			[_imageDisable drawInRect:CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height)];
		}
	}
	else
	{
		if([self isHighlighted] == YES)
		{
			if(_imageHighlight != nil)
			{
				[_imageHighlight drawInRect:CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height)];
			}
		}
		else
		{
			[_imageNormal drawInRect:CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height)];
		}
	}
}

// 设置子控件高亮
- (void)setSubHighlighted:(BOOL)highlightedNew forView:(UIView *)viewParent
{
	NSArray *arrayViewSub = [viewParent subviews];
	NSInteger subCount = [arrayViewSub count];
	for(NSInteger i = 0; i < subCount; i++)
	{
		id viewSub = [arrayViewSub objectAtIndex:i];
		
		// Label
		if([viewSub isKindOfClass:[UILabel class]] == YES)
		{
			UILabel *labelSub = (UILabel *)viewSub;
			[labelSub setHighlighted:highlightedNew];
		}
		// ImageView
		else if([viewSub isKindOfClass:[UIImageView class]] == YES)
		{
			UIImageView *imageViewSub = (UIImageView *)viewSub;
			[imageViewSub setHighlighted:highlightedNew];
		}
		// UIControl
		else if([viewSub isKindOfClass:[UIControl class]] == YES)
		{
			UIControl *controlSub = (UIControl *)viewSub;
			[controlSub setHighlighted:highlightedNew];
		}
		// UIView
		else if([viewSub isKindOfClass:[UIView class]] == YES)
		{
			[self setSubHighlighted:highlightedNew forView:viewSub];
		}
	}
}

// 设置子控件禁用
- (void)setSubEnabled:(BOOL)enableNew forView:(UIView *)viewParent
{
	NSArray *arrayViewSub = [viewParent subviews];
	NSInteger subCount = [arrayViewSub count];
	for(NSInteger i = 0; i < subCount; i++)
	{
		id viewSub = [arrayViewSub objectAtIndex:i];
		
		// Label
		if([viewSub isKindOfClass:[UILabel class]] == YES)
		{
			UILabel *labelSub = (UILabel *)viewSub;
			[labelSub setEnabled:enableNew];
		}
		// UIControl
		else if([viewSub isKindOfClass:[UIControl class]] == YES)
		{
			UIControl *controlSub = (UIControl *)viewSub;
			[controlSub setEnabled:enableNew];
		}
		// UIView
		else if([viewSub isKindOfClass:[UIView class]] == YES)
		{
			[self setSubEnabled:enableNew forView:viewSub];
		}
	}
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
	[super sendAction:action to:target forEvent:event];
}

@end
