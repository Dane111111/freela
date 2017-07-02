//
//  FLAppDelegate.h
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/14.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class FLTabViewController;
#import "FLTabViewController.h"
#import "FLChooseController.h"
//#import "FLTabBarViewController.h"
#import "FLUserInfoModel.h"
#import "FLNetTool.h"
#import "FLApplyBusinessAccountViewController.h"
//youmeng
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"
#import "XJGGViewController.h"

typedef void (^HUDCancel)();

#define DECKRIGHGWIDTH 65
#define APP_ENTERFOREGROUND_NOTIFICATION @"APP_ENTERFOREGROUND_NOTIFICATION"
#define AUTHOR_FAILED_NOTI  @"AUTHOR_FAILED_NOTI"



@interface FLAppDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;
@property (nonatomic , strong) UITabBarController*     xjTabBar;

//test
@property (nonatomic , strong)UINavigationController* naviController;//navi
//@property (nonatomic , strong)FLTabBarViewController* tabBarController; //tabbar
- (void)setUpTabBar;
+ (FLAppDelegate*)share;

#pragma mark - MBProgressHUD
- (void)showHUDWithTitile:(NSString *)title;
- (void)showHUDWithTitile:(NSString *)title withCancel:(void(^)())cancelBlock;
- (void)setHUDTitle:(NSString *)titile;
- (void)hideHUD;
- (void)hideHUD:(CGFloat)afterDelay;

#pragma mark -----selfHUD
/**
 *只显示文本
 *一些参数
 */
- (void)showHUDWithTitile:(NSString *)title view:(UIView*)view delay:(CGFloat)delay offsetY:(CGFloat)offsetY;
/**
 *小菊花出来吧（动画）
 */
- (void)showSimplleHUDWithTitle:(NSString*)title view:(UIView*)view;
/**
 *嘿嘿嘿
 */
- (void)showdimBackHUDWithTitle:(NSString*)title view:(UIView*)view;
/**
 *new
 *一些参数
 */
- (void)showHUDWithTitile:(NSString *)title delay:(CGFloat)delay offsetY:(CGFloat)offsetY;

@end















