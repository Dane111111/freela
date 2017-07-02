//
//  FLMyCustomTableViewCell.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/19.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyBusAccountListModel.h"
#import <QuartzCore/QuartzCore.h>

@interface FLMyCustomTableViewCell : UITableViewCell
/**传进来的模型*/
@property (nonatomic , strong) FLMyBusAccountListModel* flMyBusAccountListModel;
//@property (nonatomic , strong)NSString* name;
@property (weak, nonatomic) IBOutlet UIImageView *myPortraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myAccountNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *myStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myChoiceImageView;    //选中状态
/**身份*/
@property (weak, nonatomic) IBOutlet UILabel *myAuroraLabel;


@end
