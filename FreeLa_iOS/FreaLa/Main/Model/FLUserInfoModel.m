//
//  FLUserInfoModel.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/14.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLUserInfoModel.h"


@implementation FLUserInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.flloginNumber forKey:@"flloginNumber"];
    [aCoder encodeObject:self.flpassWord forKey:@"flpassWord"];
    [aCoder encodeObject:self.fluserId forKey:@"fluserId"];
    [aCoder encodeObject:self.flnickName forKey:@"flnickName"];
//    [aCoder encodeObject:self.flheadPortrait forKey:@"flheadPortrait"];
    [aCoder encodeObject:self.flbirthday forKey:@"flbirthday"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.flloginNumber = [aDecoder decodeObjectForKey:@"flloginNumber"];
        self.flpassWord = [aDecoder decodeObjectForKey:@"flpassWord"];
        self.fluserId = [aDecoder decodeObjectForKey:@"fluserId"];
        self.flnickName = [aDecoder decodeObjectForKey:@"flnickName"];
//        self.flheadPortrait = [aDecoder decodeObjectForKey:@"flheadPortrait"];
        self.flbirthday = [aDecoder decodeObjectForKey:@"flbirthday"];
        
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"flStateInt" : @"state",
             @"flnickName":@"nickname",
             @"flbirthday":@"birthday",
             @"flavatar":@"avatar",
             @"flpassWord":@"password",
             @"fldescription":@"description",
             @"flloginNumber":@"phone",
             @"fluserId":@"userId",
             @"fladdress":@"address",
             @"flTagsStr":@"tags",
             @"flsex":@"sex",
             @"flsource":@"source"
             };
}

+ (FLUserInfoModel *)share
{
    static FLUserInfoModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}


//单例的相关
//
//+ (id)allocWithZone:(struct _NSZone *)zone
//{
//    if (!userInfoModel) {
//        userInfoModel = [super allocWithZone:zone]; //如果没有实例让父类去创建
//        return userInfoModel;
//    }
//    return nil;
//    
//}
//
//+ (FLUserInfoModel*)shareUserInfoModel
//{
//    if (!userInfoModel) {
//        userInfoModel = [[FLUserInfoModel alloc]init]; // 定义一个类方法进行访问
//    }
//    return userInfoModel;
//}

//- (id)copyWithZone:(st)



 
@end
/*
 address = "Bali ";
 avatar = "/resources/static/user/1460636049432.png";
 birthday = "2016-04-10";
 createTime = "2016-04-14 09:57:01";
 description = Sss;
 detailsId = 0;
 enable = 0;
 ip = "10.173.3.248";
 isFriend = 0;
 isThirdAvatar = 1;
 isThirdName = 0;
 isThirdSex = 1;
 lastLoginTime = "2016-04-18 10:42:27";
 loginTimes = 1;
 modifyTime = "2016-04-19 10:59:32";
 nickname = SMD;
 password = e10adc3949ba59abbe56e057f20f883e;
 phone = 13811225351;
 sex = 2;
 source = 4;
 state = 1;
 tags = "1,2,3,1234,3214,5435,1242,5555,6777,8888";
 token = 1bd6fc968cc24c3fa6c6ff97d7c031d3;
 unionid = DFBA48E359EB8A4DB4A4568358664C93;
 userId = 5;
 */









