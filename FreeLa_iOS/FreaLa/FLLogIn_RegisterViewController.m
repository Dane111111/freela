//
//  FLLogIn_RegisterViewController.m
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/16.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//

#import "FLLogIn_RegisterViewController.h"
#import "FLLogInViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FLRegisterViewController.h"
#import "FLHeader.h"
#import <Masonry/Masonry.h>
#import "FLLogIn_RegisterView.h"
#import "FLForgetPWDViewController.h"

#define XJ_THIRDLOG_MIDDLE_MARGIN    ((FLUISCREENBOUNDS.width -  2 * ((120 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION) - 3 *  60 * FL_SCREEN_PROPORTION_width) / 2)
#define XJ_THIRDLOG_WIDTH            70 * FL_SCREEN_PROPORTION_width

@interface FLLogIn_RegisterViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    //关于用户的用户名密码
   
    NSData          * userData;
    NSString* _xjUnionid;
    NSInteger _xjSex;

}
@property (strong, nonatomic) MPMoviePlayerController *player;

@property (nonatomic , strong)UIImageView* phoneImageView;
@property (nonatomic , strong)UIImageView* backdropImageView;
@property (nonatomic , strong)UIImageView* logoImageView;
@property (nonatomic , strong)UIImageView* passwordImageView;
@property (nonatomic , strong)UITextField* phoneText;
@property (nonatomic , strong)UITextField* passwordText;

@property (nonatomic , strong)UIButton*     logInButton;
@property (nonatomic , strong)UIButton*     registerButton;
@property (nonatomic , strong)UIButton*     forgetPWDButton;
@property (nonatomic , strong)UILabel*      ORLeable;

@property (nonatomic , strong)UIButton*  qqLogIn;
@property (nonatomic , strong)UIButton*  weChatLogIn;
//@property (nonatomic , strong)UIButton*  renrenLogIn;
@property (nonatomic , strong)UIButton*  weiboLogIn;
@property (nonatomic , strong)UILabel*   qqLabel;
@property (nonatomic , strong)UILabel*   wechatLabel;
@property (nonatomic , strong)UILabel*   weiboLabel;
//@property (nonatomic , strong)UILabel*   renrenLabel;


@end


@implementation FLLogIn_RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self SetupVideoPlayer];
    [self initLogIn_RegisterView];
    [self initThirdPartyLogin];
    [self drawUnderLines];
    [self addConstraints];
    [self tapTheScreen];
    

    
    //    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    [UMSocialWechatHandler setWXAppId:FL_UMENG_SDK_WECHAT_ID appSecret:FL_UMENG_SDK_WECHAT_SECRET  url:@"http://www.umeng.com/social"];
//    [UMSocialQQHandler setQQWithAppId:@"1104722431" appKey:FL_QQ_APP_KEY url:@"http://www.umeng.com/social"];
     
    
    
}
- (void)SetupVideoPlayer
{
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"log_bg" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:filePath];;

    self.player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    [self.view addSubview:self.player.view];
    self.player.shouldAutoplay = YES;
    self.player.repeatMode     = MPMovieRepeatModeOne;
    
    self.player.view.alpha     = 0;
    [self.player.view setFrame:self.view.bounds];
    [self.player setControlStyle:MPMovieControlStyleNone];
    
    [UIView animateWithDuration:2 animations:^{
        self.player.view.alpha = 1;
        [self.player prepareToPlay];
    }];
    
}

#pragma mark -------action
- (void)tapTheScreen
{
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEmpryScreen:)];
    [self.player.view addGestureRecognizer:tapRecognizer];
    tapRecognizer.numberOfTapsRequired = 1;
//    tapRecognizer.numberOfTouches = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    tapRecognizer.delegate = self;
    
}

- (void)GoToLogIn
{
    if (![self.phoneText.text isEqualToString:@""] && ![self.passwordText.text isEqualToString:@""] ) {
        if ([FLTool isNetworkEnabled]){
        //验证
        [self sendMessageToServiceToLogIn];
        }else
        {
            [[FLAppDelegate share] showHUDWithTitile:@"无网络连接" view:self.view delay:1 offsetY:0];
        }
    }
    else
    {
        [[FLAppDelegate share] showHUDWithTitile:@"用户名或密码为空" view:self.view delay:1 offsetY:0];
    }
    
}

