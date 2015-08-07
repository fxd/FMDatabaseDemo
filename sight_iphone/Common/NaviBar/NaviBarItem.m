//
//  BarButton.m
//  QunarIphone
//
//  Created by Neo on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NaviBarItem.h"
#import "SUIButton.h"
#import "NSString+Utility.h"
 
// 状态
typedef enum
{
	eNaviBarItemTypeImage,		// 图片按钮
	eNaviBarItemTypeText,		// 文本按钮
	eNaviBarItemTypeBack,		// 返回按钮
	eNaviBarItemTypeClose,		// 关闭按钮
	eNaviBarItemTypeEmptyRight,	// 空右边按钮
} NaviBarItemType;

// ==================================================================
// 布局参数
// ==================================================================
// 控件尺寸
#define	kNaviBarItemHeight					44
#define kNaviBarItemBackWidth				50
#define kNaviBarItemCloseWidth				44
#define kNaviBarItemEmptyLeftWidth			50
#define kNaviBarItemEmptyRightWidth			50

// 控件间距
#define	kNaviBarItemHMargin					6

// 控件字体
#define	kNaviBarItemFont					kCurNormalFontOfSize(16)
// 控件颜色
#define kNaviBarTextButtonNormalColor       [UIColor colorWithHex:(0x77ffff) alpha:1.0]
#define kNaviBarTextButtonPressColor        [UIColor colorWithHex:(0x77ffff) alpha:0.5]
#define kNaviBarTextButtonDisableColor      [UIColor colorWithHex:(0x77ffff) alpha:0.5]

@interface NaviBarItem ()

@property (nonatomic, strong) UIButton *button;			// 按钮
@property (nonatomic, assign) NaviBarItemType type;		// 类型

@end

// ==================================================================
// 实现
// ==================================================================
@implementation NaviBarItem

