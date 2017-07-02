//
//  CYUserModel.m
//  FreeLa
//
//  Created by cy on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYUserModel.h"

@implementation CYUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.shortName forKey:@"shortName"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.shortName = [aDecoder decodeObjectForKey:@"shortName"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
    }
    return self;
}

@end


/*
 @property(nonatomic,strong)NSString *nickname ; // 昵称
 @property(nonatomic,strong)NSString *avatar; // 头像
 
 // 商家的
 @property(nonatomic,strong)NSString *shortName; //
 // 商家的
 @property(nonatomic,strong)NSString *username; //
 */