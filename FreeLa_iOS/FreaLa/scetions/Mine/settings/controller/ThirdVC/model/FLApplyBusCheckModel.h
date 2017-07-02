//
//  FLApplyBusCheckModel.h
//  FreeLa
//
//  Created by Leon on 16/2/2.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLApplyBusCheckModel : NSObject
/*
 approver = admin;
 approverTime = "2016-02-02 12:07:57";
 auditStatus = 3;
 authId = 1;
 businessLicenseNum = 123124213214213;
 businessLicensePic = "/resources/static/user/mobile1454385946681.jpg";
 compName = "test iOS";
 createTime = "2016-02-02 12:05:51";
 creator = 2;
 legalPerson = czp;
 reason = "\U4ec0\U4e48\U9b3c";
 shortName = test;
 userId = 1;
 userType = person;

 */

/**执照号*/
@property (nonatomic , strong) NSString* businessLicenseNum;
/**执照路径*/
@property (nonatomic , strong) NSString* businessLicensePic;
/**全称*/
@property (nonatomic , strong) NSString* compName;
/**简称*/
@property (nonatomic , strong) NSString* shortName;
/**联系人*/
@property (nonatomic , strong) NSString* legalPerson;
/**商家Id*/
@property (nonatomic , strong) NSString* authId; 
/**商家Id*/
@property (nonatomic , strong) NSString* userId;




@end






