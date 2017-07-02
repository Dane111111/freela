//
//  FLSaoMiaoViewController.h
//  FreeLa
//
//  Created by Leon on 16/1/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLSaoMiaoViewController : UIViewController

/**model*/
@property (nonatomic , strong) FLMyIssueInMineModel* flmodel;

/**进来干啥  1 扫码进活动  2 验票*/
@property (nonatomic , assign) NSInteger flComeType;
@end
