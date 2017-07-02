//
//  XJPickARGiftCustiomViewController.h
//  FreeLa
//
//  Created by Leon on 2017/1/23.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XJPickARGiftCustiomViewControllerDelegate;

@interface XJPickARGiftCustiomViewController : UIViewController

@property (nonatomic , weak) id<XJPickARGiftCustiomViewControllerDelegate>delegate;

- (instancetype)initWithDelegate:(id<XJPickARGiftCustiomViewControllerDelegate>)delegate;

@end



@protocol XJPickARGiftCustiomViewControllerDelegate <NSObject>

/**
 * 缩略图
 * 使用说明
 * url
 */
- (void)xjPickARGiftCustiomViewController:(XJPickARGiftCustiomViewController*)chooseCus
                                      img:(UIImage*)img
                                introduce:(NSString*)introduce
                                      url:(NSString*)url;

@end
