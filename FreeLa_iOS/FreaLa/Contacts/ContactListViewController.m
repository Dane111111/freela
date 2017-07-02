//
//  ContactListViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/24.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "ContactListViewController.h"

#import "EaseChineseToPinyin.h"
#import "ChatViewController.h"
//#import "RobotListViewController.h"
//#import "ChatroomListViewController.h"
#import "AddFriendViewController.h"
#import "ApplyViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
#import "UserProfileManager.h"

#import <Masonry.h>
#import "CYHTTPRequestManager.h"
#import "CYUserModel.h"
#import "XJBusContactListViewController.h"
#import "XJUserProfileManager.h"
static BOOL xj_isPerseonChanged; //角色是否更换
@implementation EMBuddy (search)

//根据用户昵称进行搜索
- (NSString*)showName
{
    // 用户信息 管理类
    return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.username];
}

@end

@interface ContactListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,BaseTableCellDelegate,UIActionSheetDelegate,EaseUserCellDelegate,EMChatManagerDelegate,EMChatManagerBuddyDelegate>
{
    NSIndexPath *_currentLongPressIndex;// 当前长按的index
    NSString*    _xjFriendDidAcceptMyRequest; //此用户是不是同意 了我的好友请求，因为同意会执行两次
    NSString*    _xjFriendDidRefuseMyRequest; //此用户是不是拒绝 了我的好友请求，因为同意会执行两次
}

@property (strong, nonatomic) NSMutableArray *sectionTitles; // 标题数组
@property (strong, nonatomic) NSMutableArray *contactsSource; // 联系人数组

@property (nonatomic) NSInteger unapplyCount;// 没有处理的数量
@property (strong, nonatomic) EMSearchBar *searchBar;// 搜索Bar

@property (strong, nonatomic) EMSearchDisplayController *searchController;// 搜索控制器

@property(nonatomic,strong)NSMutableArray *myUserModelArr; // 我添加的模型数组



