//
//  SearchNetResult.h
//  QunarIphone
//
//  Created by 庆 黄 on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkStatus.h"
#import "NetworkGlobalData.h"

@interface SearchNetResult : NSObject

@property (nonatomic, strong, readonly, getter = networkStatus) NetworkStatus *bstatus;
//@property (nonatomic, strong, readonly, getter = networkGlobalData) NetworkGlobalData *global;


// 解析所有数据
- (void)parseAllNetResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo;

// 解析业务数据
- (void)parseNetResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo;

// 解析业务数据
+ (NSArray *)parseNetResultArray:(id)jsonObject WithObjectClass:(Class)objectClass forInfo:(id)customInfo;

// 适配所有ProtoBuf数据
- (BOOL)adapteAllProtoResult:(NSData *)protoBufData forInfo:(id)customInfo;

@end
