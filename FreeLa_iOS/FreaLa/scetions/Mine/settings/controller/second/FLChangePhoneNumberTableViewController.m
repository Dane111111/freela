//
//  FLChangePhoneNumberTableViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/14.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLChangePhoneNumberTableViewController.h"
#import "FLHeader.h"
#import <Masonry/Masonry.h>
#import "FLTool.h"
#import "JKCountDownButton.h"
#import <SMS_SDK/SMSSDK.h>



@interface FLChangePhoneNumberTableViewController ()
{
    FLUserInfoModel *userInfoModel;
}

@property (nonatomic , strong)UITextField* areaText;
@property (nonatomic , strong)UITextField* phoneText;
@property (nonatomic , strong)UITextField* verifyCodeText;
@property (nonatomic , strong)JKCountDownButton*    verifyBtn;
@property (nonatomic , strong)  UIButton * submitBtn;

@end

@implementation FLChangePhoneNumberTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
    if (FLFLIsPersonalAccountType) {
         self.title =  @"更换手机号";
        self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    } else {
         self.title =  @"更换邮箱";
        self.phoneText.keyboardType = UIKeyboardTypeEmailAddress;
    }
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.userInteractionEnabled = YES;
//    [self.submitBtn setBackgroundImage:[UIImage imageNamed:FL_BOTTOM_TABBAR_COLOR_IMAGE] forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    [self.submitBtn addTarget:self action:@selector(submitNewPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(180 );
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(560 * FL_SCREEN_PROPORTION_width, 80 * FL_SCREEN_PROPORTION_height));
    }];
    self.submitBtn.layer.cornerRadius = 40 * FL_SCREEN_PROPORTION_height;
    self.submitBtn.layer.masksToBounds = YES;
    self.areaText = [[UITextField alloc]init];
    self.phoneText =[[UITextField alloc]init];
    self.verifyCodeText= [[UITextField alloc]init];
    
    self.verifyCodeText.keyboardType = UIKeyboardTypeNumberPad;


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
}

#pragma mark ---------Actions
/**
 * view dismiss
 */
- (void)submitNewPhoneNumber
{
    if ([self.phoneText.text isEqualToString: @""] || [self.verifyCodeText.text isEqualToString: @""]) {
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",FLFLIsPersonalAccountType?@"手机号/验证码为空":@"邮箱/验证码为空"] view:self.view delay:1 offsetY:0];
    }
    else if (![FLTool isPhoneNumberTure:self.phoneText.text] && FLFLIsPersonalAccountType)
    {
        [[FLAppDelegate share] showHUDWithTitile: @"手机号不正确"  view:self.view delay:1 offsetY:0];
    }
    else if (![FLTool isValidateEmail: self.phoneText.text] && !FLFLIsPersonalAccountType)
    {
        [[FLAppDelegate share] showHUDWithTitile: @"手机号不正确"  view:self.view delay:1 offsetY:0];
    }
    
    else
    {
        if (FLFLIsPersonalAccountType)
        {
            //校验手机验证码
            [self xj_setNewPWDAndGoBackBySMS];// [self compareVerifityCode];
        }
        else
        {
            //校验邮箱验证码
            [self checkEmailVerifity];
        }
    }
}

