//
//  BaseNameVC.m
//  Qunar
//
//  Created by Neo on 2/18/11.
//  Copyright 2011 qunar.com. All rights reserved.
//

#import "BaseNameVC.h"
#import "LoadVC.h"
#import "VCManager.h"
#import "AlertManager.h"
#import "VCAnimationClassic.h"

#define	kBaseNameVCRoundRectOffset	5

@interface BaseNameVC ()

@property (nonatomic, strong) LoadVC *loadVC;           // 加载窗口
@property (nonatomic, assign) CGRect rootViewFrame;		// 根窗口Frame
@property (nonatomic, strong) NSString *vcName;			// 名称
@property (nonatomic, strong) UIView *background;		// 背景View

@end

// ==================================================================
// 实现
// ==================================================================
@implementation BaseNameVC

- (void)dealloc
{
	[AlertManager closeAlertViewWithBaseNameVC:self];
}

// 重载初始化函数
- (id)init
{
	if((self = [super init]) != nil)
	{
		// 设置默认值
		_rootViewFrame = [VCManager getAppFrame];
		
		// 根据时间生成随机VCName
		NSDate *curDate = [[NSDate alloc] init];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale * gregorianLocale = [[NSLocale alloc] initWithLocaleIdentifier:NSCalendarIdentifierGregorian];
        [dateFormatter setLocale:gregorianLocale];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
		NSString *curDateText = [dateFormatter stringFromDate:curDate];
		NSString *defaultVCName = [[NSString alloc] initWithFormat:@"VCName:%@", curDateText];
		_vcName = defaultVCName;
		
		_isCanGoBack = YES;
		
		_isCanRightPan = YES;
		
		return self;
	}
	
	return nil;
}

- (id)initWithName:(NSString *)vcNameInit
{
	if((self = [self init]) != nil)
	{
		_vcName = vcNameInit;
		
		return self;
	}
	
	return nil;
}

- (id)initWithName:(NSString *)vcNameInit andFrame:(CGRect)frameInit
{
	if(vcNameInit == nil)
	{
		if((self = [self init]) != nil)
		{
			_rootViewFrame = frameInit;
			
			return self;
		}
	}
	else
	{
		if((self = [super init]) != nil)
		{
			_rootViewFrame = frameInit;
			_vcName = vcNameInit;
			_isCanGoBack = YES;
			_isCanRightPan = YES;
			
			return self;
		}
	}
	
	return nil;
}

// 获取VCName
- (NSString *)getVCName
{
	return _vcName;
}

// 加载LoadVC
- (void)startLoading:(id)Content withHint:(NSString *)hintText
{
    if(_loadVC == nil)
	{
		// 创建LoadVC
		_loadVC = [[LoadVC alloc] init];
	}
	
	[_loadVC loading:self forContext:Content withTag:0 andHint:hintText andCancel:NO];
}

- (void)startLoadingCancel:(id)Content withHint:(NSString *)hintText
{
    if(_loadVC == nil)
	{
		// 创建LoadVC
		_loadVC = [[LoadVC alloc] init];
	}
	
	[_loadVC loading:self forContext:Content withTag:0 andHint:hintText andCancel:YES];
}

- (void)startLoading:(id)Content withHint:(NSString *)hintText andTag:(NSInteger)tag
{
    if(_loadVC == nil)
	{
		// 创建LoadVC
		_loadVC = [[LoadVC alloc] init];
	}
	
	[_loadVC loading:self forContext:Content withTag:tag andHint:hintText andCancel:NO];
}

- (void)startLoadingCancel:(id)Content withHint:(NSString *)hintText andTag:(NSInteger)tag
{
    if(_loadVC == nil)
	{
		// 创建LoadVC
		_loadVC = [[LoadVC alloc] init];
	}
	
	[_loadVC loading:self forContext:Content withTag:tag andHint:hintText andCancel:YES];
}

- (void)stopLoading
{
    [_loadVC endLoading];
}

// 重载初始化函数
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[[self view] setFrame:_rootViewFrame];
    [[self view] setBackgroundColor:[UIColor colorWithHex:0xf2f8fb alpha:1.0f]];
        
}

- (BOOL)canDoGoBack
{
	return YES;
}

- (BOOL)viewCanRight:(UIView *)view
{
	return YES;
}

// 返回的动作
- (void)goBack:(id)sender
{
    [[VCManager mainVCC] popWithAnimation:[VCAnimationClassic defaultAnimation]];
}

@end
