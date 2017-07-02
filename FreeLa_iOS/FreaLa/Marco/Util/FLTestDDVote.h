//
//  FLTestDDVote.h
//  FreeLa
//
//  Created by Leon on 15/10/29.
//  Copyright © 2015年 FreeLa. All rights reserved.
//


#define DDColor(r, g, b, al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]

//屏幕尺寸
/**当前屏幕宽度*/
#define DDScreenWidth ([UIScreen mainScreen].bounds.size.width)
/**当前屏幕高度*/
#define DDScreenHeight ([UIScreen mainScreen].bounds.size.height)
/**宽度系数*/
#define DDWidthMul (DDScreenWidth / 320.0)
/**高度系数*/
//#define DDHeightMum if(DDScreenHeight > 480)? ()
/**tabbar放大系数*/
#define DDTabbarMul (DDScreenWidth > 320? ((DDScreenWidth > 400)? 1.13: 1.07): 1)