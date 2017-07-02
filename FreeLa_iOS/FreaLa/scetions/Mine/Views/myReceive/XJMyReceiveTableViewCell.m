//
//  XJMyReceiveTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/5/17.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJMyReceiveTableViewCell.h"
#import "FLSquareTools.h"
@interface XJMyReceiveTableViewCell()

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

@implementation XJMyReceiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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

- (void)setFlMyReceiveListModel:(FLMyReceiveListModel *)flMyReceiveListModel {
    _flMyReceiveListModel = flMyReceiveListModel;
    [self setDataInMyIssueTableViewCellWithIndex:2]; //1为我领取 的
}

- (void)setXjMyPartInInfoModel:(XJMyPartInInfoModel *)xjMyPartInInfoModel {
    _xjMyPartInInfoModel = xjMyPartInInfoModel;
    [self setDataWithPartInModel:xjMyPartInInfoModel]; //我参与的
}

- (void)setDataInMyIssueTableViewCellWithIndex:(NSInteger)index {
    
    
    [self.xjHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flMyReceiveListModel.flMineIssueBackGroundImageStr isSite:NO]]]];
    self.xjHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    //    self.fldateDay.text   = _flMyReceiveListModel.flMineIssueDayStr;
    if (_flMyReceiveListModel.flTimeEnd.length > 11) {
        self.xjDateStr.text =  [_flMyReceiveListModel.xjinvalidTime substringToIndex:10];  //有效期
    } else {
        
    }
    
    self.xjTopicThemLabel.text = _flMyReceiveListModel.flMineTopicThemStr;
    self.xjStateStr.text = [self selftoolsReturnStateWithBool:NO]; //no 为我领取的
    self.xjTopicConditionLabel.text = [FLSquareTools xjReturnTypeStrWithStr:_flMyReceiveListModel.xjTopicType];
    self.xjTopicTypeLabel.text = _flMyReceiveListModel.xjTopicTagStr;
    self.xjBusNameStr.text = _flMyReceiveListModel.xjPublishName;
    self.xjTopicPublishType.text = [FLSquareTools returnConditionStrValueWithKey:_flMyReceiveListModel.flMineIssueTopicConditionStr];
    self.xjPubsherType.text =  [_flMyReceiveListModel.xjPublisherType isEqualToString:FLFLXJUserTypePersonStrKey] ? @"个人 : " :@"商家 : ";
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

- (NSString*)selftoolsReturnStateWithBool:(BOOL)flIsIssue {
    NSString* flstr = nil;
    
    
    NSInteger fl = _flMyReceiveListModel.flStateInt;
    //        NSInteger flAlready = _flMyReceiveListModel.flMineIssueNumbersAlreadyPickStr.integerValue;
    //        NSInteger flTotal   = _flMyReceiveListModel.flMineIssueNumbersTotalPickStr.integerValue;
    if (fl == 1) {
        flstr = @"已使用";
        self.xjStateStr.hidden = YES;
        self.xjStateImageView.hidden = NO;
    }  else if (fl == 0) {
        flstr = @"未使用";
        self.xjStateStr.hidden = NO;
        self.xjStateImageView.hidden = YES;
    }
    
    return flstr;
}

@end







