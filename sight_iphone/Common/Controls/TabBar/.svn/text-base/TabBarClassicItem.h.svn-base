//
//  TabBarItem.h
//  QunariPhone
//
//  Created by Neo on 11/23/12.
//  Copyright (c) 2012 Qunar.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"TabBarItem.h"


@interface TabBarClassicItem : TabBarItem <TabBarItemPtc>
{
	UIImageView *imageViewIcon;		// iCON
	UIImage *image;					// 常态图片
	UIImage *imageSelect;			// 选中态图片
    UIImage *imageDisable;          // 不可用图片
	UILabel *labelText;				// 文本标签
	NSString *text;					// 文本
}

// 初始化
- (id)initWithText:(NSString *)textInit andImage:(UIImage *)imageInit andSelectImage:(UIImage *)imageSelectInit;
- (id)initWithText:(NSString *)textInit
          andImage:(UIImage *)imageInit
    andSelectImage:(UIImage *)imageSelectInit
   andDisableImage:(UIImage *)imageDisableInit;

@end
