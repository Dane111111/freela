//
//  FLUserServer.h
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLServiceBase.h"
#import <Foundation/Foundation.h>
#import "FLErrorDefines.h"

@interface FLUserServer : FLServiceBase

/**
 *  用户登录
 *
 *  @param loginName 用户名
 *  @param password  密码
 */
- (void)loginWithLoginName:(NSString *)loginName
              withPassword:(NSString *)password
                   success:(FLResultSuccessBlock)sucBlock
                      fail:(FLResultFailBlock)failBlock;
@end



















