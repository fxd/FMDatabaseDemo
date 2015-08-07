//
//  VCController.m
//  QunariPhone
//
//  Created by 姜琢 on 12-11-12.
//  Copyright (c) 2012年 Qunar.com All rights reserved.
//

#import "VCController.h"

#import "MFSideMenu.h"
#import "RightPanGestureReconizer.h"
#import "VCManager.h"
#import "AlertManager.h"
#import "Switch.h"
 
 
// 控件尺寸
#define kStackScrollMenuWidth						0
#define kStackScrollMenuRightX						0
#define kStackScrollViewMinX						0
#define kStackScrollViewMainWidth					320
#define kStackScrollViewDropWidth					120

#define kStackScrollDarkRectMaxAlpha                0.6f
#define kStackScrollDarkRectMinAlpha                0.0f

@interface VCController ()

@property (nonatomic, strong) RightPanGestureReconizer* panRecognizer;

@end

@implementation VCController

- (id)init
{
	if (self = [super init])
	{
		_darkMaskStack = [[NSMutableArray alloc] init];
		
        _dragDirection = eDirectionTypeNone;
		
		_displacementPosition = 0;
		_lastTouchPoint = -1;
		
		_activeViewTouchBeganPos = CGPointZero;
		_backViewTouchBeganPos = CGPointZero;
	}
	
	return self;
}

- (void)setView:(UIView *)view
{
	[_view removeGestureRecognizer:_panRecognizer];
	
	_view = view;
	
    // 添加手势
	_panRecognizer = [[RightPanGestureReconizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
	[_panRecognizer setDirection:DirectionPanGestureRecognizerHorizontal];
	[_panRecognizer setMaximumNumberOfTouches:1];
	[_panRecognizer setDelaysTouchesBegan:NO];
	[_panRecognizer setDelaysTouchesEnded:NO];
	[_panRecognizer setCancelsTouchesInView:YES];
	[_panRecognizer setDelegate:self];
	[_view addGestureRecognizer:_panRecognizer];
}

#pragma mark - 辅助函数
- (void)createMaskViewWithBaseNameVC:(BaseNameVC *)baseNameVC
{
	// 返回上一级阴影Button
	UIView *darkMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, baseNameVC.view.frame.size.width, baseNameVC.view.frame.size.height)];
	[darkMaskView setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.05f]];
	[darkMaskView setAlpha:1.0f];
	
	// 添加Controller到栈中
	[_darkMaskStack addObject:darkMaskView];
}

- (void)deleteMaskViewWithBaseNameVC:(BaseNameVC *)baseNameVC
{
	NSInteger vcIndex = [_arrayVCSubs indexOfObject:baseNameVC];
	
	if (vcIndex != NSNotFound)
	{
		// 用maskView覆盖当前最前面的VC
		NSInteger subsDarkCount = [_darkMaskStack count];
		
		if (vcIndex < subsDarkCount)
		{
			UIView *maskView = [_darkMaskStack objectAtIndex:vcIndex];
			[_darkMaskStack removeObject:maskView];
		}
	}
}

- (void)addMaskViewWithBaseNameVC:(BaseNameVC *)baseNameVC
{
	NSInteger vcIndex = [_arrayVCSubs indexOfObject:baseNameVC];
	
	if (vcIndex != NSNotFound)
	{
		// 用maskView覆盖当前最前面的VC
		NSInteger subsDarkCount = [_darkMaskStack count];
		
		if (vcIndex < subsDarkCount)
		{
			UIView *maskView = [_darkMaskStack objectAtIndex:vcIndex];
			[[baseNameVC view] addSubview:maskView];
		}
	}
}

- (void)removeMaskViewWithBaseNameVC:(BaseNameVC *)baseNameVC
{
	NSInteger vcIndex = [_arrayVCSubs indexOfObject:baseNameVC];
	
	if (vcIndex != NSNotFound)
	{
		// 用maskView覆盖当前最前面的VC
		NSInteger subsDarkCount = [_darkMaskStack count];
		
		if (vcIndex < subsDarkCount)
		{
			UIView *maskView = [_darkMaskStack objectAtIndex:vcIndex];
			[maskView removeFromSuperview];
		}
	}
}

