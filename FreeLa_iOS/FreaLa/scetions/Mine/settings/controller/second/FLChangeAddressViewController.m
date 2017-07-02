//
//  FLChangeAddressViewController.m
//  FreeLa
//
//  Created by Leon on 15/11/20.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLChangeAddressViewController.h"
#import "FLHeader.h"
#import "FLTool.h"
#define sessionId   [userdefaults objectForKey:FL_NET_SESSIONID]
#define my_userId   [userdefaults objectForKey:FL_USERDEFAULTS_USERID_KEY]

#define  FLMaxLength    30

@interface FLChangeAddressViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *myAddress;

@property (weak, nonatomic) IBOutlet UILabel *flNumberLabel;

@end

@implementation FLChangeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   self.title = @"地址";
//    self.myAddress.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myAddress.text = _flStr;
    self.myAddress.delegate = self;
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickActionDoneInAddress)];
    self.navigationItem.rightBarButtonItem = item;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChange:)
                                               name:@"UITextFieldTextDidChangeNotification"
                                             object:self.myAddress.text];
}

- (void)clickActionDoneInAddress
{
    if (![FLTool checkLengthWithString:self.myAddress.text length:1 lengthM:FLMaxLength view:self.view who:@"地址"]) {}
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)])
        {
            FL_Log(@"准备回推");
            //传参给服务器
            [self sendAddressToService];
        }
    }

}

- (void)sendAddressToService
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"address\":\"%@\",\"userId\":\"%@\"}",sessionId,self.myAddress.text,my_userId];
    FL_Log(@"parmdic= %@",parmDic);
    NSDictionary* parm = @{@"peruser":parmDic};
    [FLNetTool updatePerWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"上传成功data 3= %@",data);
        if ([data[@"isSuccess"] boolValue]) {
            FL_Log(@"回推");
            [self.delegate FLChangeAddressViewController:self myAddress:self.myAddress.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        FL_Log(@"上传失败error = %@, == %@",error.description,error.debugDescription);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    //字数文本
    self.flNumberLabel.text = [NSString stringWithFormat:@"%lu/%d",self.myAddress.text.length,FLMaxLength];
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
    _flNumberLabel.text  = [NSString stringWithFormat:@"%lu/%d",textView.text.length,FLMaxLength];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                  name:@"UITextFieldTextDidChangeNotification"
                                                object:_myAddress.text];
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
