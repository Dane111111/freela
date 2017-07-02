//
//  PGIndexBannerSubiew.m
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "PGIndexBannerSubiew.h"
#import "FLAdvertTopicPictures.h"
#import <UIImageView+WebCache.h>

@implementation PGIndexBannerSubiew

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.mainImageView];
        [self addSubview:self.coverView];
        [self addSubview:self.leftBottomImageView];
        [self addSubview:self.leftBottomLabel];
        [self addSubview:self.arrowImageView];
        [self updateViews];
    }
    
    return self;
}

- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _mainImageView.userInteractionEnabled = YES;
    }
    return _mainImageView;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}
- (UIImageView *)leftBottomImageView{
    if (_leftBottomImageView == nil) {
        _leftBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 15, self.bounds.size.width / 2, 15)];
        _leftBottomImageView.image = [UIImage imageNamed:@"pv_bg"];
    }
    return _leftBottomImageView;
}
- (UILabel *)leftBottomLabel{
    if (_leftBottomLabel == nil) {
        _leftBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 15 , self.bounds.size.width / 2, 15)];
        _leftBottomLabel.font = [UIFont systemFontOfSize:XJ_LABEL_SIZE_SMALL];
        _leftBottomLabel.text = @"100已看过";
        _leftBottomLabel.textColor = [UIColor whiteColor];
    }
    return _leftBottomLabel;
}
- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:self.leftBottomLabel.frame];
        _arrowImageView.image = [UIImage imageNamed:@"jiantou"];
    }
    return _arrowImageView;
}
- (void)setModel:(FLRecyclePicModel *)model{
    _model = model;
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:[model.filePath2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    self.leftBottomLabel.text = [NSString stringWithFormat:@"%ld已看过",model.pv];
    [self updateViews];
}
- (void)updateViews{
    [_leftBottomLabel sizeToFit];
    self.arrowImageView.frame = CGRectMake(CGRectGetMaxX(_leftBottomLabel.frame) + 5, _leftBottomLabel.frame.origin.y, 15, 15);
    CGRect currentFrame = self.leftBottomImageView.frame;
    self.leftBottomImageView.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y, CGRectGetMaxX(self.arrowImageView.frame) + 5, 15);
    
}
@end
