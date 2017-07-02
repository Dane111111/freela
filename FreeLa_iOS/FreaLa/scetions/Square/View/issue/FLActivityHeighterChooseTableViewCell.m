//
//  FLActivityHeighterChooseTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/26.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLActivityHeighterChooseTableViewCell.h"
#import "FLHeader.h"

@implementation FLActivityHeighterChooseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.flAvtivityHeighterLabel = [[UILabel alloc] init];
        self.flAvtivityHeighterLabel.frame = CGRectMake(10, 0, 100, 44);
        self.flAvtivityHeighterLabel.text = @"高级选项";
        [self.contentView addSubview:self.flAvtivityHeighterLabel];
        self.flAvtivityHeighterImageVIew = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"issue_jiantiu_top"]];
        self.flAvtivityHeighterImageVIew.frame = CGRectMake(FLUISCREENBOUNDS.width -30 , 10, 20, 20);
        [self.contentView addSubview:self.flAvtivityHeighterImageVIew];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       
    }
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    self.selected = !self.selected;
 
}

@end
