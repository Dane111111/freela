//
//  XJSquareMainView.m
//  FreeLa
//
//  Created by Collegedaily on 2017/5/15.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJSquareMainView.h"

#define  XJ_TOP_MARGIN_H        5
#define  XJ_Width_MARGIN_H        5
#define  XJ_FIRST_VIEW_H        100
#define  XJ_AVTIVITY_VIEW_H     80

#define  XJ_VIEW_H              (self.mj_h - 40) / 2
#define  XJ_TOP_PER_VIEW_W      (self.mj_w - XJ_Width_MARGIN_H * 4) / 3

@interface  XJSquareMainView ()<UIScrollViewDelegate>
@property (nonatomic , strong) UIScrollView* xjContentView;

/**firstview*/
@property (nonatomic , strong) UIView* xjFirstView;
/**主力抢*/
@property (nonatomic , strong) UIView* xjHelpView;
/**全免费*/
@property (nonatomic , strong) UIView* xjAllFreeView;
/**优惠券*/
@property (nonatomic , strong) UIView* xjCouponView;
/**活动view*/
@property (nonatomic , strong) UIView* xjActivityView;
/**secondView*/
@property (nonatomic , strong) UIView* xjSecondView;
@end

@implementation XJSquareMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        [self addSubview:self.xjContentView];
        [self xjInitPage];
    }
    return self;
}
- (UIScrollView *)xjContentView {
    if (!_xjContentView) {
        _xjContentView = [[UIScrollView alloc] init];
        _xjContentView.frame = CGRectMake(0, 0, self.mj_w, self.mj_h);
        _xjContentView.delegate = self;
    }
    return _xjContentView;
}
- (UIView *)xjFirstView {
    if (!_xjFirstView) {
        _xjFirstView = [[UIView alloc] init];
        _xjFirstView.frame = CGRectMake(0, XJ_TOP_MARGIN_H, self.mj_w, XJ_VIEW_H);
        
    }
    return _xjFirstView;
}
- (UIView *)xjHelpView {
    if (!_xjHelpView) {
        _xjHelpView = [[UIView alloc] init];
        _xjHelpView.backgroundColor = [UIColor redColor];
        _xjHelpView.frame = CGRectMake(XJ_Width_MARGIN_H, 0, XJ_TOP_PER_VIEW_W, XJ_VIEW_H);
    }
    return _xjHelpView;
}
- (UIView *)xjAllFreeView {
    if (!_xjAllFreeView) {
        _xjAllFreeView = [[UIView alloc] init];
        _xjAllFreeView.backgroundColor = [UIColor blackColor];
        _xjAllFreeView.frame = CGRectMake(XJ_Width_MARGIN_H * 2 + XJ_TOP_PER_VIEW_W, XJ_AVTIVITY_VIEW_H, XJ_TOP_PER_VIEW_W, XJ_VIEW_H - XJ_AVTIVITY_VIEW_H);
    }
    return _xjAllFreeView;
}
- (UIView *)xjCouponView {
    if (!_xjCouponView) {
        _xjCouponView = [[UIView alloc] init];
        _xjCouponView.backgroundColor = [UIColor blueColor];
        _xjCouponView.frame = CGRectMake(XJ_Width_MARGIN_H * 3 + XJ_TOP_PER_VIEW_W * 2, XJ_AVTIVITY_VIEW_H, XJ_TOP_PER_VIEW_W, XJ_VIEW_H - XJ_AVTIVITY_VIEW_H);
    }
    return _xjCouponView;
}
- (UIView *)xjActivityView {
    if (!_xjActivityView) {
        _xjActivityView = [[UIView alloc] init];
        _xjActivityView.frame = CGRectMake(XJ_Width_MARGIN_H * 2 + XJ_TOP_PER_VIEW_W, 0, XJ_TOP_PER_VIEW_W * 2, XJ_AVTIVITY_VIEW_H);
        _xjActivityView.backgroundColor = [UIColor yellowColor];
    }
    return _xjActivityView;
}
- (UIView *)xjSecondView{
    if (!_xjSecondView) {
        _xjSecondView = [[UIView alloc] init];
        _xjSecondView.frame = CGRectMake(0, XJ_VIEW_H + 5, self.mj_w, XJ_VIEW_H);
    }
    return _xjSecondView;
}
- (void)xjInitPage {
//    [self.xjContentView addSubview:self.xjFirstView];
    
    [self addSubview:self.xjFirstView];
    [self.xjFirstView addSubview:self.xjHelpView];
    [self.xjFirstView addSubview:self.xjCouponView];
    [self.xjFirstView addSubview:self.xjActivityView];
    [self.xjFirstView addSubview:self.xjAllFreeView];
    [self addSubview:self.xjSecondView];
    self.xjSecondView.backgroundColor = [UIColor yellowColor];
    
}

- (CGFloat) xjReturnH {
    return XJ_TOP_MARGIN_H + XJ_FIRST_VIEW_H;
}

@end














