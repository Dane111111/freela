//
//  NSDate+time.m
//  Love500m
//
//  Created by 孟祥博 on 16/8/9.
//  Copyright © 2016年 LTZS. All rights reserved.
//

#import "NSDate+time.h"

@implementation NSDate (time)



+(__kindof NSDate*__nullable)dateWithStr:(NSString*__nullable)time{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en"];
    NSDate*date = [formatter dateFromString:time];
    return date;
}
+(__kindof NSDate*__nullable)dateNoTimeWithStr:(NSString*__nullable)time{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en"];
    NSDate*date = [formatter dateFromString:time];
    return date;
}

-(NSString*__nullable)getAge{
    int since = [[[NSDate alloc]init]timeIntervalSinceDate:self ];
    int age=since/(60*60*24*365);
    if (age<0) {
        age=0;
    }
    return [NSString stringWithFormat:@"%d",age];

}
/**
 刚刚(一分钟内)
 X分钟前(一小时内)
 X小时前(当天)
 昨天 HH:mm(昨天)
 MM-dd HH:mm(一年内)
 yyyy-MM-dd HH:mm(更早期)
 */
-(NSString*__nullable)getTime{
    NSCalendar * calenar = [NSCalendar currentCalendar];
    if ([calenar isDateInToday:self]) {
//        NSDate * date = [[NSDate alloc]init];
        int since = [[[NSDate alloc]init]timeIntervalSinceDate:self ];
        if (since<60) {
            return @"刚刚";
        }
        if (since<60*60) {
            return [NSString stringWithFormat:@"%d分钟以前",since/60];
        }
        return [NSString stringWithFormat:@"%d小时以前",since/(60*60)];
    }
    NSString * formatterStr = @"HH:mm";
    if ([calenar isDateInYesterday:self]) {
        formatterStr = [NSString stringWithFormat:@"昨天 %@",formatterStr];
    }else{
        formatterStr = [NSString stringWithFormat:@"MM-dd %@",formatterStr];
        NSDateComponents * comps = [calenar components:NSCalendarUnitYear fromDate:self toDate:[[NSDate alloc]init] options:0];
        if (comps.year>=1) {
            formatterStr = [NSString stringWithFormat:@"yyyy-%@",formatterStr];
        }
    }
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterStr;
    formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en"];
    return [formatter stringFromDate:self];
}
/**
 刚刚(一分钟内)
 X分钟前(一小时内)
 X小时前(当天)
 昨天 (昨天)
 MM-dd (一年内)
 yyyy-MM-dd (更早期)
 */
-(NSString*__nullable)get2Time{
    NSCalendar * calenar = [NSCalendar currentCalendar];
    if ([calenar isDateInToday:self]) {
        //        NSDate * date = [[NSDate alloc]init];
        int since = [[[NSDate alloc]init]timeIntervalSinceDate:self ];
        if (since<60) {
            return @"刚刚";
        }
        if (since<60*60) {
            return [NSString stringWithFormat:@"%d分钟以前",since/60];
        }
        return [NSString stringWithFormat:@"%d小时以前",since/(60*60)];
    }
    NSString * formatterStr = @"HH:mm";
    if ([calenar isDateInYesterday:self]) {
        formatterStr = [NSString stringWithFormat:@"昨天 %@",@""];
    }else{
        formatterStr = [NSString stringWithFormat:@"MM月dd日 %@",@""];
        NSDateComponents * comps = [calenar components:NSCalendarUnitYear fromDate:self toDate:[[NSDate alloc]init] options:0];
        if (comps.year>=1) {
            formatterStr = [NSString stringWithFormat:@"yyyy年%@",formatterStr];
        }
    }
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterStr;
    formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en"];
    return [formatter stringFromDate:self];
}

+(__kindof NSDate*__nullable)dateWithEndStr:(NSString*__nullable)time{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    if (time.length>19) {
        formatter.dateFormat = @"yyyy-MM-dd-ss HH:mm";

    }else{
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";

    }
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en"];
    NSDate*date = [formatter dateFromString:time];
    return date;
}

-(NSString*__nullable)endTime{

    NSCalendar * calenar = [NSCalendar currentCalendar];
    NSString * formatterStr = @"HH:mm";

    if ([calenar isDateInYesterday:self]) {
        formatterStr=[NSString stringWithFormat:@"昨天 %@",formatterStr];
    }else if ([calenar isDateInToday:self]) {
        formatterStr=[NSString stringWithFormat:@"今天 %@",formatterStr];
    }else if([calenar isDateInTomorrow:self]){
        formatterStr=[NSString stringWithFormat:@"明天 %@",formatterStr];
    }else{
        formatterStr = [NSString stringWithFormat:@"MM月dd日%@",formatterStr];
        NSDateComponents * comps = [calenar components:NSCalendarUnitYear fromDate:self toDate:[[NSDate alloc]init] options:0];
        if (comps.year>=1) {
            formatterStr = [NSString stringWithFormat:@"yyyy年%@",formatterStr];
        }
    }

    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterStr;
    formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en"];
    return [formatter stringFromDate:self];
}
-(NSString*__nullable)nosTime{
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en"];
    return [formatter stringFromDate:self];

}

#pragma mark -获得当前时间
+ (__kindof NSString*__nullable)getCurrenTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

#pragma mark -获得时间间隔
+ (__kindof NSString*__nullable)getTimeInterval:(NSString*__nullable)currentime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [formatter dateFromString:currentime];
    NSDate *date2 = [NSDate date];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    int second = aTimer - hour*3600 - minute*60;
    NSString *dural = [NSString stringWithFormat:@"%d时%d分%d秒", hour, minute,second];
    return dural;
}

@end
