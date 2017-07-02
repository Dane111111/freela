//
//  XJCoverBottomView.m
//  FreeLa
//
//  Created by Leon on 16/6/22.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJCoverBottomView.h"
#import "XJCricleLabel.h"



#define xj_cover_view_h             (self.frame.size.height)
#define xj_cover_view_bottom1_h     26          //numberview
#define xj_cover_view_bottom2_h     26          //助力抢&转发领
#define xj_cover_view_bottom3_h     20          //标题
#define xj_cover_view_bottom4_h     14          //昵称
#define xj_cover_header_w           50          //头像
#define xj_cover_view_top_number_h  16          //发布数量
#define xj_cover_view_top_care_w    30          //关注按钮
#define xj_cover_bottom_margin      20
#define xj_cover_middle_margin      10
#define xj_view_tag_base            1111789


@interface XJCoverBottomView ()<UIGestureRecognizerDelegate>
{
    UIView* _xjNumberView;   //下方三个统计数的view
    UIButton*   _xjPartInBtn ;//下方参与btn
    XJCricleLabel*  _xjTopicConditionLabel;  // 助力抢 & 转发领等
    UILabel*        _xjTopicConditionDisLabel; //助力抢等 描述的话
    UILabel*        _xjTopicTitleLabel;     //标题
    UILabel*        _xjNickNameLabel;       //
    UIButton*       _xjPublisherBtn;        //发布者头像
    
    UILabel*        _xjTopicIssueNumberLabel;  // 发布
    UILabel*        _xjTopicHotLabel;  // 热度
    UIButton*       _xjCareBtn;         // 关注
    
    UILabel*        _xjLabelRelay;       //转发
    UILabel*        _xjLabelRead;       //阅读
    UILabel*        _xjLabelCollection;       //收藏
    UIImageView*    _xjCollectionImageView; //收藏 imageview
    
    
}
@property (nonatomic , assign) XJPartInClickType  xjPartInClickType;
@end

@implementation XJCoverBottomView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self xjInitPagesInCoverBottomView];
        //        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

