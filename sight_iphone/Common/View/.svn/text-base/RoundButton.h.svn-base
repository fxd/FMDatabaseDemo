//
//  RoundButton.h
//  QunariPhone
//
//  Created by Qunar on 14-1-22.
//  Copyright (c) 2014年 Qunar.com. All rights reserved.
//

#import "SUIButton.h"

//
typedef enum RoundButtonStyle
{
    // 矩形按钮,需设置背景色
    kRoundButtonRectangleStyle = 0,
    // 圆角按钮,需设置背景色
    kRoundButtonArcStyle,
    // 圆角画笔按钮,只需设置类型，背景色通用
    kRoundButtonArcWithStrokeStyle,
} RoundButtonStyle;

//
typedef enum RoundButtonRadius : NSUInteger
{
    kRoundButtonSmallRadius = 3,
    kRoundButtonLargeRadius = 5,
} RoundButtonRadius;

@interface RoundButton : SUIButton
{
	CGFloat         cornerRadius;
	CGFloat         strokeWeight;
	UIColor         *strokeColor;
	UIColor         *strokeDisableColor;
}

@property (nonatomic, strong) UIColor *selectColor;			// 设置按下态的颜色
@property (nonatomic, strong) UIColor *normalColor;			// 设置的颜色
@property (nonatomic, assign) RoundButtonStyle style;		// 按钮的样式
@property (nonatomic, assign) RoundButtonRadius radius;		// 按钮的弧度

@property (nonatomic, strong) id customInfo;				// 自定义携带对象

@end
