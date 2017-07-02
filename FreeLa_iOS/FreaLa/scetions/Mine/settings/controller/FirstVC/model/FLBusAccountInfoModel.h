//
//  FLBusAccountInfoModel.h
//  FreeLa
//
//  Created by Leon on 15/11/17.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FLBusAccountInfoModel : NSObject<NSCoding>    //sds
/**邮箱*/
@property (nonatomic , strong)NSString* busEmail;
/**头像*/
@property (nonatomic , strong)NSString* busHeaderImageStr;
/**标识*/
@property (nonatomic , strong)NSString* busUserId;
/**全称*/
@property (nonatomic , strong)NSString* busfullName;
/**简称*/
@property (nonatomic , strong)NSString* busSimpleName;
/**简介*/
@property (nonatomic , strong)NSString* busSimpleIntroduce;
/**注册时间*/
@property (nonatomic , strong)NSString* busCreatTime;
/**拒绝原因*/
@property (nonatomic , strong)NSString* busRefuseReason;
/**执照号*/
@property (nonatomic , strong)NSString* busliceneNumber;
/**执照图片路径*/
@property (nonatomic , strong)NSString* busliceneImageStr;
/**联系人,创始人*/
@property (nonatomic , strong)NSString* buscreator;
/**联系人电话*/
@property (nonatomic , strong)NSString* busphoneNumber;
/**行业*/
@property (nonatomic , strong)NSString* busIndustry;
/**状态 1为禁用  0 为 正常*/
@property (nonatomic , assign)NSInteger busStateInt;

+ (FLBusAccountInfoModel*)share;

@end
