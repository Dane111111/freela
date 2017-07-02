//
//  FLAppDelegate.m
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/14.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//

#import "FLAppDelegate.h"
#import "FLNewFeatureViewController.h"
#import "FLWelcomeViewController.h"
#import "FLLogIn_RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "FLHeader.h"
#import <UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "FLSquareViewController.h"
#import "FLMineViewController.h"
#import "FLFreeCircleViewController.h"
#import "FLFuckHtmlViewController.h"
#import "JPUSHService.h"
#import "BBLaunchAdMonitor.h"
#import "XJPushMessageListViewController.h"
#import "FLMyIssueActivityControlViewController.h"
#import "FLMyReceiveControlViewController.h"
#import "XJBusinessMineViewController.h"
#import "XJSquareMainViewController.h"
#import "XJSquareMainVersionViewController.h"
//#import "UMMobClick/MobClick.h"
//#import "FLMyIssueControlDetailViewController.h"
//#import <JSPatch/JSPatch.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


#define xjzuobima_default  112214 //112019

@interface FLAppDelegate ()<UIScrollViewDelegate,MBProgressHUDDelegate,UITabBarDelegate,UITabBarControllerDelegate>
{
    //不知道什么用暂时
    HUDCancel _cancelBlock;
    MBProgressHUD* _hud;
    
    
    //关于用户的用户名密码
    NSUserDefaults  * userDefaults;
    
    UINavigationController*        NaviSquare;
    UINavigationController*        NaviFreeCircle;
    NSInteger secondsCountDown;//倒计时
    UILabel*    _xjCountDown;//label
    NSTimer* countDownTimer;
    NSString* _xjJumpURL;//广告页跳转的url
    NSInteger xj_selectedId;//广告页跳转的id
    
    NSInteger _zuobiid;//作弊需要的 参数
    
}
@property (nonatomic , strong)UIView*  lunchView;
@property (nonatomic) BOOL isLaunchedByNotification;


@property (nonatomic, strong) FLSquareViewController*        flSquareVC;
@property (nonatomic, strong) FLFreeCircleViewController*    flFreeCircleVC;
@property (nonatomic, strong) FLMineViewController*          flMineVC;
@property (nonatomic, strong) XJBusinessMineViewController*  flBusinessMineVC;
//@property (nonatomic, strong) XJSquareMainViewController*    xjSquareMainVC;
@property (nonatomic , strong)  XJSquareMainVersionViewController *    xjSquareMainVC;

@property (strong, nonatomic) UIView *ADView;
@end


@implementation FLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self logUser];
 
    [self registerSomthingInDelegate];
    
    _zuobiid = xjzuobima_default;
//     [self freelazb];
    //[self xj_insert_pl];
    
    //jspatch
//    [JSPatch startWithAppKey:@"b386991eb9724e40"];
#ifdef DEBUG
//    [JSPatch setupDevelopment];
#endif
//    [JSPatch sync];
    //     [JSPatch testScriptInBundle];
    
    //层级
    //    self.window.windowLevel = UIWindowLevelAlert;
    //    FLLogIn_RegisterViewController * vvvc = [[FLLogIn_RegisterViewController alloc]init];
    //    self.window.rootViewController = vvvc;
    //    application.applicationIconBadgeNumber = 0;//图标角标，需注册w
    
    
    //判断是不是第一次进入APPƒ√
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    //清空角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    

    //设置 一个屌东西
    
#warning  这儿以后 选择 根控制器
    //   // for test
    
    //    FLLogIn_RegisterViewController * vvvc = [[FLLogIn_RegisterViewController alloc]init];
    //    self.window.rootViewController = vvvc;
    //    [self.window makeKeyAndVisible];
#warning ddvote
    //    self.naviController = [FLChooseController chooseNaviController];
    //    self.window.rootViewController = self.naviController;
    //    [self.window makeKeyAndVisible];
    
    //配置tabbar
    //    [self setUpTabBar];
    /*
     FLSquareViewController*        FLSquareVC     = [[FLSquareViewController alloc]initWithNibName:@"FLSquareViewController" bundle:nil];
     FLFreeCircleViewController*    FLFreeCircleVC = [[FLFreeCircleViewController alloc]initWithNibName:@"FLFreeCircleViewController" bundle:nil];
     FLMineViewController*          FLMineVC       = [[FLMineViewController alloc]initWithNibName:@"FLMineViewController" bundle:nil];
     UITabBarController*            tabBar         = [[UITabBarController alloc]init];
     UINavigationController*        NaviSquare     = [[UINavigationController alloc]initWithRootViewController:FLSquareVC];
     UINavigationController*        NaviMine       = [[UINavigationController alloc]initWithRootViewController:FLMineVC];
     UINavigationController*        NaviFreeCircle = [[UINavigationController alloc]initWithRootViewController:FLFreeCircleVC];
     tabBar.viewControllers                        = @[NaviSquare,NaviFreeCircle,NaviMine];
     //    FLAppDelegate*                 app            = [UIApplication sharedApplication].delegate;
     self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
     tabBar.tabBar.tintColor = [UIColor orangeColor];//文字颜色
     self.window.rootViewController = tabBar;
     [self.window makeKeyAndVisible];
     */
    /*
     关于在启动页动态加载图片的问题
     self.lunchView = [[NSBundle mainBundle]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
     self.lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
     [self.window addSubview:self.lunchView];
     
     UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 300)];
     NSString *str = @"http://www.jerehedu.com/images/temp/logo.gif"
     ;
     [imageV sd_setImageWithURL:[NSURL URLWithString:str]
     placeholderImage:[UIImage imageNamed:@"default1.jpg"
     ]];
     [self.lunchView addSubview:imageV];
     [self.window bringSubviewToFront:self.lunchView];
     [NSTimer  scheduledTimerWithTimeInterval:3
     target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
     */
    
    //关于SMS_SDK
    [SMSSDK registerApp:FL_SMS_APPKEY withSecret:FL_SMS_SECRET];
    //配置环信推送
    [self xjSetHXPushWithlaunchOptions:launchOptions application:application];
    
    //配置极光推送
    [JPUSHService setupWithOption:launchOptions appKey:XJ_JG_PUSH_KEY channel:@"App Store" apsForProduction:NO];
    
    
    //设置全局导航栏颜色
    UINavigationBar* navi  = [UINavigationBar appearance];
    UIColor * titleColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [navi setTitleTextAttributes:dict];
    navi.tintColor = titleColor;
    
    
    //获取推送信息
    NSDictionary* xjDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (xjDic) {
        self.isLaunchedByNotification = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"THISISTHETESTPUSH" object:xjDic];
        //        FLLogIn_RegisterViewController * vvvc = [[FLLogIn_RegisterViewController alloc]init];
        //        self.window.rootViewController = vvvc;
    } else {
        self.isLaunchedByNotification = NO;
    }
    
    //根目录
    //在documents创建一个默认头像防止 AF请求时cash(body)
    NSString* path = NSHomeDirectory();
    NSLog(@"此APP的 根目录为------- %@",path);
    NSString *docPath = [path stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"selfPhoto.jpg"];
    UIImage* image = [UIImage imageNamed:@"logo_freela"];
    //    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    //    环信
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"hibang#demo" apnsCertName:@"XJPush"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //    环信UI
    [[EaseSDKHelper shareHelper] easemobApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:@"hibang#demo"
                                       apnsCertName:@"XJPush"
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    //环信登陆
    NSString *userName = [NSString stringWithFormat:@"%@_%@",XJ_USERTYPE_WITHTYPE,XJ_USERID_WITHTYPE];
    NSLog(@"cyuserid %@",userName);
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:@"123456" completion:^
     (NSDictionary *loginInfo, EMError *error) {
         if (!error && loginInfo) {
             FL_Log(@"登录成功Wit12h环信");
         }
     } onQueue:nil];
    // 设置自动登录
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
    [self saveLastLoginUsername]; // 保存一下，以后会用得到
    //    [FLTool xjLogInHuanXin];
    
    //启动广告
