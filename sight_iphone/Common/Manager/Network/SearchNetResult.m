//
//  SearchNetResult.m
//  QunarIphone
//
//  Created by 庆 黄 on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchNetResult.h"
#import "NetworkData.h"
#import "NSObject+Utility.h"

@implementation SearchNetResult

// 解析所有数据
- (void)parseAllNetResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo
{
	// !!!这三个部分的顺序千万不能颠倒，否则会解析错误!!!
	// ==============================================================
	// 子结构
	// ==============================================================
	// 业务数据
	NSDictionary *dictionaryData = [jsonDictionary objectForKey:@"result"];
	if(dictionaryData != nil)
	{
		// 解析简单数据
		[self parseNetResult:dictionaryData forInfo:customInfo];
	}
	
	// ==============================================================
	// 复合结构
	// ==============================================================
    // 网络状态
	_bstatus = [NetworkData parseJsonAutomatic:[jsonDictionary objectForKey:@"bstatus"]
									   inClass:[NetworkStatus class]
									   forInfo:customInfo];
    
    // 全局公用数据
//	_global = [NetworkData parseJsonAutomatic:[jsonDictionary objectForKey:@"global"]
//										   inClass:[NetworkGlobalData class]
//										   forInfo:customInfo];
//	
}

// 解析业务数据
- (void)parseNetResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo
{
	// 开始自动化解析
	[self parseJsonAutomatic:jsonDictionary forInfo:customInfo];
}

// 解析业务数据
+ (NSArray *)parseNetResultArray:(id)jsonObject WithObjectClass:(Class)objectClass forInfo:(id)customInfo
{
	// 开始自动化解析
	return [NSObject parseJsonArrayAutomatic:jsonObject withObjectClass:objectClass forInfo:customInfo];
}

// 适配所有ProtoBuf数据
- (BOOL)adapteAllProtoResult:(NSData *)protoBufData forInfo:(id)customInfo
{
    return YES;
}

@end
