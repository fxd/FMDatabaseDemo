//
//  NaviNameVC.h
//  QunariPhone
//
//  Created by Neo on 11/20/12.
//  Copyright (c) 2012 Qunar.com. All rights reserved.
//

#import "BaseNameVC.h"
#import "NaviBar.h"

@interface NaviNameVC : BaseNameVC
{
	NaviBar *naviBar;
}

// 初始化函数
- (id)init;
- (id)initWithName:(NSString *)vcNameInit;
- (id)initWithName:(NSString *)vcNameInit andFrame:(CGRect)frameInit;

// 布局默认的导航栏
- (void)layoutNaviBarDefault:(UIView *)viewParent;

// 获取Bar
- (NaviBar *)naviBar;

@end