//    [FLNetTool xjgetRcommendTopicImageByCommentId:nil success:^(NSDictionary *data) {
//        FL_Log(@"this is the data of the image of guanggao per =[%@]",data);
//        if ([data[@"total"] integerValue]==0) {
//            [self xjGoToPage];
//        }
//        if ([data[FL_NET_KEY_NEW] boolValue] && [data[@"total"] integerValue]!=0) {
//            NSString* xjStr = [NSString stringWithFormat:@"%@",data[FL_NET_DATA_KEY][0][@"filePath2"]];
//            NSString* xjUrlStr = [NSString stringWithFormat:@"%@",data[FL_NET_DATA_KEY][0][@"url"]];
//            if (![FLTool returnBoolWithIsHasHTTP:xjStr includeStr:@"http://"] && xjStr) {
//                xjStr = [FLBaseUrl stringByAppendingString:xjStr];
//            }
//            [self xjGoToPage];
//            [self xjStartAdvertisementWithImageStr:xjStr urlStr:xjUrlStr];
//        }
//    } failure:^(NSError *error) {
//        [self xjGoToPage];
//    }];
    //    [self xjGoToPage];
    
 
    
    
    
    [self xjGoToPage];
    
    return YES;
}
-(void)removeADView
{
    [self.ADView removeFromSuperview];
}

#pragma  mark -----------  进入界面啊
- (void)xjGoToPage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.window makeKeyAndVisible];
    });
    //判断
    //版本号是不是新版本
    //当前保存的版本号
    NSString* xj_version = [[NSUserDefaults standardUserDefaults] objectForKey:XJ_VERSION_NUMBER];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        FLWelcomeViewController* welcomeVC = [[FLWelcomeViewController alloc]init];
        self.window.rootViewController = welcomeVC  ;
    }  else{
        NSLog(@"welcome");
        NSString* xjPhone = XJ_USER_VALUE_PHONE;
        NSString* xjPwd   = XJ_USER_VALUE_PWD;
        NSString* userId  = [[NSUserDefaults standardUserDefaults] objectForKey:FL_USERDEFAULTS_USERID_KEY];
        if (xjPhone && xjPwd && ![xjPwd isEqualToString:@""] && ![xjPhone isEqualToString:@""]) {
            //如果 用户名密码存在，进入主界面 登陆环信
            [self setUpTabBar];
        } else if ([XJFinalTool xjStringSafe:userId]){
            [self setUpTabBar];
        } else {
            FLLogIn_RegisterViewController * vvvc = [[FLLogIn_RegisterViewController alloc]init];
            self.window.rootViewController = vvvc;
        }
    }
//    self.ADView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
//    self.ADView = [[UIView alloc] init];
//    self.ADView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
//    [self.window addSubview:self.ADView];
//    [self.window bringSubviewToFront:self.ADView];
//    [self xjRequestImageOfStart];
}

