//
//  FLAppDelegate+XJEaseMob.m
//  FreeLa
//
//  Created by Leon on 16/7/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLAppDelegate+XJEaseMob.h"

@implementation FLAppDelegate (XJEaseMob)
- (void)xj_easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //进度后台离线 环信
    EMError* error;
    [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:NO error:&error];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //进入前台 登陆环信
    [FLTool xjLogInHuanXin];
}
 

@end
