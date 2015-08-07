//
//  Switch.m
//  SevenSwitchExample
//
//  Created by Qunar on 14-1-24.
//  Copyright (c) 2014年 Ben Vogelzang. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "Switch.h"
#import <QuartzCore/QuartzCore.h>
 
#define kSwitchSelfWidth			              50
#define kSwitchSelfHeight			              30


@interface Switch ()
{
    UIView *background;
    UIView *knob;
    UIImageView *onImageView;
    UIImageView *offImageView;
    BOOL currentVisualValue;
    BOOL startTrackingValue;
    BOOL didChangeWhileTracking;
    BOOL isAnimating;
}

// 开闭状态
@property (nonatomic, assign) BOOL isOn;

// 关闭状态时的背景色
@property (nonatomic, strong) UIColor *inactiveColor;
@property (nonatomic, strong) UIColor *activeColor;

// 开启状态时的背景色
@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *onColor __deprecated;

// 关闭状态时的边框色
@property (nonatomic, strong) UIColor *borderColor;

// 按钮的颜色
@property (nonatomic, strong) UIColor *thumbTintColor;
@property (nonatomic, strong) UIColor *knobColor __deprecated;
@property (nonatomic, strong) UIColor *shadowColor;

// 设置是否圆角
@property (nonatomic, assign) BOOL isRounded;

@property (nonatomic, strong) UIImage *onImage;
@property (nonatomic, strong) UIImage *offImage;


- (void)showOn:(BOOL)animated;
- (void)showOff:(BOOL)animated;
- (void)setup;

@end


@implementation Switch
@synthesize inactiveColor, activeColor, onTintColor, borderColor, thumbTintColor, shadowColor;
@synthesize onImage, offImage;
@synthesize isRounded;
@synthesize isOn;

// =======================================================================
#pragma mark init Methods
// ===================================================================

- (id)initWithFrame:(CGRect)frame
{
    CGRect initialFrame;
    if (CGRectIsEmpty(frame))
    {
        initialFrame = CGRectMake(0, 0, kSwitchSelfWidth, kSwitchSelfHeight);
    }
    else
    {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self)
    {
        [self setup];
    }
    return self;
}


// 设置默认背景、按钮等的色值
- (void)setup
{
    // 默认的颜色值
    self.isOn = NO;
    self.isRounded = YES;
    self.inactiveColor = [UIColor clearColor];
    self.activeColor = [UIColor qunarBlueColor];
    self.onTintColor = [UIColor qunarBlueColor];
    self.borderColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.91f alpha:1.00f];
    self.thumbTintColor = [UIColor whiteColor];
    self.shadowColor = [UIColor grayColor];
    
    currentVisualValue = NO;
    
    // 背景底图
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    background.backgroundColor = [UIColor clearColor];
    background.layer.cornerRadius = self.frame.size.height * 0.5;
    background.layer.borderColor = self.borderColor.CGColor;
    background.layer.borderWidth = 1.0;
    background.userInteractionEnabled = NO;
	background.clipsToBounds = YES;
    [self addSubview:background];
    
    // 图片
    onImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    onImageView.alpha = 0;
    onImageView.contentMode = UIViewContentModeCenter;
    [background addSubview:onImageView];
    
    offImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.height, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    offImageView.alpha = 1.0;
    offImageView.contentMode = UIViewContentModeCenter;
    [background addSubview:offImageView];
	
	
    
    // 按钮
    knob = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.height - 2, self.frame.size.height - 2)];
    knob.backgroundColor = self.thumbTintColor;
    knob.layer.cornerRadius = (self.frame.size.height * 0.5) - 1;
    knob.layer.shadowColor = self.shadowColor.CGColor;
    knob.layer.shadowRadius = 2.0;
    knob.layer.shadowOpacity = 0.5;
    knob.layer.shadowOffset = CGSizeMake(0, 3);
    knob.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:knob.bounds cornerRadius:knob.layer.cornerRadius].CGPath;
    knob.layer.masksToBounds = NO;
    knob.userInteractionEnabled = NO;
    [self addSubview:knob];
    
    isAnimating = NO;
}


// 初始化
- (id)initWithOrigin:(CGPoint)origin
{
    CGRect initialFrame = CGRectMake(origin.x, origin.y, kSwitchSelfWidth, kSwitchSelfHeight);
    self = [super initWithFrame:initialFrame];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

// 设置Frame
- (void)setFrame:(CGRect)frameNew
{
	[super setFrame:CGRectMake(frameNew.origin.x, frameNew.origin.y, kSwitchSelfWidth, kSwitchSelfHeight)];
}


// 获取Switch的高宽
+ (CGSize)switchSize
{
	return CGSizeMake(kSwitchSelfWidth, kSwitchSelfHeight);
}


// =====================================================================
#pragma mark Touch Tracking
// ======================================================================

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    startTrackingValue = self.isOn;
    didChangeWhileTracking = NO;
    
    // make the knob larger and animate to the correct color
    CGFloat activeKnobWidth = self.bounds.size.height - 2 + 5;
    isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (self.isOn)
        {
            knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
            background.backgroundColor = self.onTintColor;
        }
        else
        {
            knob.frame = CGRectMake(knob.frame.origin.x, knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
            background.backgroundColor = self.activeColor;
        }
    } completion:^(BOOL finished)
     {
        isAnimating = NO;
    }];
    
    return YES;
}



- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    // Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    // update the switch to the correct visuals depending on if
    // they moved their touch to the right or left side of the switch
    if (lastPoint.x > self.bounds.size.width * 0.5)
    {
        [self showOn:YES];
        if (!startTrackingValue)
        {
            didChangeWhileTracking = YES;
        }
    }
    else
    {
        [self showOff:YES];
        if (startTrackingValue)
        {
            didChangeWhileTracking = YES;
        }
    }
    
    return YES;
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    BOOL previousValue = self.isOn;
    
    if (didChangeWhileTracking)
    {
        [self setOn:currentVisualValue animated:YES];
    }
    else
    {
        [self setOn:!self.isOn animated:YES];
    }
    
    if (previousValue != self.isOn)
    {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}


- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [super cancelTrackingWithEvent:event];
    
    // just animate back to the original value
    if (self.isOn)
    {
        [self showOn:YES];
    }
    else
    {
        [self showOff:YES];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!isAnimating)
    {
        CGRect frame = self.frame;
        
        // 背景底图
        background.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        background.layer.cornerRadius = self.isRounded ? frame.size.height * 0.5 : 2;
        
        // 图片
        onImageView.frame = CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height);
        offImageView.frame = CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height);
        
        // 按钮
        CGFloat normalKnobWidth = frame.size.height - 2;
        if (self.isOn)
        {
            knob.frame = CGRectMake(frame.size.width - (normalKnobWidth + 1), 1, frame.size.height - 2, normalKnobWidth);
        }
        else
        {
            knob.frame = CGRectMake(1, 1, normalKnobWidth, normalKnobWidth);
        }
        
        knob.layer.cornerRadius = self.isRounded ? (frame.size.height * 0.5) - 1 : 2;
    }
}


// 设置控件开闭状态
- (void)setOn:(BOOL)onNew animated:(BOOL)animated
{
    isOn = onNew;
    
    if (isOn)
    {
        [self showOn:animated];
    }
    else
    {
        [self showOff:animated];
    }
}



// 获取开关状态
- (BOOL)on
{
    return self.isOn;
}

// 关闭状态背景色
- (void)setInactiveColor:(UIColor *)color
{
	inactiveColor = color;
	
	[self setNeedsLayout];
}

- (void)setActiveColor:(UIColor *)color
{
	activeColor = color;
	
	[self setNeedsLayout];
}

// 开启状态背景色
- (void)setOnTintColor:(UIColor *)color
{
	onTintColor = color;
	
	[self setNeedsLayout];
}

// ====================================================================
#pragma mark State Changes
// ===================================================================

// 开启控件时的动画处理
- (void)showOn:(BOOL)animated
{
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated)
    {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking)
                knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
            else
                knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
            background.backgroundColor = self.onTintColor;
            background.layer.borderColor = self.onTintColor.CGColor;
            onImageView.alpha = 1.0;
            offImageView.alpha = 0;
        }
        completion:^(BOOL finished)
        {
             isAnimating = NO;
         }];
    }
    else
    {
        if (self.tracking)
            knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
        else
            knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
        background.backgroundColor = self.onTintColor;
        background.layer.borderColor = self.onTintColor.CGColor;
        onImageView.alpha = 1.0;
        offImageView.alpha = 0;
    }
    
    currentVisualValue = YES;
}


// 关闭控件时的动画处理
- (void)showOff:(BOOL)animated
{
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated)
    {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking)
            {
                knob.frame = CGRectMake(1, knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
                background.backgroundColor = self.activeColor;
            }
            else
            {
                knob.frame = CGRectMake(1, knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
                background.backgroundColor = self.inactiveColor;
            }
            background.layer.borderColor = self.borderColor.CGColor;
            onImageView.alpha = 0;
            offImageView.alpha = 1.0;
        } completion:^(BOOL finished)
         {
             isAnimating = NO;
         }];
    }
    else
    {
        if (self.tracking)
        {
            knob.frame = CGRectMake(1, knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
            background.backgroundColor = self.activeColor;
        }
        else
        {
            knob.frame = CGRectMake(1, knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
            background.backgroundColor = self.inactiveColor;
        }
        background.layer.borderColor = self.borderColor.CGColor;
        onImageView.alpha = 0;
        offImageView.alpha = 1.0;
    }
    
    currentVisualValue = NO;
}

// 交互统计
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
	[super sendAction:action to:target forEvent:event];
	
}

@end