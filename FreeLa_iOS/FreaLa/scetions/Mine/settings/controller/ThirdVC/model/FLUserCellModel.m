//
//  FLUserCellModel.m
//  FreeLa
//
//  Created by Leon on 15/11/2.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLUserCellModel.h"

@implementation FLUserCellModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        //使用KVC
        [self setValuesForKeysWithDictionary:dict];
    }
    return self ;
}

+ (instancetype)userModelWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}



@end
