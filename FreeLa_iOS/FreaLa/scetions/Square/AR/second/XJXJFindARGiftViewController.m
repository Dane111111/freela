//
//  XJXJFindARGiftViewController.m
//  FreeLa
//
//  Created by Collegedaily on 2017/5/2.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJXJFindARGiftViewController.h"
#import "FINCamera.h"
#import "FLMyReceiveListModel.h"
#import <CoreMotion/CoreMotion.h>
#import "XJSaoChangePlaceSecondView.h"
#import "XJCircleAnimationView.h"
#import "XJARClickAnimationView.h"
#import "BearCutOutView.h"
#import "LewPopupViewController.h"
#import "XJVersionTPickSuccessView.h"
#import "XJFreelaUVManager.h"
#import "XJGiftAddReceiveInfoView.h"
#import "XJHFiveCallLocationJsController.h"
#import "XJXJScanViewController.h"

@interface XJXJFindARGiftViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,FINCameraDelagate,UIAccelerometerDelegate,SDCycleScrollViewDelegate,NSURLSessionDelegate>
{
    CMMotionManager *manager;
    NSMutableArray* _dataSource;
    NSMutableArray* _imageViewArr;
    BOOL _xjisCilckBtn;
    NSInteger _xjSelectedIndex;
    BOOL _xjIsXianSuoClicked;
    
}
@property (strong, nonatomic) UIButton *flGoBackBtn;
@property(nonatomic,strong)FINCamera * camera;

/**换个地方的背景*/
@property (nonatomic , strong) XJSaoChangePlaceSecondView* xjChangePlaceView;

/**轮播*/
@property (nonatomic , strong) SDCycleScrollView *cycleScrollView2;

/**显示线索图的view*/
@property (nonatomic , strong) UIView* xjXianSuoView;

@property (nonatomic , strong) UIImageView* xjXianSuoImgView;
@property (nonatomic , strong) XJCircleAnimationView * centerRadarView;

@property (nonatomic , strong) XJARClickAnimationView* xjClickView;


//
@property (nonatomic , strong) NSString* xj_compareCode;
@property (nonatomic , strong) NSString* xj_topicId;
/**挖圆背景*/
@property (nonatomic , strong) BearCutOutView *cutOutView_2;
/**领取模型*/
@property (nonatomic , strong) FLMyReceiveListModel* flmyReceiveMineModel;
/**动画*/
@property (nonatomic , strong) UIImageView* xj_searchGiftDoneImgView;
/**动画需要的数组*/
@property (nonatomic , strong) NSArray* xj_GiftDoneImgViewArr;
/**添加在动画中间的button*/
@property (nonatomic , strong) UIButton* xj_allBtn;

@property (nonatomic , strong) UIButton* xjBottomBtn;

@property (nonatomic , strong) UILabel* xjTipLabel;

@property (nonatomic , strong) UILabel* xjTitleLabel;
@property(nonatomic,retain)NSMutableData*HTMLdata;
@end

@implementation XJXJFindARGiftViewController
{
    NSInteger xj_needi; //动画需要的 值
    
    NSTimer*  _xj_need_timer; //聚焦计时器
    NSInteger _xj_timer_needi;     //聚焦计时
    
    BOOL _xj_is_open_timer;//是否需要开启timer
    
    NSInteger xj_sao_bugi;//设定两次扫描 不成功
    UIImage* xj_compareImg; //线索图片，需要对比的网络图
    UIImage* xj_VideoImg; //视频流 取出 的图片
    
    
    NSString*_FLFLHTML_topId;
}
- (FLMyReceiveListModel *)flmyReceiveMineModel {
    if (!_flmyReceiveMineModel) {
        _flmyReceiveMineModel = [[FLMyReceiveListModel alloc] init];
    }
    return _flmyReceiveMineModel;
}

