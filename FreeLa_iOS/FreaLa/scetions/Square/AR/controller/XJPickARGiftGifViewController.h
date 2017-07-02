//
//  XJPickARGiftGifViewController.h
//  FreeLa
//
//  Created by Leon on 2017/1/23.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XJPickARGiftGifViewControllerDelegate;

@interface XJPickARGiftGifViewController : UIViewController

@property (nonatomic , weak) id<XJPickARGiftGifViewControllerDelegate>delegate;

- (instancetype)initWithDelegate:(id<XJPickARGiftGifViewControllerDelegate>)delegate;

@end


@protocol XJPickARGiftGifViewControllerDelegate <NSObject>

- (void)xjPickARGiftGifViewController:(XJPickARGiftGifViewController*)chooseGif didchooseDone:(NSString*)filename imgurl:(NSString*)imgurl;

@end
