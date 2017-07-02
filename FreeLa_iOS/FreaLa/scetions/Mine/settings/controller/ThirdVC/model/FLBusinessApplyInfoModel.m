//
//  FLBusinessApplyInfoModel.m
//  FreeLa
//
//  Created by Leon on 15/11/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLBusinessApplyInfoModel.h"

@implementation FLBusinessApplyInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.busFullName forKey:@"busFullName"];
    [aCoder encodeObject:self.bussimpleName forKey:@"bussimpleName"];
    [aCoder encodeObject:self.busliceneNumber forKey:@"busliceneNumber"];
    [aCoder encodeObject:self.busverifity forKey:@"busverifity"];
    [aCoder encodeObject:self.bussContectPerName forKey:@"bussContectPerName"];
    [aCoder encodeObject:self.busPhoneNumber forKey:@"busPhoneNumber"];
    [aCoder encodeObject:self.busemailNumber forKey:@"busemailNumber"];
    [aCoder encodeObject:self.busLiceneImage forKey:@"busLiceneImage"];
    [aCoder encodeObject:self.busLiceneImageStr forKey:@"busLiceneImageStr"];
    [aCoder encodeObject:self.busUserID forKey:@"busUserID"];
    [aCoder encodeObject:self.busverifity forKey:@"busverifity"];
     [aCoder encodeObject:self.busIndustryStr forKey:@"busIndustryStr"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.busFullName = [aDecoder decodeObjectForKey:@"busFullName"];
        self.bussimpleName = [aDecoder decodeObjectForKey:@"bussimpleName"];
        self.busliceneNumber = [aDecoder decodeObjectForKey:@"busliceneNumber"];
        self.busverifity = [aDecoder decodeObjectForKey:@"busverifity"];
        self.bussContectPerName = [aDecoder decodeObjectForKey:@"bussContectPerName"];
        self.busPhoneNumber = [aDecoder decodeObjectForKey:@"busPhoneNumber"];
        self.busemailNumber = [aDecoder decodeObjectForKey:@"busemailNumber"];
        self.busLiceneImage = [aDecoder decodeObjectForKey:@"busLiceneImage"];
        self.busLiceneImageStr = [aDecoder decodeObjectForKey:@"busLiceneImageStr"];
        self.busUserID = [aDecoder decodeObjectForKey:@"busUserID"];
        self.busverifity = [aDecoder decodeObjectForKey:@"busverifity"];
        self.busIndustryStr = [aDecoder decodeObjectForKey:@"busIndustryStr"];
    }
    return self;
}



@end
