//
//  UIView+Utility.m
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import "UIView+Utility.h"
#import "AppDelegate.h"
#import <sys/utsname.h>
#import "UIImage+Utility.h"
#import "SUIButton.h"

// Remove GSEvent and UITouchAdditions from Release builds
#ifdef DEBUG

/**
 * A private API class used for synthesizing touch events. This class is compiled out of release
 * builds.
 *
 * This code for synthesizing touch events is derived from:
 * http://cocoawithlove.com/2008/10/synthesizing-touch-event-on-iphone.html
 */
@interface GSEventFake : NSObject {
@public
    int ignored1[5];
    float x;
    float y;
    int ignored2[24];
}
@end

@implementation GSEventFake
@end



@interface UIEventFake : NSObject {
@public
    CFTypeRef               _event;
    NSTimeInterval          _timestamp;
    NSMutableSet*           _touches;
    CFMutableDictionaryRef  _keyedTouches;
}

@end

@implementation UIEventFake

@end


@implementation UIEvent (Utility)

- (id)initWithTouch:(UITouch *)touch {
    self = [super init];
    if (self) {
        UIEventFake *selfFake = (UIEventFake*)self;
        selfFake->_touches = [NSMutableSet setWithObject:touch];
        selfFake->_timestamp = [NSDate timeIntervalSinceReferenceDate];
        
        CGPoint location = [touch locationInView:touch.window];
        GSEventFake* fakeGSEvent = [[GSEventFake alloc] init];
        fakeGSEvent->x = location.x;
        fakeGSEvent->y = location.y;
        selfFake->_event = (__bridge CFTypeRef)(fakeGSEvent);
        
        CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 2,
                                                                &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionaryAddValue(dict, (__bridge const void *)(touch.view), (__bridge const void *)(selfFake->_touches));
        CFDictionaryAddValue(dict, (__bridge const void *)(touch.window), (__bridge const void *)(selfFake->_touches));
        selfFake->_keyedTouches = dict;
    }
    return self;
}


@end

#endif

#define kScaleMin                           0.007f
#define kScaleDefault                       1.0f
#define kScaleDelta                         0.05f


#define kFirstAnimateTime                   0.3f
#define kSecondAnimateTime                  0.2f

#define kMaskViewFinalAlpha                 0.2f    //背景的透明度

@interface ViewInfo : NSObject{
    AnimateType     aType;              //动画类型
    UIView          *displayView;       //显示页面
    CGRect          displayRect;        //显示的位置
    UIControl       *maskView;          //遮挡页面
    void            (^showBlock)(BOOL finished);
    void            (^hideBlock)(BOOL finished);
}

@property (retain, nonatomic)   UIView          *displayView;
@property (assign, nonatomic)   AnimateType     aType;
@property (assign, nonatomic)   CGRect          displayRect;
@property (retain, nonatomic)   UIControl       *maskView;
@property (copy, nonatomic)     void            (^showBlock)(BOOL finished);
@property (copy, nonatomic)     void            (^hideBlock)(BOOL finished);
@end

@implementation ViewInfo

@synthesize displayView,aType,maskView,displayRect,showBlock,hideBlock;

@end


UIInterfaceOrientation QTInterfaceOrientation() {
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    return orient;
}

CGRect QTScreenBounds() {
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape(QTInterfaceOrientation())) {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    return bounds;
}


@implementation UIView (Utility)

// 设置UIView的X
- (void)setViewX:(CGFloat)newX
{
    CGRect viewFrame = [self frame];
    viewFrame.origin.x = newX;
    [self setFrame:viewFrame];
}

// 设置UIView的Y
- (void)setViewY:(CGFloat)newY
{
    CGRect viewFrame = [self frame];
    viewFrame.origin.y = newY;
    [self setFrame:viewFrame];
}

// 设置UIView的Origin
- (void)setViewOrigin:(CGPoint)newOrigin
{
    CGRect viewFrame = [self frame];
    viewFrame.origin = newOrigin;
    [self setFrame:viewFrame];
}

// 设置UIView的width
- (void)setViewWidth:(CGFloat)newWidth
{
    CGRect viewFrame = [self frame];
    viewFrame.size.width = newWidth;
    [self setFrame:viewFrame];
}

// 设置UIView的height
- (void)setViewHeight:(CGFloat)newHeight
{
    CGRect viewFrame = [self frame];
    viewFrame.size.height = newHeight;
    [self setFrame:viewFrame];
}

