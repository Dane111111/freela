//
//  FLConst.h
//  FreeLa
//
//  Created by Leon on 15/11/13.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FLConst : NSObject


//+ (instancetype)shareInstance;

//@property (assign, nonatomic) BOOL FLFLIsPersonalAccountType;

/**选择的账号，0为个人，从1开始为商家，但是在row里需要减1*/
UIKIT_EXTERN NSInteger FLFLSelectedAccountNumber ;

/**选择的账号类别,1为个人账号 */
UIKIT_EXTERN BOOL      FLFLIsPersonalAccountType;
/**正在请求，按钮的状态,0为未选中*/
UIKIT_EXTERN BOOL      FLFLIsRequestingBtn;
/**商家的sessionID*/
UIKIT_EXTERN const NSString*  FLFLBusSesssionID;
/**商家的UserID*/
UIKIT_EXTERN const NSString*  FLFLXJBusinessUserID;
/**商家的头像地址*/
UIKIT_EXTERN const NSString*  FLFLXJBusinessUserHeaderImageURLStr;
/**商家的nickname*/
UIKIT_EXTERN const NSString*  FLFLXJBusinessNickNameStr;

/**个人修了标签的消息改*/
//UIKIT_EXTERN const NSString*  FLFLXJNOtiuserAlreadyChangeItsTags;
/**关于商家界面，1为申请进入 0为审批拒绝或更新信息进入*/
UIKIT_EXTERN BOOL  FLFLXJISApplyBusOrRevokeMyAccount;
/**关于商家申请界面,选中的userid*/
UIKIT_EXTERN const NSString*  FLFLXJISApplyBusOrRevokeMyUserID;
/**关于修改内容,1为修改昵称 ，  0 为修改联系人*/
UIKIT_EXTERN BOOL      FLFLXJIsChangeNickNameType;
/**关于手机号,1为有 ，  0 为没有*/
UIKIT_EXTERN BOOL      FLFLXJIsHasPhoneBlind;
/**发出通知，切换了用户状态*/
UIKIT_EXTERN  NSString* const XJXJISCHANGEDUSERLOG;

/**我的发布，用户报名限制*/
//UIKIT_EXTERN BOOL      FLFLXJIsChangeNickNameType;

//HTML

/**usertype tagH*/
UIKIT_EXTERN  CGFloat FLFLXJUserTagHFloatValue;
/**usertype tagH 要不要加35*/
UIKIT_EXTERN  NSInteger FLFLXJUserTagHFloatValueIsAddOne;
/**usertype 个人*/
UIKIT_EXTERN  NSString* const FLFLXJUserTypePersonStrKey;
/**usertype 商家*/
UIKIT_EXTERN  NSString* const FLFLXJUserTypeCompStrKey;

#pragma mark -----------发布

/**发布中，0为无数据 1为 数据回填进入*/
UIKIT_EXTERN BOOL  FLFLXJIssueWithDataOrNot;
//显示类型
/**全免费Show*/
UIKIT_EXTERN  NSString* const FLFLXJSquareAllFreeStr;
/**优惠券*/
UIKIT_EXTERN  NSString* const FLFLXJSquareCouponseStr;
/**个人Show*/
UIKIT_EXTERN  NSString* const FLFLXJSquarePersonStr;

/**每人每天*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssuePerOneDay;
/**无限制*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueUNLIMITED;
/**每人一次*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssuePerOnce;
//发布类型
/**全免费Key*/
UIKIT_EXTERN  NSString* const FLFLXJSquareAllFreeStrKey;
/**优惠券Key*/
UIKIT_EXTERN  NSString* const FLFLXJSquareCouponseStrKey;
/**个人Key*/
UIKIT_EXTERN  NSString* const FLFLXJSquarePersonStrKey;

/**开始时间*/
UIKIT_EXTERN  NSString* const FLFLXJIssueInfoStartTimeKey;
#pragma mark ----领取方式
//领取方式
/**助力抢Show*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueHelpPick;
/**关注领Show*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueCarePick;
/**转发领Show*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueRelayPick;
/**随心领Show*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueNonePick;

/**助力抢Vlaue*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueHelpPickVlaue;
/**关注领Vlaue*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueCarePickVlaue;
/**转发领Vlaue*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueRelayPickVlaue;
/**随心领Vlaue*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueNonePickVlaue;

#pragma mark ---- 领取人群
/**陌生人Show*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueSTRANGERPick;
/**附近的人Show*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueAROUNDPick;
/**朋友Show*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueFRIENDPick;
/**公开Show*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueOVERTPick;

/**陌生人Vlaue*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueSTRANGERPickVlaue;
/**附近的人Vlaue*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueAROUNDPickVlaue;
/**朋友Vlaue*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueFRIENDPickVlaue;
/**公开Vlaue*/
UIKIT_EXTERN  NSString* const FLFLXJSquareIssueOVERPickVlaue;


#pragma mark ----HTML
/**插参与记录的*/
UIKIT_EXTERN  NSString* const FLFLHTMLInsertParticipate;
/**通知给回复评论界面传参*/
UIKIT_EXTERN  NSString* const FLFLHTMLInfoReJudgeWindow;
/**通知回复评论弹出层*/
UIKIT_EXTERN  NSString* const FLFLHTMLAlertReJudgeWindow;

/**通知获取领取信息*/
UIKIT_EXTERN  NSString* const FLFLHTMLGetPartInfoList;
/**领取信息填写完毕提交数据*/
UIKIT_EXTERN  NSString* const FLFLHTMLSetPartInfoList;
/**点击转发领*/
UIKIT_EXTERN  NSString* const FLFLHTMLActionRelayPickClick;
/**给助力抢页面传参，用活动助力抢data*/
UIKIT_EXTERN  NSString* const FLFLHTMLActionZhuliqiangListClick;
/**给个人助力抢页面传参userid*/
UIKIT_EXTERN  NSString* const FLFLHTMLActionPerZhuliqiangListClick;
/**给别人助力*/
UIKIT_EXTERN  NSString* const FLFLHTMLActionPerZhuliqiangHelpClick;
/**给别人助力*/
UIKIT_EXTERN  NSString* const FLFLHTMLNotiRelayToPickClick;

/**推送消息*/
UIKIT_EXTERN  NSString* const XJPushMessageByCertify; //审批认证消息
UIKIT_EXTERN  NSString* const XJPushMessageBySystem; //系统消息
UIKIT_EXTERN  NSString* const XJPushMessageByJudge; //评论消息
UIKIT_EXTERN  NSString* const XJPushMessageByReJudge; //回复评论消息
UIKIT_EXTERN  NSString* const XJPushMessageByJudgePJ; //评价消息
UIKIT_EXTERN  NSString* const XJPushMessageByDueReming; //到期提醒
UIKIT_EXTERN  NSString* const XJPushMessageByCanPickUp; //达到领取资格提醒消息
UIKIT_EXTERN  NSString* const XJPushMessageByAlreadyPick; //领取消息
UIKIT_EXTERN  NSString* const XJPushMessageByAutorize; //授权消息
UIKIT_EXTERN  NSString* const XJPushMessageByBusPush; //商家推送消息
UIKIT_EXTERN  NSString* const XJPushMessageByHelpMessage; //助力消息



#pragma mark ------ ------- ------ ------- ------- ------  noti

UIKIT_EXTERN  NSString* const XJNotiOfQuitOrChangeAccountMessage; //退出登录& 切换账号

@end



































