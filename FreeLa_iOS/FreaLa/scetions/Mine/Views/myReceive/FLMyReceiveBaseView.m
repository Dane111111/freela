//
//  FLMyReceiveBaseView.m
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyReceiveBaseView.h"


#define view_imageHieght        FLUISCREENBOUNDS.width//xj_image_view_H//(FLUISCREENBOUNDS.width *0.7)     //图片高
#define view_topMargin          10      //高差
#define view_leftMarginW        10      //左边距
#define view_titleLabel_H       25      //标题高度
#define view_introduceLabel_H   20      //描述高度
#define view_addressLabel_H     20      //地址高度
#define view_timeLabel_H        20      //时间高度
#define view_check_detail_H     40      //查看详情btn
#define view_font_L         14
#define view_font_M         10
#define view_font_S         8
#define xj_label_tag        12121

#define image_numberW           30      //图标宽度/高度
#define label_numberH           18      //阅读数label高度
#define number_numberH          18      //阅读数高度
#define view_numberMargin       3       //阅读数中间高度
#define view_numberWith         ((FLUISCREENBOUNDS.width - view_leftMarginW * 6) / 4)     //阅读数的宽度
#define view_numberHeight     view_topMargin + image_numberW + label_numberH + number_numberH + view_numberMargin * 3

#define total_H              xj_image_view_H + view_titleLabel_H  + view_addressLabel_H + view_timeLabel_H + view_numberHeight + view_check_detail_H +  view_topMargin * 6
//#define total_H              view_imageHieght + view_titleLabel_H + view_introduceLabel_H + view_addressLabel_H + view_timeLabel_H + view_numberHeight + view_check_detail_H +  view_topMargin * 7

@interface FLMyReceiveBaseView ()<SDCycleScrollViewDelegate>
{
    CGFloat xj_image_view_H; //轮播图高度
}
/**背景的view*/
@property (nonatomic , strong)UIView* flBackBaseview;


/**标题*/
@property (nonatomic , strong)UILabel* flTitleLabel;
/**描述*/
@property (nonatomic , strong)FLGrayLabel* flIntroduceLabel;
/**地址*/
@property (nonatomic , strong)FLGrayLabel* flAddressLabel;
/**时间*/
@property (nonatomic , strong)FLGrayLabel* flTimeLabel;

/**中间的进度条*/
@property (nonatomic , strong)UIProgressView* flProgressView;
/**统计数据的数组*/
@property (nonatomic , strong)NSArray* flNumberArray;

/**剩余时间*/
@property (nonatomic , strong)NSString* flLeftTimeStr;

/**地址logo*/
@property (nonatomic , strong)UIImageView* flAddressLogoImageView;
/**时间logo*/
@property (nonatomic , strong)UIImageView* flTimeLogoImageView;
/**底部细线*/
@property (nonatomic , strong)UIView * flUnderLineView;

/**轮播*/
@property (nonatomic , strong) SDCycleScrollView *cycleScrollView2;

@property (nonatomic , strong) UIView* xjBottomView;
@end

static CGRect Viewframe,logoFrame,flprogressViewFrame ,backFrame ;
@implementation FLMyReceiveBaseView

- (instancetype)initWithModel:(FLMyReceiveListModel *)flMyIssueInMineModel
{
    self = [super init];
    if (self) {
        if (FLUISCREENBOUNDS.width <=320) {
            xj_image_view_H = (FLUISCREENBOUNDS.width *0.65);
        } else {
            xj_image_view_H = (FLUISCREENBOUNDS.width *0.7);
        }
        _flMyReceiveInMineModel = flMyIssueInMineModel;
        Viewframe = CGRectZero;
        Viewframe.origin.x = 0;
        Viewframe.origin.y =  FL_TopColumnView_Height_S + StatusBar_NaviHeight;
        Viewframe.size.width = FLUISCREENBOUNDS.width;
        Viewframe.size.height = FLUISCREENBOUNDS.height - StatusBar_NaviHeight  ;
        self.frame = Viewframe;
        [self requestImageArrayWithTopicId:_flMyReceiveInMineModel.flMineIssueTopicIdStr];
        
        self.flCheckDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imagesURLStrings = [NSMutableArray array];
        [self creatUIInMyIssueVCView];
        
    }
    return self;
}

