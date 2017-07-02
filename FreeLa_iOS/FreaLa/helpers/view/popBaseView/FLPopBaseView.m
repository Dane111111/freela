//
//  FLPopBaseView.m
//  FreeLa
//
//  Created by Leon on 15/12/9.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLPopBaseView.h"
#import <Masonry/Masonry.h>
#import "FLHeader.h"

#define flPopBaseViewWith 300
#define flPopBaseViewHeigh 130


@interface FLPopBaseView ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate>

//提示本体
@property (nonatomic,strong) UIView * mainAlert;
//标题及内容
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * detailLabel;
//按钮
@property (nonatomic,strong) UIButton * cancleBtn;
@property (nonatomic,strong) UIButton * ensureBtn;
/**长度*/
@property (nonatomic , assign) NSInteger fllength;

/**文本框的view*/
@property (nonatomic, strong) UIView* xjTextBaseView;
/**分割线+确定+取消*/
@property (nonatomic , strong) UIView* xjBottomView;

@end

static NSInteger _stylefl;
@implementation FLPopBaseView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _isTextField = YES;
//        self = [[FLPopBaseView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//        self.userInteractionEnabled = NO;
        
        //增加屏幕点击手势按钮
        UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flGrayViewGoBack)];
        tapGR.delegate = self;
        [self addGestureRecognizer:tapGR];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChangeInPop)
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
        
    }
    return self;
}

//创建视图
- (id)initWithTitle:(NSString *)title
           delegate:(id)delegate
  andCancleBtnTitle:(NSString *)
