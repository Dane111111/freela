//
//  FLHTTPRequestTool.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/21.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLHTTPRequestTool.h"

#import "FLTool.h"

#define FL_AF_GOODWORK  mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
@implementation FLHTTPRequestTool

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSLog(@"getMethod:%@", url);
#warning 想要AF好好工作解析json 需要添加如下代码
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    FL_AF_GOODWORK
    //设置网络请求超时时间
    mgr.requestSerializer.timeoutInterval = 5.0f ;
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer] ;
   
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    FL_Log(@"postMethod:%@", url);
    NSMutableDictionary* xjMu = params.mutableCopy;
    if (!xjMu) {
        xjMu = @{}.mutableCopy;
    }
    NSString* xxxx = XJ_USERID_WITHTYPE;
    [xjMu setObject:(XJ_USER_SESSION)?(XJ_USER_SESSION):@"" forKey:@"token"];
    [xjMu setObject:(xxxx)?(xxxx):@"" forKey:@"token_userId"];
    [xjMu setObject:(XJ_USERTYPE_WITHTYPE)?(XJ_USERTYPE_WITHTYPE):@"" forKey:@"token_type"];
//    params = xjMu.mutableCopy;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 5.0f ;
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    FL_AF_GOODWORK
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+ (void)putWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    FL_Log(@"putMethod:%@", url);
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    FL_AF_GOODWORK
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    FL_Log(@"multiple-part PostMethod:%@", url);
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 20.0f ;
    FL_AF_GOODWORK
    NSMutableDictionary* xjMu = params.mutableCopy;
    if (!xjMu) {
        xjMu = @{}.mutableCopy;
    }
    NSString* xxxx = XJ_USERID_WITHTYPE;
    [xjMu setObject:(XJ_USER_SESSION)?(XJ_USER_SESSION):@"" forKey:@"token"];
    [xjMu setObject:(xxxx)?(xxxx):@"" forKey:@"token_userId"];
    [xjMu setObject:(XJ_USERTYPE_WITHTYPE)?(XJ_USERTYPE_WITHTYPE):@"" forKey:@"token_type"];
    params = xjMu.mutableCopy;
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        if (block) {
            block(formData);
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end










