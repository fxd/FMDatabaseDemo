//
//  PopNameVC.m
//  QunariPhone
//
//  Created by ding yan on 13-11-29.
//  Copyright (c) 2013年 Qunar.com. All rights reserved.
//

#import "PopNameVC.h"
#import "VCManager.h"
#import "SUIButton.h"
#import "VCAnimationClassic.h"
 

// =======================================================================
// 布局参数
// =======================================================================
// 控件尺寸
#define kPopNameVCNaviBtnWidth                              44
#define kPopNameVCNaviBtnHeight                             44
#define kPopNameVCUnEnableHeight                            140

// 边框局
#define	kPopNameVCNaviVMargin                               10

// 控件字体
#define kPopNameVCNaviTitleLabelFont                        kCurNormalFontOfSize(16)

@interface PopNameVC()
@property (nonatomic, assign) NSInteger keyboardHeight;                             // 键盘高度

@end


@implementation PopNameVC

- (void)dealloc
{
    // 注销消息
    [self unregisterNotification];
    
    [_tableViewInfo setDelegate:nil];
    [_tableViewInfo setDataSource:nil];
}

// 重载初始化函数
- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [[self view] setFrame:CGRectMake(0, 0, [self view].frame.size.width, [UIScreen mainScreen].bounds.size.height - kPopNameVCUnEnableHeight)];

    // 注册消息
    [self registerNotification];
}


// =======================================================================
#pragma mark-  事件处理函数
// =======================================================================
// 返回
- (void)goBack:(id)sender
{
    // 隐藏键盘
	[self hideKeyboard];
    
    [[VCManager ucLoginVCC] popWithAnimation:[VCAnimationClassic defaultAnimation]];
}

// 关闭当前窗体
- (void)closeButtonClick:(id)sender
{
    // 隐藏键盘
	[self hideKeyboard];
    
    [VCManager ucLoginDismiss];
}

// =======================================================================
#pragma mark-  辅助函数
// =======================================================================
// 注册消息
- (void)registerNotification
{
	// 键盘显示消息
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	// 键盘隐藏消息
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

// 注销消息
- (void)unregisterNotification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// 键盘显示
- (void)keyboardDidShow:(NSNotification *)notification
{
	NSValue *frameEnd = nil;
    
    frameEnd = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSInteger keyboardHeight = 0;
    
    // 3.2以后的版本
    if(frameEnd != nil)
    {
        // 键盘的Frame
        CGRect keyBoardFrame;
        [frameEnd getValue:&keyBoardFrame];
        
        // 保存键盘的高度
        keyboardHeight = keyBoardFrame.size.height;
    }
    else
    {
        // 保存键盘的高度
        keyboardHeight = 216;
    }
    
    // 修正table的高度
    if (_keyboardHeight == 0)
    {
        [_tableViewInfo setViewHeight:([_tableViewInfo frame].size.height - keyboardHeight)];
    }
    else
    {
        [_tableViewInfo setViewHeight:([_tableViewInfo frame].size.height + _keyboardHeight - keyboardHeight)];
    }
    
    // 保存键盘的高度
    _keyboardHeight = keyboardHeight;
    
    // 获取FirstResponser
    UIView *firstResponser = [self getCurResponser:_tableViewInfo];
    if(firstResponser != nil)
    {
        if(([firstResponser isKindOfClass:[UITextField class]] == YES) || ([firstResponser isKindOfClass:[UITextView class]] == YES))
        {
            [self scrollInputView:firstResponser];
        }
    }
    
}

// 键盘消失
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (_keyboardHeight > 0)
    {
        [_tableViewInfo setViewHeight:([_tableViewInfo frame].size.height  + _keyboardHeight)];
        
    }
    _keyboardHeight = 0;
}

// 滚动输入View
- (void)scrollInputView:(UIView *)viewFocus
{
	// 计算输入框底部在VCView中的Y坐标
	CGPoint topPointInTable = [viewFocus convertPoint:CGPointZero toView:_tableViewInfo];
	CGPoint bottomPointInFocus = CGPointMake(0, [viewFocus frame].size.height);
	CGPoint bottomPointInView = [viewFocus convertPoint:bottomPointInFocus toView:[self view]];
	
	// 键盘的顶部在VCView中的坐标
	CGRect viewFrame = [[self view] frame];
	NSInteger keyboardYInView = viewFrame.size.height - _keyboardHeight;
	
	// 获取TableView的Offset
	CGPoint tableViewInfoOffset = [_tableViewInfo contentOffset];
	
	// 该坐标的位置被键盘遮盖
	if(bottomPointInView.y > keyboardYInView)
	{
		// 滚动Content View
		[UIView animateWithDuration:0.3
							  delay:0.0f
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [_tableViewInfo setContentOffset:CGPointMake(tableViewInfoOffset.x, tableViewInfoOffset.y + bottomPointInView.y - keyboardYInView)];
						 }
						 completion:nil];
	}
	// 顶部被TableView遮盖
	else if(topPointInTable.y < tableViewInfoOffset.y)
	{
		// 滚动Content View
		[UIView animateWithDuration:0.3
							  delay:0.0f
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [_tableViewInfo setContentOffset:CGPointMake(tableViewInfoOffset.x, topPointInTable.y)];
						 }
						 completion:nil];
	}
}

// 获取当前的responser
- (UIView *)getCurResponser:(UIView *)rootView
{
    return nil;
}