- (void)sendPhoneToService
{
    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"phone\":\"%@\",\"userId\":\"%@\"}",FL_ALL_SESSIONID,self.phoneText.text,FL_USERDEFAULTS_USERID_NEW];
    NSLog(@"parmdic= %@",parmDic);
    NSDictionary* parm = @{@"peruser":parmDic};
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        NSLog(@"上传成功data 5= %@",data);
        if ([[data objectForKey:FL_NET_KEY]boolValue])
        {
            [[FLAppDelegate share] showHUDWithTitile:@"修改成功" view:self.view delay:1 offsetY:0];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [[FLAppDelegate share] showHUDWithTitile:@"上传失败" view:self.view delay:1 offsetY:0];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"上传失败error = %@, == %@",error.description,error.debugDescription);
         [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (FLFLIsPersonalAccountType)
    {
        if (indexPath.row == 0)
        {
           
            self.areaText.text = @"+86";
            
            self.phoneText.placeholder = @"请输入手机号码";
           
            self.areaText.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
            self.phoneText.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
            self.verifyCodeText.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
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
        if (indexPath.row == 1)
        {
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
           
            self.verifyCodeText.placeholder = @"请输入验证码";
            [cell addSubview:self.verifyCodeText];
            [self.verifyCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell).with.offset(0);
                make.left.equalTo(cell).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(150, 44));
            }];
            self.verifyBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
            [self.verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.verifyBtn setBackgroundColor:XJ_COLORSTR(XJ_FCOLOR_REDBACK)];
            [self.verifyBtn.layer setBorderColor:(__bridge CGColorRef _Nullable)(XJ_COLORSTR(XJ_FCOLOR_REDBACK))];
            self.verifyBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
            [cell addSubview:self.verifyBtn];
            [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell).with.offset(0);
                make.right.equalTo(cell.mas_right).with.offset(-10);
                make.size.mas_equalTo(CGSizeMake(100, 44));
            }];
            [self.verifyBtn addToucheHandler:^(JKCountDownButton *sender, NSInteger tag) {
                sender.enabled = NO;
                [sender startWithSecond:60];
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
            [self.verifyBtn addTarget:self action:@selector(checkPhone) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    else
    {
        if (indexPath.row == 0)
        {
//            self.phoneText =[[UITextField alloc]init];
            self.phoneText.placeholder = @"请输企业邮箱";
            self.phoneText.frame = CGRectMake(10, 0, FLUISCREENBOUNDS.width, 44);
            [cell addSubview:self.phoneText];
        }
        else if (indexPath.row == 1)
        {
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
//            self.verifyCodeText= [[UITextField alloc]init];
            self.verifyCodeText.placeholder = @"请输入验证码";
            [cell addSubview:self.verifyCodeText];
            [self.verifyCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell).with.offset(0);
                make.left.equalTo(cell).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(150, 44));
            }];
            self.verifyBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
            [self.verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.verifyBtn setBackgroundColor:XJ_COLORSTR(XJ_FCOLOR_REDBACK)];
            [self.verifyBtn.layer setBorderColor:(__bridge CGColorRef _Nullable)(XJ_COLORSTR(XJ_FCOLOR_REDBACK))];
            self.verifyBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
            [cell addSubview:self.verifyBtn];
            [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell).with.offset(0);
                make.right.equalTo(cell.mas_right).with.offset(-10);
                make.size.mas_equalTo(CGSizeMake(100, 44));
            }];
            [self.verifyBtn addToucheHandler:^(JKCountDownButton *sender, NSInteger tag) {
                sender.enabled = NO;
                [sender startWithSecond:60];
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
            [self.verifyBtn addTarget:self action:@selector(checkEmail) forControlEvents:UIControlEventTouchUpInside];

        }
    }
    
    
    return cell;
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

- (void)checkEmail
{
    if ([FLTool isValidateEmail:self.phoneText.text])
    {
        //检查是否是已注册邮箱
        NSDictionary* dic = @{@"email":self.phoneText.text};
        [FLNetTool howManyAccountWithEmailBilndparm:dic success:^(NSDictionary *data) {
            NSLog(@"how many = %@",data);
            NSInteger number = [[data objectForKey:@"count"]integerValue];
            if ( number == 0 )
            {
                //发送验证邮件
                [self getVerifityCodeEmail];
                
            }else
            {
                [[FLAppDelegate share] showHUDWithTitile:@"该邮箱已注册,请更换邮箱" view:self.view delay:1 offsetY:0];
//                FLBusinessApplyEmailTableViewCell* cellemail = (FLBusinessApplyEmailTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
//                [cellemail.flvirifityBtn stop];
                [self.verifyBtn stop];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"how many = %@",error.debugDescription);
             [self.verifyBtn stop];
        }];
    }
    else
    {
        [[FLAppDelegate share]showHUDWithTitile:@"邮箱格式不正确" view:self.view delay:1 offsetY:0];
        [self.verifyBtn stop];
    }
}

