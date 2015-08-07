//
//  MFSideMenu.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 10/22/12. 姜琢 edit on 12/06/12
//  Copyright (c) 2012 University of Wisconsin - Madison. All rights reserved.
//

#import "MFSideMenu.h"
#import "BaseNameVC+MFSideMenu.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "VCManager.h"
 

@interface MFSideMenu()
{
    CGPoint panGestureOrigin;
}

@property (nonatomic, assign, readwrite) BaseNameVC *mainBaseNameVC;
@property (nonatomic, assign, readwrite) UIViewController *sideMenuController;
@property (nonatomic, assign, readwrite) BaseNameVC *containerBaseNameVC;
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UIView *viewMask;

@property (nonatomic, assign) MFSideMenuLocation menuSide;
@property (nonatomic, assign) MFSideMenuOptions options;

// layout constraints for the sideMenuController
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;

@property (nonatomic, assign) CGFloat panGestureVelocity;

@end


@implementation MFSideMenu

@synthesize mainBaseNameVC;
@synthesize sideMenuController;
@synthesize containerBaseNameVC;
@synthesize viewMask;
@synthesize menuSide;
@synthesize options;
@synthesize topConstraint;
@synthesize rightConstraint;
@synthesize bottomConstraint;
@synthesize leftConstraint;
@synthesize panGestureVelocity;
@synthesize menuState = _menuState;
@synthesize menuStateEventBlock;

#pragma mark - Menu Creation

+ (MFSideMenu *) menuWithBaseNameVC:(BaseNameVC *)controller
				 sideMenuController:(id)menuController
						containerVC:(BaseNameVC *)containerVC
{
    return [MFSideMenu menuWithBaseNameVC:controller
					   sideMenuController:menuController
							  containerVC:containerVC
								 location:MFSideMenuLocationLeft];
}

+ (MFSideMenu *) menuWithBaseNameVC:(BaseNameVC *)controller
				 sideMenuController:(UIViewController *)menuController
						containerVC:(BaseNameVC *)containerVC
						   location:(MFSideMenuLocation)side
{
	if ([menuController isViewLoaded] == NO)
	{
		[menuController view];
	}
	
    MFSideMenu *menu = [[MFSideMenu alloc] init];
    menu.mainBaseNameVC = controller;
    menu.sideMenuController = menuController;
	menu.containerBaseNameVC = containerVC;
    menu.menuSide = side;
	menu.sideOffset = menuController.view.frame.size.width;
    controller.sideMenuView = menu;
	
	CGRect rootVCframe = controller.view.frame;
	menu.viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rootVCframe.size.width, rootVCframe.size.height)];
    
    menu.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:menu
																 action:@selector(viewControllerPanned:)];
	[menu.panRecognizer setMaximumNumberOfTouches:1];
    [menu.panRecognizer setDelegate:menu];
	[menu.panRecognizer setEnabled:NO];
    [controller.view addGestureRecognizer:menu.panRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:menu
																					action:@selector(viewControllerTapped:)];
    [tapRecognizer setDelegate:menu];
    [controller.view addGestureRecognizer:tapRecognizer];
    
    return menu;
}

#pragma mark - BaseNameVC Controller View Lifecycle

- (void)viewControllerWillAppear
{
    [self setMenuState:MFSideMenuStateHidden];
}

