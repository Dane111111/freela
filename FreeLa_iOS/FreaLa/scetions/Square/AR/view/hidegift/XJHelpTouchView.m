//
//  XJHelpTouchView.m
//  FreeLa
//
//  Created by Leon on 2017/1/23.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJHelpTouchView.h"

@implementation XJHelpTouchView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //如果希望严谨一点，可以将上面if语句及里面代码替换成如下代码
    //UIView *view = [_redButton hitTest: redBtnPoint withEvent: event];
    //if (view) return view;
    return [super hitTest:point withEvent:event];
}

@end
