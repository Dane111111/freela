//
//  FLMyIssueInMineModel.h
//  FreeLa
//
//  Created by Leon on 15/12/24.
//  Copyright © 2015年 FreeLa. All rights reserved.
//   准备废弃啊

#warning 准备废弃啊~~~~~~
#import <Foundation/Foundation.h>

@interface FLMyIssueInMineModel : NSObject
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
/**参与数*/
@property (nonatomic , assign)NSInteger xjPartInNumber;
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

/**状态*/
@property (nonatomic , assign) NSInteger flStateInt;
/**使用说明*/
@property (nonatomic , strong) NSString* xjTopicExplain;
/**发布类型*/
@property (nonatomic , strong) NSString* xjTopicTagStr;

/**freelaUVID*/
@property (nonatomic , strong) NSString* freelaUVID;
/**tempId*/
@property (nonatomic , strong) NSString* xjTempId;

/**是否是藏宝*/
@property (nonatomic , assign) NSInteger hideGift;
@end