- (void)xjRequestImageOfStart {
    [FLNetTool xjgetRcommendTopicImageByCommentId:nil success:^(NSDictionary *data) {
        FL_Log(@"this is the data of the image of guanggao per =[%@]",data);
        if ([data[@"total"] integerValue]==0) {
            [self removeADView];
        }
        if ([data[FL_NET_KEY_NEW] boolValue] && [data[@"total"] integerValue]!=0) {
            NSString* xjStr = [NSString stringWithFormat:@"%@",data[FL_NET_DATA_KEY][0][@"filePath2"]];
            _xjJumpURL = [NSString stringWithFormat:@"%@",data[FL_NET_DATA_KEY][0][@"url"]];
            [self xjAddGGYPageWithImageurl:[XJFinalTool xjReturnImageURLWithStr:xjStr isSite:NO] parm:_xjJumpURL];
        }
        NSArray* xxxxx = data[FL_NET_DATA_KEY];
        if ([xxxxx count]>=1) {
            xj_selectedId = [xxxxx[0][@"id"] integerValue];
            [self xj_getPvNumberIndex:xj_selectedId];//增加一个pv
        }
    } failure:^(NSError *error) {
        [self removeADView];
    }];
}
#pragma  mark ----------------------------  增加PV  &  增加点击
- (void)xj_getPvNumberIndex:(NSInteger)index {
    NSDictionary* parma = @{@"advertId":@(index)};
    [FLNetTool xj_updatePvWithparma:parma success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)xj_testTwoIndex{
  
    NSDictionary* parma = @{@"advertId":@(xj_selectedId)};
    [FLNetTool xj_updateLinkNumWithparma:parma success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjAddGGYPageWithImageurl:(NSString*)xjImageUrl parm:(NSString*)xjParmUrl {

    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
    NSString *str = xjImageUrl;
    [imageV sd_setImageWithURL:[NSURL URLWithString:str]];// placeholderImage:[UIImage imageNamed:@"LaunchImage"]
    [self.ADView addSubview:imageV];
   _xjCountDown = [[UILabel alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width-80, 20, 10, 20)];
    _xjCountDown.textColor = [UIColor whiteColor];
    [self.ADView addSubview:_xjCountDown];
    UIButton* xjJumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ADView addSubview:xjJumpBtn];
    xjJumpBtn.frame = CGRectMake(FLUISCREENBOUNDS.width-70, 20, 50, 20);
    [xjJumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [xjJumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    xjJumpBtn.layer.cornerRadius = 10;
    xjJumpBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    xjJumpBtn.layer.borderWidth = .5f;
    xjJumpBtn.layer.masksToBounds = YES;
    [xjJumpBtn addTarget:self action:@selector(removeADView) forControlEvents:UIControlEventTouchUpInside];
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethodƒcopy
    //设置倒计时显示的时间
    secondsCountDown = 3;
    _xjCountDown.text=[NSString stringWithFormat:@"%ld",secondsCountDown];
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeADView) userInfo:nil repeats:NO];
    UIButton* xiBtnAll = [UIButton buttonWithType:UIButtonTypeCustom];
    xiBtnAll.frame = CGRectMake(0, 50, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height-20);
    [self.ADView addSubview:xiBtnAll];
    [xiBtnAll addTarget:self action:@selector(xjClickToPushStarfari) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)xjClickToPushStarfari {
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_xjJumpURL]]){
        [self removeADView];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_xjJumpURL]];
    }
}
-(void)timeFireMethod{
    //倒计时-1
    secondsCountDown--;
    _xjCountDown.text=[NSString stringWithFormat:@"%ld",(long)secondsCountDown];
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        [self removeADView];
    }
}

- (void)showAdDetail:(NSNotification *)noti
{
    NSLog(@"detail parameters:%@", noti.object);
    NSString* xjTopicID = noti.object[@"url"];
    if (xjTopicID.length !=0 && ![xjTopicID isEqualToString:@""]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:xjTopicID]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:xjTopicID]];
        }
    }
}

- (void)xjStartAdvertisementWithImageStr:(NSString*)xjImageStr urlStr:(NSString*)xjUrlStr {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdDetail:) name:BBLaunchAdDetailDisplayNotification object:nil];
    NSString *paths = xjImageStr;
    [BBLaunchAdMonitor showAdAtPath:paths
                             onView:self.window.rootViewController.view
                       timeInterval:3.
                   detailParameters:@{@"topicId":@(1),
                                      @"name":@"奥迪-品质生活",
                                      @"url":xjUrlStr}];
    
}

//3DTouch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    //判断先前我们设置的唯一标识
    if([shortcutItem.type isEqualToString:@"com.hibang.FreeLa.my3DTouchTest"]){
        NSArray *arr = @[@"hello 3D Touch"];
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        //设置当前的VC 为rootVC
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
        }];
    }
}

- (FLSquareViewController *)flSquareVC {
    if (!_flSquareVC) {
        _flSquareVC = [[FLSquareViewController alloc]initWithNibName:@"FLSquareViewController" bundle:nil];
    }
    return _flSquareVC;
}
- (FLFreeCircleViewController *)flFreeCircleVC {
    if (!_flFreeCircleVC) {
        _flFreeCircleVC = [[FLFreeCircleViewController alloc]init];
    }
    return _flFreeCircleVC;
}
- (FLMineViewController *)flMineVC {
    if (!_flMineVC) {
        _flMineVC = [[FLMineViewController alloc]initWithNibName:@"FLMineViewController" bundle:nil];
    }
    return _flMineVC;
}
- (XJBusinessMineViewController *)flBusinessMineVC {
    if (!_flBusinessMineVC) {
        _flBusinessMineVC = [[ XJBusinessMineViewController alloc]init];
    }
    return _flBusinessMineVC;
}

- (XJSquareMainVersionViewController *)xjSquareMainVC {
    if (!_xjSquareMainVC) {
        _xjSquareMainVC = [[XJSquareMainVersionViewController alloc] init];
        //        _xjSquareMainVC.view.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
        _xjSquareMainVC.title=@"发现";
        _xjSquareMainVC.tabBarItem.image=[UIImage imageNamed:@"tabbar_item_discover"];
    }
    return _xjSquareMainVC;
}

- (UITabBarController *)xjTabBar {
    if (!_xjTabBar) {
        _xjTabBar = [[UITabBarController alloc]init];
    }
    return _xjTabBar;
}