cancleTitle andEnsureBtnTitle:(NSString *)ensureTitle
    textFieldLength:(NSInteger)fllength
         lengthType:(FLLengthType)flLengthType
        originalStr:(NSString*)flOriginalStr{
    _isTextField = YES;
    self = [[FLPopBaseView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    self.mainAlert = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.1, [UIScreen mainScreen].bounds.size.height*0.25, [UIScreen mainScreen].bounds.size.width*0.8, 160)];
    self.mainAlert.backgroundColor = [UIColor whiteColor];
    self.mainAlert.layer.cornerRadius = 5.0;
    self.mainAlert.layer.masksToBounds = YES;
    self.mainAlert.backgroundColor = [UIColor colorWithHexString:@"#f8f6f0"];
    
    [self addSubview:self.mainAlert];
    //创建标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.mainAlert.bounds.size.width, 30)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#aea99a"];
    self.titleLabel.text = title;
    [self.mainAlert addSubview:self.titleLabel];
    
    /*
    CGSize detailSize = [self sizeWithStr:message.mutableString andRectWithSize:CGSizeMake(self.mainAlert.bounds.size.width-20, 999) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
    //NSLog(@"detailHeight:%g",detailSize.height);
    //创建详情
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, self.mainAlert.bounds.size.width-20, detailSize.height)];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.attributedText = message;
    [self.mainAlert addSubview:self.detailLabel];
     if (self.mainAlert.bounds.size.height <=detailSize.height+80) {
     self.mainAlert.bounds = CGRectMake(0, 0, self.mainAlert.bounds.size.width, detailSize.height+80);
     }
    */
    
    //文本框view
    UIView* textView = [[UIView alloc] initWithFrame:CGRectMake(20, 54, self.mainAlert.bounds.size.width - 40, 34)];
    textView.backgroundColor =  [UIColor colorWithHexString:@"#f2eddc"];
    textView.layer.borderWidth = 1.0f;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xc5c5c5 & 0xFF0000) >> 16))/255.0, ((float)((0xc5c5c5 & 0xFF0000) >> 16))/255.0, ((float)((0xc5c5c5 & 0xFF0000) >> 16))/255.0, 1 });
    textView.layer.borderColor = colorref;
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    
    
    self.flInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, self.mainAlert.bounds.size.width - 20, 32)];
    self.flInputTextField.font = [UIFont systemFontOfSize:14];
    self.flInputTextField.text = flOriginalStr ? flOriginalStr : @"";
    self.flInputTextField.textAlignment = NSTextAlignmentLeft;
    self.flInputTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.flInputTextField.keyboardType = UIKeyboardTypeDefault;
    self.flInputTextField.borderStyle = UITextBorderStyleNone;
    self.flInputTextField.delegate = self;
    [self.flInputTextField becomeFirstResponder];
    
    
    //    self.flInputTextField.backgroundColor = [UIColor colorWithHexString:@"#f2eddc"];
    [textView addSubview:self.flInputTextField];
    
    [self.mainAlert addSubview:textView];
    //分割线
    UILabel * sepLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.mainAlert.bounds.size.height-45, self.mainAlert.bounds.size.width, 0.5)];
    sepLine1.backgroundColor = [UIColor lightGrayColor];
    [self.mainAlert addSubview:sepLine1];
    
    //创建取消按钮
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancleBtn.frame = CGRectMake(0, self.mainAlert.bounds.size.height-42, self.mainAlert.bounds.size.width/2, 40);
    
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setTitleColor:[UIColor colorWithHexString:@"#aea99a"] forState:UIControlStateNormal];
    [self.mainAlert addSubview:self.cancleBtn];
    
    //创建确认按钮
    self.ensureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.ensureBtn.frame = CGRectMake(self.mainAlert.bounds.size.width/2, self.mainAlert.bounds.size.height-42, self.mainAlert.bounds.size.width/2, 40);
    self.ensureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.ensureBtn setTitleColor:[UIColor colorWithHexString:XJ_FCOLOR_REDFONT] forState:UIControlStateNormal];
    [self.ensureBtn setTitle:ensureTitle forState:UIControlStateNormal];
    [self.ensureBtn addTarget:self action:@selector(ensureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //self.ensureBtn.backgroundColor = [UIColor redColor];
    [self.mainAlert addSubview:self.ensureBtn];
    
    //分割线
    UILabel * sepLine2 = [[UILabel alloc]initWithFrame:CGRectMake(self.mainAlert.bounds.size.width/2, self.mainAlert.bounds.size.height-45, 0.5, 45)];
    sepLine2.backgroundColor = [UIColor lightGrayColor];
    [self.mainAlert addSubview:sepLine2];
    switch (flLengthType) {
        case FLLengthTypeInteger:
            _stylefl = 0;
            break;
        case FLLengthTypeLength:
            _stylefl = 1;
            
            break;
        default:
            break;
    }
    
    self.delegate = delegate;
    self.fllength = fllength;
    
    
    return self;
    
}

- (void)showErrorIfLengthOutWithLength:(NSInteger)fllength
{
    switch (_stylefl) {
        case 0:
            FL_Log(@"THIS IS 数字");
            if ([self.flInputTextField.text integerValue] > fllength) {
                [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"数值不能超过%ld",fllength] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
            }  else if ([self.flInputTextField.text isEqualToString:@""]) {
                self.flInputTextField.text = @"";
                [self.delegate entrueBtnClickWithStr:self.flInputTextField.text];//调用代理
            } else if ([self.flInputTextField.text isEqualToString:@"0"] || [self.flInputTextField.text integerValue]==0    ) {
                self.flInputTextField.text = @"";
                 [[FLAppDelegate share] showHUDWithTitile:@"数值不能为0" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
            }else {
                [self.delegate entrueBtnClickWithStr:self.flInputTextField.text];//调用代理
            }
            break;
        case 1:
        {
            if (_isTextField) {
                if (self.flInputTextField.text.length  > fllength) {
                    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"数量不能超过%ld",fllength] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                } else if ([self.flInputTextField.text isEqualToString:@""]){
                    [[FLAppDelegate share] showHUDWithTitile:@"不能为空" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                } else {
                    [self.delegate entrueBtnClickWithStr:self.flInputTextField.text];//调用代理
                }
            } else {
                if (self.xjTextView.text.length  > fllength) {
                    [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"数量不能超过%ld",fllength] view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                } else if ([self.xjTextView.text isEqualToString:@""]){
                    [[FLAppDelegate share] showHUDWithTitile:@"不能为空" view:FL_KEYWINDOW_VIEW_NEW delay:1 offsetY:0];
                } else {
                    [self.delegate entrueBtnClickWithStr:self.xjTextView.text];//调用代理
                }
            }
            
        }
            break;
            
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect{
   
}

- (void)cancleBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
//    [self.delegate canaleBtnClick];//调用代理
}

- (void)ensureBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
    [self showErrorIfLengthOutWithLength:_fllength ];
   
}
- (void)ensureBtnClickWithTextView:(UIButton*)btn
{
    FL_Log(@"congzheli diaoyong daiili");
    [self removeFromSuperview];
    [self showErrorIfLengthOutWithLength:_fllength];
}

//字符串的长度（自适应用）
-(CGSize)sizeWithStr:(NSString *)textStr andRectWithSize:(CGSize)size withAttributes:(NSDictionary *)dict
{
    
    CGSize textSize;
    textSize = [textStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return textSize;
    
}
#pragma  mark  delegate
/**返回*/
- (void)flGrayViewGoBack
{
    [self removeFromSuperview];
}

- (void)textFieldDidChangeInPop
{
    
    switch (_stylefl) {
        case 0:
        {
            FL_Log(@" THIS ISS 数字 == %@",self.flInputTextField.text);
            if([self.flInputTextField.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
            {
                NSUInteger location = [self.flInputTextField.text rangeOfString:@"."].location ;
                FL_Log(@" THIS ISS location == %lu",location);
                if (location <= 6) {
                    NSString* num1 = [self.flInputTextField.text substringToIndex:location + 1];
                    NSString* num2 = [self.flInputTextField.text substringWithRange:NSMakeRange(location + 1, self.flInputTextField.text.length - location - 1)];
                    if([num2 rangeOfString:@"."].location !=NSNotFound)
                    {
//                        num2 = @"";
                        NSUInteger location3 = [self.flInputTextField.text rangeOfString:@"."].location ;
                        FL_Log(@" THIS ISS location3 == %lu",location3);
                        num2 = [num2 substringToIndex:location3 - 1];
                        self.flInputTextField.text = [NSString stringWithFormat:@"%@%@",num1,num2];
                    } else {
                        FL_Log(@" THIS ISS number2 == %@",num2);
                        FL_Log(@" THIS ISS number1 == %@",num1);
                        if (self.flInputTextField.text.length >= location + 3) {
                            NSString* num2 = [self.flInputTextField.text substringWithRange:NSMakeRange(location + 1, 2)];
                            FL_Log(@" THIS ISS number2 == %@",num2);
                            self.flInputTextField.text = [NSString stringWithFormat:@"%@%@",num1,num2];
                        }
                    }
                }
                
            } else {
                if (self.flInputTextField.text.length >= 6) {
                    self.flInputTextField.text = [self.flInputTextField.text substringToIndex:6];
                }
            }
            
        }
            break;
        case 1:
        {
            
            NSString *toBeString = self.flInputTextField.text;
//            NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
            NSString* lang = [UIApplication sharedApplication].textInputMode.primaryLanguage;
            if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
                UITextRange *selectedRange = [self.flInputTextField markedTextRange];
                //获取高亮部分
                UITextPosition *position = [self.flInputTextField  positionFromPosition:selectedRange.start offset:0];
                //没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if(!position) {
                    if(toBeString.length > self.fllength) {
                        self.flInputTextField.text = [toBeString substringToIndex:self.fllength];
                    }
                }
                //有高亮选择的字符串，则暂不对文字进行统计和限制
                else{
                    
                }
            }
            //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            else{
                if(toBeString.length > self.fllength) {
                    self.flInputTextField.text= [toBeString substringToIndex:self.fllength];
                }
            }
        }
            break;
            
        default:
            break;
    }


}

#pragma mark textview
- (id)initWithTitle:(NSString*)xjtitle
           delegate:(id)delegate
             length:(NSInteger)xjlength
         lengthType:(FLLengthType)xjLengthType
        originalStr:(NSString*)xjoriginalStr
{
    _isTextField = NO;
    self = [[FLPopBaseView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    self.mainAlert = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.1, [UIScreen mainScreen].bounds.size.height*0.25, [UIScreen mainScreen].bounds.size.width*0.8, 160)];
    self.mainAlert.backgroundColor = [UIColor whiteColor];
    self.mainAlert.layer.cornerRadius = 5.0;
    self.mainAlert.layer.masksToBounds = YES;
    self.mainAlert.backgroundColor = [UIColor colorWithHexString:@"#f8f6f0"];
    
    [self addSubview:self.mainAlert];
    //创建标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.mainAlert.bounds.size.width, 30)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#aea99a"];
    self.titleLabel.text = xjtitle;
    [self.mainAlert addSubview:self.titleLabel];
    
    /*
     CGSize detailSize = [self sizeWithStr:message.mutableString andRectWithSize:CGSizeMake(self.mainAlert.bounds.size.width-20, 999) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
     //NSLog(@"detailHeight:%g",detailSize.height);
     //创建详情
     self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, self.mainAlert.bounds.size.width-20, detailSize.height)];
     self.detailLabel.font = [UIFont systemFontOfSize:14];
     self.detailLabel.textAlignment = NSTextAlignmentCenter;
     self.detailLabel.numberOfLines = 0;
     self.detailLabel.attributedText = message;
     [self.mainAlert addSubview:self.detailLabel];
     if (self.mainAlert.bounds.size.height <=detailSize.height+80) {
     self.mainAlert.bounds = CGRectMake(0, 0, self.mainAlert.bounds.size.width, detailSize.height+80);
     }
     */
    
    //文本框view
    _xjTextBaseView = [[UIView alloc] initWithFrame:CGRectMake(20, 54, self.mainAlert.bounds.size.width - 40, 34)];
    _xjTextBaseView.backgroundColor =  [UIColor colorWithHexString:@"#f2eddc"];
    _xjTextBaseView.layer.borderWidth = 1.0f;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xc5c5c5 & 0xFF0000) >> 16))/255.0, ((float)((0xc5c5c5 & 0xFF0000) >> 16))/255.0, ((float)((0xc5c5c5 & 0xFF0000) >> 16))/255.0, 1 });
    _xjTextBaseView.layer.borderColor = colorref;
    _xjTextBaseView.layer.cornerRadius = 5;
    _xjTextBaseView.layer.masksToBounds = YES;
    
    
    self.xjTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 2, self.mainAlert.bounds.size.width - 20, 32)];
    self.xjTextView.font = [UIFont systemFontOfSize:14];
    self.xjTextView.text = xjoriginalStr ? xjoriginalStr : @"";
    self.xjTextView.delegate = self;
    self.xjTextView.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    
    