- (void)requestImageArrayWithTopicId:(NSString*)topicId
{
    //    [FLFinalNetTool flNewgetDetailImageStrInHTMLWithTopicId:topicId
    //                                                    success:^(NSDictionary *data) {
    //                                                        FL_Log(@"new net tool to request detail images =%@",data);
    //                                                        if ([data[FL_NET_KEY_NEW] boolValue]) {
    //                                                            NSArray* array = data[FL_NET_DATA_KEY];
    //                                                            array = [FLHelpDetailImageModels mj_objectArrayWithKeyValuesArray:array];
    //                                                            for (FLHelpDetailImageModels* model in array) {
    //                                                                if ([model.businesstype integerValue] == 2) {
    //                                                                    [_imagesURLStrings addObject:[NSString stringWithFormat:@"%@%@",FLBaseUrl,model.url]];
    //                                                                }
    //                                                            }
    //
    //
    //                                                             [self creatUIInMyIssueVCView];
    //
    //                                                        }
    //
    //                                                    } failure:^(NSError *error) {
    //
    //                                                    }];
    
    
    
}

- (void)setFlMyReceiveInMineModel:(FLMyReceiveListModel *)flMyReceiveInMineModel {
    _flMyReceiveInMineModel = flMyReceiveInMineModel;
    [self setInfoInMyIssueControlView];
}

- (void)setImagesURLStrings:(NSMutableArray *)imagesURLStrings
{
    _imagesURLStrings = imagesURLStrings;
    _cycleScrollView2.imageURLStringsGroup = _imagesURLStrings;
    if (_flMyReceiveInMineModel) {
        //       [self creatUIInMyIssueVCView];
    }
}

