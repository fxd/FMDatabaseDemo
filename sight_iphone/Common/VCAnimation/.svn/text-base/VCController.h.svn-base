//
//  VCController.h
//  QunariPhone
//
//  Created by 姜琢 on 12-11-12.
//  Copyright (c) 2012年 Qunar.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCAnimation.h"
#import "BaseNameVC.h"
#import "PopNameVC.h"

// ==================================================================
// 手势类型
// ==================================================================
typedef enum
{
	eDirectionTypeNone = 0,
	eDirectionTypeLeft = 1,				// 手势向左滑动
	eDirectionTypeRight = 2,			// 手势向右滑动
} DragDirectionType;

// ==================================================================
// 手势类型
// ==================================================================
@interface VCController : NSObject <UIGestureRecognizerDelegate>
{
	CGFloat				_displacementPosition;				// 位移标点
	CGFloat				_lastTouchPoint;					// 上一个触摸点
	CGPoint				_activeViewTouchBeganPos;			// 激活View滑动开始位置
	CGPoint				_backViewTouchBeganPos;				// 背景View滑动开始位置
    
    DragDirectionType   _dragDirection;						// 滑动方向
	
    NSMutableArray		*_darkMaskStack;					// 遮罩View
	
    BaseNameVC			*_mainVC;							// 主页背景层, 最底层的内容都放在这里
    BaseNameVC			*_activeVC;							// 当前激活的层, 能够相应操作
    BaseNameVC			*_backVC;							// 当前被遮盖的层
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSMutableArray *arrayVCSubs;
@property (nonatomic, strong) BaseNameVC *currentPopVC;

// 是否为顶部节点
- (BOOL)isTopVCWithObject:(UIViewController *)vc;

// 是否为顶部节点
- (BOOL)isTopVC:(NSString *)vcName;

// 获取顶部节点
- (BaseNameVC *)getTopVC;

// 获取节点
- (BaseNameVC *)getVC:(NSString *)vcName;

// 压入节点
- (void)pushVC:(BaseNameVC *)baseNameVC WithAnimation:(id <VCAnimation>)animation;

// 弹出节点
- (BOOL)popWithAnimation:(id <VCAnimation>)animation;

// 弹出节点
- (BOOL)popToVC:(NSString *)vcName WithAnimation:(id <VCAnimation>)animation;

// 弹出节点然后压入节点
- (BOOL)popThenPushVC:(BaseNameVC *)baseNameVC WithAnimation:(id <VCAnimation>)animation;

// 弹出节点然后压入节点
- (void)popToVC:(NSString *)vcName thenPushVC:(BaseNameVC *)baseNameVC WithAnimation:(id <VCAnimation>)animation;

@end
