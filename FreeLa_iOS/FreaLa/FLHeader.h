//
//  Header.h
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/16.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//


//备用短信key
#define FL_SMS_APPKEY         @"1976d7eaf31e1"
#define FL_SMS_SECRET         @"27ae28e8242ccf2f8e24cd861a97037e"
//高德key
#define  FL_GAODE_API_KEY       @"488e0632098f5e1f690b8bab7cc3bbbd"
//#define  XJ_GAODE_TABLEID       @"587c2dc07bbf195ae8a55d95"// 测试环境
#define  XJ_GAODE_TABLEID       @"586330c67bbf195ae8561288" //正式环境

//极光key
#define XJ_JG_PUSH_KEY          @"f084d685db5f6a215976d459"

//source   0未知  1PC 2Android 3IOS 4QQ 5微信  6新浪 7人人 8机器人

#define FLUISCREENBOUNDS    [UIScreen mainScreen].bounds.size //获取屏幕大小
#define FL_WIDTH_PROPORTION   640
#define FL_HEIGHT_PROPORTION  1136
//短信验证码的key
//#define FL_SMS_APPKEY         @"f3fc6baa9ac4"
//#define FL_SMS_SECRET         @"7f3dedcb36d92deebcb373af921d635a"

//友盟key
#define FL_YOUMENG_APPKEY     @"568a1b2967e58eb72400024e"
//#define FL_FONT_NAME          @"Times NEW Roman"
#define FL_FONT_NAME          @"ArialMT"
#define FL_FONT_NUMBER_NAME   @"ArialMT"
//字体大中小
#define XJ_LABEL_SIZE_LARGE     16
#define XJ_LABEL_SIZE_BIG       14
#define XJ_LABEL_SIZE_NORMAL    12
#define XJ_LABEL_SIZE_SMALL     10

#define FL_BOTTOM_TABBAR_COLOR_IMAGE  @"tabbar_back_red"
#define FL_STATUSBAR          [[UIApplication sharedApplication] statusBarFrame].size   //获取状态栏size
#define FL_NAVI_BAR_SIZE      self.navigationController.navigationBar.frame.size        //获取导航栏size
#define FL_KeyWindow          [UIApplication sharedApplication].keyWindow               //根控制器

#define FL_SCREEN_PROPORTION_height  (1 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION     //屏幕尺寸比例高系数
#define FL_SCREEN_PROPORTION_width   (1 * FLUISCREENBOUNDS.width) / FL_WIDTH_PROPORTION       //屏幕尺寸比例宽系数

//#define FLUrlAndPort @"192.168.20.59:8080"         //李光雄    192.168,20.6
//#define FLUrlAndPort @"192.168.20.248"            //志华
//#define FLBaseUrl [NSString stringWithFormat:@"http://%@/freeLa", FLUrlAndPort] //第一版本
//
#define FLBaseUrl       [NSString stringWithFormat:@"http://%@", FLUrlAndPort]  //第二版本
#define XJImageBaseUrl  @""
//#define FLUrlAndPort @"www.liuxingpu.cn"       //张洋测试
//#define FLUrlAndPort @"192.168.20.206:8099/"       //测试r
//#define FLUrlAndPort @"192.168.20.248"       //外网   sssr
//#define FLUrlAndPort @"59.108.126.40"       //内网r
//#define FLUrlAndPort @"bd.freela.com.cn"    //阿里云测试
#define FLUrlAndPort @"www.freela.com.cn"    //freela
//#define FLUrlAndPort @"bd.freela.com.cn"    //建军
//#define FLUrlAndPort @"192.168.20.54:8080"    //

#define FL_NET_KEY             @"isSuccess"                  //用AF请求服务器  返回的 字典的key值  旧的 第一里程碑用
#define FL_NET_KEY_NEW             @"success"                  //用AF请求服务器  返回的 字典的key值
#define FL_NET_DATA_KEY         @"data"
#define FL_NET_VALUE_TRUE      @"true"                       //返回结果为true
#define FL_NET_VALUE_FALSE     @"false"                      //返回结果为false


//关于userdefaults
#define NAVBAR_CHANGE_POINT 50              //导航栏透明问题

