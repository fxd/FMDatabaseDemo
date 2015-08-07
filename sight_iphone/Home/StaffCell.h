//
//  StaffCell.h
//  sight_iphone
//
//  Created by fengshaobo on 15/7/31.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffInfo.h"

@interface StaffCell : UITableViewCell

@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *sexLabel;
@property (nonatomic , weak) IBOutlet UILabel *workLabel;
@property (nonatomic , weak) IBOutlet UILabel *buLabel;

- (void)setStaffInfo:(StaffInfo *)info;

@end
