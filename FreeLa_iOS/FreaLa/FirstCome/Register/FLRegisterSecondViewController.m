//
//  FLRegisterSecondViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/9/25.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLRegisterSecondViewController.h"
#import "FLSquareViewController.h"
#import "FLFreeCircleViewController.h"
#import "FLMineViewController.h"
#import "FLAppDelegate.h"
#import "FLHeader.h"
#import "AnimateTabbar.h"
#import "FLTabBarController.h"

#import "FLTabBarHelperViewController.h"
#import "FLNetTool.h"

@interface FLRegisterSecondViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    BOOL isPersonl;         //是否是个人
    
    //关于用户账号密码的存储
    FLUserInfoModel * userInfoModel;
    NSData          * userData;
    NSUserDefaults  * userDefault;
    
}
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *TOETextField;//昵称term of endearment
@property (weak, nonatomic) IBOutlet UITextField *PWDTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end

@implementation FLRegisterSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //添加一个Tap手势用来点击空白区域关闭键盘
    UITapGestureRecognizer* tapGertureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard)];
    tapGertureRecognizer.numberOfTapsRequired = 1 ;
    tapGertureRecognizer.numberOfTouchesRequired = 1;
    tapGertureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGertureRecognizer];
}

- (void)setUpUI
{
    self.nameView.layer.cornerRadius = 25;
    self.pwdView.layer.cornerRadius = 25;
    self.PWDTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
//    self.PWDTextField.secureTextEntry = YES;
    self.topLayout.constant =((700 * FLUISCREENBOUNDS.height) / FL_HEIGHT_PROPORTION);
    self.PWDTextField.delegate = self;
    self.TOETextField.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChangeInRegister:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.TOETextField];
    
}

- (void)closeKeyBoard
{
    [self.TOETextField resignFirstResponder];
    [self.PWDTextField resignFirstResponder];
    
}
//注册、传入手机号、密码、昵称、昵称暂时支持英文
#warning 中文昵称使用UTF8编码   、需要判断是邮箱注册还是 个人注册
- (IBAction)enterAPP:(UIButton *)sender {
    //校验信息完整度
    if (!self.TOETextField.text || [self.TOETextField.text isEqualToString:@""]) {
         [[FLAppDelegate share] showHUDWithTitile:@"还是起个昵称吧" view:self.view delay:1 offsetY:0 ];
    } else if (!self.PWDTextField.text || [self.PWDTextField.text isEqualToString:@""]) {
        [[FLAppDelegate share] showHUDWithTitile:@"密码不能为空" view:self.view delay:1 offsetY:0 ];
    }   else    {
        if (![FLTool checkLengthWithString:self.PWDTextField.text length:6 lengthM:12 view:self.view who:@"密码"]){}
        else if (![FLTool checkLengthWithString:self.TOETextField.text length:1 lengthM:8 view:self.view who:@"昵称"]){}
        else {
            //注册接口
            NSDictionary* parm = @{@"accountType":FLFLXJUserTypePersonStrKey,
                                   @"nikeName":self.TOETextField.text,
                                   @"phone":_phoneString,
                                   @"password": self.PWDTextField.text,
                                   @"source":@"3"};   //source   1、PC 2、Android 3iOS、4、QQ 5、微信 6、新浪 7、人人 8、机器人
            
                [FLNetTool registerAccountWithParm:parm success:^(NSDictionary *data) {
                    if ([[data objectForKey:FL_NET_KEY]boolValue]) {
                        FL_Log(@"this is the debau to bal balb balbla safa-=-=-=-=-=- =afs-=a s-=f-as= f-a=s -=-=fa-s= d-as=%@",data);
                        [[FLAppDelegate share] showHUDWithTitile:@"注册成功" view:self.view  delay:1 offsetY:0];
                        [self xjLoginWithFirstLog];//调用登陆接口-
                      //    数据存储
                        [self saveUserDefaults];
                    } else {
//                        [[FLAppDelegate share] showHUDWithTitile:@"注册失败" view:self.view delay:1 offsetY:0];
                         [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[ data objectForKey:@"msg"]] view:self.view delay:1 offsetY:0];
                    }
                } failure:^(NSError *error) {
                    NSLog(@"register error = %@, %@",error.description,error.debugDescription);
                    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
                }];
        }
    }
    
}

- (void)xjLoginWithFirstLog {
    [FLNetTool logInWithPhone:_phoneString password:self.PWDTextField.text success:^(NSDictionary *dic) {
        FL_Log(@"dic in square login =%@",dic);
        if (dic) {
            if ([[dic objectForKey:FL_NET_KEY] boolValue])  {
                FL_Log(@"用户名密码 没什么问题");
                NSString* xjStr = [dic objectForKey:FL_NET_SESSIONID];
                [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjStr ? xjStr :@"" key:FL_NET_SESSIONID];
                [XJFinalTool xjSaveUserInfoInUserdefaultsValue:_phoneString ? _phoneString :@"" key:XJ_VERSION2_PHONE]; //手机号
                [XJFinalTool xjSaveUserInfoInUserdefaultsValue:self.PWDTextField.text ? self.PWDTextField.text :@"" key:XJ_VERSION2_PWD]; //密码
                //进入主界面
                [[FLAppDelegate share] setUpTabBar];
            }  else {
            }
        }
        
    } failure:^(NSError *error)   {
        NSLog(@"i'm wrong =====  %@ ----------%@         。。。。。。。。。%ld",error.description,error.debugDescription,error.code);
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@", [FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
    }];

}

- (NSString *)phoneString
{
    if (!_phoneString) {
        _phoneString = [[NSString alloc]init];
    }
    return _phoneString;
}
- (void)saveUserDefaults {
    //需要先清除之前的id
    NSLog(@"数据存储开始");
    
    NSString* xjPhone = _phoneString;
    NSString* xjPwd   = self.PWDTextField.text;
    [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjPhone key:XJ_VERSION2_PHONE];
    [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjPwd key:XJ_VERSION2_PWD];
}

#pragma mark -----textfield delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField == self.PWDTextField)
    {
        if (string.length == 0) return YES;
        
        if (existedLength - selectedLength + replaceLength > 16)
        {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChangeInRegister :(NSNotification*)noti{
    NSInteger xjMaxLength = 8;
    UITextField* xjTextfield = noti.object;
    FL_Log(@"textView......====%lu",(unsigned long)xjTextfield.text.length);
    NSString *toBeString = xjTextfield.text;
 
    NSString* lang = [UIApplication sharedApplication].textInputMode.primaryLanguage;
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [xjTextfield markedTextRange];
        //获取高亮部分
        UITextPosition *position = [xjTextfield  positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > xjMaxLength) {
                xjTextfield.text = [toBeString substringToIndex:xjMaxLength];
                self.TOETextField.text = [toBeString substringToIndex:xjMaxLength];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > xjMaxLength) {
            xjTextfield.text= [toBeString substringToIndex:xjMaxLength];
            self.TOETextField.text = [toBeString substringToIndex:xjMaxLength];
        }
    }
//    self.TOETextField.text  = xjTextfield.text;//[NSString stringWithFormat:@"%lu/%ld",xjTextfield.text.length,xjMaxLength];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
















































