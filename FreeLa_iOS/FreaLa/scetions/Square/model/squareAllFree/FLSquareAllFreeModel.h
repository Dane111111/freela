//
//  FLSquareAllFreeModel.h
//  FreeLa
//
//  Created by Leon on 15/12/16.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FLSquareAllFreeModel : NSObject
/**分类图标*/
@property (strong, nonatomic)  UIImage *flCategoryImage;
/**分类*/
@property (strong, nonatomic)  NSString *flCategoryStr;
/**背景*/
@property (strong, nonatomic)  NSString *flBackGroundImageStr;
/**领取类别*/
@property (strong, nonatomic)  NSString *flPickupStyleStr;
/**创建时间*/
@property (strong, nonatomic)  NSString *flCreatTimeStr;
/**截止时间*/
@property (strong, nonatomic)  NSString *flinvalidTimeStr;
/**标题*/
@property (strong, nonatomic)  NSString *flTopicThemeStr;
/**数量标志*/
@property (strong, nonatomic)  NSString *flNumberLogoImageStr;
/**应该是阅读数量*/
@property (strong, nonatomic)  NSString *flNumberStr;
/**进度*/
@property (assign, nonatomic)  float *flProgressfloat;
/**进度label Big*/
@property (strong, nonatomic)  NSString *flProgressStrBig;
/**进度label Small*/
@property (strong, nonatomic)  NSString *flProgressStrSmall;

/**topic ID*/
@property (strong , nonatomic) NSString* flTopicTopicId;
@end







