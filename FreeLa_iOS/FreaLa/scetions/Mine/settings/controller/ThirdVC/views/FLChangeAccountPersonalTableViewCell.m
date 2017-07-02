//
//  FLChangeAccountPersonalTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/2/4.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLChangeAccountPersonalTableViewCell.h"

@implementation FLChangeAccountPersonalTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setFluserInfoModel:(FLUserInfoModel *)fluserInfoModel {
    _fluserInfoModel = fluserInfoModel;
    if (fluserInfoModel) {
        [self settingData];
    }
    
}

- (void)settingData {
    self.myNameLabel.text =  _fluserInfoModel.flnickName ;
    self.myAccountNumberLabel.text =  [NSString  stringWithFormat:@"%@",_fluserInfoModel.flloginNumber];
    
    [self.myPortraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_fluserInfoModel.flavatar isSite:NO]]] placeholderImage:[UIImage imageNamed:@"xj_default_avator"]];
    
    if (FLFLIsPersonalAccountType) {
        self.myChoiceImageView.hidden = NO;
    } else {
        self.myChoiceImageView.hidden = YES;
    }
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.myPortraitImageView.layer.cornerRadius = 35;
    
    self.myPortraitImageView.layer.masksToBounds = YES;
}



@end
