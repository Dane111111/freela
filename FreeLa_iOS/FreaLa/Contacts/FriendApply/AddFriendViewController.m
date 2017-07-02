/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AddFriendViewController.h"
#import "XJSearchByNickNamePersonModel.h"
#import "ApplyViewController.h"
#import "AddFriendCell.h"
#import "InvitationManager.h"
#import "CYHTTPRequestManager.h"
#import "CYPhone2UserId.h"

@interface AddFriendViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property(nonatomic,strong) NSMutableArray *xjmodels; // 模型数组


/**个人数组*/
@property (nonatomic , strong) NSMutableArray* xjPersonResultArr;
/**商家号数组*/
@property (nonatomic , strong) NSMutableArray* xjCompResultArr;

/**这个是选中的模型*/
@property (nonatomic , strong) XJSearchByNickNamePersonModel* xjSelectedModel;
@end

@implementation AddFriendViewController


#pragma mark - 懒加载

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.title = @"添加朋友";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    self.tableView.tableFooterView = footerView;
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:searchButton]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self.view addSubview:self.textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickToRequestSearch:) name:UITextFieldTextDidChangeNotification object:self.textField];
    
    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
}
- (XJSearchByNickNamePersonModel *)xjSelectedModel{
    if (!_xjSelectedModel) {
        _xjSelectedModel = [[XJSearchByNickNamePersonModel alloc] init];
    }
    return _xjSelectedModel;
}

- (NSMutableArray *)xjmodels {
    if (!_xjmodels) {
        _xjmodels = [NSMutableArray array];
    }
    return _xjmodels;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray *)xjPersonResultArr {
    if (!_xjPersonResultArr) {
        _xjPersonResultArr = [NSMutableArray array];
    }
    return _xjPersonResultArr;
}
- (NSMutableArray *)xjCompResultArr {
    if (!_xjCompResultArr) {
        _xjCompResultArr = [NSMutableArray array];
    }
    return _xjCompResultArr;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - getter

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = 3;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"输入手机号或昵称进行查找";
//        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    
    return _textField;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
        _headerView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
        
        [_headerView addSubview:_textField];
    }
    
    return _headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.xjPersonResultArr.count!=0 && self.xjCompResultArr.count !=0) {return 2;}
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.xjPersonResultArr.count == 0) {
            return self.xjCompResultArr.count ;
        } else {
            return self.xjPersonResultArr.count;
        }
    } else if(section == 1) {
        return self.xjCompResultArr.count;
    }
    return self.xjmodels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddFriendCell";
    AddFriendCell *cell = (AddFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        if (self.xjPersonResultArr.count == 0) {
            if (self.xjCompResultArr.count > indexPath.row) {
                XJSearchByNickNamePersonModel* model = self.xjCompResultArr[indexPath.row];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:model.avatar isSite:NO]]] placeholderImage:[UIImage imageNamed:@"defaultavater"]];
                cell.textLabel.text = model.nickname;
            }
        } else {
            if (self.xjPersonResultArr.count > indexPath.row){
                XJSearchByNickNamePersonModel* model = self.xjPersonResultArr[indexPath.row];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:model.avatar isSite:NO]]] placeholderImage:[UIImage imageNamed:@"defaultavater"]];
                cell.textLabel.text = model.nickname;
            }
        }
    } else if (indexPath.section ==1) {
        if (self.xjCompResultArr.count > indexPath.row) {
            XJSearchByNickNamePersonModel* model = self.xjCompResultArr[indexPath.row];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:model.avatar isSite:NO]]] placeholderImage:[UIImage imageNamed:@"defaultavater"]];
            cell.textLabel.text = model.nickname;
        }
    }

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.xjPersonResultArr.count == 0) {
            return self.xjCompResultArr.count == 0 ?  @"": @"商家号";
        } else {
             return @"个人号";
        }
        
    } else if(section == 1) {
        return @"商家号";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    NSString *buddyName = @"";
    
    if (indexPath.section == 0) {
        if (self.xjPersonResultArr.count == 0) {
            if (self.xjCompResultArr.count > indexPath.row) {
                XJSearchByNickNamePersonModel* model = self.xjCompResultArr[indexPath.row];
                buddyName = [NSString stringWithFormat:@"comp_%ld",model.userId];
                self.xjSelectedModel = model;
            }
        } else {
            if (self.xjPersonResultArr.count > indexPath.row){
                XJSearchByNickNamePersonModel* model = self.xjPersonResultArr[indexPath.row];
                buddyName = [NSString stringWithFormat:@"person_%ld",model.userId];
                self.xjSelectedModel = model;
            }
        }
        
    } else if (indexPath.section ==1) {
        if (self.xjCompResultArr.count > indexPath.row) {
            XJSearchByNickNamePersonModel* model = self.xjCompResultArr[indexPath.row];
            buddyName = [NSString stringWithFormat:@"comp_%ld",model.userId];
            self.xjSelectedModel = model;
        }
    }
    
    if ([self didBuddyExist:buddyName]) {
        CYUserModel* xj = [XJUserProfileManager xjSearchUserModelInLocationBySearchId:buddyName];
        NSString *message = [NSString stringWithFormat:@"'%@'已经成为您的朋友!", xj.nickname?xj.nickname:xj.username?xj.username:xj.shortName];
        
        [EMAlertView showAlertWithTitle:message
                                message:nil
                        completionBlock:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil];
        
    }  else if([self hasSendBuddyRequest:buddyName]) {
        NSString *message = [NSString stringWithFormat:@"您已经发送好友请求给'%@'!", buddyName];
        [EMAlertView showAlertWithTitle:message
                                message:nil
                        completionBlock:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil];
        
    }else{
        [self showMessageAlertView];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action

- (void)searchAction
{
    [_textField resignFirstResponder];
    if(_textField.text.length > 0)
    {
 
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if ([_textField.text isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定" message:@"不能添加自己为好友" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        
        //判断是否已发来申请
        NSArray *applyArray = [[ApplyViewController shareController] dataSource];
        if (applyArray && [applyArray count] > 0) {
            for (ApplyEntity *entity in applyArray) {
                ApplyStyle style = [entity.style intValue];
                BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
                if (!isGroup && [entity.applicantUsername isEqualToString:_textField.text]) {
                    
                    
                    NSDictionary *params = @{
                                             @"idsArray":_textField.text
                                             };
                    [FLNetTool xjfindListByIdsByParm:params success:^(NSDictionary *data) {
                        FL_Log(@"this is tmy list of frinegs =%@",data);
                        if ([data[FL_NET_KEY_NEW] boolValue]) {
                            CYUserModel * xjModel = [CYUserModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY][0]];
                            NSString *str = [NSString stringWithFormat:@"%@向你发送好友请求", xjModel.nickname];
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                            return;
                        }
                    } failure:^(NSError *error) {
                           return;
                    }];
                }
            }
        }
        
        [self.dataSource removeAllObjects];
        [self.xjmodels removeAllObjects];
//        [self.dataSource addObject:_textField.text];
//        [self.tableView reloadData];
    }
    [self xjSearchWithStr:_textField.text ];
}

- (BOOL)hasSendBuddyRequest:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState == eEMBuddyFollowState_NotFollowed &&
            buddy.isPendingApproval) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)didBuddyExist:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState != eEMBuddyFollowState_NotFollowed) {
            return YES;
        }
    }
    return NO;
}

