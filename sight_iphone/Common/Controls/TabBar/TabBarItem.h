//
//  TabBarItem.h
//  QunariPhone
//
//  Created by Neo on 11/26/12.
//  Copyright (c) 2012 Qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// 需要重载的接口(因为交叉引用的关系，拿出来放在单独的文件中)
@protocol TabBarItemPtc <NSObject>

- (CGSize)perfectSize;						// 获取最佳Size
- (void)setFrame:(CGRect)frameNew;			// 设置Frame
- (void)setSelected:(BOOL)isSelected;		// 设置选中

@optional

- (void)setIsLast:(NSNumber *)isLastNew;	// 是否为最后一个

@end

// 基类
@interface TabBarItem : UIControl
{
	BOOL isSelected;				// 是否选中
	BOOL isDisabled;				// 是否禁用
}

// 设置属性
- (void)setDisabled:(BOOL)isDisabledNew;

@end
