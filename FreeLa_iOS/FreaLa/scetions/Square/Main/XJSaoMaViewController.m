//
//  XJSaoMaViewController.m
//  FreeLa
//
//  Created by Leon on 2017/1/9.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJSaoMaViewController.h"
#import <AVFoundation/AVFoundation.h>
// 作者自定义的View视图, 继承UIView
#import "XJShadowView.h"
#import "XJEmptyViewController.h"
//#import "Radar.h"
//#import "XJGiftPickSuccessView.h"
#import "XJVersionTPickSuccessView.h"
#import "LewPopupViewController.h"
#import "XJGiftMapViewController.h"
#import "XJCircleAnimationView.h"
#import "XJFreelaUVManager.h"
#import "XJGiftAddReceiveInfoView.h"
#import "BearCutOutView.h"
#import "XJSaoChangePlaceView.h"
#import "XJARSkyViewController.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define customShowSize CGSizeMake(200, 200);

@interface XJSaoMaViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
/** 输入数据源 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/** 输出数据源 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  data输出流
 */
@property (nonatomic, strong) AVCaptureVideoDataOutput *dataOutput;

/** 输入输出的中间桥梁 负责把捕获的音视频数据输出到输出设备中 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 相机拍摄预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layerView;
/** 预览图层尺寸 */
@property (nonatomic, assign) CGSize layerViewSize;
/** 有效扫码范围 */
@property (nonatomic, assign) CGSize showSize;
/** 作者自定义的View视图 */
@property (nonatomic, strong) XJShadowView *shadowView;
/**********************************************/
/** s是否是AR */
@property (nonatomic, assign) BOOL   xj_is_Ar;
@property (strong, nonatomic) UIImageView *flimageView;
@property (strong, nonatomic) UIButton *flGoBackBtn;
@property (strong, nonatomic) UIButton *flLigthBtn;
/**********************************************/
/**取景框*/
@property (nonatomic , strong) UIImageView* flKimageView;
/**相册view*/
@property (nonatomic , strong) UIView* flbottomView;
/**相册Btn*/
@property (nonatomic , strong) UIButton* flImageBtn;
@property (nonatomic , strong) UIImagePickerController *imagePickerController;
@property (nonatomic , strong) XJCircleAnimationView * centerRadarView;
@property (nonatomic , strong) UIButton * xjGiftMapBtn; //礼物按钮
@property (nonatomic , strong) UILabel * xjGiftMapLabel;
@property (nonatomic,weak) UIView *focusCircle;//光圈动画

/**动画*/
@property (nonatomic , strong) UIImageView* xj_searchGiftDoneImgView;
/**动画需要的数组*/
@property (nonatomic , strong) NSArray* xj_GiftDoneImgViewArr;
/**添加在动画中间的button*/
@property (nonatomic , strong) UIButton* xj_allBtn;

@property (nonatomic , strong) AMapLocationManager *locationManager;
@property (nonatomic , strong) AMapSearchAPI* search;
/**当前的 poi 云图搜索请求*/
@property (nonatomic , strong) AMapCloudPOIAroundSearchRequest *currentRequest;
@property (nonatomic , strong) CLLocation *xj_userLocation;
/**云图搜索结果 数组*/
@property (nonatomic , strong) NSArray* xj_POIsArr;
@property (nonatomic , strong) NSTimer* xj_animationTimer;

@property (nonatomic , strong) NSString* xj_topicId;
/**领取模型*/
@property (nonatomic, strong)FLMyReceiveListModel* flmyReceiveMineModel;
/**挖圆背景*/
@property (nonatomic , strong) BearCutOutView *cutOutView_2;
/**换个地方的背景*/
@property (nonatomic , strong) XJSaoChangePlaceView* xjChangePlaceView;
@end

@implementation XJSaoMaViewController
{
    NSInteger xj_needi; //动画需要的 值
    
    NSTimer*  _xj_need_timer; //聚焦计时器
    NSInteger _xj_needi;     //聚焦计时
    
    BOOL _xj_is_open_timer;//是否需要开启timer
    
    UIButton* xjRightBtn; // ar 按钮
    UIButton* skyArBtn;//sky ar
    
    
    NSInteger xj_sao_bugi;//设定两次扫描 不成功
    UIImage* xj_compareImg; // 视频流中取出的 图片

}

