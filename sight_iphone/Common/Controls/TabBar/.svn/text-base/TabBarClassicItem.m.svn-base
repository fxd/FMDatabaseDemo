//
//  TabBarItem.m
//  QunariPhone
//
//  Created by Neo on 11/23/12.
//  Copyright (c) 2012 Qunar.com. All rights reserved.
//

#import "TabBarClassicItem.h"
#import "NSString+Utility.h"
 
// ==================================================================
// 布局参数
// ==================================================================
// 尺寸
#define kTabBarClassicItemIconImageViewWidth		63
#define kTabBarClassicItemIconImageViewHeight		29
#define kTabBarClassicItemIconImageHeight           23
#define kTabBarClassicItemTextViewHeight            15

// 间距
#define kTabBarClassicItemSelfHMargin				12

// 字体
#define kTabBarClassicItemLargeTextLabelFont		kCurNormalFontOfSize(14)
#define kTabBarClassicItemSmallTextLabelFont		kCurNormalFontOfSize(10)

// 颜色
#define kTabBarClassicItemLabelDisableColor         [UIColor colorWithHex:0xffffff alpha:1.0f]
#define kTabBarClassicItemLabelNormalColor			[UIColor colorWithHex:0xffffff alpha:1.0f]
#define kTabBarClassicItemLabelSelectColor			[UIColor colorWithHex:0x1ba9ba alpha:1.0f]


@interface TabBarClassicItem ()

// 布局
- (void)reLayout;

@end

@implementation TabBarClassicItem

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
				[labelText setFont:kTabBarClassicItemLargeTextLabelFont];
			}
			else
			{
				[labelText setFont:kTabBarClassicItemSmallTextLabelFont];
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
			NSInteger iconWidth = kTabBarClassicItemIconImageViewWidth + 2 * kTabBarClassicItemSelfHMargin;
			if(iconWidth > perfectWidth)
			{
				perfectWidth = iconWidth;
			}
			
			perfectHeight += kTabBarClassicItemIconImageViewHeight;
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
			NSInteger textWidth = titleSize.width + 2 * kTabBarClassicItemSelfHMargin;
			if(textWidth > perfectWidth)
			{
				perfectWidth = textWidth;
			}
			
			perfectHeight += kTabBarClassicItemTextViewHeight;
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
		if(image != nil)
		{
			[imageViewIcon setFrame:CGRectMake((NSInteger)(selfFrame.size.width - kTabBarClassicItemIconImageViewWidth) / 2, (kTabBarClassicItemIconImageViewHeight - kTabBarClassicItemIconImageHeight) / 2,
											   kTabBarClassicItemIconImageViewWidth, kTabBarClassicItemIconImageHeight)];
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
			imageViewHeight = kTabBarClassicItemIconImageViewHeight;
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
				[labelText setTextColor:kTabBarClassicItemLabelSelectColor];
			}
			else
			{
                if(isDisabled)
                {
                    [labelText setTextColor:kTabBarClassicItemLabelDisableColor];
                }
                else
                {
                    [labelText setTextColor:kTabBarClassicItemLabelNormalColor];
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
    
    // 背景色
    if(isSelected == YES)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
}

@end
