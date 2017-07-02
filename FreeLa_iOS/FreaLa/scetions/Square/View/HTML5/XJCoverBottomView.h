//
//  XJCoverBottomView.h
//  FreeLa
//
//  Created by Leon on 16/6/22.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJTopicDetailModel.h"
#import "XJTopicPartInModel.h"
#import "XJTopicStatisticModel.h"
#import "XJHFiveCallLocationJsController.h"
#import "XJQualificationModel.h"
typedef NS_ENUM(NSInteger  , XJPartInClickType) {
    XJPartInClickTypeb1,
    XJPartInClickTypeb2,
    XJPartInClickTypeb4,
    XJPartInClickTypeb5,
    XJPartInClickTypeb6,
    XJPartInClickTypeb7,
    XJPartInClickTypeb9,
    XJPartInClickTypeb8,
    XJPartInClickTypeb10,
    XJPartInClickTypeb11,
    XJPartInClickTypeb12,
    XJPartInClickTypeb13,
    XJPartInClickTypeb14,
    XJPartInClickTypeb15,
    XJPartInClickTypeb16,
    XJPartInClickTypeb17,
    XJPartInClickTypeb18,
    XJPartInClickTypeb19,
    XJPartInClickTypeb20,
    XJPartInClickTypeb21,
    XJPartInClickTypeb22,
};


@protocol XJCoverBottomViewDelegate <NSObject>
/**点击头像跳转*/
- (void)xjClickPartInListToPushCheckPublisherInCoverViewWithuserId:(NSString*)xjUserId type:(NSString*)xjType;
/**点击返回*/
- (void)xjClickBtnToPushBackInCoverView;
/**点击关注&取消关注*/
- (void)xjClickBtnToCarePublisherInCoverViewWithuserId:(NSString*)xjUserId type:(NSString*)xjType;
/**点击立即参与
 *@parma clickType
 */
- (void)xjClickBtnToParInTopicInCoverView:(XJPartInClickType)xjClickType;
/**刷新界面*/
- (void)xjRefreshPagesInCoverViewBottomView;
/**点击进行交互*/
- (void)xjCallJSInCoverViewBottomViewWithType:(HFivePushStyle)xjType;
/**点击头像跳转*/
- (void)xjPushPubilisherPageViewWithType:(BOOL)xjIsComp;
@end





@interface XJCoverBottomView : UIView
@property (nonatomic , weak) id<XJCoverBottomViewDelegate>delegate;

@property (nonatomic , strong) XJTopicStatisticModel* xjTpoicStatisticModel; //统计
@property (nonatomic , strong) XJTopicPartInModel   * xjTopicPartInModel;
@property (nonatomic , strong) XJTopicDetailModel   * xjTopicDetailnModel; //详情
@property (nonatomic , strong) XJQualificationModel* xjQualificationModel; //领取资格
/**设置发布者统计数*/
- (void)xjSetPublisherInfoWithIssueNumber:(NSInteger)xjIssueNum hotNum:(NSInteger)xjHotNum;
/**是否好友*/
- (void)xjSet_is_friendInCoverBottom:(BOOL)xj_isFriend;
/**是否收藏*/
- (void)xjSet_is_CollectionInCoverBottom:(BOOL)xj_isFriend;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

@end
