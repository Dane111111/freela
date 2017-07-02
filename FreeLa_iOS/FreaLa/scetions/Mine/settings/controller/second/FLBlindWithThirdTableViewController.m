//
//  FLBlindWithThirdTableViewController.m
//  FreeLa
//
//  Created by Leon on 16/1/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLBlindWithThirdTableViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface FLBlindWithThirdTableViewController ()
{
    FLUserInfoModel *userInfoModel;
    BOOL        _xj_need_sercetCode;//是否需要新增密码项
}

@property (nonatomic , strong)UITextField* areaText;
@property (nonatomic , strong)UITextField* phoneText;
@property (nonatomic , strong)UITextField* verifyCodeText;
@property (nonatomic , strong)JKCountDownButton*    verifyBtn;
@property (nonatomic , strong)  UIButton * submitBtn;

/**密码*/
@property (nonatomic , strong) UITextField* passWordText;
/**校验密码*/
//@property (nonatomic , strong) UITextField* passWordSText;

@end

@implementation FLBlindWithThirdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"绑定手机号";
    _xj_need_sercetCode = NO;
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.userInteractionEnabled = YES;
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:FL_BOTTOM_TABBAR_COLOR_IMAGE] forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(submitNewPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.submitBtn];
    self.submitBtn.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width , 44);
    self.tableView.tableFooterView = self.submitBtn;
//    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(200);
//        make.centerX.equalTo(self.view).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(560 * FL_SCREEN_PROPORTION_width, 80 * FL_SCREEN_PROPORTION_height));
//    }];
    
    UITapGestureRecognizer* tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingInBlindPhoneNumber)];
    [self.view addGestureRecognizer:tapGr];
    
    self.areaText = [[UITextField alloc]init];
    self.phoneText =[[UITextField alloc]init];
    self.passWordText = [[UITextField alloc] init];
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyCodeText.keyboardType = UIKeyboardTypeNumberPad;
    
    [KeyboardToolBar registerKeyboardToolBar:self.areaText];
    [KeyboardToolBar registerKeyboardToolBar:self.phoneText];
    [KeyboardToolBar registerKeyboardToolBar:self.passWordText];
    [KeyboardToolBar registerKeyboardToolBar:self.verifyCodeText];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark 提交新手机号

- (void)submitNewPhoneNumber
{
   
    if ([self.phoneText.text isEqualToString: @""] || [self.verifyCodeText.text isEqualToString: @""]) {
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",FLFLIsPersonalAccountType?@"手机号/验证码为空":@"邮箱/验证码为空"] view:self.view delay:1 offsetY:0];
        return;
    }
    else if (![FLTool isPhoneNumberTure:self.phoneText.text] )
    {
        [[FLAppDelegate share] showHUDWithTitile: @"手机号不正确"  view:self.view delay:1 offsetY:0];
        return;
    }
    else if (self.verifyCodeText.text.length > 4)
    {
        [[FLAppDelegate share] showHUDWithTitile: @"验证码错误"  view:self.view delay:1 offsetY:0];
        return;
    }
    else if (![FLTool isTrueSecretCode:self.passWordText.text] && _xj_need_sercetCode)
    {
        [[FLAppDelegate share] showHUDWithTitile: @"请输入6到16位密码"  view:self.view delay:1 offsetY:0];
        return;
    }
    else
    {
        //校验手机验证码
        [self compareVerifityCode];
    }

}


