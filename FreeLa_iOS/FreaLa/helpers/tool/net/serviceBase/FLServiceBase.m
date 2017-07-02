//
//  FLServiceBase.m
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLServiceBase.h"
#import "FLErrorDefines.h"

@implementation FLServiceBase

+ (id)share{
    static FLServiceBase *base = nil;
    if (nil == base) {
        base = [[FLServiceBase alloc] init];
    }
    return base;
}

- (void)handleRequestSuccess:(id)reqData
                    sucBlock:(FLResultSuccessBlock)sucBlock
                   failBlock:(FLResultFailBlock)failBlock{
    
    // 如果返回的不是字典对象,则执行FailBlock,告诉返回数据错误
    if (![reqData isKindOfClass:[NSDictionary class]]) {
        if (failBlock) {
            FLError *error = [[FLError alloc] init];
            error.code = RESULT_API_DATA_TYPE_ERROR;
            error.message = [FLServiceBase errorInfoWith:RESULT_API_DATA_TYPE_ERROR];
            failBlock(nil,error);
        }
        return;
    }
    
    // 如果无返回状态信息,则返回;这时有可能返回数据是成功的,但要求服务器必须改
    NSDictionary *dataDic = (NSDictionary *)reqData;
    NSDictionary *statusDic = [dataDic objectForKey:@"status"];
    
    if (!statusDic || [statusDic isKindOfClass:[NSNull class]]) {
        FLError *error = [[FLError alloc] init];
        error.code = RESULT_API_STATUS_ERROR;
        error.message = [FLServiceBase errorInfoWith:RESULT_API_STATUS_ERROR];
        if (failBlock) {
            failBlock(nil,error);
        }
        return;
    }
    
    // 处理状态信息,如果不为2000,则返回错误
    NSUInteger statusCode = [[statusDic objectForKey:@"code"] intValue];
    if (RESULT_API_SUCCESS != statusCode) {
        FLError *error = [[FLError alloc] init];
        error.code = statusCode;
        error.message = [FLServiceBase errorInfoWith:statusCode];
        if (failBlock) {
            failBlock(nil,error);
        }
        
        return;
    }
    
    // 查看返回的数据是否为nill或Null.为空数组或空字典不处理,因为可能出现空数据的现象
    /*
     id data = [dataDic objectForKey:@"data"];
     if (nil == dataDic || [data isKindOfClass:[NSNull class]]) {
     
     DDError *error = [[DDError alloc] init];
     error.code = 1000;
     error.message = [DDServerBase errorInfoWith:1000];
     if (failBlock) {
     failBlock(nil,error);
     }
     return;
     }
     */
    /*
     其它条件,如果使用发现其它需要处理,再加相应用处理代码
     */
    
    // 经过上边几层过滤,如果没问题,此时就可以向使用者返回成功获取数据的信息了
    if (sucBlock) {
        sucBlock (dataDic,RESULT_SUCCESS);
    }
}

/**
 *  请求数据失败后的处理
 *
 *  @param error     请求失败后返回DDError对象
 */
- (void)handleRequestFailed:(FLError *)error
                  failBlock:(FLResultFailBlock)failBlock{
    error.extra = [FLServiceBase errorInfoWith:error.code];
    if (failBlock) {
        failBlock (nil,error);
    }
    
}

+ (NSString *)errorInfoWith:(NSUInteger)errorCode{
    NSString *str = nil;
    switch (errorCode) {
        case RESULT_EMPTY:
            str = @"无返回结果";
            break;
        case RESULT_PARA_ERROR:
            str = @"请求参数错误";
            break;
        case RESULT_VERIFY_USER_ERROR:
            str = @"客户端未授权";
            break;
        case RESULT_SERVER_DENIED:
            str = @"服务器拒接访问";
            break;
        case RESULT_SERVER_NOT_FOUND:
            str = @"未找到服务器资源";
            break;
        case RESULT_SERVER_NOT_ALLOW:
            str = @"不允许使用的方法";
            break;
        case RESULT_SERVER_TIMEOUT:
            str = @"请求超时";
            break;
        case RESULT_SERVER_REQUEST_CONFLICGT:
            str = @"请求冲突";
            break;
        case RESULT_SERVER_TOO_LARGE:
            str = @"请求实体太大";
            break;
        case RESULT_SERVER_URL_LONG:
            str = @"请求URL太长";
            break;
        case RESULT_SERVER_UNSUPPORT_TYPE:
            str = @"不支持的媒体类型";
            break;
        case RESULT_SERVER_ERROR:
            str = @"Server端内部错误，具体错误见response输出";
            break;
        case RESULT_SERVER_BAD_GATEWAY:
            str = @"网关故障";
            break;
        case RESULT_SERVER_GATEWAY_TIMEOUT:
            str = @"网关超时";
            break;
        case RESULT_SERVER_UNSUPPORT_PROTOCOL:
            str = @"服务器收到的请求使用了它不支持的HTTP协议版本";
            break;
        case RESULT_API_UNKNOW_ERROR:
            str = @"发生未知错误";
            break;
        case RESULT_API_PARAMS_EMPTY:
            str = @"必须参数为空";
            break;
        case RESULT_API_PARAMS_TOO_LARGE:
            str = @"参数超出允许的最大值";
            break;
        case RESULT_API_PARAMS_TOO_SMALL:
            str = @"参数小于允许的最小值";
            break;
        case RESULT_API_PARAMS_TYPE_ERROR:
            str = @"参数与允许的类型不匹配";
            break;
        case RESULT_API_DATA_TYPE_ERROR:
            str = @"接口数据格式错误,与允许数据格式不匹配";
            break;
        case RESULT_API_PARAMS_MUST_INT:
            str = @"参数非法，参数必须为正整数";
            break;
        case RESULT_API_PARAMS_IS_NULL:
            str = @"参数非法,参数不能为空字符串或nil";
            break;
        case RESULT_API_PARAMS_TOO_LONG:
            str = @"RESULT_API_PARAMS_TOO_LONG";
            break;
        case RESULT_API_PARAMS_TOO_SHORT:
            str = @"参数非法：参数长度超出允许的最小值";
            break;
        case RESULT_USER_ABSENT:
            str = @"用户不存在";
            break;
        case RESULT_USER_PASSWORD_ERROR:
            str = @"密码错误";
            break;
        case RESULT_USER_LOCKED:
            str = @"用户已锁定";
            break;
        case RESULT_USER_NON_GET_RESORCE:
            str = @"没有权限访问该资源";
            break;
        case RESULT_USER_CERT_EXPIRE:
            str = @"用户认证信息已过期";
            break;
        case RESULT_USER_NO_CHANGED_START_PASSWORD:
            str = @"未重新设置初始密码";
            break;
        case RESULT_USER_DISABLE:
            str = @"用户被禁用";
            break;
        case RESULT_API_STATUS_ERROR:
            str = @"未返回状态信息";
            break;
        case RESULT_API_DATA_IS_NULL:
            str = @"返回的数据为nil或者为Null";
            break;
            
        default:
            break;
    }
    
    return str;
}


@end











