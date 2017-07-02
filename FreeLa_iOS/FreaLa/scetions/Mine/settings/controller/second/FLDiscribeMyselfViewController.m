//
//  FLDiscribeMyselfViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/16.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLDiscribeMyselfViewController.h"
#import "FLConst.h"

#define FLMaxLength 100

@interface FLDiscribeMyselfViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;

@end

@implementation FLDiscribeMyselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = FLFLIsPersonalAccountType? @"设置签名":@"设置签名";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.discribeText setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveMyDiscribtion)];
    UIBarButtonItem* itemBus = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveMyDiscribtion)];
    self.navigationItem.rightBarButtonItem = FLFLIsPersonalAccountType? item: itemBus;
    self.discribeText.text = _flStr;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.discribeText.delegate = self;
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    //字数文本
    self.lengthLabel.text = [NSString stringWithFormat:@"%lu/%d",self.discribeText.text.length,FLMaxLength];
}

- (void)saveMyDiscribtion
{
    
    if (![FLTool isNetworkEnabled])
    {
        [[FLAppDelegate share] showHUDWithTitile:@"无网络连接" view:self.view delay:1 offsetY:0];
    }
    else
    {
        //验证长度
//        if (![FLTool checkLengthWithString:self.discribeText.text length:1 lengthM:FLMaxLength view:self.view who:@"个人描述"])
//        {
////            [[FLAppDelegate share] showHUDWithTitile:@"不能超过100个字" view:self.view delay:1 offsetY:0];
//        }
//        else
//        {
            if (FLFLIsPersonalAccountType) {
                //传参给服务器
                [self sendToService];
            }else
            {
                [self saveMyBusDiscribtion];
            }
//        }
    }
}

- (void)saveMyBusDiscribtion
{
    [[FLAppDelegate share] showdimBackHUDWithTitle:nil view:self.view];
    NSString* parmDic = [NSString stringWithFormat:@"{\"description\":\"%@\",\"userId\":\"%@\"}",self.discribeText.text,FLFLXJBusinessUserID];
    NSLog(@"parmdic= %@",parmDic);
    NSDictionary* parmUpdate = @{@"compuser":parmDic,@"token":FLFLBusSesssionID};
    
    [FLNetTool updateCompInfoWithParm:parmUpdate success:^(NSDictionary *data) {
        NSLog(@"update bus success = %@ ,",data );
        if ([[data objectForKey:@"info"]isEqualToString:@"success"]) {
            [[FLAppDelegate share]hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FLAppDelegate share] showHUDWithTitile:@"更新成功" view:self.view delay:1 offsetY:0];

                [self.delegate FLDiscribeMyselfViewController:self myDiscription:self.discribeText.text];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [[FLAppDelegate share]hideHUD];
        }
    } failure:^(NSError *error) {
        NSLog(@"update bus error = %@ , %@",error.description , error.debugDescription);
        [[FLAppDelegate share]hideHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        });
    }];
}

- (void)sendToService
{
    [[FLAppDelegate share] showdimBackHUDWithTitle:nil view:self.view];
    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"description\":\"%@\",\"userId\":\"%@\"}",FL_ALL_SESSIONID,self.discribeText.text,FL_USERDEFAULTS_USERID_NEW];
    NSLog(@"parmdic= %@",parmDic);
    NSDictionary* parm = @{@"peruser":parmDic};
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        NSLog(@"上传成功databus dis = %@",data);
        [[FLAppDelegate share]hideHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate FLDiscribeMyselfViewController:self myDiscription:self.discribeText.text];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        NSLog(@"上传失败error = %@, == %@",error.description,error.debugDescription);
        [[FLAppDelegate share]hideHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
           [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.view delay:1 offsetY:0];
        });
    }];
}



#pragma mark textViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    FL_Log(@"textView......====%lu",(unsigned long)textView.text.length);
    //    if (textView.text.length > FLMaxLength) {
    //        textView.text =  [textView.text substringToIndex:FLMaxLength];
    //    }
    //
    NSString *toBeString = textView.text;
    //            NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    NSString* lang = [UIApplication sharedApplication].textInputMode.primaryLanguage;
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView  positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > FLMaxLength) {
                textView.text = [toBeString substringToIndex:FLMaxLength];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > FLMaxLength) {
            textView.text= [toBeString substringToIndex:FLMaxLength];
        }
    }
    _lengthLabel.text  = [NSString stringWithFormat:@"%lu/%d",textView.text.length,FLMaxLength];
    
}









 
@end














