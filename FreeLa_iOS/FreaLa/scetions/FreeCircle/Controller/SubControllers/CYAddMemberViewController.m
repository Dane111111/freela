//
//  CYAddMemberViewController.m
//  FreeLa
//
//  Created by cy on 16/1/13.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYAddMemberViewController.h"
#import "EaseMob.h"

@interface CYAddMemberViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *memberListTableView;
@property(nonatomic,strong)NSArray *buddyList; // 好友列表

@end

@implementation CYAddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationItem.title = @"添加成员";
    
    self.memberListTableView.delegate = self;
    self.memberListTableView.dataSource = self;
    
//    加载好友列表
    self.buddyList =  [[EaseMob sharedInstance].chatManager buddyList];
    NSLog(@"联系人个数是：%zd",self.buddyList.count);
    [self.memberListTableView reloadData];
    
    [self.memberListTableView setEditing:YES animated:YES]; // 进入编辑模式
    self.memberListTableView.allowsMultipleSelectionDuringEditing = YES; // 多选
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

static NSString *ID = @"addmembercell";

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMBuddy *buddy = self.buddyList[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",buddy.username];
    cell.imageView.image = [UIImage imageNamed:@"expression"];
    cell.detailTextLabel.hidden = YES;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (IBAction)onOKClick:(id)sender {
    
//    获取用户选中的用户indexPath
    NSArray *selectedIndexPaths = self.memberListTableView.indexPathsForSelectedRows;
    NSLog(@"你选中了%@",selectedIndexPaths);
//    根据用户indexPath 得到用户名数组
//    NSMutableArray *userNames = [NSMutableArray array];
    for (EMBuddy *buddy in self.buddyList) {
//        userNames addObject:buddy
    }
    
    EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
    
    groupStyleSetting.groupMaxUsersCount = 500; // 创建500人的群，如果不设置，默认是200人。
    groupStyleSetting.groupStyle = eGroupStyle_PublicOpenJoin; // 创建不同类型的群组，这里需要才传入不同的类型
    
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:self.groupName
                                                          description:self.groupDescription
                                                             invitees:@[@"6001",@"6002"]
                                                initialWelcomeMessage:@"邀请您加入群组"
                                                         styleSetting:groupStyleSetting
                                                           completion:^(EMGroup *group, EMError *error) {
                                                               if(!error){
                                                                   NSLog(@"创建成功 -- %@",group);
                                                               }        
                                                           } onQueue:nil];
}


@end
