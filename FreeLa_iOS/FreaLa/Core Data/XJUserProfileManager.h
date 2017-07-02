//
//  XJUserProfileManager.h
//  FreeLa
//
//  Created by Leon on 16/6/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYUserModel.h"

@interface XJUserProfileManager : NSObject
/**添加以 type_id 为索引 的model
 */
+ (void) xjAddUserModelInLocation:(CYUserModel*)xjModel bySearchId:(NSString*)xjSearchId userType:(CYUserModelUserType)xjUserType;
/**删除以 type_id 为索引 的model
 */
+ (void)xjRemoveUserModelInLocatiBySearchId:(NSString*)xjSearchId;
/**查询以 type_id 为索引 的model
 */
+ (CYUserModel*)xjSearchUserModelInLocationBySearchId:(NSString*)xjSearchId;

/**更改以 type_id 为索引 的model
 */
+ (void)xjChangeUserModelInLocationBySearchId:(NSString*)xjSearchId;

/**删除所有 的model
 */
+ (void)xjRemoveAllUserModelInLocation;

@end
