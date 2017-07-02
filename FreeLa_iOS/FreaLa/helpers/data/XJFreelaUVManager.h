//
//  XJFreelaUVManager.h
//  FreeLa
//
//  Created by Leon on 16/8/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJFreelaUVManager : NSObject
/**添加以 type_id 为索引 的 uv
 */
+ (void) xjAddUVStr:(NSString*)xjUVStr SearchId:(NSString*)xjSearchId;
/**删除以 type_id 为索引 的 uv
 */
+ (void)xjRemoveUVInLocatiBySearchId:(NSString*)xjSearchId;
/**查询以 type_id 为索引 的 uv
 */
+ (NSString*)xjSearchUVInLocationBySearchId:(NSString*)xjSearchId;

/**更改以 type_id 为索引 的 uv
 */
+ (void)xjChangeUVInLocationBySearchId:(NSString*)xjSearchId;

/**删除所有 的model
 */
+ (void)xjRemoveAllUserModelInLocation;
@end
