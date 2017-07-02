//
//  FLDiscribeTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/8.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLDiscribeTableViewCell.h"

@implementation FLDiscribeTableViewCell

- (void)awakeFromNib {
    // Initialization code
     self.flmydiscription.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    self.flmydiscription.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUserCellModel:(FLUserCellModel *)userCellModel
{
    _userCellModel = userCellModel;
}


@end