- (void)viewControllerDidAppear
{
    UIView *menuView = self.sideMenuController.view;
    if (menuView.superview)
	{
		return;
	}
    
    UIView *containerView = containerBaseNameVC.view;
    
	CGRect appFrame = [VCManager getAppFrame];
	if ([containerView isKindOfClass:[UIWindow class]])
	{
		[menuView setViewOrigin:CGPointMake(containerView.frame.size.width - menuView.frame.size.width, appFrame.origin.y)];
	}
	else if ([containerView isKindOfClass:[UIView class]])
	{
		[menuView setViewOrigin:CGPointMake(containerView.frame.size.width - menuView.frame.size.width, 0)];
	}
	
    [containerView addSubview:menuView];
	[containerView sendSubviewToBack:menuView];
	
	[self drawRootControllerShadowPath];
	self.rootViewController.view.layer.shadowOpacity = 0.6f;
	self.rootViewController.view.layer.shadowRadius = kMFSideMenuShadowWidth;
	self.rootViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)viewControllerDidDisappear
{
    // we don't want the menu to be visible if the navigation controller is gone
    if (self.sideMenuController.view && self.sideMenuController.view.superview)
	{
        [self.sideMenuController.view removeFromSuperview];
    }
}

#pragma mark - UIBarButtonItems & Callbacks

- (void)showSideMenu
{
    if (self.menuState == MFSideMenuStateVisible)
	{
        [self setMenuState:MFSideMenuStateHidden];
    }
	else
	{
        [self setMenuState:MFSideMenuStateVisible];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) return NO;
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
		self.menuState != MFSideMenuStateHidden)
	{
		return YES;
	}
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] &&
		self.menuState != MFSideMenuStateHidden)
	{
		return YES;
    }
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
		self.menuState == MFSideMenuStateHidden)
	{
		return NO;
	}
	
    return YES;
}

#pragma mark - UIGestureRecognizer Callbacks

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    //[[self.sideMenuController view] setHidden:NO];
    UIView *view = self.rootViewController.view;
    
	if (recognizer.state == UIGestureRecognizerStateBegan)
	{
        // remember where the pan started
        panGestureOrigin = view.frame.origin;
	}
    
    CGPoint translatedPoint = [recognizer translationInView:view];
    CGPoint adjustedOrigin = panGestureOrigin;
    translatedPoint = CGPointMake(adjustedOrigin.x + translatedPoint.x,
                                  adjustedOrigin.y + translatedPoint.y);
    
    if (self.menuSide == MFSideMenuLocationLeft)
	{
        translatedPoint.x = MIN(translatedPoint.x, _sideOffset);
        translatedPoint.x = MAX(translatedPoint.x, 0);
    }
	else
	{
        translatedPoint.x = MAX(translatedPoint.x, -1 * _sideOffset);
        translatedPoint.x = MIN(translatedPoint.x, 0);
    }
    
	[view setViewX:translatedPoint.x];
    
	if (recognizer.state == UIGestureRecognizerStateEnded)
	{
        CGPoint velocity = [recognizer velocityInView:view];
        CGFloat finalX = translatedPoint.x + (.35*velocity.x);
        CGFloat viewWidth = view.frame.size.width;
        
        if (self.menuState == MFSideMenuStateHidden)
		{
            BOOL showMenu = (self.menuSide == MFSideMenuLocationLeft) ? (finalX > viewWidth/2) : (finalX < -1*viewWidth/2);
            if (showMenu)
			{
                self.panGestureVelocity = velocity.x;
                [self setMenuState:MFSideMenuStateVisible];
            }
			else
			{
                self.panGestureVelocity = 0;
				
				[UIView animateWithDuration:0.0f
								 animations:^{
									 [view setViewX:0];
								 }];
            }
        }
		else if (self.menuState == MFSideMenuStateVisible)
		{
            BOOL hideMenu = (self.menuSide == MFSideMenuLocationLeft) ? (finalX < adjustedOrigin.x) : (finalX > adjustedOrigin.x);
            if (hideMenu)
			{
                self.panGestureVelocity = velocity.x;
                [self setMenuState:MFSideMenuStateHidden];
            }
			else
			{
                self.panGestureVelocity = 0;
				
				[UIView animateWithDuration:0.0f
								 animations:^{
									 [view setViewX:adjustedOrigin.x];
								 }];
            }
        }
	}
}

- (void)viewControllerTapped:(id)sender
{
    if (self.menuState != MFSideMenuStateHidden)
	{
        [self setMenuState:MFSideMenuStateHidden];
    }
}

