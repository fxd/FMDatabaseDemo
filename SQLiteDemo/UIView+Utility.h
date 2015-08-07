//
//  UIView+Utility.h
//  SQLiteDemo
//
//  Created by fengshaobo on 15/8/7.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Utility)

//  将View的左边移动到指定位置
@property (nonatomic) CGFloat left;

//  将View的顶端移动到指定位置
@property (nonatomic) CGFloat top;

//  将View的右边移动到指定位置
@property (nonatomic) CGFloat right;

//  将View的底端移动到指定位置
@property (nonatomic) CGFloat bottom;

//  更改View的宽度
@property (nonatomic) CGFloat width;

//  更改View的高度
@property (nonatomic) CGFloat height;

//  更改View的位置
@property (nonatomic) CGPoint origin;

//  更改View的尺寸
@property (nonatomic) CGSize size;

@end
