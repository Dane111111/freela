//
//  FLCountDownActivityModel.m
//  a
//
//  Created by 佟 on 2017/5/16.
//  Copyright © 2017年 xj. All rights reserved.
//

#import "FLCountDownActivityModel.h"

@implementation FLCountDownActivityModel


+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CountDownItem class]};
}
@end
@implementation CountDownItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"NewDate" : @"newDate"
             };
    
}
- (void)mj_keyValuesDidFinishConvertingToObject{
    _countDownTime = [self getCountDownStringWithEndTime:_endTime];
}

-(NSString *)getCountDownStringWithEndTime:(NSString *)endTime {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[NSDate date];
    NSDate *endD = [inputFormatter dateFromString:endTime];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:startD toDate:endD options:NSCalendarWrapComponents];
    return [NSString stringWithFormat:@"%ld天%ld时",dateCom.day,dateCom.hour];

}
@end