- (instancetype)initWithType:(NSInteger)xjType
{
    self = [super init];
    if (self) {
        [AMapServices sharedServices].apiKey = FL_GAODE_API_KEY;
        _flComeType = xjType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _xj_is_Ar = NO;
    _xj_is_open_timer = NO;
    xj_sao_bugi = 0; //设定两次扫描不成功
    self.view.backgroundColor = [UIColor blackColor];
    
    //显示范围
    self.showSize = customShowSize;
    //调用
    [self creatScanQR];
    //添加拍摄图层
    [self.view.layer addSublayer:self.layerView];
    
    
    UIImageView* xj = [[UIImageView alloc] init];
    xj.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    xj.frame = CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
//    [self.view addSubview:xj];
//    xj.backgroundColor = [UIColor redColor];
   
     //开始二维码
    [self.session startRunning];
    //设置可用扫码范围
    [self allowScanRect];
    
    //添加上层阴影视图
//    [self.view addSubview:self.shadowView];
    [self.view addSubview:self.cutOutView_2];//挖圆
    [self.view addSubview:self.xjChangePlaceView]; //换个地方
    [self.view addSubview:self.flGoBackBtn];
    [self.view addSubview:self.flLigthBtn];
    [self.view addSubview:self.centerRadarView]; //扫一扫动画啊
    
    [self creatBottomBtn];
    [self createBottomView];
    
    
    __weak typeof(self) weakSelf = self;
    [self.xjChangePlaceView xjClickToReSao:^{
        [weakSelf xj_ChangeSaoStatus:YES];
    }];
    
    
    [self xj_switchStyleAr];
//    [self  xj_showAddReceiveView];
}
#pragma mark --------------------------init
- (BearCutOutView *)cutOutView_2{
    if (!_cutOutView_2) {
        //画圆
        CGRect rect = CGRectMake((FLUISCREENBOUNDS.width)/2-120, (FLUISCREENBOUNDS.height)/2-140, 240, 240);
        UIBezierPath *beizPath=[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:240/2];
        _cutOutView_2 = [[BearCutOutView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
        [_cutOutView_2 setUnCutColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] cutOutPath:beizPath];
        _cutOutView_2.hidden = YES;
    }
    return _cutOutView_2;
}
- (XJShadowView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[XJShadowView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight )];
        _shadowView.showSize = self.showSize;
    }
    return _shadowView;
}
- (XJSaoChangePlaceView *)xjChangePlaceView {
    if (!_xjChangePlaceView) {
        _xjChangePlaceView = [[XJSaoChangePlaceView alloc] init];
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
- (UIButton *)flLigthBtn {
    if (!_flLigthBtn) {
        _flLigthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flLigthBtn.frame = CGRectMake(FLUISCREENBOUNDS.width-60, 20, 40, 40);
        [_flLigthBtn setBackgroundImage:[UIImage imageNamed:@"mypublish_btn_flash-lamp"] forState:UIControlStateNormal];
        _flLigthBtn.selected = NO;
        [_flLigthBtn addTarget:self action:@selector(flligthOnOff:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flLigthBtn;
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
- (UIImageView *)xj_searchGiftDoneImgView {
    if (!_xj_searchGiftDoneImgView) {
        _xj_searchGiftDoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.width)];
        _xj_searchGiftDoneImgView.center = self.view.center;
    }
    return  _xj_searchGiftDoneImgView;
}
- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        _search.timeout = 5; //超时
    }
    return _search;
}
- (CLLocation *)xj_userLocation{
    if (!_xj_userLocation) {
        _xj_userLocation = [[CLLocation alloc] init];
    }
    return _xj_userLocation;
}
- (XJCircleAnimationView *)centerRadarView {
    if (!_centerRadarView) {
        _centerRadarView = [[XJCircleAnimationView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.width)];
        _centerRadarView.center = CGPointMake(self.view.centerX, self.view.centerY -20);
        _centerRadarView.hidden = YES;
    }
    return _centerRadarView;
}

- (FLMyReceiveListModel *)flmyReceiveMineModel {
    if (!_flmyReceiveMineModel) {
        _flmyReceiveMineModel = [[FLMyReceiveListModel alloc] init];
    }
    return _flmyReceiveMineModel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    if (_xj_is_Ar) {
        if (self.centerRadarView) {
            [self xj_ChangeSaoStatus:YES];
            [self.centerRadarView xj_circleStart];
        }
    } else {
        
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self xjTimerRemove];
    [self xj_stop];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self xjTimerRemove];
    [self.xj_animationTimer invalidate];
    if (_xj_searchGiftDoneImgView) {
        [_xj_searchGiftDoneImgView removeFromSuperview];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}
//切换是否AR模式时
- (void)setXj_is_Ar:(BOOL)xj_is_Ar {
    _xj_is_Ar = xj_is_Ar;
    
}

//设置切换模式
//切换至 非 ar 模式
- (void)xj_switchStyleSao {
    if (_xj_is_Ar) {
        xjRightBtn.selected = NO;
        self.xjChangePlaceView.hidden = YES;
        _centerRadarView.hidden = YES;
        [self.view addSubview:self.flbottomView];
        [self.view addSubview:self.flKimageView];
        //        [self.view addSubview:self.flImageBtn];
        _xj_is_Ar = NO;
        [self.xjGiftMapLabel removeFromSuperview];
        [self.xjGiftMapBtn removeFromSuperview];
        //test
        [_xj_searchGiftDoneImgView removeFromSuperview];
        _xj_is_open_timer = NO;
//        [_xj_need_timer invalidate];
        self.cutOutView_2.hidden = YES;
    }
}
//切换至   ar 模式
- (void)xj_switchStyleAr{
    if (!_xj_is_Ar) {
        xjRightBtn.selected = YES;
        self.cutOutView_2.hidden = NO;
        [self.flbottomView removeFromSuperview];
        [self.flKimageView removeFromSuperview];
        [self startSerialLocation];//定位开启
        //        [self.flImageBtn removeFromSuperview];
        _xj_is_Ar = YES;
//        _centerRadarView.center = self.view.center;
        self.centerRadarView.hidden = NO;
        [self.centerRadarView xj_circleStart];
        [self.view addSubview:self.xjGiftMapBtn];
        [self.view addSubview:self.xjGiftMapLabel];
        [self xj_start];
        //聚焦一下
        _xj_is_open_timer = YES;
        [self xjTimerStart];
    }
}

- (void)xjClickToSkyAr{
    XJARSkyViewController * allake = [[XJARSkyViewController alloc] init];
    if (self.session) {
        [self xj_stop];
    }
    [self.navigationController pushViewController:allake animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)xj_stop {
    if (self.session&& self.session.isRunning) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.session stopRunning];
        });
    }
}
- (void)xj_start {
    if (self.session&&!self.session.isRunning) {
        [self.session startRunning];
    }
}

-(void)creatScanQR{
    
    /** 创建输入数据源 */
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];  //获取摄像设备
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    
//    int flags = NSKeyValueObservingOptionNew; //监听自动对焦
//    [device addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    
    //增加设备 移动的监听
    if (!device.subjectAreaChangeMonitoringEnabled) {
        device.subjectAreaChangeMonitoringEnabled = YES;
    }
    
    [device unlockForConfiguration];
    //对设备的 是否移动做监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xj_deveiceDidMode:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];
    
    
