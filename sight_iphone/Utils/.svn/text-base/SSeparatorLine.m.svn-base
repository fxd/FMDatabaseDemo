//
//  SeperatorLine.m
//  Sight
//
//  Created by yue.dai on 14/1/1.
//  Copyright (c) 2014年 Qunar.com. All rights reserved.
//

#import "SSeparatorLine.h"
#import "UIView+Utility.h"


@implementation SSeparatorLine

+ (id)line {
    return [[SSeparatorLine alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineDiameter)];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupView];
}

- (void)setupView {
    if (self.height > self.width) {
        // vertical
        self.width = kLineDiameter;
    } else {
        // horizontal
        self.height = kLineDiameter;
    }
    self.backgroundColor = [UIColor qunarGrayColor];
}

- (void)updateConstraints {
    [super updateConstraints];

    if (self.height > self.width) {
        // vertical
        [self configureAttributeIfExists:NSLayoutAttributeWidth];
    } else {
        // horizontal
        [self configureAttributeIfExists:NSLayoutAttributeHeight];
    }
}

- (BOOL)configureAttributeIfExists:(NSLayoutAttribute)attribute {
    for (NSLayoutConstraint * constraint in self.constraints) {
        if (constraint.firstAttribute == attribute) {
            constraint.constant = kLineDiameter;
            return YES;
        }
    }
    return NO;
}

@end