- (void)compareVerifityCode
{
  
    [self closeKeyBoard];
    [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
    //校验得到的验证码
    [self xj_setNewPWDAndGoBackBySMS];
    /*
    dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQuene, ^{
        //付费密码校验$
        NSDictionary* parmVerifity = [NSDictionary dictionaryWithObjectsAndKeys:
                                      XJ_USER_SESSION, @"token",
                                      self.phoneText.text,@"account",
                                      self.verifyCodeText.text,@"checkCode",
                                      nil];//$$
        [FLNetTool checkEmailVerifityParm:parmVerifity success:^(NSDictionary *data) {
            FL_Log(@"verifity compare success %@, %@",data, [data objectForKey:@"msg"]);
            if ([[data objectForKey:FL_NET_KEY]boolValue]) {
//                [[FLAppDelegate share] hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [[FLAppDelegate share] showHUDWithTitile:@"修改成功" view:self.view delay:1 offsetY:0];
                    FL_Log(@"this is change  personal phone success");
                    
                    FLFLXJIsHasPhoneBlind = 1;  //全局变量更改为已绑定手机号
                    [self sendPhoneToService];  //修改个人资料
                });
            } else {
                [[FLAppDelegate share] hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FLAppDelegate share] showHUDWithTitile:@"验证失败" view:self.view delay:1 offsetY:0];
                });
                NSLog(@"yan zheng shiba少时诵诗书i le ");
            }
        } failure:^(NSError *error) {
            NSLog(@"verifity forget message error= %@",error.debugDescription);
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",error.userInfo[NSLocalizedFailureReasonErrorKey]] view:self.view delay:1 offsetY:0];
        }];
    });
     */
  
//    FLFLXJIsHasPhoneBlind = 1;  //全局变量更改为已绑定手机号
//    [self sendPhoneToService];
}

- (void)sendPhoneToService
{
    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"phone\":\"%@\",\"userId\":\"%@\"}",FL_ALL_SESSIONID,self.phoneText.text,FL_USERDEFAULTS_USERID_NEW];
    FL_Log(@"parmdic= %@",parmDic);
    NSDictionary* parm = @{@"peruser":parmDic};
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"上传成功data 2= %@",data);
        [[FLAppDelegate share] hideHUD];
        if ([[data objectForKey:FL_NET_KEY]boolValue])  {
//            [self xj_refresh_uid];//刷新userid，用旧的请求新的
            [self thisIsForgetPwdAction];
            
        }  else  {
            [[FLAppDelegate share] hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"上传失败" view:self.view delay:1 offsetY:0];
            });
        }
        
    } failure:^(NSError *error) {
        NSLog(@"上传失败error = %@, == %@",error.description,error.debugDescription);
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
    }];
}