- (void)GoToRegistration
{
    NSLog(@"点击注册");
    FLRegisterViewController* RegisterVC = [[FLRegisterViewController alloc]init];
      UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:RegisterVC];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)forgetPWD
{
    FL_Log(@"忘记密码");
    FLForgetPWDViewController* forgetPWDVC = [[FLForgetPWDViewController alloc]initWithNibName:@"FLForgetPWDViewController" bundle:nil];
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:forgetPWDVC];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)sendMessageToServiceToLogIn
{
    [[FLAppDelegate share] showSimplleHUDWithTitle:nil view:self.view];
    //TODO
    [self.passwordText resignFirstResponder];
    if (!FLFLIsRequestingBtn) {
        FLFLIsRequestingBtn = 1;
    FL_Log(@"ffllflflflfl = %ld",(long)FLFLIsRequestingBtn);
    dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQuene, ^{
        [FLNetTool isAlreadyRegistedWithPhone:self.phoneText.text success:^(NSDictionary *dic) {
            if ([[dic objectForKey:FL_NET_KEY]boolValue]) {
                FL_Log(@"now im log in = %@",dic[@"msg"]);
                 FLFLIsRequestingBtn = 0;
                [self underCheckAndLogIn];
            } else  {
                [[FLAppDelegate share]hideHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"你还没注册呐" view:self.view delay:1 offsetY:0];
                });
            }
        } failure:^(NSError *error) {
            NSLog(@"checek number in logvc error = %@ , =%@",error.description,error.debugDescription);
            FLFLIsRequestingBtn = 0;
            [[FLAppDelegate share]hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",error.userInfo[NSLocalizedDescriptionKey]] view:self.view delay:1 offsetY:0];
            });
        }];
    });
    }
    else
    {
        FLFLIsRequestingBtn = 0;
        [[FLAppDelegate share]hideHUD];
        NSLog(@"别瞎点了");
    }
}

- (void)underCheckAndLogIn
{
    [FLNetTool logInWithPhone:self.phoneText.text password:self.passwordText.text success:^(NSDictionary *dic) {
        FL_Log(@"sasadah少时诵诗书lk= %@",dic);
        if ([[dic objectForKey:FL_NET_KEY] boolValue]) {
            [[FLAppDelegate share] hideHUD];
            [self setUpUserDefaultsWithDic:dic];
            [self xjRequestUserInfoWithToken:dic[FL_NET_SESSIONID]];//通过token 请求userinfo
            //保存用户名和密码
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:self.phoneText.text key:XJ_VERSION2_PHONE];
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:self.passwordText.text key:XJ_VERSION2_PWD];
            //移除第三方登陆
            [[XJUserAccountTool share] xj_save_isthirdLogin:nil];
        }  else  {
             FL_Log(@"密码不正确");
            [[FLAppDelegate share] hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"密码不正确，请重新输入" view:self.view delay:1 offsetY:0];
            });
        }
    } failure:^(NSError *error) {
        FL_Log(@"failure ====   ,======= ==%@,  ______________ %@   , +++++++++++++ %@",error.description , error.debugDescription,error.domain);
        
    }];

}

- (void)setUpUserDefaultsWithDic:(NSDictionary*)dic {

    //存入sessionID
    [XJFinalTool xjSaveUserInfoInUserdefaultsValue:[dic objectForKey:FL_NET_SESSIONID] key:FL_NET_SESSIONID];
    [self tapTheScreen];
    //                [self seeAllUserInfo];
    [[FLAppDelegate share] showSimplleHUDWithTitle:nil view:self.view];
    [[FLAppDelegate share] showHUDWithTitile:@"登录成功" view:self.view delay:1 offsetY:0];
//    [self dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[FLAppDelegate share] setUpTabBar];
    });
    
}