@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    xj_isPerseonChanged = FLFLIsPersonalAccountType; //设置角色初始值
    self.showRefreshHeader = YES; //
    
    _contactsSource = [NSMutableArray array];// 初始化两个数组
    _sectionTitles = [NSMutableArray array];
    
    [self tableViewDidTriggerHeaderRefresh];
    
    [self searchController]; // 懒加载控制器
    //    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);// searchBar --> self.view
    //    [self.view addSubview:self.searchBar];
    // 内部是有一个tableView的
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去除分割线
    self.tableView.sectionIndexColor = [UIColor grayColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0); // 设置滚动区域
    //    [self reloadDataSource];// 重新加载数据
    
    // 环信UIdemo中有用到Parse, 加载用户好友个人信息  ？？？
    // EMBuddy 数组 --> 用户名 数组
    //    [[UserProfileManager sharedInstance] loadUserProfileInBackgroundWithBuddy:self.contactsSource saveToLoacal:YES completion:NULL];
    // 2016年01月18日12:04:50  申请好友通知  EMChatManagerDelegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadApplyView];
    if (xj_isPerseonChanged != FLFLIsPersonalAccountType) {
        xj_isPerseonChanged = FLFLIsPersonalAccountType; //设置角色初始值
        [self tableViewDidTriggerHeaderRefresh]; // 刷新好友列表
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter
// 导航栏上右边的按钮
- (NSArray *)rightItems
{
    if (_rightItems == nil) {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"addContact.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addContactAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        _rightItems = @[addItem];
    }
    
    return _rightItems;
}
// 搜索栏
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}
// 搜索控制器
- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ContactListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            EMBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
            cell.textLabel.text = buddy.username;
            cell.username = buddy.username;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            EMBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:buddy.username]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能和自己聊天" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
            
            [weakSelf.searchController.searchBar endEditing:YES];
            //            ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:buddy.username
            //                                                                                conversationType:eConversationTypeChat];
            //            chatVC.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy.username];
            //            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        }];
    }
    
    return _searchController;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count] + 1;// dataArray 数组？？？
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    
    return [[self.dataArray objectAtIndex:(section - 1)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.model = nil;
        if (indexPath.row == 0) {// 申请与通知
            NSString *CellIdentifier = @"addFriend";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.avatarView.image = [UIImage imageNamed:@"newFriends"];
            cell.titleLabel.text = @"新的朋友";
            cell.avatarView.badge = self.unapplyCount;
            return cell;
        }
        else if (indexPath.row == 1) {// 商家号
            cell.avatarView.image = [UIImage imageNamed:@"business"];
            cell.titleLabel.text = @"商家号";
        }
        else if (indexPath.row == 2) {// 群组
            cell.avatarView.image = [UIImage imageNamed:@"group"];
            cell.titleLabel.text = @"群组";
        }
    } else {
        if (self.dataArray.count > indexPath.section - 1) {
            NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
            EaseUserModel *model = [userSection objectAtIndex:indexPath.row];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.model = model;
        }
        //        UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.buddy.username];
        //        if (profileEntity) {
        //            model.avatarURLPath = profileEntity.imageUrl;
        //            model.nickname = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
        //        }
        
        //        if (self.myUserModelArr.count != 0) {
        //            CYUserModel *cyUserModel = [self.myUserModelArr objectAtIndex:indexPath.row];
        //            if (cyUserModel) {
        //                EMBuddy *tempBuddy = [EMBuddy buddyWithUsername:model.nickname];
        //                EaseUserModel *tempModel = [[EaseUserModel alloc] initWithBuddy:tempBuddy];
        //                tempModel.avatarURLPath = cyUserModel.avatar;
        //                tempModel.nickname = cyUserModel.nickname;
        //                model = tempModel;
        //            }
        //        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    if (self.sectionTitles.count > section - 1) {
        [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];  // 6 -- [0 5]
    }
    [contentView addSubview:label];
    
    return contentView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            ApplyViewController *applyVC = [ApplyViewController shareController];
            applyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyVC animated:YES];
        }
        else if (row == 1) {
            XJBusContactListViewController* xjBusVC = [[XJBusContactListViewController alloc] init];
            [xjBusVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:xjBusVC animated:YES];
        }
        else if (row == 2)
        {
            if (_groupController == nil) {
                _groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
            }
            else{
                [_groupController reloadDataSource];
            }
            _groupController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:_groupController animated:YES];
        }
    }
    else{
        EaseUserModel *model = [[self.dataArray objectAtIndex:(section - 1)] objectAtIndex:row];
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0) {
            if ([loginUsername isEqualToString:model.buddy.username]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能和自己聊天" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
                return;
            }
        }
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:model.buddy.username conversationType:eConversationTypeChat];
        chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy.username;
        chatController.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        if ([model.buddy.username isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能删除自己" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager removeBuddy:model.buddy.username removeFromRemote:YES error:&error];
        if (!error) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.buddy.username deleteMessages:YES append2Chat:YES];
            
            [tableView beginUpdates];
            [[self.dataArray objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
            [self.contactsSource removeObject:model.buddy];
            [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView  endUpdates];
        }
        else{
            [self showHint:[NSString stringWithFormat:@"删除失败%@", error.description]];
            [tableView reloadData];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - BaseTableCellDelegate

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1) {
        // 群组，聊天室
        return;
    }
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.buddy.username isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"加入黑名单" otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - action
- (void)addContactAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - private data

- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    
    //    NSMutableArray *contactsSource = [NSMutableArray array];
    
    //从获取的数据中剔除黑名单中的好友
    //    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
    //f放出 黑名单好友
    //    for (EMBuddy *buddy in blockList) {
    //
    //        if (buddy) {
    //            [[EaseMob sharedInstance].chatManager unblockBuddy:buddy];
    //        }
    //    }
    
    //    for (EMBuddy *buddy in buddyList) {
    //        if (![blockList containsObject:buddy.username]) {
    //            [contactsSource addObject:buddy];
    //        }
    //    }
    //
    //    NSLog(@"好有个数---- %zd",[contactsSource count]); // 7个
    //    在此处取向自己的服务器请求数据，
    [self loadNickName_AvatarURLWithBuddyList:buddyList];
}

- (void)tempMethod:(NSArray*)contactsSource{
    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    //    初始化可变数组对象的长度，如果后面代码继续添加数组超过长度以后NSMutableArray的长度会自动扩充
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //    //按首字母分组
    //    for (EMBuddy *buddy in contactsSource) {
    //        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
    //        if (model) {
    //            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    ////            model.nickname = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy.username];
    ////            model setValue:<#(nullable id)#> forKeyPath:@""
    //
    ////            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:[[UserProfileManager sharedInstance] getNickNameWithUsername:buddy.username]];
    ////             model.nickname  person_6
    //            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:model.nickname];
    //            NSLog(@"首字符%@",firstLetter);
    //            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
    //
    //            NSMutableArray *array = [sortedArray objectAtIndex:section];
    //            [array addObject:model];
    //        }
    //    }
    for (int i = 0; i < [contactsSource count]; i++) {
        EMBuddy *buddy = contactsSource[i];
        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
        if (model && [self.myUserModelArr count] != 0) {
            if (self.myUserModelArr.count > i) {
                CYUserModel *userModel = self.myUserModelArr[i];
                model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
                if (userModel.shortName != nil) {
                    [model setValue:userModel.shortName forKeyPath:@"nickname"];
                } else if(userModel.nickname !=nil){
                    [model setValue:userModel.nickname forKeyPath:@"nickname"];
                }
                [model setValue:userModel.avatar forKeyPath:@"avatarURLPath"];
                NSLog(@"更改后的昵称 %@",model.nickname);
                if (model.nickname) {
                    //            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:[[UserProfileManager sharedInstance] getNickNameWithUsername:buddy.username]];
                    //             model.nickname  person_6
                    NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:model.nickname];
                    if ([model.nickname isEqualToString:@""]) {
                        firstLetter = @"#";
                    }
                    NSLog(@"首字符%@",firstLetter);
                    if ([XJFinalTool xjStringSafe:firstLetter]) {
                        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
                        NSMutableArray *array = [sortedArray objectAtIndex:section];
                        [array addObject:model];
                    }
                }
            }
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy.username];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy.username];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    NSLog(@"标题 %@",self.sectionTitles);
    [self.dataArray addObjectsFromArray:sortedArray];
}

