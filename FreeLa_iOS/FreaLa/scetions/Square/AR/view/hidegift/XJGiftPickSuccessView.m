//
//  XJGiftPickSuccessView.m
//  FreeLa
//
//  Created by Leon on 2017/1/8.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJGiftPickSuccessView.h"

@interface XJGiftPickSuccessView ()

@end


@implementation XJGiftPickSuccessView

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

- (UILabel *)xj_NickNameL {
    if (!_xj_NickNameL) {
        _xj_NickNameL = [[UILabel alloc] init];
        _xj_NickNameL.font = [UIFont fontWithName:FL_FONT_NAME size:12];
        _xj_NickNameL.textColor = [UIColor whiteColor];
        _xj_NickNameL.textAlignment = NSTextAlignmentCenter;
    }
    return _xj_NickNameL;
}
- (UILabel *)xj_TopicThemeL {
    if (!_xj_TopicThemeL) {
        _xj_TopicThemeL = [[UILabel alloc] init];
        _xj_TopicThemeL.font = [UIFont fontWithName:FL_FONT_NAME size:12];
        _xj_TopicThemeL.textColor = [UIColor whiteColor];
        _xj_TopicThemeL.textAlignment = NSTextAlignmentCenter;
    }
    return _xj_TopicThemeL;
}
- (UIImageView *)xj_TopicImgView{
    if (!_xj_TopicImgView) {
        _xj_TopicImgView = [[UIImageView alloc] init];
    }
    return _xj_TopicImgView;
}

- (void)xj_createBaseView {
    //title
    //    self.xj_title_label.text = @"藏礼包";
    [self xj_createMainViewForDone];
}

- (void)xj_createMainViewForDone{
    
    CGFloat xj_img_w =  60;
    CGFloat xj_img_x =  (self.width/2)-30;
    self.xj_imageView = [[UIImageView alloc] init];
    self.xj_imageView.frame = CGRectMake(xj_img_x, 60, xj_img_w, xj_img_w);
    [self addSubview:self.xj_imageView];
    self.xj_imageView.layer.borderColor=DE_headerBorderColor.CGColor;
    self.xj_imageView.layer.borderWidth=DE_headerBorderWidth;

    self.xj_imageView.image = [UIImage imageNamed:@"xj_default_avator"];
    self.xj_imageView.layer.cornerRadius = xj_img_w/2;
    self.xj_imageView.layer.masksToBounds = YES;
    
    [self.xj_imageView sd_setImageWithURL:[NSURL URLWithString:[XJFinalTool xjReturnImageURLWithStr:[[XJUserAccountTool share] xj_getUserAvatar] isSite:NO]]];
    
    
    //昵称
    CGRect xj_nickname = self.xj_imageView.frame;
    xj_nickname.origin.x = 0;
    xj_nickname.origin.y += (10 + xj_nickname.size.height);
    xj_nickname.size.width = self.width;
    xj_nickname.size.height = 20;
    self.xj_NickNameL.frame = xj_nickname;
    self.xj_NickNameL.text = [[XJUserAccountTool share] xj_getUserName];
    [self addSubview:self.xj_NickNameL];
    
    //主题
    CGRect xj_topTheme = xj_nickname;
    xj_topTheme.origin.x = 20;
    xj_topTheme.origin.y += 30;
    xj_topTheme.size.width = self.width-40;
    xj_topTheme.size.height = 40;
    self.xj_TopicThemeL.frame = xj_topTheme;
    self.xj_TopicThemeL.text = @"这里是他么的主题呀主题";
    self.xj_TopicThemeL.numberOfLines = 2;
//    self.xj_TopicThemeL.backgroundColor = [UIColor redColor];
    [self addSubview:self.xj_TopicThemeL];
    
    //缩略图
    CGRect xj_topThemeImg = xj_topTheme;
    xj_topThemeImg.origin.x = 0;
    xj_topThemeImg.origin.y  =  0;
    xj_topThemeImg.size.width = self.width*0.8;
    xj_topThemeImg.size.height = self.width*0.8;
    self.xj_TopicImgView.frame = xj_topThemeImg;
    self.xj_TopicImgView.center = CGPointMake(self.centerX, xj_topTheme.origin.y+140);
    self.xj_TopicImgView.backgroundColor = [UIColor redColor];
    [self addSubview:self.xj_TopicImgView];
    
    //完成按钮
    UIButton* xjDone = [UIButton buttonWithType: UIButtonTypeCustom];
    [xjDone setBackgroundImage:[UIImage imageNamed:@"ar_buttonbg"] forState:UIControlStateNormal];
    [xjDone setTitle:@"查看票券" forState:UIControlStateNormal];
    [xjDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [xjDone addTarget:self action:@selector(xj_clickDone) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect xj_done ;//= canghaole;
    xj_done.origin.x = (self.width/2)-70;
    xj_done.origin.y = self.height - 90;
    xj_done.size.width = 140;
    xj_done.size.height = 50;
    xjDone.frame = xj_done;
    [self addSubview:xjDone];
 
}

- (void)xj_clickDone {
    if (self.block != nil) {
        self.block();
    }
}

- (void)xj_findGiftSuccessDone:(xjPickSucessDoneAction)block {
    _block = block;
}

@end
