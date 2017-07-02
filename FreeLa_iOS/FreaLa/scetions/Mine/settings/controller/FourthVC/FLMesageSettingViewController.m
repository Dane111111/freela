//
//  FLMesageSettingViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLMesageSettingViewController.h"
#import "FLConst.h"

#define SESSIONID           [userDefaults objectForKey:FL_NET_SESSIONID]

//extern BOOL  FLFLIsPersonalAccountType;

@interface FLMesageSettingViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *NewPwdText;
@property (weak, nonatomic) IBOutlet UITextField *doubleCheckText;

@property (nonatomic , strong)FLUserInfoModel* userInfoModel;
@property (strong, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIView *oldView;
@property (weak, nonatomic) IBOutlet UIView *NewView;
@property (weak, nonatomic) IBOutlet UIView *sureView;

@end

@implementation FLMesageSettingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
    self.title = @"修改密码";
    [self.myView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
   
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self tapTheScreen];
}


- (IBAction)makeSure:(id)sender
{
    //关闭键盘
    [self.oldPassWord resignFirstResponder];
    [self.NewPwdText resignFirstResponder];
    [self.doubleCheckText resignFirstResponder];
    //检查网络状态
    if (![FLTool isNetworkEnabled]) {
        [[FLAppDelegate share] showHUDWithTitile:@"请检查网络设置" view:self.view delay:1 offsetY:0];
    }else
    {
        [self checkInfo:sender];
    }
}

- (void)checkInfo:(id)sender {
    [self.view endEditing:YES];
    //校验新密码长度和其他信息
    if (!self.oldPassWord.text || [self.oldPassWord.text isEqualToString:@""]) {
        [[FLAppDelegate share] showHUDWithTitile:@"旧密码不能为空" view:self.view delay:1 offsetY:0 ];
        return;
    } else if (!self.NewPwdText.text || [self.NewPwdText.text isEqualToString:@""]) {
        [[FLAppDelegate share] showHUDWithTitile:@"新密码不能为空" view:self.view delay:1 offsetY:0 ];
        return;
    } else if (![FLTool checkLengthWithString:self.NewPwdText.text length:6 lengthM:16 view:self.view who:@"新密码"]) {
        return;
    } else if (![FLTool checkLengthWithString:self.oldPassWord.text length:6 lengthM:16 view:self.view who:@"旧密码"]) {
        return;
     }  else if(!self.doubleCheckText.text || [self.doubleCheckText.text isEqualToString:@""]) {
        [[FLAppDelegate share] showHUDWithTitile:@"请输入新密码" view:self.view delay:1 offsetY:0];
        return;
    } else if (![FLTool checkLengthWithString:self.doubleCheckText.text length:6 lengthM:16 view:self.view who:@"新密码"]) {
        return;
    } else if (![self.NewPwdText.text isEqualToString: self.doubleCheckText.text]) {
        [[FLAppDelegate share] showHUDWithTitile:@"两次密码输入不一致" view:self.view delay:1 offsetY:0];
        return;
    }   else     {
        //看是否是个人用户
        if (FLFLIsPersonalAccountType)  {
            NSDictionary* parm = [NSDictionary dictionaryWithObjectsAndKeys:XJ_USER_SESSION,@"token",FLFLXJUserTypePersonStrKey,@"accountType",self.oldPassWord.text,@"oldpassword",self.NewPwdText.text,@"newpassword", nil];
            [FLNetTool changeMyPasswordWithParm:parm success:^(NSDictionary *data) {
                if ([[data objectForKey:FL_NET_KEY] boolValue]){
                    NSLog(@"post总算是好了");
                    //更新userdefaults
                    [self changeMyPWDWithOldPWD];
                    [[FLAppDelegate share] showHUDWithTitile:@"修改成功，请使用新密码登录" view:self.view delay:1 offsetY:0];
                    [[FLAppDelegate share] setUpTabBar];
                }else  {
                    NSLog(@"修改失败了");
                    [[FLAppDelegate share] showHUDWithTitile:@"旧密码输入有误" view:self.view delay:1 offsetY:0];
                }
                
            } failure:^(NSError *error) {
                NSLog(@"不可能，为什么会不行");
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
            }];
        }  else  {
            NSDictionary* parm = [NSDictionary dictionaryWithObjectsAndKeys:FLFLBusSesssionID,@"token",@"comp",@"accountType",self.oldPassWord.text,@"oldpassword",self.NewPwdText.text,@"newpassword", nil];
            [FLNetTool changeMyPasswordWithParm:parm success:^(NSDictionary *data) {
                if ([[data objectForKey:FL_NET_KEY] boolValue]){
                    NSLog(@"post总算是好了");
                    [[FLAppDelegate share] showHUDWithTitile:@"修改成功，请使用新密码登录" view:self.view delay:1 offsetY:0];
                    [[FLAppDelegate share] setUpTabBar];
                } else  {
                    NSLog(@"修改失败了");
                     [[FLAppDelegate share] showHUDWithTitile:@"旧密码输入有误" view:self.view delay:1 offsetY:0];
                }
            } failure:^(NSError *error) {
                NSLog(@"不可能，为什么会不行");
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
            }];
        }
    }

}

- (void)changeMyPWDWithOldPWD {
    NSString* xjPwd = self.NewPwdText.text;
    NSLog(@"- - - -- - - -%@ ",self.NewPwdText.text );
    [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjPwd key:XJ_VERSION2_PWD];
}

- (void)setUpUI {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    //取消边框
    self.oldPassWord.borderStyle = UITextBorderStyleNone;
    self.NewPwdText.borderStyle = UITextBorderStyleNone;
    self.doubleCheckText.borderStyle = UITextBorderStyleNone;
    //边框颜色
    self.oldView.layer.borderWidth = 1;
    self.NewView.layer.borderWidth = 1;
    self.sureView.layer.borderWidth = 1;
    [self.oldView.layer setBorderColor:colorref];
    [self.NewView.layer setBorderColor:colorref];
    [self.sureView.layer setBorderColor:colorref];
    //圆角
    self.oldView.layer.cornerRadius = 25;
    self.NewView.layer.cornerRadius = 25;
    self.sureView.layer.cornerRadius = 25;
    //键盘式样
    self.oldPassWord.keyboardType = UIKeyboardTypeASCIICapable;
    self.NewPwdText.keyboardType = UIKeyboardTypeASCIICapable;
    self.doubleCheckText.keyboardType = UIKeyboardTypeASCIICapable;
    //代理
    self.oldPassWord.delegate = self;
    self.NewPwdText.delegate = self;
    self.doubleCheckText.delegate = self;
    //密文
    self.oldPassWord.secureTextEntry = YES;
    self.NewPwdText.secureTextEntry = YES;
    self.doubleCheckText.secureTextEntry = YES;
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

- (void)tapTheScreen
{
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEmpryScreen:)];
    [self.view addGestureRecognizer:tapRecognizer];
    tapRecognizer.numberOfTapsRequired = 1;
    //    tapRecognizer.numberOfTouches = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    tapRecognizer.delegate = self;
    
}

- (void)tapEmpryScreen:(UITapGestureRecognizer*)ges
{
    [self.oldPassWord resignFirstResponder];
    [self.NewPwdText resignFirstResponder];
    [self.doubleCheckText resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.oldPassWord) {
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }   else if (textField == self.NewPwdText )  {
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }  else if (textField == self.doubleCheckText ) {
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated] ;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setHidden:NO];
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