- (void)setUpTabBar
{
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        FLSquareViewController*        FLSquareVC     = [[FLSquareViewController alloc]initWithNibName:@"FLSquareViewController" bundle:nil];
    //        FLFreeCircleViewController*    FLFreeCircleVC = [[FLFreeCircleViewController alloc]init];
    self.flFreeCircleVC.tabBarItem.image=[UIImage imageNamed:@"tabbar_item_freecircle"];
    self.flFreeCircleVC.title=@"免费圈";
    
    //        FLMineViewController*          FLMineVC       = [[FLMineViewController alloc]initWithNibName:@"FLMineViewController" bundle:nil];
    self.xjTabBar         = [[UITabBarController alloc]init];
    NaviSquare     = [[UINavigationController alloc]initWithRootViewController:self.xjSquareMainVC];
    //    UINavigationController*        NaviSquare     = [[UINavigationController alloc]initWithRootViewController:self.flSquareVC];
    UINavigationController*        NaviMine       = [[UINavigationController alloc]initWithRootViewController:self.flMineVC];
    NaviFreeCircle = [[UINavigationController alloc]initWithRootViewController:self.flFreeCircleVC];
    UINavigationController*        NaviBusMine    = [[UINavigationController alloc]initWithRootViewController:self.flBusinessMineVC];
    if (FLFLIsPersonalAccountType) {
        self.xjTabBar.viewControllers                        = @[NaviSquare,NaviFreeCircle,NaviMine];
    } else {
        self.xjTabBar.viewControllers                        = @[NaviSquare,NaviFreeCircle,NaviBusMine];
    }
    //    FLAppDelegate*                 app            = [UIApplication sharedApplication].delegate;
    self.xjTabBar.tabBar.tintColor = [UIColor colorWithHexString:@"#ff5555"];//文字颜色
    self.xjTabBar.delegate = self;
    //    });
    self.window.rootViewController = self.xjTabBar;
    [self.window makeKeyAndVisible];
}

//- (void)setUpTabBar
//{
//    FLSquareViewController*        FLSquareVC     = [[FLSquareViewController alloc]initWithNibName:@"FLSquareViewController" bundle:nil];
//    FLFreeCircleViewController*    FLFreeCircleVC = [[FLFreeCircleViewController alloc]initWithNibName:@"FLFreeCircleViewController" bundle:nil];
////    FLMineViewController*          FLMineVC       = [[FLMineViewController alloc]initWithNibName:@"FLMineViewController" bundle:nil];
//    UITabBarController*            tabBar         = [[UITabBarController alloc]init];
//    FLMineTableViewController* FLMineVC = [[FLMineTableViewController alloc] initWithNibName:@"FLMineTableViewController" bundle:nil];
//    tabBar.viewControllers                        = @[FLSquareVC,FLFreeCircleVC,FLMineVC];
//    //    FLAppDelegate*                 app            = [UIApplication sharedApplication].delegate;
//    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
//    tabBar.tabBar.tintColor = [UIColor orangeColor];//文字颜色
//    self.window.rootViewController = tabBar;
//    [self.window makeKeyAndVisible];
//}

#pragma mark ---------initSomething

/*
 -(void)removeLun
 {     [self.lunchView
 removeFromSuperview];
 }
 */

//禁止横屏
- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return  UIInterfaceOrientationMaskPortrait;
}


// 接收到内存警告的时候调用
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"内存问题出现了内存问题出现了内存问题出现了内存问题出现了内存问题出现了内存问题出现了");
    // 停止所有的下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 删除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

// 失去焦点
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"silence.mp3" withExtension:nil];
    //    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //    [player prepareToPlay];
    //    // 无限播放
    //    player.numberOfLoops = -1;
    //
    //    [player play];
    //
    //    _player = player;
    
    
}

// 程序进入后台的时候调用
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // 开启一个后台任务,时间不确定，优先级比较低，假如系统要关闭应用，首先就考虑
    //    UIBackgroundTaskIdentifier ID = [application beginBackgroundTaskWithExpirationHandler:^{
    //
    //        // 当后台任务结束的时候调用
    //        [application endBackgroundTask:ID];
    //
    //    }];
    
    // 如何提高后台任务的优先级，欺骗苹果，我们是后台播放程序
    
    // 但是苹果会检测你的程序当时有没有播放音乐，如果没有，有可能就干掉你
    
    // 微博：在程序即将失去焦点的时候播放静音音乐.
    
}


#pragma mark ----------------------------------
+ (FLAppDelegate*)share
{
    return (FLAppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)showHUDWithTitile:(NSString *)title{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (!_hud) {
            _hud = [[MBProgressHUD alloc] initWithWindow:_window];
            
            [self.window addSubview:_hud];
            [self.window bringSubviewToFront:_hud];
        }
        _hud.labelText = title;
        //        _hud.showCloseButton = NO;
        [_hud show:YES];
    }];
}

- (void)showHUDWithTitile:(NSString *)title withCancel:(void(^)())cancelBlock{
    
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithWindow:_window];
        //        [_hud.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:_hud];
    }
    _cancelBlock   = [cancelBlock copy];
    _hud.labelText = title;
    //    _hud.showCloseButton = YES;
    [_hud show:YES];
}

- (void)setHUDTitle:(NSString *)titile {
    
    
    _hud.labelText = titile;
    
}

- (void)hideHUD{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_hud hide:YES];
        _hud = nil;
    }];
}
- (void)hideHUD:(CGFloat)afterDelay{
    [_hud hide:YES afterDelay:afterDelay];
}

- (void)showHUDWithTitile:(NSString *)title view:(UIView*)view delay:(CGFloat)delay offsetY:(CGFloat)offsetY
{
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //     CGFloat xjH = [FLTool xjReturnCellHWithWidth:FLUISCREENBOUNDS.width*0.8 text:title fontSize:XJ_LABEL_SIZE_NORMAL];
    _hud.mode = MBProgressHUDModeText;
    
    //    _hud.labelText  = title;
    _hud.detailsLabelText = title;
    _hud.detailsLabelFont = [UIFont fontWithName:FL_FONT_NAME size:14];
    _hud.margin = 10.0f;
    //    _hud.yOffset = -30.0f;
    //    _hud.yOffset=offsetY;
    _hud.removeFromSuperViewOnHide = YES;
    [_hud hide:YES afterDelay:delay];
}

