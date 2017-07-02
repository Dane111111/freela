//
//  FLBusinessApplyContectTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLBusinessApplyContectTableViewCell.h"
#import "FLBusinessApplyInfoModel.h"
#import "FLHeader.h"
#define FLMaxLength 15
@interface FLBusinessApplyContectTableViewCell ()<UITextFieldDelegate>

@end

@implementation FLBusinessApplyContectTableViewCell

- (void)awakeFromNib {
    self.flmyNameTextView.layer.borderWidth = 1;
    self.flmyPhoneView.layer.borderWidth = 1;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    
    self.flmyNameText.borderStyle = UITextBorderStyleNone;//取消边框
    self.flmyPhoneText.borderStyle = UITextBorderStyleNone ;
    [self.flmyNameTextView.layer setBorderColor:colorref];//边框颜色
    [self.flmyPhoneView.layer setBorderColor:colorref];
    //添加代理
    self.flmyNameText.delegate = self;
    self.flmyPhoneText.delegate = self;
    self.flmyPhoneText.keyboardType = UIKeyboardTypeNumberPad;
    
    //监听
    [self.flmyNameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.flmyPhoneText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //设置联系电话不可更改
    self.flmyPhoneText.userInteractionEnabled = NO;
    self.flmyPhoneText.enabled = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.flmyPhoneText.text];
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
    busApplyInfoModel.bussContectPerName = self.flmyNameText.text;
    busApplyInfoModel.busPhoneNumber = self.flmyPhoneText.text;
    data = [NSKeyedArchiver archivedDataWithRootObject:busApplyInfoModel];
    [userdefaults setObject:data forKey:FL_BUSAPPLY_INFO_KEY];
    [userdefaults synchronize];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    
    self.flmyNameText.borderStyle = UITextBorderStyleNone;//取消边框
    self.flmyPhoneText.borderStyle = UITextBorderStyleNone ;
    [self.flmyNameTextView.layer setBorderColor:colorref];//边框颜色
    [self.flmyPhoneView.layer setBorderColor:colorref];
    
    if (sender == self.flmyNameText) {
        NSString *toBeString = self.flmyNameText.text;
        //            NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        NSString* lang = [UIApplication sharedApplication].textInputMode.primaryLanguage;
        if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [self.flmyNameText markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self.flmyNameText  positionFromPosition:selectedRange.start offset:0];
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if(!position) {
                if(toBeString.length > FLMaxLength) {
                    self.flmyNameText.text = [toBeString substringToIndex:FLMaxLength];
                }
            }
            //有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if(toBeString.length > FLMaxLength) {
                self.flmyNameText.text= [toBeString substringToIndex:FLMaxLength];
            }
        }
        
        
    }
    

   
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}










@end
