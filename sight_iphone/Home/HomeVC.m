//
//  HomeVC.m
//  sight_iphone
//
//  Created by fengshaobo on 15/4/5.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import "HomeVC.h"
#import "UITableView+Utility.h"
#import "SQLManager.h"
#import "StaffInfo.h"
#import "StaffCell.h"


@interface HomeVC ()

@property (nonatomic , strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *staffArray;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.staffArray = [NSMutableArray array];
    
    [self layoutRootViewDefault:self.view];
    [self stopLoading:YES];
    
    // NavigationBar
    [naviBar setTitle:@"目录"];
    
    NaviBarItem *rightBarButton = [[NaviBarItem alloc] initTextItem:@"增加" target:self action:@selector(addStaff)];
    rightBarButton.frame = CGRectMake(0, 0, 40, 40);
    [naviBar setRightBarItem:rightBarButton];
    
    self.table = [[UITableView alloc] initWithFrame:viewContent.bounds style:UITableViewStylePlain];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setBackgroundColor:[UIColor whiteColor]];
    [_table setBackgroundView:nil];
    [_table setDataSource:self];
    [_table setDelegate:self];
    [viewContent addSubview:_table];
    
    self.table.frame = viewContent.bounds;
    [viewContent addSubview:self.table];
    
    [SQLManager initDatabase];
    
    self.staffArray = [SQLManager queryFromTable:StaffTable];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - database operation
- (void)addStaff {
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.staffArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StaffInfo *staffInfo = self.staffArray[indexPath.row];
    StaffCell *cell = [tableView cellForNibName:@"StaffCell"];
    [cell setStaffInfo:staffInfo];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


@end