- (void)thisIsForgetPwdAction {
    BOOL mima = [XJFinalTool xjStringSafe:self.passWordText.text];
    if (!mima) {
        [self xj_refresh_uid];
        
    } else  {
        [FLNetTool forgetPasswordWithPhone:self.phoneText.text newPassword:self.passWordText.text success:^(NSDictionary *dic) {
            FL_Log(@"this is third set phone&pwd action =%@",dic);
            if ([[dic objectForKey:FL_NET_KEY] boolValue]){
                //设置 userdefaults
                [XJFinalTool xjSaveUserInfoInUserdefaultsValue:self.phoneText.text key:XJ_VERSION2_PHONE];
                [XJFinalTool xjSaveUserInfoInUserdefaultsValue:self.passWordText.text key:XJ_VERSION2_PHONE];
                [self endEditingInBlindPhoneNumber];
                [[FLAppDelegate share] showHUDWithTitile:@"修改成功" view:self.view delay:1 offsetY:0];
                [self xj_refresh_uid];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

//刷新userid
- (void)xj_refresh_uid {
    
    NSString* xjold = XJ_USERID_WITHTYPE;
    [FLNetTool xj_getMainUsrToken:xjold success:^(NSDictionary *data) {
        FL_Log(@"this is the main usr token=%@",data);
        NSString* xjtoken = data[@"results"];
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            
            if ([XJFinalTool xjStringSafe:xjtoken]) {
                NSDictionary* parm = @{@"token":xjtoken,
                                       };
                [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
                    FL_Log(@"this is main info =%@",data);
                    if (data) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [XJFinalTool xjSaveUserInfoInUserdefaultsValue:data[@"parentId"] key:FL_USERDEFAULTS_USERID_KEY];
                        [XJFinalTool xjSaveUserInfoInUserdefaultsValue:data[@"phone"] key:XJ_VERSION2_PHONE];
                        [XJFinalTool xjSaveUserInfoInUserdefaultsValue:data[@"token"] key:FL_NET_SESSIONID];
                        
                        FLFLXJIsHasPhoneBlind = 1;  //全局变量更改为已绑定手机号
                        if (self.delegate) {
                            [self.delegate FLBlindWithThirdTableViewController:self blindPhoneNumber:self.phoneText.text];
                        } else {
                            [FLTool showWith:@"绑定手机号操作成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_xj_need_sercetCode) {
        return 2;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 0)
    {
        
        self.areaText.text = @"+86";
        
        self.phoneText.placeholder = @"请输入手机号码";
        self.areaText.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
        //        self.areaText.textColor = [UIColor colorWithHexString:@"#6c6c6c"];
        self.areaText.keyboardType = UIKeyboardTypeNumberPad;//键盘式样
        [cell addSubview:self.areaText];
        [cell addSubview:self.phoneText];
        [self.areaText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell).with.offset(0);
            make.left.equalTo(cell).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 44));
        }];
        [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell).with.offset(0);
            make.left.equalTo(self.areaText.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width - 50, 44));
        }];
        
    }
   else  if (indexPath.row == 1)
    {
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        self.verifyCodeText= [[UITextField alloc]init];
        self.verifyCodeText.placeholder = @"请输入验证码";
        [cell addSubview:self.verifyCodeText];
        [self.verifyCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell).with.offset(0);
            make.left.equalTo(cell).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(150, 44));
        }];
        [cell addSubview:self.verifyBtn];
        [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell).with.offset(0);
            make.right.equalTo(cell.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(100, 44));
        }];
        [self.verifyBtn addToucheHandler:^(JKCountDownButton *sender, NSInteger tag) {
            sender.enabled = NO;
            [sender startWithSecond:90];
            [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
                
                NSString* title = [NSString stringWithFormat:@"%d秒以后再次获取",second];
                [sender setBackgroundColor:[UIColor grayColor]];
                return title;
            }];
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                [sender setBackgroundColor:XJ_COLORSTR(XJ_FCOLOR_REDBACK)];
                return @"重新获取";
            }];
        }];
        [self.verifyBtn addTarget:self action:@selector(checkPhoneInBlind) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.row == 2)
    {
    
        self.passWordText.placeholder = @"请设置密码";
        self.passWordText.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
        self.passWordText.keyboardType = UIKeyboardTypeDefault;//键盘式样
            self.passWordText.secureTextEntry = YES;
        [cell addSubview:self.passWordText];
        [self.passWordText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell).with.offset(0);
            make.left.equalTo(cell).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width - 50, 44));
        }];

    }
    return cell;

    
}

- (JKCountDownButton *)verifyBtn {
    if (!_verifyBtn) {
        _verifyBtn =  [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyBtn setBackgroundColor:XJ_COLORSTR(XJ_FCOLOR_REDBACK)];
        [_verifyBtn.layer setBorderColor:(__bridge CGColorRef _Nullable)(XJ_COLORSTR(XJ_FCOLOR_REDBACK))];
        _verifyBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    }
    return _verifyBtn;
}
//关闭键盘
- (void)closeKeyBoard
{
    [self.view endEditing:YES];
    [FLTool closeKeyBoardByTextField:self.areaText];
    [FLTool closeKeyBoardByTextField:self.phoneText];
    [FLTool closeKeyBoardByTextField:self.verifyCodeText];
}

