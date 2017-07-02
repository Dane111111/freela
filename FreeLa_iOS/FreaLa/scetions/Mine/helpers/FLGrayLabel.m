//
//  FLGrayLabel.m
//  FreeLa
//
//  Created by Leon on 16/1/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLGrayLabel.h"

@implementation FLGrayLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    }
    return self;
}
@end