#pragma mark -------GestureRecognizerDelegate
- (void)tapEmpryScreen:(UIGestureRecognizer*)recognizer
{
    [self.phoneText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

#pragma mark -------initView

- (void)initLogIn_RegisterView
{
    //背景
    self.backdropImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
    self.backdropImageView.backgroundColor=[UIColor clearColor];
//    self.backdropImageView.image = [UIImage imageNamed:@"login_backdrop"];
    [self.view addSubview:self.backdropImageView];
    
    //图标
    self.logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_freela"]];
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = 10;
    [self.player.view addSubview:self.logoImageView];
    
    //手机号头像
    self.phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_head"]];
    [self.player.view addSubview:self.phoneImageView];
    
    
    //手机号文本框
    self.phoneText = [[UITextField alloc]init];
    [KeyboardToolBar registerKeyboardToolBar:self.phoneText];
    //    self.phoneText.backgroundColor = [UIColor redColor];//测试文本框
    self.phoneText.borderStyle = UITextBorderStyleRoundedRect;//关于光标过于靠前的解决方法
    self.phoneText.clearButtonMode = UITextFieldViewModeAlways;//关于输入框 X号 问题
//    self.phoneText.clearsOnBeginEditing = YES;//再次编辑清空
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;//键盘式样
    self.phoneText.backgroundColor = [UIColor clearColor];
    self.phoneText.placeholder = @"手机号";
    self.phoneText.textColor = [UIColor whiteColor];
    self.phoneText.delegate = self;
    [self.phoneText  setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.player.view addSubview:self.phoneText];
    
    //密码图片
    self.passwordImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_key"]];
    [self.player.view addSubview:self.passwordImageView];
    
    //密码文本框
    self.passwordText = [[UITextField alloc]init];
    [KeyboardToolBar registerKeyboardToolBar:self.passwordText];
    //     self.passwordText.backgroundColor = [UIColor redColor];//测试文本框
    self.passwordText.borderStyle = UITextBorderStyleRoundedRect;//关于光标过于靠前的解决方法
    self.passwordText.clearButtonMode = UITextFieldViewModeAlways;//关于输入框 X号 问题
//    self.passwordText.clearsOnBeginEditing = YES;//再次编辑清空
    self.passwordText.keyboardType = UIKeyboardTypeDefault;//键盘式样
    self.passwordText.secureTextEntry = YES;//密码输入变成点
    self.passwordText.returnKeyType = UIReturnKeyDone;//return变成什么样
    self.passwordText.delegate = self;
    self.passwordText.backgroundColor = [UIColor clearColor];
    self.passwordText.placeholder = @"密码";
    self.passwordText.textColor = [UIColor whiteColor];
    [self.passwordText  setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.player.view addSubview:self.passwordText];
    
    //代理
    
    
    
    //登录按钮
    self.logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logInButton.layer.cornerRadius = 20;
    [self.logInButton setBackgroundImage:[UIImage imageNamed:@"button_background_red"] forState:UIControlStateNormal];
    [self.logInButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.logInButton.titleLabel.font = [UIFont fontWithName:@"Times NEW Roman" size:24.f];
    [self.logInButton addTarget:self action:@selector(GoToLogIn) forControlEvents:UIControlEventTouchUpInside];
    [self.player.view addSubview:self.logInButton];
    
    //忘记密码
    self.forgetPWDButton = [[UIButton alloc]init];
    [self.forgetPWDButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetPWDButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.forgetPWDButton addTarget:self action:@selector(forgetPWD) forControlEvents:UIControlEventTouchUpInside];
    [self.player.view addSubview:self.forgetPWDButton];
    
    //立即注册
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.layer.cornerRadius = 15.0;
    self.registerButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(GoToRegistration) forControlEvents:UIControlEventTouchUpInside];
    [self.registerButton setTintColor:[UIColor whiteColor]];
    [self.player.view addSubview:self.registerButton];
    
    //OR
    self.ORLeable = [[UILabel alloc]init];
    self.ORLeable.text = @"or";
    self.ORLeable.font = [UIFont fontWithName:@"" size:12];
    self.ORLeable.textColor = [UIColor whiteColor];
    self.ORLeable.textAlignment = NSTextAlignmentCenter;
    [self.player.view addSubview:self.ORLeable];
}
//添加约束
- (void)addConstraints
{
    //图标约束
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.player.view).with.offset((100 * FLUISCREENBOUNDS.height)/ FL_HEIGHT_PROPORTION);
        NSLog(@"%f,,,,,",FLUISCREENBOUNDS.height);
        make.centerX.equalTo(self.backdropImageView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    //手机头像约束
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImageView).with.offset((200 * FLUISCREENBOUNDS.height)/ FL_HEIGHT_PROPORTION);
        make.centerX.equalTo(self.backdropImageView).with.offset(-110);
        make.size.mas_equalTo(CGSizeMake(25, 30));
    }];
    
    //手机文本框约束
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImageView).with.offset((200 * FLUISCREENBOUNDS.height)/ FL_HEIGHT_PROPORTION);
        make.left.equalTo(self.phoneImageView).with.offset(30);
        make.right.equalTo(self.backdropImageView).with.offset(-40);
        
    }];
    
    //密码图片约束
    [self.passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneImageView).with.offset((90 * FLUISCREENBOUNDS.height)/ FL_HEIGHT_PROPORTION);
        make.centerX.equalTo(self.backdropImageView).with.offset(-110);
        make.size.mas_equalTo(CGSizeMake(25, 30));
    }];
    
    //密码文本框约束
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneImageView).with.offset((90 * FLUISCREENBOUNDS.height)/ FL_HEIGHT_PROPORTION);
        make.left.equalTo(self.phoneImageView).with.offset(30);
        make.right.equalTo(self.backdropImageView).with.offset(-40);
    }];
    
    //登录按钮约束
    [self.logInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordImageView).with.offset((150 * FLUISCREENBOUNDS.height)/ FL_HEIGHT_PROPORTION);
        make.centerX.equalTo(self.backdropImageView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width - 80, 40));
    }];
    
    //忘记密码约束
    [self.forgetPWDButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logInButton).with.offset((120 * FLUISCREENBOUNDS.height)/ FL_HEIGHT_PROPORTION);
        make.left.equalTo(self.logInButton).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100,40));
    }];
    
    //立即注册约束
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logInButton).with.offset((130 * FLUISCREENBOUNDS.height)/ FL_HEIGHT_PROPORTION);
        make.right.equalTo(self.logInButton).with.offset(0);
        //        make.size.mas_equalTo(CGSizeMake((120 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION, 30));
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    //单词or约束
    [self.ORLeable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backdropImageView).with.offset((850 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION );
        make.centerX.equalTo(self.backdropImageView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];
    
    
    //QQLogin约束  renren  weibo  wechat
    [self.qqLogIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backdropImageView).with.offset((930 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.left.equalTo(self.backdropImageView).with.offset(XJ_THIRDLOG_MIDDLE_MARGIN);
        make.size.mas_equalTo(CGSizeMake(XJ_THIRDLOG_WIDTH, XJ_THIRDLOG_WIDTH));
    }];
    
    [self.qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qqLogIn).with.offset(0);
        make.centerY.equalTo(self.qqLogIn).with.offset((50 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
    }];
    
    [self.weChatLogIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backdropImageView).with.offset((930 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
//        make.left.equalTo(self.qqLogIn).with.offset(XJ_THIRDLOG_MIDDLE_MARGIN + 1.5 * XJ_THIRDLOG_WIDTH);
        make.centerX.equalTo(self.backdropImageView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(XJ_THIRDLOG_WIDTH, XJ_THIRDLOG_WIDTH));
    }];
    
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.weChatLogIn).with.offset(0);
        make.centerY.equalTo(self.weChatLogIn).with.offset((50 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        
    }];
    
