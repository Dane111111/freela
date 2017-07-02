//
//  FLMoreTextPageViewController.m
//  FreeLa
//
//  Created by Leon on 16/2/16.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMoreTextPageViewController.h"
#import "FLHeader.h"
#import "FLTool.h"


@interface FLMoreTextPageViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *xjtextView;
@property (weak, nonatomic) IBOutlet UILabel *xjnumberLabel;

@end

@implementation FLMoreTextPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _XJtitle;
    //    self.myAddress.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.xjtextView.text = _XJStr;
    self.xjtextView.delegate = self;
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickActionDoneInmorePage)];
    self.navigationItem.rightBarButtonItem = item;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChange:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.xjtextView.text];
}

- (void)clickActionDoneInmorePage
{
    if (self.delegate)
    {
        FL_Log(@"准备回推");
        [self.delegate FLMoreTextPageViewController:self message:self.xjtextView.text];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    //字数文本
    self.xjnumberLabel.text = [NSString stringWithFormat:@"%lu/%ld",self.xjtextView.text.length,_XJMaxLimit];
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
            if(toBeString.length > _XJMaxLimit) {
                textView.text = [toBeString substringToIndex:_XJMaxLimit];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > _XJMaxLimit) {
            textView.text= [toBeString substringToIndex:_XJMaxLimit];
        }
    }
    _xjnumberLabel.text  = [NSString stringWithFormat:@"%lu/%ld",textView.text.length,_XJMaxLimit];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_xjtextView.text];
}




@end























