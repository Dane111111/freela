//
//  FLForgetPWDViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLForgetPWDViewController.h"
#import "FLTool.h"
#import "FLHeader.h"
#import "HexColors.h"
#import <Masonry/Masonry.h>
#import "FLAppDelegate.h"
#import <SMS_SDK/SMSSDK.h>

#define xj_cornerRadius     15

@interface FLForgetPWDViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    MBProgressHUD* _hud;
    BOOL isLoading;   //防止持续点击
}

@property (nonatomic , strong)UIView* phoneView;
@property (nonatomic , strong)UITextField* areaText;
@property (nonatomic , strong)UITextField* phoneText;
@property (nonatomic , strong)UITextField* verifyCodeText;
//@property (nonatomic , strong)UIButton*   getTextCodeButton;
@property (nonatomic , strong)JKCountDownButton * getTextCodeButton;
@property (nonatomic , strong)UIView * NewPWDView;
@property (nonatomic , strong)UIImageView* pwdImageView;
@property (nonatomic , strong)UITextField* NewPWDText;
@property (nonatomic , strong)UIButton * nextButton;
/**确认密码*/
@property (nonatomic , strong)UIView* sureView;
/**确认密码*/
@property (nonatomic, strong)UITextField* sureTextfield;
@end

@implementation FLForgetPWDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    [self setUPBaseRegisterUI];
    [self makeConstraints];
    [self tapBlanceSpace];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:FL_BOTTOM_TABBAR_COLOR_IMAGE] forBarMetrics:UIBarMetricsDefault];
    
    //设置title
    self.title = @"忘记密码";
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
   
    //左返回键
    UIBarButtonItem* sssssss = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBackToLogInVC)];
    self.navigationController.navigationItem.leftBarButtonItem = sssssss;

    [self.navigationItem setLeftBarButtonItem:sssssss];
//    背景色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)goBackToLogInVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setUPBaseRegisterUI
{
    //请输入手机号码
    self.areaText = [[UITextField alloc]init];
    self.phoneText = [[UITextField alloc]init];
    self.phoneText.backgroundColor = [UIColor blackColor ];
    self.phoneView = [FLTool setPhoneTextWithAreaText:self.areaText phoneText:self.phoneText];
    self.phoneText.delegate = self;
    [self.view addSubview:self.phoneView];

    //验证码输入
    self.verifyCodeText = [[UITextField alloc]init];
    self.verifyCodeText.backgroundColor = [UIColor whiteColor];
    self.verifyCodeText.layer.cornerRadius = xj_cornerRadius;
    self.verifyCodeText.placeholder = @"验证码";
    self.verifyCodeText.keyboardType = UIKeyboardTypeNumberPad;//键盘式样
    self.verifyCodeText.textAlignment = NSTextAlignmentCenter;
    self.verifyCodeText.delegate = self;
    [self.view addSubview:self.verifyCodeText];
    
    self.getTextCodeButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [self.getTextCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getTextCodeButton.layer.cornerRadius = xj_cornerRadius;
    self.getTextCodeButton.layer.masksToBounds = YES;
    self.getTextCodeButton.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [self.getTextCodeButton setBackgroundImage:[UIImage imageNamed:@"button_background_red"] forState:UIControlStateNormal];
    [self.view addSubview:self.getTextCodeButton];
    [self.getTextCodeButton addToucheHandler:^(JKCountDownButton *sender, NSInteger tag) {
        sender.enabled = NO;
        [sender startWithSecond:60];
        [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
            NSString* title = [NSString stringWithFormat:@"%d秒以后再次获取",second];
            [sender setBackgroundImage:[UIImage imageNamed:@"button_background_gray"] forState:UIControlStateNormal];
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            self.nextButton.enabled = YES;
            [sender setBackgroundImage:[UIImage imageNamed:@"button_background_red"] forState:UIControlStateNormal];
            return @"重新获取";
        }];
    }];
    
    [KeyboardToolBar registerKeyboardToolBar:self.verifyCodeText];
    [KeyboardToolBar registerKeyboardToolBar:self.phoneText];
    [KeyboardToolBar registerKeyboardToolBar:self.NewPWDText];
    [KeyboardToolBar registerKeyboardToolBar:self.sureTextfield];
    [self.getTextCodeButton addTarget:self action:@selector(xj_sendVerifityCodeBySMS) forControlEvents:UIControlEventTouchUpInside];//getSMSCodeForForgetPWD

#warning 此处有一个封装
    //请输入新密码
    self.NewPWDText   = [[UITextField alloc]init];
    [self.NewPWDText setBackgroundColor:[UIColor whiteColor]];
    self.NewPWDText.secureTextEntry = YES;
    self.NewPWDText.delegate = self;
   
    self.NewPWDView   = [FLTool setNewPWDTextWithpwdImage:@"icon_key_gray" pwdText:self.NewPWDText];
    [self.view addSubview:self.NewPWDView];
    //请确认新密码
    self.sureTextfield = [[UITextField alloc] init];
    [self.sureTextfield setBackgroundColor:[UIColor whiteColor]];
    self.sureTextfield.secureTextEntry = YES;
    self.sureTextfield.delegate = self;
    self.sureView  = [FLTool setNewPWDTextWithpwdImage:@"icon_key_gray" pwdText:self.sureTextfield];
    self.sureTextfield.placeholder = @"请确认新密码";
    [self.view addSubview:self.sureView];
    //下一步
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(checkInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"button_background_red"] forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:XJ_COLORSTR(XJ_FCOLOR_REDBACK)];
    self.nextButton.layer.masksToBounds = YES;            //解决圆角 不圆的问题 ，切掉图外的方法
    self.nextButton.layer.cornerRadius = 20;
    [self.view addSubview:self.nextButton];
  
    
}

