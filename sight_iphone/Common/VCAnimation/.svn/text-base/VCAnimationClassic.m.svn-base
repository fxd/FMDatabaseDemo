//
//  VCPushAnimation.m
//  QunariPhone
//
//  Created by 姜琢 on 12-11-12.
//  Copyright (c) 2012年 Qunar.com All rights reserved.
//

#import "VCAnimationClassic.h"
#import "VCManager.h"
 

@implementation VCAnimationClassic

+ (VCAnimationClassic *)defaultAnimation
{
    return [[VCAnimationClassic alloc] init];
}

- (void)pushAnimationFromTopVC:(UIViewController *)topVC
					ToArriveVC:(UIViewController *)arriveVC
				WithCompletion:(void (^)(BOOL finished))completion
						inView:(UIView *)view
{
	if ([[arriveVC view] isDescendantOfView:view] == NO)
	{
		[[arriveVC view] setViewX:[[arriveVC view] frame].size.width];
		[view addSubview:[arriveVC view]];
	}
	else
	{
		[view bringSubviewToFront:[arriveVC view]];
	}
	
	[topVC viewWillDisappear:NO];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [[topVC view] setViewX:(-topVC.view.frame.size.width/3)];
                         [[arriveVC view] setViewX:[VCManager getAppFrame].size.width - arriveVC.view.frame.size.width];
						 
						 [topVC viewDidDisappear:NO];
                     }
                     completion:completion];
}

- (void)popAnimationFromTopVC:(UIViewController *)topVC
				   ToArriveVC:(UIViewController *)arriveVC
					AndBackVC:(UIViewController *)backVC
			   WithCompletion:(void (^)(BOOL finished))completion
					   inView:(UIView *)view
{
	BOOL arriveVCAppear = NO;
	
	if ([[arriveVC view] isDescendantOfView:view] == NO)
	{
		[view insertSubview:[arriveVC view] belowSubview:[topVC view]];
		[[arriveVC view] setViewX:(-arriveVC.view.frame.size.width/3)];
	}
	else
	{
		[arriveVC viewWillAppear:NO];
		
		arriveVCAppear = YES;
	}
	
	if ([[backVC view] isDescendantOfView:view] == NO)
	{
		[view insertSubview:[backVC view] belowSubview:[arriveVC view]];
		[[backVC view] setViewX:(-backVC.view.frame.size.width/3)];
	}
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [[topVC view] setViewX:[VCManager getAppFrame].size.width];
                         [[arriveVC view] setViewX:[VCManager getAppFrame].size.width - arriveVC.view.frame.size.width];
                     }
                     completion:^(BOOL finished) {
						 
						 completion(finished);
						 
						 if (arriveVCAppear)
						 {
							 [arriveVC viewDidAppear:NO];
						 }
					 }];
}

@end
