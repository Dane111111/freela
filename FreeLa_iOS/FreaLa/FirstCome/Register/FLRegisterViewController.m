//
//  FLRegisterViewController.m
//  dajiba
//
//  Created by 楚志鹏 on 15/9/22.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLRegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FLHeader.h"
#import "HexColors.h"
#import <Masonry/Masonry.h>
#import "FLRegisterSecondViewController.h"
#import "FLNetTool.h"
#import <SMS_SDK/SMSSDK.h>

#define xj_cornerRadius     15


@interface FLRegisterViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic , strong)UIView* phoneView;
@property (nonatomic , strong)UITextField* areaText;
@property (nonatomic , strong)UITextField* phoneText;
@property (nonatomic , strong)UITextField* verifyCodeText;
@property (nonatomic , strong)UIButton*   choiceButton;
@property (nonatomic , strong)UIButton*   agreementButton;
@property (nonatomic , strong)UIButton*    nextStep;
@property (nonatomic , strong)UILabel*    agreeLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;

@property (nonatomic , strong)UIButton *testButton;
@property (nonatomic , strong)JKCountDownButton * getTextCodeButton;

//@property


@end

@implementation FLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRegisterView];
    [self makeConstraints];
    [self changeLayoutConstraint];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    //设置title
    self.title = @"用户注册";
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:FL_BOTTOM_TABBAR_COLOR_IMAGE] forBarMetrics:UIBarMetricsDefault];
    //左返回键
    UIBarButtonItem* returnItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goToLogInVC)];
    self.navigationItem.leftBarButtonItem = returnItem;
    //背景色
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //添加一个Tap手势用来点击空白区域关闭键盘
    UITapGestureRecognizer* tapGertureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    tapGertureRecognizer.numberOfTapsRequired = 1 ;
    tapGertureRecognizer.numberOfTouchesRequired = 1;
    tapGertureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGertureRecognizer];
}

