//
//  FLMySettingsTableViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/19.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLMySettingsTableViewController.h"
#import "FLMesageSettingViewController.h"
#import "FLIdeaBackViewController.h"
#import "FLAboutUsViewController.h"
#import "FLCheckVersionViewController.h"
#import "SDImageCache.h"
#import "FLTool.h"

@interface FLMySettingsTableViewController ()<UIAlertViewDelegate>
{
    NSArray* _flsection0Arr;
    NSArray* _flsection1Arr;
    NSArray* _flsection2Arr;
    
    NSString*  _xjWebCacheSize;
}
//@property (nonatomic , strong)NSArray* array;
@property (nonatomic , strong)UIButton* quitBtn;
@end

@implementation FLMySettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initQuitBtn];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.array = @[@"密码修改",@"消息设置",@"清除缓存",@"意见反馈",@"关于我们",@"查看版本"];
    _flsection0Arr = @[@"密码修改"];
    _flsection1Arr = @[@"消息设置",@"清除缓存"];
    _flsection2Arr = @[@"意见反馈",@"关于我们",@"查看版本"];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIColor* color = [UIColor whiteColor];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    
    [self.navigationController.navigationBar lt_reset];
    UIColor * titleColor = [UIColor blackColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
     self.title = @"更多设置";
    self.navigationController.navigationItem.leftBarButtonItem.tintColor= [UIColor blackColor];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithTitle:@"我的设置" style:UIBarButtonItemStyleBordered target:self action:@selector(goBackToMySettings)];
    self.navigationItem.backBarButtonItem = leftItem;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.navigationController.navigationBar setHidden:YES];
}

- (void)goBackToMySettings
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* myIdentifier = @"mySettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier ];//forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myIdentifier];
    }
    
    if (indexPath.section == 0 ) {
        cell.textLabel.text = _flsection0Arr[indexPath.row];
    } else if ( indexPath.section == 1) {
         cell.textLabel.text = _flsection1Arr[indexPath.row];
        if (indexPath.row == 1) {
            NSInteger xjSize = [[SDImageCache sharedImageCache] getSize];
            xjSize = xjSize / (1024 * 1024);
            NSString * str = [NSString stringWithFormat:@"%ld",xjSize];  //getTheCorrectNum ;
            str = [FLTool getTheCorrectNum:str] ;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ M",[str isEqualToString:@""] ? @"0":str];
        }
    } else {
         cell.textLabel.text = _flsection2Arr[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (FLFLIsPersonalAccountType)
//    {
    if (indexPath.section == 0)
    {
        if (self.flUserInfoModel.flloginNumber) {
            FLMesageSettingViewController* messageVC = [[FLMesageSettingViewController alloc]initWithNibName:@"FLMesageSettingViewController" bundle:nil];
            [self.navigationController pushViewController:messageVC animated:YES];
        } else {
            [[FLAppDelegate share] showHUDWithTitile:@"请先绑定手机号" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            FLMessageSettingSViewController* messageSet = [[FLMessageSettingSViewController alloc] init];
            [self.navigationController pushViewController:messageSet animated:YES];
        }
        else if (indexPath.row == 1)
        {
            NSString* flSureBtnTitle      = NSLocalizedString(@"确定", nil);
            UIAlertController* flAlertViewController = [UIAlertController alertControllerWithTitle:@"确定清除?" message:@"操作不可恢复" preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) weakSelf = self;
            UIAlertAction* flCancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                FL_Log(@"The \"Okay/Cancel\" alert's cancel action occured in tag1.");
            }];
            UIAlertAction *flsureAction = [UIAlertAction actionWithTitle:flSureBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                FL_Log(@"The \"Okay/Cancel\" alert's copy action occured with make sure.");
                 [[SDImageCache sharedImageCache] clearDisk];
                [weakSelf.tableView reloadData];
            }];
            [flAlertViewController addAction:flsureAction];
            [flAlertViewController addAction:flCancleAction];
            [self presentViewController:flAlertViewController animated:YES completion:nil];
            
        }

    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            FLIdeaBackViewController* ideaBack = [[FLIdeaBackViewController alloc] initWithNibName:@"FLIdeaBackViewController" bundle:nil];
            [self.navigationController pushViewController:ideaBack animated:YES];
        }
        else if (indexPath.row == 1)
        {
            FLAboutUsViewController* aboutUs = [[FLAboutUsViewController alloc] initWithNibName:@"FLAboutUsViewController" bundle:nil];
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
        else if (indexPath.row == 2)
        {
            FLCheckVersionViewController* checkVersionVC = [[FLCheckVersionViewController alloc] initWithNibName:@"FLCheckVersionViewController" bundle:nil];
            [self.navigationController pushViewController:checkVersionVC animated:YES];
        }
        
        //    }
        //    else
        //    {
        //        if (indexPath.row == 0)
        //        {
        //            FLMesageSettingViewController* messageVC = [[FLMesageSettingViewController alloc]initWithNibName:@"FLMesageSettingViewController" bundle:nil];
        //            [self.navigationController pushViewController:messageVC animated:YES];
        //
        //        }
        //    }
        

    }
    
    
}

