//
//  CamelAnimationView.m
//  QunariPhone
//
//  Created by Lufangying on 14-3-11.
//  Copyright (c) 2014年 Qunar.com. All rights reserved.
//

#import "CamelAnimationView.h"
 

#define kLoadingBGVMargin                   2

// 骆驼Logo大小
#define	kLoadCamelImageViewWidth			48
#define	kLoadCamelImageViewHeight			36
#define kLoadCamelBGImageWidth              233
#define kLoadCamelBGImageHeight             233
#define kLoadCamelBGMaskWidth               320
#define kLoadCamelBGMaskHeight              329

// 计算角度
#define degreesToRadians(x)                 (M_PI*(x)/180.0)

@interface CamelAnimationView()

@property (nonatomic, strong) UIImageView *imageViewBGAnimation;    // 地图背景
@property (nonatomic, strong) CALayer *maskLayer;                   // Mask
@property (nonatomic, strong) UIImageView *imageViewAnimation;      // 骆驼动画View
@property (nonatomic, assign) NSInteger degree;                     // 旋转角度

@end

@implementation CamelAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _degree = 1;
        
        // =======================================================================
		// 骆驼背景动画 ImageView
		// =======================================================================
        _imageViewBGAnimation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kLoadingViewCamelBGImageFile]];
        [_imageViewBGAnimation setFrame:CGRectMake((frame.size.width - kLoadCamelBGImageWidth) / 2, _offset - kLoadingBGVMargin, kLoadCamelBGImageWidth, kLoadCamelBGImageHeight)];
        [self addSubview:_imageViewBGAnimation];
        
        // =======================================================================
		// 遮罩Mask
		// =======================================================================
        UIImage *maskImage = [UIImage imageNamed:kLoadingViewCamelBGMaskImageFile];
        _maskLayer = [CALayer layer];
        _maskLayer.frame = CGRectMake((frame.size.width - kLoadCamelBGMaskWidth) / 2, _imageViewBGAnimation.center.y - kLoadCamelBGMaskHeight / 2, kLoadCamelBGMaskWidth, kLoadCamelBGMaskHeight);
        _maskLayer.contents = (id)[maskImage CGImage];
        [[self layer] setMask:_maskLayer];
        
		// =======================================================================
		// 骆驼动画 ImageView
		// =======================================================================
		_imageViewAnimation = [[UIImageView alloc] init];
		[_imageViewAnimation setFrame:CGRectMake((frame.size.width - kLoadCamelImageViewWidth) / 2,
												 _offset, kLoadCamelImageViewWidth, kLoadCamelImageViewHeight)];
		[_imageViewAnimation setAnimationDuration:0.7];
		
		// 设置动画图片
		NSMutableArray *arrayImages = [[NSMutableArray alloc] init];
		[arrayImages addObject:[UIImage imageNamed:kLoadingViewCamel1ImageFile]];
		[arrayImages addObject:[UIImage imageNamed:kLoadingViewCamel2ImageFile]];
		[arrayImages addObject:[UIImage imageNamed:kLoadingViewCamel3ImageFile]];
		[arrayImages addObject:[UIImage imageNamed:kLoadingViewCamel4ImageFile]];
		[arrayImages addObject:[UIImage imageNamed:kLoadingViewCamel5ImageFile]];
		[_imageViewAnimation setAnimationImages:arrayImages];
		
		// 保存
		[self addSubview:_imageViewAnimation];
		
        // 开始做动画
		[self startAnimating];
    }
    return self;
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    
    // 重新设置动画位置
    [_imageViewBGAnimation setViewY:_offset - kLoadingBGVMargin];
    
    CGRect maskLayerFrame = _maskLayer.frame;
    _maskLayer.frame = CGRectMake(maskLayerFrame.origin.x, _imageViewBGAnimation.center.y - kLoadCamelBGMaskHeight / 2, maskLayerFrame.size.width, maskLayerFrame.size.height);
    
	[_imageViewAnimation setViewY:_offset];
}

- (void)startAnimating
{
	if([self isAnimating] == NO)
    {
        [_imageViewAnimation startAnimating];
        [self circleAnimationStart];
    }
}

- (void)stopAnimating
{
	[_imageViewAnimation stopAnimating];
}

- (BOOL)isAnimating
{
	return [_imageViewAnimation isAnimating];
}

- (void)circleAnimationStart
{
    [UIView animateWithDuration:0.06f
                     animations:^{
                         _imageViewBGAnimation.transform = CGAffineTransformMakeRotation(degreesToRadians(_degree));
                     }
                     completion:^(BOOL finish){
                         if((finish == YES) && ([self isAnimating] == YES))
                         {
                             _degree += 1;
                             if(_degree > 360)
                             {
                                 _degree = 0;
                             }
                             
                             [self circleAnimationStart];
                         }
                     }];
}

@end