//    [self.renrenLogIn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backdropImageView).with.offset((930 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
//        make.left.equalTo(self.weChatLogIn).with.offset((110 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION);
//        make.size.mas_equalTo(CGSizeMake(60 * FL_SCREEN_PROPORTION_width, 60 * FL_SCREEN_PROPORTION_height));
//    }];
    
//    [self.renrenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.renrenLogIn).with.offset(0);
//        make.centerY.equalTo(self.renrenLogIn).with.offset((50 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
//        
//    }];
    
    [self.weiboLogIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backdropImageView).with.offset((930 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        make.right.equalTo(self.backdropImageView.mas_right).with.offset(-XJ_THIRDLOG_MIDDLE_MARGIN );
        make.size.mas_equalTo(CGSizeMake(XJ_THIRDLOG_WIDTH , XJ_THIRDLOG_WIDTH));
    }];
    
    [self.weiboLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.weiboLogIn).with.offset(0);
        make.centerY.equalTo(self.weiboLogIn).with.offset((50 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
        
    }];
    
//    NSString* xxjxj = [NSString stringWithFormat:@"%f",XJ_THIRDLOG_MIDDLE_MARGIN];
    
}



#pragma mark------initThirdPartyLogin

- (void)initThirdPartyLogin
{
    self.qqLogIn          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.weChatLogIn      = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.renrenLogIn      = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.weiboLogIn       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.qqLogIn.layer.cornerRadius = (30 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION ;
//    self.qqLogIn.clipsToBounds = YES;
    self.weiboLogIn.layer.cornerRadius = (30 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION ;
//    self.weiboLogIn.clipsToBounds = YES;
    self.weChatLogIn.layer.cornerRadius = (30 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION ;
    self.weChatLogIn.clipsToBounds = YES;
//    self.renrenLogIn.layer.cornerRadius = (30 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION ;
//    self.renrenLogIn.clipsToBounds = YES;
    [self.qqLogIn setBackgroundImage:[UIImage imageNamed:@"logIn_qq"] forState:UIControlStateNormal];
    [self.weiboLogIn setBackgroundImage:[UIImage imageNamed:@"logIn_weibo"] forState:UIControlStateNormal];
    [self.weChatLogIn setBackgroundImage:[UIImage imageNamed:@"logIn_weChat"] forState:UIControlStateNormal];
//    [self.renrenLogIn setBackgroundImage:[UIImage imageNamed:@"logIn_renren"] forState:UIControlStateNormal];
    self.qqLabel = [[UILabel alloc]init];
//    self.renrenLabel = [[UILabel alloc]init];
    self.wechatLabel = [[UILabel alloc]init];
    self.weiboLabel = [[UILabel alloc]init];
    self.qqLabel.text = @"QQ";
    self.wechatLabel.text = @"微信";
//    self.renrenLabel.text = @"人人";
    self.weiboLabel.text  = @"微博";
    self.qqLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    self.weiboLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    self.wechatLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
//    self.renrenLabel.font = [UIFont fontWithName:FL_FONT_NAME size:14];
    self.qqLabel.textAlignment = NSTextAlignmentCenter;
//    self.renrenLabel.textAlignment = NSTextAlignmentCenter;
    self.wechatLabel.textAlignment = NSTextAlignmentCenter;
    self.weiboLabel.textAlignment = NSTextAlignmentCenter;
    self.qqLabel.textColor = [UIColor whiteColor];
    self.wechatLabel.textColor = [UIColor whiteColor];
//    self.renrenLabel.textColor = [UIColor whiteColor];
    self.weiboLabel.textColor = [UIColor whiteColor];
    [self.player.view addSubview:self.qqLabel];
//    [self.view addSubview:self.renrenLabel];
    [self.player.view addSubview:self.weiboLabel];
    [self.player.view addSubview:self.wechatLabel];
    [self.player.view addSubview:self.qqLogIn];
//    [self.view addSubview:self.renrenLogIn];
    [self.player.view addSubview:self.weiboLogIn];
    [self.player.view addSubview:self.weChatLogIn];
    [self logInWithShareSDK];
    
}

- (void)logInWithShareSDK
{
    [self.weChatLogIn addTarget:self action:@selector(logInWithWeChatSDK) forControlEvents:UIControlEventTouchUpInside];
    [self.weiboLogIn addTarget:self action:@selector(logInWithWeiBoSDK) forControlEvents:UIControlEventTouchUpInside];
    [self.qqLogIn addTarget:self action:@selector(flLogInWithQQSDK) forControlEvents:UIControlEventTouchUpInside];
//    [self.renrenLogIn addTarget:self action:@selector(flRenRenLogInSDK) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark--------drawLines

- (void)drawUnderLines
{
    //PhoneUnderLine
    UIView* phoneLineView  = [[UIView alloc]init];
    phoneLineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.player.view addSubview:phoneLineView];
    [phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneImageView).with.offset(36);
        make.left.equalTo(self.phoneImageView).with.offset(0);
        make.right.equalTo(self.phoneText).with.offset(0);
        make.height.mas_equalTo(1.0);
        
    }];
    
    //PWDUnderLine
    UIView* PWDUnderLine  = [[UIView alloc]init];
    PWDUnderLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.player.view addSubview:PWDUnderLine];
    [PWDUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordImageView).with.offset(36);
        make.left.equalTo(self.passwordImageView).with.offset(0);
        make.right.equalTo(self.passwordText).with.offset(0);
        make.height.mas_equalTo(1.0);
    }];
    
    //ForgetPWDUnderLine
    UIView* ForgetPWDUnderLine  = [[UIView alloc]init];
    ForgetPWDUnderLine.backgroundColor = [[UIColor colorWithHexString:@"#e3e3e3"] colorWithAlphaComponent:0.5];

    [self.player.view addSubview:ForgetPWDUnderLine];
    [ForgetPWDUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetPWDButton).with.offset(30);
        make.left.equalTo(self.forgetPWDButton).with.offset(15);
        make.right.equalTo(self.forgetPWDButton).with.offset(-15);
        make.height.mas_equalTo(1.0);
    }];
    
    //底部线分成两段
    UIView* BottomLineLeft  = [[UIView alloc]init];
    BottomLineLeft.backgroundColor = [[UIColor colorWithHexString:@"#e3e3e3"] colorWithAlphaComponent:0.5];

    [self.player.view addSubview:BottomLineLeft];
    [BottomLineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backdropImageView).with.offset((880 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION );
        make.left.equalTo(self.backdropImageView).with.offset((70 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION);
        make.size.mas_equalTo(CGSizeMake((200 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION, 1.0));
    }];
    
    UIView* BottomLineRight  = [[UIView alloc]init];
    BottomLineRight.backgroundColor = [[UIColor colorWithHexString:@"#e3e3e3"] colorWithAlphaComponent:0.5];

    [self.player.view addSubview:BottomLineRight];
    [BottomLineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backdropImageView).with.offset((880 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION );
        make.right.equalTo(self.backdropImageView).with.offset((-70 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION);
        make.size.mas_equalTo(CGSizeMake((200 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION, 1.0));
    }];
    
}

#pragma mark -------textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.passwordText resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneText)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength  = string.length;
        if (existedLength - selectedLength + replaceLength > 11)
        {
            return NO;
        }
    }
    else if (textField == self.passwordText)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16)
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark 第三方登录
- (void)logInWithWeChatSDK
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            FL_Log(@"usernamssse is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSString* xjToken = response.data[@"wxsession"][@"accessToken"];
            NSString* xjOpenId = response.data[@"wxsession"][@"usid"];
            [FLNetTool xjGetunionidWithToken:xjToken openId:xjOpenId success:^(NSDictionary *dic) {
                FL_Log(@"this is the datassss = %@",dic);
                _xjUnionid = dic[@"unionid"];
                _xjSex = [dic[@"sex"] integerValue];
                if(_xjSex == 2){
                    self.flThirdLogInModel.sex=0;
                } else if (_xjSex==1){
                    self.flThirdLogInModel.sex=1;
                }
                //此处为自动注册
//                self.flThirdLogInModel = [FLMyThirdLogInModel mj_objectWithKeyValues:snsAccount];
                self.flThirdLogInModel.userName =  dic[@"nickname"] ;
                self.flThirdLogInModel.iconURL = dic[@"headimgurl"] ;
                self.flThirdLogInModel.flSource =  @"5" ;
                self.flThirdLogInModel.unionid = _xjUnionid;
//                self.flThirdLogInModel.sex = _xjSex;
                [self logInWithThirdInSelfIsWeChat:YES];
            } failure:^(NSError *error) {
                [[FLAppDelegate share] hideHUD];
            }];
        }
        
    });
    
    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        FL_Log(@"SnsInformation is %@",response.data);
        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSString* xjToken = response.data[@"access_token"];