- (void)viewControllerPanned:(id)sender
{
    [self handlePanGesture:sender];
}

#pragma mark - Menu State & Open/Close Animation

- (void)setMenuState:(MFSideMenuState)menuState
{
    MFSideMenuState currentState = _menuState;
    _menuState = menuState;
    
    switch (currentState)
	{
        case MFSideMenuStateHidden:
		{
            if (menuState == MFSideMenuStateVisible)
			{
				[self.mainBaseNameVC.view addSubview:viewMask];
				
				[self.containerBaseNameVC setIsCanRightPan:NO];
				
				[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
				
                [self toggleSideMenuHidden:NO];
            }
			
			[_panRecognizer setEnabled:YES];
		}
            break;
			
        case MFSideMenuStateVisible:
		{
            if (menuState == MFSideMenuStateHidden)
			{
				[viewMask removeFromSuperview];
				
				[self.containerBaseNameVC setIsCanRightPan:YES];
				
				[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
				
                [self toggleSideMenuHidden:YES];
            }
			
			[_panRecognizer setEnabled:NO];
		}
            break;
			
        default:
            break;
    }
}

// menu open/close animation
- (void)toggleSideMenuHidden:(BOOL)hidden
{
    // notify that the menu state event is starting
    [self sendMenuStateEventNotification:(hidden ? MFSideMenuStateEventMenuWillClose : MFSideMenuStateEventMenuWillOpen)];
    
    CGFloat x = ABS(self.rootViewController.view.frame.origin.x);
    
    CGFloat viewControllerXPosition = (self.menuSide == MFSideMenuLocationLeft) ? _sideOffset : -1 * _sideOffset;
    CGFloat animationPositionDelta = (hidden) ? x : (viewControllerXPosition  - x);
    
    CGFloat duration;
    
    if (ABS(self.panGestureVelocity) > 1.0)
	{
        // try to continue the animation at the speed the user was swiping
        duration = animationPositionDelta / ABS(self.panGestureVelocity);
    }
	else
	{
        // no swipe was used, user tapped the bar button item
        CGFloat animationDurationPerPixel = kMFSideMenuAnimationDuration / viewControllerXPosition;
        duration = animationDurationPerPixel * animationPositionDelta;
    }
    
    if (duration > kMFSideMenuAnimationMaxDuration)
	{
		duration = kMFSideMenuAnimationMaxDuration;
	}
    
    [UIView animateWithDuration:duration
					 animations:^{
						 CGFloat xPosition = (hidden) ? 0 : viewControllerXPosition;
						 [self.rootViewController.view setViewX:xPosition];
					 }
					 completion:^(BOOL finished) {
						 // notify that the menu state event is done
						 [self sendMenuStateEventNotification:(hidden ? MFSideMenuStateEventMenuDidClose : MFSideMenuStateEventMenuDidOpen)];
						 
						 if ((_delegate != nil) && ([_delegate conformsToProtocol:@protocol(MFSideMenuPtc)]))
						 {
							 [_delegate sideMenuDidDismiss:self];
						 }
					 }];
}

- (void)sendMenuStateEventNotification:(MFSideMenuStateEvent)event
{
    if (self.menuStateEventBlock)
	{
		self.menuStateEventBlock(event);
	}
}

#pragma mark - Root Controller

- (UIViewController *) rootViewController {
    return self.mainBaseNameVC;
}

// draw a shadow between the navigation controller and the menu
- (void) drawRootControllerShadowPath
{
    CGRect pathRect = self.rootViewController.view.bounds;
    if (self.menuSide == MFSideMenuLocationRight)
	{
        // draw the shadow on the right hand side of the viewController
        pathRect.origin.x = pathRect.size.width - kMFSideMenuShadowWidth;
    }
    pathRect.size.width = kMFSideMenuShadowWidth;
    
    self.rootViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:pathRect].CGPath;
}

@end
