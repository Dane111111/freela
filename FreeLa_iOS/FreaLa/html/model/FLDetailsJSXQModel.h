//
//  FLDetailsJSXQModel.h
//  FreeLa
//
//  Created by Leon on 15/12/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "FLConst.h"
#import "FLHeader.h"
#import "FLNetTool.h"
#import "FLTool.h"
#import "FLSquareAllFreeModel.h"
@protocol JavaScriptObjectiveCDelegate <JSExport>
/**点击领取事件*/  //test
- (void)showAlert:(NSString*)title Msg:(NSString*)msgs;
/**点击评价获取评价列表*/
//- (void)getJudgeListgetJudgeListAndStar;
 
/**测试文本*/
- (void)getJubaoTextAndSendToService:(NSString*)msgs;

/**用来通知调用哪个js方法*/
- (void)setHTMLCallJSMethodWithNSInteger;

#pragma mark -------real
/**点击插入参与记录*/
- (void)flinsertParticipate;
/**进入评论页面，给界面传参*/
- (void)takeParmToNextPgeName:(NSString*)name Image:(NSString*)image Time:(NSString*)time Content:(NSString* )content CetID:(NSString*)cetId;
/**通知弹出层*/
- (void)alertPopViewInhtmlReJudge;
 
/**点击领取、通知获取填写领取信息*/
- (void)getPickPartInfoInHTML;
/**填写领取信息，点击提交按钮*/
- (void)setUpReceiveInfoInHTMLInJubaoJS:(NSString*)jsonStr;
/**给助力抢界面传参，用获取活动助力抢的data*/
- (void)flgetZhuliListInXQJS;
/**个人助力抢界面点击 传参*/
- (void)participateIdInZhuliqiangJS:(NSString*)userId Nickname:(NSString*)nickname;
/**
 *给他点赞(助力)
 */
- (void)flZLinsertPromeInZLJS:(NSString*)userId;
/**
 *通知调起转发
 */
- (void)flNotiRelayInXQJS;
/**
 *关注
 */
- (void)fltakeCareToTopicOwner:(NSString*)flUserId UserType:(NSString*)userType;
/**
 *隐藏导航栏
 */
- (void)flSethiddenWithNavi:(BOOL)isHidden;
 
/**
 * 收藏
 */
- (void)flcollectionTopicInMine;
 

@end



@interface FLDetailsJSXQModel : NSObject<JavaScriptObjectiveCDelegate>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;




@end














