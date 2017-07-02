//
//  FLMyIssueActivityControlView.m
//  FreeLa
//
//  Created by Leon on 16/1/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyIssueActivityControlView.h"
#import "FLMyIssueControlDetailViewController.h"

#define view_imageHieght        FLUISCREENBOUNDS.width //xj_image_view_H//FLUISCREENBOUNDS.width     //图片高
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
#define xj_Label_Tag           10101
#define xj_offbtn_W         80

#define image_numberW           30      //图标宽度/高度
#define label_numberH           18      //阅读数label高度
#define number_numberH          18      //阅读数高度
#define view_numberMargin       3       //阅读数中间高度
#define view_numberWith         ((FLUISCREENBOUNDS.width - view_leftMarginW * 6) / 4)     //阅读数的宽度
#define view_numberHeight     view_topMargin + image_numberW + label_numberH + number_numberH + view_numberMargin * 3

#define total_H              xj_image_view_H + view_titleLabel_H  + view_addressLabel_H + view_timeLabel_H + view_numberHeight + view_check_detail_H +  view_topMargin * 6



@interface FLMyIssueActivityControlView ()<SDCycleScrollViewDelegate>
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
@implementation FLMyIssueActivityControlView

- (instancetype)initWithModel:(FLMyIssueInMineModel *)flMyIssueInMineModel
{
    self = [super init];
    if (self) {
        if (FLUISCREENBOUNDS.width <=320) {
            xj_image_view_H = (FLUISCREENBOUNDS.width *0.65);
        } else {
            xj_image_view_H = (FLUISCREENBOUNDS.width *0.7);
        }
        _flMyIssueInMineModel = flMyIssueInMineModel;
        Viewframe = CGRectZero;
        Viewframe.origin.x = 0;
        Viewframe.origin.y =  FL_TopColumnView_Height_S + StatusBar_NaviHeight;
        Viewframe.size.width = FLUISCREENBOUNDS.width;
        Viewframe.size.height = FLUISCREENBOUNDS.height - StatusBar_NaviHeight - TabBarHeight ;
        self.frame = Viewframe;
        [self requestImageArrayWithTopicId:_flMyIssueInMineModel.flMineIssueTopicIdStr];
        
        self.flCheckDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imagesURLStrings = [NSMutableArray array];
        self.flScrollView = [[UIScrollView alloc]init];
        [self xjAlloc];
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

- (void)setImagesURLStrings:(NSMutableArray *)imagesURLStrings {
    _imagesURLStrings = imagesURLStrings;
    _cycleScrollView2.imageURLStringsGroup = _imagesURLStrings;
    //     [self creatUIInMyIssueVCView];
    
}
- (void)xjAlloc {
    self.flBackBaseview = [[UIView alloc] init];
    self.flTitleLabel = [[UILabel alloc] init];
    self.flIntroduceLabel = [[FLGrayLabel alloc] init];
    self.flAddressLogoImageView = [[UIImageView alloc] init];
    self.flAddressLabel = [[FLGrayLabel alloc] init];
    self.flTimeLogoImageView = [[UIImageView alloc] init];
    self.flTimeLabel = [[FLGrayLabel alloc] init];
    self.flProgressView = [[UIProgressView alloc] init];
    self.xjOffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
}

- (void)creatUIInMyIssueVCView
{
    [self addSubview:self.flScrollView];
    [self.flScrollView addSubview:self.flBackBaseview];
    Viewframe.origin.y = 0;
    Viewframe.size.height = FLUISCREENBOUNDS.height - StatusBar_NaviHeight - TabBarHeight - FL_TopColumnView_Height_S;
    //背景
    self.flScrollView.frame = Viewframe;
    self.flScrollView.contentSize = CGSizeMake(FLUISCREENBOUNDS.width, total_H);
    self.flScrollView.showsVerticalScrollIndicator =NO;
    self.flScrollView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    backFrame = Viewframe;
    backFrame.size.height = total_H;
    self.flBackBaseview.frame =backFrame ;
    self.flBackBaseview.backgroundColor = [UIColor whiteColor];
    
    //图片
    Viewframe.origin.y = 0;
    Viewframe.size.height = FLUISCREENBOUNDS.width;
    //    self.flMyBackGroundImageView = [[UIImageView alloc] initWithFrame:Viewframe];
    //轮播
    _cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:Viewframe delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.flBackBaseview addSubview:_cycleScrollView2];
    
    
    /***底部**/
    self.xjBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, xj_image_view_H, FLUISCREENBOUNDS.width, self.flBackBaseview.frame.size.height - xj_image_view_H)];
    self.xjBottomView.backgroundColor = [UIColor whiteColor];
    [self.flBackBaseview addSubview:self.xjBottomView];
    
    
    //标题
    Viewframe.origin.x = view_leftMarginW;
    Viewframe.origin.y += view_topMargin + xj_image_view_H;
    Viewframe.size.height = view_titleLabel_H;
    Viewframe.size.width  = FLUISCREENBOUNDS.width - xj_offbtn_W;
    self.flTitleLabel.frame = Viewframe;
    self.flTitleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:view_font_L];
    
    //撤回按钮
    CGRect xjFrame = Viewframe;
    xjFrame.origin.x = FLUISCREENBOUNDS.width - xj_offbtn_W + 5;
    xjFrame.size.width= xj_offbtn_W - 10;
    self.xjOffBtn.frame = xjFrame;
    [self.xjOffBtn setTitle:@"撤回" forState:UIControlStateNormal];
    self.xjOffBtn.titleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_NORMAL];
    self.xjOffBtn.backgroundColor = XJ_COLORSTR(XJ_FCOLOR_REDBACK);
    self.xjOffBtn.layer.cornerRadius = self.xjOffBtn.frame.size.height / 2;
    self.xjOffBtn.layer.masksToBounds = YES;
    
    //描述
    //    Viewframe.origin.x +=
    self.flIntroduceLabel.frame = Viewframe ;
    self.flIntroduceLabel.font = [UIFont fontWithName:FL_FONT_NAME size:view_font_M];
    //地址logo
    logoFrame = Viewframe;
    logoFrame.origin.y += view_topMargin + view_introduceLabel_H;
    logoFrame.size.height = view_addressLabel_H;
    logoFrame.size.width  = view_addressLabel_H - 4;
    self.flAddressLogoImageView.frame = logoFrame;
    //地址
    Viewframe.origin.x += view_addressLabel_H + 5;
    Viewframe.origin.y += view_topMargin + view_introduceLabel_H;
    Viewframe.size.height = view_addressLabel_H;
    self.flAddressLabel.frame = Viewframe ;
    self.flAddressLabel.font = [UIFont fontWithName:FL_FONT_NAME size:view_font_M];
    //时间logo
    logoFrame.origin.y += view_topMargin + view_addressLabel_H;
    logoFrame.size.width = view_timeLabel_H;
    logoFrame.size.height = view_timeLabel_H;
    self.flTimeLogoImageView.frame =logoFrame ;
    //时间
    Viewframe.origin.y = logoFrame.origin.y;
    self.flTimeLabel.frame = Viewframe;
    self.flTimeLabel.font = [UIFont fontWithName:FL_FONT_NAME size:view_font_M];
    //进度条
    flprogressViewFrame = Viewframe;
    flprogressViewFrame.origin.x += view_leftMarginW;
    flprogressViewFrame.origin.y += view_topMargin * 2 + view_timeLabel_H;
    flprogressViewFrame.size.width = FLUISCREENBOUNDS.width - view_leftMarginW * 4;
    flprogressViewFrame.size.height = 5;
    self.flProgressView.layer.cornerRadius = XJ_PROGRESS_H/2;
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
    //    self.flProgressView.frame = flprogressViewFrame;
    //    self.flProgressView.centerX = self.centerX;
    self.flProgressView.tintColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
    //阅读数、分享数、参与进度、剩余天数
    self.flNumberArray = @[@"阅读数",@"分享数",@"参与进度",@"参与剩余时间"];
    NSArray* fllogoArray = @[@"iconfont_yuedu_gray",@"iconfont_fenxiang_gray",@"iconfont_renwujindushangsheng",@"iconfont_time_gray"];
    //时间相减,此处变更为剩余时间
    NSString* str = [FLTool returnNumberWithStartTime:_flMyIssueInMineModel.flTimeEnd serviceTime:_flMyIssueInMineModel.flTimeService];
    
    //    NSArray* numberModelArray = @[_flMyIssueInMineModel.flMineIssueNumbersReadStr,_flMyIssueInMineModel.flMineIssueNumbersRelayStr ? _flMyIssueInMineModel.flMineIssueNumbersRelayStr:@"0", _flMyIssueInMineModel.flfloatStr,str];
    NSArray* numberModelArray = @[_flMyIssueInMineModel.flMineIssueNumbersReadStr ? _flMyIssueInMineModel.flMineIssueNumbersReadStr:@"0",_flMyIssueInMineModel.flMineIssueNumbersRelayStr ? _flMyIssueInMineModel.flMineIssueNumbersRelayStr:@"0", _flMyIssueInMineModel.flfloatStr ? _flMyIssueInMineModel.flfloatStr:@"",str ? str :@"s"];
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
        numberLabel.tag = xj_Label_Tag+ i;
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
    
    [self.flBackBaseview addSubview:self.flTitleLabel];
    [self.flBackBaseview addSubview:self.flIntroduceLabel];
    [self.flBackBaseview addSubview:self.flAddressLogoImageView];
    [self.flBackBaseview addSubview:self.flAddressLabel];
    [self.flBackBaseview addSubview:self.flTimeLogoImageView];
    [self.flBackBaseview addSubview:self.flTimeLabel];
    //    [self.flBackBaseview addSubview:self.flProgressView];
    [self.flBackBaseview addSubview:self.flUnderLineView];
    [self.flBackBaseview addSubview:self.flCheckDetailBtn];
    [self.flBackBaseview addSubview:self.xjOffBtn];
    [self setInfoInMyIssueControlView];
    
    //test
}

