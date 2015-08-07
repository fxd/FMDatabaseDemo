//
//  RoundButton.m
//  QunariPhone
//
//  Created by Qunar on 14-1-22.
//  Copyright (c) 2014年 Qunar.com. All rights reserved.
//

#import "RoundButton.h"
#import "UIImage+Utility.h"
 
#define kRoundButtonWidthMargin								20
#define kRoundButtonHeightMargin							15

// 控件的默认填充颜色
#define kRoundButtonEllipseWithStrokeStyleNormalColor		[UIColor colorWithHex:0xffffff alpha:1.0f]
#define kRoundButtonEllipseWithStrokeStyleSelectColor		[UIColor colorWithHex:0x1ba9ba alpha:1.0f]

// 控件边缘画笔的默认颜色
#define kRoundButtonStrokeColor								[UIColor colorWithHex:0x1ba9ba alpha:1.0f]
#define kRoundButtonStrokeDisableColor						[UIColor colorWithHex:0xbbbbbb alpha:1.0f]

#define kRoundButtonHighlightTextColor						[UIColor colorWithHex:0xffffff alpha:1.0f]

@implementation RoundButton

- (void)dealloc
{
    // 取消延迟加载函数
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hesitateUpdate) object:nil];
}

- (void)commonInit
{
	// Initialization code
	[self setOpaque:NO];
	[self setBackgroundColor:[UIColor clearColor]];
	
	strokeWeight = 1.0f;
	cornerRadius = kRoundButtonLargeRadius;
	strokeColor  = kRoundButtonStrokeColor;
	strokeDisableColor = kRoundButtonStrokeDisableColor;
}

// 初始化圆形按钮
- (id)init
{
    self = [super init];
    if (self)
    {
		[self commonInit];
    }
    
    return self;
}

// 初始化圆形按钮
- (id)initWithrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		[self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	if (self != nil)
    {
		[self commonInit];
	}
	return self;
}

// 设置按下态高亮颜色
- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    
    if(_style == kRoundButtonArcWithStrokeStyle)
    {
        [self setNeedsDisplay];
    }
    else
    {
        [self setBackgroundImage:[UIImage imageFromColor:_selectColor] forState:UIControlStateHighlighted];
    }
}

// 设置按钮的背景色
- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    
    if(_style == kRoundButtonArcWithStrokeStyle)
    {
        [self setNeedsDisplay];
    }
    else
    {
        [self setBackgroundImage:[UIImage imageFromColor:_normalColor] forState:UIControlStateNormal];
    }
}

// 设置控件的弯曲弧度
- (void)setRadius:(RoundButtonRadius)radius
{
    cornerRadius = radius;
    
    if (_style == kRoundButtonArcWithStrokeStyle)
    {
        [self setNeedsDisplay];
    }
    else if(_style == kRoundButtonArcStyle)
    {
        [self.layer setCornerRadius:radius];
        
        [self.layer setMasksToBounds:YES];
    }
}

// 重新调整控件的大小
- (void)setStyle:(RoundButtonStyle)style
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    _style = style;
    
    if(_style == kRoundButtonArcWithStrokeStyle)
    {
        _normalColor = kRoundButtonEllipseWithStrokeStyleNormalColor;
        _selectColor = kRoundButtonEllipseWithStrokeStyleSelectColor;
        
        [self setTitleColor:kRoundButtonStrokeColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:kRoundButtonStrokeDisableColor forState:UIControlStateDisabled];
        
        [self setNeedsDisplay];
    }
    else if(style == kRoundButtonArcStyle)
    {
        [self.layer setCornerRadius:cornerRadius];
        
        [self.layer setMasksToBounds:YES];
    }
}

