//
//  FLFinalNetTool.h
//  FreeLa
//
//  Created by Leon on 16/1/13.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLNetTool.h"

@interface FLFinalNetTool : NSObject
#pragma mark 第一里程碑
/**
 *  更新个人信息
 *  @param search.topicId
 */
//+ (void)flNewUpDateMySelfInfoWithUserId:(NSString*)UserId
//                                Address:(NSString*)Myaddress
//                                success:(void(^)(NSDictionary *data))success
//                                failure: (void(^)(NSError *error))failure;

/**
 *  注册商家号
 *  @param
 */

//+ (void)flNewRegisterBusinessAccountWithpassWord:(NSString*)password  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  提交商家认证信息
 *  @parm  compAuth.userId - 用户id
 *  @parm  compAuth.userType 用户类型
 *  @parm  compAuth.creator 创建人id
 *  @parm  compAuth.authId 申请id（修改必填）
 *  @parm  compAuth.compName 商家名称
 *  @parm  compAuth.shortName 商家简称 必填
 *  @parm  compAuth.legalPerson 法人 必填
 *  @parm  compAuth.businessLicenseNum 营业执照号 必填
 *  @Parm compAuth.businessLicensePic 营业执照图片路径 必填
 */

//+ (void)flNewUpDateBusinessInfoWithUserId:(NSString*)userId userType:(NSString*)userType creatorId:(NSString*)creatorId applyId:(NSString*)applyId businessFullName:(NSString*)flfullName simpleName:(NSString*)simpleName contextPerson:(NSString*)flperson busLiceneNum:(NSString*)busLiceneNum busLicenePic:(NSString*)busLicenePic  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;




/**
 * 获取商家列表
 * @param  userid
 * @param  busID
 */
+ (void)flNewGetMyBusApplyListsuccess:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;


/**
 *  获取商家审核详细信息
 *  @param  compAuth.userId
 */
+ (void)flNewGetBusAccountDetailsWithBusId:(NSString*)BusId
                                   success:(void(^)(NSDictionary *data))success
                                   failure: (void(^)(NSError *error))failure;



#pragma mark 第二里程碑




/**
 *  获取详情图
 *  @param topicId
 *  改自  getDetailImageStrInHTMLWithParm
 */
+ (void)flNewgetDetailImageStrInHTMLWithTopicId:(NSString*)topicId
                                        success:(void(^)(NSDictionary *data))success
                                        failure: (void(^)(NSError *error))failure;

/**
 *  获取活动全部领取记录
 *  @param search.topicId
 */
+ (void)flNewexportUserReceiveToExcelWithTopicId:(NSString*)topicId
                                         success:(void(^)(NSDictionary *data))success
                                         failure: (void(^)(NSError *error))failure;

/**
 *  举报
 *  @param report
 */
+ (void)flNewHTMLInsertReportWithTopicId:(NSString*)topicId
                                  userId:(NSString*)userId
                              reportDesc:(NSString*)reportStr
                                 success:(void(^)(NSDictionary *data))success
                                 failure: (void(^)(NSError *error))failure;







#pragma mark 第三里程碑
/**
 *  发送邮件(领取列表excle)
 *  @param report
 *  attachementArr  附件数组
 */
+ (void)flNewSendEmailWithTitle:(NSString*)fltitle
                        address:(NSString*)fladdress
                        content:(NSString*)flcontent
                 attachementArr:(NSString*)flattaArr
                        success:(void(^)(NSDictionary *data))success
                        failure: (void(^)(NSError *error))failure;


/**
 *  获取统计数
 *  @param  topic.topicId
 *  attachementArr  附件数组
 */
+ (void)flNewPVUVlWithTopicId:(NSString*)fltopicId
                      success:(void(^)(NSDictionary *data))success
                      failure: (void(^)(NSError *error))failure;

/**
 *  获取好友列表
 *  @param  idsArray  好友数组字符串
 */
+ (void)xjGetFriendsFromeSerWithStr:(NSString*)xjStr
                            success:(void(^)(NSDictionary *data))success
                            failure: (void(^)(NSError *error))failure;

/**
 *  一键建群 请求回来 userid
 *  @param  token
 *  @param  topicId
 *  @param  searchConditionNum    1="已参与" 2="已领取" 3="全部
 */
+ (void)xjGetUserIdForCreatGroupFromeSerWithtopicidStr:(NSString*)xjStr
                                                 token:(NSString*)xjToken
                                    searchConditionNum:(NSString*)xjNumber
                                               success:(void(^)(NSDictionary *data))success
                                               failure: (void(^)(NSError *error))failure;







@end