- (void)creatUIInMyIssueVCView
{
    
    Viewframe.origin.y = 0;
    Viewframe.size.height = FLUISCREENBOUNDS.height - StatusBar_NaviHeight  - FL_TopColumnView_Height_S;
    //背景
    self.flScrollView = [[UIScrollView alloc] initWithFrame:Viewframe];
    self.flScrollView.contentSize = CGSizeMake(FLUISCREENBOUNDS.width, total_H);
    self.flScrollView.showsVerticalScrollIndicator =NO;
    self.flScrollView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    backFrame = Viewframe;
    backFrame.size.height = total_H;
    self.flBackBaseview = [[UIView alloc] initWithFrame:backFrame];
    self.flBackBaseview.backgroundColor = [UIColor whiteColor];
    
    //图片
    Viewframe.origin.y = 0;
    Viewframe.size.height = FLUISCREENBOUNDS.width;
    //    self.flMyBackGroundImageView = [[UIImageView alloc] initWithFrame:Viewframe];
    //轮播
    _cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:Viewframe delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    
    [self addSubview:self.flScrollView];
    [self.flScrollView addSubview:self.flBackBaseview];
    [self.flBackBaseview addSubview:_cycleScrollView2];
    
    /***底部**/
    self.xjBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, xj_image_view_H, FLUISCREENBOUNDS.width, self.flBackBaseview.frame.size.height - xj_image_view_H)];
    self.xjBottomView.backgroundColor = [UIColor whiteColor];
    [self.flBackBaseview addSubview:self.xjBottomView];
    
    //标题
    Viewframe.origin.x = view_leftMarginW;
    Viewframe.origin.y += view_topMargin + xj_image_view_H;
    Viewframe.size.height = view_titleLabel_H;
    self.flTitleLabel = [[UILabel alloc] initWithFrame:Viewframe];
    self.flTitleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:view_font_L];
    //描述
    self.flIntroduceLabel = [[FLGrayLabel alloc] initWithFrame:Viewframe];
    self.flIntroduceLabel.font = [UIFont fontWithName:FL_FONT_NAME size:view_font_M];
    //地址logo
    logoFrame = Viewframe;
    logoFrame.origin.y += view_topMargin + view_introduceLabel_H;
    logoFrame.size.height = view_addressLabel_H;
    logoFrame.size.width  = view_addressLabel_H - 4;
    self.flAddressLogoImageView = [[UIImageView alloc] initWithFrame:logoFrame];
    //地址
    Viewframe.origin.x += view_addressLabel_H + 5;
    Viewframe.origin.y += view_topMargin + view_introduceLabel_H;
    Viewframe.size.height = view_addressLabel_H;
    self.flAddressLabel = [[FLGrayLabel alloc] initWithFrame:Viewframe];
    self.flAddressLabel.font = [UIFont fontWithName:FL_FONT_NAME size:view_font_M];
    //时间logo
    logoFrame.origin.y += view_topMargin + view_addressLabel_H;
    logoFrame.size.width = view_timeLabel_H;
    logoFrame.size.height = view_timeLabel_H;
    self.flTimeLogoImageView = [[UIImageView alloc] initWithFrame:logoFrame];
    //时间
    Viewframe.origin.y = logoFrame.origin.y;
    self.flTimeLabel = [[FLGrayLabel alloc] initWithFrame:Viewframe];
    self.flTimeLabel.font = [UIFont fontWithName:FL_FONT_NAME size:view_font_M];
    //进度条
    flprogressViewFrame = Viewframe;
    flprogressViewFrame.origin.x += view_leftMarginW;
    flprogressViewFrame.origin.y += view_topMargin * 2 + view_timeLabel_H;
    flprogressViewFrame.size.width = FLUISCREENBOUNDS.width - view_leftMarginW * 4;
    flprogressViewFrame.size.height = 2;
    self.flProgressView = [[UIProgressView alloc] initWithFrame:flprogressViewFrame];
    self.flProgressView.centerX = self.centerX;
    self.flProgressView.tintColor = [UIColor colorWithHexString:XJ_FCOLOR_REDFONT];
    [self.flProgressView setProgress:[_flMyReceiveInMineModel.flfloatNumberStr floatValue]];
    self.flProgressView.layer.cornerRadius = 3;
    self.flProgressView.layer.masksToBounds = YES;
    UIView* xjProgressBac = [[UIView alloc] initWithFrame:flprogressViewFrame];
    [self.flBackBaseview addSubview:xjProgressBac];
    [xjProgressBac addSubview:self.flProgressView];
    [self.flProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xjProgressBac).offset(0);
        //        make.left.equalTo(self).offset(flprogressViewFrame.origin.x);
        make.centerX.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(flprogressViewFrame.size.width, XJ_PROGRESS_H));
    }];
    
    
    //阅读数、分享数、参与进度、剩余天数
    self.flNumberArray = @[@"阅读数",@"分享数",@"参与进度",@"参与剩余时间"];
    NSArray* fllogoArray = @[@"iconfont_yuedu_gray",@"iconfont_fenxiang_gray",@"iconfont_renwujindushangsheng",@"iconfont_time_gray"];
    //时间相减,此处变更为剩余时间
    NSString* str = [FLTool returnNumberWithStartTime:_flMyReceiveInMineModel.flTimeEnd serviceTime:_flMyReceiveInMineModel.flTimeService];
    NSArray* numberModelArray = @[_flMyReceiveInMineModel.flMineIssueNumbersReadStr ? _flMyReceiveInMineModel.flMineIssueNumbersReadStr :@"0",_flMyReceiveInMineModel.flMineIssueNumbersRelayStr ? _flMyReceiveInMineModel.flMineIssueNumbersRelayStr :@"0", _flMyReceiveInMineModel.flfloatStr ? _flMyReceiveInMineModel.flfloatStr :@"0",str ? str : @"0"];
    for (NSInteger i = 0; i < self.flNumberArray.count; i++)
    {
        CGFloat numX = view_topMargin* 3 + i * view_numberWith ;
        CGFloat numY = flprogressViewFrame.origin.y + view_topMargin * 2;
        CGFloat numW = image_numberW;
        CGFloat numH = image_numberW;
        UIView* numberView = [[UIView alloc] initWithFrame:CGRectMake(numX, numY, view_numberWith, view_numberHeight)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((view_numberWith / 2) - numW / 2, 0, numW, numH)];
        FLGrayLabel* label = [[FLGrayLabel alloc] initWithFrame:CGRectMake(0, numH + view_numberMargin, view_numberWith, label_numberH)];
        label.font = [UIFont fontWithName:FL_FONT_NAME size:view_font_M];
        label.text = self.flNumberArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        FLGrayLabel* numberLabel = [[FLGrayLabel alloc] initWithFrame:CGRectMake(0, numH + label_numberH + view_numberMargin * 2 , view_numberWith, number_numberH)];
        numberLabel.text = numberModelArray[i];
        numberLabel.tag = xj_label_tag +i;
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont fontWithName:FL_FONT_NUMBER_NAME size:view_font_M];
        imageView.image = [UIImage imageNamed:fllogoArray[i]];
        [numberView addSubview:imageView];
        [numberView addSubview:label];
        [numberView addSubview:numberLabel];
        
        [self.flBackBaseview addSubview:numberView];
    }
    
    //底部细线
    Viewframe = flprogressViewFrame;
    Viewframe.origin.x = 0;
    Viewframe.origin.y += view_numberHeight + view_topMargin;
    Viewframe.size.width = FLUISCREENBOUNDS.width;
    Viewframe.size.height = 1;
    self.flUnderLineView = [[UIView alloc] initWithFrame:Viewframe];
    self.flUnderLineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    //查看详情
    Viewframe.origin.y += 1;
    Viewframe.size.height = view_check_detail_H;
    
    self.flCheckDetailBtn.frame = Viewframe;
    [self.flCheckDetailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    //    [self.flCheckDetailBtn addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
    [self.flCheckDetailBtn setTitleColor:[UIColor colorWithHexString:XJ_FCOLOR_REDFONT] forState:UIControlStateNormal];
    self.flCheckDetailBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:view_font_L];
    
    
    [self addviewInMyIssueControlView];
}

