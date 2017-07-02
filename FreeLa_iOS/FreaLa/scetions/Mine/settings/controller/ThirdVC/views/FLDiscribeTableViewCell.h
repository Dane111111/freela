//
//  FLDiscribeTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/11/8.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLUserCellModel.h"
@interface FLDiscribeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *flmydiscription;
@property (weak, nonatomic) IBOutlet UILabel *flmyTitle;
@property (nonatomic , strong)FLUserCellModel* userCellModel;
@end
