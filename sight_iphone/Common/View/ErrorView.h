//
//  ErrorView.h
//  QunariPhone
//
//  Created by 姜琢 on 13-2-4.
//  Copyright (c) 2013年 Qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ErrorView;

@protocol ErrorViewPtc <NSObject>

- (void)pressButtonInErrorView:(ErrorView *)errorView;

@end

@interface ErrorView : UIView

@property (nonatomic, weak) id <ErrorViewPtc> delegate;

- (id)initWithFrame:(CGRect)frame
			  title:(NSString *)title
			message:(NSString *)message
		 buttonText:(NSString *)buttonText;

- (void)updateWithFrame:(CGRect)frame
				  title:(NSString *)title
				message:(NSString *)message
			 buttonText:(NSString *)buttonText;

- (void)setFrame:(CGRect)frame;

- (void)setMessage:(NSString *)message;

@end
