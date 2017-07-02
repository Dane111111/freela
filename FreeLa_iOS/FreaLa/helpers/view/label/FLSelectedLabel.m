//
//  FLSelectedLabel.m
//  FreeLa
//
//  Created by Leon on 16/1/28.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLSelectedLabel.h"

@implementation FLSelectedLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        FL_Log(@"12321412124123");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame selected:(BOOL)isSelected
{
    self = [super initWithFrame:frame];
    if (self) {
        _flselected = isSelected;
//        FL_Log(@"12321412124123sadasfasdsadwfwa");
    }
    return self;
}

@end
