//
//  LoadVC.m
//  QunarIphone
//
//  Created by Neo on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadVC.h"
#import "CamelAnimationView.h"
#import "VCManager.h"
#import "UILabel+Utility.h"
 #import "NSString+Utility.h"
 

//#import "AFHTTPRequestOperationManager.h"

// ==================================================================
// 布局参数
// ==================================================================
// 控件限高宽
#define kLoadVCContentViewWidth				240
#define kLoadVCContentViewHeight			155
#define	kLoadVCCancelButtonWidth			44
#define	kLoadVCCancelButtonHeight			44

// 控件间距
#define kLoadVCCamelVMargin                 30
#define	kLoadVCHintLabelHMargin				12
#define kLoadVCHintLabelVMargin             95
#define kLoadVCHintLabelBottomMargin        18

// 控件字体
#define	kLoadVCHintLabelFont				kCurNormalFontOfSize(14)

// 控件标记
typedef enum
{
	kLoadVCContentViewTag = 100,
	kLoadVCCancelButtonTag,
	kLoadVCLoadHintLabelTag,
    kLoadVCCamelViewTag,
} LoadVCTag;

// 扩展
@interface LoadVC ()

@property (nonatomic, retain) id context;					// 上下文
@property (nonatomic, assign) NSInteger contextTag;			// 上下文标记
@property (nonatomic, retain) NSString *hintText;			// 提示文本
@property (nonatomic, assign) UIViewController<LoadCancelPtc> *delegate;	// 代理
@property (nonatomic, assign) BOOL canCancel;				// 是否可以取消
@property (nonatomic, assign) BOOL vcCanRightPanTmp;		// 缓存vc能否进行右滑

// 刷新界面
- (void)reLayout;

@end

// ==================================================================
// 实现
// ==================================================================
@implementation LoadVC

// 重载基类该函数,自定义界面控件的布局
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[self view] setBackgroundColor:[UIColor clearColor]];
	
	// 创建root View的子视图
	[self setupViewRootSubs:[self view]];
}