- (void)checkPhoneInBlind
{
    if ([FLTool isPhoneNumberTure:self.phoneText.text]) {
        //检查是否是注册用户
        /*
        [FLNetTool isAlreadyRegistedWithPhone:self.phoneText.text success:^(NSDictionary *dic) {
             if ([[dic objectForKey:FL_NET_KEY]boolValue]) {
                 [[FLAppDelegate share] showHUDWithTitile:@"手机号已注册" view:self.view delay:1 offsetY:0];
                 [self.verifyBtn stop];
             } else  {
                 [self getVerifityCode];
             }
         } failure:^(NSError *error) {
             
         }];
         */
        [self.view endEditing:YES];
        
        //检查是否是 绑定了此类账号
        NSString* xj = [[NSUserDefaults standardUserDefaults] objectForKey:XJ_VERSION_IS_THIRD];
        
        [FLNetTool xj_checkPhoneBlindType:[xj integerValue] phone:self.phoneText.text success:^(NSDictionary *data) {
            FL_Log(@"this is the result of pbone blind=%@",data);
            NSInteger result = [data[@"results"] integerValue];
            if (result == 0) { // 0:手机号未注册 ,此时需要添加一个密码项
                _xj_need_sercetCode = YES;
                [self xj_sendVerifityCodeBySMS];// [self getVerifityCode];
                [self.tableView reloadData];
            } else if (result == 1) { // 1:已注册但未绑定指定的第三方帐号
                [self xj_sendVerifityCodeBySMS];//[self getVerifityCode];
            } else if (result == 2) { // 2：已注册并且绑定过指定的第三方帐号
                [FLTool showWith:@"已绑定过此类账号"];
                [self.verifyBtn stop];
                return ;
            }
        } failure:^(NSError *error) {
            [FLTool returnStrWithErrorCode:error];
        }];
        
    } else  {
        [[FLAppDelegate share]showHUDWithTitile:@"手机号不正确" view:self.view delay:1 offsetY:0];
        [self.verifyBtn stop];
    }
         
}

- (void)getVerifityCode
{
    /*
    BOOL isTurePhone;
    //截取地区字符
    NSString* areaString = self.areaText.text;
    areaString = [areaString substringFromIndex:1];
    NSLog(@"areaString %@",areaString);
    NSString* phoneNumberString = self.phoneText.text;
    NSLog(@"phonenumber %@",phoneNumberString);
    isTurePhone = [FLTool isPhoneNumberTure:phoneNumberString];
    if (isTurePhone == YES)
    {
        NSDictionary* parm = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.phoneText.text,@"phone"
                              , nil];
        [FLNetTool sendVerifityCodeByPayParm:parm success:^(NSDictionary *data) {
            NSLog(@"smsmsmsm = %@  msg = %@",data,[data objectForKey:@"msg"]);
            if ([[data objectForKey:FL_NET_KEY]boolValue]) {
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"已将验证码发送至%@",phoneNumberString] view:self.view delay:2 offsetY:0];
                //发送成功
            } else {
                [FLTool showWith:@"您短时间内请求过多，请稍后重试"];
                [self.verifyBtn stop];
            }
        } failure:^(NSError *error) {
            [self.verifyBtn stop];
            NSLog(@"send forget message error= %@",error.debugDescription);
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        }];
        
    }
    else
    {
        [self.verifyBtn stop];
    }
     */
    
}

/**
 * 使用SMS 短信发送验证码
 */
- (void)xj_sendVerifityCodeBySMS{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"已将验证码发送至%@",self.phoneText.text] view:self.view delay:2 offsetY:0];
        } else {
            NSLog(@"错误信息：%@",error);
            [self.verifyBtn stop];
            [FLTool showWith:@"发送失败"];
        }
    }];
    
}
/**
 * 使用SMS 短信校验验证码
 */

- (void)xj_setNewPWDAndGoBackBySMS{
    
    [SMSSDK commitVerificationCode:self.verifyCodeText.text phoneNumber:self.phoneText.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        {
            if (!error){
                NSLog(@"验证成功");
                //                    [[FLAppDelegate share] showHUDWithTitile:@"修改成功" view:self.view delay:1 offsetY:0];
                    FL_Log(@"this is change  personal phone success");
                    FLFLXJIsHasPhoneBlind = 1;  //全局变量更改为已绑定手机号
                    [self sendPhoneToService];  //修改个人资料
            }else {
                NSLog(@"错误信息:%@",error);
                [[FLAppDelegate share]hideHUD];
                [self performSelector:@selector(xj_showerror) withObject:nil afterDelay:1];
            }
        }
    }];

}

- (void)xj_showerror{
    [FLTool showWith:@"校验失败"];
}
- (void)endEditingInBlindPhoneNumber
{
    [self.view endEditing:YES];
}




@end
