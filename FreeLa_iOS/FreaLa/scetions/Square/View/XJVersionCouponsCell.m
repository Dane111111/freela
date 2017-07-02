//
//  XJVersionCouponsCell.m
//  FreeLa
//
//  Created by Leon on 16/7/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJVersionCouponsCell.h"


@interface XJVersionCouponsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *xjHeaderImageView;

@property (weak, nonatomic) IBOutlet UILabel *xjTopicThemeLabel;

@property (weak, nonatomic) IBOutlet UILabel *xhTopicTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *xjTopicTypeView;

@property (weak, nonatomic) IBOutlet UILabel *xjTimeEndLabel;

@property (weak, nonatomic) IBOutlet UILabel *xjTopicConLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xjTopicConBacImageView;

@property (weak, nonatomic) IBOutlet UILabel *xjPublisherTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *xjPublisherLabel;


@end

@implementation XJVersionCouponsCell

- (void)awakeFromNib {
    [super awakeFromNib];
//     Initialization code
    self.xjWhiteBaseView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.xjTopicTypeView.layer.borderWidth = 1.f ;
    self.xjTopicTypeView.layer.borderColor = [UIColor colorWithHexString:@"f5a631"].CGColor;
    self.xjTopicTypeView.layer.cornerRadius = self.xjTopicTypeView.height / 2;
    self.xjTopicTypeView.layer.masksToBounds = YES;
    self.xhTopicTypeLabel.textColor = [UIColor colorWithHexString:@"f5a631"];
    
    self.xjHeaderImageView.layer.cornerRadius = 6;
    self.xjHeaderImageView.layer.masksToBounds = YES;
//    
//ng:@"f5a631"].CGColor;
//    self.xjTopicTypeView.layer.borderWidth = 0.5;
//    self.xjTopicTypeLabel.textColor = [UIColor colorWithHexString:@"f5a631"];
//    self.xjTopicConditionView.layer.cornerRadius = 10;
//    self.xjTopicConditionView.layer.masksToBounds = YES;
//    self.xjTopicConditionView.layer.borderColor = [UIColor colorWithHexString:@"72d0b4"].CGColor;
//    self.xjTopicConditionLabel.textColor = [UIColor colorWithHexString:@"72d0b4"];
//    self.xjTopicConditionView.layer.borderWidth = 0.5;
//    self.xjTopicPublishType.backgroundColor = [UIColor colorWithHexString:@"f06458"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setXjCellModel:(XJVersionTwoCouponsModel *)xjCellModel {
    [self.xjHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:xjCellModel.thumbnail isSite:NO]]]];
    
    self.xjTopicThemeLabel.text = xjCellModel.topicTheme;
    self.xjTimeEndLabel.text    = xjCellModel.endTime;
    if (xjCellModel.endTime.length >= 11) {
        NSString* xxxx = [xjCellModel.endTime substringToIndex:11];
        self.xjTimeEndLabel.text = xxxx;
    }
    if ([xjCellModel.userType isEqualToString:FLFLXJUserTypeCompStrKey]) {
        self.xjPublisherTypeLabel.text = @"商家:";
    } else {
        self.xjPublisherTypeLabel.text = @"个人:";
    }
    self.xjPublisherLabel.text = xjCellModel.nickName;
    self.xhTopicTypeLabel.text = xjCellModel.topicTag;
    if ([xjCellModel.topicConditionKey isEqualToString:FLFLXJSquareIssueNonePick]) {
        self.xjTopicConLabel.text = @"随心领";
        self.xjTopicConBacImageView.image = [UIImage imageNamed:@"zy_green_ticket"];
    } else if ([xjCellModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
        self.xjTopicConLabel.text = @"转发领";
        self.xjTopicConBacImageView.image = [UIImage imageNamed:@"zy_blue_ticket"];
    } else if ([xjCellModel.topicConditionKey isEqualToString:FLFLXJSquareIssueCarePick]) {
        self.xjTopicConLabel.text = @"关注领";
        self.xjTopicConBacImageView.image = [UIImage imageNamed:@"zy_orange_ticket"];
    } else if ([xjCellModel.topicConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
        self.xjTopicConLabel.text = @"助力抢";
        self.xjTopicConBacImageView.image = [UIImage imageNamed:@"zy_red_ticket"];
    }
    
}

@end
