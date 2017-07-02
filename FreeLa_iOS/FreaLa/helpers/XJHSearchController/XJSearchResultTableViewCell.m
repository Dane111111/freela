//
//  XJSearchResultTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/5/5.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJSearchResultTableViewCell.h"

@implementation XJSearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.xjThumbnailImageView.layer.cornerRadius = 6;
    self.xjThumbnailImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setXjModel:(XJSearchResultModel *)xjModel {
    self.xjTopicThemeLabel.text = xjModel.topicTheme;
    [self.xjThumbnailImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:xjModel.thumbnail isSite:NO]]]];
}

@end
