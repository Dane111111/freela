//
//  CYUserModel.h
//  FreeLa
//
//  Created by cy on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger , CYUserModelUserType) {
    CYUserModelUserTypePerson =0,
    CYUserModelUserTypeBus =1,
    CYUserModelUserTypeGroup=2,
};

@interface CYUserModel : NSObject<NSCoding>

@property(nonatomic,strong)NSString *nickname ; // 昵称
@property(nonatomic,strong)NSString *avatar; // 头像

// 商家的
@property(nonatomic,strong)NSString *shortName; //
// 商家的
@property(nonatomic,strong)NSString *username; //

@property(nonatomic,strong)NSString *userId; //

@property (nonatomic , assign) CYUserModelUserType xjUserType;

@end

/*
 alias = "comp_100008_1";
 auditStatus = 2;
 avatar = "/resources/static/user/mobile1465023901268.png";
 businessLicenseNum = 123456789012345;
 businessLicensePic = "/resources/static/user/mobile1465023894513.png";
 createTime = "2016-06-04 15:05:54";
 defaultLogin = 1;
 email = "zhangjun198404@163.com";
 industry = "\U8ba1\U7b97\U673a";
 isFriend = 0;
 lastLoginTime = "2016-06-12 14:22:38";
 legalPerson = "\U5f20\U4fca";
 modifyTime = "2016-06-12 14:22:38";
 password = e10adc3949ba59abbe56e057f20f883e;
 phone = 18612724124;
 phoneStr = "186****4124";
 shortName = "\U5f20\U4fca";
 state = 0;
 token = 19f76ad121e04cafba5e7f9f81f1ef83;
 userId = 100008;
 username = "\U5f20\U4fca";
 */