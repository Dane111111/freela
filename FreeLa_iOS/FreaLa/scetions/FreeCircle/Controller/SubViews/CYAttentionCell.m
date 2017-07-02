//
//  CYAttentionCell.m
//  FreeLa
//
//  Created by cy on 16/1/8.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYAttentionCell.h"
#import <UIImageView+WebCache.h>

@interface CYAttentionCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView; // 头像
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView; // 主题图片
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel; // 昵称
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicThemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicTypeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *topicProgressView;

@property (weak, nonatomic) IBOutlet UILabel *xjTopicCondition;

@end

@implementation CYAttentionCell

- (void)awakeFromNib {
    self.avatarImageView.layer.cornerRadius =  self.avatarImageView.frame.size.width / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.descriptionLabel setHidden:YES];
    self.topicProgressView.hidden = YES;
    self.thumbnailImageView.layer.cornerRadius = 6;
    self.thumbnailImageView.layer.masksToBounds = YES;
    
//    self.topicTypeLabel.layer.cornerRadius = self.topicTypeLabel.height/2;
//    self.topicTypeLabel.layer.masksToBounds = YES;
//    self.topicTypeLabel.layer.borderWidth = .5f;
    
    self.xjTopicCondition.layer.cornerRadius = self.xjTopicCondition.height/2;
    self.xjTopicCondition.layer.masksToBounds = YES;
    self.xjTopicCondition.layer.borderWidth = .5f;
    
}

- (void)setModel:(CYAttentionModel *)model{
    _model = model;
    
    //    给子控件赋值
    NSString *avatarPath = [XJFinalTool xjReturnImageURLWithStr:_model.avatar isSite:NO];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarPath]];
    
    NSString *thumbnailPath = [XJFinalTool xjReturnImageURLWithStr:_model.thumbnail isSite:NO];
    [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:thumbnailPath]];
    self.nickNameLabel.text = _model.nickName;
    self.createTimeLabel.text = _model.createTime;
    //    self.descriptionLabel.text = _model.DESCRIPTION;
    
    self.topicThemeLabel.text = _model.topicTheme;
    self.topicTimeLabel.text = [NSString stringWithFormat:@"活动时间：%@",[self returnTimeNeedWithBegan: _model.startTime  endTime:_model.endTime ]]; // 还没处理完
    if ([_model.topicType isEqualToString:FLFLXJSquarePersonStrKey]) {
        self.topicTypeLabel.text = FLFLXJSquarePersonStr;
    } else if ([_model.topicType isEqualToString:FLFLXJSquareAllFreeStrKey]) {
        self.topicTypeLabel.text = FLFLXJSquareAllFreeStr;
    } else if ([_model.topicType isEqualToString:FLFLXJSquareCouponseStrKey]) {
        self.topicTypeLabel.text = FLFLXJSquareCouponseStr;
    }
    
    if ([_model.topicCondition isEqualToString:FLFLXJSquareIssueHelpPick]) {
        self.xjTopicCondition.text = FLFLXJSquareIssueHelpPickVlaue;
    } else if ([_model.topicCondition isEqualToString:FLFLXJSquareIssueCarePick]) {
        self.xjTopicCondition.text = FLFLXJSquareIssueCarePickVlaue;
    } else if ([_model.topicCondition isEqualToString:FLFLXJSquareIssueRelayPick]) {
        self.xjTopicCondition.text = FLFLXJSquareIssueRelayPickVlaue;
    } else if ([_model.topicCondition isEqualToString:FLFLXJSquareIssueNonePick]) {
        self.xjTopicCondition.text = FLFLXJSquareIssueNonePickVlaue;
    }
    
    
    //    self.topicProgressView
}
- (NSString*)returnTimeNeedWithBegan:(NSString*)timeB endTime:(NSString*)timeE {
    NSString* str = nil;
    FL_Log(@"timeb.length =%lu",(unsigned long)timeB.length);
    NSString* timeBA = [timeB substringWithRange:NSMakeRange(0, 4)];
    NSString* timeBO = [timeB substringWithRange:NSMakeRange(5,2)];
    NSString* timeBS = [timeB substringWithRange:NSMakeRange(8, 2)];
    NSString* timeBT = [timeB substringWithRange:NSMakeRange(10, 6)];
    timeB = [NSString stringWithFormat:@"%@/%@/%@ %@",timeBA,timeBO,timeBS,timeBT];
    FL_Log(@"timeb = %@",timeB);
    FL_Log(@"timeb.length =%lu",(unsigned long)timeB.length);
    NSString* timeEA = [timeB substringWithRange:NSMakeRange(0, 4)];
    NSString* timeEO = [timeE  substringWithRange:NSMakeRange(5,2)];
    NSString* timeES = [timeE  substringWithRange:NSMakeRange(8, 2)];
    NSString* timeET = [timeE  substringWithRange:NSMakeRange(10, 6)];
    timeE = [NSString stringWithFormat:@"%@/%@/%@ %@",timeEA,timeEO,timeES,timeET];
    FL_Log(@"timeb = %@",timeE);
    str = [NSString stringWithFormat:@"%@-%@",timeB ,timeE];
    
    return str;
}

@end
