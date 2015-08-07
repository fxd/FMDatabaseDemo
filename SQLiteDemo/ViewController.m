//
//  ViewController.m
//  SQLiteDemo
//
//  Created by fengshaobo on 15/8/7.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import "ViewController.h"
#import "SQLManager.h"
#import "StaffCell.h"
#import "ModifyVC.h"

@interface ViewController ()

@property (nonatomic , strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *staffArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    self.staffArray = [NSMutableArray array];
    
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setBackgroundColor:[UIColor whiteColor]];
    [_table setBackgroundView:nil];
    [_table setDataSource:self];
    [_table setDelegate:self];
    [self.view addSubview:self.table];
    
    // 增
    [SQLManager initDatabase];
    
    // 查
    self.staffArray = [SQLManager queryFromTable:StaffTable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *identifier = @"StaffCell";
    StaffCell* cell = (StaffCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StaffCell" owner:nil options:nil] lastObject];
    }
    [cell setStaffInfo:staffInfo];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak typeof(self) weakSelf = self;
    StaffInfo *staffInfo = self.staffArray[indexPath.row];
    [staffInfo printInfo];
    ModifyVC *modifyVC = [[ModifyVC alloc] init];
    modifyVC.staffInfo = staffInfo;
    [modifyVC setModifyBlock:^(StaffInfo *staffInfo) {
        [weakSelf modifyStaffInfo:staffInfo];
    }];
    [self.navigationController pushViewController:modifyVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    StaffInfo *staffInfo = self.staffArray[indexPath.row];
    [staffInfo printInfo];
    [self deleteStaffInfo:staffInfo];
}

#pragma mark - database operation

- (void)modifyStaffInfo:(StaffInfo *)staffInfo {
    //TODO: 在SQLManager中实现修改方法
}

- (void)deleteStaffInfo:(StaffInfo *)staffInfo {
    //TODO: 在SQLManager中实现删除方法
}

@end
