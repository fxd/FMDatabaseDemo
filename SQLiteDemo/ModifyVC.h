//
//  ModifyVC.h
//  SQLiteDemo
//
//  Created by fengshaobo on 15/8/7.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StaffInfo;

typedef void (^ModifyBlock)(StaffInfo *staffInfo);

@interface ModifyVC : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) StaffInfo *staffInfo;

@property (nonatomic, copy) ModifyBlock modifyBlock;

@end
