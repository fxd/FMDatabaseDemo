//
//  RefreshControl.h
//  QunariPhone
//
//  Created by 姜琢 on 12-11-20.
//  Copyright (c) 2012年 Qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshControl : UIControl

@property (nonatomic, strong) NSString *startText;       // 未达到触发刷新时的文案
@property (nonatomic, strong) NSString *hintText;       // 达到触发刷新时的文案
@property (nonatomic, strong) NSString *loadingText;    // 刷新中...文案

- (id)initInScrollView:(UIScrollView *)scrollView;

- (id)initWithBlueStyleInScrollView:(UIScrollView *)scrollView;

- (void)beginRefreshing;

- (void)endRefreshing;

- (void)endRefreshingWithoutScrollToTop;

- (void)endRefreshingWithScroll:(BOOL)isScroll;

- (void)endRefreshingWithText:(NSString *)errorText;

@end
