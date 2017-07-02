//
//  XJMyWeaitPJModel.h
//  FreeLa
//
//  Created by Leon on 16/3/9.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJMyWeaitPJModel : NSObject
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

@end
