//
//  CYContactViewController.m
//  FreeLa
//
//  Created by cy on 16/1/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYContactViewController.h"
#import "CYGroupViewController.h"
#import "CYNewFriendViewController.h"
#import "CYChatViewController.h"

#import "CYContactCell.h"

@interface CYContactViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *buddyList; // 好友列表

@end

@implementation CYContactViewController


static NSString *ID = @"contact";

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.tableView.style
    
    // 获取联系人列表（必须登录/自动登录之后才可以获取）
    self.buddyList =  [[EaseMob sharedInstance].chatManager buddyList];
    NSLog(@"联系人个数是：%zd",self.buddyList.count);
    [self.tableView reloadData];
    //    注册
    UINib *nib = [UINib nibWithNibName:@"CYContactCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ID];
    
    [self.tableView setRowHeight:80];
    //    去除分割线
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //    设置字母索引颜色
    //    self.tableView.sectionIndexBackgroundColor
    self.tableView.sectionIndexColor = [UIColor grayColor];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        CYNewFriendViewController *newFriendVC = [[CYNewFriendViewController alloc] init];
        [self.navigationController pushViewController:newFriendVC animated:YES];
    }else if(indexPath.section == 0 && indexPath.row == 1){
        
    }else if (indexPath.section==0 && indexPath.row == 2){
        CYGroupViewController *groupVC = [[CYGroupViewController alloc] init];
        [self.navigationController pushViewController:groupVC animated:YES];
    }else{
        EMBuddy *buddy = self.buddyList[indexPath.row];
        
        CYChatViewController *chatVC = [[CYChatViewController alloc] initWithConversationChatter:buddy.username conversationType:eConversationTypeChat];
        //        chatVC.buddy = buddy; // 传值
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return self.buddyList.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CYContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            cell.userNameLabel.text = @"新朋友";
            cell.portraitImageView.image = [UIImage imageNamed:@"newfriend"];
        }else if (indexPath.row ==1){
            cell.userNameLabel.text = @"商家号";
            cell.portraitImageView.image = [UIImage imageNamed:@"business"];
            cell.noticeNumLabel.hidden = YES;
        }else if (indexPath.row == 2){
            cell.userNameLabel.text = @"群组";
            cell.portraitImageView.image = [UIImage imageNamed:@"group"];
            cell.noticeNumLabel.hidden = YES;
        }
        return cell;
    }else {
        EMBuddy *buddy = self.buddyList[indexPath.row];
        NSLog(@"%@",buddy.username);
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@",buddy.username];
        cell.portraitImageView.image = [UIImage imageNamed:@"expression"];
        cell.noticeNumLabel.hidden = YES;
        return cell;
    }
}

//设置右侧索引栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",
             @"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}

//设置组名
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"";
    }
    return @"P";
}


@end