- (void)makeConstraints
{
    //手机号view
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(80 * FL_SCREEN_PROPORTION_height);
        make.size.mas_equalTo(CGSizeMake(470 * FL_SCREEN_PROPORTION_width, 80 * FL_SCREEN_PROPORTION_height));
    }];
    //+86
    [self.areaText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.phoneView).with.offset(0);
//        make.left.equalTo(self.phoneView).with.offset(10);
//       make.size.mas_equalTo(CGSizeMake(80 * FL_SCREEN_PROPORTION_width, 30 * FL_SCREEN_PROPORTION_height));
    
    }];
//    phonetext
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.phoneView).with.offset(0);
        make.left.equalTo(self.areaText.mas_right).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(350 * FL_SCREEN_PROPORTION_width, 50 * FL_SCREEN_PROPORTION_height));
    }];
    
//    验证码
    [self.verifyCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView).with.offset((140 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.left.equalTo(self.phoneView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(180 * FL_SCREEN_PROPORTION_width, 80 * FL_SCREEN_PROPORTION_height));
    }];
    //获取验证码
    [self.getTextCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView).with.offset((140 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.right.equalTo(self.phoneView.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(230 * FL_SCREEN_PROPORTION_width, 80 * FL_SCREEN_PROPORTION_height));
    }];
    //新密码view
    [self.NewPWDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.getTextCodeButton).with.offset((140 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.size.mas_equalTo(CGSizeMake(470 * FL_SCREEN_PROPORTION_width, 80 * FL_SCREEN_PROPORTION_height));
    }];
    //pwdtext
    [self.NewPWDText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.NewPWDView).with.offset(0);
        make.left.equalTo(self.areaText.mas_right).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(350 * FL_SCREEN_PROPORTION_width, 50 * FL_SCREEN_PROPORTION_height));
    }];
    //self.sureView
    [self.sureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.NewPWDView).with.offset((140 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.size.mas_equalTo(CGSizeMake(470 * FL_SCREEN_PROPORTION_width, 80 * FL_SCREEN_PROPORTION_height));
    }];
    //pwdtext
    [self.sureTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sureView).with.offset(0);
        make.left.equalTo(self.areaText.mas_right).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(350 * FL_SCREEN_PROPORTION_width, 50 * FL_SCREEN_PROPORTION_height));
    }];
    //nextButton
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.sureView).with.offset((140 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.size.mas_equalTo(CGSizeMake(470 * FL_SCREEN_PROPORTION_width, 40));
    }];
 
}