// 创建BarItem
- (NaviBarItem *)initImageItem:(CGRect)frameInit target:(id)target action:(SEL)action
{
	if((self = [super initWithFrame:frameInit]) != nil)
	{
		// 创建Button
		_button = [[SUIButton alloc] init];
		[_button setFrame:CGRectMake(0, 0, frameInit.size.width, frameInit.size.height)];
		[_button setExclusiveTouch:YES];
		
		// 事件处理
		if((target != nil) && (action != NULL))
		{
			[_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		}
		else
		{
			[_button setEnabled:NO];
		}
		
		// 保存
		[self addSubview:_button];
		
		// 类型
		_type = eNaviBarItemTypeImage;
		
		return self;
	}
	
	return nil;
}

// 创建BarItem
- (NaviBarItem *)initTextItem:(NSString *)title target:(id)target action:(SEL)action
{
	if((self = [super initWithFrame:CGRectZero]) != nil)
	{
		// 计算字符串尺寸
		CGSize titleSize = [title sizeWithFontCompatible:kNaviBarItemFont];
		
		// 设置自己的尺寸
		NSInteger selfWidth = titleSize.width + 2 * kNaviBarItemHMargin;
		NSInteger selfHeight = kNaviBarItemHeight;
		[self setFrame:CGRectMake(0, 0, selfWidth, selfHeight)];
		
		// 创建Button
		_button = [[SUIButton alloc] init];
		[_button setFrame:CGRectMake(0, 0, selfWidth, selfHeight)];
		[[_button titleLabel] setFont:kNaviBarItemFont];
		[_button setTitle:title forState:UIControlStateNormal];
		[_button setTitleColor:kNaviBarTextButtonNormalColor forState:UIControlStateNormal];
        [_button setTitleColor:kNaviBarTextButtonPressColor forState:UIControlStateHighlighted];
		[_button setTitleColor:kNaviBarTextButtonDisableColor forState:UIControlStateDisabled];
		[_button setExclusiveTouch:YES];
		
		// 事件处理
		if((target != nil) && (action != NULL))
		{
			[_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		}
		else
		{
			[_button setEnabled:NO];
		}
		
		// 保存
		[self addSubview:_button];
		
		// 类型
		_type = eNaviBarItemTypeText;
		
		return self;
	}
	
	return nil;
}

// 创建EmptyRightBarItem
- (NaviBarItem *)initEmptyRightItem:(id)target action:(SEL)action
{
	if((self = [self initImageItem:CGRectMake(0, 0, kNaviBarItemEmptyRightWidth, kNaviBarItemHeight)
							target:target
							action:action]) != nil)
	{
		// 设置Button的背景图片
        [_button setBackgroundColor:[UIColor clearColor]];
		
		// 类型
		_type = eNaviBarItemTypeEmptyRight;
		
		return self;
	}
	
	return nil;
}

// 创建BackBarItem
- (NaviBarItem *)initBackItem:(id)target action:(SEL)action
{
	if((self = [self initImageItem:CGRectMake(0, 0, kNaviBarItemBackWidth, kNaviBarItemHeight)
							target:target
							action:action]) != nil)
	{
		// 设置Button的背景图片
		[_button setImage:[UIImage imageNamed:kNaviBackBarButtonNormalImageFile] forState:UIControlStateNormal];
		[_button setImage:[UIImage imageNamed:kNaviBackBarButtonHighlightedImageFile] forState:UIControlStateHighlighted];
		[_button setImage:[UIImage imageNamed:kNaviBackBarButtonDisableImageFile] forState:UIControlStateDisabled];
		
		// 类型
		_type = eNaviBarItemTypeBack;
		
		return self;
	}
	
	return nil;
}

// 创建CloseBarItem
- (NaviBarItem *)initCloseItem:(id)target action:(SEL)action
{
	if((self = [self initImageItem:CGRectMake(0, 0, kNaviBarItemCloseWidth, kNaviBarItemHeight)
							target:target
							action:action]) != nil)
	{
		// 设置Button的背景图片
		[_button setBackgroundImage:[UIImage imageNamed:kNaviCloseBarButtonNormalImageFile] forState:UIControlStateNormal];
		[_button setBackgroundImage:[UIImage imageNamed:kNaviCloseBarButtonHighlightedImageFile] forState:UIControlStateHighlighted];

		// 类型
		_type = eNaviBarItemTypeClose;
		
		return self;
	}
	
	return nil;
}

// 设置Frame
- (void)setFrame:(CGRect)frameNew
{
	if(_type == eNaviBarItemTypeImage)
	{
		[super setFrame:frameNew];
		[_button setFrame:CGRectMake(0, 0, frameNew.size.width, frameNew.size.height)];
	}
	else if((_type == eNaviBarItemTypeText)
			|| (_type == eNaviBarItemTypeEmptyRight)
			|| (_type == eNaviBarItemTypeBack)
			|| (_type == eNaviBarItemTypeClose))
	{
		[super setFrame:CGRectMake(frameNew.origin.x, frameNew.origin.y, [self frame].size.width, [self frame].size.height)];
	}
	else
	{
		[super setFrame:frameNew];
	}
}

// 设置文本
- (void)setTitle:(NSString *)titleNew
{
	if(_type == eNaviBarItemTypeText)
	{
		// 计算字符串尺寸
		CGSize titleSize = [titleNew sizeWithFontCompatible:kNaviBarItemFont];
			
		// 设置自己的尺寸
		NSInteger selfWidth = titleSize.width + 2 * kNaviBarItemHMargin;
		NSInteger selfHeight = kNaviBarItemHeight;
		[self setFrame:CGRectMake(0, 0, selfWidth, selfHeight)];
			
		// 设置Button
		[_button setFrame:CGRectMake(0, 0, selfWidth, selfHeight)];
		[_button setTitle:titleNew forState:UIControlStateNormal];
	}
}

// 设置背景色
- (void)setBackgroundImage:(UIImage *)image forState:(NaviBarItemState)state
{
	if(_type == eNaviBarItemTypeImage)
	{
		if(state == eNaviBarItemStateNormal)
		{
			[_button setBackgroundImage:image forState:UIControlStateNormal];
		}
		else if(state == eNaviBarItemDisable)
		{
			[_button setBackgroundImage:image forState:UIControlStateDisabled];
		}
		else if(state == eNaviBarItemStateHighlighted)
		{
			[_button setBackgroundImage:image forState:UIControlStateHighlighted];
		}
	}
}

// 设置Item是否为Disabled
- (void)setItemEnable:(BOOL)isEnable
{
	[_button setEnabled:isEnable];
}

@end