//    self.flInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, self.mainAlert.bounds.size.width - 20, 32)];
//    self.flInputTextField.font = [UIFont systemFontOfSize:14];
//    self.flInputTextField.text = xjoriginalStr ? xjoriginalStr : @"";
//    self.flInputTextField.textAlignment = NSTextAlignmentLeft;
//    self.flInputTextField.borderStyle = UITextBorderStyleRoundedRect;
//    self.flInputTextField.keyboardType = UIKeyboardTypeDefault;
//    self.flInputTextField.borderStyle = UITextBorderStyleNone;
//    self.flInputTextField.delegate = self;
//    [self.flInputTextField becomeFirstResponder];
    
    //    self.flInputTextField.backgroundColor = [UIColor colorWithHexString:@"#f2eddc"];
    [_xjTextBaseView addSubview:self.xjTextView];
    
    [self.mainAlert addSubview:_xjTextBaseView];
    self.xjBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainAlert.bounds.size.height-45, self.mainAlert.bounds.size.width, 45)];
    [self.mainAlert addSubview:_xjBottomView];
    //分割线
    UILabel * sepLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.mainAlert.bounds.size.width, 0.5)];
    sepLine1.backgroundColor = [UIColor lightGrayColor];
    [self.xjBottomView addSubview:sepLine1];
    
    //创建取消按钮
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancleBtn.frame = CGRectMake(0, 3, self.mainAlert.bounds.size.width/2, 40);
    
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setTitleColor:[UIColor colorWithHexString:@"#aea99a"] forState:UIControlStateNormal];
    [self.xjBottomView addSubview:self.cancleBtn];
    
    //创建确认按钮
    self.ensureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.ensureBtn.frame = CGRectMake(self.mainAlert.bounds.size.width/2, 3, self.mainAlert.bounds.size.width/2, 40);
    self.ensureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.ensureBtn setTitleColor:[UIColor colorWithHexString:XJ_FCOLOR_REDFONT] forState:UIControlStateNormal];
    [self.ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.ensureBtn addTarget:self action:@selector(ensureBtnClickWithTextView:) forControlEvents:UIControlEventTouchUpInside];
    //self.ensureBtn.backgroundColor = [UIColor redColor];
    [self.xjBottomView addSubview:self.ensureBtn];
    
    //分割线
    UILabel * sepLine2 = [[UILabel alloc]initWithFrame:CGRectMake(self.mainAlert.bounds.size.width/2, 0, 0.5, 45)];
    sepLine2.backgroundColor = [UIColor lightGrayColor];
    [self.xjBottomView addSubview:sepLine2];
    switch (xjLengthType) {
        case FLLengthTypeInteger:
        _stylefl = 0;
        break;
        case FLLengthTypeLength:
        _stylefl = 1;
        
        break;
        default:
        break;
    }
    
    self.delegate = delegate;
    self.fllength = xjlength;
    return self;
}