//- (void)testAction
//{
//    FL_Log(@"test in detail cell for test");
//}

- (void)addviewInMyIssueControlView
{
    //    [self addSubview:self.flScrollView];
    //    [self.flScrollView addSubview:self.flBackBaseview];
    //    [self.flBackBaseview addSubview:self.flMyBackGroundImageView];  //图
//    [self.flBackBaseview addSubview:_cycleScrollView2];
    [self.flBackBaseview addSubview:self.flTitleLabel];
    [self.flBackBaseview addSubview:self.flIntroduceLabel];
    [self.flBackBaseview addSubview:self.flAddressLogoImageView];
    [self.flBackBaseview addSubview:self.flAddressLabel];
    [self.flBackBaseview addSubview:self.flTimeLogoImageView];
    [self.flBackBaseview addSubview:self.flTimeLabel];
    //    [self.flBackBaseview addSubview:self.flProgressView];
    [self.flBackBaseview addSubview:self.flUnderLineView];
    [self.flBackBaseview addSubview:self.flCheckDetailBtn];
    [self setInfoInMyIssueControlView];
    
    //test
    
    
}

- (void)setInfoInMyIssueControlView
{
    self.flTitleLabel.text = _flMyReceiveInMineModel.flMineTopicThemStr;
    //    self.flIntroduceLabel.text = _flMyReceiveInMineModel.flMineIssueTopicConditionStr;
    self.flAddressLogoImageView.image = [UIImage imageNamed:@"adress_btn"];
    self.flAddressLabel.text =  _flMyReceiveInMineModel.flMineTopicAddressStr.length !=0 ? _flMyReceiveInMineModel.flMineTopicAddressStr :@"在线";
    self.flTimeLogoImageView.image = [UIImage imageNamed:@"clock_btn"];
    self.flTimeLabel.text = [self returnTimeNeedWithBegan:_flMyReceiveInMineModel.flTimeBegan endTime:_flMyReceiveInMineModel.flTimeEnd];
    _cycleScrollView2.imageURLStringsGroup = _imagesURLStrings;
    
    NSString* str = [FLTool returnNumberWithStartTime:_flMyReceiveInMineModel.flTimeEnd serviceTime:_flMyReceiveInMineModel.flTimeService];
    if (_flMyReceiveInMineModel.flMineIssueNumbersReadStr && _flMyReceiveInMineModel.flMineIssueNumbersRelayStr && _flMyReceiveInMineModel.flfloatStr && str) {
        NSArray* numberModelArray = @[_flMyReceiveInMineModel.flMineIssueNumbersReadStr,_flMyReceiveInMineModel.flMineIssueNumbersRelayStr, _flMyReceiveInMineModel.flfloatStr,str];
        for (NSInteger i = 0; i < self.flNumberArray.count; i++) {
            FLGrayLabel* xjlabel =  [self viewWithTag: xj_label_tag +i];
            xjlabel.text = numberModelArray[i];
        }
    }
    [self.flProgressView setProgress:[_flMyReceiveInMineModel.flfloatNumberStr floatValue]];
}



- (NSString*)returnTimeNeedWithBegan:(NSString*)timeB endTime:(NSString*)timeE
{
    NSString* str = nil;
    FL_Log(@"timeb.length =%lu",(unsigned long)timeB.length);
    NSString* timeBA = [timeB substringWithRange:NSMakeRange(0,4)];
    NSString* timeBO = [timeB substringWithRange:NSMakeRange(5,2)];
    NSString* timeBS = [timeB substringWithRange:NSMakeRange(8, 2)];
    NSString* timeBT = [timeB substringWithRange:NSMakeRange(10, 6)];
    timeB = [NSString stringWithFormat:@"%@/%@/%@ %@",timeBA,timeBO,timeBS,timeBT];
    FL_Log(@"timeb = %@",timeB);
    FL_Log(@"timeb.length =%lu",(unsigned long)timeB.length);
    NSString* timeEA = [timeE substringWithRange:NSMakeRange(0,4)];
    NSString* timeEO = [timeE  substringWithRange:NSMakeRange(5,2)];
    NSString* timeES = [timeE  substringWithRange:NSMakeRange(8, 2)];
    NSString* timeET = [timeE  substringWithRange:NSMakeRange(10, 6)];
    timeE = [NSString stringWithFormat:@"%@/%@/%@ %@",timeEA,timeEO,timeES,timeET];
    FL_Log(@"timeb = %@",timeE);
    str = [NSString stringWithFormat:@"%@-%@",timeB ,timeE];
    
    return str;
}




@end









