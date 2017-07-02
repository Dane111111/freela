//
//  CYNewFriendViewController.m
//  FreeLa
//
//  Created by cy on 16/1/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYNewFriendViewController.h"
#import "CYNewFriendCell.h"

@interface CYNewFriendViewController ()

@end

@implementation CYNewFriendViewController

static NSString *ID = @"newfriend";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden=YES;
    
    //    注册cell
    UINib *nib = [UINib nibWithNibName:@"CYNewFriendCell" bundle:nil];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.newfriendPortrait.image = [UIImage imageNamed:@"official"];
    cell.newfriendSrc.text = @"来自条件查找";
    cell.newfriendName.text = @"免费啦官方";
    
    return cell;
}

@end
