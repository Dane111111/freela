//
//  ClusterTableViewCell.h
//  iOS_3D_ClusterAnnotation
//
//  Created by PC on 15/7/7.
//  Copyright (c) 2015年 FENGSHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClusterTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIButton *tapBtn;
/**头像*/
@property (nonatomic , strong) UIImageView* xj_headerImg;
@property (nonatomic , strong) UILabel* xjTitleLabel;


@end
