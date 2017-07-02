//
//  FLMyIssueActivityPartInView.m
//  FreeLa
//
//  Created by Leon on 16/1/8.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyIssueActivityPartInView.h"


#define view_bottom_btn_W       FLUISCREENBOUNDS.width / 4
#define view_bottom_margin      8
#define view_bottom_insertMargin    5

@interface FLMyIssueActivityPartInView ()
{
    NSInteger _flPartInCurrentPage;
    NSInteger _fltotal;
}

/**baseview*/
@property (nonatomic , strong)UIView* flBaseView;


@end

@implementation FLMyIssueActivityPartInView

static CGRect Viewframe , bottomLeftFrame ,bottomRightFrame ,flAllChoiceBtnFrame;
- (instancetype)initWithData:(NSMutableArray*)flMyTopicPartInArray
{
    self = [super init];
    if (self ) {
        //        _flMyTopicPartInArray = flMyTopicPartInArray;
        Viewframe = CGRectZero;
        Viewframe.origin.x = 0 ;
        Viewframe.origin.y =  FL_TopColumnView_Height_S + StatusBar_NaviHeight;
        Viewframe.size.width = FLUISCREENBOUNDS.width;
        Viewframe.size.height = FLUISCREENBOUNDS.height - StatusBar_NaviHeight - TabBarHeight ;
        self.frame = Viewframe;
        _flMyTopicPartInArray = [NSMutableArray array];
        _flPartInCurrentPage = 0;
    }
    return self;
}

- (void)setFlmyIssueInMineModel:(FLMyIssueInMineModel *)flmyIssueInMineModel
{
    _flmyIssueInMineModel  = flmyIssueInMineModel;
    [self creatBottomUIInMyIssueVCView];
    
}

//底部view
- (void)creatBottomUIInMyIssueVCView
{
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, FLUISCREENBOUNDS.height - TabBarHeight - FL_TopColumnView_Height_S - StatusBar_NaviHeight, FLUISCREENBOUNDS.width , TabBarHeight)];
    [self addSubview:bottomView];
    //细线
    UIView* underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, 1)];
    underLineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    [bottomView addSubview:underLineView];
    //导出信息view
    bottomLeftFrame.origin.x = view_bottom_btn_W / 2;
    bottomLeftFrame.origin.y = view_bottom_margin;
    bottomLeftFrame.size.width = view_bottom_btn_W;
    bottomLeftFrame.size.height = TabBarHeight - view_bottom_margin * 2;
    bottomRightFrame = bottomLeftFrame;
    UIView* leftView = [[UIView alloc] initWithFrame:bottomLeftFrame];
    leftView.layer.cornerRadius = 2;
    leftView.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    [bottomView addSubview:leftView];
    self.flExcleBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flExcleBtn.frame = bottomLeftFrame;
    [bottomView addSubview:self.flExcleBtn];
    //image
    bottomLeftFrame.origin.x = view_bottom_insertMargin;
    bottomLeftFrame.origin.y = view_bottom_insertMargin;
    bottomLeftFrame.size.height -= view_bottom_insertMargin * 2;
    bottomLeftFrame.size.width = bottomLeftFrame.size.height;
    UIImageView* leftLogo = [[UIImageView alloc] initWithFrame:bottomLeftFrame];
    [leftView addSubview:leftLogo];
    leftLogo.image  = [UIImage imageNamed:@"btn_icon_excle"];
    
    //label
    bottomLeftFrame.origin.x += bottomLeftFrame.size.height ;
    bottomLeftFrame.size.width = view_bottom_btn_W - view_bottom_insertMargin - bottomLeftFrame.size.height ;
    UILabel* leftLabel = [[UILabel alloc] initWithFrame:bottomLeftFrame];
    leftLabel.text = @"导出信息";
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    [leftView addSubview:leftLabel];
    
    
    
    //一键建群view
    bottomRightFrame.origin.x =  FLUISCREENBOUNDS.width -  view_bottom_btn_W * 1.5;
    flAllChoiceBtnFrame = bottomRightFrame;
    UIView* rightView = [[UIView alloc] initWithFrame:bottomRightFrame];
    rightView.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    rightView.layer.cornerRadius = 2;
    [bottomView addSubview:rightView];
    self.flmakeGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flmakeGroupBtn.frame = bottomRightFrame;
    [bottomView addSubview:self.flmakeGroupBtn];
    //image
    bottomRightFrame.origin.x = view_bottom_insertMargin;
    bottomRightFrame.origin.y = view_bottom_insertMargin;
    bottomRightFrame.size.height -= view_bottom_insertMargin * 2;
    bottomRightFrame.size.width = bottomRightFrame.size.height;
    UIImageView* rightLogo = [[UIImageView alloc] initWithFrame:bottomRightFrame];
    [rightView addSubview:rightLogo];
    rightLogo.image  = [UIImage imageNamed:@"btn_icon_group_gray"];
    //label
    bottomRightFrame.origin.x += bottomLeftFrame.size.height  ;
    bottomRightFrame.size.width = view_bottom_btn_W - view_bottom_insertMargin - bottomRightFrame.size.height ;
    UILabel* rightLabel = [[UILabel alloc] initWithFrame:bottomRightFrame];
    rightLabel.text = @"一键建群";
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    [rightView addSubview:rightLabel];
    
    //全选
    flAllChoiceBtnFrame.origin.x += view_bottom_btn_W * 1.5;
    flAllChoiceBtnFrame.origin.y += view_bottom_margin;
    flAllChoiceBtnFrame.size.width = 40;
    flAllChoiceBtnFrame.size.height -= view_bottom_insertMargin * 2;
    self.flAllChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flAllChooseBtn.frame = flAllChoiceBtnFrame;
    [self.flAllChooseBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.flAllChooseBtn setBackgroundColor:[UIColor colorWithHexString:XJ_FCOLOR_REDBACK]];
    //    [bottomView addSubview:self.flAllChooseBtn];
    
    
}




@end



























