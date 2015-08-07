//
//  AlertManager.m
//  QunariPhone
//
//  Created by 姜琢 on 13-4-12.
//  Copyright (c) 2013年 Qunar.com. All rights reserved.
//

#import "AlertManager.h"
#import "AlertViewRelation.h"

@interface AlertManager ()

@property (nonatomic, strong) NSMutableArray *arrayRelation;
@property (nonatomic, strong) BaseNameVC *currentPopVC;

@end

static AlertManager *globalAlertManager = nil;

@implementation AlertManager

@synthesize arrayRelation = _arrayRelation;

// 获取数据管理的控制器
+ (AlertManager *)getInstance
{
	@synchronized(self)
	{
		// 实例对象只分配一次
		if(globalAlertManager == nil)
		{
			globalAlertManager = [[super allocWithZone:NULL] init];
			
			globalAlertManager.arrayRelation = [[NSMutableArray alloc] initWithCapacity:0];
		}
	}
	
	return globalAlertManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self getInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (void)appendWithBaseNameVC:(BaseNameVC *)baseNameVC AndAlertView:(UIAlertView *)alertView
{
	AlertViewRelation *alertViewRelation = [[AlertViewRelation alloc] init];
	
	[alertViewRelation setAlertView:alertView];
	[alertViewRelation setBaseNameVC:baseNameVC];
	
	[[[AlertManager getInstance] arrayRelation] addObject:alertViewRelation];
}

+ (void)closeAlertViewWithBaseNameVC:(BaseNameVC *)baseNameVC
{
	NSArray *arrayRelation = [[AlertManager getInstance] arrayRelation];
	
	// 要被移除的对象
	NSMutableArray *arrayRemoved = [[NSMutableArray alloc] init];
	
	for (AlertViewRelation *alertViewRelation in arrayRelation)
	{
		if ([alertViewRelation.baseNameVC isEqual:baseNameVC])
		{
			[alertViewRelation.alertView setDelegate:nil];
			[alertViewRelation.alertView dismissWithClickedButtonIndex:0 animated:NO];
			
			// 添加到被移除对象数组中
			[arrayRemoved addObject:alertViewRelation];
		}
	}
	
	// 移除对象
	[[[AlertManager getInstance] arrayRelation] removeObjectsInArray:arrayRemoved];
}

@end
