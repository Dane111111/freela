//
//  FLConst.m
//  FreeLa
//
//  Created by Leon on 15/11/13.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLConst.h"


@implementation FLConst
/**选中的哪一个账号*/
NSInteger   FLFLSelectedAccountNumber               = 0;

BOOL        FLFLIsRequestingBtn                     = 0;
NSString*   FLFLBusSesssionID                       = @"";
NSString*   FLFLXJBusinessUserID                    = @"";
NSString*   FLFLXJBusinessNickNameStr               = @"";
NSString*   FLFLXJBusinessUserHeaderImageURLStr     = @"";
BOOL        FLFLIsPersonalAccountType               = 1;
BOOL        FLFLXJISApplyBusOrRevokeMyAccount       = 1;
NSString*   FLFLXJISApplyBusOrRevokeMyUserID        = @"";
BOOL        FLFLXJIsChangeNickNameType              = 1;
BOOL        FLFLXJIsHasPhoneBlind                   = 1;
CGFloat     FLFLXJUserTagHFloatValue                = 0;
NSInteger   FLFLXJUserTagHFloatValueIsAddOne        = NO;

//second
#pragma mark --------发布
BOOL  FLFLXJIssueWithDataOrNot  = 0;
NSString* const  FLFLXJSquareAllFreeStr     =   @"全免费";
NSString* const  FLFLXJSquareCouponseStr    =   @"优惠券";
NSString* const  FLFLXJSquarePersonStr      =   @"个人发布";

NSString* const FLFLXJSquareIssuePerOneDay  =   @"DAY";  //没人每天
NSString* const FLFLXJSquareIssueUNLIMITED  =   @"UNLIMITED"; //@"UNLIMITED"无限制   @"ONCE"
NSString* const FLFLXJSquareIssuePerOnce  =   @"ONCE";//每人一次

NSString* const FLFLXJSquareAllFreeStrKey   =   @"FREE";
NSString* const FLFLXJSquareCouponseStrKey  =   @"COUPON";
NSString* const FLFLXJSquarePersonStrKey    =   @"PERSONAL";

NSString* const FLFLXJUserTypePersonStrKey  =   @"person";
NSString* const FLFLXJUserTypeCompStrKey    =   @"comp";

NSString* const FLFLXJIssueInfoStartTimeKey =   @"startTime";

NSString* const FLFLXJSquareIssueHelpPick   =   @"ZHULIQIANG";
NSString* const FLFLXJSquareIssueCarePick   =   @"GUANZHULING";
NSString* const FLFLXJSquareIssueRelayPick  =   @"ZHUANFALING";
NSString* const FLFLXJSquareIssueNonePick   =   @"SUIXINLING";

NSString* const FLFLXJSquareIssueHelpPickVlaue   =   @"助力抢";
NSString* const FLFLXJSquareIssueCarePickVlaue   =   @"关注领";
NSString* const FLFLXJSquareIssueRelayPickVlaue  =   @"转发领";
NSString* const FLFLXJSquareIssueNonePickVlaue   =   @"随心领";

NSString* const FLFLXJSquareIssueSTRANGERPick   =   @"STRANGER";
NSString* const FLFLXJSquareIssueAROUNDPick     =   @"AROUND";
NSString* const FLFLXJSquareIssueFRIENDPick     =   @"FRIEND";
NSString* const FLFLXJSquareIssueOVERTPick      =   @"OVERT";

NSString* const FLFLXJSquareIssueSTRANGERPickVlaue  =   @"陌生人";
NSString* const FLFLXJSquareIssueAROUNDPickVlaue    =   @"附近的人";
NSString* const FLFLXJSquareIssueFRIENDPickVlaue    =   @"朋友";
NSString* const FLFLXJSquareIssueOVERPickVlaue      =   @"公开";

#pragma mark ----HTML
NSString* const FLFLHTMLInsertParticipate           =   @"FLFLHTMLInsertParticipate";
NSString* const FLFLHTMLInfoReJudgeWindow           =   @"FLFLHTMLInfoReJudgeWindow";
NSString* const FLFLHTMLAlertReJudgeWindow          =   @"FLFLHTMLAlertReJudgeWindow";
NSString* const FLFLHTMLGetPartInfoList             =   @"FLFLHTMLGetPartInfoList";
NSString* const FLFLHTMLSetPartInfoList             =   @"FLFLHTMLSetPartInfoList";
NSString* const FLFLHTMLActionRelayPickClick        =   @"FLFLHTMLActionRelayPickClick";
NSString* const FLFLHTMLActionZhuliqiangListClick   =   @"FLFLHTMLActionZhuliqiangListClick";
NSString* const FLFLHTMLActionPerZhuliqiangListClick   =   @"FLFLHTMLActionPerZhuliqiangListClick";
NSString* const FLFLHTMLActionPerZhuliqiangHelpClick   =    @"FLFLHTMLActionPerZhuliqiangHelpClick";
NSString* const FLFLHTMLNotiRelayToPickClick        =   @"FLFLHTMLNotiRelayToPickClick";
NSString* const XJXJISCHANGEDUSERLOG                =   @"XJXJISCHANGEDUSERLOG";


#pragma mark 推送
NSString* const XJPushMessageByCertify          =   @"审批认证消息";
NSString* const XJPushMessageBySystem           =   @"系统消息";
NSString* const XJPushMessageByJudge            =   @"评论消息";
NSString* const XJPushMessageByReJudge          =   @"回复评论消息";
NSString* const XJPushMessageByJudgePJ          =   @"评价消息";
NSString* const XJPushMessageByDueReming        =   @"到期提醒";
NSString* const XJPushMessageByCanPickUp        =   @"达到领取资格提醒消息";
NSString* const XJPushMessageByAlreadyPick      =   @"领取消息";
NSString* const XJPushMessageByAutorize         =   @"授权消息";
NSString* const XJPushMessageByBusPush          =   @"商家推送消息";
NSString* const XJPushMessageByHelpMessage      =   @"助力消息";

#pragma mark ------ ------- ------ ------- ------- ------  noti

NSString* const XJNotiOfQuitOrChangeAccountMessage      =   @"XJNotiOfQuitOrChangeAccountMessage";



@end


























