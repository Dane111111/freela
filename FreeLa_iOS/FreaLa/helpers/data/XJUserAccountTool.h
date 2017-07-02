//
//  XJUserAccountTool.h
//  FreeLa
//
//  Created by Leon on 16/7/28.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJUserAccountModel.h"

@interface XJUserAccountTool : NSObject

+ (XJUserAccountTool*)share;

- (XJUserAccountModel*)xjGetCurrent;

/**是第三方登陆的来源*/
- (NSString*)xj_userdefault_thirdloginInfo;

#pragma  mark ---------------------- 【存】
/**保存第三方登陆*/
- (void)xj_save_isthirdLogin:(NSString*)xjFource;
/**存用户名
 */
- (void)xj_saveUserName:(NSString*)xjstr;
/**存头像
 */
- (void)xj_saveUserAvatar:(NSString*)xjstr;

/**是否被禁 
 * 0是 正常 1是被禁
 */
- (void)xj_saveUserState:(NSString*)xjstate;
#pragma  mark ---------------------- 【取】
/**取头像
 */
- (NSString*)xj_getUserAvatar;
/**取用户名
 */
- (NSString*)xj_getUserName;
/**是否被禁
 */
- (NSString*)xj_getUserState;
@end
