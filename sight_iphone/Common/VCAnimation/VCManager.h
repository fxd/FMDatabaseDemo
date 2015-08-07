//
//  VCManager.h
//  Qunar_ipad
//
//  Created by tang Helen on 11-9-27.
//  Copyright 2011年 去哪网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCController.h"

@interface VCManager : NSObject

// ==================================================================================
#pragma mark - mainVCC
// ==================================================================================
+ (VCController *)mainVCC;

// 获取AppFrame
+ (CGRect)getAppFrame;

// ==================================================================================
#pragma mark - ucLoginVCC
// ==================================================================================
+ (VCController *)ucLoginVCC;

+ (void)ucLoginShow:(PopNameVC *)popNameVC;

+ (void)ucLoginDismiss;

+ (UIWindow *)ucLoginWindow;

@end
