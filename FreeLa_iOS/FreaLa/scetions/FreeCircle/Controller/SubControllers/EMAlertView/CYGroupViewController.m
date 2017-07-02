//
//  CYGroupViewController.m
//  FreeLa
//
//  Created by cy on 16/1/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYGroupViewController.h"
#import "CYCreateGroupViewController.h"
#import "CYGroupCell.h"

@interface CYGroupViewController ()

@end

@implementation CYGroupViewController

static NSString* ID = @"group";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden=YES;
    
//    注册cell
    UINib *nib = [UINib nibWithNibName:@"CYGroupCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ID];
//    设置行高
    self.tableView.rowHeight = 80;
//    隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (indexPath.section == 0) {
        cell.groupPortraitImageView.image = [UIImage imageNamed:@"group"];
        cell.groupMsgLabel.text = @"创建群组";
        cell.groupNumLabel.text = @"";
    }else{
        cell.groupPortraitImageView.image = [UIImage imageNamed:@"group"];
        cell.groupMsgLabel.text = @"宁泽涛、宁紫怡等";
        cell.groupNumLabel.text = [NSString stringWithFormat:@"（%@人）",@"13"];
    }
    return cell;
}

// 组名
//设置组名
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"我的群组";
    }
    return @"";
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CYCreateGroupViewController *createGroupVC = [[CYCreateGroupViewController alloc] init];
        [self.navigationController pushViewController:createGroupVC animated:YES];
    }
}

@end
