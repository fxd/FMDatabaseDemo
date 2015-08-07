//
//  ErrorView.m
//  QunariPhone
//
//  Created by 姜琢 on 13-2-4.
//  Copyright (c) 2013年 Qunar.com. All rights reserved.
//

#import "ErrorView.h"
#import "SUIButton.h"
 #import "NSString+Utility.h"

#define kErrorViewImageViewWidth			103
#define kErrorViewImageViewHeight			64
#define kErrorViewRetryButtonWidth			170
#define kErrorViewRetryButtonHeight			44

#define kErrorViewVMargin					10
#define kErrorViewTopMargin					16
#define kErrorViewRetryButtonHMargin		20
#define kErrorViewTopVMargin                55

#define kErrorViewTitleLabelFont			kCurNormalFontOfSize(15)
#define kErrorViewMessageLabelFont			kCurNormalFontOfSize(12)
#define kErrorViewRetryButtonFont			kCurNormalFontOfSize(18)

@interface ErrorView ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *buttonText;

@property (nonatomic, strong) UIImageView *imageViewError;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelMessage;
@property (nonatomic, strong) SUIButton *retryButton;

@end

@implementation ErrorView

- (id)initWithFrame:(CGRect)frame
			  title:(NSString *)title
			message:(NSString *)message
		 buttonText:(NSString *)buttonText
{
    self = [super initWithFrame:frame];
    if (self)
	{
		_title = title;
		_message = message;
		_buttonText = buttonText;
		
		[self initViewRootSubs];
		[self reLayout];
    }
    return self;
}

- (void)updateWithFrame:(CGRect)frame
				  title:(NSString *)title
				message:(NSString *)message
			 buttonText:(NSString *)buttonText
{
	[self setFrame:frame];
	
	_title = title;
	_message = message;
	_buttonText = buttonText;
	
	[self reLayout];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	[self reLayout];
}

- (void)networkRetry:(id)sender
{
	// 触发代理
	if((_delegate != nil) && ([_delegate conformsToProtocol:@protocol(ErrorViewPtc)]))
	{
		[_delegate pressButtonInErrorView:self];
	}
}

#pragma mark - 布局函数

// 创建Root View的子界面
- (void)initViewRootSubs
{
	// =====================================================
	// 网络错误 ImageView
	// =====================================================
	// 创建Imageview
	_imageViewError = [[UIImageView alloc] initWithFrame:CGRectZero];
	[_imageViewError setImage:[UIImage imageNamed:kNetworkErrorHintImageFile]];
	
	// 保存
	[self addSubview:_imageViewError];
	
	// =====================================================
	// 提示Label1
	// =====================================================
	_labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
	[_labelTitle setBackgroundColor:[UIColor clearColor]];
	[_labelTitle setTextColor:[UIColor qunarTextBlackColor]];
	[_labelTitle setAlpha:0.5f];
	[_labelTitle setFont:kErrorViewTitleLabelFont];
	
	// 保存
	[self addSubview:_labelTitle];
	
	// =====================================================
	// 提示Label2
	// =====================================================
	// 创建Label
	_labelMessage = [[UILabel alloc] initWithFrame:CGRectZero];
	[_labelMessage setBackgroundColor:[UIColor clearColor]];
	[_labelMessage setTextColor:[UIColor qunarTextBlackColor]];
	[_labelMessage setAlpha:0.5f];
    [_labelMessage setNumberOfLines:0];
    [_labelMessage setLineBreakMode:NSLineBreakByWordWrapping];
    [_labelMessage setTextAlignment:NSTextAlignmentCenter];
	[_labelMessage setFont:kErrorViewMessageLabelFont];
	
	// 保存
	[self addSubview:_labelMessage];
	
	// =====================================================
	// 重试按钮
	// =====================================================
	_retryButton = [[SUIButton alloc] init];
	[[_retryButton titleLabel] setFont:kErrorViewRetryButtonFont];
	
	[_retryButton addTarget:self action:@selector(networkRetry:) forControlEvents:UIControlEventTouchUpInside];
	
	// 保存
	[self addSubview:_retryButton];
}

// 创建Root View的子界面
- (void)reLayout
{
    // 父窗口属性
	CGRect parentFrame = [self frame];
    
    // 子窗口高宽
    NSInteger spaceXEnd = parentFrame.size.width;
	
	// 下半部布局
    NSInteger spaceYStart = kErrorViewTopVMargin;
    
    // =====================================================
	// 网络错误 ImageView
	// =====================================================
	CGSize imageViewErrorSize = CGSizeMake(kErrorViewImageViewWidth, kErrorViewImageViewHeight);
	
	// 创建Imageview
	[_imageViewError setFrame:CGRectMake((spaceXEnd - imageViewErrorSize.width)/2,
										 spaceYStart,
										 imageViewErrorSize.width, imageViewErrorSize.height)];
	
	// 设置子窗口
	spaceYStart += imageViewErrorSize.height;
    
    // =====================================================
	// 提示Label1
	// =====================================================
	CGSize titleSize = [_title sizeWithFontCompatible:kErrorViewTitleLabelFont];
	
	// 创建Label
	[_labelTitle setFrame:CGRectMake((spaceXEnd - titleSize.width)/2,
									 spaceYStart,
									 titleSize.width, titleSize.height)];
	[_labelTitle setText:_title];
	
	// 设置子窗口
	spaceYStart += titleSize.height;
	
	spaceYStart += kErrorViewVMargin;
    
	// =====================================================
	// 提示Label2
	// =====================================================
    CGSize messageSize = [_message sizeWithFontCompatible:kErrorViewMessageLabelFont
                                        constrainedToSize:CGSizeMake(spaceXEnd, CGFLOAT_MAX)
                                            lineBreakMode:NSLineBreakByWordWrapping];
	
	// 创建Label
	[_labelMessage setFrame:CGRectMake((spaceXEnd - messageSize.width)/2,
									   spaceYStart,
									   messageSize.width, messageSize.height)];
	[_labelMessage setText:_message];
	
	// 设置子窗口
	spaceYStart += messageSize.height;
	
	spaceYStart += kErrorViewVMargin;
	
	// =====================================================
	// 重试按钮
	// =====================================================
	spaceYStart += kErrorViewTopMargin;
	
	if (_buttonText != nil)
	{
		CGSize buttonSize = CGSizeMake(kErrorViewRetryButtonWidth, kErrorViewRetryButtonHeight);
		
		// 创建button
		[_retryButton setFrame:CGRectMake((spaceXEnd - buttonSize.width)/2,
										  spaceYStart,
										  buttonSize.width, buttonSize.height)];
		[_retryButton addTarget:self action:@selector(networkRetry:) forControlEvents:UIControlEventTouchUpInside];
		[_retryButton setTitle:_buttonText forState:UIControlStateNormal];
		[_retryButton setHidden:NO];
	}
	else
	{
		[_retryButton setHidden:YES];
	}
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.labelMessage.text = message;
}

@end
