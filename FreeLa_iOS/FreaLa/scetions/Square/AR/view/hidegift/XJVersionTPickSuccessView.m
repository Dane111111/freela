//
//  XJVersionTPickSuccessView.m
//  FreeLa
//
//  Created by Leon on 2017/1/19.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJVersionTPickSuccessView.h"
#import "WMPlayer.h"

@interface XJVersionTPickSuccessView ()

@end

@implementation XJVersionTPickSuccessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景
//        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//        imageView.image = [UIImage imageNamed:@"ar_bg"];
//        [self addSubview:imageView];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self xj_createBaseView];
    }
    return self;
}

- (WMPlayer *)xjPlayView {
    if (!_xjPlayView) {
        CGRect playerFrame =   self.xj_TopicImgView.frame;
        _xjPlayView = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:@""];
        _xjPlayView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self bringSubviewToFront:_xjPlayView];
        [self addSubview:_xjPlayView];
    }
    return _xjPlayView;
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
        _xj_TopicThemeL.font = [UIFont fontWithName:FL_FONT_NAME size:14];
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
    
    UIView* base = [[UIView alloc] init];
    [self addSubview:base];
    base.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
    
    //索勒图
    CGRect xj_topThemeImg ;
    xj_topThemeImg.origin.x = 0;
    xj_topThemeImg.origin.y  = 0;
    xj_topThemeImg.size.width = self.width * 0.8;
    xj_topThemeImg.size.height = self.width * 0.8;
    self.xj_TopicImgView.frame = xj_topThemeImg;
    self.xj_TopicImgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.xj_TopicImgView.center = CGPointMake(self.centerX, (self.width*0.8/2)+40);
    [base addSubview:self.xj_TopicImgView];
    self.xj_TopicImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    //播放视频的位置
    self.xjPlayView.hidden = YES;
    [base addSubview:self.xjPlayView];
    
    //主题
    CGRect xj_topTheme = self.xj_TopicImgView.frame;
    xj_topTheme.origin.x = 20;
    xj_topTheme.origin.y += (10+xj_topThemeImg.size.height);
    xj_topTheme.size.width = self.width-40;
    xj_topTheme.size.height = 40;
    self.xj_TopicThemeL.frame = xj_topTheme;
    self.xj_TopicThemeL.text = @"这里是他么的主题呀主题";
    self.xj_TopicThemeL.numberOfLines = 2;
    //    self.xj_TopicThemeL.backgroundColor = [UIColor redColor];
    [base addSubview:self.xj_TopicThemeL];

    
    //个人信息view
    UIView* info = [[UIView alloc] init];
    [base addSubview:info];
    CGRect xj_info ;
    xj_info.origin.x = 0;
    xj_info.origin.y = 0;
    xj_info.size = CGSizeMake(240, 80);
    info.frame = xj_info;
    info.center = CGPointMake(self.centerX - 20, (xj_topTheme.origin.y+xj_topTheme.size.height+70));
    
    //头像
    CGFloat xj_img_w =  60;
    self.xj_imageView = [[UIImageView alloc] init];
    self.xj_imageView.layer.borderColor=DE_headerBorderColor.CGColor;
    self.xj_imageView.layer.borderWidth=DE_headerBorderWidth;

    self.xj_imageView.frame = CGRectMake(0, 0, xj_img_w, xj_img_w);
    [info addSubview:self.xj_imageView];
    self.xj_imageView.image = [UIImage imageNamed:@"xj_default_avator"];
    self.xj_imageView.layer.cornerRadius = xj_img_w/2;
    self.xj_imageView.layer.masksToBounds = YES;
    
    [self.xj_imageView sd_setImageWithURL:[NSURL URLWithString:[XJFinalTool xjReturnImageURLWithStr:[[XJUserAccountTool share] xj_getUserAvatar] isSite:NO]]];
    
    UIImageView* iiimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"duihuakuang13"]];
    [info addSubview:iiimage];
    iiimage.contentMode = UIViewContentModeScaleToFill;
    iiimage.frame = CGRectMake(60, 10, info.mj_w, 40);
    
    //描述
    UILabel* xj = [[UILabel alloc] init];
    [iiimage addSubview: xj];
    xj.frame = CGRectMake(15, 5, info.mj_w, 30);
    xj.font = [UIFont fontWithName:FL_FONT_NAME size:14];
    xj.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    xj.text = @"厉害了，这都被你找到啦~";
    xj.textAlignment = NSTextAlignmentLeft;
    
    
    
    //昵称
    NSString* nick = [[XJUserAccountTool share] xj_getUserName];
    if ([XJFinalTool xjStringSafe:nick]) {
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont fontWithName:FL_FONT_NAME size:12]};
        CGSize size=[nick sizeWithAttributes:attrs];
        
        CGRect xj_nickname = self.xj_imageView.frame;
        xj_nickname.size.width = size.width>60?size.width:60;
        xj_nickname.origin.x = 0;
        xj_nickname.origin.y += (5 + xj_nickname.size.height);
        xj_nickname.size.height = 15;
        self.xj_NickNameL.frame = xj_nickname;
        
        self.xj_NickNameL.text = [[XJUserAccountTool share] xj_getUserName];
        
        [info addSubview:self.xj_NickNameL];

    }
    
    //完成按钮
    UIButton* xjDone = [UIButton buttonWithType: UIButtonTypeCustom];
    [xjDone setBackgroundImage:[UIImage imageNamed:@"ar_buttonbg"] forState:UIControlStateNormal];
    [xjDone setTitle:@"查看票券" forState:UIControlStateNormal];
    [xjDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [xjDone addTarget:self action:@selector(xj_clickDone) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect xj_done ;//= canghaole;
    xj_done.origin.x = (self.width/2)-70;
    xj_done.origin.y = base.height - 90;
    xj_done.size.width = 140;
    xj_done.size.height = 50;
    xjDone.frame = xj_done;
    [base addSubview:xjDone];
    
}

- (void)xj_clickDone {
    [self.xjPlayView.player pause];
    if (self.block != nil) {
        self.block();
        
    }
}

- (void)xj_findGiftSuccessDone:(xjPickSucessDoneAction)block {
    _block = block;
}
- (void)setXj_imgUrlStr:(NSString *)xj_imgUrlStr {
    _xj_imgUrlStr = xj_imgUrlStr;
    //判断路径的结尾是不是 .mp4
    if([xj_imgUrlStr hasSuffix:@".mp4"]){
        self.xj_TopicImgView.hidden = YES;
        self.xjPlayView.isXunHuan=YES;

        self.xjPlayView.hidden = NO;
        self.xjPlayView.videoURLStr = xj_imgUrlStr;
        [self.xjPlayView.player play];
        
    } else {
        self.xj_TopicImgView.hidden = NO;
        __weak typeof(self) weakSelf = self;
        FL_Log(@"test value in  pick success = %@",xj_imgUrlStr);
        [self.xj_TopicImgView sd_setImageWithURL:[NSURL URLWithString:xj_imgUrlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf xj_addImgAnimation];
        }];
    }
}
- (void)xj_addImgAnimation{
    
    CABasicAnimation * scaleAnimationBig = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimationBig.fromValue = @0.1;
    scaleAnimationBig.toValue = @1.0;
    scaleAnimationBig.duration = 1;
    scaleAnimationBig.repeatCount = 1;
    scaleAnimationBig.removedOnCompletion = YES;
    
    [self.xj_TopicImgView.layer addAnimation:scaleAnimationBig forKey:@"plulsing"];
}
- (void)xjClickToCloseWindow:(xjClickCloseWindow)block {
    _xjCloseBlock = block;
}
- (void)closeWindow{
   
}
@end
















