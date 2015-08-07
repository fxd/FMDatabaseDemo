//
//  NetRespond.m
//  tts_iphone
//
//  Created by fengshaobo on 14-10-14.
//  Copyright (c) 2014年 fengshaobo. All rights reserved.
//

#import "NetworkRespond.h"
#import "NSObject+Utility.h"

@implementation NetworkRespond


/*
 ****   示例解析数据  ****
 *
{
    "data" : [ {
        "computeRefundReceiveMoney" : {
            "cashBackRefundMoney" : 0.0,
            "customerReceiveMoney" : 50.0,
            "merchantRefundMoney" : 50.0,
            "qunarRefundMoney" : 0.0,
            "defaultRefundCharges" : 0.0,
            "maxRefundChargesbyQuantity" : 10.0
        }
    } ],
    "ret" : true
}
 
 *
 */


// 解析所有数据
- (void)parseAllNetResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo
{
    
 
    // !!!这三个部分的顺序千万不能颠倒，否则会解析错误!!!
    
    // 1.解析data数据
    NSArray *dataArray = [jsonDictionary objectForKey:@"data"];
    
    if ([dataArray count]) {
        
        // 业务数据
        NSDictionary *businessDict = [dataArray objectAtIndex:0];
        
        if ([[businessDict allKeys] count]) {
            
            // eg:取 computeRefundReceiveMoney
            NSString *detailKey = [[businessDict allKeys] objectAtIndex:0];
            NSDictionary *detailDict = [businessDict objectForKey:detailKey];
            
            if(detailDict != nil) {
                [self parseNetResult:detailDict forInfo:customInfo];
            }
        }

    }

    // 错误提示
    self.ret = [jsonDictionary objectForKey:@"ret"];
    if (0 == [self.ret integerValue]) {
        self.errmsg = [jsonDictionary objectForKey:@"errmsg"];
        self.errcode = [jsonDictionary objectForKey:@"errcode"];
    }
    
}


// 解析所有数据
- (void)parseAllNetOuterResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo
{
    // 1.解析data数据
    NSArray *dataArray = [jsonDictionary objectForKey:@"data"];
    
    if ([dataArray count]) {
        
        // 业务数据
        NSDictionary *businessDict = [dataArray objectAtIndex:0];
        
        if ([[businessDict allKeys] count]) {
            [self parseNetResult:businessDict forInfo:customInfo];
        }
        
    }
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