#pragma mark textView delegate
- (void)textViewDidChange:(UITextView *)textView
{
     FL_Log(@"this is textView.text =%@",textView.text);
    [self aaaWithTextView:self.xjTextView.text];
    CGSize xjsize = [self.xjTextView.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL]}];
    if (xjsize.width > self.mainAlert.width - 20) {
        CGFloat ff = xjsize.width / (self.mainAlert.width - 20);
//        FL_Log(@"ffffffffffff=%f",ff);
        NSString* floatStr = [NSString stringWithFormat:@"%f",ff];
        if ([floatStr rangeOfString:@"."].location != NSNotFound) {
            NSInteger index =  [floatStr rangeOfString:@"."].location;
            floatStr = [floatStr substringToIndex:index];
        }
        NSInteger howLines = [floatStr integerValue] + 1;
        FL_Log(@"this is how lines =%ld",howLines);
        CGRect frame;
        // 整体 [UIScreen mainScreen].bounds.size.width*0.1, [UIScreen mainScreen].bounds.size.height*0.25, [UIScreen mainScreen].bounds.size.width*0.8, 160)
        frame.origin.x = FLUISCREENBOUNDS.width * 0.1;
        frame.origin.y = FLUISCREENBOUNDS.height * 0.25 - howLines * 6;
        frame.size.width = FLUISCREENBOUNDS.width * 0.8;
        frame.size.height = 160 + howLines * 12;
        self.mainAlert.frame = frame;
        // 底部按钮 (0, self.mainAlert.bounds.size.height-45, self.mainAlert.bounds.size.width, 45)
        frame.origin.x = 0;
        frame.origin.y = 160 + howLines * 12 - 45;
        frame.size.width = FLUISCREENBOUNDS.width * 0.8;
        frame.size.height = 45;
        self.xjBottomView.frame = frame;
        // 文本框    [UIView alloc] initWithFrame:CGRectMake(20, 54, self.mainAlert.bounds.size.width - 40, 34)
        frame.origin.x = 20;
        frame.origin.y = 54;
        frame.size.width = FLUISCREENBOUNDS.width * 0.8 - 40;
        frame.size.height = 34 + howLines * 12;
        _xjTextBaseView.frame = frame;
        //textview
        frame.origin.x = 0;
        frame.origin.y = 2;
        frame.size.width = FLUISCREENBOUNDS.width * 0.8 - 40;
        frame.size.height = 30 + howLines * 12;
        self.xjTextView.frame = frame; 
    }
}

- (void)aaaWithTextView:(NSString*)xjStr
{
    NSString *toBeString = xjStr;
    //            NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    NSString* lang = [UIApplication sharedApplication].textInputMode.primaryLanguage;
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self.xjTextView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self.xjTextView  positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > self.fllength) {
                self.xjTextView.text = [toBeString substringToIndex:self.fllength];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > self.fllength) {
            self.xjTextView.text= [toBeString substringToIndex:self.fllength];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end




