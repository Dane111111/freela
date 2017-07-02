//
//  XJRecommendNaviView.m
//  FreeLa
//
//  Created by Leon on 16/5/26.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJRecommendNaviView.h"
#define xj_status_heigh_square              FL_STATUSBAR.height                                         //状态栏高度
#define xj_search_btn_w                     (xj_navi_H - 10)                                              //搜索按钮宽度
#define xj_navi_H                           ( xjNaviFrame.size.height - FL_STATUSBAR.height )           //导航栏高度
#define xj_imageView_W                      FLUISCREENBOUNDS.width - (4 * xj_Side_margin_W) - ( 2 * xj_search_btn_w)         //image宽度
#define xj_Side_margin_W                    8

@interface XJRecommendNaviView()
/**中间图片*/
@property (nonatomic , strong) UIImageView* xjHeaderImageView;
@end


static CGRect xjNaviFrame;
@implementation XJRecommendNaviView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        xjNaviFrame = frame;
        [self allocNaviInSquare];
    }
    return self;
}

- (void)changedViewColorWithAlpha:(float)alpha
{
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
}

- (void)setViewHiddenWithBool:(BOOL)isUp
{
    [self setHidden:isUp];
    
}

- (void)allocNaviInSquare {
    self.xjSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xjMiddleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xjsaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xjHeaderImageView = [[UIImageView alloc] init];
    self.xjHeaderImageView.frame = CGRectMake(xj_Side_margin_W + xj_search_btn_w, xj_status_heigh_square, xj_imageView_W, xj_navi_H);
    //    self.xjHeaderImageView.frame = CGRectMake(20, 20, 200  , 30);
    self.xjSearchBtn.frame = CGRectMake(xj_Side_margin_W, xj_status_heigh_square + 5, xj_search_btn_w, xj_search_btn_w);
    self.xjHeaderImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.xjsaoBtn.frame = CGRectMake(xjNaviFrame.size.width - xj_search_btn_w - xj_Side_margin_W , xj_status_heigh_square + 5, xj_search_btn_w, xj_search_btn_w);
    self.xjMiddleBtn.frame = self.xjHeaderImageView.frame;
    [self addSubview:self.xjSearchBtn];
    [self addSubview:self.xjsaoBtn];
    [self addSubview:self.self.xjHeaderImageView];
    [self addSubview:self.xjMiddleBtn];
    [self setUpUiInSqare];
    
    
    //加个字 加个背景
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_item_ar_tips"]];
//    [self addSubview:img];
    CGFloat img_x = FLUISCREENBOUNDS.width - xj_search_btn_w- 5 - 60;
    img.frame = CGRectMake(img_x, xj_status_heigh_square + 8, 60, xj_navi_H -16);
    UILabel* label = [[UILabel alloc] init];
//    [img addSubview:label];
    label.text = @"AR寻宝";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    label.frame = CGRectMake(5, 0, img.width-5, img.height);
//    label.textAlignment = NSTextAlignmentCenter;
    
}
- (void)setUpUiInSqare {
    [self.xjSearchBtn setImage:[UIImage imageNamed:@"bar_item_search_gray"] forState:UIControlStateNormal];
    [self.xjsaoBtn setImage:[UIImage imageNamed:@"bar_item_saomiao_new_gray"] forState:UIControlStateNormal];
    self.xjHeaderImageView.image = [UIImage imageNamed:@"navi_new_image_header"];
    
}


- (void)setXjNaviImageStr:(NSString *)xjNaviImageStr {
    _xjNaviImageStr = xjNaviImageStr;
    [self.xjHeaderImageView sd_setImageWithURL:[NSURL URLWithString: [XJFinalTool xjReturnImageURLWithStr:_xjNaviImageStr isSite:NO]]];
    
}

@end