//    [device setFocusMode:AVCaptureFocusModeAutoFocus];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];  //创建输出流
    
    /** 创建输出数据源 */
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];  //设置代理 在主线程里刷新
    
    /** Session设置 */
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];   //高质量采集
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //设置扫码支持的编码格式
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                        AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode128Code];
    
    /******************************* 添加 输出流 为图片**************************/
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    if ([self.session canAddOutput:self.stillImageOutput]) {
//        [self.session addOutput:self.stillImageOutput];
    }
    
    /****************************** 添加 输出流 为图片**************************/
    self.dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    self.dataOutput.videoSettings = [NSDictionary dictionaryWithObject:
                                     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
   [self.dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];  //设置代理 在主线程里刷新
    if ([self.session canAddOutput:self.dataOutput]) {
        [self.session addOutput:self.dataOutput];
    }
    
    /****************************** 添加 输出流 为图片**************************/
    
    /** 扫码视图 */
    //扫描框的位置和大小
    self.layerView = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.layerView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.layerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    // 将扫描框大小定义为属行, 下面会有调用
    self.layerViewSize = CGSizeMake(_layerView.frame.size.width, _layerView.frame.size.height);
    
}
- (void)createBottomView
{
    //取景框
    self.flKimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saomiao_qujing_white"]];
    CGFloat imageX = FLUISCREENBOUNDS.width * 0.2;
    CGFloat imageY = FLUISCREENBOUNDS.height * 0.3;
    CGFloat imageW = FLUISCREENBOUNDS.width * 0.6;
    CGFloat imageH = FLUISCREENBOUNDS.width * 0.6;
    self.flKimageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    [self.view addSubview:self.flKimageView];
    //从相册选择
    self.flbottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
    self.flbottomView.center  =  CGPointMake(self.flKimageView.centerX, imageY+imageH+30);
    [self.view addSubview:self.flbottomView];
    //    [self.flbottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.flimageView).with.offset(FLUISCREENBOUNDS.height * 0.3 + FLUISCREENBOUNDS.width * 0.6 + 30);
    //        make.centerX.equalTo(self.flimageView).with.offset(0);
    //        make.size.mas_equalTo(CGSizeMake(130, 40));
    //    }];
    self.flbottomView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.7];
    self.flbottomView.layer.cornerRadius = 20;
    self.flbottomView.layer.masksToBounds = YES;
    //logo
    UIImageView* logoIamge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mypublish_btn_search"]];
    logoIamge.frame = CGRectMake(15, 10, 20, 20);
    [self.flbottomView addSubview:logoIamge];
    //label
    UILabel* label = [[UILabel alloc] init];
    label.text = @"从相册选择";
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake(40, 0, 80, 40);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
    [self.flbottomView addSubview:label];
    
    self.flImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flImageBtn.frame = CGRectMake(0, 0, 130, 40);//self.flbottomView.frame;
    [self.flbottomView addSubview:self.flImageBtn];
    
    
    [self.flImageBtn addTarget:self action:@selector(clickToPickImageFromLoco) forControlEvents:UIControlEventTouchUpInside];
    self.flImageBtn.layer.cornerRadius = 20;
    self.flImageBtn.layer.masksToBounds = YES;
    
    
    //ar 界面 的 地图按钮
    self.xjGiftMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xjGiftMapBtn.frame = CGRectMake(FLUISCREENBOUNDS.width * 0.8-40, FLUISCREENBOUNDS.height - 100, 40, 40);//CGRectMake(FLUISCREENBOUNDS.width * 0.8, FLUISCREENBOUNDS.height - 180, 40, 40);
    [self.xjGiftMapBtn setBackgroundImage:[UIImage imageNamed:@"ar_icon_map_white"] forState:UIControlStateNormal];
    [self.xjGiftMapBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.xjGiftMapBtn addTarget:self action:@selector(xjgoGiftMap) forControlEvents:UIControlEventTouchUpInside];
    
    self.xjGiftMapLabel = [[UILabel alloc] init];
    self.xjGiftMapLabel.frame = CGRectMake(FLUISCREENBOUNDS.width * 0.8 -40, FLUISCREENBOUNDS.height - 60, 40, 20);// CGRectMake(FLUISCREENBOUNDS.width * 0.8-10, FLUISCREENBOUNDS.height - 140, 60, 20);
    self.xjGiftMapLabel.text = @"藏宝图";
    self.xjGiftMapLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    self.xjGiftMapLabel.textAlignment = NSTextAlignmentCenter;
    self.xjGiftMapLabel.textColor = [UIColor whiteColor];
    
    
}

- (void)creatBottomBtn
{
    UIButton* xjLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:xjLeftBtn];
    xjLeftBtn.frame = CGRectMake(FLUISCREENBOUNDS.width * 0.2, FLUISCREENBOUNDS.height - 100, 40, 40);
    UILabel* xjleftLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width * 0.2-10, FLUISCREENBOUNDS.height - 60, 60, 20)];
//    [self.view addSubview:xjleftLabel];
    xjleftLabel.text = @"扫码";
    xjleftLabel.textAlignment =NSTextAlignmentCenter;
    xjleftLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    xjleftLabel.textColor = [UIColor whiteColor];
    [xjLeftBtn setBackgroundImage:[UIImage imageNamed:@"icon_bar_code_White"] forState:UIControlStateNormal];
    [xjLeftBtn addTarget:self action:@selector(xj_switchStyleSao) forControlEvents:UIControlEventTouchUpInside];
    
    xjRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:xjRightBtn];
    xjRightBtn.frame = CGRectMake(FLUISCREENBOUNDS.width * 0.8-40, FLUISCREENBOUNDS.height - 100, 40, 40);
