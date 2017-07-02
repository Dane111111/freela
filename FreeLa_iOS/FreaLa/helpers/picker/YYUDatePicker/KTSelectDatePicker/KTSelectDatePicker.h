//
//  KTSelectDatePicker.h
//  KTSelectDatePicker
//
//  Created by hcl on 15/10/9.
//  Copyright (c) 2015年 hcl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTSelectPickerView.h"

typedef void (^DataTimeSelect)(NSDate *selectDataTime);

@interface KTSelectDatePicker : NSObject

///是否可选择当前时间之前的时间,默认为NO
@property (nonatomic,assign) BOOL isBeforeTime;

///是否可选择当前时间之后的时间,默认为YES
@property (nonatomic,assign) BOOL xjCanLaterTime;

///DatePickerMode,默认是DateAndTime
@property (assign, nonatomic) UIDatePickerMode datePickerMode;

- (void)didFinishSelectedDate:(DataTimeSelect)selectDataTime;

@end
