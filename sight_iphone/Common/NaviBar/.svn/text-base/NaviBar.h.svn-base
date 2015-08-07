//
//  NavigationBar.h
//  QunarIphone
//
//  Created by Neo on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NaviBarItem.h"

@interface NaviBar : UIControl

@property (nonatomic, assign) BOOL isClickEnable;
@property (nonatomic, retain) NSArray *rightBarItems;

// 初始化函数
- (NaviBar *)initWithFrame:(CGRect)frameInit;

// 设置frame
- (void)setFrame:(CGRect)frameNew;

// 设置背景Color
- (void)setNaviBarBackgroundColor:(UIColor *)backgroundColor;

// Title
- (NSString *)title;
- (void)setTitle:(NSString *)titleNew;

// 获取和设置左边的Item
- (UIView *)leftBarItem;
- (void)setLeftBarItem:(UIView *)viewLeftNew;

// 获取和设置右边的Item
- (UIView *)rightBarItem;
- (void)setRightBarItem:(UIView *)viewRightNew;

// 获取和设置标题View
- (UIControl *)titleView;
- (void)setTitleView:(UIView *)viewTitleNew;

// 隐藏和显示
- (void)showLeftBarItem:(BOOL)isShow;
- (void)showTitleView:(BOOL)isShow;
- (void)showRightBarItem:(BOOL)isShow;

@end
