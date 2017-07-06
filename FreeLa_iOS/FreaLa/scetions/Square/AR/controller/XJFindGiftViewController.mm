//
//  XJFindGiftViewController.m
//  FreeLa
//
//  Created by Leon on 2017/1/4.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJFindGiftViewController.h"
//#import "Radar.h"
#import "XJCircleAnimationView.h"
#import "XJFreelaUVManager.h"
#import "LewPopupViewController.h"
//#import "XJGiftPickSuccessView.h"
#import "XJGiftAddReceiveInfoView.h"
#import "BearCutOutView.h"
#import "XJSaoChangePlaceView.h"
#import "XJVersionTPickSuccessView.h"
#import "XJImgCompare.h"
#import "UIImage+YYAdd.h"
#import "XJHFiveCallLocationJsController.h"
#import "XJXJScanViewController.h"

@interface XJFindGiftViewController ()<UIGestureRecognizerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,NSURLSessionDelegate>

@property (strong, nonatomic)  UIView *backView;
@property (nonatomic,weak) UIView *focusCircle;

//AVFoundation

@property (nonatomic) dispatch_queue_t sessionQueue;
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
/**
 *  data输出流
 */
@property (nonatomic, strong) AVCaptureVideoDataOutput *dataOutput;
/**
 *  记录开始的缩放比例
 */
@property(nonatomic,assign)CGFloat beginGestureScale;
/**
 *  最后的缩放比例
 */
@property(nonatomic,assign)CGFloat effectiveScale;
/**领取模型*/
@property (nonatomic, strong)FLMyReceiveListModel* flmyReceiveMineModel;
@property (nonatomic , strong) XJCircleAnimationView * centerRadarView;

@property (nonatomic , strong) NSString* xj_topicId;

@property (nonatomic , strong) NSString* xj_compareCode;

/**动画需要的数组*/
@property (nonatomic , strong) NSArray* xj_GiftDoneImgViewArr;
/**动画*/
@property (nonatomic , strong) UIImageView* xj_searchGiftDoneImgView;
@property (nonatomic , strong) NSTimer* xj_animationTimer;
/**添加在动画中间的button*/
@property (nonatomic , strong) UIButton* xj_allBtn;

/**线索btn*/
@property (nonatomic ,strong) UIButton * xj_xiansuoBtn;
/**线索label*/
@property (nonatomic ,strong) UILabel * xj_xiansuoLabel;

/**线索View*/
@property (nonatomic ,strong) UIView * xj_xiansuoView;
/**线索ImgView*/
@property (nonatomic ,strong) UIImageView * xj_xiansuoImgView;
@property (strong, nonatomic) UIButton *flGoBackBtn;
/**挖圆背景*/
@property (nonatomic , strong) BearCutOutView *cutOutView_2;
/**换个地方的背景*/
@property (nonatomic , strong) XJSaoChangePlaceView* xjChangePlaceView;
@end

@implementation XJFindGiftViewController
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAVCaptureSession];
    _xj_is_open_timer = YES;
    xj_sao_bugi = 0; //设定两次扫描不成功
    [self setUpGesture];
    self.effectiveScale = self.beginGestureScale = 1.0f;
    [self.view addSubview:self.cutOutView_2];//挖圆背景
    [self.view addSubview:self.xjChangePlaceView]; //换个地方
    [self.view addSubview:self.centerRadarView];
    [self.centerRadarView xj_circleStart];
    
    [self xjTimerStart];
    [self.view addSubview:self.xj_xiansuoLabel];//线索btn
    [self xj_initXiansuoView];
    [self.view addSubview:self.flGoBackBtn];
    
    __weak typeof(self) weakSelf = self;
    [self.xjChangePlaceView xjClickToReSao:^{
        [weakSelf xj_ChangeSaoStatus:YES];
    }];
    

}
- (void)appHasGoneInForeground{
    

    if (_xj_is_open_timer) {
        [self.centerRadarView performSelector:@selector(xj_circleStart) withObject:nil afterDelay:1.0f];

    }

}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    if (self.session) {
        [self.session startRunning];
    }
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self xjTimerRemove];
    [self.xj_animationTimer invalidate];
//    if (_xj_searchGiftDoneImgView) {
//        [_xj_searchGiftDoneImgView removeFromSuperview];
//    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}