//            NSString* xjOpenId = response.data[@"openid"];
//            [FLNetTool xjGetunionidWithToken:xjToken openId:xjOpenId success:^(NSDictionary *dic) {
//                FL_Log(@"this is the data = %@",dic);
//                _xjUnionid = dic[@"unionid"];
//                _xjSex = [dic[@"sex"] integerValue];
//            } failure:^(NSError *error) {
//                
//            }];
        } else {
            [[FLAppDelegate share]hideHUD];
        }
        
    }];

}

- (void)logInWithWeiBoSDK {
     //删除授权
//    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//        NSLog(@"response is %@",response);
//    }];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            FL_Log(@"userssname is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            self.flThirdLogInModel.usid = self.flThirdLogInModel.usid ? self.flThirdLogInModel.usid : snsAccount.usid ? snsAccount.usid :@"";
            self.flThirdLogInModel.userName = self.flThirdLogInModel.userName ? self.flThirdLogInModel.userName :snsAccount.userName ? snsAccount.userName: @"";
            self.flThirdLogInModel.iconURL = self.flThirdLogInModel.iconURL ?self.flThirdLogInModel.iconURL: snsAccount.iconURL ? snsAccount.iconURL :@"";
            self.flThirdLogInModel.sex =  self.flThirdLogInModel.sex ?self.flThirdLogInModel.sex :0;
            self.flThirdLogInModel.flSource =  @"6" ;
//            self.flThirdLogInModel = [FLMyThirdLogInModel mj_objectWithKeyValues:snsAccount];
            if (self.flThirdLogInModel.usid) {
                 [self logInWithThirdInSelfIsWeChat:NO];
            } else {
                [[FLAppDelegate share] hideHUD];
            }
        }});
    
    //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation 微博 is %@",response.data);
