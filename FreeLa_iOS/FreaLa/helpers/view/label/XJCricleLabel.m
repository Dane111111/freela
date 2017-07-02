//
//  XJCricleLabel.m
//  FreeLa
//
//  Created by Leon on 16/5/26.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJCricleLabel.h"


@interface XJCricleLabel()
@property (nonatomic , strong) UIView* xjBottomView;
@property (nonatomic , strong) UILabel* xjLabel;
@end

@implementation XJCricleLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self xjInitPage];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xjInitPage];
    }
    return self;
}

- (void)xjInitPage {
    self.xjBottomView = [[UIView alloc] init];
    self.xjLabel = [[UILabel alloc]init ];
    [self addSubview:self.xjBottomView];
    [self.xjBottomView addSubview:self.xjLabel];
}

- (void)setXjContentStr:(NSString *)xjContentStr{
    _xjContentStr = xjContentStr;
    CGSize sizeM = [xjContentStr sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FL_FONT_NAME size:self.xjFontSize ? self.xjFontSize : XJ_LABEL_SIZE_SMALL]}];
    self.xjBottomView.frame = CGRectMake(0, 0, sizeM.width + 12, sizeM.height + 8);
    self.xjLabel.frame = CGRectMake(6, 4, sizeM.width, sizeM.height);
    if (self.frame.size.width > sizeM.width) {
//        self.xjBottomView.frame = self.frame;
//        self.xjLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    self.xjBottomView.layer.cornerRadius = self.xjBottomView.height / 2;
    self.xjBottomView.layer.masksToBounds = YES;
    self.xjBottomView.layer.borderWidth = _xjBorderColor ? 1 : 0;
    self.xjLabel.text = xjContentStr;
    self.xjLabel.textAlignment = NSTextAlignmentCenter;
    self.xjLabel.font = [UIFont fontWithName:FL_FONT_NAME size:self.xjFontSize ? self.xjFontSize : XJ_LABEL_SIZE_SMALL];
    self.xjLabel.textColor = _xjTextColor ? _xjTextColor : [UIColor blackColor];
    self.xjBottomView.layer.borderColor = _xjBorderColor ? _xjBorderColor.CGColor : [UIColor whiteColor].CGColor;
}

- (void)setXjBorderColor:(UIColor *)xjBorderColor {
    _xjBorderColor = xjBorderColor;
    self.xjBottomView.layer.borderWidth = 1;
    self.xjBottomView.layer.borderColor = xjBorderColor.CGColor;
}
- (void)setXjTextColor:(UIColor *)xjTextColor{
    _xjTextColor = xjTextColor;
    self.xjLabel.textColor = xjTextColor;
}

- (void)setXjBackgroundColor:(UIColor *)xjBackgroundColor{
    _xjBackgroundColor = xjBackgroundColor;
    self.xjBottomView.backgroundColor = xjBackgroundColor;
}

 
@end



