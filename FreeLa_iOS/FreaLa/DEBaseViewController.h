//
//  DEBaseViewController.h
//  FreeLa
//
//  Created by MBP on 17/7/3.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface DEBaseViewController : UIViewController
@property (nonatomic,strong) UIView * NavView;

@property (nonatomic,strong) UIView * BackView;

/**
 *  @brief 返回按钮点击事件
 */
- (void)navBackButtonClicked:(UIButton *)sender;
/**
 *	@brief	自定义titlte居中处理
 *
 *	@param 	title 	title
 */


- (void)setNavTitle:(NSString *)title;
- (void)setNavTitle:(NSString *)title withColor:(UIColor *)color;

-(void)setLeftButtonWithImg:(NSString *)norImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action btnTitleColor:(UIColor*)btnTitleColor;
-(void)setRightButtonWithImg:(NSString *)norImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action btnTitleColor:(UIColor*)btnTitleColor;


// 设置导航栏
- (void) setNavWithLeftView:(UIView *) leftview andMidView:(UIView *) midView andRightView:(UIView*) RightView;


//为了UI设置导航栏

- (void) setNavWithLeftView:(UIView *) view;

//为了我妹设置导航栏

- (void) setNavWithLeftView:(UIView *) view andCenterView:(UIView *) centerView;


@end
