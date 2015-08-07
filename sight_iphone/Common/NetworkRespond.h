//
//  NetRespond.h
//  tts_iphone
//
//  Created by fengshaobo on 14-10-14.
//  Copyright (c) 2014年 fengshaobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkRespond : NSObject


// 错误
@property (nonatomic, strong) NSNumber *errcode;
@property (nonatomic, strong) NSString *errmsg;
@property (nonatomic, strong) NSNumber *ret;      // 结果是否正确



// 解析所有数据
- (void)parseAllNetResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo;

// 解析所有数据，包括外层
- (void)parseAllNetOuterResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo;

// 解析业务数据
- (void)parseNetResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo;

// 解析业务数据
+ (NSArray *)parseNetResultArray:(id)jsonObject WithObjectClass:(Class)objectClass forInfo:(id)customInfo;

// 适配所有ProtoBuf数据
- (BOOL)adapteAllProtoResult:(NSData *)protoBufData forInfo:(id)customInfo;



@end
