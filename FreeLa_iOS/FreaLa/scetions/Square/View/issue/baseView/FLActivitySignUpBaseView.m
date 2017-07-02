//
//  FLActivitySignUpBaseView.m
//  FreeLa
//
//  Created by Leon on 15/11/27.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLActivitySignUpBaseView.h"
#import <Masonry/Masonry.h>
#import "FLHeader.h"
@implementation FLActivitySignUpBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fllabel = [[UILabel alloc] init];
        self.flopenSwitch = [[UISwitch alloc] init];
        self.flopenSwitch.on = YES;
        _fllabel.text = @"用户报名填写信息";
        _fllabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
        self.backgroundColor = [UIColor whiteColor];
        _fllabel.frame = CGRectMake(15, 0, FLUISCREENBOUNDS.width / 2, 44);
        [self  addSubview:_fllabel];
        [self  addSubview:self.flopenSwitch];
        [self makeMyConstraints];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
   
    
}


- (void)makeMyConstraints
{
    [self.flopenSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 31));
    }];
    
    
}
 

@end
