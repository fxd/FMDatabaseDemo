//
//  BaseNameVC+MFSideMenu.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 10/24/12.
//  Copyright (c) 2012 University of Wisconsin - Madison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNameVC.h"

@class MFSideMenu;

@interface BaseNameVC (MFSideMenu)

@property (nonatomic, strong) MFSideMenu *sideMenuView;

@end
