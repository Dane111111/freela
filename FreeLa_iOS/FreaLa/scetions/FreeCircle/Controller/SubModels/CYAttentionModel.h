//
//  CYAttentionModel.h
//  FreeLa
//
//  Created by cy on 16/1/8.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYAttentionModel : NSObject

//topicId : 25
//userType : "person"
//userId : 3138
//nickName : "雷*&（@（）"
//topicType : "PERSONAL"
//topicTheme : "个人-转发领-一天一次-1.6"
//topicTag : "特色美食"
//thumbnail : "/resources/static/topic/person/3138/1452067559973.jpg"
//topicPrice : 0
//topicNum : 23
@property(nonatomic,strong)NSNumber *topicId;
@property(nonatomic,strong)NSString *userType;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *topicType;
@property(nonatomic,strong)NSString *topicTheme;
@property(nonatomic,strong)NSString *topicTag;
@property(nonatomic,strong)NSString *thumbnail;
@property(nonatomic,strong)NSNumber *topicPrice;
@property(nonatomic,strong)NSNumber *topicNum;
//favonites : "收藏"
//operType : 0
//endTime : "2016-01-07 00:00:00"
//startTime : "2016-01-06 00:00:00"
//invalidTime : "2016-01-08 00:00:00"
//state : 1  
//totop : 0
//createTime : "2016-01-06 16:06:40"
//enable : 0
//dateDiff : "0天0小时"
@property(nonatomic,strong)NSString *favonites;
@property(nonatomic,strong)NSNumber *operType;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *invalidTime;
@property(nonatomic,strong)NSNumber *state;
@property(nonatomic,strong)NSNumber *totop;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSNumber *enable;
@property(nonatomic,strong)NSString *dateDiff;
//url : "http://www.baidu.com"
//avatar : "/resources/static/user/cut_xpuser1452047066632.jpg"
//description : "个人帐号测试专用#*&#&……——~（@*@）——++**#-=9"
//pv : 0
//uv : 0
//receiveNum : 0
//useNum : 0
//assiNum : 0
//transformNum : 0
//commentCount : 0
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *DESCRIPTION;//description --> DESCRIPTION
@property(nonatomic,strong)NSNumber *pv;
@property(nonatomic,strong)NSNumber *uv;
@property(nonatomic,strong)NSNumber *receiveNum;
@property(nonatomic,strong)NSNumber *useNum;
@property(nonatomic,strong)NSNumber *assiNum;
@property(nonatomic,strong)NSNumber *transformNum;
@property(nonatomic,strong)NSNumber *commentCount;

//
@property (nonatomic , strong) NSString * topicCondition;
//rankCount : 0
//favNum : 0
@property(nonatomic,strong)NSNumber *rankCount;
@property(nonatomic,strong)NSNumber *favNum;

@end
