//
//  CYUserProfileTool.m
//  FreeLa
//
//  Created by cy on 16/1/21.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYUserProfileTool.h"

@implementation CYUserProfileTool

+ (instancetype)share{
    static CYUserProfileTool *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

// 初始化字典
- (instancetype)init{
    if (self = [super init]) {
        self.userId_Model = [NSMutableDictionary dictionary];
    }
    return self;
}

- (CYUserModel *)modelWithUserId:(NSString *)userId{
    return self.userId_Model[userId];
}

- (void)addModel:(CYUserModel *)model withUserID:(NSString *)userId{
    [self.userId_Model setObject:model forKey:userId];
}
// 群组界面的头像和昵称怎么办？？？
// 获取成功发通知
//代理
//block
@end
