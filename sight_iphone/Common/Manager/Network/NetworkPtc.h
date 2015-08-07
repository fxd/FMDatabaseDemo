//
//  NetworkPtc.h
//  QunariPhone
//
//  Created by Neo on 11/15/12.
//  Copyright (c) 2012 Qunar.com. All rights reserved.
//
// ========================================================
// 为了节省Size，该Protocol并未真正使用
// ========================================================
@protocol NetworkPtc <NSObject>

@optional

// 获取网络请求回调
- (void)getSearchNetBack:(id)searchResult forInfo:(id)customInfo;
- (void)getImageNetBack:(UIImage *)image forInfo:(id)customInfo;
- (void)getPayNetBack:(id)payResult forInfo:(id)customInfo;

// 获取图片的Key
- (NSString *)imageKeyForInfo:(id)customInfo;

// 缓存回调
- (void)cacheImageBack:(UIImage *)image forInfo:(id)customInfo;
- (void)cacheSearchBack:(id)searchResult forInfo:(id)customInfo;

@end
