//
//  XJNaviViewSearchBar.m
//  FreeLa
//
//  Created by Leon on 16/5/27.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJNaviViewSearchBar.h"
#define xj_status_heigh_square              FL_STATUSBAR.height                                         //状态栏高度
#define xj_search_btn_w                     (xj_navi_H - 10)                                              //搜索按钮宽度
#define xj_navi_H                           ( xjNaviFrame.size.height - FL_STATUSBAR.height )           //导航栏高度
#define xj_search_bar_W                      FLUISCREENBOUNDS.width - (4 * xj_Side_margin_W) - ( 2 * xj_search_btn_w)         //image宽度
#define xj_Side_margin_W                    8
@interface XJNaviViewSearchBar ()

@end


static CGRect xjNaviFrame;
@implementation XJNaviViewSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        xjNaviFrame = frame;
        [self allocNaviInSquare];
    }
    return self;
}

- (void)changedViewColorWithColor:(UIColor*)xjColor alpha:(float)alpha {
    dispatch_async(dispatch_get_main_queue(), ^{
          self.backgroundColor = [xjColor colorWithAlphaComponent:alpha];
    });
}

- (void)setViewHiddenWithBool:(BOOL)isUp {
    dispatch_async(dispatch_get_main_queue(), ^{
    [self setHidden:isUp];
     });
}

- (void)allocNaviInSquare {
    self.xjBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xjBackBtn.frame = CGRectMake(xj_Side_margin_W, xj_status_heigh_square + 5, xj_search_btn_w, xj_search_btn_w);
    //searchBar
    self.xjSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(xj_Side_margin_W * 2 + xj_search_btn_w, xj_status_heigh_square, xj_search_bar_W, StatusBar_NaviHeight - xj_status_heigh_square)];
    if ([self.xjSearchBar respondsToSelector:@selector(barTintColor)]) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.1) {
            //ios7.1
            [[[[self.xjSearchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [self.xjSearchBar setBackgroundColor:[UIColor clearColor]];
        }else{
            //ios7.0
            [self.xjSearchBar setBarTintColor:[UIColor clearColor]];
            [self.xjSearchBar setBackgroundColor:[UIColor clearColor]];
        }
    }else{
        //iOS7.0 以下
        [[self.xjSearchBar.subviews objectAtIndex:0] removeFromSuperview];
        [self.xjSearchBar setBackgroundColor:[UIColor clearColor]];
    }
    self.xjSearchBar.placeholder = @"搜索免费信息、朋友";
    [self addSubview:self.xjSearchBar];
    [self addSubview:self.xjBackBtn];
    [self setUpUiInSqare];
}

- (void)setUpUiInSqare {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.xjBackBtn setImage:[UIImage imageNamed:@"btn_icon_goback_white"] forState:UIControlStateNormal];
    });
    
 
    
}


 
@end