// 调整控件大小
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (_style == kRoundButtonArcWithStrokeStyle)
    {
        self.backgroundColor = [UIColor clearColor];
        CGRect imageBounds = CGRectMake(0.0, 0.0, self.bounds.size.width - 0.5, self.bounds.size.height);
        
        CGColorRef fillColor;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPoint point2;
        
        CGFloat resolution = 0.5 * (self.bounds.size.width / imageBounds.size.width + self.bounds.size.height / imageBounds.size.height);
        
        CGFloat stroke = strokeWeight * resolution;
        if (stroke < 1.0)
		{
            stroke = ceil(stroke);
		}
        else
		{
            stroke = round(stroke);
		}
        stroke /= resolution;
		
        CGFloat alignStroke = fmod(0.5 * stroke * resolution, 1.0);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint point = CGPointMake((self.bounds.size.width - cornerRadius), self.bounds.size.height - 0.5f);
		
        point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
        point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
        CGPathMoveToPoint(path, NULL, point.x, point.y);
		
        point = CGPointMake(self.bounds.size.width - 0.5f, (self.bounds.size.height - cornerRadius));
        point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
        point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
        CGPoint controlPoint1 = CGPointMake((self.bounds.size.width - (cornerRadius / 2.f)), self.bounds.size.height - 0.5f);
		
        controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
        controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
        CGPoint controlPoint2 = CGPointMake(self.bounds.size.width - 0.5f, (self.bounds.size.height - (cornerRadius / 2.f)));
		
        controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
        controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
        CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
		
        point = CGPointMake(self.bounds.size.width - 0.5f, cornerRadius);
        point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
        point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
		
        point = CGPointMake((self.bounds.size.width - cornerRadius), 0.0);
        point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
        point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
        controlPoint1 = CGPointMake(self.bounds.size.width - 0.5f, (cornerRadius / 2.f));
        controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
        controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
        controlPoint2 = CGPointMake((self.bounds.size.width - (cornerRadius / 2.f)), 0.0);
        controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
        controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
        CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
		
        point = CGPointMake(cornerRadius, 0.0);
        point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
        point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
		
        point = CGPointMake(0.0, cornerRadius);
        point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
        point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
        controlPoint1 = CGPointMake((cornerRadius / 2.f), 0.0);
        controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
        controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
        controlPoint2 = CGPointMake(0.0, (cornerRadius / 2.f));
        controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
        controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
        CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
		
        point = CGPointMake(0.0, (self.bounds.size.height - cornerRadius));
        point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
        point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
		
        point = CGPointMake(cornerRadius, self.bounds.size.height - 0.5f);
        point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
        point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
        controlPoint1 = CGPointMake(0.0, (self.bounds.size.height - (cornerRadius / 2.f)));
        controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
        controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
        controlPoint2 = CGPointMake((cornerRadius / 2.f), self.bounds.size.height - 0.5f);
        controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
        controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
        CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
		
        point = CGPointMake((self.bounds.size.width - cornerRadius), self.bounds.size.height - 0.5f);
        point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
        point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
		
        CGPathCloseSubpath(path);
        
        if (self.state == UIControlStateHighlighted)
        {
            fillColor = _selectColor.CGColor;
        }
        else
        {
            fillColor = _normalColor.CGColor;
        }
        
        CGContextSetFillColorWithColor(context, fillColor);
        
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        CGContextSaveGState(context);
        point = CGPointMake((self.bounds.size.width / 2.0), self.bounds.size.height - 0.5f);
        point2 = CGPointMake((self.bounds.size.width / 2.0), 0.0);
        CGContextRestoreGState(context);
		
		if (self.state == UIControlStateDisabled)
		{
			[strokeDisableColor setStroke];
		}
		else
		{
			[strokeColor setStroke];
		}
		
        CGContextSetLineWidth(context, stroke);
        CGContextSetLineCap(context, kCGLineCapSquare);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
        CGPathRelease(path);
    }
}

- (void)hesitateUpdate
{
    [self setNeedsDisplay];
}

// 检测控件的触控状态
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.2];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.2];
}

- (void)setHighlighted:(BOOL)highlighted
{
	if (highlighted)
	{
		[super setHighlighted:highlighted];
		[self setNeedsDisplay];
	}
	else
	{
		[super setHighlighted:highlighted];
		[self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.2];
	}
}

@end