- (void)setInfoInMyIssueControlView
{
    self.flTitleLabel.text = _flMyIssueInMineModel.flMineTopicThemStr;
    //    self.flIntroduceLabel.text = _flMyIssueInMineModel.flMineIssueTopicConditionStr;
    self.flAddressLogoImageView.image = [UIImage imageNamed:@"adress_btn"];
    self.flAddressLabel.text =  _flMyIssueInMineModel.flMineTopicAddressStr.length!=0 ? _flMyIssueInMineModel.flMineTopicAddressStr:@"在线";
    self.flTimeLogoImageView.image = [UIImage imageNamed:@"clock_btn"];
    self.flTimeLabel.text = [self returnTimeNeedWithBegan:_flMyIssueInMineModel.flTimeBegan endTime:_flMyIssueInMineModel.flTimeEnd];
    
    _cycleScrollView2.imageURLStringsGroup = _imagesURLStrings;
}

- (void)setFlMyIssueInMineModel:(FLMyIssueInMineModel *)flMyIssueInMineModel {
    _flMyIssueInMineModel = flMyIssueInMineModel;
    [self setInfoInMyIssueControlView];
    NSString* str = [FLTool returnNumberWithStartTime:_flMyIssueInMineModel.flTimeEnd serviceTime:_flMyIssueInMineModel.flTimeService];
    if (_flMyIssueInMineModel.flMineIssueNumbersReadStr && _flMyIssueInMineModel.flMineIssueNumbersRelayStr && _flMyIssueInMineModel.flfloatStr && str) {
        NSArray* numberModelArray = @[_flMyIssueInMineModel.flMineIssueNumbersReadStr,_flMyIssueInMineModel.flMineIssueNumbersRelayStr, _flMyIssueInMineModel.flfloatStr,str];
        for (NSInteger i = 0; i < self.flNumberArray.count; i++) {
            FLGrayLabel* xjlabel =  [self viewWithTag:xj_Label_Tag + i];
            xjlabel.text = numberModelArray[i];
        }
    }
    [self.flProgressView setProgress:[_flMyIssueInMineModel.flfloatNumberStr floatValue]];
}


- (NSString*)returnTimeNeedWithBegan:(NSString*)timeB endTime:(NSString*)timeE
{
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










