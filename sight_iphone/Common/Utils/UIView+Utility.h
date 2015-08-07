//
//  UIView+Utility.h
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define DefaultDeviceWidth              320
#define kDefaultAnimateTime             0.25f

typedef enum AnimateType{       //动画类型
    AnimateTypeOfTV,            //电视
    AnimateTypeOfPopping,       //弹性缩小放大
    AnimateTypeOfLeft,          //左
    AnimateTypeOfRight,         //右
    AnimateTypeOfTop,           //上
    AnimateTypeOfBottom         //下
}AnimateType;

@interface UIView (Utility)

//  将View的左边移动到指定位置
@property (nonatomic) CGFloat left;

//  将View的顶端移动到指定位置
@property (nonatomic) CGFloat top;

//  将View的右边移动到指定位置
@property (nonatomic) CGFloat right;

//  将View的底端移动到指定位置
@property (nonatomic) CGFloat bottom;

//  更改View的宽度
@property (nonatomic) CGFloat width;

//  更改View的高度
@property (nonatomic) CGFloat height;

//  更改View的位置
@property (nonatomic) CGPoint origin;

//  更改View的尺寸
@property (nonatomic) CGSize size;

//  更改View中心点的位置x
@property (nonatomic) CGFloat centerX;

//  更改View中心点的位置x
@property (nonatomic) CGFloat centerY;

//  Return the x coordinate on the screen.
@property (nonatomic, readonly) CGFloat ttScreenX;


//  Return the y coordinate on the screen.
@property (nonatomic, readonly) CGFloat ttScreenY;

//  Return the x coordinate on the screen, taking into account scroll views.
@property (nonatomic, readonly) CGFloat screenViewX;


//  Return the y coordinate on the screen, taking into account scroll views.
@property (nonatomic, readonly) CGFloat screenViewY;


//  Return the view frame on the screen, taking into account scroll views.
@property (nonatomic, readonly) CGRect screenFrame;

//  Return the width in portrait or the height in landscape.
@property (nonatomic, readonly) CGFloat orientationWidth;


// Return the height in portrait or the width in landscape.
@property (nonatomic, readonly) CGFloat orientationHeight;



// 设置UIView的X == setLeft
- (void)setViewX:(CGFloat)newX;

// 设置UIView的Y == setTop
- (void)setViewY:(CGFloat)newY;

// 设置UIView的Origin == setOrigin
- (void)setViewOrigin:(CGPoint)newOrigin;

// 设置UIView的width == setWidth
- (void)setViewWidth:(CGFloat)newWidth;

// 设置UIView的height == setHeight
- (void)setViewHeight:(CGFloat)newHeight;

// 设置UIView的Size == setSize
- (void)setViewSize:(CGSize)newSize;


//! 清除所有的子View
- (void)removeAllSubviews;





// 返回subview中指定tag的view
- (id)subviewWithTag:(NSInteger)tag;

// 统计用获取子View中Title
- (NSString *)subViewsTextForStatistics;

// 返回view的vc
- (UIViewController*)viewController;
// 返回view的vc
- (UIViewController*)viewController:(Class)class;
// 返回view
- (UIView*)view:(Class)class ;



//  Finds the first descendant view (including this view) that is a member of a particular class.
- (UIView*)descendantOrSelfWithClass:(Class)cls;

//  Finds the first ancestor view (including this view) that is a member of a particular class.
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

//  Calculates the offset of this view from another view in screen coordinates.
//  otherView should be a parent view of this view.
- (CGPoint)offsetFromView:(UIView*)otherView;



// 获取顶部View  SingleChatVC.view ————当地人
+ (UIView *)getTopView;

// 顶层maskView触摸
+ (void)setTopMaskViewCanTouch:(BOOL)_canTouch;

/**
 显示view
 @param _view 需要显示的view
 @param _aType 动画类型
 @param _fRect 最终位置
 */
+ (void)showView:(UIView*)_view animateType:(AnimateType)_aType finalRect:(CGRect)_fRect;

/**
 消失view
 */
+ (void)hideView;

/**
 消失view
 @param _aType 动画类型
 */
+ (void)hideViewByType:(AnimateType)_aType;

#pragma mark - 下面的增加了完成块
+ (void)showView:(UIView*)_view animateType:(AnimateType)_aType finalRect:(CGRect)_fRect completion:(void(^)(BOOL finished))completion;
+ (void)hideViewByCompletion:(void(^)(BOOL finished))completion;
+ (void)hideViewByType:(AnimateType)_aType completion:(void(^)(BOOL finished))completion;


/**
 *	@brief	工厂方法，从与类名同名的xib中加载。
 *
 *	@return	用xib初始化的View。
 */
+ (id)viewFromXib;


/**
 *	@brief	适配新的iphone6 6 plus
 *
 *	@return	新的frame
 */
-(CGRect)autoAdaptive;


/**
 *  @brief  在下方添加子view
 */
- (void)addCustomView:(UIView *)cView;

/**
 *  @brief  宽不变，高按320等比缩放
 */
- (void)frameCompatibleHeight:(CGRect)rect;

/**
 *  @brief  等比缩放
 */
- (void)frameCompatibleSize:(CGRect)rect;

/**
 *  @brief  把传入的长度等比放大
 */
+ (CGFloat)compatibleLength:(CGFloat)length;

/**
 *  @brief  添加子View，同时以子View的frame添加constraints
 */
- (void)addSubviewAndConstraints:(UIView *)view;

/**
 *  @brief  设置View边框的颜色和宽度
 */
- (void)setborderColor:(UIColor *)color borderWidth:(CGFloat)width;


- (CGPoint)boundsCenter;

- (UIImage *) snapshotImage;

- (UIImage *) snapshotWithScale:(CGFloat)scale;
- (UIImage *) snapshotWithScale:(CGFloat)scale andFrame:(CGRect) frame;

// 水平中间对齐
- (CGFloat) horizontalCenterAlignYWith:(UIView *) target;
// 垂直中间对齐
- (CGFloat) verticalCenterAlignXWith:(UIView *) target;

// 最顶层的View
- (UIView *) rootView;

// 添加触发事件
- (void) addTarget:(id) target withSelector:(SEL) action;

// 添加缩放式退出动画
- (void) shrinkToEndPoint:(CGPoint) end clearupWork:(void(^)(void)) clearupWork;


@end
