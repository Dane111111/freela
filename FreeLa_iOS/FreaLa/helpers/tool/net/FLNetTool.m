//
//  FLNetTool.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/20.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLNetTool.h"
#import <AFNetworking/AFNetworking.h>


#define cuizhihuaurl   @"http://192.168.20.151:8888"
#define guangxiongurl  @"http://192.168.20.55:8080"

#define FL_AF_GOODWORK  mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];

@implementation FLNetTool
//+ (void)loginAndRegiserWithParam:(XLLoginAndRegisterParamModel *)param success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
//{
//    NSMutableString *requestUrl = [NSMutableString stringWithFormat:@"%@user/addUser?", XLBaseUrl];
//    NSLog(@"BaseUrl00000000000000000%@",XLBaseUrl);
//    if (param.parentId) {
//        [requestUrl appendFormat:@"parentId=%@", param.parentId];
//    }else{
//        [requestUrl appendFormat:@"parentId=%@", @""];
//    }
//    if (param.uId) {
//        [requestUrl appendFormat:@"&uid=%@", param.uId];
//    }else{
//        [requestUrl appendFormat:@"&uid=%@", @""];
//    }
//    if (param.uName) {
//        [requestUrl appendFormat:@"&uName=%@", STRING_BY_ADDING_PERCENT(param.uName)];
//    }else{
//        [requestUrl appendFormat:@"&uName=%@", @""];
//    }
//    if (param.deviceToken) {
//        [requestUrl appendFormat:@"&device_tokens=%@", param.deviceToken];
//    }
//
//    XLLog(@"requestUrl====%@",requestUrl);
//    [XLHttpRequestTool postWithURL:requestUrl params:nil success:^(id json) {
//        success(json);
//    } failure:^(NSError *error) {
//        failure(error);
//    }];
//}

+ (void)registerAccountWithnikeName:(NSString*)nikeName phone:(NSString*)phone passWord:(NSString*)passWord success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!registered.action?d=76954&accountType=person&nikeName=%@&phone=%@&password=%@",FLBaseUrl,nikeName,phone,passWord]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool getWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
#warning 理论上是要发post 把整个模型传故去
+ (void)isAlreadyRegistedWithPhone:(NSString*)phoneNumber success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError*))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!isRegPerson.action?d=%u&phone=%@",FLBaseUrl,randomNumber,phoneNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool getWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

+ (void)logInWithPhone:(NSString*)phone password:(NSString*)password success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!loginUser.action?d=76954&accountType=person&account=%@&password=%@",FLBaseUrl,phone,password] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool getWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)forgetPasswordWithPhone:(NSString*)phone newPassword:(NSString*)newPassword success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!updatePassword.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* parm = @{@"accountType":FLFLXJUserTypePersonStrKey,
                           @"phone":phone,
                           @"newpassword":newPassword};
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)registerAccountWithcheckCode:(NSString*)checkCode email:(NSString*)email passWord:(NSString*)passWord success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!registered.action?d=76954&accountType=comp&email=%@&checkCode=%@&password=%@",FLBaseUrl,email,checkCode,passWord] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [FLHTTPRequestTool postWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

+ (void)sendVerifityCodeWithEmail:(NSString*)email success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!sendValidateCode.action?d=76954&email=%@",FLBaseUrl,email] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)uploadHeadImage: (UIImage *)image success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    //    FLUserInfoModel* userInfoModel =
    //    if (userInfoModel) {
    //        <#statements#>
    //    }
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@/users!upLoadSrcPic.action?", FLBaseUrl];
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    [FLHTTPRequestTool postWithURL:requestStr params:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"my" fileName:@"selfPhoto.png" mimeType:@"image/jpeg"];
    } success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}


+ (void)changeMyPasswordWithPhone:(NSString*)phone OldPassword:(NSString*)oldPassword NewPassword:(NSString*)newPassword success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!rePassword.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* parm = [NSDictionary dictionaryWithObjectsAndKeys:@"token",@"1123",@"xingming",@"chuzhipeng", nil];
    //    NSDictionary* parm = [NSDictionary dictionaryWithObject:@"123" forKey:@"token"];
    //把拼接后的字符串转换为data，设置请求体
    //    request.HTTPBody = [parm dataUsingEncoding:NSUTF8StringEncoding ];
    //发送请求
    
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)changeMyPasswordWithEmail:(NSString*)email OldPassword:(NSString*)oldPassword NewPassword:(NSString*)newPassword success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!rePassword.action?d=76954&accountType=comp&email=%@&oldpassword=%@&newpassword=%@",FLBaseUrl,email,oldPassword,newPassword] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