//申请商家账户的信息
#define FL_BUSAPPLY_INFO_KEY                @"busApplyInfo"

//标签的高度
#define FL_TAGS_HEIGHT_KEY                @"myTagsHeight"




/**------------------删除----------------*/
/**------------------删除----------------*/

#ifdef DEBUG
#define FL_Log(...) NSLog(__VA_ARGS__)
#else
#define FL_Log(...)
#endif





#define FL_UMENG_SDK_WECHAT_ID             @"wx7ce4c150e2484834"
#define FL_UMENG_SDK_WECHAT_SECRET         @"dc5e09f616b1bfe30ff90b9ca1a536bb"

//APP ID1105028239
//APP KEY5fZvrKidsqcgTeoP

/**
 * userdefaults
 */
#define XJ_VERSION2_PHONE               @"xjversion2phone"              //第二版本的手机号存储
#define XJ_VERSION2_PWD                 @"xjversion2pwd"                 //第二版本的密码存储
//个人userId
#define FL_USERDEFAULTS_USERID_KEY      @"myUserId"
#define FL_NET_SESSIONID                @"sessionid"                  //返回一个sessionid 存到userdefaults的 token
#define XJ_VERSION_IS_THIRD               @"isThirdLogIn"              //是不是第三方登陆 ,存在即代表第三方登陆
#define XJ_USERID_WITHTYPE                        FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID         //userid
#define XJ_USERTYPE_WITHTYPE                      FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey     //userType
#define XJ_USER_SESSION                           FLFLIsPersonalAccountType ? FL_ALL_SESSIONID           : FLFLBusSesssionID            //token
#define XJ_USER_freelaUVID              @"xjVesion2FreelaUVID"
#define XJ_USER_VALUE_PHONE             [[NSUserDefaults standardUserDefaults] objectForKey:XJ_VERSION2_PHONE]
#define XJ_USER_VALUE_PWD               [[NSUserDefaults standardUserDefaults] objectForKey:XJ_VERSION2_PWD]

/**image*/
#define  XJ_IMAGE_PUBULIU_ADD   @"site_"
#define  XJ_IMAGE_BIG_ADD       @"big_"

#define  XJ_PLACEHOLDER_IMAGE   [UIImage imageNamed:@"xj_default_avator"]

//环信约定的key
#define  XJ_HUANXIN_KEY_USERNAME        @"userName"
#define  XJ_HUANXIN_KEY_AVATAR          @"userPic"
#define  XJ_HUANXIN_USERTYPE_Friend     @"xjFriend"
#define  XJ_HUANXIN_USERTYPE_Group      @"xjGroup"
#define  XJ_HUANXIN_USERTYPE_ID         @"xj_huanxin_userType_Id"       //用来解决 环信 model 中没有id 的问题

//当前的头像 昵称 环信用
#define  XJ_FOR_HUANXIN_USERNAME        @"xj_for_huanxin_username"
#define  XJ_FOR_HUANXIN_AVATAR          @"xj_for_huanxin_avatar"



//颜色
#define FL_MAIN_COLOR_RED           @"#f06458"
#define FL_MAIN_COLOR_GRAY          @"#edecec"
#define XJ_MAIN_COLOR_BACKGROUND    @"#f2f2f2"

#define XJ_FCOLOR_REDBACK              @"#ff3e3e"   //背景
#define XJ_FCOLOR_REDFONT              @"#ff5656"    //字体


#define XJ_COLORRGB(r,g,b,a)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define XJ_COLORSTR(str)            [UIColor colorWithHexString:str]

//用户是否被禁
#define XJ_xjBusAccountState        @"xjBusAccountState"
//progressviewH
#define XJ_PROGRESS_H               5
#define XJ_VERSION_NUMBER       @"xj_version_number"


#define  XJ_TRANS_HTML      @"/transpond/transpond!isTranspond.action?"
#define  XJ_TRANS_HTML5     @"/transpondh/transpondh!isTranspond.action?"

#define DE_headerBorderColor [UIColor colorWithHexString:@"#cfcbc8"]

#define DE_headerBorderWidth 3

