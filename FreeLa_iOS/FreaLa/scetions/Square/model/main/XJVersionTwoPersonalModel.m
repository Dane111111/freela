//
//  XJVersionTwoPersonalModel.m
//  FreeLa
//
//  Created by Leon on 16/5/30.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJVersionTwoPersonalModel.h"

@implementation XJVersionTwoPersonalModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"xjServiceTime" : @"newDate"};
}

@end
