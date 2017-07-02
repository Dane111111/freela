//
//  FLTabViewController.m
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLTabViewController.h"
#import "FLSquareViewController.h"
#import "FLFreeCircleViewController.h"
#import "FLMineViewController.h"

#define addHeight 88
#define SELECTED_VIEW_CONTROLLER_TAG 98456345
//#define LAUNCH_VIEW_TAG 440

@interface FLTabViewController ()<FLTabbarViewDelegate>
{
    NSInteger currentIndex;
}

@end

@implementation FLTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTabBarView];


}

- (void)initTabBarView
{
     CGFloat height = 64;
    CGFloat tabbarHeight = 49 * DDTabbarMul;
    CGFloat tabbarWidth =DDScreenWidth;
    CGFloat tabbarX = 0;
    CGFloat tabbarY = DDScreenHeight - height - tabbarHeight;
    _tabBar = [[FLTabbarView alloc] initWithFrame:CGRectMake(tabbarX,  tabbarY, tabbarWidth, tabbarHeight)];
    _tabBar.backgroundColor = [UIColor clearColor];
    _tabBar.delegate = self;
    [self.view addSubview:_tabBar];
    
    _arrayViewControllers = [self getViewcontrollers];
    currentIndex = 0;
    [self touchBtnAtIndex:0];
    
    
    
}

- (NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    UIViewController *firstViewController  = [[FLSquareViewController alloc] initWithNibName:@"FLSquareViewController" bundle:nil];
    UIViewController *secondViewController = [[FLFreeCircleViewController alloc] initWithNibName:@"FLFreeCircleViewController" bundle:nil];
    UIViewController *thirdViewController   = [[FLMineViewController alloc] initWithNibName:@"FLMineViewController" bundle:nil];
//    UIViewController *fiveViewController   = [[DDAccountBriefViewController alloc] initWithNibName:@"DDAccountBriefViewController" bundle:nil];
    //账户控制器
//    self.userController = firstViewController;
    
    
    tabBarItems = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@[@"filter",@"search"], @"images", firstViewController, @"viewController",@"Hi帮",@"leftTitle", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@[@"close",@"search"], @"images", secondViewController, @"viewController",@"Hi帮",@"leftTitle", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@[@"search",@"add"], @"images", thirdViewController, @"viewController",@"Hi帮",@"leftTitle", nil],
                   nil];
    return tabBarItems;
}

- (void)touchBtnAtIndex:(NSInteger)index
{
    if (currentIndex != index) {
        //  点击各个界面需要通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FLTabControllerItemPressedNotification object:@(index) userInfo:nil];
    }
    
    currentIndex = index;
    
    if (currentIndex == 2) {
        
    } else {
        UIView *currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
        [currentView removeFromSuperview];
        
        UIViewController *viewController = [_arrayViewControllers objectAtIndex:index][@"viewController"];
        viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
        viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 40 * DDTabbarMul);
        
        [self.view insertSubview:viewController.view belowSubview:_tabBar];
        
        [self createNavigationBarWithIndex:currentIndex];
    }
    //设置返回按钮的文字
    NSString *backStr;
    switch (index) {
        case 0:
            backStr = @"广场";
            break;
        case 1:
            backStr = @"我的";
            break;
        case 3:
            backStr = @"朋友圈";
            break;
        case 4:
            backStr = @"账户";
            break;
        default:
            break;
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backStr style:UIBarButtonItemStylePlain target:nil action:nil];
}
//
//- (void)createNavigationBarWithIndex:(NSInteger)index {
//    self.navigationItem.titleView = nil;
//    if (index == 2) {
//        
//    }
//    else {
//        NSDictionary *dic = [_arrayViewControllers objectAtIndex:currentIndex];
//        UIViewController *viewController = dic[@"viewController"];
//        
//        [self createBackButtonWithImage:[UIImage imageNamed:@"logo.png"] title:dic[@"leftTitle"]];
//        
//        UIBarButtonItem *fixedBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
//        fixedBar.width = 14;
//        
//        UIButton *firstButton      = nil;
//        UIButton *secondButton     = nil;
//        UIBarButtonItem *firstBar  = nil;
//        UIBarButtonItem *secondBar = nil;
//        
//        if (currentIndex == 3 || currentIndex == 4) {
//            if (currentIndex == 3) {
//                firstButton = [self navigationButtonWithImage:[UIImage imageNamed:@"放大镜"]
//                                                       target:viewController
//                                                       action:@selector(search:)];
//                firstBar = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
//                self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLogoAndText:@"Hi帮" target:nil action:nil];
//            }
//            else if (currentIndex == 4) {
//                firstButton = [self navigationButtonWithImage:[UIImage imageNamed:@"设置"]
//                                                       target:viewController
//                                                       action:@selector(gotoDetailed:)];
//                firstBar = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
//                self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLogoAndText:@"我的账户" target:nil action:nil];
//            }
//            NSArray *barArray = secondBar ? @[secondBar, fixedBar, firstBar] : @[firstBar];
//            self.navigationItem.rightBarButtonItems = barArray;
//        }
//        else if (currentIndex == 1) {
//            DDVoteCollectionViewController *vc = (DDVoteCollectionViewController *)viewController;
//            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLogoAndText:@"Hi帮" target:nil action:nil];
//            if (!vc.barButtonArray) {
//                firstButton = [self navigationButtonWithImage:[UIImage imageNamed:@"放大镜"]
//                                                       target:viewController
//                                                       action:@selector(search:)];
//                firstBar = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
//                
//                UIButton *secondButton = [self navigationButtonWithImage:[UIImage imageNamed:@"删除"]
//                                                                  target:viewController
//                                                                  action:@selector(deleteItem:)];
//                UIBarButtonItem *secondBar = [[UIBarButtonItem alloc] initWithCustomView:secondButton];
//                
//                self.navigationItem.rightBarButtonItems = @[firstBar, secondBar];
//            } else {
//                self.navigationItem.rightBarButtonItems = vc.barButtonArray;
//            }
//        }
//        if (currentIndex == 0) {
//            //                secondButton = [self navigationButtonWithImage:[UIImage imageNamed:@"删选"]
//            //                                                        target:viewController
//            //                                                        action:@selector(filter:)];
//            //                secondBar  = [[UIBarButtonItem alloc] initWithCustomView:secondButton];
//            //                firstButton = [self navigationButtonWithImage:[UIImage imageNamed:@"放大镜"]
//            //                                                       target:viewController
//            //                                                       action:@selector(search:)];
//            //                firstBar = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
//            //                self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLogoAndText:@"Hi帮" target:nil action:nil];
//            DDSquareViewController *squareVC = (DDSquareViewController *)viewController;
//            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLogoAndText:@"Hi帮" target:nil action:nil];
//            if (!squareVC.barButtonArray) {
//                firstButton = [self navigationButtonWithImage:[UIImage imageNamed:@"放大镜"]
//                                                       target:viewController
//                                                       action:@selector(search:)];
//                firstBar = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
//                secondButton = [self navigationButtonWithImage:[UIImage imageNamed:@"删选"]
//                                                        target:viewController
//                                                        action:@selector(filter:)];
//                secondBar  = [[UIBarButtonItem alloc] initWithCustomView:secondButton];
//                self.navigationItem.rightBarButtonItems = @[secondBar,firstBar];
//            } else {
//                self.navigationItem.rightBarButtonItems = squareVC.barButtonArray;
//            }
//        }
//    }
//    
//}
//





@end
























