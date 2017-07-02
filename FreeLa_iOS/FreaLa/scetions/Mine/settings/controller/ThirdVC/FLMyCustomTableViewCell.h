//
//  FLMyCustomTableViewCell.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/19.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLUserInfoModel.h"
#import "FLUserCellModel.h"

@interface FLMyCustomTableViewCell : UITableViewCell

@property (nonatomic , strong)FLUserCellModel* userCellModel;
@property (nonatomic , strong)FLUserInfoModel* userInfoModel;


@end
