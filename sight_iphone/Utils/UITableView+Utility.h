//
//  UITableView+Utility.h
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView(initcell)

- (id)cellForIdentifier:(NSString*)reuseIdentifier cellClass:(Class)cellClass;

- (id)cellForIdentifier:(NSString*)reuseIdentifier;

- (id)cellForNibName:(NSString*)nibName;

@end