//        self.flThirdLogInModel = [FLMyThirdLogInModel mj_objectWithKeyValues:response.data];
        self.flThirdLogInModel.sex = [response.data[@"gender"] integerValue];
        self.flThirdLogInModel.usid = response.data[@"uid"] ;
        self.flThirdLogInModel.userName = response.data[@"screen_name"] ;
        self.flThirdLogInModel.iconURL = response.data[@"profile_image_url"];
        self.flThirdLogInModel.flSource =  @"4" ;
    }];
    //获取好友列表
    [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//        FL_Log(@"SnsFriends is %@",response.data);
    }];
    


}

- (void)flLogInWithQQSDK {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取 用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
//            self.flThirdLogInModel = [FLMyThirdLogInModel mj_objectWithKeyValues:snsAccount];
            if ( self.flThirdLogInModel.usid) {
                 UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                self.flThirdLogInModel.usid = self.flThirdLogInModel.usid ? self.flThirdLogInModel.usid : snsAccount.usid ? snsAccount.usid :@"";
                self.flThirdLogInModel.userName =  self.flThirdLogInModel.userName ? self.flThirdLogInModel.userName : snsAccount.userName ? snsAccount.userName :@"";
                self.flThirdLogInModel.iconURL = self.flThirdLogInModel.iconURL ? self.flThirdLogInModel.iconURL  : snsAccount.iconURL ?snsAccount.iconURL :@"";
                [self logInWithThirdInSelfIsWeChat:NO];
            } else {
                [self logInWithThirdInSelfIsWeChat:NO];
            }
        }});
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation qq  is %@",response.data);
        //        self.flThirdLogInModel = [FLMyThirdLogInModel mj_objectWithKeyValues:response.data];
        NSString* xjSex =  response.data[@"gender"] ;
        if ([xjSex isEqualToString:@"男"]) {
            self.flThirdLogInModel.sex = 1;
        } else if ([xjSex isEqualToString:@"女"]){
             self.flThirdLogInModel.sex = 0;
        } else  {
            self.flThirdLogInModel.sex = 2;
        }
        self.flThirdLogInModel.usid = response.data[@"uid"] ;
        self.flThirdLogInModel.userName = response.data[@"screen_name"] ;
        self.flThirdLogInModel.iconURL = response.data[@"profile_image_url"] ;
        self.flThirdLogInModel.flSource =  @"4" ;
    }];
    
}