#pragma mark - EaseUserCellDelegate

- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    if (indexPath.section == 0 && indexPath.row >= 1) {
    //        // 群组，聊天室
    //        return;
    //    }
    //    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    //    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    //    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    //    if ([model.buddy.username isEqualToString:loginUsername])
    //    {
    //        return;
    //    }
    //
    //    _currentLongPressIndex = indexPath;
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"加入黑名单" otherButtonTitles:nil, nil];
    //    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    //此功能暂时隐藏
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex && _currentLongPressIndex) {
        EaseUserModel *model = [[self.dataArray objectAtIndex:(_currentLongPressIndex.section - 1)] objectAtIndex:_currentLongPressIndex.row];
        [self hideHud];
        [self showHudInView:self.view hint:@"请等待..."];
        
        __weak typeof(self) weakSelf = self;
        [[EaseMob sharedInstance].chatManager asyncBlockBuddy:model.buddy.username relationship:eRelationshipFrom withCompletion:^(NSString *username, EMError *error){
            typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf hideHud];
            if (!error) {
                //由于加入黑名单成功后会刷新黑名单，所以此处不需要再更改好友列表
                //                [strongSelf.dataArray removeAllObjects];
                //                [self tableViewDidTriggerHeaderRefresh];
            } else {
                [strongSelf showHint:error.description];
            }
        } onQueue:nil];
    }
    _currentLongPressIndex = nil;
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh {
    //    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak ContactListViewController *weakSelf = self;
    [[[EaseMob sharedInstance] chatManager] asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (error == nil) {
                [self.contactsSource removeAllObjects];
                [self.contactsSource addObjectsFromArray:buddyList];
                NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
                NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
                if (loginUsername && loginUsername.length > 0) {
                    EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
                    [self.contactsSource addObject:loginBuddy];
                }
                
                [weakSelf _sortDataArray:self.contactsSource];
            } else{
                [weakSelf showHint:@"加载数据失败！"];
                [self huanxinLogin];
            }
            
            [weakSelf tableViewDidFinishTriggerHeader:YES reload:YES];
        });
    } onQueue:nil];
}