// =======================================================================
// 布局函数
// =======================================================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
	// 父窗口属性
	CGRect parentFrame = [viewParent frame];
	
	// =======================================================================
	// 背景View
	// =======================================================================
	// 创建View
	UIView *viewBG = [[UIView alloc] initWithFrame:CGRectZero];
	[viewBG setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
	[viewBG setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
	
	// 添加到父窗口
	[viewParent addSubview:viewBG];
	
	// =======================================================================
	// Content View
	// =======================================================================
	// 创建View
	UIView *viewContent = [[UIView alloc] initWithFrame:CGRectZero];
	[viewContent setFrame:CGRectMake((NSInteger)(parentFrame.size.width - kLoadVCContentViewWidth) / 2,
                                     (NSInteger)(parentFrame.size.height - kLoadVCContentViewHeight) / 2,
                                     kLoadVCContentViewWidth, kLoadVCContentViewHeight)];
	[viewContent setTag:kLoadVCContentViewTag];
    [viewContent setBackgroundColor:[UIColor whiteColor]];
    [[viewContent layer] setCornerRadius:5.0f];
    [[viewContent layer] setMasksToBounds:YES];
	
	// 创建子界面
	[self setupViewContentSubs:viewContent];
	
	// 添加到父窗口
	[viewParent addSubview:viewContent];
}

// 创建Content View的子界面
- (void)setupViewContentSubs:(UIView *)viewParent
{
	// 父窗口
	CGRect parentFrame = [viewParent frame];
	
    CamelAnimationView *viewAnimation = (CamelAnimationView *)[viewParent viewWithTag:kLoadVCCamelViewTag];
    if(viewAnimation == nil)
    {
        viewAnimation = [[CamelAnimationView alloc] initWithFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
        [viewAnimation setOffset:kLoadVCCamelVMargin];
        [viewAnimation setTag:kLoadVCCamelViewTag];
        [viewParent addSubview:viewAnimation];
    }
	else
    {
        [viewAnimation setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
        [viewAnimation startAnimating];
    }
	
    // =======================================================================
	// Hint Label
	// =======================================================================
	UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kLoadVCLoadHintLabelTag];
	if(labelHint == nil)
	{
		labelHint = [[UILabel alloc] initWithFont:kLoadVCHintLabelFont andTag:kLoadVCLoadHintLabelTag];
		[labelHint setLineBreakMode:NSLineBreakByWordWrapping];
		[labelHint setNumberOfLines:0];
		[labelHint setTextAlignment:NSTextAlignmentCenter];
        [labelHint setTextColor:[UIColor colorWithHex:0x1ba9ba alpha:1.0]];
		
		// 保存
		[viewParent addSubview:labelHint];
	}
	
	// 设置属性
	if(_hintText != nil)
	{
		// 设置字符串的尺寸
		CGSize hintTextSize = [_hintText sizeWithFontCompatible:kLoadVCHintLabelFont
                                              constrainedToSize:CGSizeMake(kLoadVCContentViewWidth - 2 * kLoadVCHintLabelHMargin, CGFLOAT_MAX)
                                                  lineBreakMode:NSLineBreakByWordWrapping];
		
		// 设置Label属性
		[labelHint setFrame:CGRectMake((NSInteger)(parentFrame.size.width - hintTextSize.width) / 2,
									   kLoadVCHintLabelVMargin, hintTextSize.width, hintTextSize.height)];
		[labelHint setText:_hintText];
		[labelHint setHidden:NO];
	}
	else
	{
		[labelHint setHidden:YES];
	}
    
	// =======================================================================
	// Close Button
	// =======================================================================
	UIButton *buttonCancel = (UIButton *)[viewParent viewWithTag:kLoadVCCancelButtonTag];
	if(buttonCancel == nil)
	{
		buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
		[buttonCancel setBackgroundImage:[UIImage imageNamed:kLoadVCCloseImageFile] forState:UIControlStateNormal];
		[buttonCancel setBackgroundImage:[UIImage imageNamed:kLoadVCClosePressImageFile] forState:UIControlStateHighlighted];
		[buttonCancel addTarget:self action:@selector(doCancel:) forControlEvents:UIControlEventTouchUpInside];
		[buttonCancel setTag:kLoadVCCancelButtonTag];
		
		// 保存
		[viewParent addSubview:buttonCancel];
	}
	
	// 现实
	if(_canCancel)
	{
		[buttonCancel setFrame:CGRectMake(parentFrame.size.width - kLoadVCCancelButtonWidth / 2 - 16,
                                          -kLoadVCCancelButtonHeight / 2 + 16,
                                          kLoadVCCancelButtonWidth, kLoadVCCancelButtonHeight)];
		[buttonCancel setHidden:NO];
	}
	else
	{
		[buttonCancel setHidden:YES];
	}
	
	if (viewParent != nil)
	{
		[viewParent setViewHeight:kLoadVCHintLabelVMargin + labelHint.frame.size.height + kLoadVCHintLabelBottomMargin];
	}
}

// =======================================================================
// 事件处理函数
// =======================================================================
// 取消
- (void)doCancel:(id)sender
{
	// 停止加载
	[self endLoading];
	
#warning todo: 取消网络请求
	// 取消网络请求
//	if([_context isKindOfClass:[AFHTTPRequestOperationManager class]])
//	{
//		[[(AFHTTPRequestOperationManager *)_context operationQueue] cancelAllOperations];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadVCDoCancel" object:nil];
//	}
	
	// 请求代理函数
    if((_delegate != nil) && ([_delegate respondsToSelector:@selector(cancelLoad:withTag:)] == YES))
    {
        [_delegate cancelLoad:_context withTag:_contextTag];
    }
}

// =======================================================================
// 接口函数
// =======================================================================
// 加载(ctx, text如果没发生变化，就传nil)
- (void)loading:(UIViewController<LoadCancelPtc> *)vc forContext:(id)ctx withTag:(NSInteger)tag andHint:(NSString *)text andCancel:(BOOL)cancel;
{
    // !!!!!!对半屏进行特殊处理(start)!!!!!!
    if([[vc view] frame].origin.x == 20)
    {
        UIView *viewContent = [[self view] viewWithTag:kLoadVCContentViewTag];
        [viewContent setViewX:10];
    }
    // !!!!!!对半屏进行特殊处理(end)!!!!!!
    
	// 首次加载
	if([[self view] isDescendantOfView:[vc view]] == NO)
    {
		// 设置属性
		_context = ctx;
		_contextTag = tag;
		_hintText = text;
		_canCancel = cancel;
		_delegate = vc;
		
		if ([_delegate isKindOfClass:[BaseNameVC class]])
		{
			BaseNameVC *baseNameVC = (BaseNameVC *)_delegate;
			_vcCanRightPanTmp = baseNameVC.isCanRightPan;
			if ([baseNameVC isCanRightPan])
			{
				[(BaseNameVC *)_delegate setIsCanRightPan:NO];
			}
		}
		
		// 加载视图
		if([self isViewLoaded] == NO)
		{
			[self view];
		}
		
		// 刷新界面
		[self reLayout];
		
		// 添加到父窗口
		[[self view] setAlpha:0];
		[[self view] setViewY:0];
		[[vc view] addSubview:[self view]];
		
		// 显示
		[UIView animateWithDuration:0.5
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] setAlpha:1];
						 }
						 completion:nil];
	}
	else
	{
		if(ctx != nil)
		{
			_context = ctx;
			_contextTag = tag;
		}
		
		if(text != nil)
		{
			[self setHintText:text];
		}
		
		if(cancel != _canCancel)
		{
			_canCancel = cancel;
		}
		
		// 刷新界面
		[self reLayout];
	}
}

