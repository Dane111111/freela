//
//  XJMyIssueTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/5/17.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJMyIssueTableViewCell.h"

@interface XJMyIssueTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *xjHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *xjTopicThemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *xjDayYear;
@property (weak, nonatomic) IBOutlet UILabel *xjDayMonth;
@property (weak, nonatomic) IBOutlet UILabel *xjProgressFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *xjProgressSecondLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *xjProgressView;
@property (weak, nonatomic) IBOutlet UILabel *xjState;
@property (weak, nonatomic) IBOutlet UIImageView *xjImageViewRead;
@property (weak, nonatomic) IBOutlet UIImageView *xjImageViewRelay;
@property (weak, nonatomic) IBOutlet UIImageView *xjImageViewJudge;
@property (weak, nonatomic) IBOutlet UILabel *xjLabelRead;
@property (weak, nonatomic) IBOutlet UILabel *xjLabelRelay;
@property (weak, nonatomic) IBOutlet UILabel *xjLabelJudge;
@property (weak, nonatomic) IBOutlet UIView *xjTopicTypeView;
@property (weak, nonatomic) IBOutlet UILabel *xjTopicTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *xjBottomBaseVIew;

@end



@implementation XJMyIssueTableViewCell

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
    [self.xjDayYear setHidden:YES];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.xjBottomBaseVIew.layer.cornerRadius = 4;
    self.xjBottomBaseVIew.layer.masksToBounds = YES;
    self.xjProgressView.layer.cornerRadius = XJ_PROGRESS_H / 2;
    self.xjProgressView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//重写model 的set方法


- (void)setFlMyIssueInMineModel:(FLMyIssueInMineModel *)flMyIssueInMineModel {
    _flMyIssueInMineModel = flMyIssueInMineModel;
    [self setDataInMyIssueTableViewCellWithIndex:1]; //1为我发布 的
}

- (void)setXjMyPartInInfoModel:(XJMyPartInInfoModel *)xjMyPartInInfoModel {
    _xjMyPartInInfoModel = xjMyPartInInfoModel;
    [self setDataInMyIssueTableViewCellWithIndex:3]; //4为 我参与 的
}

- (void)setDataInMyIssueTableViewCellWithIndex:(NSInteger)index {
    switch (index) {
        case 1:  {
            
            [self.xjHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flMyIssueInMineModel.flMineIssueBackGroundImageStr isSite:NO]]]];
            self.xjHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.xjDayMonth.text   = [NSString stringWithFormat:@"%@%@日",_flMyIssueInMineModel.flMineIssueMonthStr,_flMyIssueInMineModel.flMineIssueDayStr];
            //            self.xjDayYear.text = [NSString stringWithFormat:@"%@%@",_flMyIssueInMineModel.flMineIssueMonthStr,_flMyIssueInMineModel.flMineIssueDayStr];
            self.xjProgressFirstLabel.text = _flMyIssueInMineModel.flMineIssueNumbersAlreadyPickStr;
            self.xjProgressSecondLabel.text = [NSString stringWithFormat:@"/ %@",_flMyIssueInMineModel.flMineIssueNumbersTotalPickStr];
            self.xjLabelRead.text =  [FLTool xjSetNumberByStr:_flMyIssueInMineModel.flMineIssueNumbersReadStr];
            self.xjLabelRelay.text = [FLTool xjSetNumberByStr:_flMyIssueInMineModel.flMineIssueNumbersRelayStr];
            [self.xjProgressView setProgress:[_flMyIssueInMineModel.flfloatNumberStr floatValue]];
            self.xjLabelJudge.text = [FLTool xjSetNumberByStr:_flMyIssueInMineModel.flMineIssueNumbersJudgeStr];
            self.xjTopicThemeLabel.text = _flMyIssueInMineModel.flMineTopicThemStr;
            self.xjState.text = [self selftoolsReturnStateWithBool:YES]; //yes 为我发布的
            self.xjTopicTypeLabel.text = _flMyIssueInMineModel.xjTopicTagStr;
            
        }
            break;
            //        case 2: {
            //            [self.fldetailImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FLBaseUrl,_flMyReceiveListModel.flMineIssueBackGroundImageStr]]];
            //            self.fldetailImageView.contentMode = UIViewContentModeScaleAspectFill;
            //            self.fldateDay.text   = _flMyReceiveListModel.flMineIssueDayStr;
            //            self.fldateMonth.text = _flMyReceiveListModel.flMineIssueMonthStr;
            //            self.flProgressLabel.text = [NSString stringWithFormat:@"%@/%@",_flMyReceiveListModel.flMineIssueNumbersAlreadyPickStr,_flMyReceiveListModel.flMineIssueNumbersTotalPickStr];
            //            self.flReadNumberLabel.text = _flMyReceiveListModel.flMineIssueNumbersReadStr;
            //            self.flRelayNumberLabel.text = _flMyReceiveListModel.flMineIssueNumbersRelayStr;
            //            [self.flProgressView setProgress:[_flMyReceiveListModel.flfloatNumberStr floatValue]];
            //            self.flJudgeNumberLabel.text = _flMyReceiveListModel.flMineIssueNumbersJudgeStr ? _flMyReceiveListModel.flMineIssueNumbersJudgeStr:@"0";
            //            self.flTopicThemLabel.text = _flMyReceiveListModel.flMineTopicThemStr;
            //            self.flStateLabel.text = [self selftoolsReturnStateWithBool:NO]; //no 为我领取的
            //        }
            //            break;
                    case 3:  {
                        [self.xjHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_xjMyPartInInfoModel.flMineIssueBackGroundImageStr isSite:NO]]]];
                        self.xjHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
