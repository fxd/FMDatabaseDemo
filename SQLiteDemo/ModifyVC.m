//
//  ModifyVC.m
//  SQLiteDemo
//
//  Created by fengshaobo on 15/8/7.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

#import "ModifyVC.h"
#import "StaffInfo.h"
#import "UIView+Utility.h"

@interface ModifyVC ()

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UITextField *sexTextField;

@property (nonatomic, strong) UITextField *workTextField;

@property (nonatomic, strong) UITextField *buTextField;

@end


static const CGFloat kHorMargin = 10;
static const CGFloat kVerMargin = 10;

static const CGFloat kTextFieldHeight = 30;

@implementation ModifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"编辑页";

    CGFloat textFieldWidth = self.view.width - kHorMargin * 2;
    CGFloat startY = kVerMargin + 84;
    
    self.nameTextField = [self addTextFieldWithPlaceHolder:@"姓名" toView:self.view];
    self.nameTextField.frame = CGRectMake(kHorMargin, startY, textFieldWidth, kTextFieldHeight);
    self.nameTextField.text = self.staffInfo.name;
    startY += kTextFieldHeight + kVerMargin;
    
    self.sexTextField = [self addTextFieldWithPlaceHolder:@"性别" toView:self.view];
    self.sexTextField.frame = CGRectMake(kHorMargin, startY, textFieldWidth, kTextFieldHeight);
    self.sexTextField.text = self.staffInfo.sex;
    startY += kTextFieldHeight + kVerMargin;

    self.workTextField = [self addTextFieldWithPlaceHolder:@"工作" toView:self.view];
    self.workTextField.frame = CGRectMake(kHorMargin, startY, textFieldWidth, kTextFieldHeight);
    self.workTextField.text = self.staffInfo.work;
    startY += kTextFieldHeight + kVerMargin;

    self.buTextField = [self addTextFieldWithPlaceHolder:@"部门" toView:self.view];
    self.buTextField.frame = CGRectMake(kHorMargin, startY, textFieldWidth, kTextFieldHeight);
    self.buTextField.text = self.staffInfo.bu;
    startY += kTextFieldHeight + kVerMargin;

    CGFloat sureButtonWidth = 100;
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.backgroundColor = [UIColor yellowColor];
    sureButton.frame = CGRectMake((self.view.width - sureButtonWidth) / 2 , startY, sureButtonWidth, 44);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(clickSureButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextField*)addTextFieldWithPlaceHolder:(NSString*)placeHolder toView:(UIView *)parentView {
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleLine;
    textField.font = [UIFont systemFontOfSize:12];
    textField.textColor = [UIColor blackColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [parentView addSubview:textField];
    return textField;
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    if (sender == self.nameTextField) {
        self.staffInfo.name = sender.text;
    } else if (sender == self.sexTextField) {
        self.staffInfo.sex = sender.text;
    } else if (sender == self.workTextField) {
        self.staffInfo.work = sender.text;
    } else if (sender == self.buTextField) {
        self.staffInfo.bu = sender.text;
    }
}

- (IBAction)clickSureButton:(id)sender {
    if (self.modifyBlock) {
        self.modifyBlock(self.staffInfo);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