//    [xjRightBtn setBackgroundImage:[UIImage imageNamed:@"ar_icon_white"] forState:UIControlStateNormal];
    [xjRightBtn setBackgroundImage:[UIImage imageNamed:@"ar_icon_red"] forState:UIControlStateNormal];
    [xjRightBtn addTarget:self action:@selector(xj_switchStyleAr) forControlEvents:UIControlEventTouchUpInside];
    UILabel* xjRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width * 0.8 -40, FLUISCREENBOUNDS.height - 60, 40, 20)];
    [self.view addSubview:xjRightLabel];
    xjRightLabel.text = @"直接寻宝";
    xjRightLabel.textAlignment =NSTextAlignmentCenter;
    xjRightLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    xjRightLabel.textColor = [UIColor whiteColor];
    
    xjRightLabel.frame = xjleftLabel.frame ;
    xjRightBtn.frame = xjLeftBtn.frame;
    
    //skyar
    skyArBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:skyArBtn];
    skyArBtn.frame = CGRectMake(FLUISCREENBOUNDS.width / 2 - 20, FLUISCREENBOUNDS.height - 100, 40, 40);
    [skyArBtn addTarget:self action:@selector(xjClickToSkyAr) forControlEvents:UIControlEventTouchUpInside];
    [skyArBtn setBackgroundImage:[UIImage imageNamed:@"xj_sky_ar_white"] forState:UIControlStateNormal];
//    [skyArBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_back_red_new"] forState:UIControlStateHighlighted];
    
    UILabel* xjMiddleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width /2 -20, FLUISCREENBOUNDS.height - 60, 40, 20)];
    [self.view addSubview:xjMiddleLabel];
    xjMiddleLabel.text = @"我的天";
    xjMiddleLabel.textAlignment =NSTextAlignmentCenter;
    xjMiddleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    xjMiddleLabel.textColor = [UIColor whiteColor];
    
    
}

#pragma mark -------------------------- 实现代理方法, 完成二维码扫描
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count > 0) {
        
        // 停止动画, 看完全篇记得打开注释, 不然扫描条会一直有动画效果
//        [self.shadowView stopTimer];
        //停止扫描
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0];
        //输出扫描字符串
        FL_Log(@"%@",metadataObject.stringValue);
        [self xj_saomaResule:[NSString stringWithFormat:@"%@",metadataObject.stringValue?metadataObject.stringValue:@""]];
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", metadataObject.stringValue] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }
    
    
    
}

/** 配置扫码范围 */
-(void)allowScanRect{
    
    
    /** 扫描是默认是横屏, 原点在[右上角]
     *  rectOfInterest = CGRectMake(0, 0, 1, 1);
     *  AVCaptureSessionPresetHigh = 1920×1080   摄像头分辨率
     *  需要转换坐标 将屏幕与 分辨率统一
     */
    
    //剪切出需要的大小位置
    CGRect shearRect = CGRectMake((self.layerViewSize.width - self.showSize.width) / 2,
                                  (self.layerViewSize.height - self.showSize.height) / 2,
                                  self.showSize.height,
                                  self.showSize.height);
    
    
    CGFloat deviceProportion = 1920.0 / 1080.0;
    CGFloat screenProportion = self.layerViewSize.height / self.layerViewSize.width;
    
    //分辨率比> 屏幕比 ( 相当于屏幕的高不够)
    if (deviceProportion > screenProportion) {
        //换算出 分辨率比 对应的 屏幕高
        CGFloat finalHeight = self.layerViewSize.width * deviceProportion;
        // 得到 偏差值
        CGFloat addNum = (finalHeight - self.layerViewSize.height) / 2;
        
        // (对应的实际位置 + 偏差值)  /  换算后的屏幕高
        self.output.rectOfInterest = CGRectMake((shearRect.origin.y + addNum) / finalHeight,
                                                shearRect.origin.x / self.layerViewSize.width,
                                                shearRect.size.height/ finalHeight,
                                                shearRect.size.width/ self.layerViewSize.width);
        
    }else{
        
        CGFloat finalWidth = self.layerViewSize.height / deviceProportion;
        
        CGFloat addNum = (finalWidth - self.layerViewSize.width) / 2;
        
        self.output.rectOfInterest = CGRectMake(shearRect.origin.y / self.layerViewSize.height,
                                                (shearRect.origin.x + addNum) / finalWidth,
                                                shearRect.size.height / self.layerViewSize.height,
                                                shearRect.size.width / finalWidth);
    }
    
}

#pragma mark -------------------------- 相册中读取二维码
/* navi按钮实现 */
-(void)takeQRCodeFromPic:(UIBarButtonItem *)leftBar{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
        pickerC.delegate = self;
        
        pickerC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;  //来自相册
        
        [self presentViewController:pickerC animated:YES completion:NULL];
        
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //监测到的结果数组  放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        //判断是否有数据（即是否是二维码）
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            [self xj_saomaResule:scannedResult];
//            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:scannedResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }];
}
#pragma mark ----------------------------Btn click
/*********************************进入红包地图**************************************/
- (void)xjgoGiftMap {
    XJGiftMapViewController* xjgift = [[XJGiftMapViewController alloc] init];
    [self.navigationController pushViewController:xjgift animated:YES];
}