#pragma mark Action
- (void)goToLogInVC
{
    [self closeKeyBoard];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//选还是不选
- (void)agreeOrNot
{
//    if (self.choiceButton.selected == NO)
//    {
//        [self.choiceButton setBackgroundImage:[UIImage imageNamed:@"button_choice_right"] forState:UIControlStateSelected];
//    }
//    self.choiceButton.selected = !self.choiceButton.selected;
    [[FLAppDelegate share] showHUDWithTitile:@"请阅读并同意《免费啦用户协议》" view:self.view delay:1 offsetY:0];
}

- (void)readMe
{
    NSLog(@"协议啊巴拉巴拉巴拉");
    FLAgreementViewController * agreeVC = [[FLAgreementViewController alloc] init];
    [self.navigationController pushViewController:agreeVC animated:YES];
    
}

//获取验证码
- (void)getSMSCodeBtn {
    //判断手机号长度
    if ([FLTool isPhoneNumberTure:self.phoneText.text]) {
    //判断手机号是否已经注册
    [FLNetTool isAlreadyRegistedWithPhone:self.phoneText.text success:^(NSDictionary *dic) {
        
        if (![[dic objectForKey:FL_NET_KEY] boolValue])  {
             NSLog(@"成功 ===1=== %@ ，value ==  %@ ",dic,[dic objectForKey:FL_NET_KEY]);
            //获取验证码
            [self getVerifityCode];
        }else {
            [[FLAppDelegate share] showHUDWithTitile:@"该手机号已注册" view:self.view delay:1 offsetY:0];
            [self.getTextCodeButton stop];
            self.getTextCodeButton.enabled = YES;
        }
        
    } failure:^(NSError *error) {
          NSLog(@"failure ====   ,=========%@",error.description);
        [self.getTextCodeButton stop];
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",error.userInfo[NSLocalizedDescriptionKey]] view:self.view delay:1 offsetY:0];
    }];
    }  else {
        [[FLAppDelegate share] showHUDWithTitile:@"手机号不正确" view:self.view delay:1 offsetY:0];
        [self.getTextCodeButton stop];
    }

}
//获取验证码
- (void)getVerifityCode
{
    //截取地区字符
    NSString* areaString = self.areaText.text;
    areaString = [areaString substringFromIndex:1];
    NSLog(@"areaString %@",areaString);
    NSString* phoneNumberString = self.phoneText.text;
    NSLog(@"phonenumber %@",phoneNumberString);
    //使用付费短信
    BOOL isTurePhone;
    //截取地区字符
    areaString = [areaString substringFromIndex:1];
    NSLog(@"areaString %@",areaString);
    NSLog(@"phonenumber %@",phoneNumberString);
    isTurePhone = [FLTool isPhoneNumberTure:phoneNumberString];
    if (isTurePhone == YES)
    {
        //判断手机号是否已经注册
        [FLNetTool isAlreadyRegistedWithPhone:self.phoneText.text success:^(NSDictionary *dic) {
            
            if ([[dic objectForKey:FL_NET_KEY] boolValue])
            {
                [[FLAppDelegate share] showHUDWithTitile:@"您还咩有注册，请先注册" view:self.view delay:1 offsetY:0];
                [self.getTextCodeButton stop];
            }else
            {
                [self xjSend_FreeYzm:self.phoneText.text];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"failure ====   ,=========%@",error.description);
        }];
        
    }
    else
    {
        [[FLAppDelegate share] showHUDWithTitile:@"请输入正确的手机号码" view:self.view delay:1 offsetY:-30];
        [self.getTextCodeButton stop];
    }
}

- (void)xjSendYZM:(NSString*)phoneNumberString {
    [self xjSend_FreeYzm:phoneNumberString];
}
- (void)xjSend_FreeYzm:(NSString*)phoneNumberString {
    self.getTextCodeButton.enabled = NO;
    [self xj_sendVerifityCodeBySMS];
    /*
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
        NSLog(@"send forget message error= %@",error.debugDescription);
    }];
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
            [self.getTextCodeButton stop];
            [FLTool showWith:@"发送失败"];
        }
    }];
    
}

- (void)xjSend_HuaQianYzm {
    
}
- (void)xjYan_FreeYzm {
    
}
- (void)xjYan_HuaQianYzm {
    
}

//注册下一步和比对验证码
- (void)nextStepAndVerify
{
    //此处为纯代码编写区域
}
//下一步按钮动作
- (IBAction)nextStepAndVerify:(UIButton *)sender
{
    [self closeKeyBoard];
    //校验信息完整度
    if (!self.phoneText.text || [self.phoneText.text isEqualToString:@""])
    {
        [[FLAppDelegate share] showHUDWithTitile:@"手机号不能为空" view:self.view delay:1 offsetY:0 ];
    }else if (![FLTool isPhoneNumberTure:self.phoneText.text])
    {
        [[FLAppDelegate share] showHUDWithTitile:@"手机号不正确" view:self.view delay:1 offsetY:0 ];
    }
    else if(!self.verifyCodeText.text || [self.verifyCodeText.text isEqualToString:@""])
    {
        [[FLAppDelegate share] showHUDWithTitile:@"验证码不能为空" view:self.view delay:1 offsetY:0];
    }
    else if(!self.verifyCodeText.text || [self.verifyCodeText.text isEqualToString:@""])
    {
        [[FLAppDelegate share] showHUDWithTitile:@"验证码不能为空" view:self.view delay:1 offsetY:0];
    }
    else
    {
        [self xj_setNewPWDAndGoBackBySMS];
        /*
    dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQuene, ^{
         //付费密码校验$
        NSDictionary* parmVerifity = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self.phoneText.text,@"account",
                                      self.verifyCodeText.text,@"checkCode",
                                      nil];//$$
         //付费短信校验验证码$
        [FLNetTool checkEmailVerifityParm:parmVerifity success:^(NSDictionary *data) {
            if ([[data objectForKey:FL_NET_KEY]boolValue]) {
                [[FLAppDelegate share] showHUDWithTitile:@"验证成功" view:self.view delay:1 offsetY:0];
                //推出注册第二个界面
                FLRegisterSecondViewController* registerSecondVC = [[FLRegisterSecondViewController alloc]initWithNibName:@"FLRegisterSecondViewController" bundle:nil];
                registerSecondVC.phoneString = self.phoneText.text;
                [self.navigationController pushViewController:registerSecondVC animated:YES];
            }
            else{
                [[FLAppDelegate share] showHUDWithTitile:@"验证失败" view:self.view  delay:1 offsetY:0];
//                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]] view:self.view delay:1 offsetY:0];
            }
        } failure:^(NSError *error) {
            NSLog(@" register request error =%@, %@ ",error.description,error.debugDescription);
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@", [FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        }];
        
    });
         */

    }
}

