//
//  FLChangeAccountPersonalTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/2/4.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLUserInfoModel.h"

@interface FLChangeAccountPersonalTableViewCell : UITableViewCell
/**传进来的模型*/
@property (nonatomic , strong) FLUserInfoModel* fluserInfoModel;

@property (weak, nonatomic) IBOutlet UIImageView *myPortraitImageView;

@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *myAccountNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myChoiceImageView;

@end