- (void)flligthOnOff:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self systemLightSwitch:sender.selected];
}
- (void)systemLightSwitch:(BOOL)open
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}
//相册
- (void)clickToPickImageFromLoco{
    [self xj_stop];
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.navigationBar.tintColor = [UIColor blackColor];
        [_imagePickerController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}
- (void)xj_popGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----------------------------扫码有了结果
- (void)xj_saomaResule:(NSString*)result {
    if (_flComeType == 1) {
        [self xjSaoMiaoResultWithResult:result];
    } else if (_flComeType == 2) {
        //验票
        [self reportScanResult:result];
    }
}

#pragma mark ----------------------------- 扫码
- (void)xjSaoMiaoResultWithResult:(NSString*)xjResult {
    NSString* xjTopicId = @"topic.topicId=";
    NSString* xjUserId = @"&userId=";
    NSString* xjUserType = @"&userType=";
    [self xj_stop];
    if ([self xjHasStrLong:xjResult new:xjTopicId]&&[self xjHasStrLong:xjResult new:@"http://"]) {  [self gotoHTMLPageWithTopicId:xjResult];//跳详情//详情
    } else if ([self xjHasStrLong:xjResult new:@"http://"]) {
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:xjResult]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:xjResult]];
        }//浏览器
    } else {
        //显示内容
        XJEmptyViewController* xjx = [[XJEmptyViewController alloc] initWithNibName:@"XJEmptyViewController" bundle:nil];
        xjx.xjContentStr = xjResult;
        [self.navigationController pushViewController:xjx animated:YES];
    }
}
- (BOOL)xjHasStrLong:(NSString*)xjOld new:(NSString*)new {
    if ([xjOld rangeOfString:new].location!=NSNotFound)return YES;
    return NO;
}
- (void)gotoHTMLPageWithTopicId:(NSString*)flTopicId
{
    if ([flTopicId rangeOfString:@"topic.topicId="].location != NSNotFound) {
        //        NSString* xjbaseUrl = @"www.freela.com.cn";
        //        NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@/transpond/transpond!isTranspond.action?topic.topicId=%@",FLBaseUrl,str];
        NSInteger topicIndex = [flTopicId rangeOfString:@"topic.topicId="].location;
        flTopicId = [flTopicId substringFromIndex:topicIndex+14];
        if ([flTopicId rangeOfString:@"&"].location !=NSNotFound ) {
            NSInteger xj = [flTopicId rangeOfString:@"&"].location;
            flTopicId = [flTopicId substringToIndex:xj];
        }
        FL_Log(@"this is final topic str =%@",flTopicId);
    }
    if (![flTopicId integerValue]) {
        [FLTool showWith:@"二维码失效"];
        [self xj_start];
        return;
    }
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    FLFuckHtmlViewController* htmlVC = [[FLFuckHtmlViewController alloc] init];
    htmlVC.flFuckTopicId = flTopicId;
    [self.navigationController pushViewController:htmlVC animated:YES];
}


#pragma mark ---------------------------- 验票
- (void)reportScanResult:(NSString *)result{
    [self xj_stop];
 
    [self flUseDetailsTicketsInSaoMiaoVCWithStr:result];
}
- (void)flUseDetailsTicketsInSaoMiaoVCWithStr:(NSString*)str {
    NSDictionary* parm = @{@"token":XJ_USER_SESSION,
                           @"participateDetailes.userType":XJ_USERTYPE_WITHTYPE,
                           @"participateDetailes.detailsid":str,
                           @"participateDetailes.topicId":_flmodel.flMineIssueTopicIdStr,
                           @"participateDetailes.userId":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"participateDetailes.creator":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"participateDetailes.checkUser":FL_USERDEFAULTS_USERID_NEW
                           };
    [FLNetTool fluseDetailesByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in use details in saomiao view= %@",data);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",data[@"msg"]] message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续验证", nil];
        [alert show];

    } failure:^(NSError *error) {
        FL_Log(@"this is error in saomiao =%@",error);
        [self xj_start];
    }];
}


#pragma mark ---------------------------- 动画
- (void)xj_testToShowOK {
    if(self.centerRadarView){[self.centerRadarView xj_done];}
    NSMutableArray* xj = [NSMutableArray array];
    for (NSInteger i = 0; i < 45; i++) {
        if (i<10) {
//            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"合成 1_0000%ld",i]];
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ar_0000%ld",i] ofType:@"png"]];
            if (image) {
                [xj addObject:image];
            }
        }else {
//            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"合成 1_000%ld",i]];
             UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ar_000%ld",i] ofType:@"png"]];
            if (image) {
                [xj addObject:image];
            }
        }
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
-(void)setNextImage
{
    xj_needi++;
    if (xj_needi==self.xj_GiftDoneImgViewArr.count-1) {
        [self.xj_animationTimer invalidate];
        xj_needi = -1;
        _xj_searchGiftDoneImgView.image = [UIImage imageNamed: @"ar_00060"];
        return;
    } else if (xj_needi<10 &&xj_needi>=0) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"ar_0000%ld",xj_needi]];
        if (image) {
            _xj_searchGiftDoneImgView.image = image;
        }
    } else if(xj_needi< 61 && xj_needi >=10){
        NSString* xx = [NSString stringWithFormat:@"ar_000%ld",xj_needi];
        FL_Log(@"-=-=-=-=【%@】",xx);
        UIImage* image1 = [UIImage imageNamed:[NSString stringWithFormat:@"ar_000%ld",xj_needi]];
        if (xj_needi==52) {
            
        }
        NSLog(@"=-=-=-=【%ld】",xj_needi);
        if (image1) {
            _xj_searchGiftDoneImgView.image = image1;
        }
    }
    
}
#pragma mark -----------------------点击领取
- (void)xj_clickToPick{
    //先判断是否有领取信息
    [self getRequestDetailsOfTopicWithId:self.xj_topicId];
    [self FLFLHTMLInsertParticipate];//canyu
    //[self FLFLHTMLHTMLsaveTopicClickOn];
}

- (void)xj_clickToShowPickSuccess{
    [self xj_ChangePickGiftDoneStatus];
    __weak typeof(self) weakSelf = self;
    //领取陈宫界面
    XJVersionTPickSuccessView *view = [[XJVersionTPickSuccessView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width , FLUISCREENBOUNDS.height)];
    view.parentVC = weakSelf;
    view.xj_TopicThemeL.text =  self.flmyReceiveMineModel.flMineTopicThemStr;
    
    if ([XJFinalTool xjStringSafe:self.flmyReceiveMineModel.xj_suolvetuStr]) {
        NSString* ss=self.flmyReceiveMineModel.xj_suolvetuStr;
        //判断路径的结尾是不是 .mp4
//        if(![self.flmyReceiveMineModel.xj_suolvetuStr hasSuffix:@".mp4"]&& ![self.flmyReceiveMineModel.xj_suolvetuStr hasSuffix:@".gif"]){
//            ss = [XJFinalTool xjReturnImageURLWithStr:self.flmyReceiveMineModel.xj_suolvetuStr
//                                               isSite:NO];
//        }
        view.xj_imgUrlStr = ss;
    }
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
    //点击完成
    [view xj_findGiftSuccessDone:^{
        [weakSelf lew_dismissPopupView];
        //跳到票券页
        XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
        ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
        FL_Log(@"thi1s is te1h acti1on to push the page of ticke3t");
        [weakSelf.navigationController pushViewController:ticketVC animated:YES];
    }];
    
    
}


