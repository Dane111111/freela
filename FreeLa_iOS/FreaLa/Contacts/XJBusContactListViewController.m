//
//  XJBusContactListViewController.m
//  FreeLa
//
//  Created by Leon on 16/6/20.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJBusContactListViewController.h"
#import "ChatViewController.h"
#import "XJUserProfileManager.h"
@interface XJBusContactListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) XJTableView* xjTableView;
@property (nonatomic , strong) NSMutableArray* xjBusContactArr;
@end

@implementation XJBusContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self xjInitPagesInBusContactList];
    
}

- (void) xjInitPagesInBusContactList {
    self.title = @"商家号";
    self.xjTableView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height - 49);
    self.xjTableView.tableFooterView = [[UIView alloc] init];
    self.xjTableView.delegate = self;
    self.xjTableView.dataSource = self;
    self.xjTableView.mj_header = [XJBirdFlyGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(xjRefreshBusContactList)];
    [self.view addSubview:self.xjTableView];
    [self.xjTableView.mj_header beginRefreshing];
}
#pragma  mark   - ---- - -- - -- -Lazy

- (XJTableView *)xjTableView {
    if (!_xjTableView) {
        _xjTableView = [[XJTableView alloc] init];
    }
    return _xjTableView;
}

- (NSMutableArray *)xjBusContactArr {
    if (!_xjBusContactArr) {
        _xjBusContactArr = [NSMutableArray array];
    }
    return _xjBusContactArr;
}
#pragma  mark   - ---- - -- - -- -Action

- (void)xjRefreshBusContactList {
    [self.xjBusContactArr removeAllObjects];
    NSArray* xjArr = [[[EaseMob sharedInstance] chatManager] buddyList];
    [self loadNickName_AvatarURLWithBuddyList:xjArr];

}

#pragma  mark   - ---- - -- - -- -tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xjBusContactArr.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    EaseUserModel *model = self.xjBusContactArr[indexPath.row];
    cell.indexPath = indexPath;
//    cell.delegate = self;   //长按 事件，不考虑
    cell.model = model;
    
    return cell;
}


- (void)loadNickName_AvatarURLWithBuddyList:(NSArray*)buddyList{
    NSMutableArray* xjBuddyNew = @[].mutableCopy;
    if(buddyList.count > 0 ){
        NSString *friendIDList = @","; //    拼接请求参数 ',person_1,person_2,'
        for (EMBuddy *buddy in buddyList){
            //这里只有商家账号
            if ([FLTool returnBoolWithIsHasHTTP:buddy.username includeStr:@"comp_"]) {
                friendIDList = [friendIDList stringByAppendingFormat:@"%@,",buddy.username];
                [xjBuddyNew addObject:buddy];
            }
        }
        
        FL_Log(@"请求参数 %@",friendIDList);
        NSDictionary *params = @{
                                 @"idsArray":friendIDList
                                 };
        [FLNetTool xjfindListByIdsByParm:params success:^(NSDictionary *data) {
            FL_Log(@"this is tsmy li5st of frinegs =%@",data);
            if ([data[FL_NET_KEY_NEW] boolValue]) {
                NSMutableArray* xjMu = @[].mutableCopy;
                xjMu = [CYUserModel mj_objectArrayWithKeyValuesArray:data[FL_NET_DATA_KEY]];
                
                CYUserProfileTool *userProfileTool = [CYUserProfileTool share];
                CYUserModel *tempModel;
                EMBuddy *tempBuddy;
                for (int i = 0 ;i < [xjMu count] ; i++) {
                    if (xjMu.count > i ) {
                        tempModel = xjMu[i];
                        tempBuddy = xjBuddyNew[i];
                        [userProfileTool addModel:tempModel withUserID:tempBuddy.username];
                        [XJUserProfileManager xjAddUserModelInLocation:tempModel bySearchId:tempBuddy.username userType:CYUserModelUserTypeBus];
                        FL_Log(@"原因是不是d 在这儿啊在这人啊 啊撒大声地啊啊啊？=%@",tempBuddy.username);
                        
                        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:tempBuddy];
                        CYUserModel *userModel = xjMu[i];
                        [model setValue:userModel.avatar forKeyPath:@"avatarURLPath"];
                        [model setValue:userModel.shortName ? userModel.shortName :userModel.username ? userModel.username :@"#" forKeyPath:@"nickname"];
                        FL_Log(@"这儿到底他妈的存了个啥===【%@】",userModel.shortName ? userModel.shortName :userModel.username ? userModel.username :@"#");
                        [self.xjBusContactArr addObject:model];
                    }
                }
               
                FL_Log(@"原因是不是dsfdsfdsg在这儿啊在这人啊 啊啊啊啊？=[%@],,,,,,==[%@]",self.xjBusContactArr,[CYUserProfileTool share].userId_Model);
                [self.xjTableView reloadData];
                [self.xjTableView.mj_header endRefreshing];
            }
        } failure:^(NSError *error) {
            [self.xjTableView.mj_header endRefreshing];
        }];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    EaseUserModel *model = self.xjBusContactArr[indexPath.row];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:model.buddy.username conversationType:eConversationTypeChat];
    chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy.username;
    chatController.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
    [self.navigationController pushViewController:chatController animated:YES];
}




@end










