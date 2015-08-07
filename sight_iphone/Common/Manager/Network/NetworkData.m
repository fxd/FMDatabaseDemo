//
//  NetworkData.m
//  QunariPhone
//
//  Created by Neo on 11/29/12.
//  Copyright (c) 2012 Qunar.com. All rights reserved.
//

#import "NetworkData.h"
#import "NSObject+Utility.h"

@implementation NetworkData

// 自动化解析
+ (id)parseJsonAutomatic:(NSDictionary *)dictionaryJson inClass:(Class)classDest forInfo:(id)customInfo
{
	// 创建Dest
	id objectDest = [[classDest alloc] init];
	if(objectDest != nil)
	{
		[objectDest parseJsonAutomatic:dictionaryJson forInfo:customInfo];
	}
	
	return objectDest;
}

@end
