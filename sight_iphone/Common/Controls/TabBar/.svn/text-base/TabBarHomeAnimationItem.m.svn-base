//
//  TabBarHomeAnimationItem.m
//  QunariPhone
//
//  Created by 姜琢 on 13-10-23.
//  Copyright (c) 2013年 Qunar.com. All rights reserved.
//

#import "TabBarHomeAnimationItem.h"
#import "NSString+Utility.h"
 
// ==================================================================
// 布局参数
// ==================================================================
// 尺寸
#define kTabBarHomeItemIconImageViewWidth           36
#define kTabBarHomeItemIconImageViewHeight          36
#define kTabBarHomeItemIconImageHeight              36
#define kTabBarHomeItemIconTextViewHeight           15

// 间距
#define kTabBarHomeItemSelfHMargin                  12

// 字体
#define kTabBarHomeItemLargeTextLabelFont           kCurNormalFontOfSize(14)
#define kTabBarHomeItemSmallTextLabelFont           kCurNormalFontOfSize(10)

// 颜色
#define kTabBarHomeItemLabelDisableColor            [UIColor colorWithHex:0x555555 alpha:1.0f]
#define kTabBarHomeItemLabelNormalColor             [UIColor colorWithHex:0x555555 alpha:1.0f]
#define kTabBarHomeItemLabelSelectColor             [UIColor colorWithHex:0x1ba9ba alpha:1.0f]

@interface TabBarHomeAnimationItem ()

// 布局
- (void)reLayout;

@end

@implementation TabBarHomeAnimationItem

- (void)dealloc
{
    if([imageViewIcon isAnimating] == YES)
    {
        [imageViewIcon stopAnimating];
    }
}

// 初始化
- (id)initWithText:(NSString *)textInit
		 andImages:(NSArray *)arrayImage
   andSelectImages:(NSArray *)arrayImageSelect
{
	return [self initWithText:textInit andImages:arrayImage andSelectImages:arrayImageSelect andDisableImages:arrayImage];
}

- (id)initWithText:(NSString *)textInit
		 andImages:(NSArray *)arrayImage
   andSelectImages:(NSArray *)arrayImageSelect
  andDisableImages:(NSArray *)arrayImageDisable
{
    if((textInit != nil) || ((arrayImage != nil) && ([arrayImage count] > 0)))
	{
		if((self = [super initWithFrame:CGRectZero]) != nil)
		{
			// Icon
			imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
			[self addSubview:imageViewIcon];
			
			// Label
			labelText = [[UILabel alloc] initWithFrame:CGRectZero];
			[labelText setBackgroundColor:[UIColor clearColor]];
			[labelText setText:textInit];
			
			// 字体
			if(arrayImage == nil)
			{
				[labelText setFont:kTabBarHomeItemLargeTextLabelFont];
			}
			else
			{
				[labelText setFont:kTabBarHomeItemSmallTextLabelFont];
			}
			
			[self addSubview:labelText];
			
			// images
			_animationImages = arrayImage;
			_highlightedAnimationImages = arrayImageSelect;
            _disabledAnimationImages = arrayImageDisable;
			text = textInit;
			
			// 属性
			isSelected = NO;
		}
		
		return self;
	}
	
	return nil;
}

// 设置Frame
- (void)setFrame:(CGRect)frameNew
{
	[super setFrame:frameNew];
	
	// 刷新
	[self reLayout];
}

