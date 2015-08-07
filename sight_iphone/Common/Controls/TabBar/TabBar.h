//
//  TabBar.h
//  QunariPhone
//
//  Created by Neo on 11/23/12.
//  Copyright (c) 2012 Qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"TabBarItem.h"

@class TabBar;

// TabBar协议
@protocol TabBarPtc <NSObject>

- (void)tabBar:(TabBar *)tabBar didSelectItem:(TabBarItem *)item;

@end

// TabBar
@interface TabBar : UIView

// 初始化
- (id)initWithFrame:(CGRect)frameInit canScroll:(BOOL)scrollable;
- (id)initWhiteWithFrame:(CGRect)frameInit canScroll:(BOOL)scrollable;
- (id)initBlueWithFrame:(CGRect)frameInit canScroll:(BOOL)scrollable;
- (id)initHomeWithFrame:(CGRect)frameInit;

// 设置Frame
- (void)setFrame:(CGRect)frameNew;

// 添加item
- (void)appendItem:(TabBarItem<TabBarItemPtc> *)item;
- (void)insertItem:(TabBarItem<TabBarItemPtc> *)item atIndex:(NSUInteger)index;

// 删除Item
- (void)removeItemAtIndex:(NSUInteger)index;
- (void)removeAllItems;

// Item
- (TabBarItem *)itemAtIndex:(NSUInteger)index;

// 选中项
- (NSInteger)selectedItemIndex;
- (void)setSelectedItemIndex:(NSInteger)index;

// 设置代理
- (void)setDelegate:(id<TabBarPtc>)delegateNew;

@end