#pragma mark ---------------------开启定位

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];//设置期望定位精度
        [_locationManager setPausesLocationUpdatesAutomatically:NO];//设置不允许系统暂停定位
//        [_locationManager setAllowsBackgroundLocationUpdates:YES];//设置允许在后台定位
        [_locationManager setLocationTimeout:6];//设置定位超时时间
    }
    return _locationManager;
}

- (void)startSerialLocation{
    //开始定位
     __weak XJSaoMaViewController *weakSelf = self;
//    [self.locationManager startUpdatingLocation];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            FL_Log(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        FL_Log(@"location:%@", location);
        if (location) {
            _xj_userLocation = location;
//            [self xjSearchAroundWithLocationx:location.coordinate.longitude y:location.coordinate.latitude];
        }
        if (regeocode)
        {
            FL_Log(@"reGeocode:%@", regeocode);
            [weakSelf xjSearchPOIsFromARKitServiceWithLocationx:location.coordinate.longitude
                                                              y:location.coordinate.latitude
                                                           city:regeocode.city];
        }
    }];
}

- (void)stopSerialLocation{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    //定位结果
//    FL_Log(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//    if (location) {
//        _xj_userLocation = location;
//        [self xjSearchAroundWithLocationx:location.coordinate.longitude y:location.coordinate.latitude];
//    }
}

//云图搜索 结果
- (void)xjSearchAroundWithLocationx:(CGFloat)longitude y:(CGFloat)latitude{
    AMapCloudPOIAroundSearchRequest *placeAround = [[AMapCloudPOIAroundSearchRequest alloc] init];
    [placeAround setTableID:(NSString *)XJ_GAODE_TABLEID];
    
    [placeAround setRadius:500];
    //    AMapGeoPoint* centerPoint = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    AMapGeoPoint *centerPoint = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    [placeAround setCenter:centerPoint];
    [placeAround setSortType:AMapCloudSortTypeDESC];
    self.currentRequest = placeAround;
    [self.search AMapCloudPOIAroundSearch:placeAround];
    
}

#pragma mark -------------- 从自己后台获取云图数据
- (void)xjSearchPOIsFromARKitServiceWithLocationx:(CGFloat)longitude y:(CGFloat)latitude city:(NSString*)city{
    
    NSDictionary* parm = @{@"compid":@"",
                           @"city":city,
                           @"userid":XJ_USERID_WITHTYPE,
                           @"positon":[NSString stringWithFormat:@"%f,%f",longitude,latitude],
                           @"distance":@"1000000"
                           };
    [FLNetTool xjGetGiftMapResultsFromServer:parm searchType:@"C" success:^(NSDictionary *data) {
        //        XJFL_Log(@"this is pois datsa=【%@】",data );
        NSArray* arr = data[@"data"];
        NSMutableArray* mu = @[].mutableCopy;
        for (NSDictionary* dic in arr) {
            AMapCloudPOI* poi = [[AMapCloudPOI alloc] init];
            poi.address = dic[@"_address"];
            AMapGeoPoint* location =  [[AMapGeoPoint alloc] init];
            NSArray* loarr = [[NSString stringWithFormat:@"%@",dic[@"_location"]] componentsSeparatedByString:@","];
            location.longitude = [loarr[0] floatValue];
            location.latitude  = [loarr[1] floatValue];
            poi.location = location;
            
            poi.name = dic[@"_name"];
            poi.customFields = @{
                                 @"pictureCode":dic[@"pictureCode"]?dic[@"pictureCode"]:@"",
                                 @"topicId":dic[@"topicId"]?dic[@"topicId"]:@"",
                                 @"topicPublisher":dic[@"topicPublisher"]?dic[@"topicPublisher"]:@"",
                                 @"topicPublisherIcon":dic[@"topicPublisherIcon"]?dic[@"topicPublisherIcon"]:@""
                                 };
            [mu addObject:poi];
        }
        self.xj_POIsArr = mu.mutableCopy;
        
    } failure:^(NSError *error) {
        
    }];
}
//回调
- (void)onCloudSearchDone:(AMapCloudSearchBaseRequest *)request response:(AMapCloudPOISearchResponse *)response {
    if ([response POIs].count == 0) {
        return;
    }
    // 只处理最新的请求
    if (request != self.currentRequest) {
        return;
    }
       //解析response获取云图点信息，具体解析见 Demo
     //    [self addAnnotationsWithPOIs:[response POIs]];
    NSMutableArray* xjmu = @[].mutableCopy;
    for (NSInteger i = 0 ; i < [response POIs].count; i++) {
        AMapCloudPOI* xjpoi = [response POIs][i];
        //判断点是否在圆内
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(xjpoi.location.latitude, xjpoi.location.longitude);
        CLLocationCoordinate2D center = _xj_userLocation.coordinate;
        BOOL isContains = MACircleContainsCoordinate(location, center, 500);
        if (isContains) {
            [xjmu addObject:xjpoi];
             FL_Log(@"这些是 可以领取的poi 数据==%@     0-0-0-[%@]",xjpoi.address,xjpoi.customFields);
        }
        //判断是否是不限地区的 poi
    }
    self.xj_POIsArr = xjmu.mutableCopy;

}


#pragma mark ---------------------------------- 聚焦问题
//光圈动画
-(void)setFocusCursorAnimationWithPoint:(CGPoint)point{
    self.focusCircle.center = point;
    self.focusCircle.transform = CGAffineTransformIdentity;
    self.focusCircle.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCircle.transform=CGAffineTransformMakeScale(0.5, 0.5);
        self.focusCircle.alpha = 0.0;
    }];
}
//光圈
- (UIView *)focusCircle{
    if (!_focusCircle) {
        UIView *focusCircle = [[UIView alloc] init];
        focusCircle.frame = CGRectMake(0, 0, 150, 150);
        focusCircle.layer.borderColor = [UIColor orangeColor].CGColor;
        focusCircle.layer.borderWidth = 2;
        focusCircle.layer.cornerRadius = 50;
        focusCircle.layer.masksToBounds =YES;
        _focusCircle = focusCircle;
        [self.view addSubview:focusCircle];
    }
    return _focusCircle;
}

