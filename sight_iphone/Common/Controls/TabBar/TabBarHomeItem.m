//
//  TabBarHomeItem.m
//  QunariPhone
//
//  Created by Neo on 4/28/13.
//  Copyright (c) 2013 Qunar.com. All rights reserved.
//

#import "TabBarHomeItem.h"
#import "NSString+Utility.h"
 
// ==================================================================
// 布局参数
// ==================================================================
// 尺寸
#define kTabBarHomeItemIconImageViewWidth           24
#define kTabBarHomeItemIconImageViewHeight          24

#define kTabBarHomeItemIconImageHeight              23
#define kTabBarHomeItemIconTextViewHeight           15

// 间距
#define kTabBarHomeItemSelfHMargin                  12

// 字体
#define kTabBarHomeItemLargeTextLabelFont           kCurNormalFontOfSize(14)
#define kTabBarHomeItemSmallTextLabelFont           kCurNormalFontOfSize(10)

// 颜色
#define kTabBarHomeItemLabelDisableColor            [UIColor qunarTextBlackColor]
#define kTabBarHomeItemLabelNormalColor             [UIColor qunarTextBlackColor]
#define kTabBarHomeItemLabelSelectColor             [UIColor qunarTextBlackColor]

@interface TabBarHomeItem ()

// 布局
- (void)reLayout;

@end

@implementation TabBarHomeItem

// 初始化
- (id)initWithText:(NSString *)textInit andImage:(UIImage *)imageInit andSelectImage:(UIImage *)imageSelectInit
{
	return [self initWithText:textInit andImage:imageInit andSelectImage:imageSelectInit andDisableImage:imageInit];
}

- (id)initWithText:(NSString *)textInit
          andImage:(UIImage *)imageInit
    andSelectImage:(UIImage *)imageSelectInit
   andDisableImage:(UIImage *)imageDisableInit
{
    if((textInit != nil) || (imageInit != nil))
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
			if(imageInit == nil)
			{
				[labelText setFont:kTabBarHomeItemLargeTextLabelFont];
			}
			else
			{
				[labelText setFont:kTabBarHomeItemSmallTextLabelFont];
			}
			
			[self addSubview:labelText];
			
			// image
			image = imageInit;
			imageSelect = imageSelectInit;
            imageDisable = imageDisableInit;
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
		if(image != nil)
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
    NSInteger offsetY = 4;
	
	// Icon
	if(imageViewIcon != nil)
	{
		if(image != nil)
		{
			[imageViewIcon setFrame:CGRectMake((NSInteger)(selfFrame.size.width - kTabBarHomeItemIconImageViewWidth) / 2,
                                               offsetY +(kTabBarHomeItemIconImageViewHeight - kTabBarHomeItemIconImageHeight) / 2,
											   kTabBarHomeItemIconImageViewWidth, kTabBarHomeItemIconImageHeight)];
			[imageViewIcon setHidden:NO];
			
			// 设置图片
			if((isSelected) && (imageSelect != nil))
			{
				[imageViewIcon setImage:imageSelect];
			}
			else
			{
                if(isDisabled)
                {
                    [imageViewIcon setImage:imageDisable];
                }
                else
                {
                    [imageViewIcon setImage:image];
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
                [labelText setFrame:CGRectMake((NSInteger)(selfFrame.size.width - titleSize.width) / 2, imageViewHeight - offsetY, titleSize.width, titleSize.height)];
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
