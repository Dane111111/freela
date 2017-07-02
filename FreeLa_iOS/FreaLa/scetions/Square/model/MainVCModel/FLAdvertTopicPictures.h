//
//  FLAdvertTopicPictures.h
//  轮播图model
//
//  Created by 佟 on 2017/5/16.
//  Copyright © 2017年 xj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLRecyclePicModel;
@interface FLAdvertTopicPictures : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray<FLRecyclePicModel *> *data;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger total;

@end
@interface FLRecyclePicModel : NSObject

@property (nonatomic, copy) NSString *details;

@property (nonatomic, copy) NSString *topicCondition;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, assign) NSInteger attentNum1;

@property (nonatomic, copy) NSString *detailchart;

@property (nonatomic, copy) NSString *invalidTime;

@property (nonatomic, assign) NSInteger advertId;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, copy) NSString *sitethumbnail;

@property (nonatomic, assign) NSInteger hideGift;

@property (nonatomic, copy) NSString *topicExplain;

@property (nonatomic, assign) NSInteger uv;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *thumbnail;

@property (nonatomic, copy) NSString *createTime2;

@property (nonatomic, assign) NSInteger receiveNum;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *topicTheme;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger useNum1;

@property (nonatomic, assign) NSInteger isSpecial;

@property (nonatomic, copy) NSString *pictureCode;

@property (nonatomic, assign) NSInteger attentNum;

@property (nonatomic, assign) NSInteger assiNum1;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *fileName2;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, assign) NSInteger transformNum1;

@property (nonatomic, assign) NSInteger state2;

@property (nonatomic, assign) NSInteger enable;

@property (nonatomic, copy) NSString *publishTime;

@property (nonatomic, assign) NSInteger totop;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, assign) NSInteger topicId;

@property (nonatomic, copy) NSString *filePath2;

@property (nonatomic, assign) NSInteger isPhNum;

@property (nonatomic, assign) NSInteger pv;

@property (nonatomic, copy) NSString *topicType;

@property (nonatomic, assign) NSInteger rankCount1;

@property (nonatomic, assign) NSInteger receiveNum1;

@property (nonatomic, copy) NSString *rule;

@property (nonatomic, copy) NSString *lowerTime;

@property (nonatomic, copy) NSString *topicTag;

@property (nonatomic, assign) NSInteger operType;

@property (nonatomic, assign) NSInteger useNum;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, assign) NSInteger transformNum;

@property (nonatomic, assign) NSInteger pv1;

@property (nonatomic, copy) NSString *frontSize;

@property (nonatomic, assign) NSInteger assiNum;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *creator;

@property (nonatomic, assign) NSInteger favNum1;

@property (nonatomic, copy) NSString *topicRange;

@property (nonatomic, assign) NSInteger topicPrice;

@property (nonatomic, assign) NSInteger rankCount;

@property (nonatomic, assign) NSInteger favNum;

@property (nonatomic, copy) NSString *userType;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, assign) NSInteger uv1;

@property (nonatomic, copy) NSString *upperTime;

@property (nonatomic, assign) NSInteger commentCount1;

@property (nonatomic, copy) NSString *creator2;

@property (nonatomic, assign) NSInteger topicNum;

@end

