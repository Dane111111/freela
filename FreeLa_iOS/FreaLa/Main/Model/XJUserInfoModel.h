//
//  XJUserInfoModel.h
//  FreeLa
//
//  Created by Leon on 16/4/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJUserInfoModel : NSObject
/**手机号*/
@property(nonatomic, assign) NSInteger phone;
/**密码*/
@property(nonatomic, strong) NSString *password;
/**userid*/
@property(nonatomic, strong) NSString *userId;

/**昵称*/
@property(nonatomic, strong) NSString *nickname;
/**头像地址*/
//@property(nonatomic, copy) NSString *flheadPortrait;
/**生日*/
@property(nonatomic, strong) NSString *birthday;
//性别
@property(nonatomic , assign) NSInteger sex;
/**个人标签*/
@property(nonatomic , strong) NSString* tags;
/**一句话描述*/
@property(nonatomic , strong) NSString* fldescription;
/**头像地址*/
@property (nonatomic , strong) NSString* flavatar;
/**地址*/
@property (nonatomic , strong) NSString* fladdress;

/**账户来源*/
@property (nonatomic , assign) NSInteger flSource;

@end


/*
 avatar = "/resources/static/user/1460636049432.png";
 birthday = "2016-04-10";
 createTime = "2016-04-14 09:57:01";
 detailsId = 0;
 enable = 0;
 ip = "10.173.3.248";
 isFriend = 0;
 isThirdAvatar = 1;
 isThirdName = 0;
 isThirdSex = 1;
 lastLoginTime = "2016-04-18 10:42:27";
 loginTimes = 1;
 modifyTime = "2016-04-15 15:47:57";
 nickname = SMD;
 password = e10adc3949ba59abbe56e057f20f883e;
 phone = 13811225351;
 sex = 2;
 source = 4;
 state = 1;
 tags = "1,2,3,1234,3214,5435,1242,5555,6777,8888";
 token = 1bd6fc968cc24c3fa6c6ff97d7c031d3;
 unionid = DFBA48E359EB8A4DB4A4568358664C93;
 userId = 5
*/