- (void)showSimplleHUDWithTitle:(NSString*)title view:(UIView*)view
{
    //使用 多张图片 播放
    //    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 100 ,100)];
    //    animatedImageView.animationImages =@[[UIImage imageNamed:@"loadimage0"],
    //                                         [UIImage imageNamed:@"loadimage1"],
    //                                         [UIImage imageNamed:@"loadimage2"],
    //                                         ];
    //
    //    animatedImageView.animationDuration = 0.1f;
    //    animatedImageView.animationRepeatCount = 0;
    //    [animatedImageView startAnimating];
    
    //    使用gif
    UIImage  *image=[UIImage sd_animatedGIFNamed:@"loading_redbird"];
    UIImageView  *animatedImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
    animatedImageView.image=image;
    animatedImageView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0];
    
    _hud = [MBProgressHUD showHUDAddedTo:view ? view : FL_KEYWINDOW_VIEW_NEW animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.removeFromSuperViewOnHide = YES;
    _hud.labelText = title;
    _hud.color = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    _hud.customView=animatedImageView;
}

- (void)showdimBackHUDWithTitle:(NSString*)title view:(UIView*)view
{
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.dimBackground = YES;
    _hud.delegate = self;
    _hud.removeFromSuperViewOnHide = YES;
    // Show the HUD while the provided method executes in a new thread
    //    [_hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
}

- (void)showHUDWithTitile:(NSString *)title delay:(CGFloat)delay offsetY:(CGFloat)offsØflØetY
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (!_hud) {
            _hud = [[MBProgressHUD alloc] initWithWindow:_window];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText  = title;
            _hud.margin = 10.0f;
            [self.window addSubview:_hud];
            //            [self.window bringSubviewToFront:_hud];
        }
        _hud.labelText = title;
        //        _hud.showCloseButton = NO;
        [_hud show:YES];
        //        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:delay];
    }];
    //    _hud.yOffset=offsetY;
}

- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
//    [CrashlyticsKit setUserIdentifier:XJ_APP_BUNDLE_ID];
//    [CrashlyticsKit setUserEmail:@"121314202@qq.com"];
//    [CrashlyticsKit setUserName:@"Jiayeye"];
}

