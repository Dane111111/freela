//
//  XJChooseFriendVersionToIssueVC.m
//  FreeLa
//
//  Created by Leon on 16/6/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJChooseFriendVersionToIssueVC.h"
#import "CYUserModel.h"
#import "EMRemarkImageView.h"
#import "BaseTableViewCell.h"


@interface XJChooseFriendVersionToIssueVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *selectedContacts;
@property (strong, nonatomic) NSMutableArray *blockSelectedUsernames;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIScrollView *footerScrollView;
@property (strong, nonatomic) UIButton *doneButton;

@property (nonatomic , strong) UITableView* xjTableView;
//@property (nonatomic , strong) NSMutableArray* xjDataSourceGroup;
@property (nonatomic , strong) NSMutableArray* xjDataSourceFriend;
@end

@implementation XJChooseFriendVersionToIssueVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (UITableView *)xjTableView {
    if (!_xjTableView) {
        _xjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height) style:UITableViewStyleGrouped];
    }
    return _xjTableView;
}

- (NSMutableArray *)xjDataSourceFriend {
    if (!_xjDataSourceFriend) {
        _xjDataSourceFriend = [NSMutableArray array];
    }
    return _xjDataSourceFriend;
}
- (NSMutableArray *)selectedContacts {
    if (!_selectedContacts) {
        _selectedContacts = [NSMutableArray array];
    }
    return _selectedContacts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self xjInitPageInChooseFriend];
    [self xjLoadInfo];
}


- (void)xjInitPageInChooseFriend {
    self.xjTableView.delegate = self;
    self.xjTableView.dataSource = self;
    self.xjTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.xjTableView];
    self.xjTableView.rowHeight = 60;
    self.xjTableView.allowsMultipleSelectionDuringEditing = YES; // 多选
    self.xjTableView.allowsMultipleSelection = YES;
    [self.view addSubview:self.footerView];
}
#pragma mark ----------------------------------[info]
- (void)xjLoadInfo {
    //清除数据
    [self.xjDataSourceFriend removeAllObjects];
    //群组
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        if (!error) {
            for (EMGroup* xjGroup in groups) {
                CYUserModel* xjModel = [[CYUserModel alloc] init];
                xjModel.userId = xjGroup.groupId;
                xjModel.username = xjGroup.groupSubject;
                xjModel.xjUserType = CYUserModelUserTypeGroup;
                 [self.xjDataSourceFriend addObject:xjModel];
            }
            FL_Log(@"this is the froup of myine=[%@]",groups);
            [self.xjTableView reloadData];
        }
    }onQueue:nil];
    //个人号
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    for (EMBuddy *buddy in buddyList) {
        if (buddy.followState != eEMBuddyFollowState_NotFollowed) {
            if ([buddy.username rangeOfString:@"comp_"].location==NSNotFound) { //个人账号
                CYUserModel* xjModelP = [XJUserProfileManager xjSearchUserModelInLocationBySearchId:buddy.username];
                if(!xjModelP)  return;
                [self.xjDataSourceFriend addObject:xjModelP];
            }
        }
    }
    [self.xjTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
#pragma mark ----------------------------------[info]
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xjDataSourceFriend.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ContactListCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CYUserModel *userModel = self.xjDataSourceFriend[indexPath.row]; //[XJUserProfileManager xjSearchUserModelInLocationBySearchId:buddy.username];
    if (userModel) {
        NSString* xjName = userModel.nickname ? userModel.nickname : (userModel.shortName ? userModel.shortName :userModel.username);
        
        cell.username =  xjName;
        cell.textLabel.text = xjName;
        NSString *imageURL = [XJFinalTool xjReturnImageURLWithStr:userModel.avatar isSite:NO];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"defaultavater"]];
    }
   
 
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CYUserModel *buddy =  self.xjDataSourceFriend[indexPath.row];
    if (![self.selectedContacts containsObject:buddy])
    {
        [self.selectedContacts addObject:buddy];
        
        [self reloadFooterView];
    }
    FL_Log(@"iiiiiiindex=[%ld] buddy.nam=[%@]",indexPath.row,buddy.username);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  xjIndex= indexPath.row;
    CYUserModel *buddy =   self.xjDataSourceFriend[xjIndex];
    if ([self.selectedContacts containsObject:buddy]) {
        [self.selectedContacts removeObject:buddy];
        
        [self reloadFooterView];
    }
    FL_Log(@"iiiiiiindex=[%ld] buddy.nam=[%@]",indexPath.row,buddy.username);
}

- (void)reloadFooterView
{
    [self.footerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat imageSize = self.footerScrollView.frame.size.height;
    NSInteger count = [self.selectedContacts count];
    self.footerScrollView.contentSize = CGSizeMake(imageSize * count, imageSize);
    for (int i = 0; i < count; i++) {
        EMRemarkImageView *remarkView = [[EMRemarkImageView alloc] initWithFrame:CGRectMake(i * imageSize, 0, imageSize, imageSize)];
        CYUserModel *userModel = [self.selectedContacts objectAtIndex:i];
        if (userModel) {
            NSString* xjName = userModel.nickname ? userModel.nickname : (userModel.shortName ? userModel.shortName :userModel.username);
            remarkView.remark = xjName;
            NSString *imageURL = [XJFinalTool xjReturnImageURLWithStr:userModel.avatar isSite:NO];
            [remarkView.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"defaultavater"]];
        }
        [self.footerScrollView addSubview:remarkView];
    }
    
    if ([self.selectedContacts count] == 0) {
        [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    else{
        [_doneButton setTitle:[NSString stringWithFormat:@"完成(%zd)", [self.selectedContacts count]] forState:UIControlStateNormal];
    }
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height -50, self.view.frame.size.width, 50)];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _footerView.backgroundColor = [UIColor colorWithRed:66 / 255.0 green:66 /255.0 blue:64 / 255.0 alpha:1];
        
        _footerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 30 - 70, _footerView.frame.size.height - 5)];
        _footerScrollView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:_footerScrollView];
        
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(_footerView.frame.size.width - 80, 8, 70, _footerView.frame.size.height - 16)];
        //        [_doneButton setBackgroundColor:[UIColor colorWithRed:66 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
        [_doneButton setTitle:@"接受" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor colorWithRed:84 / 255.0 green:214 / 255.0 blue:167 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_doneButton];
        _footerView.userInteractionEnabled = YES;
    }
    
    return _footerView;
}

- (void)doneAction:(id)sender {
    BOOL isPop = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:didFinishSelectedSources:)]) {
//        if ([_blockSelectedUsernames count] == 0) {
//            isPop = [_delegate viewController:self didFinishSelectedSources:self.selectedContacts];
//        }
//        else{
            NSMutableArray *resultArray = [NSMutableArray array];
            for (CYUserModel *buddy in self.selectedContacts) {
                [resultArray addObject:buddy];
            }
            isPop = [_delegate viewController:self didFinishSelectedSources:resultArray];
//        }
    }
    if (isPop) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
@end










