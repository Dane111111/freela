//
//  FLMyCustomTableViewCell.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/19.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLMyCustomTableViewCell.h"
//#define FLNameFont

@interface FLMyCustomTableViewCell ()

@end


static NSInteger _flstate,_flmyAuroraLabel; //状态、身份
@implementation FLMyCustomTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    //    FL_Log(@"dddddddddddddddddin my cus tomtable view cell");
    self.myAuroraLabel.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //    self.myChoiceImageView.hidden = !selected;
    
}

- (void)setFlMyBusAccountListModel:(FLMyBusAccountListModel *)flMyBusAccountListModel
{
    _flMyBusAccountListModel = flMyBusAccountListModel;
    [self settingData];
}

- (void)settingData
{
    
    self.myNameLabel.text =  _flMyBusAccountListModel.shortName ;
    self.myAccountNumberLabel.text =  _flMyBusAccountListModel.email;
    self.myPortraitImageView.layer.borderColor=DE_headerBorderColor.CGColor;
    self.myPortraitImageView.layer.borderWidth=DE_headerBorderWidth;

    [self.myPortraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flMyBusAccountListModel.avatar isSite:NO]]]placeholderImage:[UIImage imageNamed:@"xj_default_avator"]];
    _flstate = _flMyBusAccountListModel.auditStatus;  //0：待提交审核 1:审批中2：正常3：审批拒绝
    switch (_flstate) {
        case  0:
            self.myStatusLabel.text = @"待提交审核";
            break;
        case  1:
            self.myStatusLabel.text = @"审批中";
            break;
        case  2:
            self.myStatusLabel.text = @"正常";
            break;
        case  3:
            self.myStatusLabel.text = @"审批拒绝";
            break;
            
        default:
            break;
    }
    _flmyAuroraLabel = _flMyBusAccountListModel.authorizationRole;
    switch (_flmyAuroraLabel) {
        case 1:
        {
            self.myAuroraLabel.text = @"运营者";
            self.myAuroraLabel.backgroundColor = [UIColor colorWithHexString:@"#7AE2B5"];
        }
            break;
        case 2:
        {
            self.myAuroraLabel.text = @"管理员";
            self.myAuroraLabel.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
        }
            break;
            
        default:
            break;
    }
    
    if (!FLFLIsPersonalAccountType) {
        if ([FLFLXJBusinessUserID isEqualToString:self.flMyBusAccountListModel.userId]) {
            self.myChoiceImageView.hidden = NO;
            FL_Log(@"应该只有这一个cell 啊");
        } else {
            self.myChoiceImageView.hidden = YES;
        }
    } else {
        
        self.myChoiceImageView.hidden = YES;
    }
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.myStatusLabel.layer.cornerRadius = 8;
    self.myAuroraLabel.layer.cornerRadius = 8;
    self.myPortraitImageView.layer.cornerRadius = 35;
    
    self.myAuroraLabel.layer.masksToBounds = YES;
    self.myStatusLabel.layer.masksToBounds = YES;
    self.myPortraitImageView.layer.masksToBounds = YES;
}



@end