- (void)setPoi:(AMapCloudPOI *)poi {
    _poi = poi;
    NSString* xjstr = poi.customFields[@"pictureCode"];
    NSString* xjtopicid = poi.customFields[@"topicId"];
    self.xj_topicId = [NSString stringWithFormat:@"%@",xjtopicid];
    self.xj_compareCode = [NSString stringWithFormat:@"%@",xjstr];
    
    [self xj_getRequestDetailsOfTopicWithId:self.xj_topicId];
}

- (void)xjSetModel:(FLMyReceiveListModel*)model {
    self.xj_topicId = [NSString stringWithFormat:@"%@",model.flMineIssueTopicIdStr];
    self.xj_compareCode = [NSString stringWithFormat:@"%@",model.pictureCode];
    [self xj_getRequestDetailsOfTopicWithId:self.xj_topicId];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if (self.session) {
        
        [self.session stopRunning];
    }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        

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
    

    
}

- (XJSaoChangePlaceView *)xjChangePlaceView {
    if (!_xjChangePlaceView) {
        _xjChangePlaceView = [[XJSaoChangePlaceView alloc] init];
        _xjChangePlaceView.hidden = YES;
    }
    return _xjChangePlaceView;
}
- (BearCutOutView *)cutOutView_2{
    if (!_cutOutView_2) {
        //画圆
        CGRect rect = CGRectMake((FLUISCREENBOUNDS.width)/2-120, (FLUISCREENBOUNDS.height)/2-140, 240, 240);
        UIBezierPath *beizPath=[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:240/2];
        _cutOutView_2 = [[BearCutOutView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
        [_cutOutView_2 setUnCutColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] cutOutPath:beizPath];
    }
    return _cutOutView_2;
}
- (FLMyReceiveListModel *)flmyReceiveMineModel {
    if (!_flmyReceiveMineModel) {
        _flmyReceiveMineModel = [[FLMyReceiveListModel alloc] init];
    }
    return _flmyReceiveMineModel;
}
- (XJCircleAnimationView *)centerRadarView {
    if (!_centerRadarView) {
        _centerRadarView = [[XJCircleAnimationView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.width)];
        _centerRadarView.center = CGPointMake(self.view.centerX, self.view.centerY -20);
    }
    return _centerRadarView;
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

- (UIButton *)xj_xiansuoBtn {
    if (!_xj_xiansuoBtn) {
        _xj_xiansuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xj_xiansuoBtn.frame = CGRectMake(0, FLUISCREENBOUNDS.height-80, 130, 50);
        _xj_xiansuoBtn.center = CGPointMake(self.view.centerX, FLUISCREENBOUNDS.height-70);
        _xj_xiansuoBtn.layer.cornerRadius = 25;
        _xj_xiansuoBtn.layer.masksToBounds = YES;
        [_xj_xiansuoBtn setTitle:@"线索" forState:UIControlStateNormal];
        [_xj_xiansuoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _xj_xiansuoBtn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [_xj_xiansuoBtn addTarget:self action:@selector(xj_clickToShowXSView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xj_xiansuoBtn;
}
- (UILabel *)xj_xiansuoLabel {
    if(!_xj_xiansuoLabel){
        _xj_xiansuoLabel = [[UILabel alloc] init];
        _xj_xiansuoLabel.frame = CGRectMake(0, FLUISCREENBOUNDS.height-80, 130, 50);
        _xj_xiansuoLabel.center = CGPointMake(FLUISCREENBOUNDS.width/2, FLUISCREENBOUNDS.height- 50);
        _xj_xiansuoLabel.text = @"线索";
        _xj_xiansuoLabel.layer.cornerRadius = 25;
        _xj_xiansuoLabel.layer.masksToBounds = YES;
        _xj_xiansuoLabel.textAlignment = NSTextAlignmentCenter;
        _xj_xiansuoLabel.textColor = [UIColor whiteColor];
        _xj_xiansuoLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        _xj_xiansuoLabel.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressBtn:)];
        [longPressGesture setDelegate:self];
        longPressGesture.minimumPressDuration=0.5;//默认0.5秒
        [_xj_xiansuoLabel addGestureRecognizer:longPressGesture];
    }
    return _xj_xiansuoLabel;
}

- (UIView *)xj_xiansuoView {
    if (!_xj_xiansuoView) {
        _xj_xiansuoView = [UIButton buttonWithType:UIButtonTypeCustom];
        _xj_xiansuoView.frame = CGRectMake(0, 0, 100, 100);
        _xj_xiansuoView.center = CGPointMake(FLUISCREENBOUNDS.width/2, FLUISCREENBOUNDS.height-120-30);
//        _xj_xiansuoView.backgroundColor = [UIColor redColor];
        _xj_xiansuoView.hidden = YES;
    }
    return _xj_xiansuoView;
}

- (UIImageView *)xj_xiansuoImgView {
    if (!_xj_xiansuoImgView) {
        _xj_xiansuoImgView = [[UIImageView alloc] init];
        _xj_xiansuoImgView.frame = CGRectMake(0, 0, 100, 100);
        _xj_xiansuoImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_xj_xiansuoView addSubview:_xj_xiansuoImgView];
        UIView* xjcover =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        xjcover.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        [_xj_xiansuoView addSubview:xjcover];
        
    }
    return _xj_xiansuoImgView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
        [self.view addSubview:_backView];
    }
    return _backView;
}
- (void)xj_popGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark private method
- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeOff];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xj_deveiceDidMode:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];
    
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
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
    

    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
 
    self.previewLayer.frame = CGRectMake(0, 0,FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height );
    self.backView.layer.masksToBounds = YES;
    [self.backView.layer addSublayer:self.previewLayer];
    
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

