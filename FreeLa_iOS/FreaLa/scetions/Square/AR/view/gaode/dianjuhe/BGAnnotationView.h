//
//  BGAnnotationView.h
//  FreeLa
//
//  Created by MBP on 17/7/7.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGAnnotationView : MAAnnotationView
@property (nonatomic, assign) NSUInteger count;

@property (nonatomic ,strong) NSString* xjHeaderImgStr;
- (void)xj_setCount:(NSInteger)count isInCircle:(BOOL)isin;

@end
