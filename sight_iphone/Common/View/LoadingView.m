//
//  LoadView.m
//  QunariPhone
//
//  Created by 姜琢 on 12-12-13.
//  Copyright (c) 2012年 Qunar.com. All rights reserved.
//

#import "LoadingView.h"
#import "CamelAnimationView.h"
#import "UILabel+Utility.h"
#import "NSString+Utility.h"
  

// 边框局
#define kLoadDefaultOriginYMargin			65
#define kLoadImageLabelMargin				65
#define kLoadDefaultOriginXMargin           30


#define	kLoadTextFont						kCurNormalFontOfSize(14)

@interface LoadingView ()

@property (nonatomic, strong) CamelAnimationView *viewAnimation;    // 骆驼动画
@property (nonatomic, strong) UILabel *labelHint;                   // 提示文案Label

@end

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // 设置背景颜色
        [self setBackgroundColor:[UIColor clearColor]];
        
		_offset = kLoadDefaultOriginYMargin;
		_hidesWhenStopped = YES;
        
        // =======================================================================
		// 骆驼动画
		// =======================================================================
        _viewAnimation = [[CamelAnimationView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_viewAnimation setBackgroundColor:self.backgroundColor];
        [_viewAnimation setOffset:_offset];
        [self addSubview:_viewAnimation];
        
		// =======================================================================
		// 加载中 Label
		// =======================================================================
		NSString *hintText = @"加载中…";
		CGSize hintTextSize = [hintText sizeWithFontCompatible:kLoadTextFont];
		
		_labelHint = [[UILabel alloc] init];
		[_labelHint setFrame:CGRectMake((frame.size.width - hintTextSize.width) / 2, _offset + kLoadImageLabelMargin,
										hintTextSize.width, hintTextSize.height)];
		[_labelHint setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
		[_labelHint setBackgroundColor:[UIColor clearColor]];
		[_labelHint setTextColor:[UIColor colorWithHex:0x1ba9ba alpha:1.0f]];
        [_labelHint setNumberOfLines:0];
        [_labelHint setTextAlignment:NSTextAlignmentCenter];
        [_labelHint setLineBreakMode:NSLineBreakByCharWrapping];
		[_labelHint setFont:kLoadTextFont];
		[_labelHint setText:hintText];
		
		[self addSubview:_labelHint];
    }
	
    return self;
}

- (id)initWithFrame:(CGRect)frame andText:(NSString *)text
{
	if((self = [self initWithFrame:frame]) != nil)
	{
		[self setText:text];
	}
	
	return self;
}

- (void)setOffset:(CGFloat)offset
{
	_offset = offset;
	
	// 重新设置位置
    [_viewAnimation setOffset:_offset];
	[_labelHint setViewY:_offset + kLoadImageLabelMargin];
}

- (void)setText:(NSString *)text
{
	_text = text;
	
    
    
    CGSize hintTextSize = [_text sizeWithFontCompatible:kLoadTextFont
                                                      constrainedToSize:CGSizeMake(self.frame.size.width - 2 * kLoadDefaultOriginXMargin, CGFLOAT_MAX)
                                                          lineBreakMode:NSLineBreakByWordWrapping];
	
	[_labelHint setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
	[_labelHint setFrame:CGRectMake((self.frame.size.width - hintTextSize.width) / 2, _offset + kLoadImageLabelMargin,
									hintTextSize.width, hintTextSize.height)];
	[_labelHint setText:_text];
}

- (void)startAnimating
{
    [_viewAnimation startAnimating];
}

- (void)stopAnimating
{
    [_viewAnimation stopAnimating];
    
    if (_hidesWhenStopped)
	{
		[self setHidden:YES];
	}
}

- (BOOL)isAnimating
{
    return [_viewAnimation isAnimating];
}

@end
