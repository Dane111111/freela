//
//  FLCouponsTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/11/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FLSquareConcouponseModel.h"
#import "XJVersionTwoAllFreeModel.h"
#import "XJVersionTwoCouponsModel.h"


@interface FLCouponsTableViewCell : UITableViewCell


/**模型*/
@property (nonatomic , strong)FLSquareConcouponseModel* flsquareConcouponseModel;

/**----------------------*/
@property (nonatomic , strong) XJVersionTwoCouponsModel* xjCellModel;

@end









