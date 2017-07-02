//
//  CYCreateGroupViewController.m
//  FreeLa
//
//  Created by cy on 16/1/13.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYCreateGroupViewController.h"
#import "CYAddMemberViewController.h"

@interface CYCreateGroupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *groupDescripitionTextView;
@property (weak, nonatomic) IBOutlet UISwitch *groupAuthorityBtn;
@property (weak, nonatomic) IBOutlet UILabel *groupAuthorityLabel;
@property (weak, nonatomic) IBOutlet UISwitch *memeberAuthorityBtn;
@property (weak, nonatomic) IBOutlet UILabel *memeberAuthorityLabel;

@end

@implementation CYCreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"创建群组";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加成员" style:UIBarButtonItemStyleDone target:self action:@selector(onAddMemberClick)];
    
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
}
//!textField.text || textField.text.length == 0
//[self.groupNameTextField.text isEqualToString:@""] || [self.groupNameTextField.text length]==0
- (void)onAddMemberClick{
//    去掉空格
    NSString *textName = [self.groupNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([textName isEqualToString:@""] || [self.groupNameTextField.text length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"群组名不能为空！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    CYAddMemberViewController *addMemberVC = [[CYAddMemberViewController alloc] init];
    
    addMemberVC.groupName = self.groupNameTextField.text;
    addMemberVC.groupDescription = self.groupDescripitionTextView.text;
    
    [self.navigationController pushViewController:addMemberVC animated:YES];
}

@end
