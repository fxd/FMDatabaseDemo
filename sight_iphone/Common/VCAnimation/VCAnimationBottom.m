//
//  VCAnimationBottom.m
//  QunariPhone
//
//  Created by 姜琢 on 13-9-10.
//  Copyright (c) 2013年 Qunar.com. All rights reserved.
//

#import "VCAnimationBottom.h"
#import "VCManager.h"
 

@implementation VCAnimationBottom

- (id)init
{
    self = [super init];
    if (self) {
        _animationDirection = eVCAnimtaionBottom;
    }
    return self;
}

- (instancetype)initWithDirection:(VCAnimtaionBottomDirection)direction
{
    self = [self init];
    if (self) {
        _animationDirection = direction;
    }
    return self;
}

+ (VCAnimationBottom *)defaultAnimation
{
    return [[VCAnimationBottom alloc] init];
}

- (void)pushAnimationFromTopVC:(UIViewController *)topVC
					ToArriveVC:(UIViewController *)arriveVC
				WithCompletion:(void (^)(BOOL finished))completion
						inView:(UIView *)view
{
	if ([[arriveVC view] isDescendantOfView:view] == NO)
	{
		[[arriveVC view] setViewX:0];
		
		if (_animationDirection == eVCAnimtaionBottom)
		{
			[[arriveVC view] setViewY:[[arriveVC view] frame].size.height];
		}
		else if (_animationDirection == eVCAnimtaionTop)
		{
			[[arriveVC view] setViewY:-[[arriveVC view] frame].size.height];
		}
		
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
                         [[arriveVC view] setViewY:[VCManager getAppFrame].origin.y];
						 
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
	}
	else
	{
		[arriveVC viewWillAppear:NO];
		
		arriveVCAppear = YES;
	}
	
	[[arriveVC view] setViewX:[VCManager getAppFrame].size.width - arriveVC.view.frame.size.width];
	
	if ([[backVC view] isDescendantOfView:view] == NO)
	{
		[view insertSubview:[backVC view] belowSubview:[arriveVC view]];
		[[backVC view] setViewX:0];
	}
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
						 if (_animationDirection == eVCAnimtaionBottom)
						 {
							 [[topVC view] setViewY:[[arriveVC view] frame].size.height];
						 }
						 else if (_animationDirection == eVCAnimtaionTop)
						 {
							 [[topVC view] setViewY:-[[arriveVC view] frame].size.height];
						 }
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
