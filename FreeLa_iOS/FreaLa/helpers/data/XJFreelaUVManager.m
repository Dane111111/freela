//
//  XJFreelaUVManager.m
//  FreeLa
//
//  Created by Leon on 16/8/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//


@interface XJFreelaUVModel : NSObject<NSCoding>
@property (nonatomic , strong) NSString* xjUvStr;
@end

@implementation XJFreelaUVModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.xjUvStr forKey:@"xjUvStr"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.xjUvStr = [aDecoder decodeObjectForKey:@"xjUvStr"];
    }
    return self;
}

@end
/************************************************************************************************/

#import "XJFreelaUVManager.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define xj_archive_key          @"XJFreelaUV.plist"

@implementation XJFreelaUVManager

/**添加以 type_id 为索引 的model
 */
+ (void) xjAddUVStr:(NSString*)xjUVStr SearchId:(NSString*)xjSearchId; {
    //先解档查看
    NSMutableDictionary* xjMu = [self xjMuOfAchive_2];
    FL_Log(@"==-0=-=-=-==%@",xjMu);
    if (xjMu==nil) {
        xjMu = [[NSMutableDictionary alloc] init];
    }
    XJFreelaUVModel* model = [[XJFreelaUVModel alloc] init];
    model.xjUvStr = xjUVStr;
    [self xjRemoveUVInLocatiBySearchId:xjSearchId];
    //    FL_Log(@"this is the adads======[%@]",[self xjMuOfAchive]);
    [xjMu setObject:xjUVStr?xjUVStr:@"" forKey:xjSearchId];
    //归档
    [self xj_AchiveWithDic:xjMu];
}
/**删除以 type_id 为索引 的model
 */
+ (void)xjRemoveUVInLocatiBySearchId:(NSString*)xjSearchId {
    NSMutableDictionary* xjMu = [self xjMuOfAchive_2];
    NSString* model = [xjMu objectForKey:xjSearchId];
    if (model) {
        [xjMu removeObjectForKey:xjSearchId];
    }
    //归档
    [self xj_AchiveWithDic:xjMu];
}
/**查询以 type_id 为索引 的model
 */
+ (NSString*)xjSearchUVInLocationBySearchId:(NSString*)xjSearchId {
    //先解档查看
    NSMutableDictionary* xjMu = [self xjMuOfAchive_2];
    if (xjMu==nil) {
        return  @"";
    }
    NSString* xjModel = [xjMu objectForKey:xjSearchId];
    return xjModel?xjModel:@"";
}

/**更改以 type_id 为索引 的model
 */
+ (void)xjChangeUVInLocationBySearchId:(NSString*)xjSearchId {
    
}

/**删除所有 的model
 */
+ (void)xjRemoveAllUserModelInLocation{
    NSMutableDictionary* xjMu = [self xjMuOfAchive_2];
    [xjMu removeAllObjects];
    [self xj_AchiveWithDic:xjMu];
}
//解档
+ (NSMutableDictionary*)xjMuOfAchive_2 {
    NSString *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePaths = [paths stringByAppendingPathComponent:xj_archive_key];
    // 解档
    NSDictionary *xjMu = [NSKeyedUnarchiver unarchiveObjectWithFile:filePaths];
    if (xjMu==nil) {
        return   [NSMutableDictionary dictionary];
    }
    return [NSMutableDictionary dictionaryWithDictionary:xjMu];
}
//归档
+ (void)xj_AchiveWithDic:(NSMutableDictionary*)xjDic {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 这个文件后缀可以是任意的，只要不与常用文件的后缀重复即可
    NSString *filePath = [path stringByAppendingPathComponent:xj_archive_key];
    [NSKeyedArchiver archiveRootObject:xjDic.mutableCopy toFile:filePath];
}
@end
