//
//  FLMyIssueTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/12/14.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLMyIssueTableViewCell.h"

#define flMiddle_width  8
#define flHalf_middle_width flMiddle_width /2
#define fl_Date_Day_Size 16
#define fl_Date_Month_Size 8
#define fl_Top_Margin     10
#define fl_DetailImage_Margin_Bottom 90
#define fl_Middle_Margin_btns  FLUISCREENBOUNDS.width / 10

@interface FLMyIssueTableViewCell()

/**灰色的竖线*/
@property (nonatomic , strong)UIView* flverticalLine;
/**灰色的竖线中间的红点*/
@property (nonatomic , strong)UIView* flMiddleRedView;

/**baseview*/
@property (nonatomic , strong)UIImageView* flbaseImageView;
/**btn baseview*/
@property (nonatomic , strong)UIView* flBtnBaseView;
/**阅读数logo*/
@property (nonatomic , strong)UIImageView* flReadNumberBtn;
/**评论数logo*/
@property (nonatomic , strong)UIImageView* flJudgeNumberBtn;
/**转发数logo*/
@property (nonatomic , strong)UIImageView* flRelayNumberBtn;
/**领取进度logo*/
@property (nonatomic , strong)UIImageView* flPickNumberBtn;

/**短的细线*/
@property (nonatomic , strong)UIView* flVerticalShortLine;

/***********************************************************/

/**middle view*/
@property (nonatomic , strong)UIView* flMiddleView;
/**主题*/
@property (nonatomic , strong)UILabel* flTopicThemLabel;
/**中间的横线*/
@property (nonatomic , strong)UIView* flMiddleLineView;
/**状态图标*/
@property (nonatomic , strong)UIImageView* flStateLogoImage;
/**状态*/
@property (nonatomic , strong)UILabel* flStateLabel;


@end

@implementation FLMyIssueTableViewCell

- (void)awakeFromNib{
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        [self allocInIssueCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
    }
    return self;
}

- (void)setDataInMyIssueTableViewCellWithIndex:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            [self.fldetailImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flMyIssueInMineModel.flMineIssueBackGroundImageStr isSite:NO]]]];
            
            self.fldetailImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.fldateDay.text   = _flMyIssueInMineModel.flMineIssueDayStr;
            self.fldateMonth.text = _flMyIssueInMineModel.flMineIssueMonthStr;
            self.flProgressLabel.text = [NSString stringWithFormat:@"%@/%@",_flMyIssueInMineModel.flMineIssueNumbersAlreadyPickStr,_flMyIssueInMineModel.flMineIssueNumbersTotalPickStr ? _flMyIssueInMineModel.flMineIssueNumbersTotalPickStr :@"服务器没有返回"];
            self.flReadNumberLabel.text = _flMyIssueInMineModel.flMineIssueNumbersReadStr;
            self.flRelayNumberLabel.text = _flMyIssueInMineModel.flMineIssueNumbersRelayStr;
            [self.flProgressView setProgress:[_flMyIssueInMineModel.flfloatNumberStr floatValue]];
            self.flJudgeNumberLabel.text = _flMyIssueInMineModel.flMineIssueNumbersJudgeStr;
            self.flTopicThemLabel.text = _flMyIssueInMineModel.flMineTopicThemStr;
            self.flStateLabel.text = [self selftoolsReturnStateWithBool:YES]; //yes 为我发布的
            
        }
            break;
        case 2:
        {
            [self.fldetailImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flMyReceiveListModel.flMineIssueBackGroundImageStr isSite:NO]]]];
            self.fldetailImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.fldateDay.text   = _flMyReceiveListModel.flMineIssueDayStr;
            self.fldateMonth.text = _flMyReceiveListModel.flMineIssueMonthStr;
            self.flProgressLabel.text = [NSString stringWithFormat:@"%@/%@",_flMyReceiveListModel.flMineIssueNumbersAlreadyPickStr,_flMyReceiveListModel.flMineIssueNumbersTotalPickStr];
            self.flReadNumberLabel.text = _flMyReceiveListModel.flMineIssueNumbersReadStr;
            self.flRelayNumberLabel.text = _flMyReceiveListModel.flMineIssueNumbersRelayStr;
            [self.flProgressView setProgress:[_flMyReceiveListModel.flfloatNumberStr floatValue]];
            self.flJudgeNumberLabel.text = _flMyReceiveListModel.flMineIssueNumbersJudgeStr ? _flMyReceiveListModel.flMineIssueNumbersJudgeStr:@"0";
            self.flTopicThemLabel.text = _flMyReceiveListModel.flMineTopicThemStr;
            self.flStateLabel.text = [self selftoolsReturnStateWithBool:NO]; //no 为我领取的
        }
            break;
        case 3:
        {
            [self.fldetailImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_xjMyPartInInfoModel.flMineIssueBackGroundImageStr isSite:NO]]]];
            self.fldetailImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.fldateDay.text   = _xjMyPartInInfoModel.flMineIssueDayStr;
            self.fldateMonth.text = _xjMyPartInInfoModel.flMineIssueMonthStr;
            self.flProgressLabel.text = [NSString stringWithFormat:@"%@/%@",_xjMyPartInInfoModel.flMineIssueNumbersAlreadyPickStr,_xjMyPartInInfoModel.flMineIssueNumbersTotalPickStr ? _xjMyPartInInfoModel.flMineIssueNumbersTotalPickStr  : @"服务器没有返回"];
            self.flReadNumberLabel.text = _xjMyPartInInfoModel.flMineIssueNumbersReadStr;
            self.flRelayNumberLabel.text = _xjMyPartInInfoModel.flMineIssueNumbersRelayStr;
            [self.flProgressView setProgress:[_xjMyPartInInfoModel.flfloatNumberStr floatValue]];
            self.flJudgeNumberLabel.text = _xjMyPartInInfoModel.flMineIssueNumbersJudgeStr ? _xjMyPartInInfoModel.flMineIssueNumbersJudgeStr:@"0";
            self.flTopicThemLabel.text = _xjMyPartInInfoModel.flMineTopicThemStr;
        }
            break;
        default:
            break;
    }
    
}

