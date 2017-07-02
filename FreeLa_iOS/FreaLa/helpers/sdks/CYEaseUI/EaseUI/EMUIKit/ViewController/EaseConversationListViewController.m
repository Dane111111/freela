//
//  EaseConversationListViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/25.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EaseConversationListViewController.h"

#import "EaseMob.h"
#import "EaseSDKHelper.h"
#import "EaseEmotionEscape.h"
#import "EaseConversationCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "NSDate+Category.h"

#import "CYHTTPRequestManager.h"
#import "CYUserModel.h"


@interface EaseConversationListViewController () <IChatManagerDelegate>

@property(nonatomic,strong)NSMutableArray *myUserModelArr; // 我添加的模型数组

@end

@implementation EaseConversationListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self tableViewDidTriggerHeaderRefresh];
    [self registerNotifications];
    [self.tableView reloadData]; // 当删除好友的时候 会话记录也会删除
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.dataArray count] <= indexPath.row) {
        return cell;
    }
    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
//    if (self.myUserModelArr.count != 0) {
//        CYUserModel *userModel = [self.myUserModelArr objectAtIndex:indexPath.row];
//        model.title = userModel.nickname;
//        model.avatarURLPath = userModel.avatar;
//    }
    
    cell.model = model;
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
        cell.detailLabel.text = [_dataSource conversationListViewController:self latestMessageTitleForConversationModel:model];
    } else {
        cell.detailLabel.text = [self _latestMessageTitleForConversationModel:model];
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [_dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
    NSLog(@"会话个数%zd",[self.dataArray count]);
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EaseConversationCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(conversationListViewController:didSelectConversationModel:)]) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [_delegate conversationListViewController:self didSelectConversationModel:model];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.conversation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSLog(@"会话1个数 %zd",[conversations count]);
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    [self loadNickName_AvaterURLWithConversations:sorted]; // 从自己服务器请求数据
    
    }



#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self tableViewDidTriggerHeaderRefresh];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - private
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                latestMessageTitle = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                latestMessageTitle = @"[语音]";
            } break;
            case eMessageBodyType_Location: {
                latestMessageTitle = @"[位置]";
            } break;
            case eMessageBodyType_Video: {
                latestMessageTitle = @"[视频]";
            } break;
            case eMessageBodyType_File: {
                latestMessageTitle = @"[文件]";
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

- (NSString *)_latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}

#pragma mark - 懒加载
- (NSMutableArray *)myUserModelArr{
    if (_myUserModelArr == nil) {
        _myUserModelArr = [NSMutableArray array];
    }
    return _myUserModelArr;
}

#pragma mark - 自己添加的方法，向服务器请求数据好友列表信息
- (void)loadNickName_AvaterURLWithConversations:(NSArray*)sorted{
    
    //    拼接请求参数 ',person_1,person_2,'
    NSString *friendIDList = @",";

    for (EMConversation *conversation in sorted){
        if (conversation.isGroup) {
            // 是群聊天会话，什么也不做
        }else{
            friendIDList = [friendIDList stringByAppendingFormat:@"%@,",conversation.chatter];
        }
    }
    NSLog(@"请求参数%@",friendIDList);
    NSDictionary *params = @{
                             @"idsArray":friendIDList
                             };
    NSString *url = [NSString stringWithFormat:@"%@/app/chats!findListByIds.action",FLBaseUrl];//@"http://59.108.126.36:8888/app/chats!findListByIds.action";

    //    发起请求
    CYHTTPRequestManager *mgr = [CYHTTPRequestManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    
    
//    [FLNetTool xjfindListByIdsByParm:params success:^(NSDictionary *data) {
//        FL_Log(@"this is the list of my friends=%@",data);
//        [self.tableView.mj_header endRefreshing];
//        if (data[FL_NET_KEY_NEW]) {
//        }
//    } failure:^(NSError *error) {
//        
//    }];
    
    
    
    

    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation * operation,NSDictionary* responseObject) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",@"成功！什么啊！！");
        self.myUserModelArr = [CYUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSLog(@"%@",self.myUserModelArr);
        NSLog(@"请this is the list of my friends=据 %zd",self.myUserModelArr.count);
//---------------------------------------------
        [self.dataArray removeAllObjects];
        CYUserProfileTool *profileTool = [CYUserProfileTool share];
        
        //    在这里面处理 ！！！
        int j = 0;
        for (EMConversation *converstion in sorted) {
            EaseConversationModel *model = nil;
            if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
                model = [_dataSource conversationListViewController:self modelForConversation:converstion];
//              -------------------cy
                if (!converstion.isGroup) {
                    if (self.myUserModelArr.count > j) {
                        CYUserModel *userModel = self.myUserModelArr[j];
                        model.title = userModel.nickname ?userModel.nickname :userModel.shortName?userModel.shortName:userModel.username;
                        model.avatarURLPath = userModel.avatar;
                        
                        [profileTool addModel:userModel withUserID:converstion.chatter]; // 缓存
                    }
                    j++;
                }else{
    //                model.title = converstion.
//                    model.avatarImage = [UIImage imageNamed:@"group"];
                }
//              -------------------cy
            }
            else{
                model = [[EaseConversationModel alloc] initWithConversation:converstion];
            }
            
            if (model) {
                [self.dataArray addObject:model];
            }
        }
        
//---------------------------------------------------------------
//        int j=0;
//        for (EMConversation *converstion in sorted) {
//            EaseConversationModel *model = nil;
//            model = [[EaseConversationModel alloc] initWithConversation:converstion];
//            if (!converstion.isGroup) {
//                CYUserModel *userModel = self.myUserModelArr[j];
//                model.title = userModel.nickname;
//                model.avatarURLPath = userModel.avatar;
//                j++;
//            }else{
////                model.title = converstion.
//                model.avatarImage = [UIImage imageNamed:@"group"];
//            }
//            if (model) {
//                [self.dataArray addObject:model];
//            }
//        }
//---------------------------------------------------------------
        // 刷新界面 -- 设置TabBar/应用图标  的红点提示
        NSInteger totalCount = 0;
        for (EMConversation *conversation in sorted) {
            totalCount += [conversation unreadMessagesCount];
        }
        
        if (totalCount > 0) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",totalCount];
        }else{
            self.navigationController.tabBarItem.badgeValue = nil;
        }
        
        
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
//---------------------------------------------
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"%@",error);
        NSLog(@"%@",@"啊哦in easy con失败了");
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
    }];
}


@end