#pragma mark - 管理视图控制器
// =======================================================================
// 管理视图控制器
// =======================================================================
- (void)returnOriginal
{
	BaseNameVC *frontVC = [_arrayVCSubs lastObject];
	
	BaseNameVC *backVC = nil;
	
	NSInteger vcCount = [_arrayVCSubs count];
	
	if (vcCount >= 2)
	{
		backVC = [_arrayVCSubs objectAtIndex:vcCount - 2];
	}
	
	[UIView animateWithDuration:0.2
						  delay:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 [backVC.view setViewX:(-backVC.view.frame.size.width/3)];
						 [frontVC.view setViewX:(_view.frame.size.width - frontVC.view.frame.size.width)];
					 }
					 completion:nil];
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
	CGPoint translatedPoint = [recognizer translationInView:self.view];
	
//	NSLog(@"%f, %f", translatedPoint.x, translatedPoint.y);
	
	NSInteger vcCount = [_arrayVCSubs count];
	
	// 只有HomeVC时不允许进行右滑操作
	if (vcCount < 2)
	{
		return;
	}
	
	BaseNameVC *frontVC = [_arrayVCSubs lastObject];
	
	// 若VC当前不支持右滑操作则不处理
	if (!(frontVC.isCanRightPan))
	{
		return;
	}
	
	BaseNameVC *backVC = nil;
	
	backVC = [_arrayVCSubs objectAtIndex:vcCount - 2];
	
	if (recognizer.state == UIGestureRecognizerStateBegan)
	{
		_displacementPosition = 0;
		_activeViewTouchBeganPos = frontVC.view.frame.origin;
		_backViewTouchBeganPos = backVC.view.frame.origin;
        
        [backVC.view.layer removeAllAnimations];
        [frontVC.view.layer removeAllAnimations];
	}
	
	CGPoint location =  [recognizer locationInView:self.view];
	
	if (_lastTouchPoint != -1)
	{
        // 向左滑动
		if (location.x < _lastTouchPoint)
		{
			if (_dragDirection == eDirectionTypeRight)
			{
				_activeViewTouchBeganPos = frontVC.view.frame.origin;
				_backViewTouchBeganPos = backVC.view.frame.origin;
				_displacementPosition = translatedPoint.x;
			}
			
			_dragDirection = eDirectionTypeLeft;
			
			// 不只有一个View在Stack中
			if (backVC != nil)
			{
				// RightView的位置是否已经在最边界位置
				if (_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition) <= (_view.frame.size.width - frontVC.view.frame.size.width))
				{
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [backVC.view setViewX:(-backVC.view.frame.size.width/3)];
                                         [frontVC.view setViewX:(_view.frame.size.width - frontVC.view.frame.size.width)];
                                     }
                                     completion:nil];
				}
                else if (_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition) >= _view.frame.size.width)
                {
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [backVC.view setViewX:(_view.frame.size.width - backVC.view.frame.size.width)];
                                         [frontVC.view setViewX:_view.frame.size.width];
                                     }
                                     completion:nil];
                }
				else
				{
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [frontVC.view setViewX:(_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition))];
										 [backVC.view setViewX:(_backViewTouchBeganPos.x + ((translatedPoint.x - _displacementPosition)/3))];
                                     }
                                     completion:nil];
				}
			}
			// 只有一个View在Stack中
            else
            {
				// RightView的位置是否已经在最边界位置
				if (_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition) <= (_view.frame.size.width - frontVC.view.frame.size.width))
				{
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [frontVC.view setViewX:(_view.frame.size.width - frontVC.view.frame.size.width)];
                                     }
                                     completion:nil];
				}
                else if (_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition) >= _view.frame.size.width)
                {
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [frontVC.view setViewX:_view.frame.size.width];
                                     }
                                     completion:nil];
                }
				else
				{
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [frontVC.view setViewX:(_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition))];
										 [backVC.view setViewX:(_backViewTouchBeganPos.x + ((translatedPoint.x - _displacementPosition)/3))];
                                     }
                                     completion:nil];
				}
            }
		}
        // 向右滑动
		else if (location.x > _lastTouchPoint)
		{
			if (_dragDirection == eDirectionTypeLeft)
			{
				_activeViewTouchBeganPos = frontVC.view.frame.origin;
				_backViewTouchBeganPos = backVC.view.frame.origin;
				_displacementPosition = translatedPoint.x;
			}
			
			_dragDirection = eDirectionTypeRight;
			
			// 不只有一个View在Stack中
			if (backVC != nil)
			{
				// RightView的位置是否已经在最边界位置
				if (_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition) <= (_view.frame.size.width - frontVC.view.frame.size.width))
				{
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [backVC.view setViewX:(-backVC.view.frame.size.width/3)];
                                         [frontVC.view setViewX:(_view.frame.size.width - frontVC.view.frame.size.width)];
                                     }
                                     completion:nil];
				}
                else if (_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition) >= _view.frame.size.width)
                {
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [backVC.view setViewX:(_view.frame.size.width - backVC.view.frame.size.width)];
                                         [frontVC.view setViewX:_view.frame.size.width];
                                     }
                                     completion:nil];
                }
				else
				{
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [frontVC.view setViewX:(_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition))];
										 [backVC.view setViewX:(_backViewTouchBeganPos.x + ((translatedPoint.x - _displacementPosition)/3))];
                                     }
                                     completion:nil];
				}
			}
			// 只有一个View在Stack中
            else
            {
				// RightView的位置是否已经在最边界位置
				if (_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition) <= (_view.frame.size.width - frontVC.view.frame.size.width))
				{
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [frontVC.view setViewX:(_view.frame.size.width - frontVC.view.frame.size.width)];
                                     }
                                     completion:nil];
				}
                else if (_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition) >= _view.frame.size.width)
                {
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [frontVC.view setViewX:_view.frame.size.width];
                                     }
                                     completion:nil];
                }
				else
				{
                    [UIView animateWithDuration:0.0f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [frontVC.view setViewX:(_activeViewTouchBeganPos.x + (translatedPoint.x - _displacementPosition))];
										 [backVC.view setViewX:(_backViewTouchBeganPos.x + ((translatedPoint.x - _displacementPosition)/3))];
                                     }
                                     completion:nil];
				}
            }
		}
	}
	
	_lastTouchPoint = location.x;
	
	// STATE END
	if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled ||
        recognizer.state == UIGestureRecognizerStateFailed)
	{
		if (frontVC.view.frame.origin.x > (_view.frame.size.width - frontVC.view.frame.size.width + frontVC.view.frame.size.width/3))
		{
			// Pop到上一层
			if ([frontVC isCanGoBack])
			{
                // 这里进行了修改
				if ([frontVC canDoGoBack] == NO)
				{
					[self returnOriginal];
				}
                
                [frontVC goBack:nil];
			}
			else
			{
				[self returnOriginal];
			}
		}
		else
		{
			// 归位
			[self returnOriginal];
		}
		
		_lastTouchPoint = -1;
		_dragDirection = eDirectionTypeNone;
	}
}

