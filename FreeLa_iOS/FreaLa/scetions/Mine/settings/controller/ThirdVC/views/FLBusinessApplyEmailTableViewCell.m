//
//  FLBusinessApplyEmailTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLBusinessApplyEmailTableViewCell.h"
#import "FLHeader.h"
#import "FLBusinessApplyInfoModel.h"
#import  <Masonry/Masonry.h>
#define FLMaxLength 4
@interface FLBusinessApplyEmailTableViewCell()<UITextFieldDelegate>

@end

@implementation FLBusinessApplyEmailTableViewCell

- (void)awakeFromNib {
    self.flverifityView.layer.borderWidth = 1;
    self.flemailView.layer.borderWidth = 1;
    self.flpasswordView.layer.borderWidth = 1;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    
    self.flverifityText.borderStyle = UITextBorderStyleNone;//取消边框
    self.flemailText.borderStyle = UITextBorderStyleNone ;
    self.flpasswordText.borderStyle = UITextBorderStyleNone;
    self.flpasswordText.secureTextEntry = YES;
    [self.flverifityView.layer setBorderColor:colorref];//边框颜色
    [self.flemailView.layer setBorderColor:colorref];
    [self.flpasswordView.layer setBorderColor:colorref];
    self.flemailText.delegate = self;
    self.flverifityText.delegate = self;
    self.flpasswordText.delegate = self;
    self.flvirifityBtn.enabled = YES;
    self.flvirifityBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    self.flvirifityBtn.frame = CGRectMake(0, 0, self.btnView.frame.size.width, self.btnView.frame.size.height);
    [self.flvirifityBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.flvirifityBtn.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    self.flvirifityBtn.layer.cornerRadius = 15;
    self.flvirifityBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    [self.btnView addSubview:self.flvirifityBtn];
    //监听
    [self.flemailText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.flverifityText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    NSLog(@"frame = %f",self.flvirifityBtn.frame.size.width);
    
    //格式
    self.flverifityText.keyboardType = UIKeyboardTypeNumberPad;
    self.flpasswordText.keyboardType = UIKeyboardTypeASCIICapable;
    self.flemailText.keyboardType = UIKeyboardTypeASCIICapable;

}
//按钮事件
- (void)click:(UIButton*)sender
{
    NSLog(@"cell  btn click");
    //实现代码块
//    if (self.btnClick) {
//        self.btnClick();
//    }
    [self.delegate checkEmailAndSendMessage:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

//删除了textfield的自带回调方法，增加了监听事件，当修改文本框完成后的方法
- (void) textFieldDidChange:(id) sender
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [userdefaults objectForKey:FL_BUSAPPLY_INFO_KEY];
    //先取出model
    FLBusinessApplyInfoModel* busApplyInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //写入userdefaults
    busApplyInfoModel.busemailNumber = self.flemailText.text;
    busApplyInfoModel.busverifity = self.flverifityText.text;
    busApplyInfoModel.busPassword = self.flpasswordText.text;
    data = [NSKeyedArchiver archivedDataWithRootObject:busApplyInfoModel];
    [userdefaults setObject:data forKey:FL_BUSAPPLY_INFO_KEY];
    [userdefaults synchronize];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    
    self.flverifityText.borderStyle = UITextBorderStyleNone;//取消边框
    self.flemailText.borderStyle = UITextBorderStyleNone ;
    [self.flverifityView.layer setBorderColor:colorref];//边框颜色
    [self.flemailView.layer setBorderColor:colorref];
    [self.flpasswordView.layer setBorderColor:colorref];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.flpasswordText)
    {
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

@end
