//
//  XJMyPartInViewCell.m
//  FreeLa
//
//  Created by Leon on 16/7/10.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJMyPartInViewCell.h"
@interface XJMyPartInViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *xjHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *xjTopicThemLabel;
@property (weak, nonatomic) IBOutlet UILabel *xjStateStr;
@property (weak, nonatomic) IBOutlet UILabel *xjDateStr;
@property (weak, nonatomic) IBOutlet UILabel *xjBusNameStr;
@property (weak, nonatomic) IBOutlet UIView *xjTopicConditionView;
@property (weak, nonatomic) IBOutlet UILabel *xjTopicConditionLabel;
@property (weak, nonatomic) IBOutlet UIView *xjTopicTypeView;
@property (weak, nonatomic) IBOutlet UILabel *xjTopicTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xjStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *xjTopicPublishType;//随心领

@property (weak, nonatomic) IBOutlet UILabel *xjPubsherType; //发布者类型 个人&商家
@property (weak, nonatomic) IBOutlet UIView *xjBottomBaseView;
@end

@implementation XJMyPartInViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.xjTopicTypeView.layer.cornerRadius = 10;
    self.xjHeaderImageView.layer.cornerRadius = 5;
    self.xjHeaderImageView.layer.masksToBounds = YES;
    self.xjTopicTypeView.layer.masksToBounds = YES;
    self.xjTopicTypeView.layer.borderColor = [UIColor colorWithHexString:@"f5a631"].CGColor;
    self.xjTopicTypeView.layer.borderWidth = 0.5;
    self.xjTopicTypeLabel.textColor = [UIColor colorWithHexString:@"f5a631"];
    self.xjTopicConditionView.layer.cornerRadius = 10;
    self.xjTopicConditionView.layer.masksToBounds = YES;
    self.xjTopicConditionView.layer.borderColor = [UIColor colorWithHexString:@"72d0b4"].CGColor;
    self.xjTopicConditionLabel.textColor = [UIColor colorWithHexString:@"72d0b4"];
    self.xjTopicConditionView.layer.borderWidth = 0.5;
    self.xjTopicPublishType.backgroundColor = [UIColor colorWithHexString:@"f06458"];
    self.xjBottomBaseView.layer.cornerRadius = 6;
    self.xjBottomBaseView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setXjMyPartInInfoModel:(XJMyPartInInfoModel *)xjMyPartInInfoModel {
    _xjMyPartInInfoModel = xjMyPartInInfoModel;
    [self setDataWithPartInModel:xjMyPartInInfoModel]; //我参与的
}
- (void)setDataWithPartInModel:(XJMyPartInInfoModel*)xjModel {
    [self.xjHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_xjMyPartInInfoModel.flMineIssueBackGroundImageStr isSite:NO]]]];
    self.xjHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.xjDateStr.text   = _xjMyPartInInfoModel.flTimeBegan;
    //    self.fldateMonth.text = _xjMyPartInInfoModel.flMineIssueMonthStr;
    //    self.flProgressLabel.text = [NSString stringWithFormat:@"%@/%@",_xjMyPartInInfoModel.flMineIssueNumbersAlreadyPickStr,_xjMyPartInInfoModel.flMineIssueNumbersTotalPickStr ? _xjMyPartInInfoModel.flMineIssueNumbersTotalPickStr  : @"服务器没有返回"];
    //    self.flReadNumberLabel.text = _xjMyPartInInfoModel.flMineIssueNumbersReadStr;
    //    self.flRelayNumberLabel.text = _xjMyPartInInfoModel.flMineIssueNumbersRelayStr;
    //    [self.flProgressView setProgress:[_xjMyPartInInfoModel.flfloatNumberStr floatValue]];
    //    self.flJudgeNumberLabel.text = _xjMyPartInInfoModel.flMineIssueNumbersJudgeStr ? _xjMyPartInInfoModel.flMineIssueNumbersJudgeStr:@"0";
    self.xjTopicThemLabel.text = _xjMyPartInInfoModel.flMineTopicThemStr;
    
}

@end