- (void)loadingInWindow:(id)delegate forContext:(id)ctx withTag:(NSInteger)tag andHint:(NSString *)text andCancel:(BOOL)cancel
{
	UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
	
	// 首次加载
	if([[self view] isDescendantOfView:window] == NO)
    {
		// 设置属性
		_context = ctx;
		_contextTag = tag;
		_hintText = text;
		_canCancel = cancel;
		
		// 加载视图
		if([self isViewLoaded] == NO)
		{
			[self view];
		}
		
		// 刷新界面
		[self reLayout];
		
		// 添加到父窗口
		[[self view] setAlpha:0];
		[[self view] setViewY:20];
		[window addSubview:[self view]];
		
		// 显示
		[UIView animateWithDuration:0.5
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] setAlpha:1];
						 }
						 completion:nil];
	}
	else
	{
		if(ctx != nil)
		{
			_context = ctx;
			_contextTag = tag;
		}
		
		if(text != nil)
		{
			[self setHintText:text];
		}
		
		if(cancel != _canCancel)
		{
			_canCancel = cancel;
		}
		
		// 刷新界面
		[self reLayout];
	}
}

- (void)loadingInPopWindow:(id)delegate forContext:(id)ctx withTag:(NSInteger)tag andHint:(NSString *)text andCancel:(BOOL)cancel
{
	UIWindow *window = [VCManager ucLoginWindow];
	
	// 首次加载
	if([[self view] isDescendantOfView:window] == NO)
    {
		// 设置属性
		_context = ctx;
		_contextTag = tag;
		_hintText = text;
		_canCancel = cancel;
		
		// 加载视图
		if([self isViewLoaded] == NO)
		{
			[self view];
		}
		
		// 刷新界面
		[self reLayout];
		
		// 添加到父窗口
		[[self view] setAlpha:0];
		[[self view] setViewY:20];
		[window addSubview:[self view]];
		
		// 显示
		[UIView animateWithDuration:0.5
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] setAlpha:1];
						 }
						 completion:nil];
	}
	else
	{
		if(ctx != nil)
		{
			_context = ctx;
			_contextTag = tag;
		}
		
		if(text != nil)
		{
			[self setHintText:text];
		}
		
		if(cancel != _canCancel)
		{
			_canCancel = cancel;
		}
		
		// 刷新界面
		[self reLayout];
	}
}

// 设置代理
- (void)setDelegate:(UIViewController<LoadCancelPtc> *)delegateNew
{
	_delegate = delegateNew;
}

// 结束加载
- (void)endLoading
{
	if ([_delegate isKindOfClass:[BaseNameVC class]])
	{
		[(BaseNameVC *)_delegate setIsCanRightPan:_vcCanRightPanTmp];
	}
	
    // 停止动画
    CamelAnimationView *viewAnimation = (CamelAnimationView *)[[self view] viewWithTag:kLoadVCCamelViewTag];
    if(viewAnimation != nil)
    {
        [viewAnimation stopAnimating];
    }
    
    // 移除屏幕
	[[self view] removeFromSuperview];
}

// 刷新界面
- (void)reLayout
{
	UIView *viewContent = [[self view] viewWithTag:kLoadVCContentViewTag];
	if(viewContent != nil)
	{
		[self setupViewContentSubs:viewContent];
	}
}

// 销毁代理
- (void)dealloc
{
	_delegate = nil;
}

@end
