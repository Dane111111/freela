//
//  FLMyIssueJudgePJTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/1/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyIssueJudgePJTableViewCell.h"
#import "FLStartChoiceView.h"
#import "FLCellImageView.h"

#define view_left_Margin        25
#define view_middle_Margin      10
#define view_header_width_H     60
#define view_top_Margin         10


#define label_size_font_M       12
#define label_size_font_S       10
#define startView_size_H        15
#define startView_size_W        80

#define fl_image_size_W         ((FLUISCREENBOUNDS.width - 2 * view_left_Margin - 2 * view_middle_Margin) / 3)

#define view_total_H      view_header_width_H + label_size_font_S +  view_top_Margin * 5 + _flListImageCount * fl_image_size_W

@interface FLMyIssueJudgePJTableViewCell()
{
    NSInteger _flListImageCount; //竖排image 个数
    CGFloat  _flExplainLabelH; //说明的高度
}
/**baseView*/
@property (nonatomic , strong) UIView* flbaseView;
/**头像*/
@property (nonatomic , strong) UIButton* flavatarBtn;
/**昵称*/
@property (nonatomic , strong) UILabel* flnickNameLabel;
/**时间*/
@property (nonatomic , strong) FLGrayLabel* fltimeLabel;
/**星星view*/
@property (nonatomic , strong) FLStartChoiceView* flstartView;
/**说明*/
@property (nonatomic , strong) FLGrayLabel* flExplainLabel;


@end
static CGRect baseViewFrame ,topViewFrame ,flimageViewFrame;

@implementation FLMyIssueJudgePJTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.frame = baseViewFrame;
        self.flbaseView = [[UIView alloc] init];  //报错删
        //        [self allocInIssueCellPJList];
    }
    return self;
}

- (void)setFlmodel:(FLMyIssueJudgePJModel *)flmodel
{
    _flmodel = nil;
    _flmodel = flmodel;
    baseViewFrame.origin.x = 0;
    baseViewFrame.origin.y = 0;
#warning TODO
    if (_flmodel.listImgURL.count == 0)
    {
        _flListImageCount = _flmodel.listImgURL.count;
    } else if (_flmodel.listImgURL.count <=3) {
        _flListImageCount = 1;
    } else if (_flmodel.listImgURL.count <=6){
        _flListImageCount = 2 ;
    }
    baseViewFrame.size.width = FLUISCREENBOUNDS.width;
    baseViewFrame.size.height = view_total_H;
    //    self.flbaseView = [[UIView alloc] initWithFrame:baseViewFrame];  //报错 打开
    self.flbaseView.frame = baseViewFrame; //报错删
    [self.contentView addSubview:self.flbaseView];
    [self.flbaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.top.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    [self allocInIssueCellPJList];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void)allocInIssueCellPJList
{
    //头像
    self.flavatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topViewFrame.origin.x = view_left_Margin;
    topViewFrame.origin.y = view_top_Margin;
    topViewFrame.size.width = view_header_width_H;
    topViewFrame.size.height = view_header_width_H;
    self.flavatarBtn.frame = topViewFrame;
    self.flavatarBtn.layer.cornerRadius = view_header_width_H / 2;
    self.flavatarBtn.layer.masksToBounds = YES;
    //昵称
    topViewFrame.origin.x += view_middle_Margin + view_header_width_H;
    topViewFrame.origin.y += 10;
    topViewFrame.size  = [_flmodel.content sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FL_FONT_NAME size:label_size_font_M]}];
    topViewFrame.size.width += 5;
    self.flnickNameLabel = [[UILabel alloc] initWithFrame:topViewFrame];
    self.flnickNameLabel.font = [UIFont fontWithName:FL_FONT_NAME size:label_size_font_M];
    //星星
    topViewFrame.origin.y += view_header_width_H - topViewFrame.size.height - view_top_Margin;
    topViewFrame.size.width = startView_size_W;
    topViewFrame.size.height = startView_size_H;
    self.flstartView = [[FLStartChoiceView alloc] initWithFrame:topViewFrame];
    self.flstartView.flrank = [_flmodel.rank integerValue];
    //时间
    topViewFrame.origin.x += view_middle_Margin + startView_size_W ;
    topViewFrame.size = [_flmodel.createTime sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FL_FONT_NAME size:label_size_font_M]}];
    topViewFrame.size.width += 5;
    self.fltimeLabel = [[FLGrayLabel alloc] initWithFrame:topViewFrame];
    self.fltimeLabel.font = [UIFont fontWithName:FL_FONT_NAME size:label_size_font_S];
    
    //说明
    topViewFrame.origin.x  = view_left_Margin;
    topViewFrame.origin.y += view_top_Margin * 2 + startView_size_H;
    CGFloat labelW = FLUISCREENBOUNDS.width - 2 * view_left_Margin;
    topViewFrame.size = [FLMineTools returnLabelSizeWithString:_flmodel.content viewWidth:labelW ];
    _flExplainLabelH = topViewFrame.size.height;
    flimageViewFrame = topViewFrame;
    self.flExplainLabel = [[FLGrayLabel alloc] initWithFrame:topViewFrame];
    self.flExplainLabel.font = [UIFont fontWithName:FL_FONT_NAME size:label_size_font_M];
    self.flExplainLabel.numberOfLines = 0;  //设置自动换行
    
    //imageview
    flimageViewFrame.origin.x  = view_left_Margin;
    flimageViewFrame.origin.y += view_top_Margin + _flExplainLabelH;
    flimageViewFrame.size.width = FLUISCREENBOUNDS.width - 2 * view_left_Margin;
    flimageViewFrame.size.height = _flListImageCount * fl_image_size_W;
    
    FLCellImageView* view = [[FLCellImageView alloc] initWithFrame:flimageViewFrame];
    view.flimagesArray = _flmodel.listImgURL;
    [self.flbaseView addSubview:view];
    
    
    [self addViewInPJcell];
}

- (void)addViewInPJcell
{
    [self.flbaseView addSubview:self.flavatarBtn];   //头像
    [self.flbaseView addSubview:self.flstartView];         //星星
    [self.flbaseView addSubview:self.flnickNameLabel]; //昵称
    [self.flbaseView addSubview:self.fltimeLabel];  //时间
    [self.flbaseView addSubview:self.flExplainLabel]; //说明
    [self setInfoInPJcell];
}


- (void)setInfoInPJcell
{
    [self.flavatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_flmodel.avatar isSite:NO]]] forState:UIControlStateNormal]; //头像
    self.flnickNameLabel.text   = _flmodel.nickname;
    self.fltimeLabel.text       = _flmodel.createTime;
    self.flExplainLabel.text    = _flmodel.content;
    
}

@end