- (void)showMessageAlertView {
     __weak typeof(self) weakSelf = self;
  
        FL_Log(@"The  alert's send action occured.");
        UIAlertController* flAlertSecondVC = [UIAlertController alertControllerWithTitle:@"说点什么吧" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* flCancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            FL_Log(@"cancle in second.");
        }];
        UIAlertAction* flSureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            FL_Log(@"sure in second.");
            FL_Log(@"this is my email address to send =%@", flAlertSecondVC.textFields[0].text);
            [self xjAddFriendWithString:flAlertSecondVC.textFields[0].text];
        }];
        [flAlertSecondVC addAction:flCancleAction];
        [flAlertSecondVC addAction:flSureAction];
        
        [flAlertSecondVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        }];
        [weakSelf presentViewController:flAlertSecondVC animated:YES completion:nil];
}
#pragma  mark 添加好友
- (void)xjAddFriendWithString:(NSString*)xjMyStr {

    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *username = [loginInfo objectForKey:kSDKUsername];
    [FLFinalNetTool xjGetFriendsFromeSerWithStr:username success:^(NSDictionary *data) {
        FL_Log(@"fl xjfinal netttool with friens result =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSString *messageStr = @"";
            CYUserModel * xjModel = [CYUserModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY][0]];
            NSString* xjName = xjModel.nickname?xjModel.nickname:xjModel.shortName?xjModel.shortName:xjModel.username?xjModel.username:@"";
            if (xjMyStr.length > 0) {
                messageStr = [NSString stringWithFormat:@"%@：%@", xjName,xjMyStr];
            } else{
                messageStr = [NSString stringWithFormat:@"我是%@,想要添加你为好友", xjName];
            }
            [self sendFriendApplyAtIndexPath:self.selectedIndexPath
                                     message:messageStr];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        if (messageTextField.text.length > 0) {
            messageStr = [NSString stringWithFormat:@"%@：%@", username, messageTextField.text];
        }
        else{
            messageStr = [NSString stringWithFormat:@"%@ 添加你为好友", username];
        }
        [self sendFriendApplyAtIndexPath:self.selectedIndexPath
                                 message:messageStr];
    }
}

- (void)sendFriendApplyAtIndexPath:(NSIndexPath *)indexPath
                           message:(NSString *)message {
      NSString* userId = [NSString stringWithFormat:@"%@_%ld",self.xjSelectedModel.xjUserType,self.xjSelectedModel.userId];
    if (self.xjSelectedModel.userId && self.xjSelectedModel.xjUserType){
        [self showHudInView:self.view hint:@"发送申请中..."];
//        [self getUserIdWithPhoneNum:phoneNum WithMessage:message];
        EMError *error;
        [[EaseMob sharedInstance].chatManager addBuddy:userId message:message error:&error];
        [self hideHud];
        if (error) {
//            [self showHint:@"发送申请失败，请重试"];
            [FLTool showWith:@"发送申请失败，请重试"];
        }
        else{
//            [self showHint:@"发送申请成功"];
            [FLTool showWith:@"发送申请成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }

    }
}

#pragma  mark 没什么用的东西
- (void)getUserIdWithPhoneNum:(NSString*)phoneNum WithMessage:(NSString*)message{
    NSDictionary *params = @{
                             @"phone":phoneNum
                             };
    NSString *url = @"http://59.108.126.36:8888/app/chats!getPersonByPhone().action";
    CYHTTPRequestManager *mgr = [CYHTTPRequestManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    //Request failed: unacceptable content-type: text/plain"
    
    [mgr  POST:url parameters:params success:^(AFHTTPRequestOperation * operation, NSDictionary *responseObject) {
        
        CYPhone2UserId *model= [CYPhone2UserId mj_objectWithKeyValues:responseObject[@"data"]];
        NSNumber *ID = model.userId;
        int temp = [ID intValue];
        NSString *userId = [NSString stringWithFormat:@"person_%d",temp];
        
        EMError *error;
        [[EaseMob sharedInstance].chatManager addBuddy:userId message:message error:&error];
        [self hideHud];
        if (error) {
            [self showHint:@"发送申请222失败，请重试"];
        }
        else{
            [self showHint:@"发送申请成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"%@",error);
    }];
}

//text did change
- (void)clickToRequestSearch:(NSNotification*)xjTextField {
    [self.xjPersonResultArr removeAllObjects];
    [self.xjCompResultArr removeAllObjects];
   
    
    UITextField* xj = xjTextField.object;
    FL_Log(@"this is the tetttstst=%@",xj.text );
    if (xj.text.length >=2) {
         [self xjSearchWithStr:xj.text];
    }
}

#pragma  mark 搜索。。。。。。
- (void)xjSearchWithStr:(NSString*)xjStr{
     [self.xjPersonResultArr removeAllObjects];
    if ([xjStr integerValue] && xjStr.length ==11) {
        [self xjSearchWithPhone:xjStr];
    } else {
        [self xjSearchByNickName:xjStr];
    }
}

- (void)xjSearchWithPhone:(NSString*)xjPhone {
    NSDictionary* parm =@{@"phone":xjPhone};
    [FLNetTool xjgetPersonByPhone:parm success:^(NSDictionary *data) {
        FL_Log(@"xjthis is the result by phonenumber=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSDictionary* dd = data[FL_NET_DATA_KEY];
            if (dd.allKeys.count !=0) {
                XJSearchByNickNamePersonModel* model = [XJSearchByNickNamePersonModel mj_objectWithKeyValues:dd];
                NSInteger xjxj = [XJ_USERID_WITHTYPE integerValue];
                if ( model.userId   == [XJ_USERID_WITHTYPE integerValue]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定" message:@"不能添加自己为好友" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                } else {
                    model.xjUserType = FLFLXJUserTypePersonStrKey;
                    self.xjPersonResultArr = @[model].mutableCopy;
                    [self.tableView reloadData];
                }
            } else {
                [FLTool showWith:@"查无此人"];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [FLTool showWith:@"搜索失败，请稍后再试"];
    }];

    
}
- (void)xjSearchByNickName:(NSString*)xjNickName {
    NSDictionary* parm = @{@"nikeName":xjNickName };
    [FLNetTool xjgetPersonInfoByNickName:parm success:^(NSDictionary *data) {
        FL_Log(@"sdadsadasfasdaewqraw=%@",data);
        NSArray* xjArrPerson = data[FLFLXJUserTypePersonStrKey];
        NSArray* xjArrComp   = data[FLFLXJUserTypeCompStrKey];
        NSArray* xjPersonModel = [XJSearchByNickNamePersonModel mj_objectArrayWithKeyValuesArray:xjArrPerson];
        NSArray* xjCompModel   = [XJSearchByNickNamePersonModel mj_objectArrayWithKeyValuesArray:xjArrComp];
        FL_Log(@"lllllsaddaddadadaddlsllslslsl=%@ = =%@",xjArrPerson,xjArrPerson);
        [self xjReturnModelWithPerArr:xjPersonModel compArr:xjCompModel];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjReturnModelWithPerArr:(NSArray*)xjPerArr compArr:(NSArray*)xjCompArr{
    [self.xjPersonResultArr removeAllObjects];
    [self.xjCompResultArr removeAllObjects];
    for (XJSearchByNickNamePersonModel* xjPerModel in xjPerArr) {
        xjPerModel.xjUserType =   FLFLXJUserTypePersonStrKey ;
        [self.xjPersonResultArr addObject:xjPerModel];
    }
    for (XJSearchByNickNamePersonModel* xjCopmModel in xjCompArr) {
        xjCopmModel .xjUserType =  FLFLXJUserTypeCompStrKey;
        [self.xjCompResultArr addObject:xjCopmModel];
    }
 
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

















