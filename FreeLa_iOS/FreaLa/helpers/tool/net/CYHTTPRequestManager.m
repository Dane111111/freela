//
//  CYHTTPSessionManager.m
//  BS
//
//  Created by cy on 15/11/19.
//  Copyright © 2015年 cy. All rights reserved.
//

#import "CYHTTPRequestManager.h"

@implementation CYHTTPRequestManager

+ (CYHTTPRequestManager *)manager{
    static CYHTTPRequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
