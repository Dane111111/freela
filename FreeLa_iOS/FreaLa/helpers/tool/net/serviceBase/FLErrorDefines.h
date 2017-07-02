//
//  FLErrorDefines.h
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#ifndef FLErrorDefines_h
#define FLErrorDefines_h
//
//  DDErrorDefines.h
//  Created by jiaoxt on 18/7/14.


#pragma mark -                           常见HTTP错误编码表

/**
 *  @breif                               成功
 */
#define RESULT_SUCCESS                   200

/**
 *  @breif                               无结果
 */
#define RESULT_EMPTY                     204

/**
 *  @breif                               请求参数不对，如json格式不对，或必填得参数没有携带
 */
#define RESULT_PARA_ERROR                400

/**
 *  @breif                               未授权(需要客户端对自己认证)
 */
#define RESULT_VERIFY_USER_ERROR         401

/**
 *  @breif                               服务器拒接访问
 */
#define RESULT_SERVER_DENIED             403

/**
 *  @breif                               未找到服务器资源
 */
#define RESULT_SERVER_NOT_FOUND          404

/**
 *  @breif                               不允许使用的方法
 */
#define RESULT_SERVER_NOT_ALLOW          405

/**
 *  @breif                               请求超时
 */
#define RESULT_SERVER_TIMEOUT            408

/**
 *  @breif                               请求冲突(发出的请求在资源上造成了一些冲突)
 */
#define RESULT_SERVER_REQUEST_CONFLICGT  409

/**
 *  @breif                               请求实体太大
 */
#define RESULT_SERVER_TOO_LARGE          413

/**
 *  @breif                               请求URL太长
 */
#define RESULT_SERVER_URL_LONG           414

/**
 *  @breif                               不支持的媒体类型
 */
#define RESULT_SERVER_UNSUPPORT_TYPE     415

/**
 *  @breif                               Server端内部错误，具体错误见response输出
 */
#define RESULT_SERVER_ERROR              500

/**
 *  @breif                               网关故障
 */
#define RESULT_SERVER_BAD_GATEWAY        502

/**
 *  @breif                               网关超时
 */
#define RESULT_SERVER_GATEWAY_TIMEOUT    504

/**
 *  @breif                               服务器收到的请求使用了它不支持的HTTP协议版本
 */
#define RESULT_SERVER_UNSUPPORT_PROTOCOL 505


#pragma mark -                       接口调用参数错误编码

/**
 *                                   服务器正常响应
 */
#define RESULT_API_SUCCESS           2000

/**
 *                                   发生未知错误
 */
#define RESULT_API_UNKNOW_ERROR      5000

/**
 *                                   必须参数为空
 */
#define RESULT_API_PARAMS_EMPTY      5001


/**
 *                                   参数超出允许的最大值
 */
#define RESULT_API_PARAMS_TOO_LARGE  5002

/**
 *                                   参数小于允许的最小值
 */
#define RESULT_API_PARAMS_TOO_SMALL  5003

/**
 *                                   参数与允许的类型不匹配
 */
#define RESULT_API_PARAMS_TYPE_ERROR 5004

/**
 *                                   接口数据格式错误,与允许数据格式不匹配
 */
#define RESULT_API_DATA_TYPE_ERROR   5005

/**
 *                                   参数非法，参数必须为正整数
 */
#define RESULT_API_PARAMS_MUST_INT   5006

/**
 *                                   参数非法,参数不能为空字符串
 */
#define RESULT_API_PARAMS_IS_NULL    5007

/**
 *                                   参数非法,参数长度超出允许的最大值
 */
#define RESULT_API_PARAMS_TOO_LONG   5008
/**
 *                                   参数非法：参数长度超出允许的最小值
 */
#define RESULT_API_PARAMS_TOO_SHORT  5009
/**
 *                                   参数非法：根据当前条件无法找到对应记录
 */
#define RESULT_API_PARAMS_NOT_FIND   6000
/**
 参数非法：数据已经存在，不允许再次操作
 */
#define RESULT_API_PARAMS_FIND       6001
/**
 *  状态信息出错,如未返回状态信息等
 */
#define RESULT_API_STATUS_ERROR      15009

/**
 *  返回的字典为nil或者为Null ,[Dic objectForkey:@"data"]为nil或Null对象
 */
#define RESULT_API_DATA_IS_NULL      15010


#pragma mark -                                用户相关错误码

/**
 *                                            用户不存在
 */
#define RESULT_USER_ABSENT                    4000

/**
 *                                            用户密码错误
 */
#define RESULT_USER_PASSWORD_ERROR            4001

/**
 *                                            用户已锁定（超出最大登录次数）
 */
#define RESULT_USER_LOCKED                    4002

/**
 *                                            用户没有权限访问该资源
 */
#define RESULT_USER_NON_GET_RESORCE           4003

/**
 *                                            用户认证信息已过期
 */
#define RESULT_USER_CERT_EXPIRE               4004

/**
 *                                            用户未重新设置初始密码
 */
#define RESULT_USER_NO_CHANGED_START_PASSWORD 4005

/**
 *                                            用户被禁用（违规操作，管理员手动禁用）
 */
#define RESULT_USER_DISABLE                   4006



#endif /* FLErrorDefines_h */
