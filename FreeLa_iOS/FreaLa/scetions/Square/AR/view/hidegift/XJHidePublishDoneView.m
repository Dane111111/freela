//
//  XJHidePublishDoneView.m
//  FreeLa
//
//  Created by Leon on 2017/1/8.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJHidePublishDoneView.h"
#import "UIViewController+LewPopupViewController.h"

@interface XJHidePublishDoneView ()
@property (nonatomic , strong) UILabel* xj_title_label;

@property (nonatomic , strong) UIImageView* xj_imageView;


@end

@implementation XJHidePublishDoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        imageView.image = [UIImage imageNamed:@"ar_bg"];
        [self addSubview:imageView];
        [self xj_createBaseView];
    }
    return self;
}

- (UILabel *)xj_title_label {
    if (!_xj_title_label) {
        _xj_title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.width, 15)];
        _xj_title_label.font = [UIFont fontWithName:FL_FONT_NAME size:14];
        _xj_title_label.textAlignment = NSTextAlignmentCenter;
        _xj_title_label.textColor = [UIColor whiteColor];
        [self addSubview:_xj_title_label];
    }
    return _xj_title_label;
}


- (void)xj_createBaseView {
    //title
//    self.xj_title_label.text = @"藏礼包";
    [self xj_createMainViewForDone];
}

- (void)xj_createMainViewForDone{
    
    CGFloat xj_img_w =  (self.width-60);
    self.xj_imageView = [[UIImageView alloc] init];
    self.xj_imageView.frame = CGRectMake(30, 40, xj_img_w, xj_img_w);
//    [self addSubview:self.xj_imageView];
    self.xj_imageView.image = [UIImage imageNamed:@"ar_hidesuccess_kkbg"];
    
    self.xj_topicThemImgView =  [[UIImageView alloc] init];
    [self addSubview:self.xj_topicThemImgView];
    self.xj_topicThemImgView.frame = CGRectMake(40, 50, xj_img_w-20, xj_img_w-40);
    self.xj_topicThemImgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
//    self.xj_topicThemImgView.image = [UIImage imageNamed:@""];
    
    _xj_addressLabel = [[UILabel alloc] init];
    _xj_addressLabel.textColor = [UIColor whiteColor];
//    _xj_addressLabel.text = @"地址";
    _xj_addressLabel.textAlignment = NSTextAlignmentCenter;
    _xj_addressLabel.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    _xj_addressLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    _xj_addressLabel.layer.cornerRadius = 15;
    _xj_addressLabel.layer.masksToBounds = YES;
    _xj_addressLabel.frame = CGRectMake((self.width/2)-80, self.xj_imageView.height+self.xj_imageView.y-48, 160, 30);
    [self addSubview:_xj_addressLabel];
    
    //藏好啦
    UILabel* mb = [[UILabel alloc] init];
    mb.text = @"藏好啦~";
    mb.textColor = [UIColor whiteColor];
    mb.textAlignment = NSTextAlignmentCenter;
    mb.font = [UIFont fontWithName:FL_FONT_NAME size:18];
    CGRect canghaole = self.xj_imageView.frame;
    canghaole.origin.x = 20 ;
    canghaole.origin.y =  (40 + canghaole.size.height);
    canghaole.size.width = self.width-40;
    canghaole.size.height = 24;
    [self addSubview:mb];
    mb.frame = canghaole;
    
    
    //到藏宝位置，按线索图扫描即可寻宝
    UILabel* nidaye = [[UILabel alloc] init];
    nidaye.text = @"到藏宝位置，按线索图扫描即可寻宝";
    nidaye.textColor = [UIColor whiteColor];
    nidaye.textAlignment = NSTextAlignmentCenter;
    nidaye.font = [UIFont fontWithName:FL_FONT_NAME size:14];
    CGRect nidayede = canghaole;
    nidayede.origin.x = 20 ;
    nidayede.origin.y +=  34 ;
    nidayede.size.width = self.width-40;
    nidayede.size.height = 24;
    [self addSubview:nidaye];
    nidaye.frame = nidayede;
    
    
    //喊人来找
    UIButton* xjShre = [UIButton buttonWithType: UIButtonTypeCustom];
    [xjShre setBackgroundImage:[UIImage imageNamed:@"ar_buttonbg"] forState:UIControlStateNormal];
    [xjShre setTitle:@"喊人来找" forState:UIControlStateNormal];
    [xjShre setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [xjShre addTarget:self action:@selector(xj_clickToShre) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect xjshare = nidayede;
    xjshare.origin.x = (self.width/2)-70;
    xjshare.origin.y += 35;
    xjshare.size.width = 140;
    xjshare.size.height = 50;
    xjShre.frame = xjshare;
    [self addSubview:xjShre];
    
    //完成
    UIButton* xjDone = [UIButton buttonWithType: UIButtonTypeCustom];
    [xjDone setBackgroundImage:[UIImage imageNamed:@"ar_buttonbg"] forState:UIControlStateNormal];
    [xjDone setTitle:@"完成" forState:UIControlStateNormal];
    [xjDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [xjDone addTarget:self action:@selector(xj_clickDone) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect xj_done = xjshare;
    xj_done.origin.x = (self.width/2)-70;
    xj_done.origin.y += 60;
    xj_done.size.width = 140;
    xj_done.size.height = 50;
    xjDone.frame = xj_done;
    [self addSubview:xjDone];
}

- (void)xjClickToShareGift:(xjClickToShre)block {
    _block = block;
}

- (void)xj_clickToShre {
    if (self.block!=nil) {
        self.block();
    }
}

- (void)xj_clickDone {
     [self.parentVC lew_dismissPopupView];
}

@end