- (void)xjInitPagesInCoverBottomView {
    CGRect _xjFrame ;
    _xjNumberView = [[UIView alloc] init];
    //    _xjNumberView.backgroundColor = [UIColor redColor];
    [self addSubview:_xjNumberView];
    [_xjNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-xj_cover_bottom_margin);
        make.left.equalTo(self).with.offset(xj_cover_bottom_margin);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width* 0.4 , xj_cover_view_bottom1_h));
    }];
    //number
    CGFloat xjView_W = (self.frame.size.width* 0.4)/3;
    for (NSInteger i = 0; i<3; i++) {
        UIView* xjView = [[UIView alloc] initWithFrame:CGRectMake(i*xjView_W, 0, xjView_W , xj_cover_view_bottom1_h )];
        xjView.tag = xj_view_tag_base + i;
        UITapGestureRecognizer* xjTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjClickToPushHTMLPage:)];
        xjTap.delegate = self;
        [xjView addGestureRecognizer:xjTap];
        UIImageView* xjImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 20, 20)];
        NSString* xjxj =@[@"myinfo_img_pinglun",@"myinfo_img_share",@"my_collect_zy"][i];
        xjImage.image = [UIImage imageNamed: xjxj] ;
        UILabel* xjLabel    = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, xjView_W - 22, xj_cover_view_bottom1_h)];
        [_xjNumberView addSubview:xjView];
        [xjView addSubview:xjLabel];
        [xjView addSubview:xjImage];
        //        xjLabel.backgroundColor = @[[UIColor redColor],[UIColor greenColor],[UIColor redColor]][i];
        xjLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_SMALL];
        xjLabel.textColor = [UIColor whiteColor];
        //        xjLabel.tag = xj_label_tag_base + i;
        xjLabel.textAlignment = NSTextAlignmentLeft;
        //        xjLabel.backgroundColor = [UIColor redColor];
        if (i==0) {
            _xjLabelRead = xjLabel;
        } else if (i==1) {
            _xjLabelRelay = xjLabel;
        } else if (i==2) {
            _xjLabelCollection = xjLabel;
            _xjCollectionImageView = xjImage;
        }
        
    }
    
    _xjPartInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_xjPartInBtn];
    _xjPartInBtn.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    [_xjPartInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_xjPartInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_xjNumberView).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-xj_cover_bottom_margin);
        make.size.mas_equalTo(CGSizeMake(80 , xj_cover_view_bottom1_h));
    }];
    _xjPartInBtn.hidden = FLFLIsPersonalAccountType ? NO : YES;
    
    
    _xjPartInBtn.layer.cornerRadius = 4;
    _xjPartInBtn.layer.masksToBounds = YES;
    [_xjPartInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
    [_xjPartInBtn addTarget:self action:@selector(xjClickToPartInTopic) forControlEvents:UIControlEventTouchUpInside];
    _xjPartInBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    
    _xjFrame.origin.x = xj_cover_bottom_margin;
    _xjFrame.origin.y = xj_cover_view_h - xj_cover_bottom_margin - xj_cover_middle_margin - xj_cover_view_bottom2_h - xj_cover_view_bottom1_h;
    _xjFrame.size.width = 80;
    _xjFrame.size.height = xj_cover_view_bottom2_h;
    _xjTopicConditionLabel  = [[XJCricleLabel alloc] initWithFrame:_xjFrame];
    [self addSubview:_xjTopicConditionLabel];
    _xjTopicConditionLabel.xjBackgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    _xjTopicConditionLabel.xjTextColor = [UIColor whiteColor];
    _xjTopicConditionLabel.xjFontSize = XJ_LABEL_SIZE_NORMAL;
    
    _xjTopicConditionLabel.xjContentStr = @"助力抢";
    
    
    //zhliqnag
    _xjFrame.origin.x = 80 ;
    _xjFrame.size.width = FLUISCREENBOUNDS.width -110;

    _xjTopicConditionDisLabel = [[UILabel alloc] initWithFrame:_xjFrame];
    _xjTopicConditionDisLabel.textColor = [UIColor whiteColor];
    _xjTopicConditionDisLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_BIG];
    [self addSubview:_xjTopicConditionDisLabel];
    _xjTopicConditionDisLabel.frame = _xjFrame;
    _xjTopicConditionDisLabel.text = @"先到先得 最低助力数 12& 个，仅限8&个";
    
    
    //标题
    _xjFrame.origin.x = xj_cover_bottom_margin;
    _xjFrame.origin.y = _xjFrame.origin.y -= xj_cover_middle_margin + xj_cover_view_bottom3_h;
    _xjTopicTitleLabel = [[UILabel alloc] initWithFrame:_xjFrame];
    [self addSubview:_xjTopicTitleLabel];
    _xjTopicTitleLabel.textColor = [UIColor whiteColor];
    _xjTopicTitleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
    _xjTopicTitleLabel.text =@"特色美食7000";
    
    
    //头x像
    _xjFrame.origin.y -= xj_cover_middle_margin + xj_cover_header_w;
    _xjFrame.size.width = xj_cover_header_w;
    _xjFrame.size.height = xj_cover_header_w;
    _xjPublisherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _xjPublisherBtn.frame = _xjFrame;
    [_xjPublisherBtn addTarget:self action:@selector(xjClickToPushPublisherPage) forControlEvents:UIControlEventTouchUpInside];
    _xjPublisherBtn.layer.cornerRadius = xj_cover_header_w / 2;
    _xjPublisherBtn.layer.masksToBounds = YES;
    [self addSubview:_xjPublisherBtn];
    //    _xjPublisherBtn.backgroundColor = [UIColor redColor];

    
    //numbser issue
    _xjFrame.origin.x += xj_cover_middle_margin + xj_cover_header_w;
    _xjFrame.origin.y += 28 ;
    _xjFrame.size.width = 160;
    _xjFrame.size.height = xj_cover_view_top_number_h;
    UIView* xjPubliserView = [[UIView alloc] initWithFrame:_xjFrame];
