//
//  FLChangeMyAccountTableViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/16.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLChangeMyAccountTableViewController.h"
#import "FLHeader.h"

#define User_Key_shortName   @"username"
#define User_Key_userId      @"userId"


//test
extern  NSInteger  FLFLSelectedAccountNumber;

@interface FLChangeMyAccountTableViewController () {
    //关于用户的用户名密码
    NSMutableArray  * mutableArray;
    //关于用户的权限
    
    //选中
    NSInteger _isSelected;  //是否选中
    
    //选中的哪一个
}
@property (nonatomic , retain)UIView* tableFooterView; //安全退出按钮

@property (nonatomic , assign)NSInteger selectedIndex;

/**列表模型*/
//@property (nonatomic , strong) FLMyBusAccountListModel* flMyBusAccountListModel;
/**列表数组*/
@property (nonatomic , strong) NSArray* flMyBusAccountListModelArray;




@end

@implementation FLChangeMyAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    _isSelected = 0;
    
    
    [self setUpMyAccountUI];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"FLMyCustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"FLMyCustomTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FLApplyBusinessTableViewCell" bundle:nil] forCellReuseIdentifier:@"FLApplyBusinessTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FLChangeAccountPersonalTableViewCell" bundle:nil] forCellReuseIdentifier:@"FLChangeAccountPersonalTableViewCell"];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"我的账户";
    
    //    if (FLFLIsPersonalAccountType) {
    //        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    //    }
    //    else
    //    {
    //        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:(FLFLSelectedAccountNumber - 1) inSection:1];
    //        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    //    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#warning delegate
    [self getUserBusinessInfoList]; //test
    [self.navigationController.navigationBar setHidden:NO];
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    //    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    self.title = @"我的账户";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    if (![FLTool isNetworkEnabled]) {
        [[FLAppDelegate share ] showHUDWithTitile:@"网络连接错误" view:self.view delay:1 offsetY:0];
    }
    
    //获取用户的个人账户信息
    [self getUserInfoPersonal];
    [self getUserBusinessInfoList];
    
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    } else {
        return self.flMyBusAccountListModelArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            FLChangeAccountPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLChangeAccountPersonalTableViewCell" forIndexPath:indexPath];
            //            cell.myNameLabel.text = [self.userInfoDic objectForKey:@"nickname"];
            //            if ([[self.userInfoDic objectForKey:@"email"] isEqual:[NSNull null]] ) {
            //                //这里有null
            //            }else
            //            {
            //            cell.myAccountNumberLabel.text = [self.userInfoDic objectForKey:@"email"];
            //            }
            //            [cell.myPortraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FLBaseUrl,[self.userInfoDic objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"logo_freela"]];
            //            cell.selected = YES;
            cell.fluserInfoModel = self.userInfoModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if(indexPath.row == 1)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text =  @"更多操作请登录www.freela.com.cn";
            cell.textLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            return cell;
        }
        return  nil;
        
    }
    else if (indexPath.section == 1)
    {
        FLMyCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLMyCustomTableViewCell" forIndexPath:indexPath];
        FLMyBusAccountListModel* flmodel = self.flMyBusAccountListModelArray[indexPath.row];
        //        if (cell.flMyBusAccountListModel.state == 1) {
        //            flmodel.username = @"认证中";
        //            cell.flMyBusAccountListModel = flmodel;
        //        } else if (cell.flMyBusAccountListModel.state == 0) {
        //             flmodel.username = @"没有认证信息";
        //            cell.flMyBusAccountListModel = flmodel;
        //        }
        cell.flMyBusAccountListModel = flmodel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        return nil;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        return 40;
    }
    return 80;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"我的个人账户";
    }
    else
    {
        return @"我的商家账户";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0 ;
}