#pragma mark-------Action
//单击空白
- (void)tapBlanceSpace
{
    UITapGestureRecognizer* tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoardInForget)];
    tapgesture.delegate = self;
    [self.view addGestureRecognizer:tapgesture];
    
    
}
//关闭键盘
- (void)closeKeyBoardInForget
{
    [FLTool closeKeyBoardByTextField:self.areaText];
    [FLTool closeKeyBoardByTextField:self.phoneText];
    [FLTool closeKeyBoardByTextField:self.verifyCodeText];
    [FLTool closeKeyBoardByTextField:self.NewPWDText];
}
//获取验证码
- (void)getSMSCodeForForgetPWD
{

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
        //判断手机号是否已经注册
        [FLNetTool isAlreadyRegistedWithPhone:self.phoneText.text success:^(NSDictionary *dic) {
            
            if (![[dic objectForKey:FL_NET_KEY] boolValue])
            {
                [[FLAppDelegate share] showHUDWithTitile:@"您还咩有注册，请先注册" view:self.view delay:1 offsetY:0];
                [self.getTextCodeButton stop];
            }else
            {
                self.getTextCodeButton.enabled = YES;
                [self xj_sendVerifityCodeBySMS];
                /*
                NSDictionary* parm = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self.phoneText.text,@"phone"
                                      , nil];
                [FLNetTool sendVerifityCodeByPayParm:parm success:^(NSDictionary *data) {
                    NSLog(@"smsmsmsm forget pwd = %@  msg = %@",data,[data objectForKey:@"msg"]);
                    if ([[data objectForKey:FL_NET_KEY]boolValue]) {
                        self.nextButton.enabled = YES;
                        self.getTextCodeButton.enabled = NO;
                        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"已将验证码发送至%@",phoneNumberString] view:self.view delay:2 offsetY:0];
                        //发送成功
                    }
                } failure:^(NSError *error) {
                    NSLog(@"send forget message error= %@",error.debugDescription);
                    [self.getTextCodeButton stop];
                    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",error.userInfo[NSLocalizedDescriptionKey]] view:self.view delay:1 offsetY:0];
                    
                }];
                 */
            }
            
        } failure:^(NSError *error) {
            NSLog(@"failure ====   ,=========%@",error.description);
             [self.getTextCodeButton stop];
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",error.userInfo[NSLocalizedDescriptionKey]] view:self.view delay:1 offsetY:0];
        }];

    }
    else
    {
        self.nextButton.enabled = NO;
        self.getTextCodeButton.enabled = YES;
        [[FLAppDelegate share] showHUDWithTitile:@"请输入正确的手机号码" view:self.view delay:1 offsetY:-30];
        [self.getTextCodeButton stop];
    }
    
}

/**
 * 使用SMS 短信发送验证码
 */
- (void)xj_sendVerifityCodeBySMS{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            self.nextButton.enabled = YES;
            self.getTextCodeButton.enabled = NO;
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"已将验证码发送至%@",self.phoneText.text] view:self.view delay:2 offsetY:0];
        } else {
            NSLog(@"错误信息：%@",error);
            [self.getTextCodeButton stop];
            [FLTool showWith:@"发送失败"];
        }
    }];
    
}
/**
 * 使用SMS 短信校验验证码
 */

