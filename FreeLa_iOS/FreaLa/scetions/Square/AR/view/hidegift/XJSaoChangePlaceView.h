//
//  XJSaoChangePlaceView.h
//  FreeLa
//
//  Created by Leon on 2017/1/16.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^xjClickToReSao)(void);

@interface XJSaoChangePlaceView : UIView

@property (nonatomic , copy)xjClickToReSao block;

- (void)xjClickToReSao:(xjClickToReSao)block;

@end
