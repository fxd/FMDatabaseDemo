//
//  NetworkAPI.h
//  byy
//
//  Created by fengshaobo on 14-4-1.
//  Copyright (c) 2014年 byy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonTemplate.h"
#import "AFHTTPRequestOperationManager.h"
#import "NetworkPtc.h"

@class SearchNetResult;

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_2G= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_4G= 3,
    NETWORK_TYPE_5G= 4,//  5G目前为猜测结果
    NETWORK_TYPE_WIFI= 5,
}NETWORK_TYPE;


// 网络请求的状态
typedef NS_ENUM(NSInteger, APIStatus) {
    ELoading,        // 加载中
    ESuccess,        // 请求成功
    EFailure,        // 请求失败：网络失败
};

typedef void(^SAPIBlock)(APIStatus status, id data , AFHTTPRequestOperation* operation);


@interface NetworkAPI : NSObject <NetworkPtc>

DECLARE_SINGLETON(NetworkAPI)

// 发起一个Get请求
- (void)apiGet:(NSString *)keyword withParam:(NSDictionary *)param respondData:(id)data result:(SAPIBlock)block;

// 发起一个Post请求
- (void)apiPost:(NSString *)keyword withParam:(NSDictionary *)param respondData:(id)data result:(SAPIBlock)block;

// post上传一个图片文件
- (void)apiUploadImage:(NSString *)imagePath respondData:(id)data result:(SAPIBlock)block;

// 获取当前网络状态
+ (NETWORK_TYPE)networkType;

@end
