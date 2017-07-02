//
//  CardView.h
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSLCardView.h"
#import "FLGrayLabel.h"
#import "XJCricleLabel.h"
#import "XJRecommendTopicListModel.h"
#import "XJTopicConditionView.h"
@interface CardView : YSLCardView
/**model*/
@property (nonatomic , strong) XJRecommendTopicListModel* xjModel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *selectedView;

/**主题*/
@property (nonatomic ,strong) UILabel* xjTopicThemLabel;
/**进度条*/
@property (nonatomic ,strong) UIProgressView* xjProgressView;
/**进度*/
@property (nonatomic ,strong) FLGrayLabel* xjProgressLabel;
/**进度变红继承自  UIVIEW*/
@property (nonatomic ,strong) XJProGressLabel* xjProgressLabelTotal;
/**分类*/
@property (nonatomic ,strong) XJCricleLabel* xjTopicTypeLabel;

/**分类*/
@property (nonatomic ,strong) FLGrayLabel * xjHotLabel;

/**助力抢？随心领？*/
@property (nonatomic ,strong) XJTopicConditionView * xjTopicConditionViewLabel;

- (void)xjSetEmptyImage:(UIImage*)xjImage;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com