// 获取最佳Size
- (CGSize)perfectSize
{
	NSInteger perfectWidth = 0;
	NSInteger perfectHeight = 0;
	
	// Icon
	if(imageViewIcon != nil)
	{
		if(_animationImages != nil)
		{
			NSInteger iconWidth = kTabBarHomeItemIconImageViewWidth + 2 * kTabBarHomeItemSelfHMargin;
			if(iconWidth > perfectWidth)
			{
				perfectWidth = iconWidth;
			}
			
			perfectHeight += kTabBarHomeItemIconImageViewHeight;
		}
	}
	
	// text
	if(labelText != nil)
	{
		if(text != nil)
		{
			// 计算字体
			UIFont *titleFont = [labelText font];
			CGSize titleSize = [text sizeWithFontCompatible:titleFont];
			NSInteger textWidth = titleSize.width + 2 * kTabBarHomeItemSelfHMargin;
			if(textWidth > perfectWidth)
			{
				perfectWidth = textWidth;
			}
			
			perfectHeight += kTabBarHomeItemIconTextViewHeight;
		}
	}
	
	return CGSizeMake(perfectWidth, perfectHeight);
}

// 布局
- (void)reLayout
{
	// 获取Frame
	CGRect selfFrame = [self frame];
	
	// 辅助计算值
	NSInteger imageViewHeight = 0;
	
	// Icon
	if(imageViewIcon != nil)
	{
		if(_animationImages != nil)
		{
			[imageViewIcon setFrame:CGRectMake((NSInteger)(selfFrame.size.width - kTabBarHomeItemIconImageViewWidth) / 2, (kTabBarHomeItemIconImageViewHeight - kTabBarHomeItemIconImageHeight) / 2,
											   kTabBarHomeItemIconImageViewWidth, kTabBarHomeItemIconImageHeight)];
			[imageViewIcon setHidden:NO];
            
            // 防止动画中途被中断没有图像
            if([_animationImages count] > 0)
            {
                [imageViewIcon setImage:[_animationImages objectAtIndex:0]];
            }
			
			// 设置图片
			if((isSelected) && (_highlightedAnimationImages != nil))
			{
                if([imageViewIcon isAnimating] == YES)
                {
                    [imageViewIcon stopAnimating];
                }
                
				[imageViewIcon setAnimationImages:_highlightedAnimationImages];
                [imageViewIcon setAnimationDuration:2.8f];
                [imageViewIcon startAnimating];
			}
			else
			{
                if(isDisabled)
                {
                    if([imageViewIcon isAnimating] == YES)
                    {
                        [imageViewIcon stopAnimating];
                    }
                    
                    [imageViewIcon setAnimationImages:_disabledAnimationImages];
                    [imageViewIcon setAnimationDuration:2.8f];
                    [imageViewIcon startAnimating];
                }
                else
                {
                    if([imageViewIcon isAnimating] == YES)
                    {
                        [imageViewIcon stopAnimating];
                    }
                    
                    [imageViewIcon setAnimationImages:_animationImages];
                    [imageViewIcon setAnimationDuration:2.8f];
                    [imageViewIcon startAnimating];
                }
			}
			
			// 计算高度
			imageViewHeight = kTabBarHomeItemIconImageViewHeight;
		}
		else
		{
			[imageViewIcon setHidden:YES];
		}
	}
	
	// text
	if(labelText != nil)
	{
		if(text != nil)
		{
			[labelText setHidden:NO];
			
			// 设置字体颜色
			if(isSelected)
			{
				[labelText setTextColor:kTabBarHomeItemLabelSelectColor];
			}
			else
			{
                if(isDisabled)
                {
                    [labelText setTextColor:kTabBarHomeItemLabelDisableColor];
                }
                else
                {
                    [labelText setTextColor:kTabBarHomeItemLabelNormalColor];
                }
			}
			
			// 计算字体
			UIFont *titleFont = [labelText font];
			CGSize titleSize = [text sizeWithFontCompatible:titleFont];
            if(imageViewHeight > 0)
            {
                [labelText setFrame:CGRectMake((NSInteger)(selfFrame.size.width - titleSize.width) / 2, imageViewHeight, titleSize.width, titleSize.height)];
            }
            else
            {
                [labelText setFrame:CGRectMake((NSInteger)(selfFrame.size.width - titleSize.width) / 2, (selfFrame.size.height - titleSize.height) / 2, titleSize.width, titleSize.height)];
            }
		}
		else
		{
			[labelText setHidden:YES];
		}
	}
}

@end
