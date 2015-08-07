//
//  AlertController.m
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import "AlertController.h"

@interface AlertController ()

@property (nonatomic, strong) UIAlertView *alertView;		// 对话框

@end

// =====================================================================================
// 全局对话框控制器
// =====================================================================================
static AlertController *globalAlertController = nil;

@implementation AlertController

// 获取AlertView控制器(单例，防止全局变量的使用)
+ (AlertController *)getInstance
{
	@synchronized(self)
	{
		// 实例对象只分配一次
		if(globalAlertController == nil)
		{
			globalAlertController = [[super allocWithZone:NULL] init];
			
			// 初始化为nil
			[globalAlertController setAlertView:nil];
		}
	}
	
	return globalAlertController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self getInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

// 显示新的View
- (void)showNewAlertView:(UIAlertView *)alertViewNew
{
	UIAlertView *alertViewCur = _alertView;
	if(alertViewCur != nil)
	{
		[alertViewCur setDelegate:nil];
		[alertViewCur setHidden:YES];
		[alertViewCur dismissWithClickedButtonIndex:0 animated:NO];
	}
	
	_alertView = alertViewNew;
}

// 销毁
- (void)destroy
{
	_alertView = nil;
}

@end
