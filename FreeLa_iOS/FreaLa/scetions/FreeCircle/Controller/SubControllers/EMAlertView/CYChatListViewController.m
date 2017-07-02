//
//  CYChatViewController.m
//  FreeLa
//
//  Created by cy on 16/1/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYChatListViewController.h"
#import "EaseMob.h"
#import "EMAlertView.h"
#import "CYSearchViewController.h"
#import "CYChatListCell.h"
 
@interface CYChatListViewController ()<EMChatManagerDelegate,UIAlertViewDelegate>

@property(nonatomic,weak)UITextField *searchTF; // 搜索输入框

@property(nonatomic,strong)NSArray *conversations;

/** 好友的名称 */
@property (nonatomic, copy) NSString *buddyUsername;

@end

@implementation CYChatListViewController

static NSString* ID = @"chatlist";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSearchView];
    
    // 1.获取历史会话记录
    [self loadConversations];
    
    // 2.添加代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
//    //    注册cell
    UINib *nib = [UINib nibWithNibName:@"CYChatListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ID];
    //    设置行高
    self.tableView.rowHeight = 80;
    //    隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - UITableViewDelegate
// 不允许高亮  为什么就点不了了？？？
//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(void)viewDidAppear:(BOOL)animated{
    [self refreshUI];
}

// 刷新界面 -- 设置TabBar/应用图标  的红点提示
-(void)refreshUI{
    [self.tableView reloadData];
    // 1.设置tabbarButton的总未读数
    NSInteger totalCount = 0;
    for (EMConversation *conversation in self.conversations) {
        totalCount += [conversation unreadMessagesCount];
    }
    
    if (totalCount > 0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",totalCount];
    }else{
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
    //AppIcon的badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = totalCount;
    
}

// 搜索好友，发送好友请求
- (void)setUpSearchView{
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.tableView.cy_width, 40)];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(10,0, self.tableView.cy_width-60, 40)];
    self.searchTF = searchTF;
//    searchTF.backgroundColor = [UIColor grayColor];
    searchTF.placeholder = @"搜索免费啦号/群组/商家号";
    [searchView addSubview:searchTF];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.tableView.cy_width-60, 0, 50, 40)];
    searchBtn.backgroundColor = [UIColor grayColor];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(onSearchClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    
    self.tableView.tableHeaderView = searchView;
}

- (void)onSearchClick{
    if (!self.searchTF.text.length) {
        NSLog(@"请输入好友账号");
        return;
    }
//    发送好友请求
    id<IChatManager> cm = [EaseMob sharedInstance].chatManager;
    NSString *msg = [NSString stringWithFormat:@"我是%@",[cm loginInfo][@"username"]];
    if([cm addBuddy:self.searchTF.text message:msg error:nil]){
        
        [EMAlertView showAlertWithTitle:@"提示" message:@"好友添加申请已经发送" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
            
        } cancelButtonTitle:@"好的" otherButtonTitles:nil];
    }

}

#pragma mark 加载历史会话记录
- (void)loadConversations {
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    if (conversations.count == 0) {
        conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    }
    self.conversations = conversations;
    
    NSLog(@"历史会话记录--loadConversations %@",conversations);
}

#pragma mark - 表格数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    EMConversation *converstaion = self.conversations[indexPath.row];
    
    cell.userNameLabel.text = [NSString stringWithFormat:@"%@ 未读消息数%zd",converstaion.chatter,converstaion.unreadMessagesCount];
    cell.portraitImageView.image = [UIImage imageNamed:@"official"];
    // 最后一条信息
    EMMessage *lastMsg = [converstaion latestMessage];
    
    id body = lastMsg.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {//文本消息
        EMTextMessageBody *textBody = body;
        cell.msgLabel.text = textBody.text;
    }else if([body isKindOfClass:[EMVoiceMessageBody class]]){//音频
        EMVoiceMessageBody *voiceBody = body;
        cell.detailTextLabel.text = voiceBody.displayName;
    }else{
        cell.detailTextLabel.text = @"未处理的消息类型";
    }
    return cell;
}

#pragma mark - EMChatManager代理方法
#pragma mark 有新的会话列表
- (void)didUpdateConversationList:(NSArray *)conversationList{
    self.conversations = conversationList;
    [self refreshUI];
}

#pragma mark 未读消息数改变
-(void)didUnreadMessagesCountChanged{
    [self refreshUI];
}

#pragma mark 完成自动登录
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    NSLog(@"完成自动登录\n %@ %@",loginInfo,error);
}

#pragma mark 将自动连接
-(void)willAutoReconnect{
    NSLog(@"将自动连接");
}

#pragma mark 完成自动连接
-(void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSLog(@"完成自动连接 %@",error);
}

#pragma mark 网络连接状态
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
    if (connectionState == eEMConnectionDisconnected) {
        NSLog(@"未连接...");
    }else{
        NSLog(@"网络已连接...");
    }
}

#pragma mark - 好友添加的代理方法
#pragma mark 好友请求被同意
-(void)didAcceptedByBuddy:(NSString *)username{
    
//    // 提醒用户，好友请求被同意
//    NSString *message = [NSString stringWithFormat:@"%@ 同意了你的好友请求",username];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加消息" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//    [alert show];
}

#pragma mark 好友请求被拒绝
-(void)didRejectedByBuddy:(NSString *)username{
    // 提醒用户，好友请求被同意
//    NSString *message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求",username];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加消息" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//    [alert show];
    
}


#pragma mark 接收好友的添加请求
-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    FL_Log(@"haohaohaoahoahoahoahohaohaohaohaohaohaohaohaohoahoahoyou");
    // 赋值
    self.buddyUsername = username;
    
    // 对话框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加请求" message:message delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    [alert show];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {//拒绝好友请求
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:self.buddyUsername reason:@"我不认识你" error:nil];
    }else{//同意好友请求
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:self.buddyUsername error:nil];
        
    }
}

- (void)dealloc
{
    //移除聊天管理器的代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


@end