- (NSString*)selftoolsReturnStateWithBool:(BOOL)flIsIssue
{
    NSString* flstr = nil;
    
    if (flIsIssue) {
        NSInteger fl = _flMyIssueInMineModel.flStateInt; //0是草稿 1是发布 2是撤回
        NSInteger flAlready = _flMyIssueInMineModel.flMineIssueNumbersAlreadyPickStr.integerValue;
        NSInteger flTotal   = _flMyIssueInMineModel.flMineIssueNumbersTotalPickStr.integerValue;
        if (flAlready && flAlready == flTotal) {
            flstr = @"已抢光";
        } else {
            if (fl == 1) {
                flstr = @"已发布";
            } else if (fl == 2) {
                flstr = @"已撤回";
            }else if (fl == 0) {
                flstr = @"草稿";
            }
        }
    } else {
        NSInteger fl = _flMyReceiveListModel.flStateInt;
        //        NSInteger flAlready = _flMyReceiveListModel.flMineIssueNumbersAlreadyPickStr.integerValue;
        //        NSInteger flTotal   = _flMyReceiveListModel.flMineIssueNumbersTotalPickStr.integerValue;
        if (fl == 1) {
            flstr = @"已使用";
        }  else if (fl == 0) {
            flstr = @"未使用";
        }
    }
    
    return flstr;
}

//重写model 的set方法


- (void)setFlMyIssueInMineModel:(FLMyIssueInMineModel *)flMyIssueInMineModel
{
    _flMyIssueInMineModel = flMyIssueInMineModel;
    [self setDataInMyIssueTableViewCellWithIndex:1]; //1为我发布 的
}

- (void)setFlMyReceiveListModel:(FLMyReceiveListModel *)flMyReceiveListModel
{
    _flMyReceiveListModel = flMyReceiveListModel;
    [self setDataInMyIssueTableViewCellWithIndex:2]; //1为我领取 的
}

- (void)setXjMyPartInInfoModel:(XJMyPartInInfoModel *)xjMyPartInInfoModel
{
    _xjMyPartInInfoModel = xjMyPartInInfoModel;
    [self setDataInMyIssueTableViewCellWithIndex:3]; //3为我参与 的
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
}

