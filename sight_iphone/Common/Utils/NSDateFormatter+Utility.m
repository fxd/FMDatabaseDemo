//
//  NSDateFormatter+Default.m
//  QunariPhone
//
//  Created by 姜琢 on 12-11-30.
//  Copyright (c) 2012年 Qunar.com. All rights reserved.
//

#import "NSDateFormatter+Utility.h"

static NSDateFormatter *s_format;

@implementation NSDateFormatter (Utility)

+ (NSDateFormatter *)defaultFormatter
{
    if (!s_format)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            s_format = [[NSDateFormatter alloc] init];
            NSLocale * gregorianLocale = [[NSLocale alloc] initWithLocaleIdentifier:NSCalendarIdentifierGregorian];
            [s_format setLocale:gregorianLocale];
        });
    }
	return s_format;
}

+ (void)destoryDefaultFormatter
{
    if (s_format)
    {
        s_format = nil;
    }
}

@end