//更改设备属性前一定要锁上
-(void)changeDevicePropertySafety:(void (^)(AVCaptureDevice *captureDevice))propertyChange{
    //也可以直接用_videoDevice,但是下面这种更好
    AVCaptureDevice *captureDevice= [self.input device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁,意义是---进行修改期间,先锁定,防止多处同时修改
    BOOL lockAcquired = [captureDevice lockForConfiguration:&error];
    if (!lockAcquired) {
        NSLog(@"锁定设备过程error，错误信息：%@",error.localizedDescription);
    }else{
        [_session beginConfiguration];
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        [_session commitConfiguration];
    }
}
//捕捉焦点,设置焦点模式
- (void)xj_setjiaodian{
    if (_xj_needi>5 || _xj_needi==0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    CGPoint point= CGPointMake(FLUISCREENBOUNDS.width/2, FLUISCREENBOUNDS.height/2);
    //将UI坐标转化为摄像头坐标,摄像头聚焦点范围0~1
    CGPoint cameraPoint= [self.layerView captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorAnimationWithPoint:point];
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        //聚焦
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            NSLog(@"聚焦模式修改为%zd",AVCaptureFocusModeContinuousAutoFocus);
            //            [self.session stopRunning];
            [weakSelf performSelectorOnMainThread:@selector(takePhotoButtonClick:) withObject:nil waitUntilDone:YES];
            
        }else{
            NSLog(@"聚焦模式修改失败");
        }
        
        //聚焦点的位置
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:cameraPoint];
        }
    }];
    
}
- (void)takePhotoButtonClick:(UIBarButtonItem *)sender {
    if (xj_compareImg) {
       [self xj_checkPOIsWithImg:xj_compareImg];
    }
    /*
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
    FL_Log(@"takephotoClick...");
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
        
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];//镜头方向？
        
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1.0f];
        
        
        //去除拍照声音11
        static SystemSoundID  soundID = 0;
        if (soundID==0) {
            NSString* path = [[NSBundle mainBundle] pathForResource:@"photoShutter2" ofType:@"caf"];
            NSURL* filePath = [NSURL fileURLWithPath:path isDirectory:NO];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        }
        AudioServicesPlaySystemSound(soundID);
        
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
//            CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
//                                                                        imageDataSampleBuffer,
//                                                                        kCMAttachmentMode_ShouldPropagate);
//            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//            if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
//                //无权限
//                return ;
//            }
           
            if (weakSelf.session&&weakSelf.session.running&&jpegData) {
//                [self xj_stop];
                UIImage* image = [UIImage imageWithData:jpegData];
                if (image) {
                    //j根据周边 检索出来的 扫
                    [self xj_checkPOIsWithImg:image];
                }
//                [self performSelector:@selector(xj_testToShowOK) withObject:nil afterDelay:2];
            }
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//            [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//                
//            }];
        }
    }];
         });
     */
}
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

#pragma  mark  ----------------------------切换扫描结果状态
- (void)xj_ChangeSaoStatus:(BOOL)sao {
    [_xj_need_timer invalidate];
    _xj_need_timer = nil;
    _xj_is_open_timer = sao;
    if (sao) {
        [self xj_start];
        [self xjTimerStart];
    }
    self.centerRadarView.hidden = !sao;
    self.cutOutView_2.hidden = !sao;
    self.xjChangePlaceView.hidden = sao;
}
#pragma  mark  ----------------------------切换领取完成状态
- (void)xj_ChangePickGiftDoneStatus {
    [_xj_need_timer invalidate];
    _xj_need_timer = nil;
    self.centerRadarView.hidden = YES;
    self.cutOutView_2.hidden = YES;
    self.xjChangePlaceView.hidden = YES;
}
#pragma  mark  ----------------------------request
- (void)xj_checkPOIsWithImg:(UIImage*)img {
//    AMapCloudPOI* xjpoi
    if (self.xj_POIsArr.count==0) {
        [self xj_ChangeSaoStatus:NO];
        return;
    }
    xj_sao_bugi +=1;
    if (xj_sao_bugi<3) {
        [self xj_ChangeSaoStatus:NO];
        return;
    }
    [self xjTimerSuspend];//暂停扫描
    BOOL  can_check=NO;
    for (NSInteger i = 0; i<self.xj_POIsArr.count; i++) {
        AMapCloudPOI* xjpoi = self.xj_POIsArr[i];
        NSString* xjstr = xjpoi.customFields[@"pictureCode"];
        NSString* xjtopicid = xjpoi.customFields[@"topicId"];
        NSInteger jj= [XJFinalTool xj_compareWithString:xjstr andImg:img];
        FL_Log(@"jjjjj=【%ld】",jj);
        if (jj>30) {
            
        } else {
            FL_Log(@"jjjjj=【%ld】",jj);
            self.xj_topicId = xjtopicid;
            can_check = YES;
        }
    }
    if (can_check) {
        [self xjTimerSuspend];
        [self xj_stop];
        [self checkTakeCanOrNot];
    } else {
        [self xj_ChangeSaoStatus:NO];//[self xjTimerStart];
    }
}
#pragma mark ------------------------------------- 数据请求
- (void) xjGetPartInfoList:(NSString*)partinfo{
    
   
    NSDictionary* parm =@{@"topic.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"topic.partInfo":partinfo};
    [FLNetTool HTMLGetPartInfoListByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"get partinafo success =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            [self  xj_showAddReceiveView];
        }
    } failure:^(NSError *error) {
        
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

// 领取资格
- (void)checkTakeCanOrNot {
//    [self xj_testToShowOK];
    FL_Log(@"this web view begin to reload for test");
    //检查领取资格
    NSDictionary* parm = @{@"participate.topicId": self.xj_topicId,
                           @"participate.userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"participate.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,
                           @"participate.creator":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID};
    [FLNetTool checkReceiveInfoInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in check pi22ck topic =%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            _xj_is_open_timer = NO;
            [self xj_testToShowOK];
        } else {
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
// 点击插入参与记录 (发起助力抢等)
- (void)FLFLHTMLInsertParticipate
{
    FL_Log(@"点击插入参与记录");
    NSDictionary* parm =@{@"participate.topicId":self.xj_topicId,
                          @"participate.userId":FL_USERDEFAULTS_USERID_NEW,
                          @"participate.userType":FLFLXJUserTypePersonStrKey,   //商家不可以点击领取
                          @"participate.creator":FL_USERDEFAULTS_USERID_NEW};   //个人领取永远是个人id
    [FLNetTool HTMLinsertParticipateInMineByIDWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"点击插入参ss与记录ssssdsa成功= %@",data);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            
        }
    } failure:^(NSError *error) {
        
    }];
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
                           @"participateDetailes.creator":xjCreator,//FL_USERDEFAULTS_USERID_NEW,
                           @"participateDetailes.message":xjmsg,
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
            [[FLAppDelegate share] showHUDWithTitile:@"操作成功" view:self.view delay:1 offsetY:0];
            [self xj_clickToShowPickSuccess];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic =%@",error);
//        [self lew_dismissPopupView];
    }];
}

