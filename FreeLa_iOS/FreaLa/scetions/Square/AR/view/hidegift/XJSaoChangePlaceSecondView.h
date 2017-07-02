//
//  XJSaoChangePlaceSecondView.h
//  FreeLa
//
//  Created by Collegedaily on 2017/5/2.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^xjClickToReSao)(void);

@interface XJSaoChangePlaceSecondView : UIView

@property (nonatomic , copy)xjClickToReSao block;

- (void)xjClickToReSao:(xjClickToReSao)block;

@end
