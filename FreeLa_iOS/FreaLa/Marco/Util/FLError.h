//
//  FLError.h
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLError : NSObject
{
    
    NSInteger code; // 错误代码
    NSString *extra; // 扩展错误解释
    NSString *message; // 错误信息
    NSString *method; // 请求参数
    NSDictionary *userInfo;
    // NSDictionary *params; // 请求参数 (用于核实验证)
}

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, retain) NSString *extra;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSDictionary *userInfo;

+ (FLError *)error;
+ (FLError *)errorFromDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)getDictionaryFromError;

@end