// 登录
- (void)huanxinLogin{
    NSString *userName = [NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE];
    NSLog(@"cyuserid %@",userName);
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:@"123456" completion:^
     (NSDictionary *loginInfo, EMError *error) {
         if (!error && loginInfo) {
             FL_Log(@"登录成功Wsith环信");
         }
     } onQueue:nil];
    // 设置自动登录
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
    [self saveLastLoginUsername]; // 保存一下，以后会用得到
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
}

- (void)didLogoffWithError:(EMError *)error {
    if (error.errorCode == EMErrorServerNotReachable) {
        [FLTool showWith:@"链接服务器失败"];
    }
}
- (void)saveLastLoginUsername {
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}

#pragma mark - public
- (void)reloadDataSource {
    [self.dataArray removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList]; // 所有好友列表
    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList]; // 黑名单列表
    for (EMBuddy *buddy in buddyList) {   // 遍历 好友列表，只有没有在黑名单的才添加进去
        if (![blockList containsObject:buddy.username]) {
            [self.contactsSource addObject:buddy];
        }
    }
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo]; // 获取用户信息字典
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername]; // 通过字典 获取用户名
    if (loginUsername && loginUsername.length > 0) {
        EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername]; // 用户名 --> EMBuddy对象
        [self.contactsSource addObject:loginBuddy]; // 将“我”也添加到 EMBuddy数组中
    }
    
    [self _sortDataArray:self.contactsSource];// 右边字母索引
    //    [self.tableView reloadData];// 重新加载数据
}

- (void)reloadApplyView
{
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    self.unapplyCount = count;
    [self.tableView reloadData];
}

- (void)reloadGroupView
{
    [self reloadApplyView];
    
    if (_groupController) {
        [_groupController reloadDataSource];
    }
}

- (void)addFriendAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - EMChatManagerBuddyDelegate
- (void)didUpdateBlockedList:(NSArray *)blockedList
{
    [self reloadDataSource];
}