// 设置UIView的Size
- (void)setViewSize:(CGSize)newSize
{
    CGRect viewFrame = [self frame];
    viewFrame.size = newSize;
    [self setFrame:viewFrame];
}

- (NSString *)subViewsTextForStatistics
{
    NSMutableArray *arraySubText = [NSMutableArray array];
    for (UIView *subView in [self subviews])
    {
        if ([subView isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)subView;
            NSString *labelText = [label text];
            if (labelText != nil && [labelText length] > 0)
            {
                [arraySubText addObject:labelText];
            }
        }
        else if ([subView isKindOfClass:[UIButton class]] || [subView isKindOfClass:[SUIButton class]])
        {
            UIButton *button = (UIButton *)subView;
            NSString *buttonTitle = [[button titleLabel] text];
            if (buttonTitle != nil && [buttonTitle length] > 0)
            {
                [arraySubText addObject:buttonTitle];
            }
        }
    }
    
    return [arraySubText componentsJoinedByString:@","];;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

//将图片移动到左边
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat)top {
    return self.frame.origin.y;
}


//设置view的top的位置
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat)right {
    return self.left + self.width;
}


- (void)setRight:(CGFloat)right {
    if(right == self.right){
        return;
    }
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


- (CGFloat)bottom {
    return self.top + self.height;
}


//设置view底部的位置
- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)centerX {
    return self.center.x;
}


- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat)centerY {
    return self.center.y;
}


- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)width {
    return self.frame.size.width;
}


- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)height {
    return self.frame.size.height;
}


- (void)setHeight:(CGFloat)height {
    if(height == self.height){
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}


- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGSize)size {
    return self.frame.size;
}


- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (id)subviewWithTag:(NSInteger)tag{
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    return nil;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


- (UIViewController*)viewController:(Class)class {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:class]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UIView*)view:(Class)class {
    for (UIView* next = [self superview]; next; next = next.superview) {
        if ([next isKindOfClass:class]) {
            return (UIView*)next;
        }
    }
    return nil;
}

- (CGFloat)ttScreenX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

- (CGFloat)ttScreenY {
    CGFloat y = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

- (CGFloat)screenViewX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0.0f, y = 0.0f;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}



-(CGPoint)boundsCenter
{
    return CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
}


static NSMutableArray   *displayViewAry;   //已显示的页面数组

#pragma mark - 获取顶部View
+ (AppDelegate *)getAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
+ (UIView *)getTopView{
    UIViewController *vc = [[VCManager mainVCC] getVC:@"SingleChatVC"];
    return  vc.view;
}