+ (void)howManyAccountWithEmailBilnd:(NSString*)Email success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!selectRegBusinessCount.action?d=76954&accountType=comp&email=%@",FLBaseUrl,Email] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

+ (void)findAllCompInfoWithSession:(NSString*)session success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!findAllCompInfo.action?d=76954&token=%@",FLBaseUrl,session] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//重写的post请求
+ (void)changeMyPasswordWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!rePassword.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)seeInfoWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!seeInfo.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 5.0f ;
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

+ (void)updatePerWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure;
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!updatePer.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)uploadHeadImage: (UIImage *)image parm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    //     NSData* imageData = UIImageJPEGRepresentation(image, 1.0f);
    //    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    //    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!uploadSrcPic.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyyMMddHHmmss";
    //    NSString* str = [formatter stringFromDate:[NSDate date]];
    //    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
    //    [manager POST:requestStr parameters:@{@"imagefileFileName":fileName} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    //        //以文件流上传图片
    //        [formData appendPartWithFileData:imageData name:@"imagefile" fileName:fileName mimeType:@"image/jpeg"];
    //    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    //        NSLog(@"111");
    //        NSLog(@"%@",responseObject);
    //    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    //        NSLog(@"222error= %@ = %@",error.description,error.debugDescription);
    //    }];
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!uploadSrcPic.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString* str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
        [formData appendPartWithFileData:imageData name:@"imagefile" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(id json) {
        success(json);
        //        NSLog(@"responseObject=%@%",json);
    } failure:^(NSError *error) {
        failure(error);
        NSLog(@"222error= %@ = %@",error.description,error.debugDescription);
    }];
    
}
+ (void)xjUploadYYZZImage: (UIImage *)image parm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!uploadAuthPic.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString* str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
        [formData appendPartWithFileData:imageData name:@"imagefile" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(id json) {
        success(json);
        //        NSLog(@"responseObject=%@%",json);
    } failure:^(NSError *error) {
        failure(error);
        NSLog(@"222error= %@ = %@",error.description,error.debugDescription);
    }];
}
+ (void)xjUploadTWDetailImage: (UIImage *)image success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!uploadPicture.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString* str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
        [formData appendPartWithFileData:imageData name:@"imagefile" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(id json) {
        success(json);
        //        NSLog(@"responseObject=%@%",json);
    } failure:^(NSError *error) {
        failure(error);
        NSLog(@"222error= %@ = %@",error.description,error.debugDescription);
    }];
}
+ (void)xjUploadPJCommentsImage: (UIImage *)image parm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/comments!uploadSrcPic.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString* str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
        [formData appendPartWithFileData:imageData name:@"imagefile" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(id json) {
        success(json);
        //        NSLog(@"responseObject=%@%",json);
    } failure:^(NSError *error) {
        failure(error);
        NSLog(@"222error= %@ = %@",error.description,error.debugDescription);
    }];
}

+ (void)howManyAccountWithEmailBilndparm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!selectRegBusinessCount.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)registerBusinessAccountWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!insertcompUser.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)checkEmailVerifityParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!validateCode.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)sendVerifityCodeByPayParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!sendVlidateCodePer.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

