//
//  FLMyNewCustomTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/1/29.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyNewCustomTableViewCell.h"

@implementation FLMyNewCustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
     self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
