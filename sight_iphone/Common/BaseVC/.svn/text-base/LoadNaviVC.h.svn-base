//
//  LoadNaviVC.h
//  QunariPhone
//
//  Created by Neo on 3/14/13.
//  Copyright (c) 2013 Qunar.com. All rights reserved.
//

#import "NaviNameVC.h"
#import "ErrorView.h"
#import "LoadingView.h"

@interface LoadNaviVC : NaviNameVC <ErrorViewPtc>
{
    LoadingView *loadingView;       // 加载View
    ErrorView *errorView;           // 错误View
    UIView *viewContent;            // 内容View

    NSURLConnection *urlConnectionLoading; // 网络请求
}

// 布局默认的根View
- (void)layoutRootViewDefault:(UIView *)viewParent;
// 修改上面的方法，把loadingView和errorView限制在viewContent范围
- (void)layoutRootViewDefault:(UIView *)viewParent viewContent:(UIView*)_viewContent;

// 获取相关属性
- (NaviBar *)naviBar;
- (LoadingView *)loadingView;
- (ErrorView *)errorView;
- (UIView *)viewContent;

// 切换状态
- (void)startLoading;
- (void)stopLoading:(BOOL)isSuccessed;

// 设置属性
- (void)setErrorMessage:(NSString*)message;

@end
