//
//  XJPushMessagesBtn.h
//  FreeLa
//
//  Created by Leon on 16/5/18.
//  Copyright © 2016年 FreeLa. All rights reserved.
//  A Button with badge

#import <UIKit/UIKit.h>

@interface XJPushMessagesBtn : UIView
@property (nonatomic , strong) UIButton* xjBtn;
@property (nonatomic , assign) NSInteger xjBadges;

@property (nonatomic , strong) UIImage* xjImage;
- (void)changeImageWithBool:(BOOL)xjIsWhite;

@end
