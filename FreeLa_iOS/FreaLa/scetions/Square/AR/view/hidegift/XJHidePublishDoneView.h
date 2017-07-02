//
//  XJHidePublishDoneView.h
//  FreeLa
//
//  Created by Leon on 2017/1/8.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^xjClickToShre)(void);

@interface XJHidePublishDoneView : UIView
@property (nonatomic, weak)UIViewController *parentVC;

@property (nonatomic ,strong) UIImageView* xj_topicThemImgView;

@property (nonatomic , strong) UILabel* xj_addressLabel;

@property (nonatomic , copy) xjClickToShre block;

- (void)xjClickToShareGift:(xjClickToShre)block;

@end
