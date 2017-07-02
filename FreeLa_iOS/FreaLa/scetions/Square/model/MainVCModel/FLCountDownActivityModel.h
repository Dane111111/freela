//
//  FLCountDownActivityModel.h
//  倒计时活动model
//
//  Created by 佟 on 2017/5/16.
//  Copyright © 2017年 xj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CountDownItem;
@interface FLCountDownActivityModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<CountDownItem *> *data;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger total;

@end
@interface CountDownItem : NSObject

@property (nonatomic, copy) NSString *topicCondition;

@property (nonatomic, assign) NSInteger attentNum1;

@property (nonatomic, copy) NSString *detailchart;

@property (nonatomic, copy) NSString *invalidTime;

@property (nonatomic, assign) NSInteger advertId;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, copy) NSString *sitethumbnail;

@property (nonatomic, assign) NSInteger hideGift;

@property (nonatomic, copy) NSString *topicConditionKey;

@property (nonatomic, assign) NSInteger uv;

@property (nonatomic, copy) NSString *thumbnail;

@property (nonatomic, copy) NSString *dateDiff;

@property (nonatomic, assign) NSInteger receiveNum;

@property (nonatomic, assign) NSInteger useNum1;

@property (nonatomic, copy) NSString *topicTheme;

@property (nonatomic, assign) NSInteger isSpecial;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *pictureCode;

@property (nonatomic, assign) NSInteger attentNum;

@property (nonatomic, assign) NSInteger assiNum1;

@property (nonatomic, copy) NSString *NewDate;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, assign) NSInteger transformNum1;

@property (nonatomic, assign) NSInteger state2;

@property (nonatomic, assign) NSInteger enable;

@property (nonatomic, copy) NSString *publishTime;

@property (nonatomic, assign) NSInteger totop;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *topicZxTheme;

@property (nonatomic, assign) NSInteger topicId;

@property (nonatomic, assign) NSInteger isPhNum;

@property (nonatomic, assign) NSInteger pv;

@property (nonatomic, copy) NSString *topicType;

@property (nonatomic, assign) NSInteger rankCount1;

@property (nonatomic, assign) NSInteger receiveNum1;

@property (nonatomic, assign) NSInteger receiveQuantity;

@property (nonatomic, copy) NSString *topicTag;

@property (nonatomic, assign) NSInteger operType;

@property (nonatomic, assign) NSInteger useNum;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, assign) NSInteger transformNum;

@property (nonatomic, assign) NSInteger pv1;

@property (nonatomic, assign) NSInteger assiNum;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, assign) NSInteger favNum1;

@property (nonatomic, assign) NSInteger topicPrice;

@property (nonatomic, assign) NSInteger rankCount;

@property (nonatomic, assign) NSInteger favNum;

@property (nonatomic, copy) NSString *userType;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, assign) NSInteger uv1;

@property (nonatomic, assign) NSInteger commentCount1;

@property (nonatomic, assign) NSInteger topicNum;
/**倒计时 x天x时*/
@property (nonatomic, copy) NSString *countDownTime;

@end

