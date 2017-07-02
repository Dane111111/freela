//
//  CYUserProfileTool.h
//  FreeLa
//
//  Created by cy on 16/1/21.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYUserModel.h"

@interface CYUserProfileTool : NSObject
// 给我一个userid,就可以获得一个模型
// userid -- CYUserModel -- nickName
//                       -- avaterURL  sd内部是一一对应 UIImage的
//
@property(nonatomic,strong)NSMutableDictionary *userId_Model; // 存储userid和模型的对应关系

+ (instancetype)share;

- (CYUserModel*)modelWithUserId:(NSString*)userId;

- (void)addModel:(CYUserModel*)model withUserID:(NSString*)userId;
@end
