//
//  BaseNameVC.h
//  Qunar
//
//  Created by Neo on 2/18/11.
//  Copyright 2011 qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadCancelPtc.h"

// ==================================================================
// 该类是Project中所有需要跳转的UIViewController的基类
// 它记录了VC的name,方便基于name的VC和管理
// ==================================================================
@interface BaseNameVC : UIViewController <LoadCancelPtc>

@property (nonatomic, assign) BOOL isCanGoBack;			// 界面是否支持右滑返回, 若设置该属性，则界面无法响应手势，即无法随手势移动
@property (nonatomic, assign) BOOL isCanRightPan;		// VC当前是否能够相应右滑手势

// 初始化函数
- (id)init;
- (id)initWithName:(NSString *)vcNameInit;
- (id)initWithName:(NSString *)vcNameInit andFrame:(CGRect)frameInit;

// 获取VCName
- (NSString *)getVCName;

// 加载LoadVC
- (void)startLoading:(id)Content withHint:(NSString *)hintText;
- (void)startLoadingCancel:(id)Content withHint:(NSString *)hintText;
- (void)startLoading:(id)Content withHint:(NSString *)hintText andTag:(NSInteger)tag;
- (void)startLoadingCancel:(id)Content withHint:(NSString *)hintText andTag:(NSInteger)tag;
- (void)stopLoading;

// VCController
// canDoGoBack 用来返回界面当前是否可以返回
// 子类可重载，默认返回Yes，重载时不需要调用[super canDoGoBack]
// 若该方法返回NO，则界面无法进行返回，右滑只能看到黑色背景
// 当该方法返回YES时，界面不会自动返回，需在goBack中处理界面的状态
- (BOOL)canDoGoBack;

// 手势用来判断能否进行右滑
- (BOOL)viewCanRight:(UIView *)view;

// 返回的动作
- (void)goBack:(id)sender;

@end
