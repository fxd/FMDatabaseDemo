//
//  AlertViewRelation.h
//  QunariPhone
//
//  Created by 姜琢 on 13-4-12.
//  Copyright (c) 2013年 Qunar.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNameVC.h"

@interface AlertViewRelation : NSObject

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, assign) BaseNameVC *baseNameVC;

@end
