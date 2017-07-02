//
//  XJSaoMaViewController.h
//  FreeLa
//
//  Created by Leon on 2017/1/9.
//  Copyright © 2017年 FreeLa. All rights reserved.
//  仅作为首页扫码 用

#import <UIKit/UIKit.h>

@interface XJSaoMaViewController : UIViewController

/**model*/
@property (nonatomic , strong) FLMyIssueInMineModel* flmodel;

/**进来干啥  1 扫码进活动  2 验票*/
@property (nonatomic , assign) NSInteger flComeType;

- (instancetype)initWithType:(NSInteger)xjType;
@end
