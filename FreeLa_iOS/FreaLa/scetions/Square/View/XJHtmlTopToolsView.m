//
//  XJHtmlTopToolsView.m
//  FreeLa
//
//  Created by Leon on 16/4/8.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJHtmlTopToolsView.h"

#define xjMiddleW   10
#define xjBtnWH     40

@implementation XJHtmlTopToolsView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.xjGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.xjCollectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.xjShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self xjInitPageInTopTools];
    }
    return self;
}

- (void)xjInitPageInTopTools
{
    self.xjGoBackBtn.frame = CGRectMake(xjMiddleW, 0, xjBtnWH, xjBtnWH);
    self.xjShareBtn.frame = CGRectMake(FLUISCREENBOUNDS.width - (xjMiddleW + xjBtnWH)* 2  , 0, xjBtnWH, xjBtnWH);
//    self.xjCollectionBtn.frame = CGRectMake(FLUISCREENBOUNDS.width - (xjMiddleW + xjBtnWH)* 1, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
}



@end
