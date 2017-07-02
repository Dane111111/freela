//
//  XJHtmlNeedModel.h
//  FreeLa
//
//  Created by Leon on 16/3/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJHtmlNeedModel : NSObject

@property (nonatomic , strong) NSString* address;
@property (nonatomic , assign) CGFloat latitude;
@property (nonatomic , assign) CGFloat longitude;
@property (nonatomic , assign) NSInteger topicId;
@property (nonatomic , strong) NSString* topicConditionKey;
@property (nonatomic , assign) NSInteger userId;
@property (nonatomic , strong) NSString* userType;
@property (nonatomic , strong) NSString* topicExplain;
@property (nonatomic , strong) NSString* zlqRule;
@property (nonatomic , strong) NSString* nickName;
@property (nonatomic , strong) NSString* participateId;

/**已领*/
@property (nonatomic , assign) NSInteger receiveNum;
/**总数*/
@property (nonatomic , assign) NSInteger topicNum;
@end
/*
 address = "\U5730\U70b9";
 assiNum = 0;
 avatar = "/resources/static/user/mobile1457333072137.jpg";
 commentCount = 0;
 createTime = "2016-03-07 16:44:15";
 creator = 6;
 detailchart = "/resources/static/topic/comp/8/14573400104988.png";
 details = "\U56fe\U6587<br><img src=\"http://59.108.126.36:8585/resources/static/user/mobile1457340081893.jpg\" alt=\"\"><br><b>\U52a0\U7c97</b><br><br><i>\U503e\U659c<br><br><br></i>";
 enable = 0;
 endTime = "2016-03-08 16:38:00";
 favNum = 0;
 invalidTime = "2016-04-07 16:38:00";
 latitude = null;
 longitude = null;
 lowestNum = 2;
 newDate = "2016-03-07 16:58:31";
 nickName = "\U6d4b\U901a\U77e5";
 num = 0;
 operType = 0;
 partInfo = TEL;
 pv = 0;
 rankCount = 0;
 receiveNum = 0;
 rule = "\U6bcf\U4eba\U6bcf\U5929\U4e00\U6b21";
 ruleTimes = "";
 startTime = "2016-03-07 16:38:00";
 state = 1;
 thumbnail = "/resources/static/topic/comp/8/14573400063008.png";
 topicCondition = "\U52a9\U529b\U62a2--\U6ee1\U8db3\U52a9\U529b\U89c4\U5219\U624d\U53ef\U4ee5\U9886\U53d6";
 topicConditionKey = ZHULIQIANG;
 topicExplain = "\U8bf4\U660e";
 topicId = 14;
 topicNum = 5;
 topicPrice = 25;
 topicRange = "\U516c\U5f00";
 topicTag = "\U65c5\U6e38";
 topicTheme = "\U52a9\U7406\U62a2top\U9886\U53d6_\U8346\U6d4b";
 topicType = FREE;
 transformNum = 0;
 useNum = 0;
 userId = 8;
 userType = comp;
 uv = 0;
 zlqRule = TOP;


*/