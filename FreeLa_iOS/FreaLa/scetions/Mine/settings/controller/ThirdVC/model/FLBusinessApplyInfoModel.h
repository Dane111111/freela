//
//  FLBusinessApplyInfoModel.h
//  FreeLa
//
//  Created by Leon on 15/11/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FLBusinessApplyInfoModel : NSObject<NSCoding>   //apply
/**全称*/
@property (nonatomic , strong)NSString* busFullName;
/**简称*/
@property (nonatomic , strong)NSString* bussimpleName;
/**执照号*/
@property (nonatomic , strong)NSString* busliceneNumber;
/**联系人*/
@property (nonatomic , strong)NSString* bussContectPerName;
/**联系电话*/
@property (nonatomic , strong)NSString* busPhoneNumber;
/**邮箱*/
@property (nonatomic , strong)NSString* busemailNumber;
/**验证码*/
@property (nonatomic , strong)NSString* busverifity;
/**执照*/
@property (nonatomic , strong)UIImage* busLiceneImage;
/**密码*/
@property (nonatomic , strong)NSString* busPassword;
/**执照路径*/
@property (nonatomic , strong)NSString* busLiceneImageStr;
/**userID*/
@property (nonatomic , strong)NSString* busUserID;
/**行业*/
@property (nonatomic , strong)NSString* busIndustryStr;

/**头像路径*/
@property (nonatomic , strong)NSString* busHeaderImageStr;

@end








