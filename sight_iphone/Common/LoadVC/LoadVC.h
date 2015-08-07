//
//  LoadVC.h
//  QunarIphone
//
//  Created by Neo on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNameVC.h"
#import "LoadCancelPtc.h"

@interface LoadVC : BaseNameVC

// =======================================================================
// 事件处理函数
// =======================================================================
// 取消
- (void)doCancel:(id)sender;

// =======================================================================
// 接口函数
// =======================================================================
// 加载(ctx, text如果没发生变化，就传nil)
- (void)loading:(UIViewController<LoadCancelPtc> *)vc forContext:(id)ctx withTag:(NSInteger)tag andHint:(NSString *)text andCancel:(BOOL)cancel;

- (void)loadingInWindow:(id)delegate forContext:(id)ctx withTag:(NSInteger)tag andHint:(NSString *)text andCancel:(BOOL)cancel;

- (void)loadingInPopWindow:(id)delegate forContext:(id)ctx withTag:(NSInteger)tag andHint:(NSString *)text andCancel:(BOOL)cancel;

// 设置代理
- (void)setDelegate:(UIViewController<LoadCancelPtc> *)delegateNew;

// 结束加载
- (void)endLoading;

@end
