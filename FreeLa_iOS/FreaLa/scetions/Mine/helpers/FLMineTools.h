//
//  FLMineTools.h
//  FreeLa
//
//  Created by Leon on 15/12/24.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLMyIssueInMineModel.h"
#import "FLTool.h"
#import "FLMyIssueJudgePlModel.h"
#import "FLMyIssueJudgePJModel.h"
#import "FLMyReceiveListModel.h"
#import "FLUserInfoModel.h"
#import "XJMyPartInInfoModel.h"
#import "XJMyWeaitPJModel.h"

@interface FLMineTools : NSObject

+ (NSArray* )returnMyIssueInMineModelsWithDictionary:(NSDictionary*)dic type:(NSInteger)indexPage;

/**
 *通过日期string 返回年、月、日
 */
+ (NSString*)returnDateStrWithDateStr:(NSString*)dateStr ForType:(NSInteger)needType;


/**
 * 返回评论列表的模型数组
 */
+ (NSArray*)returnJudgePLModelWithDic:(NSDictionary*)dicData;

/**
 * 返回评价列表的模型数组
 */
+ (NSArray*)returnJudgePJModelWithDic:(NSDictionary*)dicData;

/**
 * 返回评价模型中cell的高度
 */
+ (CGFloat)returnJudgePJCellHWithPJModel:(FLMyIssueJudgePJModel*)model;

/**返回有几列*/
+ (NSInteger)returnNumberImageLineInSelfWithArray:(NSArray*)arrayCount line:(NSInteger)how;
/**label size*/
+ (CGSize)returnLabelSizeWithString:(NSString*)str viewWidth:(CGFloat)viewW;

/**
 * 返回用户模型
 */
+ (FLUserInfoModel*)returnUserInfoModelWithModel:(NSDictionary*)data;

 
@end








