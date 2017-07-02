//
//  FLFinalNetTool.m
//  FreeLa
//
//  Created by Leon on 16/1/13.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLFinalNetTool.h"


#define cuizhihuaurl   @"http://192.168.20.151:8888"
#define guangxiongurl  @"http://192.168.20.55:8080"


@implementation FLFinalNetTool

#pragma mark 第一里程碑
+ (void)flNewGetMyBusApplyListsuccess:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"peruser.userId":FL_USERDEFAULTS_USERID_NEW};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!findAllPerCompInfo.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 5.0f ;
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    [mgr POST:requestStr parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            //            NSLog(@"res = == = = == = =%@",responseObject);
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)flNewGetBusAccountDetailsWithBusId:(NSString*)BusId
                                   success:(void(^)(NSDictionary *data))success
                                   failure: (void(^)(NSError *error))failure
{
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"compAuth.userId":BusId};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!getWSHCompAuth.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


#pragma mark 第二里程碑
+ (void)flNewgetDetailImageStrInHTMLWithTopicId:(NSString*)topicId
                                        success:(void(^)(NSDictionary *data))success
                                        failure: (void(^)(NSError *error))failure{
    
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"topic.topicId":topicId};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getTopicPic.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)flNewexportUserReceiveToExcelWithTopicId:(NSString*)topicId
                                         success:(void(^)(NSDictionary *data))success
                                         failure: (void(^)(NSError *error))failure{
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"search.topicId":topicId};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!exportUserReceiveToExcel.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

+ (void)flNewRegisterBusinessAccountWithsuccess:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSDictionary* parm = @{};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!insertcompUser.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flNewHTMLInsertReportWithTopicId:(NSString*)topicId
                                  userId:(NSString*)userId
                              reportDesc:(NSString*)reportStr
                                 success:(void(^)(NSDictionary *data))success
                                 failure: (void(^)(NSError *error))failure
{
    NSDictionary* parmDic = @{@"report.topicId":topicId,
                              @"report.userId":userId,
                              @"report.reportDesc":reportStr};
    NSDictionary* parm = @{@"report":[FLTool returnDictionaryToJson:parmDic],
                           @"token":FL_ALL_SESSIONID,};
    
    NSDictionary* parmm = @{@"report.topicId":topicId,
                            @"report.userId":userId,
                            @"report.reportDesc":reportStr,
                            @"token":FL_ALL_SESSIONID};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!insertReport.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parmm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)flNewSendEmailWithTitle:(NSString*)fltitle
                        address:(NSString*)fladdress
                        content:(NSString*)flcontent
                 attachementArr:(NSString*)flattaArr
                        success:(void(^)(NSDictionary *data))success
                        failure: (void(^)(NSError *error))failure
{
    NSDictionary* parm = @{@"title":fltitle?fltitle:@"",
                           @"addrees":fladdress,
                           @"content":flcontent?flcontent:@"",
                           @"attachmentArr":flattaArr?flattaArr:@"",
                           @"token":FL_ALL_SESSIONID};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/messages!sendEmail.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}





#pragma mark 第三里程碑

+ (void)flNewPVUVlWithTopicId:(NSString*)fltopicId
                      success:(void(^)(NSDictionary *data))success
                      failure: (void(^)(NSError *error))failure
{
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"topic.topicId":fltopicId};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/stat!queryTopicStatistics.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)xjGetFriendsFromeSerWithStr:(NSString*)xjStr
                            success:(void(^)(NSDictionary *data))success
                            failure: (void(^)(NSError *error))failure {
    NSDictionary* parm = @{@"idsArray":xjStr};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/chats!findListByIds.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetUserIdForCreatGroupFromeSerWithtopicidStr:(NSString*)xjStr
                                                 token:(NSString*)xjToken
                                    searchConditionNum:(NSString*)xjNumber
                                               success:(void(^)(NSDictionary *data))success
                                               failure: (void(^)(NSError *error))failure {
    NSDictionary* parm = @{@"token":xjToken,@"topicId":xjStr,@"searchConditionNum":xjNumber};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!searchOnCreateGroup.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end











