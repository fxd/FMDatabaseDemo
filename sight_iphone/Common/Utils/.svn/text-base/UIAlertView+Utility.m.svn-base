//
//  UIAlertView+Utility.m
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import "UIAlertView+Utility.h"
#import "AlertController.h"
#import "BaseNameVC.h"
#import "VCManager.h"
#import "AlertManager.h"

@implementation UIAlertView (Utility)

// 显示对话框
+ (void)showAlertView:(NSString *)title message:(NSString *)message delgt:(id)delgt cancelTitle:(NSString *)cancelTitle otherTilte:(NSString *)otherTitle
{
	if ([delgt isKindOfClass:[BaseNameVC class]])
	{
		BaseNameVC *baseNameVC = delgt;
		
		if ([baseNameVC isEqual:[[VCManager mainVCC] currentPopVC]])
		{
			return;
		}
	}
	
	if(otherTitle != nil)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
															message:message
														   delegate:delgt
												  cancelButtonTitle:cancelTitle
												  otherButtonTitles:otherTitle, nil];
		[alertView show];
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
															message:message
														   delegate:delgt
												  cancelButtonTitle:cancelTitle
												  otherButtonTitles:nil];
		[alertView show];
	}
}

// 显示对话框
+ (void)showAlertView:(NSString *)title message:(NSString *)message delgt:(id)delgt cancelTitle:(NSString *)cancelTitle otherTilte:(NSString *)otherTitle andTag:(NSInteger)initTag
{
	if ([delgt isKindOfClass:[BaseNameVC class]])
	{
		BaseNameVC *baseNameVC = delgt;
		
		if ([baseNameVC isEqual:[[VCManager mainVCC] currentPopVC]])
		{
			return;
		}
	}
	
	if(otherTitle != nil)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
															message:message
														   delegate:delgt
												  cancelButtonTitle:cancelTitle
												  otherButtonTitles:otherTitle, nil];
		[alertView setTag:initTag];
		[alertView show];
		
		if ([delgt isKindOfClass:[BaseNameVC class]])
		{
			BaseNameVC *baseNameVC = delgt;
			
			[AlertManager appendWithBaseNameVC:baseNameVC AndAlertView:alertView];
		}
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
															message:message
														   delegate:delgt
												  cancelButtonTitle:cancelTitle
												  otherButtonTitles:nil];
		[alertView setTag:initTag];
		[alertView show];
		
		if ([delgt isKindOfClass:[BaseNameVC class]])
		{
			BaseNameVC *baseNameVC = delgt;
			
			[AlertManager appendWithBaseNameVC:baseNameVC AndAlertView:alertView];
		}
	}
}

// 显示网络请求失败对话框
+ (void)showNetworkErrorAlertView
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
														message:@"网络请求失败"
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
	[alertView show];
}

// 显示可变按钮数量的对话框
+ (void)showAlertView:(NSString *)title message:(NSString *)message delgt:(id)delgt withArrayTitle:(NSArray *)arrayTitle andTag:(NSInteger)initTag
{
	if ([delgt isKindOfClass:[BaseNameVC class]])
	{
		BaseNameVC *baseNameVC = delgt;
		
		if ([baseNameVC isEqual:[[VCManager mainVCC] currentPopVC]])
		{
			return;
		}
	}
	
	if ((arrayTitle != nil) && ([arrayTitle count] > 0))
	{
		UIAlertView *alertView = [[UIAlertView alloc] init];
		[alertView setTitle:title];
		[alertView setMessage:message];
		[alertView setDelegate:delgt];
		[alertView setTag:initTag];
		
		for (NSInteger i=0; i<[arrayTitle count]; i++)
		{
			[alertView addButtonWithTitle:[arrayTitle objectAtIndex:i]];
		}
		
		[alertView show];
	}
}

// 创建单例对话框
- (id)initSingleWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;
{
	if ([delegate isKindOfClass:[BaseNameVC class]])
	{
		BaseNameVC *baseNameVC = delegate;
		
		if ([baseNameVC isEqual:[[VCManager mainVCC] currentPopVC]])
		{
			return nil;
		}
	}
	
	if((self = [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil]) != nil)
	{
		[[AlertController getInstance] showNewAlertView:self];
	}
	
	return self;
}

@end