#pragma mark ---------setupui
- (void)setUpMyAccountUI
{
    //    self.title = @"我的账户";
    self.tableView.showsVerticalScrollIndicator = NO;
    /*
     UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     //2.设置文字和文字颜色
     [button setTitle:@"安全退出" forState:UIControlStateNormal];
     [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     
     //3.设置圆角幅度
     button.layer.cornerRadius = 22.0;
     //    button.layer.borderWidth = 1.0;
     
     //4.设置frame
     button.frame = CGRectMake(0, 100, 20, 44);
     
     //5.设置背景色
     button.backgroundColor = [UIColor redColor];
     
     //6.设置触发事件
     [button addTarget:self action:@selector(quitMyAccount) forControlEvents:UIControlEventTouchUpInside];
     //7.添加到tableView tableFooterView中
     self.tableView.tableFooterView = button;
     */
    
    
    
    
}

#pragma mark ------Actions
- (void)quitMyAccount {
    NSLog(@"quit my Account sss");
    [XJFinalTool xjRemoveUserInfoInUserdefaultskey:FL_USERDEFAULTS_USERID_KEY];
    [[FLAppDelegate share] showHUDWithTitile:@"退出成功" view:self.view delay:1 offsetY:0];
    FLLogIn_RegisterViewController* logInVC  = [[FLLogIn_RegisterViewController alloc] init ];//WithNibName:@"FLLogIn_RegisterViewController" bundle:nil];
    [self presentViewController:logInVC animated:YES completion:nil];
}

