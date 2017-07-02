//
//  XJBirdFlyGifHeader.m
//  FreeLa
//
//  Created by Leon on 16/4/22.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJBirdFlyGifHeader.h"

@implementation XJBirdFlyGifHeader
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i < 3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loding_pre%zd", i]];  //bird 3
//         UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"donghua_%zd", i +1]]; 55
        [idleImages addObject:image];
    }
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    [self setImages:idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [self setImages:idleImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:idleImages forState:MJRefreshStateRefreshing];
 
}
@end
