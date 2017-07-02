//
//  FLTabViewController.h
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLBaseViewController.h"
#import "FLTabbarView.h"
#define FLTabControllerItemPressedNotification @"FLTabControllerItemPressedNotification"


@interface FLTabViewController : FLBaseViewController

@property (nonatomic , strong) FLTabbarView* tabBar;
@property (nonatomic , strong) NSArray     * arrayViewControllers;


- (void)createNavigationBarWithIndex:(NSInteger)index;
- (void)touchBtnAtIndex:(NSInteger)index;
- (void)checkMask;  //确定是否有遮挡曾
/**加载未读信息,也就是下面的红点*/
- (void)loadNews;

@end
