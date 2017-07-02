//
//  XJCoverTopView.m
//  FreeLa
//
//  Created by Leon on 16/6/22.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJCoverTopView.h"

#define xj_header_iamge_h   50
@interface XJCoverTopView()
{
    UIScrollView*   _xjScrollview;      //
    UIView*         _xjTopView;         //
    UILabel*        _xjTitleLabel;      //标题
    UILabel*        _xjPartInLabel;     //参与数量
}


@end

@implementation XJCoverTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self xjInitPageOfCoverTopView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self xjInitPageOfCoverTopView];
    }
    return self;
}

- (void)xjInitPageOfCoverTopView {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    _xjTopView = [[UIView alloc] init];
    [self addSubview:_xjTopView];
    _xjScrollview = [[UIScrollView alloc] init];
    [self addSubview:_xjScrollview];
    UITapGestureRecognizer* xjxj = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjClickToPushPartInList)];
    [_xjScrollview addGestureRecognizer:xjxj];
    _xjTitleLabel = [[UILabel alloc] init];
    [_xjTopView addSubview:_xjTitleLabel];
    
    
    _xjPartInLabel = [[UILabel alloc] init];
    _xjPartInLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    _xjPartInLabel.textColor = [UIColor whiteColor];
    _xjPartInLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_xjPartInLabel];

    _xjTopView.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, 80);
    _xjScrollview.frame = CGRectMake(0, 80, FLUISCREENBOUNDS.width, 50);
    _xjPartInLabel.frame = CGRectMake(20, 130, 100, 20);
//    _xjTitleLabel.frame = CGRectMake(20, 30, FLUISCREENBOUNDS.width -40, 20);
    [_xjTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@20);
        make.height.equalTo(@49);
    }];
    _xjTitleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    _xjTitleLabel.textColor = [UIColor whiteColor];
    _xjScrollview.showsHorizontalScrollIndicator = NO;
    //返回
    UIButton* xjBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xjBackBtn.frame =  CGRectMake(20, 30, 30, 30);
    [xjBackBtn setBackgroundImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
    [xjBackBtn addTarget:self action:@selector(xjClickToGoBack) forControlEvents:UIControlEventTouchUpInside];
    [_xjTopView addSubview:xjBackBtn];
    //举报
    UIButton* xjJBkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xjJBkBtn.frame =  CGRectMake(FLUISCREENBOUNDS.width - 50, 30, 30, 30);
    [xjJBkBtn setBackgroundImage:[UIImage imageNamed:@"icon_jubao_yellow"] forState:UIControlStateNormal];
    [xjJBkBtn addTarget:self action:@selector(xjClickToGoJBPage) forControlEvents:UIControlEventTouchUpInside];
    [_xjTopView addSubview:xjJBkBtn];
    
    

}

- (void)setXjTopicPartInArr:(NSArray *)xjTopicPartInArr {
    if (xjTopicPartInArr.count==0) {
        return;
    }
    _xjScrollview.contentSize = CGSizeMake(((xj_header_iamge_h +4)*xjTopicPartInArr.count+20) >FLUISCREENBOUNDS.width ?(xj_header_iamge_h +4)*xjTopicPartInArr.count + 20 :FLUISCREENBOUNDS.width, 0);
    for (NSInteger i = 0;  i < xjTopicPartInArr.count; i++) {
        UIButton* xjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        xjBtn.frame = CGRectMake(20 + i * (xj_header_iamge_h + 4), 0, xj_header_iamge_h, xj_header_iamge_h);
        [_xjScrollview addSubview:xjBtn];
        xjBtn.layer.borderColor=DE_headerBorderColor.CGColor;
        xjBtn.layer.borderWidth=DE_headerBorderWidth;

        [xjBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",xjTopicPartInArr[i]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xj_default_avator"]];
        [xjBtn addTarget:self action:@selector(cjClickToPushCommenListHTML) forControlEvents:UIControlEventTouchUpInside];
        xjBtn.layer.cornerRadius = xjBtn.width / 2;
        xjBtn.layer.masksToBounds = YES;
        [xjBtn addTarget:self action:@selector(xjClickToPushPartInList) forControlEvents:UIControlEventTouchUpInside];
    }
    
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
    if (_xjTopicDetailnModel&&_xjTpoicStatisticModel) {
        NSString *xjTimeStr = [FLTool returnNumberWithStartTime:_xjTopicDetailnModel.invalidTime serviceTime:_xjTopicDetailnModel.xjnewDate];
       _xjTitleLabel.text = [NSString stringWithFormat:@"浏览:%ld  剩余数量:%ld  剩余时间:%@",_xjTpoicStatisticModel.pv,_xjTopicDetailnModel.topicNum - _xjTpoicStatisticModel.receiveNum ,xjTimeStr];
        [_xjTitleLabel sizeToFit];
    } else {
        if ([self.delegate respondsToSelector:@selector(xjRefreshTopViewInCoverView)  ]) {
            [self.delegate xjRefreshTopViewInCoverView];
        }
    }
}


#pragma  mark ------------- [push]
- (void)cjClickToPushCommenListHTML {
    if ([self.delegate respondsToSelector:@selector(xjClickPartInListToPushHTMLInCoverView)]) {
        [self.delegate xjClickPartInListToPushHTMLInCoverView];
    }
}
- (void)xjClickToGoBack {
    if ([self.delegate respondsToSelector:@selector(xjClickBtnToPushBackInCoverView)]) {
        [self.delegate xjClickBtnToPushBackInCoverView];
    }
}

- (void)xjSet_total_numerInTopCoverView:(NSInteger)xjNum {
    _xjPartInLabel.text = [NSString stringWithFormat:@"(参与人数:%ld)",xjNum];
    [_xjPartInLabel sizeToFit];
}
//举报
- (void)xjClickToGoJBPage {
    if ([self.delegate respondsToSelector:@selector(xjClickTopViewJBToPushHtml)]) {
        [self.delegate xjClickTopViewJBToPushHtml];
    }
}

- (void)xjClickToPushPartInList {
    if ([self.delegate respondsToSelector:@selector(xjClickTopViewPartInListToPushHtml:)]) {
        if ([_xjTopicDetailnModel.topicConditionKey isEqualToString:FLFLXJSquareIssueHelpPick]) {
          [self.delegate xjClickTopViewPartInListToPushHtml:YES];
        } else {
             [self.delegate xjClickTopViewPartInListToPushHtml:NO];
        }
       
    }
}

@end