- (UILabel *)xjTipLabel {
    if (!_xjTipLabel) {
        _xjTipLabel = [[UILabel alloc] init];
        _xjTipLabel.frame = CGRectMake(FLUISCREENBOUNDS.width / 2  - 80, self.xjClickView.mj_y + self.xjClickView.mj_h + 60, 160, 24);
        _xjTipLabel.text = @"点击屏幕按照线索提示寻宝";
        _xjTipLabel.layer.cornerRadius = 12;
        _xjTipLabel.layer.masksToBounds = YES;
        _xjTipLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
        _xjTipLabel.textColor = [UIColor whiteColor];
        _xjTipLabel.textAlignment = NSTextAlignmentCenter;
        _xjTipLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    return _xjTipLabel;
}
- (UILabel *)xjTitleLabel {
    if (!_xjTitleLabel) {
        _xjTitleLabel = [[UILabel alloc] init];
        _xjTitleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
        _xjTitleLabel.textColor = [UIColor whiteColor];
        _xjTitleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _xjTitleLabel.frame = CGRectMake(FLUISCREENBOUNDS.width / 2  - 120, 150, 0, 22);
        _xjTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xjTitleLabel;
}
- (UIButton *)xjBottomBtn {
    if (!_xjBottomBtn) {
        _xjBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xjBottomBtn.frame = CGRectMake(20, FLUISCREENBOUNDS.height - 60, 40, 40);
        [_xjBottomBtn setBackgroundImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
        [_xjBottomBtn addTarget:self action:@selector(xj_popGoBackBottom) forControlEvents:UIControlEventTouchUpInside];
        _xjBottomBtn.hidden = YES;
    }
    return _xjBottomBtn;
}
- (SDCycleScrollView *)cycleScrollView2 {
    if (!_cycleScrollView2) {
        CGRect Viewframe = CGRectMake(FLUISCREENBOUNDS.width/2 - 50, 40, 100, 100);
        _cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:Viewframe delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
//        _cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView2.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
//        _cycleScrollView2.currentPageDotColor = [[UIColor whiteColor] colorWithAlphaComponent:0]; // 自定义分页控件小圆标颜色
        _cycleScrollView2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
//        _cycleScrollView2.autoScroll = NO;
    }
    return _cycleScrollView2;
}

- (XJSaoChangePlaceSecondView *)xjChangePlaceView {
    if (!_xjChangePlaceView) {
        _xjChangePlaceView = [[XJSaoChangePlaceSecondView alloc] init];
        _xjChangePlaceView.hidden = YES;
    }
    return _xjChangePlaceView;
}
- (UIButton *)flGoBackBtn {
    if (!_flGoBackBtn) {
        _flGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flGoBackBtn.frame = CGRectMake(20, 20, 40, 40);
        [_flGoBackBtn setBackgroundImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
        [_flGoBackBtn addTarget:self action:@selector(xj_popGoBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flGoBackBtn;
}
- (UIImageView *)xjXianSuoImgView {
    if (!_xjXianSuoImgView) {
        _xjXianSuoImgView = [[UIImageView alloc] init];
//        _xjXianSuoImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xjXianSuoImgView;
}
- (UIView *)xjXianSuoView {
    if (!_xjXianSuoView) {
        _xjXianSuoView = [[UIView alloc] init];
        //线索的细线
        UIView* line = [[UIView alloc] init];
        [_xjXianSuoView addSubview:line];
        line.frame = CGRectMake(29, 0, 2, 60);
        line.backgroundColor = [UIColor whiteColor];
        
        _xjXianSuoView.frame = CGRectMake(FLUISCREENBOUNDS.width - 90, 0, 60, 120);
        
        //xiansuo
//        _xjXianSuoImgView = [[UIImageView alloc] init];
        self.xjXianSuoImgView.frame = CGRectMake(0, 55, 60, 60);
        self.xjXianSuoImgView.layer.cornerRadius = _xjXianSuoImgView.height/2;
        _xjXianSuoImgView.layer.masksToBounds = YES;
//        _xjXianSuoImgView.backgroundColor = [UIColor redColor];
        [_xjXianSuoView addSubview:_xjXianSuoImgView];
        _xjXianSuoImgView.userInteractionEnabled = YES;
        _xjXianSuoImgView.image = [UIImage imageNamed:@"ar_icon_xiansuo"];
        
        UITapGestureRecognizer* tapg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjxjClickXianSuo)];
        [_xjXianSuoImgView addGestureRecognizer:tapg];
        _xjXianSuoView.hidden = YES;
        
    }
    return _xjXianSuoView;
}
- (UIImageView *)xj_searchGiftDoneImgView {
    if (!_xj_searchGiftDoneImgView) {
        _xj_searchGiftDoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.width)];
        _xj_searchGiftDoneImgView.center = self.view.center;
    }
    return  _xj_searchGiftDoneImgView;
}
- (UIButton *)xj_allBtn {
    if (!_xj_allBtn) {
        _xj_allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xj_allBtn.frame = CGRectMake((FLUISCREENBOUNDS.width-200)/2, (FLUISCREENBOUNDS.height-200)/2, 200, 200);
        //        _xj_allBtn.hidden = YES;
        [_xj_allBtn addTarget:self action:@selector(xj_clickToPick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xj_allBtn;
}

- (XJARClickAnimationView *)xjClickView {
    if (!_xjClickView) {
        CGRect frame = CGRectMake(FLUISCREENBOUNDS.width / 2 - 100, FLUISCREENBOUNDS.height /2 - 100, 200, 200);
        _xjClickView = [[XJARClickAnimationView alloc] initWithFrame:frame];
    }
    return _xjClickView;
}
- (XJCircleAnimationView *)centerRadarView {
    if (!_centerRadarView) {
        _centerRadarView = [[XJCircleAnimationView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.width)];
        _centerRadarView.center = CGPointMake(self.view.centerX, self.view.centerY -20);
        _centerRadarView.hidden = YES;
    }
    return _centerRadarView;
}
- (void)xjxjClickXianSuo {
    _xjIsXianSuoClicked = !_xjIsXianSuoClicked;
    
    FLMyReceiveListModel* model = _dataSource[_xjSelectedIndex];
    self.xj_topicId = model.flMineIssueTopicIdStr;
    if (!_xjIsXianSuoClicked) {
        self.xjXianSuoImgView.image = [UIImage imageNamed:@"ar_icon_xiansuo"];
    } else {
        [self.xjXianSuoImgView sd_setImageWithURL:[NSURL URLWithString:model.xj_xiansuotuStr]];
    }

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.isHtmlPop) {
        [self xj_clickToShowPickSuccess];
        self.isHtmlPop=NO;
    }
    
    for (UIViewController*ctr in [self.navigationController childViewControllers]) {
        if ([ctr isKindOfClass:[XJXJScanViewController class]]) {
            XJXJScanViewController* scCtr=(XJXJScanViewController*)ctr;
            scCtr.isHtmlPop=NO;
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnterBackGround)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    

    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _xjisCilckBtn = NO;
    _xjIsXianSuoClicked = NO;
    _xjSelectedIndex = 0;
    [self openCamera];
    // Do any additional setup after loading the view.
    _dataSource = @[].mutableCopy; 
    _imageViewArr = @[].mutableCopy;
    [self xjFetchData];
    [self.view addSubview:self.flGoBackBtn];
    [self.view addSubview:self.xjXianSuoView];
    [self.view addSubview:self.centerRadarView];
    [self.view addSubview:self.xjClickView];
    [self.view addSubview:self.xjTitleLabel];
//    [self.view addSubview:self.xjBottomBtn];
    [self.view addSubview:self.xjTipLabel];
    
    //其他view
    [self xjCreatOterView];
    
    __weak XJXJFindARGiftViewController* weakSelf = self;
    [self.xjChangePlaceView xjClickToReSao:^{
        [weakSelf xj_ChangeSaoStatus:YES];
    }];

    //手动滚
    self.cycleScrollView2.xjScrollViewDidScroll = ^(NSInteger xjIndex) {
        FL_Log(@"thisi is is sthe index =【%ld】",xjIndex);
        _xjSelectedIndex = xjIndex;
        if (_dataSource.count > _xjSelectedIndex) {
            FLMyReceiveListModel* model = _dataSource[_xjSelectedIndex];
            weakSelf.xj_topicId = model.flMineIssueTopicIdStr;
            if (!_xjIsXianSuoClicked) {
                weakSelf.xjXianSuoImgView.image = [UIImage imageNamed:@"ar_icon_xiansuo"];
            } else {
                [weakSelf.xjXianSuoImgView sd_setImageWithURL:[NSURL URLWithString:model.xj_suolvetuStr]];
            }
            [weakSelf xjSettingTileLabel:model.flMineTopicThemStr];
        }
    };
    
    
    
}
- (void)appHasGoneInForeground{
    [self.camera endSession];
    [self.camera startSession];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.camera startSession];
    });
    
}

- (void)appEnterBackGround{
    [self.camera endSession];
}

- (void)xjCreatOterView {
    __weak XJXJFindARGiftViewController *weakSelf = self;
    self.xjClickView.xjClickBtn = ^{
        [weakSelf xjClickBtnClicked];
    };
}

- (void)xjClickBtnClicked {
    if (_dataSource.count == 0) {
        [FLTool showWith:@"暂无可领取的活动"];
        return ;
    }
    
    _xjisCilckBtn = YES;
    self.xjClickView.hidden = YES;
    self.xjXianSuoView.hidden = NO;
    self.centerRadarView.hidden = NO;
    [self.centerRadarView xj_circleStart];
    self.cycleScrollView2.autoScroll = NO;
    _xj_is_open_timer = YES;
    [self xjTimerStart];
    [self xj_ChangeSaoStatus:YES];
    self.xjBottomBtn.hidden = NO;
    self.xjTipLabel.hidden = YES;
    self.xjTitleLabel.hidden = YES;
    
    self.cycleScrollView2.hidden = YES;
    
    if (_dataSource.count!=0) {
        FLMyReceiveListModel* model = _dataSource[_xjSelectedIndex];
        self.xj_topicId = model.flMineIssueTopicIdStr;
        if (!_xjIsXianSuoClicked) {
            self.xjXianSuoImgView.image = [UIImage imageNamed:@"ar_icon_xiansuo"];
        } else {
            [self.xjXianSuoImgView sd_setImageWithURL:[NSURL URLWithString:model.xj_xiansuotuStr]];
        }
    }else {
        [FLTool showWith:@"暂无可领取的活动"];
    }
    
//    self.cycleScrollView2.
    
}
- (void)xj_popGoBack {
    if (_xjisCilckBtn) {
        _xjisCilckBtn = NO;
        
        [self xj_start];
        
        if (_xj_searchGiftDoneImgView) {
            //            [_xj_searchGiftDoneImgView removeFromSuperview];
            
            [_xj_searchGiftDoneImgView removeFromSuperview];
            _xj_searchGiftDoneImgView = nil;
            _xj_searchGiftDoneImgView.animationImages = nil;
            //            [self xj_stop];
            xj_needi = 0;
            //            [self xj_start];
        }
        
        if (self.xj_allBtn) {
            [self.xj_allBtn removeFromSuperview];
        }
//        for ( FLMyReceiveListModel*model  in _dataSource) {
//            if ([model.flMineIssueTopicIdStr integerValue] ==[self.flmyReceiveMineModel.flMineIssueTopicIdStr integerValue]) {
//                [_dataSource removeObject:model];
//                break;
//            }
//        }

        
        //        self.xjXianSuoImgView.image = [UIImage imageNamed:@"ar_icon_xiansuo"];
        _xjIsXianSuoClicked = !_xjIsXianSuoClicked;
        self.centerRadarView.hidden = YES;
        self.xjXianSuoView.hidden = YES;
        
        self.cycleScrollView2.autoScroll = _dataSource.count >1? YES: NO;
        self.xjClickView.hidden = NO;
        [self xjTimerRemove];
        self.xjTipLabel.hidden = _dataSource.count ==0? YES: NO;
        self.cycleScrollView2.hidden = _dataSource.count ==0? YES: NO;
        self.xjTitleLabel.hidden = _dataSource.count ==0? YES: NO;
        if (_dataSource.count) {
            [self xjImageInit];

        }
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.xjChangePlaceView) {
        self.xjChangePlaceView.hidden = YES;
    }

//    if (_xjisCilckBtn) {
//        _xjisCilckBtn = NO;
//        self.centerRadarView.hidden = YES;
//        self.xjXianSuoView.hidden = YES;
//        self.cycleScrollView2.autoScroll = YES;
//        self.xjClickView.hidden = NO;
//        [self xjTimerRemove];
//        self.xjTipLabel.hidden = _dataSource.count ==0? YES: NO;
//        self.cycleScrollView2.hidden = NO;
//        self.xjTitleLabel.hidden = NO;
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    if (self.xjChangePlaceView) {
//        self.xjChangePlaceView.hidden = YES;
//    }
    
}

- (void)xj_popGoBackBottom{
    self.centerRadarView.hidden = YES;
    self.xjXianSuoView.hidden = YES;
    self.cycleScrollView2.autoScroll = YES;
    self.xjClickView.hidden = NO;
    [self xjTimerRemove];
    self.xjBottomBtn.hidden = YES;
    self.xjTipLabel.hidden = NO;
}
#pragma  mark  ----------------------------切换扫描结果状态
- (void)xj_ChangeSaoStatus:(BOOL)sao {
    [_xj_need_timer invalidate];
    _xj_need_timer = nil;
    if (sao) {
        [self xj_start];
        [self xjTimerStart];
    }
    self.centerRadarView.hidden = !sao;
    self.cutOutView_2.hidden = !sao;
    self.xjChangePlaceView.hidden = sao;
    
}
#pragma mark - 相机
- (void)openCamera {
    __weak XJXJFindARGiftViewController* weakSelf = self;
    self.camera =[FINCamera createWithBuilder:^(FINCamera *builder) {
        // input
        [builder useBackCamera];
        // output
        [builder useVideoDataOutputWithDelegate:weakSelf];
        // delegate
        [builder setDelegate:weakSelf];
        // setting
        [builder setPreset:AVCaptureSessionPresetPhoto];
    }];
    [self.camera startSession];
    //    [self.view addSubview:[self.camera previewWithFrame:self.view.frame]];
    UIView* view = [self.camera previewWithFrame:self.view.frame];
    view.userInteractionEnabled = YES;
    [self.view insertSubview:view atIndex:0];
    
    //添加 界面
    [self.view addSubview:self.xjChangePlaceView]; //换个地方
    
    //    UIImageView *cover = [[UIImageView alloc] initWithFrame:self.view.frame];
    //    cover.image = [UIImage imageNamed:@"cover"];
    //    [self.view addSubview:cover];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    //    NSLog(@"??????==%ld",_xj_needi);
    if (_xj_timer_needi==3) {
        xj_VideoImg = image;
        [self xj_stop];
    }
}
-(void)camera:(FINCamera *)camera adjustingFocus:(BOOL)adjustingFocus{
//        NSLog(@"%@",adjustingFocus?@"正在对焦":@"对焦完毕");
}
- (void)xjFetchData{
    [_dataSource removeAllObjects];
    NSDictionary* parm = @{@"userid":XJ_USERID_WITHTYPE};
    [FLNetTool xjGetSkyGiftpResultsFromServer:parm success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray* arr = data[FL_NET_DATA_KEY];
            if (arr.count!=0) {
                for (NSDictionary* dic in arr) {
                    FLMyReceiveListModel* model = [self returnModelForTicketsWithData:dic];
                    [_dataSource addObject:model];
                }
            }
            if (_dataSource.count!=0) {
                [self xjImageInit];
            } else {
                self.xjTitleLabel.hidden = YES;
                if (self.cycleScrollView2) {
                    [self.cycleScrollView2 removeFromSuperview];
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void) xjImageInit{
    
    if (self.cycleScrollView2) {
        [self.cycleScrollView2 removeFromSuperview];
    }
    [self.view addSubview:self.cycleScrollView2];
    
    NSMutableArray * arr = @[].mutableCopy;
    for (FLMyReceiveListModel* model in  _dataSource) {
        [arr addObject:model.xj_suolvetuStr];
    }
    self.cycleScrollView2.imageURLStringsGroup = arr.mutableCopy;
    if (_dataSource.count!=0) {
        FLMyReceiveListModel* model = _dataSource[0];
        [self xjSettingTileLabel:model.flMineTopicThemStr];
    }
}
- (void)xjSettingTileLabel:(NSString*)str {
    self.xjTitleLabel.text = str?str:@"";
    [self.xjTitleLabel sizeToFit];
    self.xjTitleLabel.mj_w += 10;
    self.xjTitleLabel.mj_h += 6;
    self.xjTitleLabel.centerX = FLUISCREENBOUNDS.width / 2;
    self.xjTitleLabel.layer.cornerRadius = self.xjTitleLabel.mj_h / 2;
    self.xjTitleLabel.layer.masksToBounds = YES;
}
- (FLMyReceiveListModel*)returnModelForTicketsWithData:(NSDictionary*)data {
    FLMyReceiveListModel* model = [[FLMyReceiveListModel alloc] init];
    self.flmyReceiveMineModel=model;

    model.flIntroduceStr = data[@"topicExplain"];
    model.flMineIssueTopicIdStr = data[@"topicId"];
    model.xjCreator = [data[@"creator"] integerValue];
    model.xjUserId = [data[@"userId"] integerValue];
    model.flTimeBegan = data[@"startTime"];
    model.xjinvalidTime = data[@"invalidTime"];
    model.xjUrl = data[@"url"];
    model.xjUserType = data[@"userType"];
//        NSString* suolve = data[@"sitethumbnail"];
//        if ([XJFinalTool xjStringSafe:suolve]) {
//            if (![suolve hasSuffix:@".gif"]&&![suolve hasSuffix:@".mp4"]) {
//                model.xj_suolvetuStr = suolve;
//            }
//    
//        }
    model.flMineTopicThemStr = data[@"topicTheme"];
    model.xj_xiansuotuStr = data[@"detailchart"];
    NSString* ad = data[@"thumbnail"];
    FL_Log(@"dsadsafsadsad===【%@】",ad);
    model.createTime = data[@"createTime"];
    
    //缩略图
    NSString* suolve  = data[@"thumbnail"];
    if ([XJFinalTool xjStringSafe:suolve]) {
        NSString* type  = data[@"userType"];
        if ([suolve rangeOfString:@"http"].location==NSNotFound) {
            model.xj_suolvetuStr = [NSString stringWithFormat:@"http://123.57.35.196:9090/CJH/freela/resources/static/topic/%@/%ld/%@",type,model.xjUserId,suolve];

        }else{
            model.xj_suolvetuStr=suolve;
        }
    }
    //线索图
    NSString* xiansuo  = data[@"detailchart"];
    if ([XJFinalTool xjStringSafe:xiansuo]) {
        NSString* type  = data[@"userType"];
        if ([xiansuo rangeOfString:@"http"].location==NSNotFound) {
            model.xj_xiansuotuStr = [NSString stringWithFormat:@"http://123.57.35.196:9090/CJH/freela/resources/static/topic/%@/%ld/%@",type,model.xjUserId,xiansuo];

        }else{
            model.xj_xiansuotuStr=xiansuo;
        }
    }
    model.pictureCode = data[@"pictureCode"];
    return model;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {

    if (!_xjisCilckBtn) {
        _xjSelectedIndex = index;
        FL_Log(@"selected index = 【%ld】",index);
        if (_dataSource.count >= _xjSelectedIndex +1) {
            FLMyReceiveListModel* model = _dataSource[_xjSelectedIndex];
            self.xj_topicId = model.flMineIssueTopicIdStr;
            if (!_xjIsXianSuoClicked) {
                self.xjXianSuoImgView.image = [UIImage imageNamed:@"ar_icon_xiansuo"];
            } else {
                [self.xjXianSuoImgView sd_setImageWithURL:[NSURL URLWithString:model.xj_suolvetuStr]];
                [self xjSettingTileLabel:model.flMineTopicThemStr];
            }
        }
        
    } else{
        
    }
}
#pragma  mark ----------sssss
- (void)xj_stop {
    [self.camera endSession];
}
- (void)xj_start {
    [self.camera startSession];
}

#pragma  mark  ----------------------------request

- (void)xj_checkCodeStrWithImg:(UIImage*)img {
    //    AMapCloudPOI* xjpoi
    [self xjTimerSuspend];//暂停扫描
    BOOL  can_check=NO;
    /*
     UIImageView* all = [[UIImageView alloc] init];
     all.image = img;
     [self.view addSubview:all];
     all.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
     
     UIImageView* imageview = [[UIImageView alloc] init];
     [self.view addSubview:imageview];
     
     CGFloat imageW = 100;
     imageview.frame = CGRectMake(200, 200, imageW*2, imageW*2);
     
     CGFloat xjxjx = img.size.width / FLUISCREENBOUNDS.width;
     CGFloat xjxjy = img.size.height / FLUISCREENBOUNDS.height;
     
     CGFloat xjx = (img.size.width/2 - xjxjx*imageW);
     CGFloat xjy = img.size.height/2 - xjxjy*imageW;
     
     
     
     UIImage* testimage = [[XJFinalTool xj_fixOrientation:img] imageByCropToRect: CGRectMake(xjx, xjy, imageW*2, imageW*2)];
     //    UIImage* testimage = [XJFinalTool getSubImage:CGRectMake(xjx, xjy, 200, 200) img:img];
     imageview.image = testimage;
     
     UIImage* img111 = [UIImage imageNamed:@"test_compare"];
     double ssss = [XJImgCompare xjCompareImg:img andImg:img111];
     FL_Log(@"ssss=【%f】",ssss);
     */
    
    xj_sao_bugi +=1;
    if (xj_sao_bugi<3) {
        CGFloat xjff =  (arc4random() % 100);
        if (xjff>70) {
         
        }else{
            [self xj_ChangeSaoStatus:NO];
            return;
        }
    }
    
    NSString* xjstr = self.xj_compareCode;
    NSString* xjtopicid = self.xj_topicId;
    NSInteger jj= [XJFinalTool xj_compareWithString:xjstr andImg:img]; //对比图片出来的值
    
    FL_Log(@"jjjjj=【%ld】",jj);
    if (jj>50) {
        
    } else {
        FL_Log(@"jjjjj=【%ld】",jj);
        self.xj_topicId = xjtopicid;
        can_check = YES;
        
    }
    if (can_check) {
        [self xjTimerSuspend];
        [self xj_stop];
        [self checkTakeCanOrNot];
    } else {
        [self xj_ChangeSaoStatus:NO];//[self xjTimerStart];
    }
}
// 领取资格
- (void)checkTakeCanOrNot {
//        [self xj_testToShowOK];
    FL_Log(@"this web view begin to reload for test");
    //检查领取资格
    NSDictionary* parm = @{@"participate.topicId": self.xj_topicId,
                           @"participate.userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"participate.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,
                           @"participate.creator":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID};
    [FLNetTool checkReceiveInfoInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in check pi22ck topic =%@",data);
//        [self xj_testToShowOK];
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _xj_is_open_timer = NO;
            [self xj_testToShowOK];
        } else {
            [FLTool showWith:[NSString stringWithFormat:@"%@",data[@"msg"]]];
            _xj_is_open_timer = YES;
            [self xj_start];
            [self xj_ChangeSaoStatus:NO];
        }
    } failure:^(NSError *error) {
        _xj_is_open_timer = YES;
        [self xj_start];
        [self xj_ChangeSaoStatus:NO];
    }];
}
// 通过抽样缓存数据创建一个UIImage对象
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
}
#pragma  mark  ----------------------------切换领取完成状态
- (void)xj_ChangePickGiftDoneStatus {
    [_xj_need_timer invalidate];
    _xj_need_timer = nil;
    self.centerRadarView.hidden = YES;
    self.cutOutView_2.hidden = YES;
    self.xjChangePlaceView.hidden = YES;
}

- (void)xj_clickToShowPickSuccess{
    for ( FLMyReceiveListModel*model  in _dataSource) {
        if ([model.flMineIssueTopicIdStr integerValue] ==[self.flmyReceiveMineModel.flMineIssueTopicIdStr integerValue]) {
            [_dataSource removeObject:model];
            break;
        }
    }

    [self xj_ChangePickGiftDoneStatus];
    if (self.xj_allBtn) {
        [self.xj_allBtn removeFromSuperview];
    }
    __weak typeof(self) weakSelf = self;
    //领取陈宫界面
    XJVersionTPickSuccessView *view = [[XJVersionTPickSuccessView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width , FLUISCREENBOUNDS.height)];
    view.parentVC = weakSelf;
    FL_Log(@"dsadsafa=%@",self.flmyReceiveMineModel.flMineTopicThemStr);
    view.xj_TopicThemeL.text =  self.flmyReceiveMineModel.flMineTopicThemStr;
    
    if ([XJFinalTool xjStringSafe:self.flmyReceiveMineModel.xj_suolvetuStr]) {
        NSString* ss=self.flmyReceiveMineModel.xj_suolvetuStr;
        //判断路径的结尾是不是 .mp4
        if(![self.flmyReceiveMineModel.xj_suolvetuStr hasSuffix:@".mp4"]&& ![self.flmyReceiveMineModel.xj_suolvetuStr hasSuffix:@".gif"]){
            ss = [XJFinalTool xjReturnImageURLWithStr:self.flmyReceiveMineModel.xj_suolvetuStr
                                               isSite:NO];
        }
        
        view.xj_imgUrlStr = ss;
    }
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
    //点击完成
    [view xj_findGiftSuccessDone:^{
        [weakSelf lew_dismissPopupView];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
        weakSelf.navigationController.navigationBar.hidden = YES;
        [weakSelf xj_start];
        _xjisCilckBtn = YES;
        [weakSelf xj_popGoBack];
        
        //跳到票券页
        XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
        ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
        FL_Log(@"thi1s is te1h acti1on to push the page of ticke3t");
        [weakSelf.navigationController pushViewController:ticketVC animated:YES];
        if (weakSelf.xj_searchGiftDoneImgView) {
            [weakSelf.xj_searchGiftDoneImgView removeFromSuperview];
        }
        [weakSelf xj_stop];
    }];
}
#pragma mark -----------------------点击领取
- (void)xj_clickToPick{
    //先判断是否有领取信息
    [self getRequestDetailsOfTopicWithId:self.xj_topicId];
//    [self FLFLHTMLInsertParticipate];//canyu
    //[self FLFLHTMLHTMLsaveTopicClickOn];
}
#pragma mark ---------------------------- 动画
- (void)xj_testToShowOK {
    if(self.centerRadarView){[self.centerRadarView xj_done];}
    if (self.xjXianSuoView) {
        self.xjXianSuoView.hidden = YES;
    }
    NSMutableArray* xj = [NSMutableArray array];
    NSArray*arr=@[@"13",@"14",@"15",@"22",@"23",@"24",@"36",@"37",@"38",@"43",@"44",@"45"];
    for (NSString*number in arr) {
//        if (i<10) {
            //            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"合成 1_0000%ld",i]];
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ar_000%@",number] ofType:@"png"]];
            if (image) {
                [xj addObject:image];
            }
//        }else {
            //            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"合成 1_000%ld",i]];
//            UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ar_000%ld",i] ofType:@"png"]];
//            if (image) {
//                [xj addObject:image];
//            }
//        }
    }
    self.xj_GiftDoneImgViewArr = xj.mutableCopy;
    //    imageView.image = [UIImage animatedImageWithImages:xj duration:3];
    self.xj_searchGiftDoneImgView.animationImages = xj;
    _xj_searchGiftDoneImgView.animationRepeatCount = 1;
    
    _xj_searchGiftDoneImgView.animationDuration = xj.count * 0.08;
    [_xj_searchGiftDoneImgView startAnimating];
    [self.view addSubview:_xj_searchGiftDoneImgView];
    [self.view addSubview:self.xj_allBtn];
    [self performSelector:@selector(clearAinimationImageMemory) withObject:nil afterDelay:xj.count * 0.08];
    /*****************************************************************/
    xj_needi = -1;
    
    //    self.xj_animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(setNextImage) userInfo:nil repeats:YES];
}
- (void)clearAinimationImageMemory{
    [_xj_searchGiftDoneImgView stopAnimating];
    _xj_searchGiftDoneImgView.animationImages = nil;
    _xj_searchGiftDoneImgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ar_000%d",45] ofType:@"png"]];
}
#pragma  mark --- --------------------------------详情
- (void)getRequestDetailsOfTopicWithId:(NSString*)xjtopicid {
    if (!xjtopicid) {
        return;
    }
    NSDictionary* parm = @{@"topic.topicId":xjtopicid,
                           @"userType":XJ_USERTYPE_WITHTYPE,
                           @"userId":XJ_USERID_WITHTYPE,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:xjtopicid]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            FL_Log(@"thi si s the data of html 666666666666 =[%@]",data);
            [self returnModelForTicketsWithData:data[FL_NET_DATA_KEY]];
            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjtopicid];
            NSString* xj_parinfo = data[FL_NET_DATA_KEY][@"partInfo"];
            if ([XJFinalTool xjStringSafe:xj_parinfo]) {
//                [self  xj_showAddReceiveView];;//[self xjGetPartInfoList:xj_parinfo];//获取填写信息
                
                [self FLFLHTML2GetPartInfoListTopid:xjtopicid userId:XJ_USERID_WITHTYPE partInfo:data[@"data"][@"partInfo"]];

            }else{
                [self FLFLHTMLHTMLsaveTopicClickOn:@""];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)setFlDetailsIdStr:(NSString*)xjmsg{
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    NSString* xjUserId = FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID;
    NSString* xjCreator = FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID;
    if (!xjUserId  || !xjCreator) {
        xjUserId = @"";
        xjCreator = @"";
    }
    
    NSDictionary* parm = @{@"participateDetailes.topicId":self.xj_topicId,
                           @"participateDetailes.userId":xjUserId,
                           @"participateDetailes.userType":FLFLIsPersonalAccountType?FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"participateDetailes.message":xjmsg,
                           @"participateDetailes.creator":xjCreator,//FL_USERDEFAULTS_USERID_NEW,
                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID]};
    [FLNetTool HTMLsaveATopicInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"notifation with SAVE gift clickon = %@",data);
        if (!data) {
            [FLTool showWith:@"请求结果错误"];
            return ;
        }
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.flmyReceiveMineModel.flDetailsIdStr = data[@"detailsid"];
            //移除动画
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic =%@",error);
    }];
    
}
#pragma mark /获取回填信息
- (void)FLFLHTMLGetPartInfoListTopid:(NSString*)topid userId:(NSString*)userId  partInfo:(NSString*)partInfo{
    NSDictionary* parm =@{@"topic.userId":userId,
                          @"topic.partInfo":partInfo};
    [FLNetTool HTMLGetPartInfoListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"get partinfod success =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            
            XJHFiveCallLocationJsController*vc=[[XJHFiveCallLocationJsController alloc] initWithTopicId:topid];
            vc.flmyReceiveMineModel=self.flmyReceiveMineModel;
            vc.xjPartInfoArr=[data[@"data"] allKeys];
            vc.xjPushStyle=HFivePushStylePutInfoForTake;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
    } failure:^(NSError *error) {
    }];
}
- (void)FLFLHTML2GetPartInfoListTopid:(NSString*)topid userId:(NSString*)userId  partInfo:(NSString*)partInfo{
    _FLFLHTML_topId=topid;
    NSString* getURLStr = [[NSString stringWithFormat:@"%@/app/publishs!getUserReceiveInfo.action?d=%d",FLBaseUrl,randomNumber] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString*parameter=[NSString stringWithFormat:@"topic.userId=%@&topic.partInfo=%@",userId,partInfo];
    NSURL*getURL=[NSURL URLWithString:getURLStr];
    NSMutableURLRequest*request=[[NSMutableURLRequest alloc]init];
    request.URL=getURL;
    request.HTTPMethod=@"POST";
    request.timeoutInterval=60;
    request.HTTPBody=[parameter dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionConfiguration*conf=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession*session=[NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    NSURLSessionTask*task=[session dataTaskWithRequest:request];
    [task resume];

}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
//    [self.HTMLdata appendData:data];
    NSString*str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    str=[str stringByReplacingOccurrencesOfString:@"{"withString:@"["];
    str=[str stringByReplacingOccurrencesOfString:@"}"withString:@"]"];
    NSArray* array1 = [str componentsSeparatedByString:@":["];
    NSArray*array2=[array1[1] componentsSeparatedByString: @"],"];

    [self performSelectorOnMainThread:@selector(pushJSCtr:) withObject:array2[0] waitUntilDone:YES];

}
-(void)pushJSCtr:(NSString*)str{
    XJHFiveCallLocationJsController*vc=[[XJHFiveCallLocationJsController alloc] initWithTopicId:_FLFLHTML_topId];
    vc.xjPartInfoStr=str;
    vc.flmyReceiveMineModel=self.flmyReceiveMineModel;
    vc.xjPushStyle=HFivePushStylePutInfoForTake;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * __nullable cachedResponse))completionHandler{
//    NSString*str=[[NSString alloc]initWithData:self.HTMLdata encoding:NSUTF8StringEncoding];
//    NSDictionary*dic=[NSJSONSerialization JSONObjectWithData:self.HTMLdata options:NSJSONReadingMutableContainers error:nil];
//    [self performSelectorOnMainThread:@selector(setTabelView:) withObject:dic waitUntilDone:YES];
    
}

- (void)xj_getRequestDetailsOfTopicWithId:(NSString*)xjtopicid {
    if (!xjtopicid) {
        return;
    }
    NSDictionary* parm = @{@"topic.topicId":xjtopicid,
                           @"userType":XJ_USERTYPE_WITHTYPE,
                           @"userId":XJ_USERID_WITHTYPE,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:xjtopicid]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            FL_Log(@"thi si s the data of html 5=[%@]",data);
            [self xjreturnModelForTicketsWithData:data[FL_NET_DATA_KEY]];
            [self xj_clickToShowPickSuccess];
            [self xjFetchData];
//            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjtopicid];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)xjTimerStart{
    if (_xj_is_open_timer) {
        _xj_timer_needi=0;
        _xj_need_timer = nil;
        [_xj_need_timer invalidate];
        _xj_need_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self  selector:@selector(xj_waitJuJiao) userInfo:nil repeats:YES];
    }
}
//暂停
- (void)xjTimerSuspend{
    _xj_need_timer = nil;
    [_xj_need_timer invalidate];
    _xj_timer_needi=0;
}
- (void)xjTimerRemove{
    
    [_xj_need_timer setFireDate:[NSDate distantFuture]];
    _xj_timer_needi=-1;
    [_xj_need_timer invalidate];
    _xj_need_timer = nil;
    _xj_is_open_timer = NO;
}
//当设备移动
- (void)xj_deveiceDidMode :(NSNotification*)obj{
    if(_xj_is_open_timer){//是否需要开启timer
        _xj_timer_needi=0;
        
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma  mark ------------------------ 等待聚焦
- (void)xj_waitJuJiao {
    if (xj_needi==-1) {
        [_xj_need_timer invalidate];
        return;
    }
    _xj_timer_needi +=1;
    FL_Log(@"这里是等待聚焦 的状态【%ld】",_xj_timer_needi);
    if (_xj_timer_needi>3 && _xj_timer_needi<5) {
        [_xj_need_timer invalidate];
        _xj_need_timer = nil;
        [self takePhotoButtonClick:nil];
        _xj_timer_needi = 0;
    }
}
- (void)takePhotoButtonClick:(UIBarButtonItem *)sender {
    if (xj_VideoImg) {
        [self xj_checkCodeStrWithImg:xj_VideoImg];
    }
}
#pragma mark -------------------------直接领取
- (void)FLFLHTMLHTMLsaveTopicClickOn:(NSString*)xjmsg {
    if([XJFinalTool xj_is_forbidden]){ //如果被禁用
        [FLTool showWith:@"账号异常,请联系管理员"];
        return;
    }
    NSString* xjUserId = FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID;
    NSString* xjCreator = FLFLIsPersonalAccountType?FL_USERDEFAULTS_USERID_NEW:FLFLXJBusinessUserID;
    if (!xjUserId  || !xjCreator) {
        xjUserId = @"";
        xjCreator = @"";
    }
    
    NSDictionary* parm = @{@"participateDetailes.topicId":self.xj_topicId,
                           @"participateDetailes.userId":xjUserId,
                           @"participateDetailes.userType":FLFLIsPersonalAccountType?FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"participateDetailes.message":xjmsg,
                           @"participateDetailes.creator":xjCreator,//FL_USERDEFAULTS_USERID_NEW,
                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:FL_NET_SESSIONID]};
    [FLNetTool HTMLsaveATopicInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"notifation with SAVE gift clickon = %@",data);
        if (!data) {
            [FLTool showWith:@"请求结果错误"];
            return ;
        }
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            //self.flmyReceiveMineModel.flDetailsIdStr = data[@"detailsid"];
            self.flmyReceiveMineModel.flDetailsIdStr = data[@"detailsid"];
            //            [[FLAppDelegate share] showHUDWithTitile:@"操作成功" view:self.view delay:1 offsetY:0];
//            [self xj_getRequestDetailsOfTopicWithId:self.xj_topicId];
            NSString* xj_parinfo = @"NAME,TEL,ADDRESS";
            //            if ([XJFinalTool xjStringSafe:xj_parinfo]) {
            //                [self xjGetPartInfoList:xj_parinfo];//获取填写信息
            //            }else{
           
            //            }
            //移除动画
            
            [_xj_searchGiftDoneImgView removeFromSuperview];
            _xj_searchGiftDoneImgView = nil;
            _xj_searchGiftDoneImgView.animationImages = nil;
            [self xj_stop];
            [self xj_clickToShowPickSuccess];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic =%@",error);
    }];
}
- (void)xj_showAddReceiveView {
    __weak typeof(self) weakSelf = self;
    XJGiftAddReceiveInfoView* view = [[XJGiftAddReceiveInfoView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width*0.8, 400)];
    //    xjView.center = self.view.center;
    [view xj_ReturnReceiveInfo:^(NSString *xjReceiveInfo) {
        [weakSelf lew_dismissPopupView];
        [weakSelf performSelector:@selector(FLFLHTMLHTMLsaveTopicClickOn:) withObject:xjReceiveInfo afterDelay:1];
    }];
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
}
- (void)xjreturnModelForTicketsWithData:(NSDictionary*)data {
    //    FLMyReceiveListModel* model = [[FLMyReceiveListModel alloc] init];
    self.flmyReceiveMineModel.flIntroduceStr = data[@"topicExplain"];
    self.flmyReceiveMineModel.flMineIssueTopicIdStr = data[@"topicId"];
    self.flmyReceiveMineModel.xjCreator = [data[@"creator"] integerValue];
    self.flmyReceiveMineModel.xjUserId = [data[@"userId"] integerValue];
    self.flmyReceiveMineModel.flTimeBegan = data[@"startTime"];
    self.flmyReceiveMineModel.xjinvalidTime = data[@"invalidTime"];
    self.flmyReceiveMineModel.xjUrl = data[@"url"];
    self.flmyReceiveMineModel.xjUserType = data[@"userType"];
    NSString* suolve = data[@"thumbnail"];
    if ([XJFinalTool xjStringSafe:suolve]) {
        if (![suolve hasSuffix:@".gif"]&&![suolve hasSuffix:@".mp4"]) {
            self.flmyReceiveMineModel.xj_suolvetuStr = suolve;
        }
        
    }
    
    self.flmyReceiveMineModel.flMineTopicThemStr = data[@"topicTheme"];
    self.flmyReceiveMineModel.xj_xiansuotuStr = data[@"detailchart"];
    NSString* ad = data[@"thumbnail"];
    FL_Log(@"dsadsafsadsad===【%@】",ad);
    self.flmyReceiveMineModel.createTime = data[@"createTime"];
    
    //    //缩略图
    //    NSString* suolve  = data[@"thumbnail"];
    //    if ([XJFinalTool xjStringSafe:suolve]) {
    //        NSString* type  = data[@"userType"];
    //        self.flmyReceiveMineModel.xj_suolvetuStr = [NSString stringWithFormat:@"http://123.57.35.196:9090/CJH/freela/resources/static/topic/%@/%ld/%@",type,self.flmyReceiveMineModel.xjUserId,suolve];
    //    }
    //    //线索图
    //    NSString* xiansuo  = data[@"detailchart"];
    //    if ([XJFinalTool xjStringSafe:xiansuo]) {
    //        NSString* type  = data[@"userType"];
    //        self.flmyReceiveMineModel.xj_xiansuotuStr = [NSString stringWithFormat:@"http://123.57.35.196:9090/CJH/freela/resources/static/topic/%@/%ld/%@",type,self.flmyReceiveMineModel.xjUserId,xiansuo];
    //    }
    self.flmyReceiveMineModel.pictureCode = data[@"pictureCode"];
    
    //    return self.flmyReceiveMineModel;
}

@end










