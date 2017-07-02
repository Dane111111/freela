//
//  XJUserAccountTool.m
//  FreeLa
//
//  Created by Leon on 16/7/28.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJUserAccountTool.h"
static XJUserAccountTool* instanceOnce = nil;
static XJUserAccountTool* instanceOnce;
@implementation XJUserAccountTool

+ (XJUserAccountTool*)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceOnce = [[self alloc] init];
    });
    return instanceOnce;
}

- (NSString*)xj_userdefault_thirdloginInfo {
    NSString* isThi = [[NSUserDefaults standardUserDefaults] objectForKey:XJ_VERSION_IS_THIRD];
    if ([XJFinalTool xjStringSafe:isThi]) {
        if ([isThi isEqualToString:@"4"]) { //4、QQ  5、微信  6、新浪
            isThi = @"QQ";
        } else if ([isThi isEqualToString:@"5"]) {
            isThi = @"微信";
        }  else if ([isThi isEqualToString:@"6"]) {
            isThi = @"新浪";
        }
    }  else {
        return @"";
    }
    return isThi?isThi:@"";
}
- (void)xj_save_isthirdLogin:(NSString*)xjFource {
    if (![XJFinalTool xjStringSafe:xjFource]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:XJ_VERSION_IS_THIRD];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:xjFource forKey:XJ_VERSION_IS_THIRD];
    }
}
- (void)xj_saveUserName:(NSString*)xjstr {
    [[NSUserDefaults standardUserDefaults] setObject:xjstr forKey:@"xjversion2UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString*)xj_getUserName {
    NSString* xx = [[NSUserDefaults standardUserDefaults] objectForKey:@"xjversion2UserName"];
    return [XJFinalTool xjStringSafe:xx]?xx:@"";
}
- (void)xj_saveUserState:(NSString*)xjstate {
    [[NSUserDefaults standardUserDefaults] setObject:xjstate forKey:@"xjversion2UserState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString*)xj_getUserState {
    NSString* xx = [[NSUserDefaults standardUserDefaults] objectForKey:@"xjversion2UserState"];
    return [XJFinalTool xjStringSafe:xx]?xx:@"0";
}
- (void)xj_saveUserAvatar:(NSString*)xjstr {
    [[NSUserDefaults standardUserDefaults] setObject:xjstr forKey:@"xjversion2UserAvatar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString*)xj_getUserAvatar {
    NSString* xx = [[NSUserDefaults standardUserDefaults] objectForKey:@"xjversion2UserAvatar"];
    return [XJFinalTool xjStringSafe:xx]?xx:@"";
}
@end