#pragma mark - 顶层maskView触摸
+ (void)setTopMaskViewCanTouch:(BOOL)_canTouch{
    ViewInfo *info = [displayViewAry lastObject];
    if (_canTouch)
        [info.maskView addTarget:self action:@selector(maskViewTouch) forControlEvents:UIControlEventTouchUpInside];
    else
        [info.maskView removeTarget:self action:@selector(maskViewTouch) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 下面的增加了完成块
/**
 显示view
 @param _view 需要显示的view
 @param _aType 动画类型
 @param _fRect 最终位置
 @param completion 动画块
 */
+ (void)showView:(UIView*)_view animateType:(AnimateType)_aType finalRect:(CGRect)_fRect completion:(void(^)(BOOL finished))completion{
    //初始化页面数组
    if (displayViewAry == nil)
        displayViewAry = [[NSMutableArray alloc]init];
    
    UIView *topView = [UIView getTopView];
    
    //存储页面信息
    ViewInfo *info = [[ViewInfo alloc]init];
    info.displayView = _view;
    info.aType = _aType;
    info.displayRect = _fRect;
    
    //初始化遮罩页面
    UIControl *maskView = [[UIControl alloc]init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0;
    maskView.frame = topView.bounds;
    [maskView addTarget:self action:@selector(maskViewTouch) forControlEvents:UIControlEventTouchUpInside];
    //添加页面
    [topView addSubview:maskView];
    [topView bringSubviewToFront:maskView];
    
    info.maskView = maskView;
    // [maskView release];
    
    if (completion)
        info.showBlock = completion;
    
    [displayViewAry addObject:info];
    // [info release];
    
    
    //根据不同的动画类型显示
    switch (_aType) {
        case AnimateTypeOfTV:
            [UIView showTV];
            break;
        case AnimateTypeOfPopping:
            [UIView showPopping];
        default:
            break;
    }
}
/**
 显示view
 @param _view 需要显示的view
 @param _aType 动画类型
 @param _fRect 最终位置
 */
+ (void)showView:(UIView*)_view animateType:(AnimateType)_aType finalRect:(CGRect)_fRect{
    [self showView:_view animateType:_aType finalRect:_fRect completion:nil];
}


#pragma mark - 消失view

+ (void)hideViewByCompletion:(void(^)(BOOL finished))completion{
    if ([displayViewAry count] > 0){
        ViewInfo *info = [displayViewAry lastObject];
        if (completion)
            info.hideBlock = completion;
    }
    [UIView maskViewTouch];
}
+ (void)hideViewByType:(AnimateType)_aType completion:(void(^)(BOOL finished))completion{
    if ([displayViewAry count] > 0){
        ViewInfo *info = [displayViewAry lastObject];
        info.aType = _aType;
        if (completion)
            info.hideBlock = completion;
    }
    [UIView maskViewTouch];
}
//
+ (void)hideView{
    [UIView hideViewByCompletion:nil];
}
+ (void)hideViewByType:(AnimateType)_aType{
    [UIView hideViewByType:_aType completion:nil];
}

#pragma mark - 触摸背景
+ (void)maskViewTouch{
    if ([displayViewAry count] > 0){
        ViewInfo *info = [displayViewAry lastObject];
        
        //根据不同类型隐藏
        switch (info.aType) {
            case AnimateTypeOfTV:
                [UIView hideTV];
                break;
            case AnimateTypeOfPopping:
                [UIView hidePopping];
                break;
            default:
                break;
        }
    }
}
#pragma mark - 移除遮罩和已显示页面
+ (void)removeMaskViewAndDisplay:(ViewInfo*)info{
    if (info.aType == AnimateTypeOfTV || info.aType == AnimateTypeOfPopping)  //TV,Popping 类型需要还原
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleDefault);
    
    [info.displayView removeFromSuperview];
    [info.maskView removeFromSuperview];
    [displayViewAry removeObject:info];
}

#pragma mark - 显示动画

#pragma mark - TV 显示
+ (void)showTV{
    ViewInfo *info = [displayViewAry lastObject];
    UIView *topView = [UIView getTopView];
    info.displayView.frame = info.displayRect;
    [topView addSubview:info.displayView];
    [topView bringSubviewToFront:info.displayView];
    
    info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
    
    //开始动画
    [UIView animateWithDuration:kSecondAnimateTime animations:^{
        info.maskView.alpha = 0.1f;
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleMin);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:kFirstAnimateTime animations:^{
            info.maskView.alpha = kMaskViewFinalAlpha;
            info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleDefault);
        }completion:^(BOOL finish){
            //调用完成动画块
            if (info.showBlock)
                info.showBlock(finish);
        }];
    }];
}
#pragma mark - TV 消失
+ (void)hideTV{
    
    ViewInfo *info = [displayViewAry lastObject];
    
    [UIView animateWithDuration:kSecondAnimateTime animations:^{
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleMin);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:kFirstAnimateTime animations:^{
            info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
            info.maskView.alpha = 0;
        }completion:^(BOOL finish){
            //调用完成动画块
            if (info.hideBlock)
                info.hideBlock(finish);
            [UIView removeMaskViewAndDisplay:info];
        }];
    }];
}

#pragma mark - Popping 显示
+ (void)showPopping{
    ViewInfo *info = [displayViewAry lastObject];
    UIView *topView = [UIView getTopView];
    info.displayView.frame = info.displayRect;
    [topView addSubview:info.displayView];
    [topView bringSubviewToFront:info.displayView];
    
    info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
    
    //开始动画
    [UIView animateWithDuration:kFirstAnimateTime animations:^{
        info.maskView.alpha = kMaskViewFinalAlpha;
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault+kScaleDelta, kScaleDefault+kScaleDelta);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:kSecondAnimateTime animations:^{
            info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault-kScaleDelta, kScaleDefault-kScaleDelta);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:kSecondAnimateTime animations:^{
                info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleDefault);
            }completion:^(BOOL finish){
                //调用完成动画块
                if (info.showBlock)
                    info.showBlock(finish);
            }];
        }];
    }];
}
#pragma mark - Popping 消失
+ (void)hidePopping{
    ViewInfo *info = [displayViewAry lastObject];
    
    [UIView animateWithDuration:kFirstAnimateTime animations:^{
        info.maskView.alpha = 0;
        info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
    }completion:^(BOOL finish){
        //调用完成动画块
        if (info.hideBlock)
            info.hideBlock(finish);
        [UIView removeMaskViewAndDisplay:info];
    }];
}


