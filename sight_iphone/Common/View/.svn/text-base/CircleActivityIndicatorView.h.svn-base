//
//  CircleActivityIndicatorView.h
//  CommonFramework
//
//  Created by qunar on 14-3-6.
//  Copyright (c) 2014年 Qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    eCircleActivityBlueStyle,
    eCircleActivityWhiteStyle,
} CircleActivityIndicatorStyle;

@interface CircleActivityIndicatorView : UIImageView

@property (nonatomic, assign, getter = isAnimating) BOOL isAnimating;
@property (nonatomic, assign) BOOL hidesWhenStopped;
@property (nonatomic, assign) CircleActivityIndicatorStyle style;

- (void)startAnimating;
- (void)stopAnimating;
- (void)spin;

@end