// 隐藏键盘
- (void)hideKeyboard
{
	UIView *viewFirstResponser = [self getCurResponser:_tableViewInfo];
	if(viewFirstResponser != nil)
	{
		if(([viewFirstResponser isKindOfClass:[UITextField class]] == YES) || ([viewFirstResponser isKindOfClass:[UITextView class]] == YES))
		{
			[viewFirstResponser resignFirstResponder];
		}
	}
}

- (void)startLoadingCancel:(id)Content withHint:(NSString *)hintText
{
    
    if(_loadVC == nil)
	{
		// 创建LoadVC
		_loadVC = [[LoadVC alloc] init];
	}
	
	[_loadVC loadingInPopWindow:self forContext:Content withTag:0 andHint:hintText andCancel:YES];
}

- (void)stopLoading
{
    [_loadVC endLoading];
}

// =======================================================================
#pragma mark-  布局函数
// =======================================================================
// 布局默认的根View
- (void)layoutRootViewDefault:(UIView *)viewParent
{
	// 父窗口属性
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口属性
    NSInteger spaceXStart = 0;
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    
    // =======================================================================
    // 创建Nav View
    // =======================================================================
    UIView *viewNaviBar = [[UIView alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, parentFrame.size.width, 0)];
    
    // 创建NavigationBar
    [self setupNaviBarSubs:viewNaviBar];
    
    [viewParent addSubview:viewNaviBar];
    
    // 调整子窗体尺寸
    spaceYStart += viewNaviBar.frame.size.height;
    
    // =======================================================================
    // 创建ContentInfo View
    // =======================================================================
    UIView *viewContentInfo = [[UIView alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, parentFrame.size.width, spaceYEnd - spaceYStart)];
    
    // 设置Content
    [self setupViewContentSubs:viewContentInfo];
    
    [viewParent addSubview:viewContentInfo];
}

// 创建NavigationBar的子界面
- (void)setupNaviBarSubs:(UIView *)viewParent
{
    // 子窗口高宽
    CGRect parentFrame = viewParent.frame;
    
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger subsHeight = 0;
    
	// 左侧窗体尺寸
    CGSize backBtnSize = CGSizeMake(kPopNameVCNaviBtnWidth, kPopNameVCNaviBtnHeight);
    if([[[VCManager ucLoginVCC] arrayVCSubs] count] > 0)
    {
        SUIButton *btnLeft = [SUIButton buttonWithType:UIButtonTypeCustom];
        [btnLeft setFrame:CGRectMake(0, 0, backBtnSize.width, backBtnSize.height)];
        [btnLeft setImage:[UIImage imageNamed:kModalVCBackImage] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [btnLeft setExclusiveTouch:YES];
        [viewParent addSubview:btnLeft];
    }
    
    // 调整子窗体尺寸
    spaceXStart += backBtnSize.width;
    if(subsHeight < backBtnSize.height)
    {
        subsHeight = backBtnSize.height;
    }
    
    // 创建关闭图标
    CGSize imageViewCloseSize = CGSizeMake(kPopNameVCNaviBtnWidth, kPopNameVCNaviBtnHeight);
    SUIButton *btnClose = [SUIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setImage:[UIImage imageNamed:kModalVCCloseImage] forState:UIControlStateNormal];
    [btnClose setFrame:CGRectMake(spaceXEnd - imageViewCloseSize.width, 0, imageViewCloseSize.width, imageViewCloseSize.height)];
    [btnClose addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:btnClose];
    
    // 调整子窗体尺寸
    spaceXEnd -= imageViewCloseSize.width;
    if(subsHeight < imageViewCloseSize.height)
    {
        subsHeight = imageViewCloseSize.height;
    }
    
    UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(spaceXStart, kPopNameVCNaviVMargin, spaceXEnd - spaceXStart, 0)];
    
    // 创建子视图
    [self setupNaviBarTitleSubs:viewTitle];
    
    // 保存
    [viewParent addSubview:viewTitle];
    
    if(subsHeight < viewTitle.frame.size.height)
    {
        subsHeight = viewTitle.frame.size.height;
    }
    
    // =======================================================================
    // 设置父窗口尺寸
    // =======================================================================
    [viewParent setViewHeight:subsHeight];
}

// =======================================================================
// 以下两个函数根据个业务定制
// =======================================================================
// 创建NavigationBar的子界面
- (void)setupNaviBarTitleSubs:(UIView *)viewParent
{
}

// 创建Root View的子界面
- (void)setupViewContentSubs:(UIView *)viewParent
{
    //父窗口属性
    CGRect parentFrame = [viewParent frame];
    
    //子窗口高宽
    NSInteger spaceYStart = 0;
	
    // =======================================================================
    // TableView
    // =======================================================================
    _tableViewInfo = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_tableViewInfo setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, parentFrame.size.height - spaceYStart)];
    [_tableViewInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_tableViewInfo setSeparatorColor:[UIColor clearColor]];

    
    //设置TableView的背景色
    if([_tableViewInfo respondsToSelector:@selector(setBackgroundView:)] == YES)
	{
        // 3.2以后的版本
		UIView *viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
		[_tableViewInfo setBackgroundView:viewBackground];
    }
    
    [_tableViewInfo setBackgroundColor:[UIColor clearColor]];
    
    //保存
    [viewParent addSubview:_tableViewInfo];
}

// =======================================================================
#pragma mark - UIScrollViewDelegate的代理函数
// =======================================================================
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_keyboardHeight > 0)
    {
        [self hideKeyboard];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(_keyboardHeight != 0)
	{
		// 滚动屏幕
		[self scrollInputView:textField];
	}
}

@end