- (void)checkPhone
{
        if ([FLTool isPhoneNumberTure:self.phoneText.text])
        {
            //检查是否是注册用户
            [FLNetTool isAlreadyRegistedWithPhone:self.phoneText.text success:^(NSDictionary *dic) {
                 if ([[dic objectForKey:FL_NET_KEY]boolValue]) {
                     [self.view endEditing:YES];
                     [[FLAppDelegate share] showHUDWithTitile:@"手机号已注册" view:self.view delay:1 offsetY:0];
                     [self.verifyBtn stop];
                 }  else {
                     [self xj_sendVerifityCodeBySMS];//[self getVerifityCode];
                 }
             } failure:^(NSError *error) {
                 
             }];
            
        } else {
            [[FLAppDelegate share]showHUDWithTitile:@"手机号不正确" view:self.view delay:1 offsetY:0];
            [self.verifyBtn stop];
        }
        
}

- (void)getVerifityCodeEmail
{
    
    [FLNetTool sendVerifityCodeWithEmail:self.phoneText.text success:^(NSDictionary *dic) {
        if ([[dic objectForKey:FL_NET_KEY]boolValue]) {
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"已将邮件发送至%@",self.phoneText.text] view:self.view delay:1 offsetY:0];
        }
    } failure:^(NSError *error) {
        NSLog(@"send email is error = %@ , %@",error.description,error.debugDescription);
        [self.verifyBtn stop];
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
    }];

}

- (void)compareVerifityCode
{
    [self closeKeyBoard];
    [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
    //校验得到的验证码
    dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQuene, ^{
        //付费密码校验$
        NSDictionary* parmVerifity = [NSDictionary dictionaryWithObjectsAndKeys:
                                      XJ_USER_SESSION, @"token",
                                      self.phoneText.text,@"account",
                                      self.verifyCodeText.text,@"checkCode",
                                      nil];//$$
        [FLNetTool checkEmailVerifityParm:parmVerifity success:^(NSDictionary *data) {
            NSLog(@"verifity compare success %@, %@",data, [data objectForKey:@"msg"]);
            if ([[data objectForKey:FL_NET_KEY]boolValue]) {
                [[FLAppDelegate share] hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[FLAppDelegate share] showHUDWithTitile:@"修改成功" view:self.view delay:1 offsetY:0];
                    NSLog(@"this is change  personal phone success");
                    [self.delegate FLChangePhoneNumberTableViewController:self passValue:self.phoneText.text];
                    //写入缓存
                    [self sendPhoneToService];
                });
            }
            else
            {
                [[FLAppDelegate share] hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FLAppDelegate share] showHUDWithTitile:@"验证失败" view:self.view delay:1 offsetY:0];
                });
                NSLog(@"yan zheng shibai le ");
            }
        } failure:^(NSError *error) {
            NSLog(@"verifity forget message error= %@",error.debugDescription);
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",error.userInfo[NSLocalizedFailureReasonErrorKey]] view:self.view delay:1 offsetY:0];
        }];
    });
}

- (void)checkEmailVerifity
{
    //验证邮箱验证码
    dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQuene, ^{
        NSDictionary* parmVerifity = [NSDictionary dictionaryWithObjectsAndKeys:
                                      FLFLBusSesssionID, @"token",
                                      self.phoneText.text,@"account",
                                      self.verifyCodeText.text,@"checkCode",
                                      nil];//$$
        NSLog(@"verifity in bus apply parm = %@",parmVerifity);
        [FLNetTool checkEmailVerifityParm:parmVerifity success:^(NSDictionary *data) {
            NSLog(@"verifity compare success %@, %@",data, [data objectForKey:@"msg"]);
            if ([[data objectForKey:FL_NET_KEY]boolValue])
            {
                [self submitMyNewEmailAccount];
            }
            else
            {
                NSLog(@"yan zheng shibai le ");
                [[FLAppDelegate share] showHUDWithTitile:@"验证失败" view:self.view delay:1 offsetY:0];
            }
        } failure:^(NSError *error) {
            NSLog(@"verifity forget message error= %@",error.debugDescription);
        }];
    });

}