#pragma mark  ------ ShareSDK
- (void)registerSomthingInDelegate
{
    //友盟
    [UMSocialData setAppKey:FL_YOUMENG_APPKEY];
    //wechat
    [UMSocialWechatHandler setWXAppId:@"wx7ce4c150e2484834" appSecret:@"dc5e09f616b1bfe30ff90b9ca1a536bb" url:FLBaseUrl];
    //微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2911847418" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //qq
    [UMSocialQQHandler setQQWithAppId:@"1104722431" appKey:@"MWEy8vIDieHy9r2Y" url:FLBaseUrl];
    //友盟统计
    UMConfigInstance.appKey = FL_YOUMENG_APPKEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

#pragma mark ---- ShareDelegate
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他sdk
        FL_Log(@"什么呀什么鬼");
    }
    
    NSString* xjStr = [NSString stringWithFormat:@"%@",FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID];
    if (!xjStr || [xjStr isEqualToString:@"(null)"]) {
        return NO;
    }
    NSString* xjstr = [url absoluteString];
    //    NSString* xjstr  = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if ([xjstr rangeOfString:@"freela"].location!= NSNotFound && xjstr) {
        NSString* xjStr1 = [[url path] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* xjStr7 = [[url relativePath] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* xjStr8 = [xjStr7 substringFromIndex:1];
        NSMutableString *responseString = [NSMutableString stringWithString:xjStr8];
        NSString *character = nil;
        for (int i = 0; i < responseString.length; i ++) {
            character = [responseString substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"'"])
                [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
        NSInteger xxx = [responseString integerValue];
        NSLog(@"==湿哒哒 撒旦 =%ld",xxx);
        //        [self setUpTabBar];
//        [NSThread sleepForTimeInterval:5];
        FLFuckHtmlViewController* xjHTML = [[FLFuckHtmlViewController alloc] init];
        xjHTML.flFuckTopicId = responseString;
        //    [self.window.rootViewController.tabBarController.navigationController pushViewController:xjHTML animated:YES];
        
        [(UINavigationController *)self.window.rootViewController.navigationController pushViewController:xjHTML animated:YES];
        UITabBarController* xjtab = self.window.rootViewController;
        NSArray* xjarr = xjtab.viewControllers;
        UINavigationController* xjNavi = [xjarr firstObject];
        [xjNavi pushViewController:xjHTML animated:YES];
    }
    
    return result;
}

- (void)xjSetHXPushWithlaunchOptions:(NSDictionary*)launchOptions  application:(UIApplication*)application{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
//        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        
        
    } else {
        //categories    nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken]; //传给 环信
    [JPUSHService registerDeviceToken:deviceToken];                                                                 //传给  极光
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"error -- %@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //iOS 8 or later
    if (application.applicationState == UIApplicationStateActive) {
        FL_Log(@"这里是状态1");
    } else if (application.applicationState == UIApplicationStateInactive) {
        FL_Log(@"这里是状态2");
    } else if (application.applicationState == UIApplicationStateBackground) {
        FL_Log(@"这里是状态3");
    }
    
    NSLog(@"\napns -> didReceiveRemoteNotification,Receive Data:\n%@", userInfo);
    //    //把icon上的标记数字设置为0,
    //    application.applicationIconBadgeNumber = 0;
    //    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
    //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"**推送消息**"
    //                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
    //                                                       delegate:self
    //                                              cancelButtonTitle:@"关闭"
    //                                              otherButtonTitles:@"处理推送内容",nil];
    ////        alert.tag = alert_tag_push;
    //        [alert show];
    //    }
    [JPUSHService handleRemoteNotification:userInfo];
    if (self.isLaunchedByNotification) {
        if (userInfo[@"topicId"]) {
            [self xjPushToHTMLPageWithTopicId:userInfo[@"topicId"]];
        } else if (userInfo[@"msgid"]) {
            [self xjPushOtherPageWithStr:userInfo[@"msgid"] passKey:nil];
        }
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"THISISTHETESTPUSH" object:userInfo];
    } else {
        NSString* xjStr = userInfo[@"msgid"];
        [JPUSHService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:100]
                                 alertBody:@"alert content"
                                     badge:1
                               alertAction:@"buttonText"
                             identifierKey:@"identifierKey"
                                  userInfo:nil
                                 soundName:nil];
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    NSString* xjMsgId = userInfo[@"msgid"];
    NSString* xjTopicId = userInfo[@"topicId"];
    NSString* xjAps    =  userInfo[@"aps"];
    if (self.window.rootViewController!=self.xjTabBar) {
//        self.window.rootViewController=self.xjTabBar;
    }
    if (application.applicationState == UIApplicationStateActive) {
        [self xjGetPushMessageWhenStateActiveWithKey:xjMsgId];
    } else if (application.applicationState == UIApplicationStateInactive) {
        if (xjMsgId) {
            if ([xjMsgId isEqualToString:XJPushMessageByReJudge]) {
                [self xjPushToRejudgeListInHTMLWithUserInfo:userInfo];
            } else {
                
                [self xjBackGroundStatePushWithKey:xjMsgId andTopicId:xjTopicId];
            }
        } else if ([XJFinalTool xjStringSafe:xjAps]){
            
            self.xjTabBar.selectedIndex = 1;
        }
    } else if (application.applicationState == UIApplicationStateBackground) {
        FL_Log(@"死的");
        if (xjMsgId) {
            if ([xjMsgId isEqualToString:XJPushMessageByReJudge]) {
                [self xjPushToRejudgeListInHTMLWithUserInfo:userInfo];
            } else{
                [self xjBackGroundStatePushWithKey:xjMsgId andTopicId:xjTopicId];
            }
        }
    }
    
    NSLog(@"\napns -> didReceiveRemoteNotification,Receive Data:\n%@", userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    if (self.isLaunchedByNotification) {
        if (userInfo[@"topicId"]) {
            //           [self xjPushToHTMLPageWithTopicId:userInfo[@"topicId"]];
        } else if (userInfo[@"msgid"]) {
            //            [self xjPushOtherPageWithStr:userInfo[@"msgid"] passKey:nil];
        }
        
        //    [self.window.rootViewController.tabBarController.navigationController pushViewController:xjHTML animated:YES];
        
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"THISISTHETESTPUSH" object:userInfo];
    } else {
        NSString* xjStr = userInfo[@"msgid"];
        //        [JPUSHService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:1]
        //                                 alertBody:@"alert content"
        //                                     badge:1
        //                               alertAction:@"buttonText"
        //                             identifierKey:@"identifierKey"
        //                                  userInfo:nil
        //                                 soundName:nil];
    }
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}
//跳转到html 界面
- (void)xjPushToHTMLPageWithTopicId:(NSString*)xjId {
    FLFuckHtmlViewController* xjHTML = [[FLFuckHtmlViewController alloc] init];
    xjHTML.flFuckTopicId = xjId;
    [(UINavigationController *)self.window.rootViewController.navigationController pushViewController:xjHTML animated:YES];
    //    self.xjTabBar = self.window.rootViewController;
    NSArray* xjarr = self.xjTabBar.viewControllers;
    UINavigationController* xjNavi = [xjarr firstObject];
    [xjNavi pushViewController:xjHTML animated:YES];
}

- (void)xjPushOtherPageWithStr:(NSString*)xjStr passKey:(id)xjPassKey{
    if ([xjStr isEqualToString:XJPushMessageBySystem]) { //系统消息
        
    } else if ([xjStr isEqualToString:XJPushMessageByJudge]) { //评论消息
        FLFuckHtmlViewController* xjHTML = [[FLFuckHtmlViewController alloc] init];
        xjHTML.xjGoWhere = @"1";   //1 为助力抢   2为评轮
        xjHTML.flFuckTopicId = xjPassKey;
        xjHTML.xjIsPushIn = YES;
        [(UINavigationController *)self.window.rootViewController.navigationController pushViewController:xjHTML animated:YES];
        //        UITabBarController* xjtab = self.window.rootViewController;
        self.xjTabBar.selectedIndex = 0;
        NSArray* xjarr = self.xjTabBar.viewControllers;
        UINavigationController* xjNavi = [xjarr firstObject];
        [xjNavi pushViewController:xjHTML animated:YES];
    } else if ([xjStr isEqualToString:XJPushMessageByDueReming]) { //到期提醒
        
    } else if ([xjStr isEqualToString:XJPushMessageByCanPickUp]) { //达到领取资格提醒消息
        
    } else if ([xjStr isEqualToString:XJPushMessageByAlreadyPick]) {//领取消息
        FLMyIssueActivityControlViewController* xjHTML = [[FLMyIssueActivityControlViewController alloc] init];
        xjHTML.xjSelectedIndex  = 1;
        xjHTML.xjTopicId = xjPassKey ? xjPassKey :@"";
        [(UINavigationController *)self.window.rootViewController.navigationController pushViewController:xjHTML animated:YES];
        //        UITabBarController* xjtab = self.window.rootViewController;
        self.xjTabBar.selectedIndex = 2;
        NSArray* xjarr = self.xjTabBar.viewControllers;
        UINavigationController* xjNavi = [xjarr lastObject];
        [xjNavi pushViewController:xjHTML animated:YES];
    } else if ([xjStr isEqualToString:XJPushMessageByCertify]) {//审批认证消息
        
    } else if ([xjStr isEqualToString:XJPushMessageByAutorize]) {//授权消息
        
    } else if ([xjStr isEqualToString:XJPushMessageByBusPush]) { //商家推送消息
        
    }
}

