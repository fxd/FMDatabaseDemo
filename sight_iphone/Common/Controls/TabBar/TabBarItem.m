//
//  TabBarItem.m
//  QunariPhone
//
//  Created by Neo on 11/26/12.
//  Copyright (c) 2012 Qunar.com. All rights reserved.
//

#import "TabBarItem.h"

@interface TabBarItem ()

// 布局
- (void)reLayout;

@end

@implementation TabBarItem

// 设置是否选中
- (void)setSelected:(BOOL)isSelectedNew
{
	if(isSelected != isSelectedNew)
	{
		isSelected = isSelectedNew;
		
		// 刷新
		[self reLayout];
	}
}

// 设置是否禁用
- (void)setDisabled:(BOOL)isDisabledNew
{
	if(isDisabled != isDisabledNew)
	{
		isDisabled = isDisabledNew;
		
		// 禁用控件
		[super setEnabled:!isDisabledNew];
		
		// 刷新
		[self reLayout];
	}
}

// 布局
- (void)reLayout
{
	// 需要重载
}

@end