#pragma 创建手势
- (void)setUpGesture{
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.backView addGestureRecognizer:pinch];
}

#pragma mark gestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark respone method

- (void)takePhotoButtonClick:(UIBarButtonItem *)sender {
    if (xj_VideoImg) {
        [self xj_checkCodeStrWithImg:xj_VideoImg];
    }
    
    /*
    NSLog(@"takephotoClick...");
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    //去除拍照声音
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
            if (self.session&&self.session.running&&jpegData) {
                [self.session stopRunning];
                [self xj_checkCodeStrWithImg:[UIImage imageWithData:jpegData]];
            }
        }else{
            [self xj_start];
            [self xjTimerStart];
        }
    }];
     */
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.backView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}


/******************************d点按聚焦**********************************************/


//捕捉焦点,设置焦点模式
- (void)xj_setjiaodian{
    CGPoint point= CGPointMake(FLUISCREENBOUNDS.width/2, FLUISCREENBOUNDS.height/2);
    //将UI坐标转化为摄像头坐标,摄像头聚焦点范围0~1
    CGPoint cameraPoint= [self.previewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorAnimationWithPoint:point];
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        
        /*
         @constant AVCaptureFocusModeLocked 锁定在当前焦距
         Indicates that the focus should be locked at the lens' current position.
         
         @constant AVCaptureFocusModeAutoFocus 自动对焦一次,然后切换到焦距锁定
         Indicates that the device should autofocus once and then change the focus mode to AVCaptureFocusModeLocked.
         
         @constant AVCaptureFocusModeContinuousAutoFocus 当需要时.自动调整焦距
         Indicates that the device should automatically focus when needed.
         */
        //聚焦
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            NSLog(@"聚焦模式修改为%zd",AVCaptureFocusModeContinuousAutoFocus);
            //            [self.session stopRunning];
            [self takePhotoButtonClick:nil];
         
        }else{
            NSLog(@"聚焦模式修改失败");
        }
        
        //聚焦点的位置
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:cameraPoint];
        }
    }];
    
}

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
        [self.backView addSubview:focusCircle];
    }
    return _focusCircle;
}

//更改设备属性前一定要锁上
-(void)changeDevicePropertySafety:(void (^)(AVCaptureDevice *captureDevice))propertyChange{
    //也可以直接用_videoDevice,但是下面这种更好
    AVCaptureDevice *captureDevice= [_videoInput device];
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
        [self xj_ChangeSaoStatus:NO];
        return;
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
            [self xj_stop];
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
            [self xj_getRequestDetailsOfTopicWithId:self.xj_topicId];
            NSString* xj_parinfo = @"NAME,TEL,ADDRESS";
//            if ([XJFinalTool xjStringSafe:xj_parinfo]) {
//                [self xjGetPartInfoList:xj_parinfo];//获取填写信息
//            }else{
                [self xj_clickToShowPickSuccess];
//            }
            //移除动画
            [_xj_searchGiftDoneImgView removeFromSuperview];
            _xj_searchGiftDoneImgView = nil;
            _xj_searchGiftDoneImgView.animationImages = nil;
            [self xj_stop];
        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic =%@",error);
    }];
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
        [self xj_setjiaodian];
        _xj_timer_needi = 0;
    }
}

