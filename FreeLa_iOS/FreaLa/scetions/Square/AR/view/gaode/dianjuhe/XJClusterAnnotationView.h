//
//  XJClusterAnnotationView.h
//  iOS_ClusterAnnotation_3D
//
//  Created by Leon on 2017/1/5.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface XJClusterAnnotationView : MAAnnotationView
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic ,strong) NSString* xjHeaderImgStr;
@property (nonatomic , strong) NSString* xjHeaderImgPath;


- (void)xj_setCount:(NSInteger)count isInCircle:(BOOL)isin;


@end
