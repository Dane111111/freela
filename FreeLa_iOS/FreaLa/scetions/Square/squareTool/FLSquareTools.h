//
//  FLSquareTools.h
//  FreeLa
//
//  Created by Leon on 15/12/16.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//models
#import "FLSquareAllFreeModel.h"
#import "FLSquareConcouponseModel.h"
#import "FLSquarePersonalIssueModel.h"

#import "FLConst.h"
#import "FLHeader.h"
#import "FLIssueInfoModel.h"

//typedef NS_ENUM(NSInteger,FLTableViewType) {
//    FLTableViewTypeAllFree = 0,
//    FLTableViewTypeConcupos,
//    FLTableViewTypePersonal,
//};

@interface FLSquareTools : NSObject
/**
 *返回全免费的模型
 *@parm  dic
 *@Parm  value
 */
+ (FLSquareAllFreeModel* )returnFLSquareAllFreeModel:(NSDictionary*)data WithIndex:(NSInteger)index;

/**
 *返回全免费的模型数组sss
 *@parm  dic
 *@Parm  value
 */
+ (NSArray* )returnFLSquareAllFreeModelArray:(NSDictionary*)data WithTopicType:(NSString*)type;
/**
 *返回下一步按钮
 */
+ (UIButton*)retutnNextBtnWithTitle:(NSString*)title;
/**
 *返回发布模型
 */
+ (FLIssueInfoModel*)retutnIssueInfoModelWithDic:(NSDictionary*)dic WithModel:(FLIssueInfoModel*)model;

/**
 *根据领取规则的key返回显示的值（随心领助力抢等）
 */
+ (NSString*)returnConditionStrValueWithKey:(NSString*)key;
/**
 *根据key返回value (领取范围哈)
 */
+ (NSString*)returnRankValueWithKey:(NSString*)key;
/**
 *返回图片主色
 */
+ (UIColor*)flMainColorWithImage:(UIImage*)flimage;
/**
 *返回发布分类
 * 全免费、优惠券、个人
 */
+(NSString* )xjReturnTypeStrWithStr:(NSString*)key;

/**
 *是不是先到先得
 */
+(BOOL)xjReturn_is_forstWithStr:(NSString*)key;
/**
 *是不是先到先得,返回字符
 */
+(NSString*)xjReturnStr_is_forstWithStr:(NSString*)key;

@end






