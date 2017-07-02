//
//  FLMyBusAccountDetailCheckModel.h
//  FreeLa
//
//  Created by Leon on 16/1/20.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMyBusAccountDetailCheckModel : NSObject

/*
 auditStatus = 1;
 authId = 11;
 businessLicenseNum = 13811222212314;
 businessLicensePic = "/resoucure/\U4ec0\U4e48\U9b3c";
 compName = "\U8fd9\U662f\U5168\U79f0";
 createTime = "2016-01-20 10:48:02";
 creator = 2;
 legalPerson = "\U8fd9\U662f\U8054\U7cfb\U4eba";
 shortName = "\U8fd9\U662f\U7b80\U79f0";
 userId = 17;
 userType = person;
 
 
 approver = admin;
 approverTime = "2016-01-21 08:54:16";
 auditStatus = 3;
 authId = 8;
 businessLicenseNum = 245285482548173;
 businessLicensePic = "/resources/static/compauth/comauth1453087058207.jpg";
 compName = "\U4f20\U9012";
 createTime = "2016-01-18 11:17:40";
 creator = 5;
 legalPerson = "\U6211\U751f\U6c14";
 reason = "\U6eda";
 shortName = frfefever;
 userId = 5;
 userType = comp;

 
 */

/**原因*/
@property (nonatomic , strong) NSString*  reason;
/**通过时间*/
@property (nonatomic , strong) NSString*  approverTime;
/**提交时间*/
@property (nonatomic , strong) NSString*  createTime;
/**userId*/
@property (nonatomic , assign) NSInteger userId;
/**状态啊*/
@property (nonatomic, assign) NSInteger auditStatus;

@end











