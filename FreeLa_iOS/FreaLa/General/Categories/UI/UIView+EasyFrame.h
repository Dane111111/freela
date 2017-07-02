//
//  UIView+EasyFrame.h
//  EasyFrame
//
//  Created by mac on 14-8-31.
//  Copyright (c) 2014年 TG. All rights reserved.
//  方便操作Frame

#import <UIKit/UIKit.h>

@interface UIView (EasyFrame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@end