- (void)allocInIssueCell
{
    self.flverticalLine  = [[UIView alloc] init];
    self.flMiddleRedView = [[UIView alloc] init];
    self.fldateDay       = [[UILabel alloc] init];
    self.fldateMonth     = [[UILabel  alloc] init];
    self.flbaseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_issue_baseimage"]];
    self.fldetailImageView = [[UIImageView alloc] init];
    //阅读数等view
    self.flBtnBaseView = [[UIView alloc] init];
    //    self.flBtnBaseView.backgroundColor = [UIColor redColor];
    
    
    self.flReadNumberBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont_yuedushu_issue"]];
    self.flRelayNumberBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont_fenxiang_issue"]];
    self.flJudgeNumberBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont_pinglunshu_issue"]];
    self.flPickNumberBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont_gouwu_issue"]];
    self.flReadNumberLabel = [[UILabel alloc] init];
    self.flRelayNumberLabel = [[UILabel alloc] init];
    self.flJudgeNumberLabel = [[UILabel alloc] init];
    self.flProgressLabel  = [[UILabel alloc] init];
    
    self.flVerticalShortLine = [[UIView alloc] init];
    
    //进度条
    self.flProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    
    //主题 分割线 状态
    self.flMiddleView = [[UIView alloc] init];
    self.flTopicThemLabel = [[UILabel alloc] init];
    self.flMiddleLineView = [[UIView alloc] init];
    self.flStateLogoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_myissue_gray"]];
    self.flStateLabel = [[UILabel alloc] init];
    
    
    //add
    [self addSubview:self.flverticalLine];
    [self addSubview:self.flMiddleRedView];
    [self addSubview:self.fldateDay];
    [self addSubview:self.fldateMonth];
    [self addSubview:self.flbaseImageView];
    [self addSubview:self.fldetailImageView];
    [self addSubview:self.flBtnBaseView];
    [self addSubview:self.flMiddleView];
    
    
    [self.flMiddleView addSubview:self.flTopicThemLabel];
    [self.flMiddleView addSubview:self.flStateLogoImage];
    [self.flMiddleView addSubview:self.flStateLabel];
    [self.flMiddleView addSubview:self.flMiddleLineView];
    
    
    [self.flBtnBaseView addSubview:self.flReadNumberBtn];
    [self.flBtnBaseView addSubview:self.flRelayNumberBtn];
    [self.flBtnBaseView addSubview:self.flJudgeNumberBtn];
    [self.flBtnBaseView addSubview:self.flReadNumberLabel];
    [self.flBtnBaseView addSubview:self.flRelayNumberLabel];
    [self.flBtnBaseView addSubview:self.flJudgeNumberLabel];
    [self.flBtnBaseView addSubview:self.flVerticalShortLine];
    [self.flBtnBaseView addSubview:self.flProgressLabel];
    [self.flBtnBaseView addSubview:self.flPickNumberBtn];
    [self.flBtnBaseView addSubview:self.flProgressView];
    
    [self setUpUIInMyIssueCell];
}

- (void)setUpUIInMyIssueCell
{
    
    self.flverticalLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    self.flMiddleRedView.layer.cornerRadius = flHalf_middle_width;
    self.flMiddleRedView.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    self.flMiddleRedView.layer.masksToBounds = YES;
    self.fldateDay.font = [UIFont fontWithName:FL_FONT_NAME size:fl_Date_Day_Size];
    self.fldateMonth.font = [UIFont fontWithName:FL_FONT_NAME size:fl_Date_Month_Size];
    self.fldetailImageView.layer.cornerRadius = 10;
    self.fldetailImageView.layer.masksToBounds = YES;
    
    self.flReadNumberLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    self.flReadNumberLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.flRelayNumberLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    self.flRelayNumberLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.flJudgeNumberLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    self.flJudgeNumberLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.flProgressLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    self.flProgressLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.flTopicThemLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    self.flTopicThemLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.flStateLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    self.flStateLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.flVerticalShortLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    self.flMiddleLineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    
    //test
    self.flReadNumberLabel.text = @"11201'";
    self.flJudgeNumberLabel.text = @"112'";
    self.flRelayNumberLabel.text = @"114s'";
    self.flProgressLabel.text  = @"12/31";
    
    self.flReadNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.flJudgeNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.flRelayNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.flProgressLabel.textAlignment = NSTextAlignmentRight;
    //进度条
    self.flProgressView.progressTintColor = XJ_COLORSTR(XJ_FCOLOR_REDFONT);
    self.flProgressView.trackTintColor = [UIColor grayColor];
    self.flProgressView.progress = 0.4;
    
    
    [self makeConstraintsInMyIssueCell];
    
    
}

