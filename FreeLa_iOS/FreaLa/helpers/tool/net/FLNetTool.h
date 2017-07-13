//
//  FLNetTool.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/20.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLHeader.h"
#import "FLHTTPRequestTool.h"
//#import <SMS_SDK/SMSSDK.h>
#import "FLUserInfoModel.h"
@interface FLNetTool : NSObject


/**
 *  注册
 *
 *  @param param   传入参数模型
 */
+ (void)registerAccountWithnikeName:(NSString*)nikeName phone:(NSString*)phone passWord:(NSString*)passWord success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;
/**
 *  首页登陆
 *
 *  @param param   传入参数模型
 */
+ (void)logInWithPhone:(NSString*)phone password:(NSString*)password success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;
/**
 *  判断手机号是否注册
 *
 *  @param param   传入参数模型
 */
+ (void)isAlreadyRegistedWithPhone:(NSString*)phoneNumber success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;

/**
 *  忘记密码
 *
 *  @param param   传入参数模型
 */
+ (void)forgetPasswordWithPhone:(NSString*)phone newPassword:(NSString*)newPassword success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;


//post
/**
 *  商家注册
 *
 *  @param param   传入参数模型
 */

//+ (void)registerAccountWithcheckCode:(NSString*)checkCode email:(NSString*)email passWord:(NSString*)passWord success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;
/**
 *  商家注册（邮箱发送验证码）
 *
 *  @param param   传入参数模型
 */
+ (void)sendVerifityCodeWithEmail:(NSString*)email success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;

/**
 *  上传图片(头像)
 *
 *  @param param   传入参数模型
 */
+ (void)uploadHeadImage: (UIImage *)image success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  修改密码(个人)
 *
 *  @param param   传入参数模型
 */
+ (void)changeMyPasswordWithPhone:(NSString*)phone OldPassword:(NSString*)oldPassword NewPassword:(NSString*)newPassword success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  修改密码(商家)
 *
 *  @param param   传入参数模型
 */
+ (void)changeMyPasswordWithEmail:(NSString*)email OldPassword:(NSString*)oldPassword NewPassword:(NSString*)newPassword success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  邮箱已注册数(商家)
 */

+ (void)howManyAccountWithEmailBilnd:(NSString*)Email success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  查看用户所有信息
 */
+ (void)checkOutUserInfoSesssionID:(NSString*)sesssion success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *获取商家列表
 */
+ (void)findAllCompInfoWithSession:(NSString*)session success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;




#pragma mark -------重写

//重写 post请求
/**
 *  重写修改密码(个人和商家)
 *
 *  @param param   传入参数模型
 */
+ (void)changeMyPasswordWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  重写获取个人资料接口
 *
 *  @param param   传入参数模型
 */
+ (void)seeInfoWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  重写上传(修改)个人资料接口
 *
 *  @param param   传入参数模型
 * NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"sex\":\"%ld\",\"userId\":\"%@\"}",sessionId,(long)_selectedCell,my_userId];
 * NSLog(@"parmdic= %@",parmDic);
 *NSDictionary* parm = @{@"peruser":parmDic};
 */
+ (void)updatePerWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  重写上传(修改)头像接口
 *  @param param   传入参数模型
 */
+ (void)uploadHeadImage: (UIImage *)image parm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *   上传营业执照接口
 *  @param param   传入参数模型
 */
+ (void)xjUploadYYZZImage: (UIImage *)image parm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  重写上传评价图片接口
 *  @param param   传入参数模型
 */
+ (void)xjUploadPJCommentsImage: (UIImage *)image parm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  重写判断邮箱已注册数量接口
 *  @param param ：email
 */
+ (void)howManyAccountWithEmailBilndparm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  重写邮箱注册
 *  @param param ：email
 */
+ (void)registerBusinessAccountWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  重写验证邮箱(还有个人)发送的验证码
 *  @param param ：参数模型
 */
+ (void)checkEmailVerifityParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  重写使用付费短信发送验证码
 *
 *  @param param ：参数模型
 */
+ (void)sendVerifityCodeByPayParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  重写切换账号
 *
 * @param token
 * @parm  password
 * @parm  account
 * @Parm  accountType @"comp"&"person"
 */
+ (void)exchangeAccountWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  重写个人注册
 *
 * @param nikeName
 * @parm  password
 * @parm  account
 * @Parm  accountType @"comp"&"person"
 */
+ (void)registerAccountWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  重写查看与我关联商家号个数
 *
 * @param token
 */
+ (void)checkNumbersOfblindWithMyselfWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  重写上传(修改)商家资料接口
 *
 *  @param param   传入参数模型
 * NSString* parmDic = [NSString stringWithFormat:@"{\"token\":\"%@\",\"sex\":\"%ld\",\"userId\":\"%@\"}",sessionId,(long)_selectedCell,my_userId];
 * NSLog(@"parmdic= %@",parmDic);
 *NSDictionary* parm = @{@"peruser":parmDic};
 */
+ (void)updateCompInfoWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 解绑商家
 * @param  userid
 * @param  busID
 */
+ (void)revokeMyBusApplyWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

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

+ (void)flUpDateBusinessInfoWithParm:(NSDictionary*)parm  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;





#pragma mark -------第二里程碑部分
//

/**
 * 行业选择
 * @param  token
 */
+ (void)chooseIndustryWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 获取领取条件
 * @param  token
 */
+ (void)getTakeConditionsWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 校验简称
 * @param  token
 */
+ (void)checkNickNameWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 上传接口
 * @param  token
 */
+ (void)checkNickNamWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;


/**
 * 获取详情接口
 * @param  topic.topicId
 * @param  userType
 * @param  userId
 */

+ (void)getDetailsForHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 获取详情中评论列表接口
 * @param  commentPara
 */
+ (void)getJudgeListForHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 发布活动接口
 * @param  topicPara
 * @param  token
 * @parm hideGift    1为藏宝  2 为非藏宝
 */
+ (void)issueANewActivityWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 获取广场列表
 * @param page.pageSize
 * @param topic.topicType
 * @param page.currentPage
 */
+ (void)getSquareInfoWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  发布----上传图片
 *
 *  @param param   传入参数模型
 */
+ (void)setIssueDetailImage: (UIImage *)image parm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  获取详情图
 *  @param topicId   传入参数模型
 */
+ (void)getDetailImageStrInHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  获取评分星星
 *  @param  commentPara {businessId：@""}   传入参数模型
 */
+ (void)getRankCountMapInHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  判断是否具有领取资格
 *  @param topicId   传入参数模型
 */
+ (void)checkReceiveInfoInHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  获取助力列表
 *  @param topicId   传入参数模型
 */
