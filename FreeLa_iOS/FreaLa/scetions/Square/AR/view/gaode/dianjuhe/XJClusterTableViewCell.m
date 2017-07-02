//
//  XJClusterTableViewCell.m
//  FreeLa
//
//  Created by Leon on 2017/1/11.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJClusterTableViewCell.h"

@implementation XJClusterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.xjHeaderImgView.layer.cornerRadius = 20;
    self.xjHeaderImgView.layer.masksToBounds = YES;
//    self.xjBaseImgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
