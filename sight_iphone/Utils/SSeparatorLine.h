//
//  SeperatorLine.h
//  Sight
//
//  Created by yue.dai on 14/1/1.
//  Copyright (c) 2014年 Qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	@brief 分隔线view width > height 为横线，否则为竖线
 *  注意在auto-layout下使用时，必须加上height的constraint，且优先级有效 
 */
@interface SSeparatorLine : UILabel

+(id)line;

@end