- (void)xjPush {
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:@"identifierKey"];
    FL_Log(@"this is terh dasdsagfhdslg=[%ld]",notification.applicationIconBadgeNumber);
    application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber-1;
}

#pragma mark net request
- (void)xjGetPushMessageWhenStateActiveWithKey:(NSString*)xjKey {
    FL_Log(@"这里是状态 前台 == %@",xjKey);
    if ([xjKey isEqualToString:XJPushMessageBySystem] || [xjKey isEqualToString:XJPushMessageByCertify] || [xjKey isEqualToString:XJPushMessageByAutorize] || [xjKey isEqualToString:XJPushMessageByBusPush]) {
        [self getInfoWithPushString:@"1,6,7,8" index:2];
    }
}
#pragma mark --------- - 这里是推送消息主要推送的位置 不包含APP 在前台的状态
- (void)xjBackGroundStatePushWithKey:(NSString*)xjKey andTopicId:(NSString*)xjTopicId{
    FL_Log(@"这里是状态 后台");
    if ([xjKey isEqualToString:XJPushMessageBySystem] || [xjKey isEqualToString:XJPushMessageByCertify] || [xjKey isEqualToString:XJPushMessageByAutorize] || [xjKey isEqualToString:XJPushMessageByBusPush]) {
        XJPushMessageListViewController* xjHTML = [[XJPushMessageListViewController alloc] init];
        [(UINavigationController *)self.window.rootViewController.navigationController pushViewController:xjHTML animated:YES];
        self.xjTabBar.selectedIndex = 2;
        NSArray* xjarr = self.xjTabBar.viewControllers;
        UINavigationController* xjNavi = [xjarr lastObject];
        [xjNavi pushViewController:xjHTML animated:YES];
    } else if ([xjKey isEqualToString:XJPushMessageByAlreadyPick]) {
        FL_Log(@"这里是领取消息");
        [self xjPushMyPublishWithIndex:1 topicId:xjTopicId];
    } else if ([xjKey isEqualToString:XJPushMessageByJudgePJ]) {
        FL_Log(@"这里是评价消息");
        [self xjPushMyPublishWithIndex:3 topicId:xjTopicId];
    } else if ([xjKey isEqualToString:XJPushMessageByDueReming]) {
        FL_Log(@"这里是到期提醒");
        if ([xjTopicId rangeOfString:@"_"].location != NSNotFound) {
            NSInteger xjInt = [xjTopicId rangeOfString:@"_"].location;
            NSString* xjTopicIdStr = [xjTopicId substringToIndex:xjInt];
            NSString* xjTopicTypeStr = [NSString stringWithFormat:@"%@",[xjTopicId substringFromIndex:xjInt + 1]];
            if ([xjTopicTypeStr isEqualToString:@"1"]) { //活动快结束发给商家
                [self xjPushMyPublishWithIndex:0 topicId:xjTopicIdStr];
            } else if ([xjTopicTypeStr isEqualToString:@"2"]) { //参与没有领取
                [self xjPushMyPartInWithIndex:1 topicId:xjTopicIdStr];
            }  else if ([xjTopicTypeStr rangeOfString:@"3_"].location != NSNotFound) { //领取未使用
                if ([xjTopicTypeStr rangeOfString:@"_"].location != NSNotFound) {
                    NSInteger xjDeatilsInt = [xjTopicTypeStr rangeOfString:@"_"].location;
                    NSString *xjDetails = [NSString stringWithFormat:@"%@",[xjTopicTypeStr substringFromIndex:xjDeatilsInt + 1]];
                    [self xjPushMyPickUpWithIndex:1 topicId:xjTopicIdStr detailsId:xjDetails];
                }
            }
            
        }
    } else if ([xjKey isEqualToString:XJPushMessageByReJudge]) { //回复评论消息
        FL_Log(@"这里是回复评论消息");
        [self xjPushHTMLPageWithTopicId:xjTopicId state:@"2"];
    } else if ([xjKey isEqualToString:XJPushMessageByHelpMessage]) { //助力消息
        FL_Log(@"这里是助力消息");
        [self xjPushHTMLPageWithTopicId:xjTopicId state:@"1"];
    } else if ([xjKey isEqualToString:XJPushMessageByCanPickUp]) { //到达领取资格提醒
        FL_Log(@"到达领取资格提醒消息");
        [self xjPushHTMLPageWithTopicId:xjTopicId state:@"0"]; //哪儿都不跳
    }
    [NSThread sleepForTimeInterval:3.0f];
}
- (void)xjPushToRejudgeListInHTMLWithUserInfo:(NSDictionary*)xjUserInfo{
    NSString* xjCommentID = xjUserInfo[@"commentId"];
    if (!xjCommentID) return;
    NSDictionary* parm = @{@"comment.commentId":xjCommentID};
    [FLNetTool xjgetPersonInfoForJPushByCommentId:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the data of the pingluner info=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSDictionary* xjDicToUse = data[FL_NET_DATA_KEY];
            FLFuckHtmlViewController* xjHTML = [[FLFuckHtmlViewController alloc] init];
            xjHTML.xjGoWhere = @"2";   //1 为助力抢   2为回复评论消息
            xjHTML.flFuckTopicId = xjUserInfo[@"topicId"];
            xjHTML.xjIsPushIn = YES;
            xjHTML.xjGoToRejudgeListArr = @[xjDicToUse];
            [(UINavigationController *)self.window.rootViewController.navigationController pushViewController:xjHTML animated:YES];
            //    self.xjTabBar = self.window.rootViewController;
            self.xjTabBar.selectedIndex = 0;
            NSArray* xjarr = self.xjTabBar.viewControllers;
            UINavigationController* xjNavi = [xjarr firstObject];
            [xjNavi pushViewController:xjHTML animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//设置红点
- (void)xjInitTabBarWithIndex:(NSInteger)xjIndex number:(NSInteger)xjNumber{
    if (xjIndex == 2) {
        //        [self getInfoWithPushString:@"1,6,7,8" index:2];
        [[[[self.xjTabBar viewControllers] objectAtIndex:xjIndex] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",xjNumber]];
    } else {
        
    }
}
//请求数据
- (void)getInfoWithPushString:(NSString*)xjStr index:(NSInteger)xjIndex{
    FL_Log(@"w aocaocosaoocsoco=%@----%@",XJ_USERID_WITHTYPE,XJ_USERTYPE_WITHTYPE);
    NSString* xjId = [NSString stringWithFormat:@"%@",XJ_USERID_WITHTYPE];
    NSString* xjType = [NSString stringWithFormat:@"%@",XJ_USERTYPE_WITHTYPE];
    if (xjId==nil || xjType==nil) {
        return;
    }
    NSDictionary* parm = @{@"msgPush.targetUserId":XJ_USERID_WITHTYPE,
                           @"msgPush.targetUserType":XJ_USERTYPE_WITHTYPE,
                           @"types":xjStr};
    [FLNetTool xjGetPushMessagesByParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is in appdelegate to request the push message=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray* xjArr = data.allValues;
            FL_Log(@"this is in appdelegate to request the push message=%@",xjArr);
            NSInteger xjAll = 0 ;
            for (NSInteger i = 0; i < xjArr.count; i++) {
                NSInteger xj = [xjArr[i] integerValue];
                xjAll += xj;
            }
            [self xjInitTabBarWithIndex:xjIndex number:xjAll -1];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[viewController tabBarItem] setBadgeValue:nil];
    
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == NaviSquare) {
        FL_Log(@"dsadasdsadadsa");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XJCLICKSQUARETABBAR" object:nil];
    } else if (viewController == NaviFreeCircle) {
        BOOL nimabi = [XJFinalTool xj_is_phoneNumberBlind];
        if(!nimabi) {
            self.xjTabBar.selectedIndex = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"XJCLICKFREECIRCLETABBAR" object:nil];
        }
    }
}

#pragma mark 跳转
/**跳转到 我发布的界面，
 * index 为 0-4 具体哪一个
 * topic id
 */

- (void)xjPushMyPublishWithIndex:(NSInteger)xjIndexPage topicId:(NSString*)xjTopicId{
    FLMyIssueActivityControlViewController* xjHTML = [[FLMyIssueActivityControlViewController alloc] init];
    xjHTML.xjTopicId = xjTopicId ? xjTopicId :@"";
    xjHTML.xjSelectedIndex = xjIndexPage;
    [(UINavigationController *)self.window.rootViewController.navigationController pushViewController:xjHTML animated:YES];
    self.xjTabBar.selectedIndex = 2;
    NSArray* xjarr = self.xjTabBar.viewControllers;
    UINavigationController* xjNavi = [xjarr lastObject];
    
    [xjNavi pushViewController:xjHTML animated:YES];
}

/**跳转到 我领取的界面， 到期提醒
 * index 为 0-3 具体哪一个
 * topic id
 */

- (void)xjPushMyPickUpWithIndex:(NSInteger)xjIndexPage topicId:(NSString*)xjTopicId detailsId:(NSString*)xjDetailsId{
    FLMyReceiveControlViewController* xjHTML = [[FLMyReceiveControlViewController alloc] init];
    xjHTML.xjTopicId = xjTopicId ? xjTopicId :@"";
    xjHTML.xjSelectedIndex = xjIndexPage;
    xjHTML.xjDetailsId = xjDetailsId;
    [(UINavigationController *)self.window.rootViewController.navigationController pushViewController:xjHTML animated:YES];
    self.xjTabBar.selectedIndex = 2;
    NSArray* xjarr = self.xjTabBar.viewControllers;
    UINavigationController* xjNavi = [xjarr lastObject];
    [xjNavi pushViewController:xjHTML animated:YES];
}
/**跳转到 我参与的界面，
 * topic id
 */
- (void)xjPushMyPartInWithIndex:(NSInteger)xjIndexPage topicId:(NSString*)xjTopicId {
    FLMyIssueActivityControlViewController* xjHTML = [[FLMyIssueActivityControlViewController alloc] init];
    xjHTML.xjTopicId = xjTopicId ? xjTopicId :@"";
    xjHTML.xjSelectedIndex = xjIndexPage;
    [(UINavigationController *)self.window.rootViewController.navigationController pushViewController:xjHTML animated:YES];
    self.xjTabBar.selectedIndex = 2;
    NSArray* xjarr = self.xjTabBar.viewControllers;
    UINavigationController* xjNavi = [xjarr lastObject];
    [xjNavi pushViewController:xjHTML animated:YES];
}
/**跳转到 详情，
 * topic id
 * state  1为助力抢   2为评论
 */
- (void)xjPushHTMLPageWithTopicId:(NSString*)xjTopicId state:(NSString*)xjState {
    FLFuckHtmlViewController* xjHTML = [[FLFuckHtmlViewController alloc] init];
    xjHTML.xjGoWhere = xjState;   //1 为助力抢   2为评轮
    xjHTML.flFuckTopicId = xjTopicId;
    xjHTML.xjIsPushIn = YES;
    [(UINavigationController *)self.window.rootViewController.navigationController pushViewController:xjHTML animated:YES];
    //    self.xjTabBar = self.window.rootViewController;
    self.xjTabBar.selectedIndex = 0;
    NSArray* xjarr = self.xjTabBar.viewControllers;
    UINavigationController* xjNavi = [xjarr firstObject];
    [xjNavi pushViewController:xjHTML animated:YES];
}
- (void)saveLastLoginUsername {
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"---applicationDidBecomeActive----");
    //进入前台
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xj_freela_new_version" object:nil];
} 


@end


































































