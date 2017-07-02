//
//  FLMyIssueJudgePLTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/1/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyIssueJudgePLTableViewCell.h"

@implementation FLMyIssueJudgePLTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.flAvatar.layer.cornerRadius =  self.flAvatar.frame.size.width / 2;
    self.flAvatar.layer.masksToBounds = YES;
}

- (void)setFlmodel:(FLMyIssueJudgePlModel *)flmodel
{
    _flmodel = flmodel;
    NSURL* imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flmodel.avatar isSite:NO]]];
    [self.flAvatar sd_setBackgroundImageWithURL:imageURL forState:UIControlStateNormal];
    self.flcontentStr.text = _flmodel.content;
    self.flnickName.text   = _flmodel.nickname;
    self.fltimeStr.text    = _flmodel.createTime;
     self.xjReplaysLabel.text = [NSString stringWithFormat:@"%ld",flmodel.replies];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
