//
//  VCManager.m
//  Qunar_ipad
//
//  Created by tang Helen on 11-9-27.
//  Copyright 2011年 去哪网. All rights reserved.
//

#import "VCManager.h"
 
// 控件尺寸
#define kPopNameVCUnEnableHeight                         140

@interface VCManager ()

@property (strong, nonatomic) UIWindow *mainWindow;

@property (nonatomic, strong) VCController *ucLoginVCC;
@property (nonatomic, strong) UIWindow *ucLoginWindow;          // ucLoginWindow
@property (nonatomic, strong) UIView *ucLoginViewBG;            // ucLoginViewBG

@end

@implementation VCManager

// 全局数据控制器
static VCController *mainVCC = nil;

// 全局数据控制器
static VCManager *globalVCManager = nil;

+ (id)shareManager
{
    @synchronized(self)
	{
		// 实例对象只分配一次
		if(globalVCManager == nil)
		{
			globalVCManager = [[super allocWithZone:NULL] init];
			
            // 创建 ucLogin VCController
			VCController *ucLoginVCCTmp = [[VCController alloc] init];
			[ucLoginVCCTmp setView:nil];
			[globalVCManager setUcLoginVCC:ucLoginVCCTmp];
		}
	}
	
	return globalVCManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

// ==================================================================================
#pragma mark - mainVCC
// ==================================================================================
+ (VCController *)mainVCC
{
	if (mainVCC == nil)
	{
		VCController *mainVCCTmp = [[VCController alloc] init];
		
		// =====================================================================
		// 创建Window，设置VCManager
		// =====================================================================
        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		[[VCManager shareManager] setMainWindow:window];
		
		// Override point for customization after application launch.
		[[[VCManager shareManager] mainWindow] setBackgroundColor:[UIColor clearColor]];
		
        [[[VCManager shareManager] mainWindow] makeKeyAndVisible];
		
		// 设置到A
		[[[UIApplication sharedApplication] delegate] setWindow:[[VCManager shareManager] mainWindow]];
        
		// 设置VCManager
		[mainVCCTmp setView:[[VCManager shareManager] mainWindow]];
		
		mainVCC = mainVCCTmp;
	}
	
	return mainVCC;
}

// 获取AppFrame
+ (CGRect)getAppFrame
{
	// 获取程序代理
	CGRect windowFrame = [[[VCManager mainVCC] view] frame];
	
	// 初始化控制器view
	return CGRectMake(0, 0, windowFrame.size.width, windowFrame.size.height);
}

// ==================================================================================
#pragma mark - ucLoginVCC
// ==================================================================================
+ (VCController *)ucLoginVCC
{
    return [[VCManager shareManager] ucLoginVCC];
}

+ (UIWindow *)ucLoginWindow
{
    return [[VCManager shareManager] ucLoginWindow];
}

+ (void)ucLoginShow:(PopNameVC *)popNameVC
{
    // 创建 ucLoginWindow
    UIWindow *ucLoginWindowTmp = [[VCManager shareManager] ucLoginWindow];
    if(ucLoginWindowTmp == nil)
    {
        // 创建 ucLoginWindow
        ucLoginWindowTmp = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [ucLoginWindowTmp setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.5f]];
		[ucLoginWindowTmp setWindowLevel:UIWindowLevelNormal + 1];
        
        // 保存
        [[VCManager shareManager] setUcLoginWindow:ucLoginWindowTmp];
		
		[ucLoginWindowTmp makeKeyAndVisible];
    }
    
    // 添加子视图
    UIView *ucLoginTouchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ucLoginWindowTmp.frame.size.width, kPopNameVCUnEnableHeight)];
	
    // 添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(ucLoginDismiss)];
    [ucLoginTouchView addGestureRecognizer:tapGesture];
    
    // 保存
    [ucLoginWindowTmp addSubview:ucLoginTouchView];
    
    // 添加子视图
    UIView *ucLoginViewBG = [[UIView alloc] initWithFrame:CGRectMake(0,
																	 ucLoginWindowTmp.frame.size.height + kPopNameVCUnEnableHeight,
																	 ucLoginWindowTmp.frame.size.width,
																	 ucLoginWindowTmp.frame.size.height - kPopNameVCUnEnableHeight)];
    
    // 保存
    [ucLoginWindowTmp addSubview:ucLoginViewBG];
    [[VCManager shareManager] setUcLoginViewBG:ucLoginViewBG];

    // 设置VCManager
    [[VCManager ucLoginVCC] setView:[[VCManager shareManager] ucLoginViewBG]];
    [[VCManager ucLoginVCC] pushVC:popNameVC WithAnimation:nil];

    [UIView animateWithDuration:0.4f
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect contentFrame = CGRectMake(0,
														  kPopNameVCUnEnableHeight,
														  [[[VCManager shareManager] ucLoginViewBG] frame].size.width,
														  [[[VCManager shareManager] ucLoginViewBG] frame].size.height);
                         
                         [[[VCManager shareManager] ucLoginViewBG] setFrame:contentFrame];
                     }
                     completion:^(BOOL bFinish){
                     }];
}

+ (void)ucLoginDismiss
{
    [UIView animateWithDuration:0.2f
                     animations:^{
                         CGRect contentFrame = CGRectMake(0,
														  [[[VCManager shareManager] ucLoginViewBG] frame].size.height + kPopNameVCUnEnableHeight,
														  [[[VCManager shareManager] ucLoginViewBG] frame].size.width,
														  [[[VCManager shareManager] ucLoginViewBG] frame].size.height);
                         
                         [[[VCManager shareManager] ucLoginViewBG] setFrame:contentFrame];
                     }
                     completion:^(BOOL bFinish){
                         [[[VCManager shareManager] ucLoginViewBG] removeFromSuperview];
                         
                         // 交还keywindow
                         [[[VCManager shareManager] mainWindow] makeKeyWindow];
						 
                         // 重设level
                         [globalVCManager setUcLoginWindow:nil];
                         
                         // 清空栈
                         [[VCManager ucLoginVCC] setArrayVCSubs:nil];
                         
                         // 清空View
                         [[VCManager ucLoginVCC] setView:nil];
                     }];
}

@end