- (void)xj_setNewPWDAndGoBackBySMS{
    [self closeKeyBoardInForget];
    if (![FLTool isTrueSecretCode:self.NewPWDText.text]) {
        [[FLAppDelegate share] showHUDWithTitile:@"密码中请不要出现特殊字符" view:self.view delay:1 offsetY:0];
        return;
    }
    
    
    
        //校验得到的验证码
        [self closeKeyBoardInForget];
        [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
        dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQuene, ^{
            [SMSSDK commitVerificationCode:self.verifyCodeText.text phoneNumber:self.phoneText.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                {
                    if (!error){
                        NSLog(@"验证成功");
                        [[FLAppDelegate share]hideHUD];
                        [self xj_changeSecret];
                        
                    }else {
                        NSLog(@"错误信息:%@",error);
                        [[FLAppDelegate share]hideHUD];
                        [self performSelector:@selector(xj_showerror) withObject:nil afterDelay:1];
                    }
                }
            }];

        });
}
/**修改密码接口*/
-(void)xj_changeSecret{
    [FLNetTool forgetPasswordWithPhone:self.phoneText.text newPassword:self.NewPWDText.text success:^(NSDictionary *dic) {
        FL_Log(@"this is my post forget p22wd=%@",dic);
        if ([[dic objectForKey:FL_NET_KEY] boolValue])
        {
            FL_Log(@"成功 ===3=== %@ ，value ==  %@ ",dic,[dic objectForKey:@"msg"]);
            [[FLAppDelegate share]hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self closeKeyBoardInForget];
                [[FLAppDelegate share] showHUDWithTitile:@"修改密码成功" view:self.view delay:1 offsetY:0];
                [self performSelector:@selector(change_loginstate) withObject:nil afterDelay:2];
                /*
                //更改userdefaulets
                [self changeMyUserdefaultsInForgetSerct];
                [NSThread sleepForTimeInterval:2];
                 */
                //此处直接跳转至广场页
                //                             [self dismissViewControllerAnimated:YES completion:nil];
                //                            [[FLAppDelegate share] setUpTabBar];
            });
            
        } else {
            [[FLAppDelegate share]hideHUD];
        }
    } failure:^(NSError *error) {
        NSLog(@"failure ====   ,=========%@",error.description);
        [[FLAppDelegate share]hideHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[FLAppDelegate share] showHUDWithTitile:[FLTool returnStrWithErrorCode:error] view:self.view delay:1 offsetY:0];
        });
        
    }];
}

- (void)change_loginstate{
    FLLogIn_RegisterViewController* logInVC = [[FLLogIn_RegisterViewController alloc]init];
    [self presentViewController:logInVC animated:YES completion:nil];
}
- (void)xj_showerror{
    [FLTool showWith:@"校验失败,您可以尝试重新发送验证码"];
}