+ (instancetype)viewFromXib {
    NSBundle* bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"s" withExtension:@"bundle"]];
    NSString* className = NSStringFromClass([self class]);
    return [[bundle loadNibNamed:className owner:nil options:nil] objectAtIndexSafe:0];
}

- (void)frameCompatibleHeight:(CGRect)rect
{
    self.frame = rect;
    [self setHeight:ceil(self.height * ([UIScreen mainScreen].bounds.size.width / 320))];
    
}

- (void)frameCompatibleSize:(CGRect)rect
{
    self.frame = rect;
    
    NSInteger wid = (NSInteger)[UIScreen mainScreen].bounds.size.width;
    
    if (wid != 320) {
        CGFloat rate = [UIScreen mainScreen].bounds.size.width / 320;
        [self setSize:CGSizeMake(ceil(self.width * rate), ceil(self.height * rate))];
    }
    
}

+ (CGFloat)compatibleLength:(CGFloat)length {
    if (([UIScreen mainScreen].bounds.size.width) == 320) {
        return length;
    }
    return length / 320 * ([UIScreen mainScreen].bounds.size.width);
}

/**
 *	@brief	适配新的iphone6 6 plus
 *
 *	@return	新的frame
 */

-(CGRect)autoAdaptive{
    CGRect rect = self.frame;
    rect.size.height = rect.size.height*([UIScreen mainScreen].bounds.size.width/DefaultDeviceWidth);
    self.frame = rect;
    return rect;
}

- (void) addCustomView:(UIView *)cView{
    if (cView == nil) {
        return;
    }
    
    cView.frame = CGRectMake(cView.left, self.height, cView.width, cView.height);
    
    // 重设 view frame
    self.height = cView.bottom + 15 ; //kCommonVerMargin
    [self addSubview:cView];
}

- (void)addSubviewAndConstraints:(UIView *)view {
    CGRect frame = view.frame;
    [self addSubview:view];
    
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:frame.origin.y];
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:frame.origin.x];
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:frame.size.height];
    NSLayoutConstraint* widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:frame.size.width];
    
    [self addConstraints:@[topConstraint, leftConstraint, heightConstraint, widthConstraint]];
}


- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape(QTInterfaceOrientation())
    ? self.height : self.width;
}


- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape(QTInterfaceOrientation())
    ? self.width : self.height;
}


- (void)setborderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}


- (UIImage *)snapshotWithScale:(CGFloat)scale
{
    return [self snapshotWithScale:scale andFrame:self.bounds];
}

- (UIImage *) snapshotWithScale:(CGFloat)scale andFrame:(CGRect) frame {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGSize newSize = CGSizeMake(frame.size.width * scale, frame.size.height * scale);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void) shrinkToEndPoint:(CGPoint) end clearupWork:(void(^)(void)) clearupWork {
    [UIView animateWithDuration:.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.001);
        [self setOrigin:CGPointMake(end.x, end.y)];
    } completion:^(BOOL finished){
        
        if (clearupWork) {
            
            clearupWork();
        }
        [self removeFromSuperview];
    }];
}

- (CGFloat) horizontalCenterAlignYWith:(UIView *) target {
    return target.frame.origin.y + (target.bounds.size.height - self.bounds.size.height) / 2;
}

- (CGFloat) verticalCenterAlignXWith:(UIView *)target {
    return target.frame.origin.x + (target.bounds.size.width - self.bounds.size.width) / 2;
}

- (UIView *) rootView {
    UIView *view = self;
    while (view.superview) {
        view = view.superview;
    }
    
    return view;
}

- (void) addTarget:(id) target withSelector:(SEL) action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    
    [gestureRecognizer setNumberOfTapsRequired:1];
    [gestureRecognizer setNumberOfTouchesRequired:1];
    
    [self addGestureRecognizer:gestureRecognizer];
    
}

- (UIImage*) snapshotImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:currnetContext];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

//
- (BOOL) shouldHaveBlurEffect {
    
    if (!([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)) {
        return NO;
    }
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceName =  [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    //[[VacationUtil getInstance] machineName];
    return [deviceName hasPrefix:@"iPhone5"] || [deviceName hasPrefix:@"iPhone6"] || [deviceName hasPrefix:@"iPhone7"] || [deviceName hasPrefix:@"x86_64"];
}
@end
