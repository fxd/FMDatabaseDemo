//
//  UIImage+Utility.m
//  QunariPhone
//
//  Created by 姜琢 on 13-6-8.
//  Copyright (c) 2013年 Qunar.com. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

+ (UIImage *)imageFromColor:(UIColor *)color
{
	CGRect rect = CGRectMake(0, 0, 1, 1);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context,[color CGColor]);
	CGContextFillRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}


// 截取部分图像
- (UIImage *)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));

    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}



// 等比例缩放
- (UIImage *)scaleToSize:(CGSize)size
{
    CGFloat width  = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float scale = [[UIScreen mainScreen] scale];
    
    float verticalRadio   = size.height*scale/height;
    float horizontalRadio = size.width*scale/width;

    float radio = 1;
    
    if (verticalRadio > 1 && horizontalRadio > 1)
    {
        radio = 1;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width  = width * radio;
    height = height * radio;
    
    int xPos = (size.width - width/scale)/2;
    int yPos = (size.height - height/scale)/2;
    
    UIGraphicsBeginImageContextWithOptions(size, NO,scale);
    [self drawInRect:CGRectMake(xPos, yPos, width/scale, height/scale)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)TransformtoSize:(CGSize)size image:(UIImage *)image
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *transformedImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return transformedImg;
}

- (UIImage *)imageWithMaxLength:(CGFloat)sideLenght
{
	CGSize size = [self fitSize:sideLenght];
    
    UIGraphicsBeginImageContext(size);
    
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationDefault);
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[self drawInRect:rect];
	
	UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
	return newimg;
}

- (CGSize)fitSize:(CGFloat)sideLenght
{
	CGFloat scale;
	CGSize newsize;
	
	if(self.size.width <= sideLenght && self.size.height <= sideLenght)
	{
		newsize = self.size;
	}
	else
	{
		if(self.size.width >= self.size.height)
		{
			scale = sideLenght/self.size.width;
			newsize.width = sideLenght;
			newsize.height = ceilf(self.size.height*scale);
		}
		else
		{
			scale = sideLenght/self.size.height;
			newsize.height = sideLenght;
			newsize.width = ceilf(self.size.width*scale);
		}
	}
    
	return newsize;
}


@end
