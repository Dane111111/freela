//
//  FLAvtivityCustomTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/26.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLAvtivityCustomTableViewCell.h"



@implementation FLAvtivityCustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
//        self.flAvtivityLogoImageView = [[UIImageView alloc] init];
   
        self.flAvtivityDisCribeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.flAvtivityDisCribeLabel];
        
        
        self.flAvtivityDiscribeInfoLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.flAvtivityDiscribeInfoLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.flAvtivityDiscribeInfoLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
        self.flAvtivityDisCribeLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
        
        self.flAvtivityDiscribeInfoLabel.textAlignment = NSTextAlignmentRight;
      
 
        
        
        [self makeConstraintsWithView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)makeConstraintsWithView
{
    
    [self.flAvtivityDisCribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(15);
        make.width.mas_equalTo(100);
        
    }];
    [self.flAvtivityDiscribeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-30);
        make.left.equalTo(self.flAvtivityDisCribeLabel.mas_right).with.offset(5);
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}


@end












