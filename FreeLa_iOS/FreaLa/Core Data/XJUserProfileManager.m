//
//  XJUserProfileManager.m
//  FreeLa
//
//  Created by Leon on 16/6/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJUserProfileManager.h"
#import <UIKit/UIKit.h>

#define xj_archive_key          @"CYUserModel.plist"
@interface XJUserProfileManager ()

@end



@implementation XJUserProfileManager


/**添加以 type_id 为索引 的model
 */
+ (void) xjAddUserModelInLocation:(CYUserModel*)xjModel bySearchId:(NSString*)xjSearchId userType:(CYUserModelUserType)xjUserType {
    //先解档查看
    NSMutableDictionary* xjMu = [self xjMuOfAchive];
    [self xjRemoveUserModelInLocatiBySearchId:xjSearchId];
//    FL_Log(@"this is the adads======[%@]",[self xjMuOfAchive]);
    xjModel.xjUserType = xjUserType ;
    if (!xjSearchId) {
        return;
    }
    [xjMu setObject:xjModel forKey:xjSearchId];
    //归档
    [self xjAchiveWithDic:xjMu];
}
/**删除以 type_id 为索引 的model
 */
+ (void)xjRemoveUserModelInLocatiBySearchId:(NSString*)xjSearchId {
    NSMutableDictionary* xjMu = [self xjMuOfAchive];
    CYUserModel* model = [xjMu objectForKey:xjSearchId];
    if (model) {
        [xjMu removeObjectForKey:xjSearchId];
    }
    //归档
    [self xjAchiveWithDic:xjMu];
}
/**查询以 type_id 为索引 的model
 */
+ (CYUserModel*)xjSearchUserModelInLocationBySearchId:(NSString*)xjSearchId {
    //先解档查看
    NSMutableDictionary* xjMu = [self xjMuOfAchive];
    if (!xjMu) {
        return  nil;
    }
    CYUserModel* xjModel = [xjMu objectForKey:xjSearchId];
    return xjModel;
}

/**更改以 type_id 为索引 的model
 */
+ (void)xjChangeUserModelInLocationBySearchId:(NSString*)xjSearchId {
    
}

/**删除所有 的model
 */
+ (void)xjRemoveAllUserModelInLocation {
    NSMutableDictionary* xjMu = [self xjMuOfAchive];
    [xjMu removeAllObjects];
    [self xjAchiveWithDic:xjMu];
}
//解档
+ (NSMutableDictionary*)xjMuOfAchive {
    NSString *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePaths = [paths stringByAppendingPathComponent:xj_archive_key];
    // 解档
    NSDictionary *xjMu = [NSKeyedUnarchiver unarchiveObjectWithFile:filePaths];
    if (!xjMu) {
       return  [NSMutableDictionary dictionary];
    }
    return xjMu.mutableCopy;
}
//归档
+ (void)xjAchiveWithDic:(NSMutableDictionary*)xjDic {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 这个文件后缀可以是任意的，只要不与常用文件的后缀重复即可
    NSString *filePath = [path stringByAppendingPathComponent:xj_archive_key];
    [NSKeyedArchiver archiveRootObject:xjDic.mutableCopy toFile:filePath];
}
@end