//    xjPubliserView.backgroundColor = [UIColor redColor];
    [self addSubview:xjPubliserView];
    
    //昵称
    _xjFrame.origin.y  -= 20;
    _xjNickNameLabel = [[UILabel alloc] initWithFrame:_xjFrame];
    [self addSubview:_xjNickNameLabel];
    _xjNickNameLabel.textColor = [UIColor whiteColor];
    _xjNickNameLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
   
    //发布数
    UILabel* xjIssueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 34, xj_cover_view_top_number_h)];
    xjIssueLabel.text = @"发布";
    xjIssueLabel.layer.cornerRadius = 6;
    xjIssueLabel.textAlignment = NSTextAlignmentCenter;
    xjIssueLabel.layer.masksToBounds = YES;
    xjIssueLabel.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    xjIssueLabel.textColor = [UIColor whiteColor];
    [xjPubliserView addSubview:xjIssueLabel];
    xjIssueLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    
    _xjTopicIssueNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 50, xj_cover_view_top_number_h)];
    _xjTopicIssueNumberLabel.textColor = [UIColor whiteColor];
    [xjPubliserView addSubview:_xjTopicIssueNumberLabel];
    _xjTopicIssueNumberLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    
    //热度
    UILabel* xjHotLable = [[UILabel alloc] initWithFrame:CGRectMake(70 , 0, 34, xj_cover_view_top_number_h)];
    xjHotLable.text = @"热度";
    xjHotLable.layer.cornerRadius = 6;
    xjHotLable.layer.masksToBounds = YES;
    xjHotLable.textAlignment = NSTextAlignmentCenter;
    xjHotLable.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    xjHotLable.textColor = [UIColor whiteColor];
    [xjPubliserView addSubview:xjHotLable];
    xjHotLable.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    
    _xjTopicHotLabel = [[UILabel alloc] initWithFrame:CGRectMake(108, 0, 60, xj_cover_view_top_number_h)];
    _xjTopicHotLabel.textColor = [UIColor whiteColor];
    [xjPubliserView addSubview:_xjTopicHotLabel];
    _xjTopicHotLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    
    //关注
    _xjCareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _xjFrame.origin.x = FLUISCREENBOUNDS.width - 20 - xj_cover_view_top_care_w;
    _xjFrame.size.width = xj_cover_view_top_care_w;
    _xjFrame.size.height= xj_cover_view_top_care_w;
    _xjCareBtn.frame = _xjFrame;
    [self addSubview:_xjCareBtn];
    [_xjCareBtn addTarget: self action:@selector(xjClickToCareOrDont) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)setXjQualificationModel:(XJQualificationModel *)xjQualificationModel {
    _xjQualificationModel = xjQualificationModel;
    [self xjSetBtnClickState];
}

- (void)setXjTpoicStatisticModel:(XJTopicStatisticModel *)xjTpoicStatisticModel {
    _xjTpoicStatisticModel = xjTpoicStatisticModel;
    [self xjSetPageInfo];
}

- (void)setXjTopicPartInModel:(XJTopicPartInModel *)xjTopicPartInModel {
    _xjTopicPartInModel = xjTopicPartInModel;
    [self xjSetPageInfo];
}

- (void)setXjTopicDetailnModel:(XJTopicDetailModel *)xjTopicDetailnModel {
    _xjTopicDetailnModel = xjTopicDetailnModel;
    [self xjSetPageInfo];
}