//                        self.xjDayYear.text   = _xjMyPartInInfoModel.flMineIssueDayStr;
                        self.xjDayMonth.text = [NSString stringWithFormat:@"%@%@日",_xjMyPartInInfoModel.flMineIssueMonthStr,_xjMyPartInInfoModel.flMineIssueDayStr];//_xjMyPartInInfoModel.flMineIssueMonthStr;
                        self.xjProgressFirstLabel.text = [NSString stringWithFormat:@"%@",_xjMyPartInInfoModel.flMineIssueNumbersAlreadyPickStr];
                        self.xjProgressSecondLabel.text =[NSString stringWithFormat:@"/%@",_xjMyPartInInfoModel.flMineIssueNumbersTotalPickStr];
                        self.xjLabelRead.text = _xjMyPartInInfoModel.flMineIssueNumbersReadStr;
                        self.xjLabelRelay.text = _xjMyPartInInfoModel.flMineIssueNumbersRelayStr;
                        [self.xjProgressView setProgress:[_xjMyPartInInfoModel.flfloatNumberStr floatValue]];
                        self.xjLabelJudge.text = _xjMyPartInInfoModel.flMineIssueNumbersJudgeStr ? _xjMyPartInInfoModel.flMineIssueNumbersJudgeStr:@"0";
                        self.xjTopicThemeLabel.text = _xjMyPartInInfoModel.flMineTopicThemStr;
                        self.xjState.text = [self xjStateWithMyPartinState:_xjMyPartInInfoModel.xjState entime:_xjMyPartInInfoModel.flTimeEnd];//_xjMyPartInInfoModel.flMineTopicThemStr;
                    }
                        break;
        default:
            break;
    }
    
}

- (NSString*)selftoolsReturnStateWithBool:(BOOL)flIsIssue {
    NSString* flstr = nil ;
    if (flIsIssue) {
        NSInteger fl = _flMyIssueInMineModel.flStateInt; //0是草稿 1是发布 2是撤回
        //        NSInteger flAlready = _flMyIssueInMineModel.flMineIssueNumbersAlreadyPickStr.integerValue;
        //        NSInteger flTotal   = _flMyIssueInMineModel.flMineIssueNumbersTotalPickStr.integerValue;
        //        if (flAlready && flAlready == flTotal) {
        //            flstr = @"抢光了";
        //        } else {
        if (fl == 1) {
            if ([FLTool returnBoolNumberWithCreatTime:_flMyIssueInMineModel.flTimeEnd xjxjTime:nil]) {
                flstr = @"进行中";
            } else {
                flstr = @"已结束";
            }
            if ([FLTool returnBoolNumberWithCreatTime:_flMyIssueInMineModel.flTimeBegan xjxjTime:nil]) {
                flstr = @"未开始";
            }
        } else if (fl == 2) {
            flstr = @"已撤回";
        } else if (fl == 3) {
            flstr = @"已屏蔽";
        } else if (fl == 4) {
            flstr = @"已抢光";
        }else if (fl == 0) {
            flstr = @"草稿";
        }
        //        }
    }
    return flstr;
}
- (NSString*)xjStateWithMyPartinState:(NSInteger)xjState entime:(NSString*)xjEndTime {
    NSString* flstr = nil ;
    
        NSInteger fl = _xjMyPartInInfoModel.xjState;
        if (fl == 1) {
            if ([FLTool returnBoolNumberWithCreatTime:_xjMyPartInInfoModel.flTimeEnd xjxjTime:nil]) {
                flstr = @"进行中";
            } else {
                flstr = @"已结束";
            }
            if ([FLTool returnBoolNumberWithCreatTime:_xjMyPartInInfoModel.flTimeBegan xjxjTime:nil]) {
                flstr = @"未开始";
            }
        } else if (fl == 2) {
            flstr = @"已撤回";
        } else if (fl == 3) {
            flstr = @"已屏蔽";
        } else if (fl == 4) {
            flstr = @"已抢光";
        }else if (fl == 0) {
            flstr = @"草稿";
        }
    return flstr;

}

@end