// 是否为顶部节点
- (BOOL)isTopVCWithObject:(UIViewController *)vc
{
	// 获取window的子VC
	if (_arrayVCSubs != nil)
	{
		NSInteger subsCount = [_arrayVCSubs count];
		UIViewController *viewController = [_arrayVCSubs objectAtIndex:(subsCount - 1)];
        
		// 只有BaseNameVC才支持此功能
		if ([viewController isEqual:vc] == YES)
		{
			return YES;
		}
	}
	
	return NO;
}

// 是否为顶部节点
- (BOOL)isTopVC:(NSString *)vcName
{
	// 获取window的子VC
	if (_arrayVCSubs != nil)
	{
		NSInteger subsCount = [_arrayVCSubs count];
		UIViewController *viewController = [_arrayVCSubs objectAtIndex:(subsCount - 1)];
        
		// 只有BaseNameVC才支持此功能
		if ([viewController isKindOfClass:[BaseNameVC class]] == YES)
		{
			BaseNameVC *baseNameVC = (BaseNameVC *)viewController;
			
			// 名称相同
			if ([[baseNameVC getVCName] isEqualToString:vcName] == YES)
			{
				return YES;
			}
		}
	}
	
	return NO;
}

// 获取顶部节点
- (BaseNameVC *)getTopVC
{
    // 获取window的子VC
	if (_arrayVCSubs != nil)
	{
		NSInteger subsCount = [_arrayVCSubs count];
		UIViewController *viewController = [_arrayVCSubs objectAtIndex:(subsCount - 1)];
        
		// 只有BaseNameVC才支持此功能
		if ([viewController isKindOfClass:[BaseNameVC class]] == YES)
		{
			BaseNameVC *baseNameVC = (BaseNameVC *)viewController;
			
			return baseNameVC;
		}
	}
    
    return nil;
}

