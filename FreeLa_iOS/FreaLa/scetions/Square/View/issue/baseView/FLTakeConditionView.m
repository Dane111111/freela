//
//  FLTakeConditionView.m
//  FreeLa
//
//  Created by Leon on 15/11/27.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLTakeConditionView.h"

@implementation FLTakeConditionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.fllabel.text = @"领取条件";
    }
    return self;
}


@end
