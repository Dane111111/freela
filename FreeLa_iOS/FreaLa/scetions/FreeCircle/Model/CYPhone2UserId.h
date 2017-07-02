//
//  CYPhone2UserId.h
//  FreeLa
//
//  Created by cy on 16/1/21.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYPhone2UserId : NSObject

@property (nonatomic,copy) NSNumber *userId; // 通过手机号获取userID
@property (nonatomic , strong) NSString* avatar; //头像
@property (nonatomic , strong) NSString* phone;
/*
 address = "";
 avatar = "/resources/static/user/mobile1463117200644.jpg";
 birthday = "";
 createTime = "2016-05-13 13:20:26";
 description = "\U4f60\U597d\Uff0c\U54c8\U54c8";
 detailsId = 0;
 email = "";
 enable = 0;
 isFriend = 0;
 isThirdAvatar = 0;
 isThirdName = 0;
 isThirdSex = 0;
 lastLoginTime = "2016-05-13 13:56:05";
 loginTimes = 1;
 modifyTime = "2016-05-17 17:53:36";
 nickname = "XJ!!!";
 password = e10adc3949ba59abbe56e057f20f883e;
 phone = 13811225351;
 source = 1;
 state = 0;
 tags = "1231,1232,dlds,das ,Sada,Dasf";
 token = 3a71d5d809e94277b3be187d4e72b493;
 userId = 100006;
 */
@end