+ (void)exchangeAccountWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!changAccount.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)registerAccountWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!registered.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)checkNumbersOfblindWithMyselfWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!getBindCompCountByToken.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)updateCompInfoWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!updateComp.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)revokeMyBusApplyWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!deleteAudit.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)flUpDateBusinessInfoWithParm:(NSDictionary*)parm  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!addCompAuth.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark -------第二里程碑部分
+ (void)chooseIndustryWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/userinfo/users!industry.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getTakeConditionsWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getAllPara.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
        NSString* str = json;
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)checkNickNameWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/users!getCountByShortName.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getDetailsForHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!view.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)getJudgeListForHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/comments!listComment.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)issueANewActivityWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!saveTopic.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
    //    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //    mgr.requestSerializer.timeoutInterval = 5.0f ;
    //    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    FL_AF_GOODWORK
    //    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    ////    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //
    //    [mgr POST:requestStr parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        if (success) {
    ////            NSLog(@"res = == = = == = =%@",responseObject);
    //            success(responseObject);
    //        }
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        if (failure) {
    //            failure(error);
    //        }
    //    }];
    
}
+ (void)getSquareInfoWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!topicList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
#pragma  mark---------- ------ 发布中上传详情图和缩略图的接口
+ (void)setIssueDetailImage: (UIImage *)image parm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    CGFloat scale = 0.8f;
    NSData* imageData;
    //    do {
    imageData = UIImageJPEGRepresentation(image, scale);
    //        scale -= 0.1;
    //    } while (imageData.length > 1000000 && scale >=0.6);
    
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!uploadPic.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString* str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@%u.png",str,randomNumber];
        FL_Log(@"this is my update image name =%@",fileName);
        [formData appendPartWithFileData:imageData name:@"imagefile" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(id json) {
        success(json);
        //        NSLog(@"responseObject=%@%",json);
    } failure:^(NSError *error) {
        failure(error);
        NSLog(@"222error= %@ = %@",error.description,error.debugDescription);
    }];
}