// 获取节点
- (BaseNameVC *)getVC:(NSString *)vcName
{
	// 获取window的子VC
	if (_arrayVCSubs != nil)
	{
		NSInteger subsCount = [_arrayVCSubs count];
		
		// 从上往下逐个遍历
		for (NSInteger i = 0; i < subsCount; i++)
		{
			UIViewController *viewController = [_arrayVCSubs objectAtIndex:(subsCount - i - 1)];
			
			// 只有BaseNameVC才支持此功能
			if ([viewController isKindOfClass:[BaseNameVC class]] == YES)
			{
				BaseNameVC *baseNameVC = (BaseNameVC *)viewController;
				
				// 名称相同
				if ([[baseNameVC getVCName] isEqualToString:vcName] == YES)
				{
					return baseNameVC;
				}
			}
		}
	}
	
	return nil;
}

// 压入节点
- (void)pushVC:(BaseNameVC *)baseNameVC WithAnimation:(id <VCAnimation>)animation
{
	// 加载View
	if ([baseNameVC isViewLoaded] == NO)
	{
		[baseNameVC view];
	}
    
	[self createMaskViewWithBaseNameVC:baseNameVC];
	
	// 往window中添加子VC
    if (_arrayVCSubs)
    {
		NSInteger subsCount = [_arrayVCSubs count];
		if (subsCount > 0)
		{
            // 当前最前面的VC
            BaseNameVC *baseNameVCTop = [_arrayVCSubs objectAtIndex:(subsCount - 1)];
            [self addMaskViewWithBaseNameVC:baseNameVCTop];
			
			// 当前在背景的VC
			BaseNameVC *baseNameVCBack = nil;
			if (subsCount > 1)
			{
				baseNameVCBack = [_arrayVCSubs objectAtIndex:(subsCount - 2)];
			}
			
			if (animation != nil)
			{
				[baseNameVCTop.view.layer removeAllAnimations];
				[baseNameVC.view.layer removeAllAnimations];
				
				// 禁用VC的可用性
				[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
				
				// 设置新的根节点
				[_arrayVCSubs addObject:baseNameVC];
				
				[animation pushAnimationFromTopVC:baseNameVCTop
									   ToArriveVC:baseNameVC
								   WithCompletion:^(BOOL finished) {
									   if (![baseNameVC isCanGoBack])
									   {
										   [[baseNameVCTop view] removeFromSuperview];
									   }
									   
									   // 移除上上个VC
									   [[baseNameVCBack view] removeFromSuperview];
									   
									   // 恢复VC的可用性
									   [[UIApplication sharedApplication] endIgnoringInteractionEvents];
								   }
										   inView:_view];
			}
			else
			{
				if (![baseNameVC isCanGoBack])
				{
					[[baseNameVCTop view] removeFromSuperview];
				}
				else
				{
					[[baseNameVCTop view] setViewX:0];
				}
				
				// 移除上上个VC
				[[baseNameVCBack view] removeFromSuperview];
				
				// 设置新的根节点
				[_arrayVCSubs addObject:baseNameVC];
				[_view addSubview:[baseNameVC view]];
				[[baseNameVC view] setViewX:[VCManager getAppFrame].size.width - baseNameVC.view.frame.size.width];
			}
        }
    }
    else
    {
		// 添加到队列中
		NSMutableArray *arrayVCSubsNew = [[NSMutableArray alloc] init];
		[self setArrayVCSubs:arrayVCSubsNew];
        
        // 设置根VC
		[[baseNameVC view] setViewX:[VCManager getAppFrame].size.width - baseNameVC.view.frame.size.width];
        [arrayVCSubsNew addObject:baseNameVC];
        [_view addSubview:[baseNameVC view]];
    }
}

// 弹出节点
- (BOOL)popWithAnimation:(id <VCAnimation>)animation
{
	if (_arrayVCSubs != nil)
	{
		NSInteger subsCount = [_arrayVCSubs count];
		if (subsCount > 1)
		{
            // 获取顶层的VC
            BaseNameVC *baseNameVCTop = [_arrayVCSubs objectAtIndex:(subsCount - 1)];
            
			// 下一个VC
			BaseNameVC *baseNameVCTopNew = [_arrayVCSubs objectAtIndex:(subsCount - 2)];
			
			// 下下个VC
			BaseNameVC *baseNameVCBack = nil;
			if (subsCount > 2)
			{
				baseNameVCBack = [_arrayVCSubs objectAtIndex:(subsCount - 3)];
			}
			
			if (animation != nil)
			{
				[baseNameVCTop.view.layer removeAllAnimations];
				[baseNameVCTopNew.view.layer removeAllAnimations];
				[baseNameVCBack.view.layer removeAllAnimations];
				
				// 禁用VC的可用性
				[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
				
				[self setCurrentPopVC:baseNameVCTop];
				
                [self removeMaskViewWithBaseNameVC:baseNameVCTop];
                [self deleteMaskViewWithBaseNameVC:baseNameVCTop];
				[_arrayVCSubs removeObject:baseNameVCTop];
				
				[animation popAnimationFromTopVC:baseNameVCTop
									  ToArriveVC:baseNameVCTopNew
									   AndBackVC:baseNameVCBack
								  WithCompletion:^(BOOL finished) {
									  if (_arrayVCSubs != nil)
									  {
										  [self setCurrentPopVC:nil];
										  
										  // 去除baseNameVCTopNew的MaskView
										  [self removeMaskViewWithBaseNameVC:baseNameVCTopNew];
										  
										  // 从逻辑数组删除
										  [[baseNameVCTop view] removeFromSuperview];
										  [AlertManager closeAlertViewWithBaseNameVC:baseNameVCTop];
										  
										  // 恢复VC的可用性
										  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
									  }
								  }
										  inView:_view];
			}
			else
			{
				// 去除baseNameVCTopNew的MaskView
				[self removeMaskViewWithBaseNameVC:baseNameVCTopNew];
				
				// 下一个VC
				[_view insertSubview:[baseNameVCTopNew view] belowSubview:[baseNameVCTop view]];
				[[baseNameVCTopNew view] setViewX:[VCManager getAppFrame].size.width - baseNameVCTopNew.view.frame.size.width];
				
				// 插入新的BackVC
				[_view insertSubview:[baseNameVCBack view] belowSubview:[baseNameVCTopNew view]];
				[[baseNameVCBack view] setViewX:(-baseNameVCBack.view.frame.size.width/3)];
				
				// 移除原来在最上层的VC
				[self removeMaskViewWithBaseNameVC:baseNameVCTop];
				[self deleteMaskViewWithBaseNameVC:baseNameVCTop];
				[[baseNameVCTop view] removeFromSuperview];
				[AlertManager closeAlertViewWithBaseNameVC:baseNameVCTop];
				[_arrayVCSubs removeObject:baseNameVCTop];
			}
			
			return YES;
		}
	}
	
	return NO;
}

// 弹出节点
- (BOOL)popToVC:(NSString *)vcName WithAnimation:(id <VCAnimation>)animation
{
	if (_arrayVCSubs != nil)
	{
		NSInteger subsCount = [_arrayVCSubs count];
		
		// 从上往下逐个遍历
		for (NSInteger i = 0; i < subsCount; i++)
		{
			BaseNameVC *baseNameVCTopNew = [_arrayVCSubs objectAtIndex:(subsCount - i - 1)];
			
			if ([[baseNameVCTopNew getVCName] isEqualToString:vcName] == YES)
			{
				// pop到当前VC，不做任何动作
				if (i == 0)
				{
					break;
				}
				
				// 最上层节点
				BaseNameVC *baseNameVCTop = [_arrayVCSubs objectAtIndex:(subsCount - 1)];
				
				// 下下个VC
				BaseNameVC *baseNameVCBack = nil;
				if ((subsCount - i - 2) > 0)
				{
					baseNameVCBack = [_arrayVCSubs objectAtIndex:(subsCount - i - 2)];
				}
				
				if (animation != nil)
				{
					[baseNameVCTop.view.layer removeAllAnimations];
					[baseNameVCTopNew.view.layer removeAllAnimations];
					[baseNameVCBack.view.layer removeAllAnimations];
					
					// 禁用VC的可用性
					[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
					
					// 从逻辑数据中删除目标节点之前的节点和其对应的maskView
					for (NSInteger j = subsCount - 2; j >= subsCount - i; j--)
					{
						BaseNameVC *baseNameVCTmp = [_arrayVCSubs objectAtIndex:j];
						
						[self removeMaskViewWithBaseNameVC:baseNameVCTmp];
						[self deleteMaskViewWithBaseNameVC:baseNameVCTmp];
						[[baseNameVCTmp view] removeFromSuperview];
						[AlertManager closeAlertViewWithBaseNameVC:baseNameVCTmp];
						[_arrayVCSubs removeObject:baseNameVCTmp];
					}
					
					[self setCurrentPopVC:baseNameVCTop];
					
                    // 删除baseNameVCTop和其maskView
                    [self removeMaskViewWithBaseNameVC:baseNameVCTop];
                    [self deleteMaskViewWithBaseNameVC:baseNameVCTop];
					[_arrayVCSubs removeObject:baseNameVCTop];
					
                    [animation popAnimationFromTopVC:baseNameVCTop
                                          ToArriveVC:baseNameVCTopNew
										   AndBackVC:baseNameVCBack
                                      WithCompletion:^(BOOL finished) {
										  [self setCurrentPopVC:nil];
										  
                                          // 去除baseNameVCTopNew的MaskView
                                          [self removeMaskViewWithBaseNameVC:baseNameVCTopNew];
                                          
										  [[baseNameVCTop view] removeFromSuperview];
										  [AlertManager closeAlertViewWithBaseNameVC:baseNameVCTop];
										  
										  // 恢复VC的可用性
										  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                      }
                                              inView:_view];
				}
				else
				{
					// 下一个VC
					[_view insertSubview:[baseNameVCTopNew view] belowSubview:[baseNameVCTop view]];
					[[baseNameVCTopNew view] setViewX:[VCManager getAppFrame].size.width - baseNameVCTopNew.view.frame.size.width];
					[self removeMaskViewWithBaseNameVC:baseNameVCTopNew];
					
					// 插入新的BackVC
					[_view insertSubview:[baseNameVCBack view] belowSubview:[baseNameVCTopNew view]];
					[[baseNameVCBack view] setViewX:(-baseNameVCBack.view.frame.size.width/3)];
					
					// 循环删除目标节点之前的节点
					for (NSInteger j = subsCount - 1; j >= subsCount - i; j--)
					{
						BaseNameVC *baseNameVCTmp = [_arrayVCSubs objectAtIndex:j];
						
						// 移除对应的VC及其对应的maskView
						[self removeMaskViewWithBaseNameVC:baseNameVCTmp];
						[self deleteMaskViewWithBaseNameVC:baseNameVCTmp];
						[[baseNameVCTmp view] removeFromSuperview];
						[AlertManager closeAlertViewWithBaseNameVC:baseNameVCTmp];
						[_arrayVCSubs removeObject:baseNameVCTmp];
					}
				}
				
				return YES;
			}
		}
	}
	
	return NO;
}

// 弹出节点然后压入节点
- (BOOL)popThenPushVC:(BaseNameVC *)baseNameVC WithAnimation:(id <VCAnimation>)animation
{
	// 加载View
	if ([baseNameVC isViewLoaded] == NO)
	{
		[baseNameVC view];
	}
	
	[self createMaskViewWithBaseNameVC:baseNameVC];
	
	if (_arrayVCSubs != nil)
	{
		NSInteger subsCount = [_arrayVCSubs count];
		if (subsCount > 0)
		{
			// 获取顶层的VC
            BaseNameVC *baseNameVCTop = [_arrayVCSubs objectAtIndex:(subsCount - 1)];
            
			if (animation)
			{
				[baseNameVCTop.view.layer removeAllAnimations];
				[baseNameVC.view.layer removeAllAnimations];
				
				// 禁用VC的可用性
				[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
				
				[self setCurrentPopVC:baseNameVCTop];
				
				// 设置新的根节点
				[_arrayVCSubs addObject:baseNameVC];
				
                // 从逻辑数据中删除
                [self removeMaskViewWithBaseNameVC:baseNameVCTop];
                [self deleteMaskViewWithBaseNameVC:baseNameVCTop];
				[_arrayVCSubs removeObject:baseNameVCTop];
				
				[animation pushAnimationFromTopVC:baseNameVCTop
									   ToArriveVC:baseNameVC
								   WithCompletion:^(BOOL finished) {
									   [self setCurrentPopVC:nil];
									   
									   [[baseNameVCTop view] removeFromSuperview];
									   [AlertManager closeAlertViewWithBaseNameVC:baseNameVCTop];
									   
									   // 恢复VC的可用性
									   [[UIApplication sharedApplication] endIgnoringInteractionEvents];
								   }
										   inView:_view];
			}
			else
			{
				// 设置新的根节点
				[_arrayVCSubs addObject:baseNameVC];
				[_view addSubview:[baseNameVC view]];
				
				// 从逻辑数据中删除
				[self removeMaskViewWithBaseNameVC:baseNameVCTop];
				[self deleteMaskViewWithBaseNameVC:baseNameVCTop];
				[[baseNameVCTop view] removeFromSuperview];
				[AlertManager closeAlertViewWithBaseNameVC:baseNameVCTop];
				[_arrayVCSubs removeObject:baseNameVCTop];
			}
		
			return YES;
		}
		else
		{
			[_arrayVCSubs addObject:baseNameVC];
			[_view addSubview:[baseNameVC view]];
		}
	}
	else
	{
		// 添加到队列中
		NSMutableArray *arrayVCSubsNew = [[NSMutableArray alloc] init];
		[self setArrayVCSubs:arrayVCSubsNew];
        
        // 设置根VC
		[[baseNameVC view] setViewX:[VCManager getAppFrame].size.width - baseNameVC.view.frame.size.width];
        [arrayVCSubsNew addObject:baseNameVC];
        [_view addSubview:[baseNameVC view]];
	}
	
	return NO;
}

// 弹出节点然后压入节点
- (void)popToVC:(NSString *)vcName thenPushVC:(BaseNameVC *)baseNameVC WithAnimation:(id <VCAnimation>)animation
{
    // 加载View
	if ([baseNameVC isViewLoaded] == NO)
	{
		[baseNameVC view];
	}
    
    if (_arrayVCSubs != nil)
	{
		NSInteger subsCount = [_arrayVCSubs count];
		
		// 从上往下逐个遍历
		for (NSInteger i = 0; i < subsCount; i++)
		{
			BaseNameVC *baseNameVCBackNew = [_arrayVCSubs objectAtIndex:(subsCount - i - 1)];
            
			// 名称相同
			if ([[baseNameVCBackNew getVCName] isEqualToString:vcName] == YES)
			{
				if (i == 0)
				{
					// 跳转到当前VC，则直接Push即可
					[self pushVC:baseNameVC WithAnimation:animation];
					
					break;
				}
				
				// 最上层节点
				BaseNameVC *baseNameVCTop = [_arrayVCSubs objectAtIndex:(subsCount - 1)];
				
				// 下下个VC
				if ([[baseNameVCBackNew view] isDescendantOfView:_view])
				{
					NSInteger topIndex = [[_view subviews] indexOfObject:[baseNameVCTop view]];
					NSInteger backIndex = [[_view subviews] indexOfObject:[baseNameVCBackNew view]];
					
					[_view exchangeSubviewAtIndex:backIndex withSubviewAtIndex:topIndex-1];
				}
				else
				{
					[_view insertSubview:[baseNameVCBackNew view] belowSubview:[baseNameVCTop view]];
				}
				
				[[baseNameVCBackNew view] setViewX:(-baseNameVCBackNew.view.frame.size.width/3)];
				
				if (animation != nil)
				{
					[baseNameVCTop.view.layer removeAllAnimations];
					[baseNameVC.view.layer removeAllAnimations];
					
					// 禁用VC的可用性
					[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
					
					// 从逻辑数据中删除目标节点之前的节点
					for (NSInteger j = subsCount - 2; j >= subsCount - i; j--)
					{
						BaseNameVC *baseNameVCTmp = [_arrayVCSubs objectAtIndex:j];
						
						[self removeMaskViewWithBaseNameVC:baseNameVCTmp];
						[self deleteMaskViewWithBaseNameVC:baseNameVCTmp];
						[[baseNameVCTmp view] removeFromSuperview];
                        
						[AlertManager closeAlertViewWithBaseNameVC:baseNameVCTmp];
						[_arrayVCSubs removeObject:baseNameVCTmp];
					}
					
					[self setCurrentPopVC:baseNameVCTop];
					
                    // 从逻辑数据中删除
                    [self removeMaskViewWithBaseNameVC:baseNameVCTop];
                    [self deleteMaskViewWithBaseNameVC:baseNameVCTop];
                    [_arrayVCSubs removeObject:baseNameVCTop];
                    
					// 将新界面入栈
					[_arrayVCSubs addObject:baseNameVC];
                    [animation pushAnimationFromTopVC:baseNameVCTop
                                           ToArriveVC:baseNameVC
                                       WithCompletion:^(BOOL finished) {
										   [self setCurrentPopVC:nil];
										   
										   [[baseNameVCTop view] removeFromSuperview];
										   [AlertManager closeAlertViewWithBaseNameVC:baseNameVCTop];
										   
										   // 恢复VC的可用性
										   [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                      }
                                               inView:_view];
				}
				else
				{
                    // 循环删除目标节点之前的节点
					for (NSInteger j = subsCount - 1; j >= subsCount - i; j--)
                    {
						BaseNameVC *baseNameVCTmp = [_arrayVCSubs objectAtIndex:j];
						
						[self removeMaskViewWithBaseNameVC:baseNameVCTmp];
						[self deleteMaskViewWithBaseNameVC:baseNameVCTmp];
						[[baseNameVCTmp view] removeFromSuperview];
						[AlertManager closeAlertViewWithBaseNameVC:baseNameVCTmp];
						[_arrayVCSubs removeObject:baseNameVCTmp];
                    }
                    
					// 将Push进来的VC Add到view上
					[[baseNameVC view] setViewX:[VCManager getAppFrame].size.width - baseNameVC.view.frame.size.width];
                    // 设置新的根节点
                    [_arrayVCSubs addObject:baseNameVC];
                    [_view addSubview:[baseNameVC view]];
				}
			}
		}
	}
	else
	{
		// 添加到队列中
		NSMutableArray *arrayVCSubsNew = [[NSMutableArray alloc] init];
		[self setArrayVCSubs:arrayVCSubsNew];
        
        // 设置根VC
		[[baseNameVC view] setViewX:[VCManager getAppFrame].size.width - baseNameVC.view.frame.size.width];
        [arrayVCSubsNew addObject:baseNameVC];
        [_view addSubview:[baseNameVC view]];
	}
}

// 注意需要横划操作的控件需要在这里添加例外
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	BaseNameVC *topVC = [[VCManager mainVCC] getTopVC];
	
	if ([[touch view] isKindOfClass:[Switch class]])
	{
		return NO;
	}
	else if ([topVC respondsToSelector:@selector(viewCanRight:)])
	{
		return [topVC viewCanRight:[touch view]];
	}
	
	return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
	BaseNameVC *frontVC = [_arrayVCSubs lastObject];
	
	CGPoint location =  [gestureRecognizer locationInView:self.view];
	if (gestureRecognizer.state == UIGestureRecognizerStatePossible)
	{
		if (location.x > 100)
		{
			return NO;
		}
	}
	
	// 若VC当前不支持右滑操作则不处理
	if (!(frontVC.isCanRightPan))
	{
		return NO;
	}
	
	NSInteger vcCount = [_arrayVCSubs count];
	
	// 只有HomeVC时不允许进行右滑操作
	if (vcCount < 2)
	{
		return NO;
	}
	
    return YES;
}

@end