- (void)makeConstraintsInMyIssueCell
{
    [self.fldateDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(fl_Top_Margin);
        make.left.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.fldateMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fldateDay.mas_bottom).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.flverticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self.fldateDay.mas_right).with.offset(1);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self).with.offset(0);
    }];
    [self.flMiddleRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fldateMonth).with.offset(0);
        make.centerX.equalTo(self.flverticalLine).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(flMiddle_width, flMiddle_width));
    }];
    [self.flbaseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(fl_Top_Margin);
        make.bottom.equalTo(self).with.offset(0);
        make.left.equalTo(self.flverticalLine).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(5);
    }];
    [self.fldetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flbaseImageView).with.offset(fl_Top_Margin);
        make.bottom.equalTo(self.flbaseImageView.mas_bottom).with.offset(-fl_DetailImage_Margin_Bottom);
        make.left.equalTo(self.flbaseImageView).with.offset(fl_Top_Margin * 3);
        make.right.equalTo(self.flbaseImageView.mas_right).with.offset(-fl_Top_Margin);
    }];
    
    //baseview middle
    [self.flMiddleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fldetailImageView.mas_bottom).with.offset(fl_Top_Margin);
        make.height.mas_equalTo(25);
        make.left.equalTo(self.fldetailImageView).with.offset(10);
        make.right.equalTo(self.flbaseImageView.mas_right).with.offset(-fl_Top_Margin);
    }];
    //title
    [self.flTopicThemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flMiddleView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 25));
        make.left.equalTo(self.flMiddleView).with.offset(0);
    }];
    //logo
    [self.flStateLogoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flMiddleView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(18, 20));
        make.right.equalTo(self.flStateLabel.mas_left).with.offset(-5);
    }];
    //状态
    [self.flStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flMiddleView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 25));
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    //中部line
    [self.flMiddleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flMiddleView).with.offset(24);
        make.left.equalTo(self.flMiddleView).with.offset(0);
        make.right.equalTo(self.flMiddleView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.flMiddleView.mas_bottom).with.offset(0);
    }];
    
    //baseview under
    [self.flBtnBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flMiddleView.mas_bottom).with.offset(fl_Top_Margin);
        make.bottom.equalTo(self.flbaseImageView.mas_bottom).with.offset(0);
        make.left.equalTo(self.fldetailImageView).with.offset(20);
        make.right.equalTo(self.flbaseImageView.mas_right).with.offset(-fl_Top_Margin);
    }];
    //阅读数
    [self.flReadNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flBtnBaseView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self.flBtnBaseView).with.offset(0);
    }];
    [self.flReadNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flReadNumberBtn.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(50, 16));
        make.centerX.equalTo(self.flReadNumberBtn).with.offset(0);
    }];
    //转发数
    [self.flRelayNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flReadNumberBtn).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self.flReadNumberBtn.mas_right).with.offset(fl_Middle_Margin_btns);
    }];
    [self.flRelayNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flReadNumberLabel).with.offset(0);
        make.size.equalTo(self.flReadNumberLabel).with.offset(0);
        make.centerX.equalTo(self.flRelayNumberBtn).with.offset(0);
    }];
    //评论数
    [self.flJudgeNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flReadNumberBtn).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self.flRelayNumberBtn.mas_right).with.offset(fl_Middle_Margin_btns);
    }];
    [self.flJudgeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flReadNumberLabel).with.offset(0);
        make.size.equalTo(self.flReadNumberLabel).with.offset(0);
        make.centerX.equalTo(self.flJudgeNumberBtn).with.offset(0);
    }];
    
    [self.flVerticalShortLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flReadNumberBtn).with.offset(0);
        make.left.equalTo(self.flJudgeNumberBtn.mas_right).with.offset(fl_Middle_Margin_btns / 2);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self).with.offset(-fl_Top_Margin);
    }];
    //领取进度
    [self.flPickNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flReadNumberBtn.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self.flVerticalShortLine.mas_right).with.offset(fl_Middle_Margin_btns / 2);
    }];
    
    [self.flProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flPickNumberBtn).with.offset(0);
        make.right.equalTo(self.flBtnBaseView.mas_right).with.offset(-fl_Top_Margin);
        make.left.equalTo(self.flPickNumberBtn.mas_right).with.offset(5);
        
    }];
    [self.flProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.bottom.equalTo(self.flProgressView).with.offset(0);
        make.width.equalTo(self.flProgressView).with.offset(0);
        make.right.equalTo(self.flProgressView.mas_right).with.offset(0);
        
    }];
    
    
}





@end