+ (void)htmlReceiveInfoInHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  获取评价列表
 *  @param commentPara {businessId：@""，commentType":,isFlush:}   传入参数模型
 */
+ (void)htmlListCommentInHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

#pragma mark ------ 我的
/**
 * 获取用户主题列表(我发布的)
 * @parm page.currentPage
 * @parm search.topicId
 * @Parm search.userId
 */
+ (void)searchTopicListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 再发一条，用于数据回填的接口
 * @parm topic.topicId
 */
+ (void)getTopicForIssueAgainByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 * 获取用户主题列表(我领取的)
 * @parm page.currentPage
 * @parm search.topicId
 * @Parm search.userId
 */
+ (void)searchTopicReceiveListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 * 获取我发布的中(领取列表)
 * @parm page.currentPage
 * @parm search.topicId
 * @Parm search.userId
 */
+ (void)searchMyReceiveListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;




#pragma mark-----HTML
/**
 * 获取个人助力列表
 * @parm page.currentPage
 * @parm topicPromote.topicId
 * @Parm topicPromote.participateId
 */
+ (void)HTMLfindTopicPromoteListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 获取活动助力列表
 * @parm page.currentPage
 * @parm topicPromote.topicId
 * @Parm topicPromote.participateId
 */
+ (void)HTMLfindParticipateListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;


/**
 * 插入领取记录
 * @parm participateDetailes.topicId
 * @parm participateDetailes.userId
 * @Parm participateDetailes.userType
 * @Parm participateDetailes.creator
 * @parm participateDetailes.message 非必须
 */
+ (void)HTMLsaveATopicInMineByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 * 获取详情
 * @parm topic.topicId
 * @parm userType
 * @Parm userId
 */
+ (void)HTMLSeeTopicDetailsByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 插入评论(回复)
 * @parm  businessId             topic.topicId
 * @parm commentType            评论类型 0 评论 1 打分 2回复 默认0
 * @parm parentId               userId
 * @Parm content                内容
 */
+ (void)HTMLinsertCommentByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 回复评论列表
 * @parm userId
 * @parm userType
 * @parm commentPara - = {} json串 里面传参数parentId 表示被回复的评论commentid
 */
+ (void)HTMLRejudgeListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 获取填写领取信息列表
 * @parm topic.userId
 * @parm topic.partInfo
 */
+ (void)HTMLGetPartInfoListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 * 插入参与记录只要是点领取按钮就会调用
 * @parm participate.topicId 主题id
 * @parm participate.userId 用户id
 * @Parm participate.userType 用户类型
 * @Parm participate.creator 创建人id
 */
+ (void)HTMLinsertParticipateInMineByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 * 插入助力记录(给别人助力一次)
 * @parm page.currentPage
 * @parm topicPromote.topicId
 * @Parm topicPromote.participateId 助力Id
 * @Parm topicPromote.userId 用户id
 */
+ (void)HTMLInsertTopicPromoteInMineByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 * 验票、使用票券
 * @parm participateDetailes.detailsid - 领取id
 * @parm participateDetailes.topicId - 主题id
 * @Parm participateDetailes.creator - 用户id
 */
+ (void)fluseDetailesByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  导出excle
 *  @param param   topicId
 */
+ (void)flgetTopicReceiveListByTopId:(NSString*)flTopicId success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;


/**
 *  第三方登陆
 * perModel.unionid 第三方登录唯一id
 * perModel.nickname 用户昵称
 * perModel.avatar 用户头像
 * perModel.sex 0女 1男 2保密
 * perModel.source 来源  1、PC 2、Android 3iOS、4、QQ 5、微信 6、新浪 7、人人 8、机器人
 */
+ (void)flLogInWithThirdByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;

/**
 *  查看助力详细数据、排名等
 * topic.topicId
 * userId
 * userType
 */
+ (void)flGetHelpListDetailsByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;
#pragma mark 这是一键反馈
/**
 *  查看助力详细数据、排名等
 * info.creator
 * info.type
 * info.infoRemark
 */
+ (void)flideaBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;

#pragma mark 收藏
/**
 * 添加收藏
 * token
 * userId
 * topicId
 */
+ (void)flAddcollectionTopicBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;

/**
 * 取消收藏
 * token
 * userFavonites.userId
 * userFavonites.topicId
 */
+ (void)flquitecollectionTopicBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;
/**
 * 是否收藏
 * token
 * userId
 * topicId
 */
+ (void)flIscollectionTopicBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;


#pragma mark 发布标签
//获取活动标签接口
// "/app/publishs!getion";
//增加活动标签接口
// "/app/publishs!addTag.action";
//删除活动标签接口
//"/app/publishs!delTag.action";

/**
 * 获取活动标签
 */
+ (void)flPubTopicListBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;


/**
 * 撤销活动 2   草稿更改状态 传1
 */
+ (void)flLeftTopicBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;

/**
 * 添加活动标签
 */
+ (void)flPubTopicListAddTagByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 删除活动标签
 */
+ (void)flPubTopicListRemoveTagByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;

/**
 * 分享
 */
+ (void)flPubTopicShareFriendAnyTypeByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;

/**
 * 详情用的发布者 ？？？
 */
+ (void)flHTMLGetPublisherMessageByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 我参与的
 */
+ (void)xjfindParticipateNotReceiveByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;

/**
 * 待评价的
 */
+ (void)xjuserTopicListByCommentByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 收藏列表
 */
+ (void)xjdeleteFavonitesByCommentByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;

/**
 * 添加好友
 * @parma owerName  :
 * @parma
 */
+ (void)xjAddFriendsByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 检查是否是好友
 * @parma owerName  :
 * @parma
 */
+ (void)xjCheckIsFriendsByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 *  获取 unionid
 *  @param     access_token
 *  @parma     openid
 */
+ (void)xjGetunionidWithToken:(NSString*)xjToken openId:(NSString*)xjOpenId success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;

//getParticipateDetailesById
/**
 *  刷新票券状态
 *  @param
 *  @parma
 */
+ (void)xjgetParticipateDetailesByIdWithParma:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure;
/**
 * 关注列表
 */
+ (void)xjfindAttentListByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;

/**
 * 关注列表
 */
+ (void)xjrecommendListByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;


/**
 * 请求好友列表
 */
+ (void)xjfindListByIdsByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 券码
 */
+ (void)xjGetTicketNumber:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;

/**
 * 获取未读消息列表
 */
+ (void)xjGetPushMessagesByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 获取未读(详细)消息列表
 */
+ (void)xjGetDetailPushMessagesByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 更新消息状态
 */
+ (void)xjChangePushMessageState:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;

/**
 * 通过手机号查找环信id加好友
 */
+ (void)xjgetPersonByPhone:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;

/**
 * 通过昵称查找环信id加好友
 */
+ (void)xjgetPersonInfoByNickName:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;


/**
 * 通过commentId 查找评论内容及评论人信息
 * @parma comment.commentId
 */
+ (void)xjgetPersonInfoForJPushByCommentId:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;

/**
 * 获取首页的推荐列表
 */
+ (void)xjgetRcommendTopicListByCommentId:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 获取广告页单页图片
 */
+ (void)xjgetRcommendTopicImageByCommentId:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 获取广告页单 导航栏图片
 */
+ (void)xjgetNaviRecommendImageById:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 详情页中的搜索
 * @parm userId 用户id
 * @parm participate.topicId 活动id
 * @parm participate.nickname 用户昵称
 */
+ (void)xjSearchHTMLDetailsByCommentId:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;
/**
 * 请求H5
 * @parm userId 用户id
 */
+ (void)xjRequestHtmlOUTBytempId:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure;

/**
 *  上传图文详情图片
 *
 *  @param param   传入参数模型
 */
+ (void)xjUploadTWDetailImage: (UIImage *)image success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  查找自己排名
 *  @parma  participate.topicId
 *  @param participate.participateId   传入参数模型
 */
+ (void)xj_findMyRankInHelpList: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;


/**
 *  刷新首页pv
 *  @parma  advertId
 *  192.168.20.8:8080/app/users!increaseAdvertPv.action
 */
+ (void)xj_updatePvWithparma: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  刷新首页点击量
 *  @parma  advertId
 *  192.168.20.8:8080/app/users!increaseAdvertLinkNum.action
 */
+ (void)xj_updateLinkNumWithparma: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  请求转发策略
 *  @parma  topic.topicId
 *  : 192.168.20.218:9000/app/users!getPlanByTopicId.action
 */
+ (void)xj_getPlanByTopicId: (NSString *)xjTopicId success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  请求版本号
 *  @parma  versionType
 */
+ (void)xj_GetVersionSuccess:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  上传用户版本号
 *  @parma  accountType
 *  @parma  userid
 *  @parma  appVersion
 */
+ (void)xj_uploadVersionNumber: (NSString *)appVersion success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  检查 手机号是否绑定同类账号
 *  @parma  phonenumber
 *  @parma  appVersion
 *  返回值： 0:手机号未注册  1:已注册但未绑定指定的第三方帐号 2：已注册并且绑定过指定的第三方帐号
 */
+ (void)xj_checkPhoneBlindType: (NSInteger)source phone:(NSString*)phone  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  发布 藏礼包活动
 *  @parma
 *  @parma
 *
 */
+ (void)xj_publishGiftTopic: (NSDictionary*)parm  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  获取 gif 列表
 */
+ (void)xj_getGifListSuccess:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *  检查 通过子账户userid获取主账号token的接口
 *   前置条件：      用户已登录
 *  @parma  userid
 */
+ (void)xj_getMainUsrToken: (NSString *)userid success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

+ (void)xj_checkPhoneBlindType: (NSInteger)source phone:(NSString*)phone  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  test（废弃）
 */
+ (void)xj_testsss: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;



/**
 *   通过后台获取 筛选后 的礼包地图数据
 *  @parma  city=北京市&positon=116.320862,39.970564&distance=1000000&userid=10000&compid=2324
 *  @parma searchType A：首页扫描，获取商家发布的(正在进行) B:地图扫描，获取商家发布的(包含未开始) C：首页扫描，获取免费啦发布的(正在进行) D:首页扫描，获取免费啦发布的(包含未开始)
 */
+ (void)xjGetGiftMapResultsFromServer: (NSDictionary *)parm searchType:(NSString*)sType success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;


/**
 *  测试全免费
 */
+ (void)xjTestAllfreenew: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
+ (void)xjTestAllfreenewxjxj: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
///**
// *  测试全免费
// */
//+ (void)xjTestAllfreenew: (NSDictionary *)parm searchType:(NSString*)sType success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *   通过后台获取  天空的礼包地图数据
 */
+ (void)xjGetSkyGiftpResultsFromServer: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;


/**
 轮播数据加载
 接口名称：http://www.freela.com.cn/app/users!getAdvertTopic.action
 接口参数：无
 获取图片参数：FilePath2
 */
+ (void)xjGetRecyclePics:(NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *   获取助力抢活动
 接口名称：http://www.freela.com.cn/app/publishs!zlqTopicList.action
 接口参数：无
 获取图片参数：Thumbnail
 */
+ (void)xjGetzlqTopicList:(NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *   获取全免费接口
 接口名称：http://www.freela.com.cn/app/publishs!topicList.action?
 接口参数：page.currentPage:（当前页数）
 topic.topicType:  FREE(固定值)
 获取图片参数：Thumbnail
 */
+ (void)xjGetAllFreeList:(NSInteger)pageNum  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  获取优惠券接口
 接口名称：http://www.freela.com.cn/app/publishs!topicList.action?
 接口参数：page.currentPage:（当前页数）
 topic.topicType:  COUPON(固定值)
 获取图片参数：Thumbnail
 */
+ (void)xjGetCouponList:(NSInteger)pageNum success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *   获取专题活动接口
 接口名称：http://www.freela.com.cn/app/publishs!getNewOneZx.action
 接口参数：无
 获取图片参数：Thumbnail
 */
+ (void)xjGetNewOneList:(NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *   获取专享活动接口
 接口名称：http://www.freela.com.cn//app/publishs!zxTopicList.action
 接口参数：无
 
 获取图片参数：Thumbnail
 */
+ (void)deGetZxTopicList:(NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *   获取那个detailsid 接口
 接口名称：http://www.freela.com.cn/app/publishs!getDetailsIdByUserIdAndTopicId.action?
 接口参数：   params.put("topicId", topicId);
            params.put("userId", userId);
 */
+ (void)xjxjGetDetailsIdWith:(NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *   集星主活动
 接口名称:http://www.freela.com.cn/app/publishs!getNewIsMain.action?
 接口参数 :无参数
 */
+(void)deGetNewIsMainWith:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;

/**
 *   集星子活动
 接口名称:http://www.freela.com.cn/app/publishs!getIsChildList.action?
 接口参数 :无参数

 */
+(void)deGetIsChildListWith:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  集星子活动我集了几颗星
 接口名称:http://www.freela.com.cn/app/publishs!topicReceiveList.action?
 接口参数:participateDetailes.userId:用户id
        participateDetailes.userType:person(固定)
        participateDetailes.isChild:1(固定)
        participateDetailes.startTime:开始时间
        participateDetailes.endTime:结束时间
 */
+(void)deTopicReceiveListWith:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
/**
 *  地图Mark接口
 接口名称:http://www.freela.com.cn/app/publishs!getAdminMark.action?
 接口参数:无参数
 */
+(void)deGetAdminMarkListWith:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
@end























