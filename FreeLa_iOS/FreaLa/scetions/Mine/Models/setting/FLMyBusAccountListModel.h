//
//  FLMyBusAccountListModel.h
//  FreeLa
//
//  Created by Leon on 16/1/20.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMyBusAccountListModel : NSObject
/*
 auditStatus = 2;
 authorizationRole = 1;
 avatar = "/resources/static/user/mobile1459418085106.png";
 email = "121314202@qq.com";
 lastLoginTime = "2016-03-31 15:57:17";
 password = e10adc3949ba59abbe56e057f20f883e;
 shortName = "\U7b80\U79f01";
 userId = 4;
 username = "\U540d\U79f01";
 */

/**email*/
@property (nonatomic , strong) NSString*  email;
/**state*/
@property (nonatomic , assign) NSInteger  auditStatus;
/**username*/
@property (nonatomic , strong) NSString*  username;
/**avatar*/
@property (nonatomic , strong) NSString*  avatar;
/**password*/
@property (nonatomic , strong) NSString*  password;
/**userId*/
@property (nonatomic , strong) NSString*  userId;
/**shortName*/
@property (nonatomic , strong) NSString*  shortName;
/**1 运营者  2管理员*/
@property (nonatomic , assign) NSInteger  authorizationRole;


@end






