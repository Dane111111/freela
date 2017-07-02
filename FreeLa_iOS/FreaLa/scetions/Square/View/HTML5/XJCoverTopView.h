//
//  XJCoverTopView.h
//  FreeLa
//
//  Created by Leon on 16/6/22.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XJTopicDetailModel.h"
#import "XJTopicPartInModel.h"
#import "XJTopicStatisticModel.h"

@protocol XJCoverTopViewDelegate <NSObject>
/**点击头像跳转*/
- (void)xjClickPartInListToPushHTMLInCoverView;
/**点击返回*/
- (void)xjClickBtnToPushBackInCoverView;
/**刷新顶部数据*/
- (void)xjRefreshTopViewInCoverView;
/**点击进入 参与列表*/
- (void)xjClickTopViewPartInListToPushHtml:(BOOL)xjIsHelp;
/**点击进入 举报按钮*/
- (void)xjClickTopViewJBToPushHtml;
@end



@interface XJCoverTopView : UIView
@property (nonatomic , weak) id<XJCoverTopViewDelegate>delegate;

@property (nonatomic , strong) NSArray* xjTopicPartInArr;

@property (nonatomic , strong) XJTopicStatisticModel* xjTpoicStatisticModel;
@property (nonatomic , strong) XJTopicPartInModel   * xjTopicPartInModel;
@property (nonatomic , strong) XJTopicDetailModel   * xjTopicDetailnModel;


- (void)xjSet_total_numerInTopCoverView:(NSInteger)xjNum;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

@end
