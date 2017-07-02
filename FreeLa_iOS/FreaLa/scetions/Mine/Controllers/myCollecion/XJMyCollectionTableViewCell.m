//
//  XJMyCollectionTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/3/16.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJMyCollectionTableViewCell.h"

@implementation XJMyCollectionTableViewCell


- (void)awakeFromNib {
    self.xjImageView.layer.cornerRadius = 6;
    self.xjImageView.layer.masksToBounds = YES;
//    self.xjBtn.layer.cornerRadius = self.xjBtn.height / 2;
    self.xjBtn.layer.cornerRadius = 4 ;
    self.xjBtn.layer.masksToBounds= YES;
    self.xjBtn.layer.borderWidth = .5f;
    self.xjBtn.layer.borderColor = [UIColor redColor].CGColor;
//    self.xjTime.hidden = YES;
//    self.xjBtn.backgroundColor = [UIColor blackColor];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setXjModel:(XJMyCollectionInfoModel *)xjModel {
    _xjModel = xjModel;
    [self setInfoInXJCollectionCell];
}
- (void)setInfoInXJCollectionCell {
    self.xjTitle.text = _xjModel.topicTheme;
    self.xjTime.text  = _xjModel.createTime;
    [self.xjImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_xjModel.thumbnail isSite:NO]]]];
}
@end
