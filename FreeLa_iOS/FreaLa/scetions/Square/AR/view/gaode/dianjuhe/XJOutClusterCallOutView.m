//
//  XJOutClusterCallOutView.m
//  FreeLa
//
//  Created by Leon on 2017/1/5.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJOutClusterCallOutView.h"

@interface XJOutClusterCallOutView ()
@property (nonatomic , strong) UILabel* xjLabel;
@end

@implementation XJOutClusterCallOutView

- (void)dismissCalloutView
{
    [self removeFromSuperview];
}

#pragma mark - Initialization

- (UILabel *)xjLabel {
    if (!_xjLabel) {
        _xjLabel = [[UILabel alloc] init];
    }
    return _xjLabel;
}

- (instancetype)init{
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, 100, 50);
        [self xj_initPage];
    }
    return self;
}

- (void)xj_initPage {
    
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIImageView*bgImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ditu_duihuakuang"]];
    bgImageV.contentMode=UIViewContentModeScaleToFill;
    [self addSubview:bgImageV];
    [self addSubview:self.xjLabel];
    [self.xjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    self.xjLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    self.xjLabel.textAlignment = NSTextAlignmentCenter;
    self.xjLabel.textColor = [UIColor redColor];
    self.xjLabel.numberOfLines = 2;
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xjLabel).offset(-7);
        make.top.equalTo(self.xjLabel).offset(-7);
        make.right.equalTo(self.xjLabel).offset(7);
        make.bottom.equalTo(self.xjLabel).offset(15);

    }];
    UIButton* xjbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xjbtn.frame = self.bounds;
    [self addSubview:xjbtn];
    [xjbtn addTarget:self action:@selector(xjclick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)setTopic:(NSString *)topic{
    _topic=topic;
    self.xjLabel.text = topic;
    if (topic.length>8) {
        [self.xjLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@80);
        }];

    }

}
- (void)setXjCount:(NSInteger)xjCount {
    _xjCount = xjCount;
    self.xjLabel.text = [NSString stringWithFormat:@"那儿的%ld个礼物离你较远，走近领取",xjCount];
}

- (void)xjclick {
//    [self dismissCalloutView];
}

@end