- (void)xjSetPageInfo {
    if(_xjTopicDetailnModel) {
        [_xjPublisherBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:_xjTopicDetailnModel.avatar isSite:NO]]] forState:UIControlStateNormal];
        _xjNickNameLabel.text   =   _xjTopicDetailnModel.nickName;
        _xjTopicTitleLabel.text =   _xjTopicDetailnModel.topicTheme;
        _xjTopicConditionLabel.xjContentStr = [FLSquareTools returnConditionStrValueWithKey:_xjTopicDetailnModel.topicConditionKey];
        if ([_xjTopicDetailnModel.topicConditionKey isEqualToString:FLFLXJSquareIssueNonePick]) {
            _xjTopicConditionDisLabel.text = [NSString stringWithFormat:@"限%ld份",_xjTopicDetailnModel.topicNum];
        } else if ([_xjTopicDetailnModel.topicConditionKey isEqualToString:FLFLXJSquareIssueRelayPick]) {
            _xjTopicConditionDisLabel.text = [NSString stringWithFormat:@"转发后才能领取,限%ld份",_xjTopicDetailnModel.topicNum];
        } else if ([_xjTopicDetailnModel.topicConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
            _xjTopicConditionDisLabel.text = [NSString stringWithFormat:@"%@ 最低助力数%ld个,限%ld份",[FLSquareTools xjReturnStr_is_forstWithStr:_xjTopicDetailnModel.zlqRule],_xjTopicDetailnModel.lowestNum,_xjTopicDetailnModel.topicNum];
        } else if ([_xjTopicDetailnModel.topicConditionKey isEqualToString:FLFLXJSquareIssueCarePick]) {
            _xjTopicConditionDisLabel.text = [NSString stringWithFormat:@"关注后才能领取,限%ld份",_xjTopicDetailnModel.topicNum];
        }
    }
    //    if (_xjTpoicStatisticModel) {
    _xjLabelRead.text = [NSString stringWithFormat:@"%ld",_xjTpoicStatisticModel.commentNum];
    _xjLabelRelay.text = [NSString stringWithFormat:@"%ld",_xjTpoicStatisticModel.transformNum];
    _xjLabelCollection.text = [NSString stringWithFormat:@"%ld",_xjTpoicStatisticModel.collentionNum];
    //    } else {
    //        if ([self.delegate respondsToSelector:@selector(xjRefreshPagesInCoverViewBottomView)]) {
    //            [self.delegate xjRefreshPagesInCoverViewBottomView];
    //        }
    //    }
    if (!_xjTpoicStatisticModel) {
        if ([self.delegate respondsToSelector:@selector(xjRefreshPagesInCoverViewBottomView)]) {
            [self.delegate xjRefreshPagesInCoverViewBottomView];
        }
    }
    FL_Log(@"this is the test of the threes [%@],[%@],[%@],",_xjLabelRead.text,_xjLabelRelay.text,_xjLabelCollection.text);
    FL_Log(@"thsis is the tsest of the threes [%ld],[%ld],[%ld],",_xjTpoicStatisticModel.commentNum,_xjTpoicStatisticModel.transformNum,_xjTpoicStatisticModel.collentionNum);
    FL_Log(@"thsis is the tsest of the threes[ %@]",_xjTpoicStatisticModel);
    [_xjTopicTitleLabel sizeToFit];
 
 
}


- (void)xjSetPublisherInfoWithIssueNumber:(NSInteger)xjIssueNum hotNum:(NSInteger)xjHotNum {
    _xjTopicHotLabel.text = [FLTool xjSetNumberByStr:[NSString stringWithFormat:@"%ld",xjHotNum]];  //[FLTool xjSetNumberByStr:[NSString stringWithFormat:@"%ld",xjHotNum]]
    _xjTopicIssueNumberLabel.text = [NSString stringWithFormat:@"%ld",xjIssueNum];
}

- (void)xjClickToCareOrDont {
    if ([self.delegate respondsToSelector:@selector(xjClickBtnToCarePublisherInCoverViewWithuserId:type:) ])   {
        [self.delegate xjClickBtnToCarePublisherInCoverViewWithuserId:_xjTopicDetailnModel.userId type:_xjTopicDetailnModel.userType];
    }
}

- (void)xjSet_is_friendInCoverBottom:(BOOL)xj_isFriend {
    if (xj_isFriend) {
        [_xjCareBtn setBackgroundImage:[UIImage imageNamed:@"love-red"] forState:UIControlStateNormal];
    } else {
        [_xjCareBtn setBackgroundImage:[UIImage imageNamed:@"love-gray"] forState:UIControlStateNormal];
    }
}

