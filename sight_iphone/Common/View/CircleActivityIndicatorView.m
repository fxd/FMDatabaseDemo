//
//  CircleActivityIndicatorView.m
//  CommonFramework
//
//  Created by qunar on 14-3-6.
//  Copyright (c) 2014年 Qunar.com. All rights reserved.
//

#import "CircleActivityIndicatorView.h"
 

@implementation CircleActivityIndicatorView

#pragma mark - Init Methods

- (void)dealloc
{
    
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 28, 28)];
    if (self)
	{
        [self sharedSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        [self sharedSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
	{
        [self sharedSetup];
    }
    return self;
}

- (void)sharedSetup
{
	_hidesWhenStopped = YES;
	
	[self setStyle:eCircleActivityBlueStyle];
}

- (void)setStyle:(CircleActivityIndicatorStyle)style
{
	_style = style;
	
	if (style == eCircleActivityBlueStyle)
	{
		UIImage *reloadImage = [UIImage imageNamed:kBlueCircleImageFile];
		[self setImage:reloadImage];
		
		[self setViewSize:CGSizeMake(reloadImage.size.width, reloadImage.size.height)];
	}
	else if (style == eCircleActivityWhiteStyle)
	{
		UIImage *reloadImage = [UIImage imageNamed:kWhiteCircleImageFile];
		[self setImage:reloadImage];
		
		[self setViewSize:CGSizeMake(reloadImage.size.width, reloadImage.size.height)];
	}
}

#pragma mark - Public Methods

- (void)setAnimating:(BOOL)animating
{
    _isAnimating = animating;
    if (_isAnimating)
	{
        [self startAnimating];
    }
	else
	{
        [self stopAnimating];
    }
}

- (BOOL)isAnimating
{
    CAAnimation *spinAnimation = [self.layer animationForKey:@"spinAnimation"];
    return (_isAnimating || spinAnimation);
}

- (void)startAnimating
{
    _isAnimating = YES;
    [self spin];
	
	[self setHidden:NO];
}

- (void)stopAnimating
{
    _isAnimating = NO;
	[self.layer removeAnimationForKey:@"spinAnimation"];
	
	[self setHidden:YES];
}

- (void)spin
{
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.byValue = [NSNumber numberWithFloat:2*M_PI];
    spinAnimation.duration = 1.0f;
    spinAnimation.delegate = self;
	spinAnimation.repeatCount = INT_MAX;
    [self.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}

#pragma mark - Animation Delegates

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	
}

- (void)removeFromSuperview
{
    [self stopAnimating];

	[super removeFromSuperview];
}

@end
