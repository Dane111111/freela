//
//  XJVersionTwoCouponsModel.h
//  FreeLa
//
//  Created by Leon on 16/5/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJVersionTwoCouponsModel : NSObject

@property (nonatomic , strong) NSString* topicTheme;
@property (nonatomic , strong) NSString* thumbnail;
@property (nonatomic , strong) NSString* avatar;
@property (nonatomic , strong) NSString* xjServiceTime;
@property (nonatomic , strong) NSString* startTime;
@property (nonatomic , strong) NSString* publishTime;
@property (nonatomic , strong) NSString* nickName;
@property (nonatomic , assign) NSInteger receiveNum;
@property (nonatomic , strong) NSString* topicCondition;
@property (nonatomic , strong) NSString* topicConditionKey;
@property (nonatomic , strong) NSString* topicType;
@property (nonatomic , assign) NSInteger transformNum;
/**总数*/
@property (nonatomic , assign) NSInteger topicNum;
@property (nonatomic , assign) NSInteger pv;
@property (nonatomic , strong) NSString* topicTag;
@property (nonatomic , assign) NSInteger topicId;
/**发布者类型*/
@property (nonatomic , strong) NSString* userType;
@property (nonatomic , strong) NSString* endTime;
@end



/*
 assiNum = 0;
 avatar = "/resources/static/user/cut_xpuser1463735142465.jpg";
 commentCount = 0;
 createTime = "2016-05-20 19:00:48";
 dateDiff = "0\U59290\U5c0f\U65f6";
 enable = 0;
 endTime = "2016-05-21 20:00:00";
 favNum = 0;
 invalidTime = "2016-05-23 18:00:26";
 isPhNum = 0;
 newDate = "2016-05-27 15:12:13";
 nickName = "\U591a\U8089\U519c\U573a";
 num = 0;
 operType = 0;
 publishTime = "2016-05-23 18:39:59";
 pv = 28;
 rankCount = 0;
 receiveNum = 0;
 receiveQuantity = 0;
 startTime = "2016-05-20 18:45:00";
 state = 1;
 thumbnail = "/resources/static/topic/comp/100001/little_pc_1463741221867100001.jpg";
 topicCondition = "\U52a9\U529b\U62a2--\U6ee1\U8db3\U52a9\U529b\U89c4\U5219\U624d\U53ef\U4ee5\U9886\U53d6";
 topicConditionKey = ZHULIQIANG;
 topicId = 12;
 topicNum = 5;
 topicPrice = 0;
 topicTag = "\U4e50\U6d3b\U7f8e\U690d";
 topicTheme = "\U7f8e\U7f8e\U54d2\U591a\U8089\Uff0c\U514d\U8d39\U62ff\U53bb\U8868\U8fbe\U7231\U610f\U5427\Uff5ePC\U518d\U53d1\U4e00\U6761";
 topicType = FREE;
 totop = 0;
 transformNum = 1;
 useNum = 0;
 userId = 100001;
 userType = comp;
 uv = 26;
 */

