//
//  XJGiftAddReceiveInfoView.m
//  FreeLa
//
//  Created by Leon on 2017/1/15.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJGiftAddReceiveInfoView.h"

@interface XJGiftAddReceiveInfoView ()
@property (nonatomic , strong) UITextField* xjName;
@property (nonatomic , strong) UITextField* xjPhone;
@property (nonatomic , strong) UITextField* xjAddress;
@end

@implementation XJGiftAddReceiveInfoView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        imageView.image = [UIImage imageNamed:@"ar_bg"];
        [self addSubview:imageView];
        [self xj_createReceiveView];
    }
    return self;
}

- (void)xj_createReceiveView{
    
    NSArray* titleArr = @[@"姓名",@"电话",@"地址"];
    
    CGFloat  xj_labelX = 20;
    CGFloat  xj_labelH = 40;
    CGFloat  xj_labelW = 60;
    
    UIView* xjview = [[UIView alloc] init];
    xjview.frame = CGRectMake(0, 40, self.width, self.height-40);
    [self addSubview:xjview];
    
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIView* baseView = [[UIView alloc] init];
        baseView.frame = CGRectMake(0,40 + xj_labelH*i , self.width-20, xj_labelH);
        [xjview addSubview:baseView];
        //label
        UILabel* xjlabel = [[UILabel alloc] init];
        xjlabel.font = [UIFont fontWithName:FL_FONT_NAME size:14];
        xjlabel.textColor = [UIColor whiteColor];
        xjlabel.textAlignment = NSTextAlignmentCenter;
        xjlabel.frame = CGRectMake( 20, 0, xj_labelW, xj_labelH);
        [baseView addSubview:xjlabel];
        xjlabel.text = titleArr[i];
        
        UITextField* xjtex = [[UITextField alloc] init];
        [baseView  addSubview:xjtex];
        xjtex.font = [UIFont fontWithName:FL_FONT_NAME size:14];
        xjtex.textColor = [UIColor whiteColor];
        xjtex.textAlignment = NSTextAlignmentLeft;
        xjtex.frame = CGRectMake(xj_labelX*2 + xj_labelW, 3, self.width - xj_labelX*4 - xj_labelW, xj_labelH-2*3);
        xjtex.placeholder = titleArr[i];
        [xjtex setBackground:[UIImage imageNamed:@"ar_textfield_bg"]];
        xjtex.returnKeyType = UIReturnKeyDone;
        [KeyboardToolBar registerKeyboardToolBar:xjtex];
        if (i==0) {
            self.xjName = xjtex;
        }else if(i==1){
            self.xjPhone = xjtex;
            xjtex.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            self.xjAddress = xjtex;
        }
    }
    UIButton* donebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xjview addSubview:donebtn];
    donebtn.frame = CGRectMake(self.width*0.25, self.height-140, self.width*0.5, 50);
    [donebtn setTitle:@"完成" forState:UIControlStateNormal];
    [donebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [donebtn setBackgroundImage:[UIImage imageNamed:@"ar_buttonbg"] forState:UIControlStateNormal];
    [donebtn addTarget:self action:@selector(xj_clickToCheckAddInfo) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)xj_clickToCheckAddInfo{
    if (![XJFinalTool xjStringSafe:self.xjName.text]) {
        [FLTool showWith:@"姓名不能为空"];
    }else if (![XJFinalTool xjStringSafe:self.xjPhone.text]){
        [FLTool showWith:@"联系方式不能为空"];
    }else if (![XJFinalTool xjStringSafe:self.xjAddress.text]){
        [FLTool showWith:@"地址不能为空"];
    }else {
        NSDictionary* xjZ = @{@"姓名":self.xjName.text,
                              @"电话":self.xjPhone.text,
                              @"地址":self.xjAddress.text};
        NSDictionary* xjY = @{@"NAME":self.xjName.text,
                              @"TEL":self.xjPhone.text,
                              @"ADDRESS":self.xjAddress.text};
        NSArray* arr = @[xjZ,xjY];
        NSString* xjxj = [FLTool xj_returnJsonWithObj:arr];
        if ([XJFinalTool xjStringSafe:xjxj]) {
            if (self.block!=nil) {
                self.block(xjxj);
            }
        };
    }
}

- (void)xj_ReturnReceiveInfo:(xjReturnReceiveInfoBlock)block {
    self.block = block;
}

@end



