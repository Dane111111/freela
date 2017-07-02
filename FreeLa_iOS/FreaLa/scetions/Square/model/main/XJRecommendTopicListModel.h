//
//  XJRecommendTopicListModel.h
//  FreeLa
//
//  Created by Leon on 16/5/26.
//  Copyright © 2016年 FreeLa. All rights reserved.
//  首页推荐列表的 模型

#import <Foundation/Foundation.h>

@interface XJRecommendTopicListModel : NSObject
@property (nonatomic , strong) NSString* avatar;
@property (nonatomic , strong) NSString* topicTheme;
@property (nonatomic , strong) NSString* thumbnail;
/**热度*/
@property (nonatomic , assign) NSInteger pv;
/**已领*/
@property (nonatomic , assign) NSInteger receiveNum;
/**分类（全免费=）*/
@property (nonatomic , strong) NSString* topicType;
/**分类（随心领）*/
@property (nonatomic , strong) NSString* topicConditionKey;
/**分类（随心领）*/
@property (nonatomic , strong) NSString* topicCondition;
/**分类（生活健康）*/
@property (nonatomic , strong) NSString* topicTag;
/**总数*/
@property (nonatomic , assign) NSInteger topicNum;
/**topid id*/
@property (nonatomic , strong) NSString* topicId;
/**顶部的广告图*/
@property (nonatomic , strong) NSString* filePath;
/**预览图*/
@property (nonatomic , strong) NSString* filePath2;

/*什么id*/
@property (nonatomic , strong) NSString* advertId;


/**失效时间*/
@property (nonatomic , strong) NSString* invalidTime;
/**结束时间*/
@property (nonatomic , strong) NSString* endTime;
@end

/*
 address = "\U5317\U4eac\U5e02\U671d\U9633\U533a\U9ad8\U7891\U5e97\U9547\U4e07\U8fbe\U5bb6\U5177\U5927\U4e16\U754c\U82b1\U5317\U897f\U793e\U533a";
 assiNum = 0;
 commentCount = 0;
 content = pc;
 createTime = "2016-06-03 10:00:29";
 createTime2 = "2016-06-03 10:12:06";
 creator = 100001;
 creator2 = pc;
 detailchart = "1464918246224.jpg,1464918250656.jpg,1464918258501.jpg,1464918266456.jpg";
 details = "/resources/static/topic/details/d7f7403c62d240eea61290e877a2a5ef.html";
 enable = 0;
 endTime = "2016-06-04 22:53:00";
 favNum = 0;
 fileName = "be678ab5f59f5e9fe43c5f507cad4c24.jpeg";
 fileName2 = "a1a4cb365e3edc05a0407d663737e35d.jpg";
 filePath = "/resources/static/advert/be678ab5f59f5e9fe43c5f507cad4c24.jpeg";
 filePath2 = "/resources/static/advert/a1a4cb365e3edc05a0407d663737e35d.jpg";
 invalidTime = "2016-06-05 22:53:00";
 isPhNum = 0;
 latitude = "39.916158";
 longitude = "116.523913";
 lowerTime = "2016-07-01 10:11:00";
 nickName = "\U534e\U6b63\U660e\U5929123";
 num = 0;
 operType = 0;
 partInfo = "NAME,TEL";
 publishTime = "2016-06-03 10:00:29";
 pv = 0;
 rankCount = 0;
 receiveNum = 0;
 rule = "{\"rule\":\"UNLIMITED\"}";
 sitethumbnail = "site_1464918286453.jpg";
 startTime = "2016-06-03 09:53:00";
 state = 1;
 state2 = 1;
 thumbnail = "1464918286453.jpg";
 title = pc;
 topicCondition = "{\"topicCondition\":\"SUIXINLING\"}";
 topicExplain = "";
 topicId = 8;
 topicNum = 24;
 topicPrice = 2333;
 topicRange = "{\"range\":\"OVERT\"}";
 topicTag = "\U667a\U80fd\U8f6f\U4ef6";
 topicTheme = "pc -----\U6d4b\U8bd5";
 topicType = PERSONAL;
 totop = 0;
 transformNum = 0;
 upperTime = "2016-06-30 10:11:00";
 url = "http://www.baidu.com";
 url2 = "https://www.baidu.com/index.php?tn=monline_3_dg";
 useNum = 0;
 userId = 100001;
 userType = person;
 uv = 0;

*/