+ (void)getDetailImageStrInHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getTopicPic.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)getRankCountMapInHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/comments!getRankCountMap.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)checkReceiveInfoInHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!checkReceiveInfo.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)htmlListCommentInHTMLWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/comments!listComment.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
#pragma mark ---我的
+ (void)searchTopicListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!userTopicList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)getTopicForIssueAgainByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!GetTopic.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)searchTopicReceiveListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!topicReceiveList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
#pragma mark-----HTML
+ (void)HTMLfindTopicPromoteListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!findTopicPromoteList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)HTMLfindParticipateListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!findParticipateList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)HTMLsaveATopicInMineByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!insertDetailes.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)HTMLSeeTopicDetailsByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!view.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)HTMLinsertCommentByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/comments!insertComment.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)HTMLRejudgeListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/comments!listReply.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)HTMLGetPartInfoListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getUserReceiveInfo.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)HTMLinsertParticipateInMineByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!insertParticipate.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)HTMLInsertTopicPromoteInMineByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!insertTopicPromote.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)searchMyReceiveListByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!receiveList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)fluseDetailesByIDWithParm:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!useDetailes.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)flgetTopicReceiveListByTopId:(NSString*)flTopicId success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/receives!exportReceiveUserlist.action?d=%d&topic.topicId=%@",FLBaseUrl,randomNumber,flTopicId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//%@/users!isRegPerson.action?d=76954&phone=%@",FLBase
    [FLHTTPRequestTool getWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flLogInWithThirdByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!jointLogin.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flGetHelpListDetailsByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/receives!getHowNumByLow.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flideaBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/infos!insertInfo.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flquitecollectionTopicBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/collections!deleteFavonites.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flAddcollectionTopicBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/collections!add.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flIscollectionTopicBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/collections!isCollection.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)flLeftTopicBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!upState.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flPubTopicListBackByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure
{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!tagList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flPubTopicListAddTagByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!addTag.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flPubTopicListRemoveTagByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!delTag.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flPubTopicShareFriendAnyTypeByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!transform.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)flHTMLGetPublisherMessageByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getPublisherMessage.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjfindParticipateNotReceiveByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!findParticipateNotReceive.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjuserTopicListByCommentByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!userTopicListByComment.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjdeleteFavonitesByCommentByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/collections!favonites.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjAddFriendsByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/chats!AddFriends.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjCheckIsFriendsByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!checkFriend.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetunionidWithToken:(NSString*)xjToken openId:(NSString*)xjOpenId success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",xjToken,xjOpenId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool getWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjgetParticipateDetailesByIdWithParma:(NSDictionary*)parm success:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getParticipateDetailesById.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjfindAttentListByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/attents!findAttentList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjrecommendListByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!recommendList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjfindListByIdsByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/chats!findListByIds.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetTicketNumber:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getTicketNum.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetPushMessagesByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/msg-pushs!msgCount.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetDetailPushMessagesByParm:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/msg-pushs!msgPushList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjChangePushMessageState:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/msg-pushs!updateState.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjgetPersonByPhone:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/chats!getPersonByPhone().action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjgetPersonInfoByNickName:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!getUserIdList.action?",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    
}
+ (void)xjgetPersonInfoForJPushByCommentId:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/comments!findCommentById.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)xjgetRcommendTopicListByCommentId:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!getAdvertTopic.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjgetRcommendTopicImageByCommentId:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!getAdvertList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjgetNaviRecommendImageById:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!getAdvertZdwz.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjSearchHTMLDetailsByCommentId:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!findParticipateList.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjRequestHtmlOUTBytempId:(NSDictionary*)parm success:(void(^)(NSDictionary* data))success failure:(void(^)(NSError* error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getTempUrl.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xj_findMyRankInHelpList: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!findRank.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xj_updatePvWithparma: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!increaseAdvertPv.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xj_updateLinkNumWithparma: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!increaseAdvertLinkNum.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xj_getPlanByTopicId: (NSString *)xjTopicId success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!getPlanByTopicId.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* parm = @{@"topic.topicId":xjTopicId?xjTopicId:@""};
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xj_GetVersionSuccess:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getVersion.action?d=%d&versionType=iOS",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xj_uploadVersionNumber: (NSString *)appVersion success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* usertype = XJ_USERTYPE_WITHTYPE;
    NSString* userid =  XJ_USERID_WITHTYPE;
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!updateAppVersion.action?accountType=%@&userid=%@&appVersion=%@",FLBaseUrl,usertype,userid,appVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xj_checkPhoneBlindType: (NSInteger)source phone:(NSString*)phone  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
   
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!isRegAndBind.action?phone=%@&source=%ld",FLBaseUrl,phone,source] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xj_getGifListSuccess:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@%@",FLBaseUrl,XJRequestGifList] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xj_publishGiftTopic: (NSDictionary*)parm  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@%@",FLBaseUrl,XJRequestPublishGiftTopic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)xj_getMainUsrToken: (NSString *)userid success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!getParentToken.action?userid=%@",FLBaseUrl,userid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)xj_testsss: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/WeiXinFreeLa/topic!xj_getTopicListByName.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetGiftMapResultsFromServer: (NSDictionary *)parm searchType:(NSString*)sType success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!lbsSearch%@.action",FLBaseUrl,sType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjTestAllfreenew: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!topicListRanking.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjTestAllfreenewxjxj: (NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!topicList.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetSkyGiftpResultsFromServer: (NSDictionary *)parm  success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!arTopicList.action?userid=%@",FLBaseUrl,parm[@"userid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool getWithURL:requestStr params:nil success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetRecyclePics:(NSDictionary *)parm success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/users!getAdvertTopic.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetzlqTopicList:(NSDictionary *)parm success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!zlqTopicList.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetAllFreeList:(NSInteger)pageNum success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    NSDictionary *parm = @{@"page.currentPage":@(pageNum),@"topic.topicType":@"FREE"};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!topicList.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetCouponList:(NSInteger)pageNum success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    NSDictionary *parm = @{@"page.currentPage":@(pageNum),@"topic.topicType":@"COUPON"};
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!topicList.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)xjGetNewOneList:(NSDictionary *)parm success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getNewOneZx.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+ (void)deGetZxTopicList:(NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!zxTopicList.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];

}
+ (void)xjxjGetDetailsIdWith:(NSDictionary *)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure {
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getDetailsIdByUserIdAndTopicId.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
+(void)deGetNewIsMainWith:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getNewIsMain.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];

}
+(void)deGetIsChildListWith:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getIsChildList.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];

}
+(void)deTopicReceiveListWith:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!topicReceiveList.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];

}
+(void)deGetAdminMarkListWith:(NSDictionary*)parm success:(void(^)(NSDictionary *data))success failure: (void(^)(NSError *error))failure{
    NSString* requestStr = [[NSString stringWithFormat:@"%@/app/publishs!getAdminMark.action",FLBaseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [FLHTTPRequestTool postWithURL:requestStr params:parm success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];

}
@end











