//
//  FLIssueInfoModel.h
//  FreeLa
//
//  Created by Leon on 15/12/3.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLIssueInfoModel : NSObject

/**活动开始时间*/
@property (nonatomic , strong)NSString* flactivityTimeBegin;
/**活动截止时间*/
@property (nonatomic , strong)NSString* flactivityTimeDiedline;
/**活动失效时间*/
@property (nonatomic , strong)NSString* flactivityTimeUnderLine;
/**活动报名时间*/
@property (nonatomic , strong)NSString* flactivityTimeIssue;
/**活动地点用于显示*/
@property (nonatomic , strong)NSString* flactivityAdress;
/**活动地点经度*/
@property (nonatomic , strong)NSString* flactivityAdressJD;
/**活动地点韦度*/
@property (nonatomic , strong)NSString* flactivityAdressWD;
/**市面价值*/
@property (nonatomic , strong)NSString* flactivityValueOnMarket;
/**数量上限*/
@property (nonatomic , strong)NSString* flactivityMaxNumberLimit;
/**活动主题*/
@property (nonatomic , strong)NSString* flactivityTopicSubjectStr;
/**使用说明*/
@property (nonatomic , strong)NSString* flactivityTopicIntroduceStr;
/**领取人群*/   //FLFLXJSquareIssueOVERTPick
@property (nonatomic , strong)NSString* flactivityTopicRangeStr;
/**领取条件*/
@property (nonatomic , strong)NSString* flactivityPickConditionKey;
/**领取规则*/
@property (nonatomic , strong)NSString* flactivityPickRulesKey;
/**助力抢规则*/
@property (nonatomic , strong)NSString* flactivityPickRulesStr;
/**最低助力数*/
@property (nonatomic , strong)NSString* flactivityPickRulesLimitNumberStr;
/**每天几次*/
@property (nonatomic , strong)NSString* flactivityPickRulesHowNumberStr;

/**缩略图Str*/
@property (nonatomic , strong)NSString* flactivitytopicThumbnailStr;
/**缩略图fileName*/
@property (nonatomic , strong)NSString* flactivitytopicThumbnailFileName;
/**详情图Array*/
@property (nonatomic , strong)NSArray* flactivitytopicDetailchartArr;
/**轮播图filename*/
@property (nonatomic , strong)NSString* flactivitytopicDetailchartFileName;

/**活动详情*/
@property (nonatomic , strong)NSString* flactivitytopicDetailStr;
/**活动分类*/
@property (nonatomic , strong)NSString* flactivitytopicCategoryStr;

/**是不是助力抢*/
@property (nonatomic , assign)BOOL flIsHelpParmShow;
/**是不是每人每天几次*/
@property (nonatomic , assign)BOOL flIsDAYPerTimes;
/**发布的活动类型*/
@property (nonatomic , strong)NSString* flissueActivityFromType;
/**发布的活动状态 0 草稿 1 发布 2撤回*/
@property (nonatomic , assign)NSInteger xjIssueState;

/**发布的活动topicID*/
@property (nonatomic , assign)NSInteger xjTopicId;

/**用户报名限制*/
@property (nonatomic , strong)NSString* flactivitytopicLimitTags;

/**用户报名限制的keyvalue*/
@property (nonatomic , strong)NSString* flfuckPartInfoServiceStr;

/**分类数组(最后一页标签)*/
@property (nonatomic , strong)NSArray* flLastPageBQArray;
/**分类数组(最后一页标签Id)*/
@property (nonatomic , strong)NSArray* flLastPageBQTagIdArray;
/**分类数组(最后一页标签userId)*/
@property (nonatomic , strong)NSArray* flLastPageBQTagUserIdArray;
/**分类数组(最后一页标签不可删除)*/
@property (nonatomic , strong)NSArray* flLastPageBQTagCanNotDeleteArray;

/**用户报名限制新增数组*/
@property (nonatomic , strong) NSArray* flPartInfoKeyValueArray;

/**用户再次保存草稿的问题*/
@property (nonatomic , strong) NSString* detailId;

/**用户选择的好友*/
@property (nonatomic , strong) NSString* xjChoiceRangStr;

/**用户选择的好友字段(再发一条的值)*/
@property (nonatomic , strong) NSDictionary* xjChoiceRangDic;

/**url*/
@property (nonatomic , strong) NSString* url;

/**是否藏宝*/
@property (nonatomic , assign) NSInteger hideGift;

/**LBS或LBS+AR*/

@property(nonatomic,assign)NSInteger LBSorAR;

@end











