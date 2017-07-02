//
//  FLSquareConcouponseModel.h
//  FreeLa
//
//  Created by Leon on 15/12/17.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FLSquareConcouponseModel : NSObject
/**分类图标*/
@property (strong, nonatomic)  UIImage *flCategoryImage;
/**分类*/
//@property (strong, nonatomic)  NSString *flCategoryStrFuck;
@property (nonatomic , strong) NSString* flfuckStr;
/**背景*/
@property (strong, nonatomic)  NSString *flBackGroundImageStr;
/**领取类别*/
@property (strong, nonatomic)  NSString *flPickupStyleStr;
/**时间*/
@property (strong, nonatomic)  NSString *flCreatTimeStr;
/**标题*/
@property (strong, nonatomic)  NSString *flTopicThemeStr;
/**数量标志*/
@property (strong, nonatomic)  NSString *flNumberLogoImageStr;
/**数量*/
@property (strong, nonatomic)  NSString *flNumberStr;
/**进度*/
@property (assign, nonatomic)  float *flProgressfloat;
/**进度label 已领*/
@property (strong, nonatomic)  NSString *flProgressStrAlready;
/**进度label 剩余*/
@property (strong, nonatomic)  NSString *flProgressStrNoperson;
@end
