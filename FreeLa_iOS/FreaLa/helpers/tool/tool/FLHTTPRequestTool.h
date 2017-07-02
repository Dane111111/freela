//
//  FLHTTPRequestTool.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/21.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLHeader.h"
//#import <AFNetworking/AFNetworking.h>
#import "AFURLRequestSerialization.h"
@interface FLHTTPRequestTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个PUT请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)putWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  Multiple-part post请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param block   拼接要上传的数据
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end