- (void)xjTimerContinue{
    
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
    str=[str stringByReplacingOccurrencesOfString:@"{" withString:@"["];
    str=[str stringByReplacingOccurrencesOfString:@"}" withString:@"]"];
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
            [self returnModelForTicketsWithData:data[FL_NET_DATA_KEY]];
            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjtopicid];
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
    self.flmyReceiveMineModel.xj_xiansuotuStr = data[@"detailchart"];
    NSString* ad = data[@"thumbnail"];
    FL_Log(@"dsadsafsadsad===【%@】",ad);
    self.flmyReceiveMineModel.createTime = data[@"createTime"];
    NSString* xxx = [XJFinalTool xjReturnImageURLWithStr:self.flmyReceiveMineModel.xj_xiansuotuStr isSite:NO];
    [self.xj_xiansuoImgView sd_setImageWithURL:[NSURL URLWithString:xxx] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        xj_compareImg = image;
    }];
}

#pragma mark ---------------------------- 动画
- (void)xj_testToShowOK {
    if(self.centerRadarView){[self.centerRadarView xj_done];}

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

//    for (NSInteger i = 0; i < 22; i++) {
//        NSInteger j=i*2;
//        if (j<j) {
//                        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"ar_0000%ld",j]];
////            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ar_0000%ld",i] ofType:@"png"]];
//            if (image) {
//                [xj addObject:image];
//            }
//        }else {
//                        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"ar_000%ld",j]];
////            UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ar_000%ld",i] ofType:@"png"]];
//            if (image) {
//                [xj addObject:image];
//            }
//        }
//    }
//    self.xj_GiftDoneImgViewArr = xj.mutableCopy;
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
        _xj_searchGiftDoneImgView.image = [UIImage imageNamed: @"ar_00045"];
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
    [self lew_dismissPopupView];
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
        //跳到票券页
        XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
        ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
        FL_Log(@"thi1s is te1h acti1on to push the page of ticke3t");
        [weakSelf.navigationController pushViewController:ticketVC animated:YES];
        NSMutableArray*ctrArr=weakSelf.navigationController.viewControllers.mutableCopy;
        [ctrArr removeObject:weakSelf];
        [weakSelf.navigationController setViewControllers:ctrArr];
        
        if (weakSelf.xj_searchGiftDoneImgView) {
              [weakSelf.xj_searchGiftDoneImgView removeFromSuperview];
        }
        [weakSelf xj_stop];
    }];
}

//点击查看线索
- (void)xj_clickToShowXSView{
    self.xj_xiansuoView.hidden =  !self.xj_xiansuoView.hidden;
}
- (void)xj_initXiansuoView{
    [self.view addSubview:self.xj_xiansuoView];
    NSString* xxx = [XJFinalTool xjReturnImageURLWithStr:self.flmyReceiveMineModel.flMineTopicThemStr isSite:NO];
    [self.xj_xiansuoImgView sd_setImageWithURL:[NSURL URLWithString:xxx] placeholderImage:[UIImage imageNamed:@""]];
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
#pragma  mark  ----------------------------切换领取完成状态
- (void)xj_ChangePickGiftDoneStatus {
    [_xj_need_timer invalidate];
    _xj_need_timer = nil;
    self.centerRadarView.hidden = YES;
    self.cutOutView_2.hidden = YES;
    self.xjChangePlaceView.hidden = YES;
    self.xj_xiansuoLabel.hidden = YES;
}
-(void)longPressBtn:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.xj_xiansuoView.hidden = NO;
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        self.xj_xiansuoView.hidden = YES;
    }
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    //    NSLog(@"??????==%ld",_xj_needi);
    if (_xj_timer_needi==3) {
        xj_VideoImg = image;
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


@end












