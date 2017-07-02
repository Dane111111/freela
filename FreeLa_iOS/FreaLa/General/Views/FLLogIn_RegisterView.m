//
//  FLLogIn_RegisterView.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/9/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLLogIn_RegisterView.h"
#import "FLHeader.h"
#import <Masonry/Masonry.h>
@interface FLLogIn_RegisterView()
@property (nonatomic , strong)UIView* view;
@property (nonatomic , strong)UIImageView* phoneImageView;
@property (nonatomic , strong)UIImageView* backdropImageView;
@property (nonatomic , strong)UIImageView* logoImageView;
@property (nonatomic , strong)UIImageView* passwordImageView;
@property (nonatomic , strong)UITextField* phoneText;
@property (nonatomic , strong)UITextField* passwordText;

@end

@implementation FLLogIn_RegisterView


- (void)initLogIn_RegisterView
{
    UIView* aaa = [[UIView alloc]init];
    aaa.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
    
    
    //背景
    self.backdropImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
    self.backdropImageView.image = [UIImage imageNamed:@"login_backdrop"];
    [self.view addSubview:self.backdropImageView];
    //图标
    self.logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_freela"]];
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = 10;
    [self.view addSubview:self.logoImageView];
    //约束
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backdropImageView).with.offset(50);
        make.centerX.equalTo(self.backdropImageView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    //手机号头像
    self.phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_head"]];
    [self.view addSubview:self.phoneImageView];
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImageView).with.offset(120);
        make.centerX.equalTo(self.backdropImageView).with.offset(-110);
        make.size.mas_equalTo(CGSizeMake(30, 35));
    }];
    
    //手机号文本框
    self.phoneText = [[UITextField alloc]init];
    //    self.phoneText.backgroundColor = [UIColor redColor];//测试文本框
    self.phoneText.borderStyle = UITextBorderStyleRoundedRect;//关于光标过于靠前的解决方法
    self.phoneText.clearButtonMode = UITextFieldViewModeAlways;//关于输入框 X号 问题
    self.phoneText.clearsOnBeginEditing = YES;//再次编辑清空
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;//键盘式样
    self.phoneText.backgroundColor = [UIColor clearColor];
    self.phoneText.placeholder = @"手机号";
    [self.phoneText  setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:self.phoneText];
    //约束
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImageView).with.offset(120);
        make.left.equalTo(self.phoneImageView).with.offset(30);
        make.right.equalTo(self.backdropImageView).with.offset(-40);
        
    }];
    //划线
    [self drawPhoneUnderLine];
    
    //密码图片
    self.passwordImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_key"]];
    [self.view addSubview:self.passwordImageView];
    [self.passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneImageView).with.offset(60);
        make.centerX.equalTo(self.backdropImageView).with.offset(-110);
        make.size.mas_equalTo(CGSizeMake(30, 35));
    }];
    //密码文本框
    self.passwordText = [[UITextField alloc]init];
    //     self.passwordText.backgroundColor = [UIColor redColor];//测试文本框
    self.passwordText.borderStyle = UITextBorderStyleRoundedRect;//关于光标过于靠前的解决方法
    self.passwordText.clearButtonMode = UITextFieldViewModeAlways;//关于输入框 X号 问题
    self.passwordText.clearsOnBeginEditing = YES;//再次编辑清空
    self.passwordText.keyboardType = UIKeyboardTypeNumberPad;//键盘式样
    self.passwordText.backgroundColor = [UIColor clearColor];
    self.passwordText.placeholder = @"密码";
    [self.passwordText  setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:self.passwordText];
    //约束
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneImageView).with.offset(60);
        make.left.equalTo(self.phoneImageView).with.offset(30);
        make.right.equalTo(self.backdropImageView).with.offset(-40);
    }];
    
    //划线
    [self drawPWDUnderLine];
}

- (void)drawPhoneUnderLine
{
    //添加一个背景为白色的UIView
    UIView* phoneLineView  = [[UIView alloc]init];
    phoneLineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneLineView];
    [phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneImageView).with.offset(36);
        make.left.equalTo(self.phoneImageView).with.offset(0);
        make.right.equalTo(self.phoneText).with.offset(0);
        make.height.mas_equalTo(2.0);
        
    }];
    
}

- (void)drawPWDUnderLine
{
    //添加一个背景为白色的UIView
    UIView* phoneLineView  = [[UIView alloc]init];
    phoneLineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneLineView];
    [phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordImageView).with.offset(36);
        make.left.equalTo(self.passwordImageView).with.offset(0);
        make.right.equalTo(self.passwordText).with.offset(0);
        make.height.mas_equalTo(2.0);
        
    }];
}



@end
