//
//  FLBusAccountInfoModel.m
//  FreeLa
//
//  Created by Leon on 15/11/17.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLBusAccountInfoModel.h"

@implementation FLBusAccountInfoModel




/*
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.busEmail forKey:@"busEmail"];
    [aCoder encodeObject:self.busHeaderImageStr forKey:@"busHeaderImageStr"];
    [aCoder encodeObject:self.busUserId forKey:@"busUserId"];
    [aCoder encodeObject:self.busfullName forKey:@"busfullName"];
    [aCoder encodeObject:self.busSimpleName forKey:@"busSimpleName"];
    [aCoder encodeObject:self.busSimpleIntroduce forKey:@"busSimpleIntroduce"];
     [aCoder encodeObject:self.busCreatTime forKey:@"busCreatTime"];
     [aCoder encodeObject:self.busRefuseReason forKey:@"busRefuseReason"];
     [aCoder encodeObject:self.busliceneNumber forKey:@"busliceneNumber"];
     [aCoder encodeObject:self.busliceneImageStr forKey:@"busliceneImageStr"];
    [aCoder encodeObject:self.buscreator forKey:@"buscreator"];
    [aCoder encodeObject:self.busphoneNumber forKey:@"busphoneNumber"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.busEmail = [aDecoder decodeObjectForKey:@"busEmail"];
        self.busHeaderImageStr = [aDecoder decodeObjectForKey:@"busHeaderImageStr"];
        self.busUserId = [aDecoder decodeObjectForKey:@"busUserId"];
        self.busfullName = [aDecoder decodeObjectForKey:@"busfullName"];
        self.busSimpleName = [aDecoder decodeObjectForKey:@"busSimpleName"];
        self.busSimpleIntroduce = [aDecoder decodeObjectForKey:@"busSimpleIntroduce"];
         self.busCreatTime = [aDecoder decodeObjectForKey:@"busCreatTime"];
         self.busRefuseReason = [aDecoder decodeObjectForKey:@"busRefuseReason"];
         self.busliceneNumber = [aDecoder decodeObjectForKey:@"busliceneNumber"];
         self.busliceneImageStr = [aDecoder decodeObjectForKey:@"busliceneImageStr"];
            self.buscreator = [aDecoder decodeObjectForKey:@"buscreator"];
            self.busphoneNumber = [aDecoder decodeObjectForKey:@"busphoneNumber"];
        
    }
    return self;
}


*/

+ (FLBusAccountInfoModel*)share {
    static FLBusAccountInfoModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return  @{@"busEmail":@"email",
              @"busHeaderImageStr":@"avatar",
              @"busUserId":@"userId",
              @"busfullName":@"username",
              @"busSimpleName":@"shortName",
              @"busSimpleIntroduce":@"",
              @"busCreatTime":@"createTime",
              @"busliceneNumber":@"businessLicenseNum",
              @"busliceneImageStr":@"businessLicensePic",
              @"buscreator":@"",
              @"busphoneNumber":@"phone",
              @"busIndustry":@"industry",
              @"busStateInt":@"state"};
}

/*
 
 auditStatus = 2;
 avatar = "/resources/static/user/mobile1460617987830.png";
 businessLicenseNum = 554864343466464;
 businessLicensePic = "/resources/static/user/mobile1460617982865.png";
 createTime = "2016-04-14 15:13:09";
 defaultLogin = 1;
 email = "ghhj@163.com";
 industry = "\U4e92\U8054\U7f51";
 isFriend = 0;
 lastLoginTime = "2016-04-15 09:26:08";
 legalPerson = "\U54c8\U54c8\U54c8";
 modifyTime = "2016-04-15 14:51:28";
 password = e10adc3949ba59abbe56e057f20f883e;
 phone = 13811225351;
 shortName = "\U54c8\U54c8\U54c8";
 state = 0;
 token = 634c398108914175a3a3df49dd918b15;
 userId = 100001;
 username = "\U66f4\U540e\U6094";
 */




@end