#pragma  mark ------------------------ 等待聚焦
- (void)xj_waitJuJiao {
    if (xj_needi==-1) {
        [_xj_need_timer invalidate];
        return;
    }
    _xj_needi +=1;
    FL_Log(@"这里是等待聚焦 的状态【%ld】",_xj_needi);
    if (_xj_needi>3 && _xj_needi<5) {
        [_xj_need_timer invalidate];
        _xj_need_timer = nil;
        [self xj_setjiaodian];
        _xj_needi = 0;
    }
}

- (void)xjTimerContinue{
    
}
- (void)xjTimerStart{
    if (_xj_is_open_timer) {
        _xj_needi=0;
        [_xj_need_timer invalidate];
        _xj_need_timer = nil;
        _xj_need_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self  selector:@selector(xj_waitJuJiao) userInfo:nil repeats:YES];
    }
}
//暂停
- (void)xjTimerSuspend{
    [_xj_need_timer invalidate];
    _xj_need_timer = nil;
    _xj_needi=0;
}
- (void)xjTimerRemove{
    
    [_xj_need_timer setFireDate:[NSDate distantFuture]];
    _xj_needi=-1;
    [_xj_need_timer invalidate];
    _xj_need_timer = nil;
    _xj_is_open_timer = NO;
}
//当设备移动
- (void)xj_deveiceDidMode :(NSNotification*)obj{
    if(_xj_is_open_timer){//是否需要开启timer
        _xj_needi=0;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma  mark --- --------------------------------直接领取
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
            FL_Log(@"thi si s the data of html 5=[%@]",data);
            [self returnModelForTicketsWithData:data[FL_NET_DATA_KEY]];
            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjtopicid];
            NSString* xj_parinfo = data[FL_NET_DATA_KEY][@"partInfo"];
            if ([XJFinalTool xjStringSafe:xj_parinfo]) {
                [self  xj_showAddReceiveView];;//[self xjGetPartInfoList:xj_parinfo];//获取填写信息
            }else{
                [self FLFLHTMLHTMLsaveTopicClickOn:@""];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}



- (void)returnModelForTicketsWithData:(NSDictionary*)data {
    self.flmyReceiveMineModel.flIntroduceStr = data[@"topicExplain"];
    self.flmyReceiveMineModel.flMineIssueTopicIdStr = data[@"topicId"];
    self.flmyReceiveMineModel.xjCreator = [data[@"creator"] integerValue];
    self.flmyReceiveMineModel.xjUserId = [data[@"userId"] integerValue];
    self.flmyReceiveMineModel.flTimeBegan = data[@"startTime"];
    self.flmyReceiveMineModel.xjinvalidTime = data[@"invalidTime"];
    self.flmyReceiveMineModel.xjUrl = data[@"url"];
    self.flmyReceiveMineModel.xjUserType = data[@"userType"];
    self.flmyReceiveMineModel.xj_suolvetuStr = data[@"thumbnail"];
    NSString* suolve = data[@"sitethumbnail"];
    if ([XJFinalTool xjStringSafe:suolve]) {
        if (![suolve hasSuffix:@".gif"]&&![suolve hasSuffix:@".mp4"]) {
            self.flmyReceiveMineModel.xj_suolvetuStr = suolve;
        }
    }
    self.flmyReceiveMineModel.flMineTopicThemStr = data[@"topicTheme"];
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if( [keyPath isEqualToString:@"adjustingFocus"] ){
//        BOOL adjustingFocus = [ [change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
//        NSLog(@"Is adjusting focus? %@", adjustingFocus ? @"YES" : @"NO" );
//        NSLog(@"Change dictionary: %@", change);
//        if (delegate) {
//            [delegate foucusStatus:adjustingFocus];
//          地址：http://blog.csdn.net/ld840130641/article/details/51435878
//        }
//    }
//}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // 通过抽样缓存数据创建一个UIImage对象
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
//    NSLog(@"??????==%ld",_xj_needi);
    if (_xj_needi==3) {
       xj_compareImg = image;
        [self xj_stop];
    }
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

/* 关闭系统声音
- (void)xj_removePhotoVoice {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    volumeView.frame = CGRectMake(-1000, -100, 100, 100);
    volumeView.hidden = NO;
    [self.view addSubview:volumeView];
    
    // retrieve system volume
    float systemVolume = volumeViewSlider.value;
    
    // change system volume, the value is between 0.0f and 1.0f
    [volumeViewSlider setValue:0.0f animated:NO];
    
    // send UI control event to make the change effect right now.
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}
*/

@end









