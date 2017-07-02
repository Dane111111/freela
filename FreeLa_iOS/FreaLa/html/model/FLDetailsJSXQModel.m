//
//  FLDetailsJSXQModel.m
//  FreeLa
//
//  Created by Leon on 15/12/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//  方法名前为： 

#import "FLDetailsJSXQModel.h"

@implementation FLDetailsJSXQModel

- (void)showAlert:(NSString*)title Msg:(NSString*)msgs
{
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msgs delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    NSLog(@"this is my niu bi model =%@ =%@",title,msgs);
//    [alert show];
}

 
- (void)getJubaoTextAndSendToService:(NSString*)msgs
{
    FL_Log(@"test jubao messages =%@",msgs);

    
}

//- (void)getJudgeListgetJudgeListAndStar
//{
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"FLFLHTMLJudgeListclickon" object:nil];
//}

- (void)setHTMLCallJSMethodWithNSInteger
{
   
}
#pragma mark -------real
//点击领取
- (void)flinsertParticipate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FLFLHTMLInsertParticipate object:nil];
}
//用于通知评论页 和传参
- (void)takeParmToNextPgeName:(NSString*)name Image:(NSString*)image Time:(NSString*)time Content:(NSString* )content CetID:(NSString*)cetId
{
    FL_Log(@"insert  a judge list in mine =%@，%@，%@,%@<%@",name,image,time,content,cetId);
    NSArray* array = @[name,image,time,content,cetId];
    [[NSNotificationCenter defaultCenter] postNotificationName:FLFLHTMLInfoReJudgeWindow object:array];
}
//通知弹出层
- (void)alertPopViewInhtmlReJudge
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FLFLHTMLAlertReJudgeWindow object:nil];
}

 
//填写领取信息获取partinfo
- (void)getPickPartInfoInHTML
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FLFLHTMLGetPartInfoList object:nil];
}

//填写完领取信息，点击提交按钮
- (void)setUpReceiveInfoInHTMLInJubaoJS:(NSString*)jsonStr
{
    FL_Log(@"under write info to update=%@",jsonStr);
    [[NSNotificationCenter defaultCenter] postNotificationName:FLFLHTMLSetPartInfoList object:jsonStr];
}

//给助力抢界面传参，用活动助力抢详情的data
- (void)flgetZhuliListInXQJS
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FLFLHTMLActionZhuliqiangListClick object:nil];
}
//个人助力抢界面点击 传参
- (void)participateIdInZhuliqiangJS:(NSString*)userId Nickname:(NSString*)nickname
{
    FL_Log(@"this must be deailed userid in model =%@ --52%@",userId ,nickname);
    NSArray* array = @[userId,nickname];
    [[NSNotificationCenter defaultCenter] postNotificationName:FLFLHTMLActionPerZhuliqiangListClick object:array];
}
//给他助力
- (void)flZLinsertPromeInZLJS:(NSString*)userId;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FLFLHTMLActionPerZhuliqiangHelpClick object:userId];
}
//通知调起转发
- (void)flNotiRelayInXQJS
{
   [[NSNotificationCenter defaultCenter] postNotificationName:FLFLHTMLNotiRelayToPickClick object:nil];
}

//关注
- (void)fltakeCareToTopicOwner:(NSString*)flUserId UserType:(NSString*)userType
{
    
    
}

- (void)flSethiddenWithNavi:(BOOL)isHidden
{
    //通知隐藏导航栏
    FL_Log(@"daohanglan daohalgn ======daolandalkfhla");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FLFLHTMSethiddenWithNavi" object:[NSNumber numberWithBool:isHidden]];
}

 

 

@end












