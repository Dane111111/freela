//
//  XJHFiveCallLocationJsController.h
//  FreeLa
//
//  Created by Leon on 16/6/27.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJTopicDetailModel.h"

//typedef enum{
//    HFivePushStyleJudgeList         ,      //评论
//    HFivePushStyleGroupInvitation,
//    HFivePushStyleJoinGroup,
//}HFivePushStyle;

typedef NS_ENUM(NSInteger, HFivePushStyle) {
    HFivePushStyleJudgeList          ,      //评论
    HFivePushStyleRelay               ,      //转发
    HFivePushStyleCollectoin   ,            //s收藏
    HFivePushStylePutInfoForTake,              //填写领取信息
    HFivePushStylePartInList,               //参与列表
    HFivePushStyleHelpList,               //助力抢列表
    HFivePushStylePartInJBPage,             //举报
    HFivePushStyleNone ,
};

@interface XJHFiveCallLocationJsController : UIViewController
@property (nonatomic , assign) HFivePushStyle xjPushStyle;
@property (nonatomic , strong) NSString * xjTopicIdStr;
@property (nonatomic , strong) NSArray* xjPartInfoArr; //是否需要填写领取信息
@property(nonatomic,strong)NSString*xjPartInfoStr;
/**票券需要的领取model*/
@property (nonatomic , strong) FLMyReceiveListModel *flmyReceiveMineModel;
/**详情Model*/
@property (nonatomic , strong) XJTopicDetailModel*     xjTopicDeatailModel; //详情
-(instancetype)initWithStyle:(HFivePushStyle)xjStyle;
-(instancetype)initWithTopicId:(NSString*)topicID;

@end





