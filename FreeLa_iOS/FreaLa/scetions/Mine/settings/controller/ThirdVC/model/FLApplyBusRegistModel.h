//
//  FLApplyBusRegistModel.h
//  FreeLa
//
//  Created by Leon on 16/2/2.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLApplyBusRegistModel : NSObject
/*
 auditStatus = 1;
 avatar = "/resources/static/user/mobile1454385950617.jpg";
 businessLicenseNum = "";
 businessLicensePic = "";
 createTime = "2016-02-02 12:05:51";
 defaultLogin = 1;
 email = "123125124@qq.com";
 industry = "\U4e92\U8054\U7f51";
 lastLoginTime = "2016-02-02 12:05:51";
 password = e10adc3949ba59abbe56e057f20f883e;
 phone = 13811225351;
 shortName = "";
 userId = 1;
 username = "";
 */

/**头像路径*/
@property (nonatomic , strong) NSString* avatar;
/**email*/
@property (nonatomic , strong) NSString* email;

/**行业*/
@property (nonatomic , strong) NSString* industry;
/**password*/
@property (nonatomic , strong) NSString* password;
/**phone*/
@property (nonatomic , strong) NSString* phone;
/**userId*/
@property (nonatomic , strong) NSString* userId;




@end
