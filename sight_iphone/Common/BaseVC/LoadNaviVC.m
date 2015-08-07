//
//  LoadNaviVC.m
//  QunariPhone
//
//  Created by Neo on 3/14/13.
//  Copyright (c) 2013 Qunar.com. All rights reserved.
//

#import "LoadNaviVC.h"
 

@interface LoadNaviVC ()

@property (nonatomic, weak) UIView* viewParent;

@end

@implementation LoadNaviVC

- (void)dealloc
{
    // 停止搜索
    if(urlConnectionLoading != nil)
    {
        [urlConnectionLoading cancel];
    }
    
}

// 布局默认的根View
- (void)layoutRootViewDefault:(UIView *)viewParent
{
    self.viewParent = viewParent;
    
	CGRect parentFrame = [viewParent frame];
	
    // 子窗口
    NSInteger spaceYStart = 0;
    
    // =======================================================================
    // NaviBar
    // =======================================================================
	[self layoutNaviBarDefault:viewParent];
	
	// 调整
    spaceYStart += [naviBar frame].size.height;
    
    // =======================================================================
	// LoadView
	// =======================================================================
	loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
                                                                parentFrame.size.height - spaceYStart)];
	[viewParent addSubview:loadingView];
    
    // =======================================================================
    // ErrorView
    // =======================================================================
    errorView = [[ErrorView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
                                                            parentFrame.size.height - spaceYStart)
                                           title:@"获取数据失败"
                                         message:@"请检查一下：网络是否通畅?"
                                      buttonText:@"重试"];
    [errorView setDelegate:self];
    [errorView setHidden:YES];
	[viewParent addSubview:errorView];
    
    // =======================================================================
	// Content View
	// =======================================================================
    viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
                                                           parentFrame.size.height - spaceYStart)];
    [viewContent setHidden:YES];
    [viewParent addSubview:viewContent];
}


// 修改上面的方法，把loadingView和errorView限制在viewContent范围
- (void)layoutRootViewDefault:(UIView *)viewParent viewContent:(UIView*)_viewContent
{
    self.viewParent = viewParent;
    viewContent = _viewContent;
    
    CGRect parentFrame = [viewParent frame];
    
    // 子窗口
    
    // =======================================================================
    // NaviBar
    // =======================================================================
    [self layoutNaviBarDefault:viewParent];
    
    // 调整
    NSInteger spaceYStart = MAX(viewContent.top, [naviBar frame].size.height);
    
    // =======================================================================
    // LoadView
    // =======================================================================
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
                                                                parentFrame.size.height - spaceYStart)];
    [viewParent addSubview:loadingView];
    
    // =======================================================================
    // ErrorView
    // =======================================================================
    errorView = [[ErrorView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
                                                            parentFrame.size.height - spaceYStart)
                                           title:@"获取数据失败"
                                         message:@"请检查一下：网络是否通畅?"
                                      buttonText:@"重试"];
    [errorView setDelegate:self];
    [errorView setHidden:YES];
    [viewParent addSubview:errorView];
    
    // =======================================================================
    // Content View
    // =======================================================================
    [viewContent setHidden:YES];
}

// 获取Bar
- (NaviBar *)naviBar
{
	return naviBar;
}

- (LoadingView *)loadingView
{
    return loadingView;
}

- (ErrorView *)errorView
{
    return errorView;
}

- (UIView *)viewContent
{
    return viewContent;
}

// 切换状态
- (void)startLoading
{
    [loadingView startAnimating];
    [loadingView setHidden:NO];
    [errorView setHidden:YES];
    [viewContent setHidden:YES];
}

- (void)stopLoading:(BOOL)isSuccessed
{
    [loadingView stopAnimating];
    
    if(isSuccessed)
    {
        [loadingView setHidden:YES];
        [errorView setHidden:YES];
        [viewContent setHidden:NO];
    }
    else
    {
        [loadingView setHidden:YES];
        [errorView setHidden:NO];
        [viewContent setHidden:YES];
    }
}

// =======================================================================
// ErrorViewPtc
// =======================================================================
- (void)pressButtonInErrorView:(ErrorView *)errorView
{
    // do nothing
}

- (void)setErrorMessage:(NSString*)message {
    CGRect frame = errorView.frame;
    [errorView removeFromSuperview];
    errorView = [[ErrorView alloc] initWithFrame:frame
                                           title:@"获取数据失败"
                                         message:message
                                      buttonText:nil];
    [errorView setDelegate:self];
    [errorView setHidden:YES];
    
    [self.viewParent addSubview:errorView];
}

@end