- (void)xjClickToPushHTMLPage:(UIGestureRecognizer*)xjizer {
    UIView* xjView = xjizer.view;
    HFivePushStyle xjPushStyle  ;
    if (xjView.tag == xj_view_tag_base) {
        FL_Log(@"这里是view1");
        xjPushStyle = HFivePushStyleJudgeList;
    } else if (xjView.tag == xj_view_tag_base + 1){
        FL_Log(@"这里是view2");
        xjPushStyle = HFivePushStyleRelay;
    } else if (xjView.tag == xj_view_tag_base + 2){
        FL_Log(@"这里是view3");
        xjPushStyle = HFivePushStyleCollectoin;
    }
    if ([self.delegate respondsToSelector:@selector(xjCallJSInCoverViewBottomViewWithType:)]) {
        [self.delegate xjCallJSInCoverViewBottomViewWithType:xjPushStyle];
    }
}

- (void)xjSet_is_CollectionInCoverBottom:(BOOL)xj_isFriend {
    if (xj_isFriend) {
        _xjCollectionImageView.image = [UIImage imageNamed:@"btn_collection_yellow_version2"];
    } else {
        _xjCollectionImageView.image = [UIImage imageNamed:@"my_collect_zy"];
    }
}

- (void)xjSetBtnClickState {
    
    
    FL_Log(@"this is the buttong key =[%@]",self.xjQualificationModel.buttonKey);
    if ([self.xjQualificationModel.buttonKey isEqualToString:@"b1"]) { //参数错误
        [_xjPartInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb1;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b2"]) {
        [_xjPartInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb2;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@""]) {
        
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b4"]) {
        _xjPartInBtn.hidden = YES;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b5"]) {
        [_xjPartInBtn setTitle:@"已下架" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb5;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b6"]) {
        [_xjPartInBtn setTitle:@"已抢光" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb6;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b7"]) {
        [_xjPartInBtn setTitle:@"未开始" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb7;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b8"]) {
        [_xjPartInBtn setTitle:@"已结束" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb8;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b9"]) {
        [_xjPartInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb9;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b10"]) {
        [_xjPartInBtn setTitle:@"已领取过" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb10;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b11"]) {
        [_xjPartInBtn setTitle:@"前往领取" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb11;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b12"]) {
        [_xjPartInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb12;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b13"]) {
        [_xjPartInBtn setTitle:@"已领取" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb13;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b14"]) {
        [_xjPartInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb14;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b15"]) {
        [_xjPartInBtn setTitle:@"前往领取" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb15;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b16"]) {
        [_xjPartInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb16;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b17"]) {
        [_xjPartInBtn setTitle:@"继续助力" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb17;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b18"]) {
        [_xjPartInBtn setTitle:@"继续助力" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb18;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b19"]) {
        [_xjPartInBtn setTitle:@"继续助力" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb19;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b20"]) {
        [_xjPartInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb20;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b21"]) {
        [_xjPartInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb21;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@"b22"]) {
        [_xjPartInBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        self.xjPartInClickType = XJPartInClickTypeb18;
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@""]) {
        
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@""]) {
        
    } else if ([self.xjQualificationModel.buttonKey isEqualToString:@""]) {
        
    }
    
}
- (void)xjClickToPartInTopic {
    FL_Log(@"xjClickBtnToPar--------InTopicInCoverView");
    if ([self.delegate respondsToSelector:@selector(xjClickBtnToParInTopicInCoverView:)]) {
        [self.delegate xjClickBtnToParInTopicInCoverView:self.xjPartInClickType];
    }
}
//查看发布者信息
- (void)xjClickToPushPublisherPage {
    if ([self.xjTopicDetailnModel.userType isEqualToString:FLFLXJUserTypeCompStrKey]) { //商家
        if ([self.delegate respondsToSelector:@selector(xjPushPubilisherPageViewWithType:)]) {
            [self.delegate xjPushPubilisherPageViewWithType:YES];
        }
    } else { //个人
        if ([self.delegate respondsToSelector:@selector(xjPushPubilisherPageViewWithType:)]) {
            [self.delegate xjPushPubilisherPageViewWithType:NO];
        }
    }
}

@end










