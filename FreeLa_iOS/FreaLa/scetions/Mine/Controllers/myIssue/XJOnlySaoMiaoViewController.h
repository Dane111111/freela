//
//  XJOnlySaoMiaoViewController.h
//  FreeLa
//
//  Created by Leon on 2017/1/10.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJOnlySaoMiaoViewController : UIViewController

/**model*/
@property (nonatomic , strong) FLMyIssueInMineModel* flmodel;

/**进来干啥  1 扫码进活动  2 验票*/
@property (nonatomic , assign) NSInteger flComeType;


- (instancetype)initWithType:(NSInteger)xjType;
@end
