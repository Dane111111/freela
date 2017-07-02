//
//  FLBusinessApplyNameTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/9.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLBusinessApplyNameTableViewCell.h"
#import "FLApplyBusinessAccountViewController.h"

#define FLMaxLengthFull    18
#define FLMaxLengthSimple     6


@interface FLBusinessApplyNameTableViewCell()<UITextFieldDelegate>


@end

@implementation FLBusinessApplyNameTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.fullnameView.layer.borderWidth = 1;
    self.simplenameView.layer.borderWidth = 1;
    self.licenenameView.layer.borderWidth = 1;
    self.flindustryView.layer.borderWidth = 1;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    
    self.flmyFullNameText.borderStyle = UITextBorderStyleNone;//取消边框
    self.flmyLiceneNameText.borderStyle = UITextBorderStyleNone;
    self.flmySimpleNameText.borderStyle = UITextBorderStyleNone;
     self.flindustryText.borderStyle =  UITextBorderStyleNone ;
    [self.fullnameView.layer setBorderColor:colorref];//边框颜色
    [self.licenenameView.layer setBorderColor:colorref];
    [self.simplenameView.layer setBorderColor:colorref];
    [self.flindustryView.layer setBorderColor:colorref];
    //给textfield 添加代理保存值
    self.flmyFullNameText.delegate = self;
    self.flmySimpleNameText.delegate = self;
    self.flmyLiceneNameText.delegate = self;
    self.flindustryText.delegate = self;
//    self.flindustryText.userInteractionEnabled = NO;
    
    
    //键盘属性
//    self.flmyLiceneNameText.keyboardType = UIKeyboardTypeNumberPad;
    
    //监听改变完成
    [self.flmyFullNameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.flmySimpleNameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.flmyLiceneNameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.flmyLiceneNameText addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    [KeyboardToolBar registerKeyboardToolBar:self.flmyFullNameText];
    [KeyboardToolBar registerKeyboardToolBar:self.flmyLiceneNameText];
    [KeyboardToolBar registerKeyboardToolBar:self.flmySimpleNameText];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//删除了textfield的自带回调方法，增加了监听事件，当修改文本框完成后的方法
- (void) textFieldDidChange:(id) sender
{
    //写入userdefaults
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    FLBusinessApplyInfoModel* busApplyInfoModel = [[FLBusinessApplyInfoModel alloc] init];
    busApplyInfoModel.busFullName = self.flmyFullNameText.text;
    busApplyInfoModel.bussimpleName = self.flmySimpleNameText.text;
    busApplyInfoModel.busliceneNumber = self.flmyLiceneNameText.text;
    busApplyInfoModel.busIndustryStr = self.flindustryText.text;
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:busApplyInfoModel];
//    [userdefaults setObject:data forKey:FL_BUSAPPLY_INFO_KEY];
    [userdefaults synchronize];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    self.flmyFullNameText.borderStyle = UITextBorderStyleNone;//取消边框
    self.flmyLiceneNameText.borderStyle = UITextBorderStyleNone;
    self.flmySimpleNameText.borderStyle = UITextBorderStyleNone;
    self.flindustryText.borderStyle = UITextBorderStyleNone;
    
    [self.fullnameView.layer setBorderColor:colorref];//边框颜色
    [self.licenenameView.layer setBorderColor:colorref];
    [self.simplenameView.layer setBorderColor:colorref];
    [self.flindustryView.layer setBorderColor:colorref];
    
    
    if (sender == self.flmyFullNameText) {
        NSString *toBeString = self.flmyFullNameText.text;
        //            NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        NSString* lang = [UIApplication sharedApplication].textInputMode.primaryLanguage;
        if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [self.flmyFullNameText markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self.flmyFullNameText  positionFromPosition:selectedRange.start offset:0];
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if(!position) {
                if(toBeString.length > FLMaxLengthFull) {
                    self.flmyFullNameText.text = [toBeString substringToIndex:FLMaxLengthFull];
                }
            }
            //有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if(toBeString.length > FLMaxLengthFull) {
                self.flmyFullNameText.text= [toBeString substringToIndex:FLMaxLengthFull];
            }
        }
    } else if (sender == self.flmySimpleNameText) {
        NSString *toBeString = self.flmySimpleNameText.text;
        //            NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        NSString* lang = [UIApplication sharedApplication].textInputMode.primaryLanguage;
        if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [self.flmySimpleNameText markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self.flmySimpleNameText  positionFromPosition:selectedRange.start offset:0];
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if(!position) {
                if(toBeString.length > FLMaxLengthSimple) {
                    self.flmySimpleNameText.text = [toBeString substringToIndex:FLMaxLengthSimple];
                }
            }
            //有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if(toBeString.length > FLMaxLengthSimple) {
                self.flmySimpleNameText.text= [toBeString substringToIndex:FLMaxLengthSimple];
            }
        }
        
        
    }
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField == self.flmySimpleNameText)
//    {
//          FL_Log(@"文本框修改完成");
//        //校验唯一性
//       
////        NSDictionary* dic = @{@"nikeName":self.flmySimpleNameText.text};
////        [FLNetTool checkNickNameWithParm:dic success:^(NSDictionary *data)
////        {
////            FL_Log(@"datatesttttt = %@",data);
////            if ([data[@"count"] integerValue] != 0) {
////                FL_Log(@"data count =%@",data[@"count"]);
////                [[FLAppDelegate share] showHUDWithTitile:@"用户名已存在" view:[UIApplication sharedApplication].keyWindow delay:1 offsetY:0];
////            }
//////            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[data objectForKey:@"count"]] view:self.applyVC.view delay:1 offsetY:0];
////        } failure:^(NSError *error) {
////            FL_Log(@"datatesttttt = %@",error.description);
////        }];
//    }
//    if (textField == self.flmyFullNameText) {
//        if (self.flmyFullNameText.text.length > 18) {
//            self.flmyFullNameText.text = @"";
//            [[FLAppDelegate share] showHUDWithTitile:@"全称不能大于18位" view:[UIApplication sharedApplication].keyWindow delay:1 offsetY:0];
//        }
//    }
//    if (textField == self.flmySimpleNameText) {
//        if (self.flmySimpleNameText.text.length > 8) {
//            self.flmySimpleNameText.text = @"";
//            [[FLAppDelegate share] showHUDWithTitile:@"简称不能大于8位" view:[UIApplication sharedApplication].keyWindow delay:1 offsetY:0];
//        }
//    }
//    
//  
//}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.flmyLiceneNameText)
    {
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 18)
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.flindustryText) {
        FL_Log(@"行业选择balabal");
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        [textField resignFirstResponder];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FLFLpopViewShowInBusApplyCountCell" object:nil];
 
    }
}
- (IBAction)xjendEditting:(id)sender {
    [self.flmyFullNameText resignFirstResponder];
    [self.flmySimpleNameText resignFirstResponder];
    [self.flmyLiceneNameText resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FLFLpopViewShowInBusApplyCountCell" object:nil];
}



@end




















