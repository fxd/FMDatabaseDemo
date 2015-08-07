//
//  StaffCell.m
//  sight_iphone
//
//  Created by fengshaobo on 15/7/31.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import "StaffCell.h"

@implementation StaffCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStaffInfo:(StaffInfo *)info {
    self.nameLabel.text = info.name;
    self.sexLabel.text = info.sex;
    self.workLabel.text = info.work;
    self.buLabel.text = info.bu;
}


@end
