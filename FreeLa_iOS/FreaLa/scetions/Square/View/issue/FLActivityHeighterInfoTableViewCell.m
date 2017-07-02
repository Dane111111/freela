//
//  FLActivityHeighterInfoTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/26.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLActivityHeighterInfoTableViewCell.h"
@interface FLActivityHeighterInfoTableViewCell()
@end

@implementation FLActivityHeighterInfoTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.flAvtivityHeighterLabel  = [[UILabel alloc] init];
        self.flAvtivityHeighterLabel.frame = CGRectMake(15, 0, FLUISCREENBOUNDS.width /  2, 44);
        [self.contentView addSubview:self.flAvtivityHeighterLabel];
        self.flAvtivityHeighterInfoLabel = [[UILabel alloc] init];
        self.flAvtivityHeighterInfoLabel.frame = CGRectMake(FLUISCREENBOUNDS.width / 2, 0, (FLUISCREENBOUNDS.width / 2) - 30, 44);
        [self.contentView addSubview:self.flAvtivityHeighterInfoLabel];
        
        self.flAvtivityHeighterLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
        self.flAvtivityHeighterInfoLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
        
        
        self.flAvtivityHeighterInfoLabel.textAlignment = NSTextAlignmentRight;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