- (void)logInWithThirdInSelfIsWeChat:(BOOL)xjIsWeChat {
//    self.flThirdLogInModel.flSource = [self flreturnLoginSourceWithString:self.flThirdLogInModel.platformName];
    if (!self.flThirdLogInModel.unionid && xjIsWeChat) {
        [[FLAppDelegate share] hideHUD];
        [[FLAppDelegate share] showHUDWithTitile:@"授权失败" view:self.view delay:1 offsetY:0];
        return;
    }
    NSDictionary* parm = @{@"perModel.unionid":xjIsWeChat ? self.flThirdLogInModel.unionid : self.flThirdLogInModel.usid,
                           @"perModel.nickname":self.flThirdLogInModel.userName ? self.flThirdLogInModel.userName :@"",
                           @"perModel.avatar":self.flThirdLogInModel.iconURL ? self.flThirdLogInModel.iconURL:@"",
                           @"perModel.sex":self.flThirdLogInModel.sex ? [NSNumber numberWithInteger:self.flThirdLogInModel.sex]:@"0", //0女 1男 2保密  没有数据
                           @"perModel.source":self.flThirdLogInModel.flSource ? self.flThirdLogInModel.flSource :@""};
    [FLNetTool flLogInWithThirdByParm:parm success:^(NSDictionary *dic) {
        FL_Log(@"username with qq is %@ ",dic);
        if ([dic[FL_NET_KEY_NEW] boolValue]) {
            [[FLAppDelegate share] showHUDWithTitile:@"授权成功" view:self.view delay:1 offsetY:0];
            [[XJUserAccountTool share] xj_save_isthirdLogin:self.flThirdLogInModel.flSource];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"sessionid"] forKey:FL_NET_SESSIONID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self xjRequestUserInfoWithToken:dic[@"sessionid"]];
            
            [[FLAppDelegate share] setUpTabBar];
        } else {
            [[FLAppDelegate share] showHUDWithTitile:@"授权失败" view:self.view delay:3 offsetY:0];
        }
        [[FLAppDelegate share] hideHUD];
    } failure:^(NSError *error) {
        [[FLAppDelegate share] hideHUD];
        if([FLTool returnStrWithErrorCode:error]){
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        }
    }];
}