//下一步 ,验证
- (void)setNewPWDAndGoBack
{
    [self closeKeyBoardInForget];
    if (![FLTool isTrueSecretCode:self.NewPWDText.text]) {
        [[FLAppDelegate share] showHUDWithTitile:@"密码中请不要出现特殊字符" view:self.view delay:1 offsetY:0];
    }
    else
    {
    //校验得到的验证码
    [self closeKeyBoardInForget];
    [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
    dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQuene, ^{

        //付费密码校验$
        NSDictionary* parmVerifity = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self.phoneText.text,@"account",
                                      self.verifyCodeText.text,@"checkCode",
                                      nil];//$$
        FL_Log(@"pamverfity = %@",parmVerifity);
        [FLNetTool checkEmailVerifityParm:parmVerifity success:^(NSDictionary *data) {
            FL_Log(@"verifity compare success %@, %@",data, [data objectForKey:@"msg"]);
            if ([[data objectForKey:FL_NET_KEY]boolValue]) {
                [FLNetTool forgetPasswordWithPhone:self.phoneText.text newPassword:self.NewPWDText.text success:^(NSDictionary *dic) {
                    FL_Log(@"this is my post forget pwd=%@",dic);
                    if ([[dic objectForKey:FL_NET_KEY] boolValue])
                    {
                        FL_Log(@"成功 ===2=== %@ ，value ==  %@ ",dic,[dic objectForKey:@"msg"]);
                        [[FLAppDelegate share]hideHUD];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[FLAppDelegate share] showHUDWithTitile:@"修改密码成功" view:self.view delay:1 offsetY:0];
                            [self closeKeyBoardInForget];
                            //更改userdefaulets
                            [self changeMyUserdefaultsInForgetSerct];
                            [NSThread sleepForTimeInterval:2];
                            //此处直接跳转至广场页
//                             [self dismissViewControllerAnimated:YES completion:nil];
//                            [[FLAppDelegate share] setUpTabBar];
                        });
                       
                    } else {
                        [[FLAppDelegate share]hideHUD];
                    }
                } failure:^(NSError *error) {
                    NSLog(@"failure ====   ,=========%@",error.description);
                    [[FLAppDelegate share]hideHUD];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[FLAppDelegate share] showHUDWithTitile:[FLTool returnStrWithErrorCode:error] view:self.view delay:1 offsetY:0];
                    });
                   
                }];
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
              NSLog(@"verifity forget message error= %ld  = %@",(long)error.code,error.description);
            [[FLAppDelegate share]hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:[FLTool returnStrWithErrorCode:error] view:self.view delay:1 offsetY:0];
            });
        }];
    });
    }
}
//校验信息完整度
- (void)checkInfo
{
    if (!self.phoneText.text || [self.phoneText.text isEqualToString:@""])
    {
        [[FLAppDelegate share] showHUDWithTitile:@"手机号不能为空" view:self.view delay:1 offsetY:0 ];
        return;
    }else if (![FLTool isPhoneNumberTure:self.phoneText.text])
    {
        [[FLAppDelegate share] showHUDWithTitile:@"手机号不正确" view:self.view delay:1 offsetY:0 ];
        return;
    }
    else if(!self.verifyCodeText.text || [self.verifyCodeText.text isEqualToString:@""])
    {
        [[FLAppDelegate share] showHUDWithTitile:@"验证码不能为空" view:self.view delay:1 offsetY:0];
        return;
    }
    else if(!self.sureTextfield.text || [self.sureTextfield.text isEqualToString:@""])
    {
        [[FLAppDelegate share] showHUDWithTitile:@"请输入新密码" view:self.view delay:1 offsetY:0];
        return;
    }
    else
    {
        if (![FLTool checkLengthWithString:self.NewPWDText.text length:6 lengthM:16 view:self.view who:@"密码"])
        {
            return;
        }
        else if (![FLTool checkLengthWithString:self.sureTextfield.text length:6 lengthM:16 view:self.view who:@"新密码"])
        {
            return;
        }
        else if (![self.NewPWDText.text isEqualToString: self.sureTextfield.text])
        {
            [[FLAppDelegate share] showHUDWithTitile:@"两次密码输入不一致" view:self.view delay:1 offsetY:0];
        }
        
        else
        {
            [self xj_setNewPWDAndGoBackBySMS];//[self setNewPWDAndGoBack];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField == self.phoneText )
    {
        if (string.length == 0) return YES;
        
        if (existedLength - selectedLength + replaceLength > 11)
        {
            return NO;
        }
    }   else if (textField == self.NewPWDText)  {
        if (string.length == 0) return YES;
        if (existedLength - selectedLength + replaceLength > 16)
        {
            return NO;
        }
    } else if (textField == self.verifyCodeText)  {
        if (string.length == 0) return YES;
        if (existedLength - selectedLength + replaceLength > 4) {
            return NO;
        }
    } else if (textField == self.sureTextfield) {
        if (self.sureTextfield.text.length >=16) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view endEditing:YES];
}

- (void)changeMyUserdefaultsInForgetSerct
{
    [FLNetTool logInWithPhone:self.phoneText.text  password:self.NewPWDText.text success:^(NSDictionary *dic) {
        if ([[dic objectForKey:FL_NET_KEY] boolValue])
        {
            [[FLAppDelegate share] hideHUD];
    
            //存入sessionID
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:[dic objectForKey:FL_NET_SESSIONID] key:FL_NET_SESSIONID];
            [[FLAppDelegate share] showSimplleHUDWithTitle:nil view:self.view];
            [[FLAppDelegate share] showHUDWithTitile:@"登录成功" view:self.view delay:1 offsetY:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] setUpTabBar];
            });
        } else {
            FL_Log(@"用户名密码不正确");
            [[FLAppDelegate share] hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"用户名密码不正确，请重新输入" view:self.view delay:1 offsetY:0];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"failure ====   ,=========%@,  ______________ %@   , +++++++++++++ %@",error.description , error.debugDescription,error.domain);
        
    }];

    
    
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view  endEditing:YES];
}



@end




























