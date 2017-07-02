//
//  FLBaseViewController.h
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLBaseViewController : UIViewController

@property (nonatomic , copy)NSString* naviTitle;

- (void)createBackButtonWithImage:(UIImage *)image title:(NSString *)title ;
- (void)returnBtnTapped:(id)sender;
- (void)pushNavigationerToController:(FLBaseViewController *)controller;
- (void)popNavigationer;

/**
 *  建立导航栏,默认只建立了左侧返回健(包括一个返回箭头和上一层的naviTitle)
 */
- (void)createNavigationBar;

/**
 *  建立rightButton
 *
 *  @param frame
 *  @param str
 *  @param target
 *  @param selector
 *
 *  @return
 */
- (UIBarButtonItem *)buttonWithFrame:(CGRect)frame
                           andString:(NSString *)str
                           andTarget:(id)target
                         andSelector:(SEL)selector;


@end

































