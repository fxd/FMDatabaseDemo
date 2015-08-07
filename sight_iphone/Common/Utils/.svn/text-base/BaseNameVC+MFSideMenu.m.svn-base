//
//  UINavigationController+MFSideMenu.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 10/24/12.
//  Copyright (c) 2012 University of Wisconsin - Madison. All rights reserved.
//

#import "BaseNameVC+MFSideMenu.h"
#import "MFSideMenu.h"
#import <objc/runtime.h>

@implementation BaseNameVC (MFSideMenu)

static char menuKey;

- (void)setSideMenuView:(MFSideMenu *)sideMenuView
{
    objc_setAssociatedObject(self, &menuKey, sideMenuView, OBJC_ASSOCIATION_RETAIN);
}

- (MFSideMenu *)sideMenuView
{
    return (MFSideMenu *)objc_getAssociatedObject(self, &menuKey);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.sideMenuView performSelector:@selector(viewControllerWillAppear)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.sideMenuView performSelector:@selector(viewControllerDidAppear)];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.sideMenuView performSelector:@selector(viewControllerDidDisappear)];
}

@end
