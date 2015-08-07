//
//  UIAlertView+Utility.h
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Utility)

// 显示对话框
+ (void)showAlertView:(NSString *)title message:(NSString *)message delgt:(id)delgt cancelTitle:(NSString *)cancelTitle otherTilte:(NSString *)otherTitle;

// 显示对话框
+ (void)showAlertView:(NSString *)title message:(NSString *)message delgt:(id)delgt cancelTitle:(NSString *)cancelTitle otherTilte:(NSString *)otherTitle andTag:(NSInteger)initTag;

// 显示网络请求失败对话框
+ (void)showNetworkErrorAlertView;

// 显示可变按钮数量的对话框
+ (void)showAlertView:(NSString *)title message:(NSString *)message delgt:(id)delgt withArrayTitle:(NSArray *)arrayTitle andTag:(NSInteger)initTag;

// 创建单例对话框
- (id)initSingleWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
