//
//  XJMyPartInInfoModel.h
//  FreeLa
//
//  Created by Leon on 16/3/9.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJMyPartInInfoModel : NSObject
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
/**state*/
@property (nonatomic , assign) NSInteger xjState;
@end
/*
 address = "\U65b9\U5bb6\U6751";
 assiNum = 0;
 avatar = "/resources/static/user/mobile1457416372529.jpg";
 commentCount = 5;
 createTime = "2016-03-08 14:12:10";
 creator = 3;
 dateDiff = "0\U592900\U5c0f\U65f643\U5206";
 detailchart = "14574166938741.png,14574166937491.png";
 details = "\U56fe\U6587<br><img width=\"100\" height=\"100\" src=\"http://192.168.20.79:8888/resources/static/user/mobile1457416725854.png\" alt=\"\"><br>";
 enable = 0;
 endTime = "2016-04-08 14:11:00";
 favNum = 0;
 nickName = "\U5546\U5bb6\U7b80\U79f0\U8346";
 num = 0;
 operType = 0;
 partInfo = "NAME,TEL,TINDUSTRY";
 publishTime = "2016-03-08 14:12:10";
 pv = 60;
 rankCount = 0;
 receiveNum = 2;
 rule = "{\"rule\":\"DAYONCE\"}";
 state = 1;
 thumbnail = "/resources/static/topic/comp/1/14574175003171.png";
 topicCondition = "{\"topicCondition\":\"ZHULIQIANG\",\"lowestNum\":\"2\",\"zlqRule\":\"FIRST\"}";
 topicExplain = "\U4f7f\U7528\U8bf4\U660e";
 topicId = 4;
 topicNum = 25;
 topicPrice = 123;
 topicRange = "{\"range\":\"OVERT\"}";
 topicTag = "\U667a\U80fd\U8f6f\U4ef6";
 topicTheme = "\U5148\U5230\U5148\U5f97\Uff5e\U8346";
 topicType = FREE;
 transformNum = 5;
 useNum = 0;
 userId = 0;
 userType = comp;
 uv = 0;
 */