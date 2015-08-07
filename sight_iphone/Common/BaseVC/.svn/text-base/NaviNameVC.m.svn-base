//
//  NaviNameVC.m
//  QunariPhone
//
//  Created by Neo on 11/20/12.
//  Copyright (c) 2012 Qunar.com. All rights reserved.
//

#import "NaviNameVC.h"

// ==================================================================
// 布局参数
// ==================================================================
#define kNaviNameNaivBarHeight				64

@implementation NaviNameVC

// 初始化函数
- (id)init
{
	if((self = [super init]) != nil)
	{
		// 创建NaviBar
		naviBar = [[NaviBar alloc] initWithFrame:CGRectZero];
        
        return self;
	}
	
	return nil;
}

- (id)initWithName:(NSString *)vcNameInit
{
	if((self = [super initWithName:vcNameInit]) != nil)
	{
		// 创建NaviBar
		naviBar = [[NaviBar alloc] initWithFrame:CGRectZero];
        
        return self;
	}
	
	return nil;
}

- (id)initWithName:(NSString *)vcNameInit andFrame:(CGRect)frameInit
{
	if((self = [super initWithName:vcNameInit andFrame:frameInit]) != nil)
	{
		// 创建NaviBar
		naviBar = [[NaviBar alloc] initWithFrame:CGRectZero];
        
        return self;
	}
	
	return nil;
}

// 布局默认的导航栏
- (void)layoutNaviBarDefault:(UIView *)viewParent
{
	CGRect parentFrame = [viewParent frame];
	[naviBar setFrame:CGRectMake(0, 0, parentFrame.size.width, kNaviNameNaivBarHeight)];
	[viewParent addSubview:naviBar];
	
	[naviBar setBackgroundColor:[UIColor clearColor]];
}

// 获取Bar
- (NaviBar *)naviBar
{
	return naviBar;
}

@end
