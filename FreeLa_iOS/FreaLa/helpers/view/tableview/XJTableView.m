//
//  XJTableView.m
//  FreeLa
//
//  Created by Leon on 16/6/3.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJTableView.h"
@interface XJTableView()<UIScrollViewDelegate>

@end

@implementation XJTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self xjSetImageViewWithStation];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xjSetImageViewWithStation];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self xjSetImageViewWithStation];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self xjSetImageViewWithStation];
    }
    return self;
}

- (UIImageView *)xjImageView {
    if (!_xjImageView) {
        _xjImageView = [[UIImageView alloc] init];
    }
    return _xjImageView;
}

- (FLGrayLabel *)xjLabel {
    if (!_xjLabel) {
        _xjLabel = [[FLGrayLabel alloc] init];
    }
    return _xjLabel;
}

- (void)xjSetImageViewWithStation {
    self.xjImageView.frame = CGRectMake((self.frame.size.width/2)-70, (self.frame.size.height/ 2) - 50, 140, 80);
    self.xjLabel.frame     = CGRectMake(0, 165, FLUISCREENBOUNDS.width, 20);
    self.xjLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
//    self.xjImageView.center = self.center;
    [self addSubview:self.xjImageView];
    [self addSubview:self.xjLabel];
    self.xjImageView.hidden = YES;
    self.xjLabel.hidden = YES;
    self.xjLabel.text = @"没有符合当前条件下的信息";
    self.xjLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)xjSetHidden:(BOOL)xjHidden state:(XJImageState)xjState {
    if (xjState == XJImageStateNoInterNet) {
        self.xjImageView.image = [UIImage imageNamed:@"image_nointernet_default"];
        self.xjLabel.text = @"无网络链接";
    } else if (xjState == XJImageStateNoResult) {
         self.xjImageView.image = [UIImage imageNamed:@"image_noinfo_default"];
    } else if (xjState == XJImageStateNoInfo) {
         self.xjImageView.image = [UIImage imageNamed:@"image_noinfo_default"];
    }
     self.xjImageView.hidden = xjHidden;
    self.xjLabel.hidden = xjHidden;
}

- (void)setXjImageViewFrame:(CGRect)xjImageViewFrame {
    _xjImageViewFrame = xjImageViewFrame;
    self.xjImageView.frame = xjImageViewFrame;
    CGRect xjFrame = xjImageViewFrame;
    xjFrame.origin.y += self.xjImageView.frame.size.height +2;
    self.xjLabel.frame =xjFrame;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat testY ;
// 
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > NAVBAR_CHANGE_POINT) {
//     
//        
//    } else {
//        
//    }
//
//}

@end



















