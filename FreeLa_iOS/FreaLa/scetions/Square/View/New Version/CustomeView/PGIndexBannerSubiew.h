//
//  PGIndexBannerSubiew.h
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

/******************************
 
 可以根据自己的需要再次重写view
 
 ******************************/

#import <UIKit/UIKit.h>
@class FLRecyclePicModel;
@interface PGIndexBannerSubiew : UIView
@property (nonatomic, strong) FLRecyclePicModel *model;
/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;

/**
 *  左下角图
 */
@property (nonatomic, strong) UIImageView *leftBottomImageView;

/**
 *  左下角字
 */
@property (nonatomic, strong) UILabel *leftBottomLabel;
/**
 *  左下角箭头图
 */
@property (nonatomic, strong) UIImageView *arrowImageView;

@end
