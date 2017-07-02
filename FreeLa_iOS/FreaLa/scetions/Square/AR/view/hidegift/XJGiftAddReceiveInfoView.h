//
//  XJGiftAddReceiveInfoView.h
//  FreeLa
//
//  Created by Leon on 2017/1/15.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^xjReturnReceiveInfoBlock) (NSString* xjReceiveInfo);

@interface XJGiftAddReceiveInfoView : UIView

// 声明block属性
@property (nonatomic, copy) xjReturnReceiveInfoBlock block;
- (void)xj_ReturnReceiveInfo:(xjReturnReceiveInfoBlock)block;


@end
