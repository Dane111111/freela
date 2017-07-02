//
//  XJMainJudgeTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/3/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJMainJudgeTableViewCell.h"

@implementation XJMainJudgeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.xjHeaderIage.layer.cornerRadius = 22;
    self.xjHeaderIage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setXjPLModel:(FLMyIssueJudgePlModel *)xjPLModel {
    _xjPLModel = xjPLModel;
    [self setInfoInMainJudgeCell];
}

- (void)setInfoInMainJudgeCell {
    self.xjname.text = _xjPLModel.nickname;
    self.xjcontent.text = _xjPLModel.content;
    NSString* header = [XJFinalTool xjReturnImageURLWithStr:_xjPLModel.avatar isSite:NO];
    [self.xjHeaderIage sd_setImageWithURL:[NSURL URLWithString:header]];
    self.xjCreatTimeLabel.text = _xjPLModel.createTime;
}
@end
