//
//  VCAnimation.h
//  QunariPhone
//
//  Created by 姜琢 on 12-11-12.
//  Copyright (c) 2012年 Qunar.com All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VCAnimation <NSObject>

// 压入节点动画
- (void)pushAnimationFromTopVC:(UIViewController *)topVC ToArriveVC:(UIViewController *)arriveVC WithCompletion:(void (^)(BOOL finished))completion inView:(UIView *)view;

// 弹出节点动画
- (void)popAnimationFromTopVC:(UIViewController *)topVC ToArriveVC:(UIViewController *)arriveVC AndBackVC:(UIViewController *)backVC WithCompletion:(void (^)(BOOL finished))completion inView:(UIView *)view;

@end
