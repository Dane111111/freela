//
//  CYHTTPSessionManager.h
//  BS
//
//  Created by cy on 15/11/19.
//  Copyright © 2015年 cy. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface CYHTTPRequestManager : AFHTTPRequestOperationManager

+ (__kindof CYHTTPRequestManager*)manager;

@end
