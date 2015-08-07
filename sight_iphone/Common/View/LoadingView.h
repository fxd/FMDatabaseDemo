//
//  LoadView.h
//  QunariPhone
//
//  Created by 姜琢 on 12-12-13.
//  Copyright (c) 2012年 Qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property (nonatomic, assign) CGFloat offset;			// load显示距顶边的距离
@property (nonatomic, strong) NSString *text;			// loadView上的Loading文案
@property (nonatomic, assign) BOOL hidesWhenStopped;	// 默认为YES. 调用 -setHidden 时停止动画, 同UIActivityIndicatorView

// 指定Frame的初始化方法
- (id)initWithFrame:(CGRect)frame;

// 指定Frame和提示文字的初始化方法
- (id)initWithFrame:(CGRect)frame andText:(NSString *)text;

// 设置提示文字
- (void)setText:(NSString *)text;

// 用法同UIActivityIndicatorView
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
