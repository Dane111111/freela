//
//  XJBalloonAndPhoto.h
//  FreeLa
//
//  Created by MBP on 17/8/3.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#define xj_tag  193992

@interface XJBalloonAndPhoto : UIView
@property(nonatomic,assign)NSInteger num;
@property(nonatomic,strong)UIImageView* imageV;
@property(nonatomic,strong)UILabel*dianzanLabel;
@property(nonatomic,strong)UIView*dianZanView;
@property(nonatomic,strong)void(^actionBlock)(NSInteger);
@end