#pragma mark - ----
#pragma mark 好友请求被同意
-(void)didAcceptedByBuddy:(NSString *)username{
    if ([_xjFriendDidAcceptMyRequest isEqualToString: username]) {
        return;
    }
    _xjFriendDidAcceptMyRequest = username;
    NSDictionary *params = @{
                             @"idsArray":username
                             };
    [FLNetTool xjfindListByIdsByParm:params success:^(NSDictionary *data) {
        FL_Log(@"this is tmy li4st of frinegs =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            CYUserModel * xjModel = [CYUserModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY][0]];
            NSString *message = [NSString stringWithFormat:@"%@ 同意了你的好友请求",xjModel.nickname];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加消息" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 好友请求被拒绝
-(void)didRejectedByBuddy:(NSString *)username{
    if ([_xjFriendDidRefuseMyRequest isEqualToString: username]) {
        return;
    }
    _xjFriendDidRefuseMyRequest = username;
    NSDictionary *params = @{
                             @"idsArray":username
                             };
    [FLNetTool xjfindListByIdsByParm:params success:^(NSDictionary *data) {
        FL_Log(@"this is tmy li4st of frinegs =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            CYUserModel * xjModel = [CYUserModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY][0]];
            NSString *message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求",xjModel.nickname];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加消息" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark 接收好友的添加请求
-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    FL_Log(@"haohaohaoahoahoahoahohaohaohaohaohaohaohaohaohoahoahoyou");
    if (!username) {
        return;
    }
    if (!message) {
        message = [NSString stringWithFormat:@"%@ 添加你为好友", username];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    [[ApplyViewController shareController] addNewApply:dic];
    [self setupUntreatedApplyCount]; // 底部tabbar红点提示
    [self reloadApplyView];// 新的朋友cell 红点提示
}

- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    NSLog(@"未读个数 %zd",unreadCount);
    if (unreadCount > 0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
    }else{
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)myUserModelArr{
    if (_myUserModelArr == nil) {
        _myUserModelArr = [NSMutableArray array];
    }
    return _myUserModelArr;
}

#pragma mark - 自己添加的方法，向服务器请求数据好友列表信息
- (void)loadNickName_AvatarURLWithBuddyList:(NSArray*)buddyList{
    if(buddyList.count > 0 ){
        
        NSString *friendIDList = @","; //    拼接请求参数 ',person_1,person_2,'
        NSMutableArray* xjNewBuddyList = @[].mutableCopy;
        for (EMBuddy *buddy in buddyList){
            //这里只有个人账号
            if (![FLTool returnBoolWithIsHasHTTP:buddy.username includeStr:@"comp_"]) {
                friendIDList = [friendIDList stringByAppendingFormat:@"%@,",buddy.username];
                [xjNewBuddyList addObject:buddy];
            }
        }
        
        FL_Log(@"请求参数 %@",friendIDList);
        NSDictionary *params = @{
                                 @"idsArray":friendIDList
                                 };
        [FLNetTool xjfindListByIdsByParm:params success:^(NSDictionary *data) {
            FL_Log(@"this is tmy li5st of frinegs =%@",data);
        } failure:^(NSError *error) {
            
        }];
        
        
        NSString *url = [NSString stringWithFormat:@"%@/app/chats!findListByIds.action",FLBaseUrl];//@"http://59.108.126.36:8888/app/chats!findListByIds.action";
        //        阿里云：
        //        NSString *url = @"http://123.57.35.196:80/app/chats!findListByIds.action";
        
        //    发起请求
        CYHTTPRequestManager *mgr = [CYHTTPRequestManager manager];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
        //Request failed: unacceptable content-type: text/plain"
        
        [mgr POST:url parameters:params success:^(AFHTTPRequestOperation * operation,NSDictionary* responseObject) {
            self.myUserModelArr = [CYUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSLog(@"%@",self.myUserModelArr);
            NSLog(@"请求到的卧槽数据 %zd",self.myUserModelArr.count);
            [self tempMethod:xjNewBuddyList];
            
            //                数据缓存
            //                将获取到的  friendIDList   self.myUserModelArr  存起来
//            UILabel*label=[[UILabel alloc]init];
//            label.font=[UIFont systemFontOfSize:15];
//            label.textColor=[UIColor blueColor];
//            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//            label.textAlignment=NSTextAlignmentCenter;
//            label.frame=CGRectMake(0, 0, 100, 100);
//            
//            [window addSubview:label];
//            [window mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(self.tableView.mas_centerX);
//                make.centerY.mas_equalTo(self.tableView.mas_centerY);
//
//            }];
            CYUserProfileTool *userProfileTool = [CYUserProfileTool share];
            CYUserModel *tempModel;
            EMBuddy *tempBuddy;
            for (int i = 0 ;i < [xjNewBuddyList count] ; i++) {
                if (self.myUserModelArr.count > i ) {
                    tempModel = self.myUserModelArr[i];
                    tempBuddy = xjNewBuddyList[i];
                    [userProfileTool addModel:tempModel withUserID:tempBuddy.username];
                    [XJUserProfileManager xjAddUserModelInLocation:tempModel bySearchId:tempBuddy.username userType:CYUserModelUserTypePerson];
//                    label.text=[NSString stringWithFormat:@"正在加载通讯录数据%d/%ld",i,xjNewBuddyList.count];
                    FL_Log(@"原因是不是在这儿啊在这人啊 啊撒大声地啊啊啊？=%@",tempBuddy.username);
                }
            }
//            [label removeFromSuperview];
            FL_Log(@"原因是不是在这儿啊在这人啊 啊啊啊啊？=[%@],,,,,,==[%@]",self.myUserModelArr,[CYUserProfileTool share].userId_Model);
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];

        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"%@",error);
            NSLog(@"%@",@"啊哦in con失败了");
        }];
    }else{
        NSLog(@"拉取用户头像昵称失败");
    }
}

- (void)didLoginFromOtherDevice {
    [FLTool showWith:@"账号异地登陆，如不是本人操作，请检查账号安全性"];
    [XJFinalTool xjRemoveUserInfoInUserdefaultskey:XJ_VERSION2_PHONE];
    [XJFinalTool xjRemoveUserInfoInUserdefaultskey:FL_USERDEFAULTS_USERID_KEY];
    [self performSelector:@selector(xjLogInAction) withObject:nil afterDelay:1];
    
}

- (void)xjLogInAction {
    FLLogIn_RegisterViewController* logInVC  = [[FLLogIn_RegisterViewController alloc] init ];//WithNibName:@"FLLogIn_RegisterViewController" bundle:nil];
    [self presentViewController:logInVC animated:YES completion:nil];
}

@end










