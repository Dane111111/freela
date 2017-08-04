//
//  NSDate+time.h
//  Love500m
//
//  Created by 孟祥博 on 16/8/9.
//  Copyright © 2016年 LTZS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (time)
+(__kindof NSDate*__nullable)dateNoTimeWithStr:(NSString*__nullable)time;

+(__kindof NSDate* __nullable)dateWithStr:(NSString*__nullable)time;
-(NSString*__nullable)getTime;
-(NSString*__nullable)get2Time;
+(__kindof NSDate* __nullable)dateWithEndStr:(NSString*__nullable)time;
-(NSString*__nullable)endTime;
-(NSString*__nullable)getAge;
-(NSString*__nullable)nosTime;

+ (__kindof NSString*__nullable)getCurrenTime;

+ (__kindof NSString*__nullable)getTimeInterval:(NSString*__nullable)currentime;
@end
