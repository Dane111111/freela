//
//  XJRecommendNaviView.h
//  FreeLa
//
//  Created by Leon on 16/5/26.
//  Copyright © 2016年 FreeLa. All rights reserved.
//  主界面的推荐 导航栏

#import <UIKit/UIKit.h>

@interface XJRecommendNaviView : UIView
/**中间的图片路径*/
@property (nonatomic , strong) NSString* xjNaviImageStr;
/**搜索按钮*/
@property (nonatomic , strong) UIButton* xjSearchBtn;
/**扫码按钮*/
@property (nonatomic , strong) UIButton* xjsaoBtn;
    
/**中间的图片button*/
@property (nonatomic , strong) UIButton* xjMiddleBtn;
/**背景渐变*/
- (void)changedViewColorWithAlpha:(float)alpha;
/**隐藏*/
- (void)setViewHiddenWithBool:(BOOL)isUp;


@end
