//
//  UITableView+Utility.m
//  sight_iphone
//
//  Created by fengshaobo on 15/4/6.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import "UITableView+Utility.h"

@implementation UITableView(initcell)

- (id)cellForIdentifier:(NSString*)reuseIdentifier cellClass:(Class)cellClass {
    UITableViewCell* cell = [self dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setWidth:self.width];
        [cell.contentView setWidth:self.width];
    }
    
    return cell;
}

- (id)cellForIdentifier:(NSString*)reuseIdentifier
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setViewWidth:self.width];
    }
    
    return cell;
}

- (id)cellForNibName:(NSString*)nibName
{
    UITableViewCell* cell = [self dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
        [cell setViewWidth:self.width];
    }
    
    return cell;
}


@end
