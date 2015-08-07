//
//  HomeDef.h
//  byy
//
//  Created by fengshaobo on 12-11-13.
//  Copyright (c) 2012年 byy All rights reserved.
//

///////////////////////////////////////////////////////////////////////
#pragma mark ---- Common
///////////////////////////////////////////////////////////////////////

// 线直径
#define kLineDiameter               (1 / [[UIScreen mainScreen] scale])

// 屏幕宽度
#define kScreenWidth                ([UIScreen mainScreen].bounds.size.width)






///////////////////////////////////////////////////////////////////////
#pragma mark ---- notification
///////////////////////////////////////////////////////////////////////

#define notifi_receive_watchapp_data                @"receive_watchapp_data"





///////////////////////////////////////////////////////////////////////
#pragma mark ---- VCName
///////////////////////////////////////////////////////////////////////

// ==================== rework ====================

#define kHomeVCName                                 @"HomeVC"

#define kLoginVCName                                @"LoginVC"

#define kRefreshTestVCName                          @"RefreshTestVC"

#define kXibTestVCName                              @"XibTestVC"

#define kBookDetailVC                                @"BookDetailVC"


// ==================== today list ====================

#define kForgetPassworkVC                           @"ForgetPassworkVC"

#define kTListVC                                    @"TListVC"

#define kTListDetailVC                              @"TListDetailVC"

// ==================== today watch ====================

#define kTestWatchVC                                @"TestWatchVC"






///////////////////////////////////////////////////////////////////////
#pragma mark ---- 字体
///////////////////////////////////////////////////////////////////////

// 特小字体
#define kMicroTextFont              kCurNormalFontOfSize(10)

// 小号字体
#define kSmallTextFont              kCurNormalFontOfSize(12)

// 中等字体
#define kMediumFont                 kCurNormalFontOfSize(14)

// 大号字体
#define kLargeTextFont              kCurNormalFontOfSize(16)

// 特小粗体
#define kBoldMicroTextFont          kCurBoldFontOfSize(10)

// 小号粗体
#define kBoldSmallTextFont          kCurBoldFontOfSize(12)

// 中等粗体
#define kBoldMediumTextFont         kCurBoldFontOfSize(14)

// 大号粗体
#define kBoldLargeTextFont          kCurBoldFontOfSize(16)






///////////////////////////////////////////////////////////////////////
#pragma mark ---- 图片
///////////////////////////////////////////////////////////////////////

// NavigationBar
#define	img_book_rework         @"rework.png"

// 首页
#define	img_home_highlight		@"home_highlight.png"

#define	img_home_normal         @"home_normal.png"

