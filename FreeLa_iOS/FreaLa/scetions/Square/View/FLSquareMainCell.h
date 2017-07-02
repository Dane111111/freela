//
//  FLSquareMainCell.h
//  FreeLa
//
//  Created by Leon on 15/10/27.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLSquareAllFreeModel.h"
#import "FLTool.h"
@interface FLSquareMainCell : UITableViewCell
/**分类图标*/
@property (weak, nonatomic) IBOutlet UIImageView *flCategoryImageView;
/**分类*/
@property (weak, nonatomic) IBOutlet UILabel *flCategoryLabel;
/**背景*/
@property (weak, nonatomic) IBOutlet UIImageView *flBackGroundImageView;
/**领取类别*/
@property (weak, nonatomic) IBOutlet UILabel *flPickupStyleLabel;
/**时间*/
@property (weak, nonatomic) IBOutlet UILabel *flCreatTimeLabel;
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *flTopicThemeLabel;
/**数量标志*/
@property (weak, nonatomic) IBOutlet UIImageView *flNumberLogoImageView;
/**应该是阅读数量*/
@property (weak, nonatomic) IBOutlet UILabel *flNumberLabel;
/**进度*/
@property (weak, nonatomic) IBOutlet UIProgressView *flProgressView;
/**进度label*/
@property (weak, nonatomic) IBOutlet UILabel *flProgressLabel;



/**模型*/
@property (nonatomic , strong)FLSquareAllFreeModel* flsquareAllFreeModel;

@end