#pragma mark ---- getInfo
- (void)getUserInfoPersonal {
    //seeinfo
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"accountType":@"per"};
    FL_Log(@"see info :sesssionId   parm = %@",parm);
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my change account test info = %@",data);
        if (data) {
            self.userInfoModel =  [FLMineTools returnUserInfoModelWithModel:data];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)getUserBusinessInfoList {
    [FLFinalNetTool flNewGetMyBusApplyListsuccess:^(NSDictionary *data) {
        FL_Log(@"this is my bus list =%@",data);
        if ([data[FL_NET_KEY_NEW]boolValue]) {
            NSArray* array = data[FL_NET_DATA_KEY];
            self.flMyBusAccountListModelArray = [FLMyBusAccountListModel mj_objectArrayWithKeyValuesArray:array];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        FL_Log(@"my bus list error =%@",error);
    }];
}

#pragma mark - Table view delegate
//切换账号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( self.flMyBusAccountListModelArray.count ==0) {
        return;
    }
    FLMyBusAccountListModel* flmodel = self.flMyBusAccountListModelArray[indexPath.row];
    [[FLAppDelegate share] showdimBackHUDWithTitle:nil view:self.view];
    if (indexPath.section == 1) {
        //标记选择的角色
        FLFLSelectedAccountNumber = indexPath.row + 1;
        FL_Log(@"点击了第几个%ld",(long)indexPath.row);
        FL_Log(@"拿到 的用户ID == %@", flmodel.userId);
        FL_Log(@"dic=  %@ ,password= %@",flmodel,flmodel.password);
        NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                               @"account":flmodel.email,
                               @"password":flmodel.password,
                               @"accountType":FLFLXJUserTypeCompStrKey
                               };
        //切换账号之前需判断是否是已通过审核的商家?
        if (!(flmodel.auditStatus  == 2) )  {
            [[FLAppDelegate share] hideHUD];
            FLMyBusAccountStateViewController* flSteteVC = [[FLMyBusAccountStateViewController alloc ]initWithNibName:@"FLMyBusAccountStateViewController" bundle:nil];
            flSteteVC.flState = flmodel.auditStatus;//1:审批中2：审批通过3：审批拒绝  0 未提交审核
            flSteteVC.flUserId = flmodel.userId;
            [self.navigationController pushViewController:flSteteVC animated:YES];
            if (flmodel.auditStatus == 3) {
                //被拒绝
                //                FLRefuseViewController* refuseVC = [[FLRefuseViewController alloc] initWithNibName:@"FLRefuseViewController" bundle:nil];
                //                [self.navigationController pushViewController:refuseVC animated:YES];
            }
            
        } else if(flmodel.auditStatus == 2)  {
            //切换账号，上传给服务器
            [FLNetTool exchangeAccountWithParm:parm success:^(NSDictionary *data) {
                FL_Log(@"exchange y account is success = %@  , msg=%@",data,[data objectForKey:@"msg"]);
                if ([[data objectForKey:FL_NET_KEY]boolValue]) {
                    [[FLAppDelegate share] hideHUD];
                    //标记选择的角色
                    FLFLSelectedAccountNumber = indexPath.row + 1;
                    //切换ispersonal 类型
                    FLFLIsPersonalAccountType = 0;
                    //userdefaults 写入需要时间r
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPersonal"];  //或许可以不需要
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"切换至%@成功",flmodel.email] view:self.view delay:1 offsetY:0];
                        FL_Log(@" my business userid in change vc = %@",flmodel.userId);
                        //商家头像
                        FLFLXJBusinessUserHeaderImageURLStr = [NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:flmodel.avatar isSite:NO]];
                        //保存sessionId
                        FLFLBusSesssionID = [data objectForKey:@"sessionid"];
                        //保存userID
                        FLFLXJBusinessUserID = flmodel.userId;
                        //保存nickname
                        FLFLXJBusinessNickNameStr = flmodel.shortName;
                        [[NSNotificationCenter defaultCenter] postNotificationName:XJXJISCHANGEDUSERLOG object:nil];
                        FL_Log(@"my bus session id =%@ ,,userid= %@",FLFLBusSesssionID,FLFLXJBusinessUserID);
                        //推回个人信息页
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                        [FLTool xjSetJpushAlias]; //设置极光别名
                        [FLTool xjSingUpHuanxin];//登出环信
                    });
                } else {
                    [[FLAppDelegate share] hideHUD];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",data[@"msg"]?data[@"msg"]:@"什么鬼"] view:self.view delay:1 offsetY:0];
                    });
                }
                
            } failure:^(NSError *error) {
                NSLog(@"exchange my account error = %@ , %@",error.description,error.debugDescription);
                [[FLAppDelegate share] hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
                });
            }];
        }
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        FL_Log(@"点了个人用户");
        NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                               @"account":self.userInfoModel.flloginNumber,
                               @"password":self.userInfoModel.flpassWord,
                               @"accountType":FLFLXJUserTypePersonStrKey};
        
        FL_Log(@"my token = %@ , password = %@",FL_ALL_SESSIONID ,self.userInfoModel.flpassWord);
        //切换账号，上传给服务器
        [FLNetTool exchangeAccountWithParm:parm success:^(NSDictionary *data) {
            FL_Log(@"exchange PER account is success = %@  , msg=%@",data,[data objectForKey:@"msg"]);
            if ([[data objectForKey:FL_NET_KEY]boolValue]) {
                [[FLAppDelegate share] hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"切换至%@成功",self.userInfoModel.flloginNumber] view:self.view delay:1 offsetY:0];
                });
                //切换全局属性
                FLFLSelectedAccountNumber = 0;   //选中的账号序号
                FLFLIsPersonalAccountType = 1;   //选中的账号属性1 为个人
                FLFLXJIsChangeNickNameType = 1;   //修改昵称还是联系人，1为昵称
                [FLTool xjSetJpushAlias]; //设置极光别名
                [FLTool xjSingUpHuanxin];//登出环信
                [[NSNotificationCenter defaultCenter] postNotificationName:XJXJISCHANGEDUSERLOG object:nil];
                //推回个人信息页
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];//
            }  else  {
                [[FLAppDelegate share] hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]] view:self.view delay:1 offsetY:0];
                });
            }
        } failure:^(NSError *error) {
            NSLog(@"exchange my account error = %@ , %@",error.description,error.debugDescription);
        }];
    }
}


/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (indexPath.section == 1)
 {
 FLMyBusAccountListModel* model = self.flMyBusAccountListModelArray[indexPath.row];
 FLMyBusAccountStateViewController* flSteteVC = [[FLMyBusAccountStateViewController alloc ]initWithNibName:@"FLMyBusAccountStateViewController" bundle:nil];
 flSteteVC.flState = model.state;//1:审批中2：审批通过3：审批拒绝4：认证修改中
 flSteteVC.flUserId = model.userId;
 
 [self.navigationController pushViewController:flSteteVC animated:YES];
 }
 }
 
 */




@end