- (void)submitMyNewEmailAccount
{
    NSString* parmDic = [NSString stringWithFormat:@"{\"email\":\"%@\",\"userId\":\"%@\"}",self.phoneText.text,FLFLXJBusinessUserID];
    NSLog(@"parmdic= %@",parmDic);
    NSDictionary* parmUpdate = @{@"compuser":parmDic,@"token":FLFLBusSesssionID};
    
    [FLNetTool updateCompInfoWithParm:parmUpdate success:^(NSDictionary *data) {
        NSLog(@"update bus success = %@ ,",data );
        if ([[data objectForKey:@"info"]isEqualToString:@"success"]) {
            [[FLAppDelegate share] showHUDWithTitile:@"更新成功" view:self.view delay:1 offsetY:0];
            //代理
            [self.delegate FLChangePhoneNumberTableViewController:self passValue:self.phoneText.text];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"update bus error = %@ , %@",error.description , error.debugDescription);
        [[FLAppDelegate share] showHUDWithTitile:[FLTool returnStrWithErrorCode:error] view:self.view delay:1 offsetY:0];
    }];
}

//关闭键盘
- (void)closeKeyBoard
{
    [FLTool closeKeyBoardByTextField:self.areaText];
    [FLTool closeKeyBoardByTextField:self.phoneText];
    [FLTool closeKeyBoardByTextField:self.verifyCodeText];
    
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
    [self closeKeyBoard];
    [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
    //校验得到的验证码
    dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQuene, ^{
        //付费密码校验$
        NSDictionary* parmVerifity = [NSDictionary dictionaryWithObjectsAndKeys:
                                      XJ_USER_SESSION, @"token",
                                      self.phoneText.text,@"account",
                                      self.verifyCodeText.text,@"checkCode",
                                      nil];//$$
        [FLNetTool checkEmailVerifityParm:parmVerifity success:^(NSDictionary *data) {
            NSLog(@"verifity compare success %@, %@",data, [data objectForKey:@"msg"]);
            if ([[data objectForKey:FL_NET_KEY]boolValue]) {
                [[FLAppDelegate share] hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [[FLAppDelegate share] showHUDWithTitile:@"修改成功" view:self.view delay:1 offsetY:0];
                    NSLog(@"this is change  personal phone success");
                    [self.delegate FLChangePhoneNumberTableViewController:self passValue:self.phoneText.text];
                    //写入缓存
                    [self sendPhoneToService];
                });
            }
            else
            {
                [[FLAppDelegate share] hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[FLAppDelegate share] showHUDWithTitile:@"验证失败" view:self.view delay:1 offsetY:0];
                });
                NSLog(@"yan zheng shibai le ");
            }
        } failure:^(NSError *error) {
            NSLog(@"verifity forget message error= %@",error.debugDescription);
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",error.userInfo[NSLocalizedFailureReasonErrorKey]] view:self.view delay:1 offsetY:0];
        }];
    });
    
    [SMSSDK commitVerificationCode:self.verifyCodeText.text phoneNumber:self.phoneText.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        if (!error) {
            [[FLAppDelegate share] hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                //                    [[FLAppDelegate share] showHUDWithTitile:@"修改成功" view:self.view delay:1 offsetY:0];
                NSLog(@"this is change  personal phone success");
                [self.delegate FLChangePhoneNumberTableViewController:self passValue:self.phoneText.text];
                //写入缓存
                [self sendPhoneToService];
            });
        }else{
            [[FLAppDelegate share] hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"验证失败" view:self.view delay:1 offsetY:0];
            });
            NSLog(@"yan zheng shibai le ");
        }
    }];

}


@end