/**
 * 使用SMS 短信校验验证码
 */

- (void)xj_setNewPWDAndGoBackBySMS{
    //校验得到的验证码
    [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
    dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQuene, ^{
        [SMSSDK commitVerificationCode:self.verifyCodeText.text phoneNumber:self.phoneText.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
            {
                if (!error){
                    NSLog(@"验证成功");
                    //推出注册第二个界面
                    FLRegisterSecondViewController* registerSecondVC = [[FLRegisterSecondViewController alloc]initWithNibName:@"FLRegisterSecondViewController" bundle:nil];
                    registerSecondVC.phoneString = self.phoneText.text;
                    [self.navigationController pushViewController:registerSecondVC animated:YES];
                    
                }else {
                    NSLog(@"错误信息:%@",error);
                    [[FLAppDelegate share]hideHUD];
                    [self performSelector:@selector(xj_showerror) withObject:nil afterDelay:1];
                }
            }
        }];
        
    });
}
- (void)xj_showerror{
    [FLTool showWith:@"校验失败"];
}


#pragma mark---------UI

- (void)initRegisterView
{
    //输入框view
    self.phoneView = [[UIView alloc]init];
    self.phoneView.backgroundColor = [UIColor whiteColor];
    self.phoneView.layer.cornerRadius = xj_cornerRadius;
    [self.view addSubview:self.phoneView];
    //区号选择text
    self.areaText =[[UITextField alloc]init];
    self.areaText.text = @"+86";
    self.areaText.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
    self.areaText.textColor = [UIColor colorWithHexString:@"#6c6c6c"];
    self.areaText.frame = CGRectMake(100, 190, 100, 30);
    self.areaText.textAlignment = NSTextAlignmentCenter;
    [self.phoneView addSubview:self.areaText];
    
    //手机号输入
    self.phoneText = [[UITextField alloc]init];
    self.phoneText.layer.cornerRadius = xj_cornerRadius;
    self.phoneText.borderStyle = UITextBorderStyleRoundedRect;//关于光标过于靠前的解决方法
    self.phoneText.clearButtonMode = UITextFieldViewModeAlways;//关于输入框 X号 问题
    self.phoneText.clearsOnBeginEditing = YES;//再次编辑清空
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;//键盘式样
    self.phoneText.placeholder = @"请输入手机号";
    self.phoneText.borderStyle = UITextBorderStyleNone; //边框样式
    self.phoneText.delegate = self;
    [self.phoneView addSubview:self.phoneText];
    
    //验证码输入
    self.verifyCodeText = [[UITextField alloc]init];
    self.verifyCodeText.backgroundColor = [UIColor whiteColor];
    self.verifyCodeText.layer.cornerRadius = xj_cornerRadius;
    self.verifyCodeText.placeholder = @"验证码";
    self.verifyCodeText.keyboardType = UIKeyboardTypeNumberPad;//键盘式样
    self.verifyCodeText.textAlignment = NSTextAlignmentCenter;
    self.verifyCodeText.delegate = self ;
    [self.view addSubview:self.verifyCodeText];
    
    //获取验证码
    self.getTextCodeButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [self.getTextCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [self.getTextCodeButton setBackgroundImage:[UIImage imageNamed:@"button_background_red"] forState:UIControlStateNormal];
    [self.getTextCodeButton setBackgroundColor:XJ_COLORSTR(XJ_FCOLOR_REDBACK)];
    self.getTextCodeButton.layer.cornerRadius = xj_cornerRadius;
    self.getTextCodeButton.layer.masksToBounds = YES;
    self.getTextCodeButton.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
//    self.getTextCodeButton.backgroundColor = [UIColor colorWithHexString:@"#cfcfcf"];
//    self.getTextCodeButton.backgroundColor  = [UIColor grayColor];
    
    [self.view addSubview:self.getTextCodeButton];
    [self.getTextCodeButton addToucheHandler:^(JKCountDownButton *sender, NSInteger tag) {
        sender.enabled = NO;
        [sender startWithSecond:60];
        [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = NO;
            NSString* title = [NSString stringWithFormat:@"%d秒以后再次获取",second];
            [sender setBackgroundImage:[UIImage imageNamed:@"button_background_gray"] forState:UIControlStateNormal];
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            [sender setBackgroundImage:[UIImage imageNamed:@"button_background_red"] forState:UIControlStateNormal];
            return @"重新获取";
        }];
    }];
    [self.getTextCodeButton addTarget:self action:@selector(getSMSCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    
  
    
    //选择
    self.choiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.choiceButton.layer.cornerRadius = 5;
    [self.choiceButton setBackgroundColor:[UIColor whiteColor]];
    [self.choiceButton addTarget:self action:@selector(agreeOrNot) forControlEvents:UIControlEventTouchUpInside];
    [self.choiceButton setBackgroundImage:[UIImage imageNamed:@"button_choice_right"] forState:UIControlStateNormal];
    [self.view addSubview:self.choiceButton];
    
    //同意
    self.agreeLabel = [[UILabel alloc]init];
    self.agreeLabel.text = @"同意";
    self.agreeLabel.textAlignment = NSTextAlignmentRight;
    self.agreeLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
//    self.agreeLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.agreeLabel];
    
    //免费啦用户协议
    self.agreementButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.agreementButton setTitle:@"《免费啦用户协议》" forState:UIControlStateNormal];
    self.agreementButton.titleLabel.font =[UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [self.agreementButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self.agreementButton addTarget:self action:@selector(readMe) forControlEvents:UIControlEventTouchUpInside];
//    self.agreementButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.agreementButton];
}

- (void)makeConstraints
{
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset((80 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.height.equalTo(@((80 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
        make.width.equalTo(@((470 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
        
    }];
    
    [self.areaText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneView).with.offset(0);
        make.left.equalTo(self.phoneView).with.offset(0);
        make.height.equalTo(@((30 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
        make.width.equalTo(@((80 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
        
    }];
    
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneView).with.offset(0);
        make.left.equalTo(self.areaText.mas_right).with.offset(2);
        make.height.equalTo(@((50 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
        make.width.equalTo(@((350 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
        
    }];
    //验证码
    [self.verifyCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView).with.offset((140 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.left.equalTo(self.phoneView).with.offset(0);
        make.height.equalTo(@((80 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
        make.width.equalTo(@((180 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
        }];
    //获取验证码
    [self.getTextCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView).with.offset((140 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.right.equalTo(self.phoneView.mas_right).with.offset(0);
        make.height.equalTo(@((80 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
        make.width.equalTo(@((230 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
    }];
    //选择
    [self.choiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView).with.offset((400 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.left.equalTo(self.view).with.offset((200 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION);
        make.height.equalTo(@((30 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
        make.width.equalTo(@((30 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
    }];
    //同意
    [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.choiceButton).with.offset(0);
        make.left.equalTo(self.choiceButton.mas_right).with.offset((1 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION);
        make.size.mas_equalTo(CGSizeMake(30, 20));
//        make.height.equalTo(@((20 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
//        make.width.equalTo(@((50 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
    }];
    //用户协议
    [self.agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.choiceButton).with.offset(0);
        make.left.equalTo(self.agreeLabel.mas_right).with.offset((0 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION);
         make.size.mas_equalTo(CGSizeMake(110, 20));
//        make.height.equalTo(@((20 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION));
//        make.width.equalTo(@((220 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
    }];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(0);
//        make.top.equalTo(self.view).with.offset((700 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.height.equalTo(@40);
        make.width.equalTo(@((470 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION));
    }];
}

- (void)changeLayoutConstraint
{
    self.leftLayout.constant = ((100 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION);
    self.topLayout.constant =((700 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
    
}

#pragma mark ---------CloseKeyBoard
- (void)closeKeyBoard
{
    [self.phoneText resignFirstResponder];
    [self.verifyCodeText resignFirstResponder];
    [self.areaText resignFirstResponder];
}

#pragma mark ---textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneText)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11)
        {
            return NO;
        }
    }
    else if (textField == self.verifyCodeText)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 4)
        {
            return NO;
        }
    }
    return YES;
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end




















