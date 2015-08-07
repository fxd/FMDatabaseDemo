//
//  BarButton.h
//  QunarIphone
//
//  Created by Neo on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 状态
typedef enum
{
	eNaviBarItemStateNormal,		// 普通状态
	eNaviBarItemStateHighlighted,	// 高亮状态
	eNaviBarItemDisable,			// 禁用状态
} NaviBarItemState;

// 导航栏按钮
@interface NaviBarItem : UIView

// 创建BarItem
- (NaviBarItem *)initImageItem:(CGRect)frameInit target:(id)target action:(SEL)action;

// 创建BarItem
- (NaviBarItem *)initTextItem:(NSString *)title target:(id)target action:(SEL)action;

// 创建EmptyRightBarItem
- (NaviBarItem *)initEmptyRightItem:(id)target action:(SEL)action;

// 创建BackBarItem
- (NaviBarItem *)initBackItem:(id)target action:(SEL)action;

// 创建CloseBarItem
- (NaviBarItem *)initCloseItem:(id)target action:(SEL)action;

// 设置Frame
- (void)setFrame:(CGRect)frameNew;

// 设置文本
- (void)setTitle:(NSString *)titleNew;

// 设置背景色
- (void)setBackgroundImage:(UIImage *)image forState:(NaviBarItemState)state;

// 设置Item是否为Disabled
- (void)setItemEnable:(BOOL)isEnable;

@end
