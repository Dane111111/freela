//
//  XJSaoChangePlaceSecondView.m
//  FreeLa
//
//  Created by Collegedaily on 2017/5/2.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJSaoChangePlaceSecondView.h"

@implementation XJSaoChangePlaceSecondView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
        [self xj_createNoresultView];
    }
    return self;
}

- (void)xj_createNoresultView {
    
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ar_icon_white"]];
    [self addSubview:img];
    img.frame = CGRectMake(0, 0, 40, 40);
    img.center = CGPointMake(self.centerX, self.centerY-130);
    
    
    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 300, 40);
    label.center = CGPointMake(self.centerX, self.centerY-60);
    [self addSubview:label];
    label.text = @"本次扫描没有结果";
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font = [UIFont fontWithName:FL_FONT_NAME size:20];
    
    
    UILabel* xj_un = [[UILabel alloc] init];
    xj_un.frame = CGRectMake(0, 0, 200, 40);
    xj_un.center = CGPointMake(self.centerX, self.centerY - 10);
    [self addSubview:xj_un];
    [xj_un setTextAlignment:NSTextAlignmentCenter];
    xj_un.text = @"注意扫描的角度和距离哦";
    xj_un.textColor = [UIColor whiteColor];
    xj_un.font = [UIFont fontWithName:FL_FONT_NAME size:18];
    
    UIButton* xjb = [UIButton buttonWithType:UIButtonTypeCustom];
    [xjb setTitle:@"点击重试" forState:UIControlStateNormal];
    xjb.frame = CGRectMake(0, 0, 100, 40);
    xjb.center = CGPointMake(self.centerX, self.centerY + 100);
    xjb.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:16];
    [xjb setTitleColor:[UIColor colorWithHexString:XJ_FCOLOR_REDFONT] forState:UIControlStateNormal];
    [self addSubview:xjb];
    [xjb addTarget:self action:@selector(xj_clickToReSao) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)xj_clickToReSao{
    if (self.block!=nil){
        self.block();
    }
}
- (void)xjClickToReSao:(xjClickToReSao)block{
    _block = block;
}

@end
