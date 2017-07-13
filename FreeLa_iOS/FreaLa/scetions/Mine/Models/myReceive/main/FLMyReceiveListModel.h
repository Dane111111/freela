//
//  FLMyReceiveListModel.h
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMyReceiveListModel : NSObject
/**发布者头像*/
@property(nonatomic,strong)NSString*avatar;
/**月*/
@property (nonatomic , strong)NSString* flMineIssueMonthStr;
/**日*/
@property (nonatomic , strong)NSString* flMineIssueDayStr;
/**阅读数*/
@property (nonatomic , strong)NSString* flMineIssueNumbersReadStr;

/**转发数*/
@property (nonatomic , strong)NSString* flMineIssueNumbersRelayStr;
/**评论数*/
@property (nonatomic , strong)NSString* flMineIssueNumbersJudgeStr;
/**已领数*/
@property (nonatomic , strong)NSString* flMineIssueNumbersAlreadyPickStr;
/**总数*/
@property (nonatomic , strong)NSString* flMineIssueNumbersTotalPickStr;

/**背景*/
@property (nonatomic , strong)NSString* flMineIssueBackGroundImageStr;

/**tpicId*/
@property (nonatomic , strong)NSString* flMineIssueTopicIdStr;
/**tpicIdCondition*/
@property (nonatomic , strong)NSString* flMineIssueTopicConditionStr;

/**topicThem*/
@property (nonatomic , strong) NSString* flMineTopicThemStr;
/**地址*/
@property (nonatomic , strong) NSString* flMineTopicAddressStr;

/**开始时间*/
@property (nonatomic , strong) NSString* flTimeBegan;
/**结束时间*/
@property (nonatomic , strong) NSString* flTimeEnd;

/**服务器当前时间*/
@property (nonatomic , strong) NSString* flTimeService;

/**进度百分比*/
@property (nonatomic , strong) NSString* flfloatStr;
/**进度*/
@property (nonatomic , strong) NSString* flfloatNumberStr;

/**使用说明*/
@property (nonatomic , strong) NSString* flIntroduceStr;

/**参与Id*/
@property (nonatomic , strong) NSString* flDetailsIdStr;

/**使用状态*/
@property (nonatomic , assign) NSInteger flStateInt;
/*creator*/
@property (nonatomic , assign) NSInteger xjCreator;
/**userid*/
@property (nonatomic , assign) NSInteger xjUserId;

@property (nonatomic , strong) NSString* xjUrl;

@property (nonatomic , strong) NSString* xjinvalidTime;
/**使用时间*/
@property (nonatomic , strong) NSString* xjUseTime;

/**userTpye*/
@property (nonatomic , strong) NSString* xjUserType;
/**tag*/
@property (nonatomic , strong) NSString* xjTopicTagStr;
/**发布者*/
@property (nonatomic , strong) NSString * xjPublishName;
/**发布者类型
 * person 、comp
 */
@property (nonatomic , strong) NSString * xjPublisherType;
/**发布类型
 * 全免费 、优惠券 、个人
 */
@property (nonatomic , strong) NSString* xjTopicType;
/**领取时间*/
@property (nonatomic , strong) NSString* createTime;


/**缩略图*/
@property (nonatomic , strong) NSString* xj_suolvetuStr;
/**线索图  轮播*/
@property (nonatomic , strong) NSString* xj_xiansuotuStr;
/**对比code*/
@property (nonatomic , strong) NSString* pictureCode;

@end








