//
//  FLAllFreeCouponModel.m
//  a
//
//  Created by 佟 on 2017/5/16.
//  Copyright © 2017年 xj. All rights reserved.
//

#import "FLAllFreeCouponModel.h"

@implementation FLAllFreeCouponModel


+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [AllFreeItem class]};
}
@end
@implementation AllFreeItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"NewDate" : @"newDate"
             };
    
}
@end


