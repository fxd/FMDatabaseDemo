//
//  NetworkStatus.h
//  QunarIphone
//
//  Created by Neo on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkStatus : NSObject

@property (nonatomic, strong, readonly, getter = returnCode) NSNumber *code;            // 返回代码
@property (nonatomic, strong, readonly, getter = returnDesc) NSString *desc;             // 返回描述
@property (nonatomic, strong, readonly, getter = returnInfo) NSString *info;            // 返回信息

@end
