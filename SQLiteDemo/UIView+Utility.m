//
//  UIView+Utility.m
//  SQLiteDemo
//
//  Created by fengshaobo on 15/8/7.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat)top {
    return self.frame.origin.y;
}


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

- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
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

@end
