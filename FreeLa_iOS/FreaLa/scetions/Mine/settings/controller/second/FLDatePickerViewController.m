//
//  FLDatePickerViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/15.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLDatePickerViewController.h"
#import "FLHeader.h"
#import <Masonry/Masonry.h>
@interface FLDatePickerViewController ()

@end

@implementation FLDatePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datePicker = [[UIDatePicker alloc]init];
//    self.datePicker.frame =CGRectMake(0, FLUISCREENBOUNDS.height - 310 , FLUISCREENBOUNDS.width, 200);
    self.datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(FLUISCREENBOUNDS.width, 200));
    }];
    CGRect frame = CGRectZero;
    frame.size.width = FLUISCREENBOUNDS.width;
    frame.size.height = 200;
    self.view.frame = frame;
    //改变时调用方法
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    //设置显示格式
    //默认根据手机本地设置显示为中文还是其他语言
    NSLocale* locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]; //中文
    self.datePicker.locale = locale;
    
    //当前时间创建 NSDate
    NSDate* localDate = [NSDate date];
    //在当前时间加上的时间
    NSCalendar * gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* offsetComponents = [[NSDateComponents alloc]init];
    //设置时间
    [offsetComponents setYear:0];
    [offsetComponents setMonth:0];
    [offsetComponents setDay:5];
    [offsetComponents setHour:20];
    [offsetComponents setMinute:0];
    [offsetComponents setSecond:0];
    //设置最大时间
    NSDate* maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:localDate options:0];
    //设置属性
    self.datePicker.maximumDate = maxDate;
//    self.datePicker.minimumDate = localDate;
    
    [self initYear];
    
    
}

-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    //添加你自己响应代码
    NSLog(@"dateChanged响应事件：%@",date);
    
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [self.datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日(EEEE)   HH:mm:ss"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    
    //打印显示日期时间
    NSLog(@"格式化显示时间：%@",dateString);
    _showLabel.text = dateString;
    
}

- (void)initYear
{
    
    
}





@end