#pragma mark header&footer
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 20;
    }
    return 5;
}

- (void)initQuitBtn
{
    //1.初始化Button
    self.quitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //2.设置文字和文字颜色
    [self.quitBtn setTitle:@"安全退出" forState:UIControlStateNormal];
    [self.quitBtn setTitleColor:XJ_COLORSTR(XJ_FCOLOR_REDFONT) forState:UIControlStateNormal];
    //3.设置圆角幅度
    self.quitBtn.layer.borderWidth = 1.0;
    //    button.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor redColor]);
    self.quitBtn.layer.masksToBounds = YES;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [self.quitBtn.layer setBorderColor:colorref];//边框颜色
    //4.设置frame
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake(200, 40);
    frame.origin = CGPointMake(0, 0);
    //    button.frame = CGRectMake(0, 100, 60, 44);
    self.quitBtn.frame = frame;
    //5.设置背景色
    self.quitBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.quitBtn.layer.cornerRadius = 20;
    //6.设置触发事件
    //省略
    [self.quitBtn addTarget:self action:@selector(makeSureToQuit) forControlEvents:UIControlEventTouchUpInside];
    //7.添加到tableView tableFooterView中
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake((FLUISCREENBOUNDS.width / 2) - 100, 10,60 , 40)];
    [view addSubview:self.quitBtn];
    self.tableView.tableFooterView=view;

}

- (void)makeSureToQuit
{
    UIAlertView* alertVC  = [[UIAlertView alloc] initWithTitle:@"确定退出登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertVC show];
    
}

#pragma mark ------alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        FL_Log(@"取消");
        
    }
    else if (buttonIndex == 1)
    {
        FL_Log(@"确定");
        [self quitMyAccountSafty];
    }
}

- (void)quitMyAccountSafty
{
    
    FL_Log(@"quit my Account");
    [XJFinalTool xjRemoveUserInfoInUserdefaultskey:XJ_VERSION_IS_THIRD];
    [XJFinalTool xjRemoveUserInfoInUserdefaultskey:FL_USERDEFAULTS_USERID_KEY];
    
    /***------------------new--------*/
    [XJFinalTool xjRemoveUserInfoInUserdefaultskey:XJ_VERSION2_PHONE];
    [XJFinalTool xjRemoveUserInfoInUserdefaultskey:XJ_VERSION2_PWD];
    /***------------------new--------*/
    
    
    [[FLAppDelegate share] showHUDWithTitile:@"退出成功" view:self.view delay:1 offsetY:0];
    FLLogIn_RegisterViewController* logInVC  = [[FLLogIn_RegisterViewController alloc] init ];//WithNibName:@"FLLogIn_RegisterViewController" bundle:nil];
    //切换全局属性
    FLFLXJIsChangeNickNameType = 1;  //1为修改昵称
    FLFLIsPersonalAccountType = 1;   //1为个人账号登录
   
    //登出环信
    [self EaseMobLogout];
    // 注销极光
    
    
    
    [self presentViewController:logInVC animated:YES completion:nil];
}

- (void)EaseMobLogout{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error && info) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];
}




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