- (void)flRenRenLogInSDK
{
    
}

- (FLMyThirdLogInModel *)flThirdLogInModel {
    if (!_flThirdLogInModel) {
        _flThirdLogInModel = [[FLMyThirdLogInModel alloc] init];
    }
    return _flThirdLogInModel;
}

//- (void)setUserDefaultsWithThirdLogInModel:(

- (NSString*)flreturnLoginSourceWithString:(NSString*)flstr
{
    NSString* str = nil;          // 1、PC  2、Android 3iOS、4、QQ  5、微信  6、新浪  7、人人 8、机器人
    if ([flstr isEqualToString:@"qq"]) {
        str = @"4";
    } else if ([flstr isEqualToString:@"sina"]) {
        str = @"6";
    } else if ([flstr isEqualToString:@"wxsession"]) {
        str = @"5";
    } else if ([flstr isEqualToString:@"renren"]) {
        str = @"7";
    }
    return str;
}

- (void)xjRequestUserInfoWithToken:(NSString*)xjToken {
    NSDictionary* parm  = @{@"token":xjToken,
                            @"accountType":@"per",
                            };
    FL_Log(@"see info 新 in mine :sesdddssionId = %@  parm = %@",xjToken,parm);
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result of login =%@",data);
        if (data) {
            NSString* xjStr = [NSString stringWithFormat:@"%@",data[@"userId"]];
            NSString* xjPhone=[NSString stringWithFormat:@"%@",data[@"phone"]];
            
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjStr key:FL_USERDEFAULTS_USERID_KEY];
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjPhone key:XJ_VERSION2_PHONE];
            [[XJUserAccountTool share] xj_saveUserAvatar:data[@"avatar"]];
            //友盟账号统计
            if ([XJFinalTool xjStringSafe:[[XJUserAccountTool share] xj_userdefault_thirdloginInfo]]) {
                NSString* xx = [[XJUserAccountTool share] xj_userdefault_thirdloginInfo];
                [MobClick profileSignInWithPUID:xjStr?xjStr:@"" provider:xx];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

@end



















