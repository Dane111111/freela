//
//  XJHideGiftViewController.m
//  FreeLa
//
//  Created by Leon on 2017/1/3.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJHideGiftViewController.h"
//#import "Radar.h"
#import "XJCircleAnimationView.h"

#import "LewPopupViewController.h"
//#import "XJArHideGiftView.h"
#import "XJHidePublishDoneView.h"
#import "BearCutOutView.h"
#import "XJPickARGiftGifViewController.h"
#import "XJPickARGiftCustiomViewController.h"
#import "BGHideARAndLBSView.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface XJHideGiftViewController ()<UIGestureRecognizerDelegate,FLChooseMapViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XJPickARGiftGifViewControllerDelegate,XJPickARGiftCustiomViewControllerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic)  UIView *backView;
@property (nonatomic,weak) UIView *focusCircle;
@property (nonatomic , strong) XJCircleAnimationView * centerRadarView;

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
 *  data输出流
 */
@property (nonatomic, strong) AVCaptureVideoDataOutput *dataOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

/**
 *  记录开始的缩放比例
 */
@property(nonatomic,assign)CGFloat beginGestureScale;
/**
 *  最后的缩放比例
 */
@property(nonatomic,assign)CGFloat effectiveScale;


/**藏这里按钮*/
@property (nonatomic , strong) UIButton* xj_hideBtn;
/**换个地方*/
@property (nonatomic , strong) UIButton* xj_changePlace;

/**弹出层*/
@property (nonatomic , strong) BGHideARAndLBSView* xjHideGiftView;
/**发布模型*/
@property (nonatomic , strong) FLIssueInfoModel* xjIssueModel;


/**用来上传的 图片识别码*/
@property (nonatomic , strong) NSString* xj_compareImgStr;
/**menu to share*/
@property (nonatomic , strong) CHTumblrMenuView *menuView;
/**挖圆背景*/
@property (nonatomic , strong) BearCutOutView *cutOutView_2;
@end

@implementation XJHideGiftViewController
{
    NSString* xj_locationJD;//地址经度
    NSString* xj_locationWD;//地址纬度
    NSString* xj_locationSub;//地址
    BOOL      xj_is_push;//是不是退出去找地址 或者 加图片
    BOOL      _xj_is_needPartInfo;//是否需要领取信息
    
    NSTimer*  _xj_need_timer; //聚焦计时器
    NSInteger _xj_needi;     //聚焦计时
    BOOL      _is_nedd_timer;//是否需要继续timer  当捕捉成功时为NO
    BOOL      _is_gif_imgupdate;//是否是 gif 格式缩略图
    UIImage*  _xjVieoImage;// 视频流中截取的图
    
 
}

-(instancetype)initWithModel:(FLIssueInfoModel*)xjIssueModel
{
    self = [super init];
    if (self) {
        _xjIssueModel = xjIssueModel;
        if (_xjIssueModel==nil) {
            _xjIssueModel = [[FLIssueInfoModel alloc] init];
            xj_is_push = NO;
            _is_nedd_timer = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _is_gif_imgupdate = NO;
    // Do any additional setup after loading the view.
    [self initAVCaptureSession];
    _xj_needi = 0;
    _xj_need_timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(xj_waitJuJiao)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [self setUpGesture];
    self.effectiveScale = self.beginGestureScale = 1.0f;
//    _centerRadarView = [[Radar alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    _centerRadarView.center = self.view.center;
//    _centerRadarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.cutOutView_2];
    [self.view addSubview:self.centerRadarView];
    [self.view addSubview:self.xj_changePlace];
    [self.view addSubview:self.xj_hideBtn];
    [self.centerRadarView xj_circleStart];
    
    
    
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
- (XJCircleAnimationView *)centerRadarView {
    if (!_centerRadarView) {
        _centerRadarView = [[XJCircleAnimationView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.width)];
        _centerRadarView.center = CGPointMake(self.view.centerX, self.view.centerY -20);
    }
    return _centerRadarView;
}
- (UIButton *)xj_hideBtn{
    if (!_xj_hideBtn) {
        _xj_hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xj_hideBtn.frame = CGRectMake(FLUISCREENBOUNDS.width*0.25, FLUISCREENBOUNDS.height-140, FLUISCREENBOUNDS.width*0.5, 50);
        [_xj_hideBtn setBackgroundImage:[UIImage imageNamed:@"ar_buttonbg"] forState:UIControlStateNormal];
        [_xj_hideBtn setTitle:@"藏这里" forState:UIControlStateNormal];
        [_xj_hideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _xj_hideBtn.hidden = YES;
        [_xj_hideBtn addTarget:self action:@selector(xj_hideHere) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xj_hideBtn;
}
- (UIButton *)xj_changePlace{
    if (!_xj_changePlace) {
        _xj_changePlace = [UIButton buttonWithType:UIButtonTypeCustom];
        _xj_changePlace.frame = CGRectMake(0,0, 140, 30);
        _xj_changePlace.center = CGPointMake(self.view.centerX, FLUISCREENBOUNDS.height-70);
        _xj_changePlace.layer.cornerRadius = 15;
        _xj_changePlace.layer.masksToBounds = YES;
        [_xj_changePlace setTitle:@"换个地方" forState:UIControlStateNormal];
        [_xj_changePlace setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.4]];
        [_xj_changePlace setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _xj_changePlace.hidden = YES;
        [_xj_changePlace addTarget:self action:@selector(xj_clickToChangeplace) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xj_changePlace;
}

- (BGHideARAndLBSView *)xjHideGiftView {
    if (!_xjHideGiftView) {
//        _xjHideGiftView = [[BGHideARAndLBSView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width* 0.8, FLUISCREENBOUNDS.height* 0.7)];
        _xjHideGiftView = [[BGHideARAndLBSView alloc] initWithFrame:CGRectMake(0, 0, 260, 370)];

    }
    return _xjHideGiftView;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.hidden = NO;
    if (self.session) {
        if (xj_is_push) {
            
        } else if (!self.session.running) {
            [self.session startRunning];
//            [self performSelector:@selector(xj_setjiaodian) withObject:nil afterDelay:2];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if (self.session) {
        
        [self.session stopRunning];
    }
    [_xj_need_timer invalidate];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
        [self.view addSubview:_backView];
    }
    return _backView;
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
    //设置闪光灯为guanbi
    [device setFlashMode:AVCaptureFlashModeOff];
    [device setFocusMode:AVCaptureFocusModeAutoFocus];
    //增加设备 移动的监听
    if (!device.subjectAreaChangeMonitoringEnabled) {
        device.subjectAreaChangeMonitoringEnabled = YES;
    }
    //对设备的 是否移动做监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xj_deveiceDidMode) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];
    
    
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
    NSLog(@"%f",kMainScreenWidth);
    self.previewLayer.frame = CGRectMake(0, 0,kMainScreenWidth, kMainScreenHeight );
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
//    [self.session stopRunning];
    [self xj_upload_compareimg:_xjVieoImage];//将此图上传作为识别图片
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"takephotoClick...");
        AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
        AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
        [stillImageConnection setVideoOrientation:avcaptureOrientation];
        [stillImageConnection setVideoScaleAndCropFactor:1];
        
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
                if (self.session && self.session.running&&jpegData) {
                    [self.session stopRunning];
//                    self.xj_compareImgStr = [XJFinalTool xj_getCompareCodeWithImg:[UIImage imageWithData:jpegData]];
                    [self xj_upload_compareimg:[UIImage imageWithData:jpegData]];//将此图上传作为识别图片
                }
            }
        }];
    });
     */
}

- (void)xj_upload_compareimg:(UIImage*)img {
    
    [self saveImage:img type:2];//2的时候赋值给 xj_compareImgSt
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
            self.xj_hideBtn.hidden = NO;
            self.xj_changePlace.hidden = NO;
            [self.centerRadarView xj_done];
        }else{
            NSLog(@"聚焦模式修改失败");
        }
        
        //聚焦点的位置
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:cameraPoint];
        }
        
        /*
         @constant AVCaptureExposureModeLocked  曝光锁定在当前值
         Indicates that the exposure should be locked at its current value.
         
         @constant AVCaptureExposureModeAutoExpose 曝光自动调整一次然后锁定
         Indicates that the device should automatically adjust exposure once and then change the exposure mode to AVCaptureExposureModeLocked.
         
         @constant AVCaptureExposureModeContinuousAutoExposure 曝光自动调整
         Indicates that the device should automatically adjust exposure when needed.
         
         @constant AVCaptureExposureModeCustom 曝光只根据设定的值来
         Indicates that the device should only adjust exposure according to user provided ISO, exposureDuration values.
         
         */
//        //曝光模式
//        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
//            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
//        }else{
//            NSLog(@"曝光模式修改失败");
//        }
//        
//        //曝光点的位置
//        if ([captureDevice isExposurePointOfInterestSupported]) {
//            [captureDevice setExposurePointOfInterest:cameraPoint];
//        }
        
        
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

- (void)xj_clickToChangeplace{
    if (self.session) {
        [self.session startRunning];
        _xj_changePlace.hidden = YES;
        _xj_hideBtn.hidden = YES;
        _is_nedd_timer = YES;
        
        [self.centerRadarView xj_circleStart];
        if(!_xj_need_timer.valid){
            _xj_needi=0;
            [_xj_need_timer invalidate];
            _xj_need_timer = nil;
            _xj_need_timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self  selector:@selector(xj_waitJuJiao) userInfo:nil repeats:YES];
        }
//        [self performSelector:@selector(xj_setjiaodian) withObject:nil afterDelay:2];
    }
    
}
- (void)xj_hideHere{
//    XJArHideGiftView *view = [[XJArHideGiftView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width* 0.8, FLUISCREENBOUNDS.height* 0.7)];
    
    _xj_changePlace.hidden = YES;
    _xj_hideBtn.hidden = YES;
    _is_nedd_timer = NO;
    
    __weak typeof(self) weakSelf = self;
    self.xjHideGiftView.parentVC = weakSelf;
    [self.xjHideGiftView xjHideGiftBack:^(NSString *xjtitle, NSString* xjNumber, NSString *xj_xiansuo, NSString *xj_range, BOOL xj_ispartinfo,NSInteger LBSorAR) {
        FL_Log(@"%@",xjtitle);
        self.xjIssueModel.LBSorAR=LBSorAR;
        self.xjIssueModel.flactivityTopicSubjectStr = xjtitle;
        self.xjIssueModel.flactivityMaxNumberLimit = xjNumber;
        self.xjIssueModel.flactivitytopicDetailStr = xj_xiansuo?xj_xiansuo:@"";
        self.xjIssueModel.flactivityTopicRangeStr = xj_range;
        self.xjIssueModel.flactivitytopicLimitTags = xj_ispartinfo?
        @"NAME,TEL,ADDRESS":@"";
        if (xj_ispartinfo) {
            self.xjIssueModel.flactivityPickConditionKey = @"";
        }
        [weakSelf xj_publishGiftTopic];//调用
    }];
    //添加图片
    [self.xjHideGiftView  xjClickToAddImg:^{
        [weakSelf xj_AddImageAction];
    }];
    //添加 地址
    [self.xjHideGiftView xjClickToChooseMap:^{
        FLChooseMapViewController* map = [[FLChooseMapViewController alloc] init];
        map.delegate = weakSelf;
        xj_is_push = YES;
        [weakSelf.navigationController pushViewController:map animated:YES];
        [weakSelf lew_dismissPopupView];
    }];
    [self lew_presentPopupView:self.xjHideGiftView animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
        weakSelf.xj_changePlace.hidden = NO;
        weakSelf.xj_hideBtn.hidden = NO;
    }];
}

#pragma mark -----------------delegate

- (void)FLChooseMapViewController:(FLChooseMapViewController *)chooseMapvc didInputReturnLocation:(NSString *)chooseLocationJ Location:(NSString *)chooseLocationW title:(NSString *)title subtitle:(NSString *)subtitle {
//    XJArHideGiftView *view = [[XJArHideGiftView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width* 0.8, FLUISCREENBOUNDS.height* 0.7)];
    __weak typeof(self) weakSelf = self;
    self.xj_hideBtn.hidden = YES;
    self.xj_changePlace.hidden = YES;
    self.xjHideGiftView.parentVC = weakSelf;
    self.xjHideGiftView.xjLocationStr = title;
    [self.xjHideGiftView xjHideGiftBack:^(NSString *xjtitle, NSString* xjNumber, NSString *xj_xiansuo, NSString *xj_range, BOOL xj_ispartinfo,NSInteger LBSorAR) {
        FL_Log(@"%@",xjtitle);
        if (![XJFinalTool xjStringSafe:chooseLocationJ] ||![XJFinalTool xjStringSafe:chooseLocationW] ) {
            [FLTool showWith:@"地址信息不能为空"];
            return ;
        }
        xj_locationJD = chooseLocationJ;
        xj_locationWD = chooseLocationW;
        xj_locationSub = subtitle;
        self.xjIssueModel.LBSorAR=LBSorAR;
        self.xjIssueModel.flactivityTopicSubjectStr = xjtitle;
        self.xjIssueModel.flactivityMaxNumberLimit = xjNumber;
        self.xjIssueModel.flactivitytopicDetailStr = xj_xiansuo?xj_xiansuo:@"";
        self.xjIssueModel.flactivityTopicRangeStr = xj_range;
        self.xjIssueModel.flactivitytopicLimitTags = xj_ispartinfo?@"NAME,TEL,ADDRESS":@"";
        if (xj_ispartinfo) {
            self.xjIssueModel.flactivityPickConditionKey = @"";
        }
        [weakSelf xj_publishGiftTopic];//调用
    }];
    [self lew_presentPopupView:self.xjHideGiftView animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
}

#pragma mark -------------开始上传信息来发布 礼包活动
- (void)xj_publishGiftTopic {
    
    if (![XJFinalTool xjStringSafe:self.xjIssueModel.flactivitytopicThumbnailFileName]) {
        [FLTool showWith:@"礼物美照不能为空哟"];
        return;
//        self.xjIssueModel.flactivitytopicThumbnailFileName = @"189539124869.png";
//        self.xjIssueModel.flactivitytopicThumbnailStr = @"http://pic.58pic.com/58pic/14/73/09/42A58PICmtI_1024.jpg";
    }
    if (![XJFinalTool xjStringSafe:xj_locationJD] ||![XJFinalTool xjStringSafe:xj_locationWD] ) {
        
//        xj_locationJD = @"39.971510";
//        xj_locationWD = @"116.326195";
        [FLTool showWith:@"地址信息不能为空"];
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //开始时间
    NSDate* xjnow = [NSDate date];
    NSString* xjnowStr = [FLTool returnStrWithNSDate: xjnow AndDateFormat:@"yyyy-MM-dd HH:mm"];
    //截止时间
    NSTimeInterval interval = 60 * 60 * 24 * 7;
    NSString *xjendStr = [dateFormatter stringFromDate:[xjnow initWithTimeInterval:interval sinceDate:xjnow]];
    NSDate* xjend  = [dateFormatter dateFromString:xjendStr];
    
    //失效时间
    NSString *xjinvi = [dateFormatter stringFromDate:[xjend initWithTimeInterval:interval sinceDate:xjend]];
    
    FL_Log(@"test -  1=【%@】\n  2=【%@】\n 3=【%@】\n 4=【%@】\n 5=【%@】\n 6=【%@】\n 7=【%@】\n 8=【%@】\n 9=【%@】\n ",
           FLFLXJUserTypePersonStrKey,
           self.xjIssueModel.flactivityTopicSubjectStr,
           self.xjIssueModel.flactivitytopicThumbnailFileName,
           self.xjIssueModel.flactivitytopicDetailStr,
           self.xjIssueModel.flactivityTopicRangeStr,
           self.xjIssueModel.flactivityTopicIntroduceStr?self.xjIssueModel.flactivityTopicIntroduceStr:@"",
           self.xjIssueModel.flactivityMaxNumberLimit,
           self.xj_compareImgStr,
           self.xjIssueModel.url?self.xjIssueModel.url:@""
           );
    
    NSDictionary* parm = @{@"state": @"1",
                           @"topicType": FLFLXJUserTypePersonStrKey, //全免费、优惠券、个人
                           @"userId":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"creator":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
                           @"userType":FLFLIsPersonalAccountType?FLFLXJUserTypePersonStrKey:FLFLXJUserTypeCompStrKey,
                           @"topicTag":@"AR", //分类
                           FLFLXJIssueInfoStartTimeKey:[NSString stringWithFormat:@"%@:00",xjnowStr] ,//开始时间
                           @"thumbnail": self.xjIssueModel.flactivitytopicThumbnailFileName,//缩略图
                           @"detailchart": self.xjIssueModel.flactivitytopicDetailchartFileName,//轮播图
                           @"topicTheme": self.xjIssueModel.flactivityTopicSubjectStr,
                           @"details": self.xjIssueModel.flactivitytopicDetailStr,//图文详情
                           @"endTime": [NSString stringWithFormat:@"%@:00",xjendStr], //截止时间
                           @"invalidTime": [NSString stringWithFormat:@"%@:00",xjinvi],// 失效时间
                           @"topicPrice": @"",// 价值
                           @"topicRange": self.xjIssueModel.flactivityTopicRangeStr, // 领取范围
                           @"partInfo": self.xjIssueModel.flactivitytopicLimitTags,   //使用者提交的信息
                           @"lbsOnly":[NSString stringWithFormat:@"%ld",self.xjIssueModel.LBSorAR],
                           //isLBSonly = "2";//1:LBS 2：AR+KBS
                           @"topicExplain": self.xjIssueModel.flactivityTopicIntroduceStr?self.xjIssueModel.flactivityTopicIntroduceStr:@"", // 使用说明
                           @"topicCondition":FLFLXJSquareIssueNonePick, //领取条件
                           @"lowestNum":  @"",// 最低助力
                           @"rule": FLFLXJSquareIssuePerOnce,//领取规则
                           @"ruleTimes": @"",// 没人几次
                           @"zlqRule":  @"",// 助力规则
                           @"longitude": xj_locationJD,//地址 经度
                           @"latitude": xj_locationWD,//地址 纬度
                           @"address": self.xjHideGiftView.xjLocationStr?self.xjHideGiftView.xjLocationStr:@"",// 地址
                           @"ranges" :  @"",// 用户选择的好友
                           @"hideGift":@"1",//是否是藏宝 1是
                           @"topicNum":self.xjIssueModel.flactivityMaxNumberLimit,
                           @"pictureCode": self.xj_compareImgStr,
                           @"url":self.xjIssueModel.url?self.xjIssueModel.url:@""
                           };
    NSString* str = [FLTool returnDictionaryToJson:parm];
    NSDictionary* parmLa = @{@"topicPara":str,
                           @"token":XJ_USER_SESSION};
    [FLNetTool issueANewActivityWithParm:parmLa success:^(NSDictionary *data) {
        FL_Log(@"this is hide gift data= 【%@】",data[@"msg"]);
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.xjIssueModel.xjTopicId = [data[FL_NET_DATA_KEY][@"topicId"] integerValue];
            if (_is_gif_imgupdate) {
                [self xj_publishDone];
            } else {
                [self xj_getImgUrl];//请求图片路径
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)xj_getImgUrl{
    NSDictionary* parm = @{@"topic.topicId":[NSString stringWithFormat:@"%ld",self.xjIssueModel.xjTopicId]};
    [FLNetTool getDetailImageStrInHTMLWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"data in get detail imagein HTML =%@",data[FL_NET_DATA_KEY]);
        if (data) {
            NSArray* array = data[FL_NET_DATA_KEY];
            for (NSDictionary* dic in array) {
                  if ([dic[@"businesstype"] integerValue] == 1) {
                      self.xjIssueModel.flactivitytopicThumbnailStr = [XJFinalTool xjReturnImageURLWithStr:dic[@"url"] isSite:YES];
                      [self xj_publishDone];
                  }
            }
        }
    } failure:^(NSError *error) {
        [FLTool showWith:@"网络异常请稍后重试"];
    }];
}

- (void)xj_publishDone {
    [self lew_dismissPopupView];
    _xj_hideBtn.hidden = YES;
    _xj_changePlace.hidden = YES;
    [self performSelector:@selector(xj_showDone) withObject:nil afterDelay:1];
}
- (void)xj_showDone {
    __weak typeof(self) weakSelf = self;
    XJHidePublishDoneView* view = [[XJHidePublishDoneView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width* 0.8, FLUISCREENBOUNDS.height* 0.7)];
    view.parentVC = weakSelf;
    NSString* xx = [XJFinalTool xjReturnImageURLWithStr:[NSString stringWithFormat:@"%@", self.xjIssueModel.flactivitytopicThumbnailStr] isSite:NO];
    [view.xj_topicThemImgView sd_setImageWithURL:[NSURL URLWithString:xx]];
    view.xj_addressLabel.text = self.xjHideGiftView.xjLocationStr;
    [view xjClickToShareGift:^{
//        [weakSelf lew_dismissPopupView];
        [weakSelf showMenu];
    }];
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark  -----------------image picker 
- (void)xj_AddImageAction {
    UIActionSheet* actionSheet  = [[UIActionSheet alloc]initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"从相册选取",@"gif库",@"免费啦礼包库", nil];
    [actionSheet showInView:self.view];
}

#pragma mark --- action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    xj_is_push = YES;
    if (buttonIndex == 0)  {
        //       拍照
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        picker.delegate   = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1) {
        //        相册
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        //设置图片源(相册)
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate   = self;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [picker setMediaTypes:[[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil]];
        //设置可以编辑
        picker.allowsEditing = YES;
//        picker.view.backgroundColor = [UIColor whiteColor];
        //打开拾取界面
        [self presentViewController:picker animated:YES completion:nil];
    } else if(buttonIndex == 2){
        //gif
        XJPickARGiftGifViewController* gifVC = [[XJPickARGiftGifViewController alloc] initWithDelegate:self];
        UINavigationController* na = [[UINavigationController alloc] initWithRootViewController:gifVC];
//        [self.navigationController pushViewController:gifVC animated:YES];
        [self presentViewController:na animated:YES completion:nil];
        
    }  else if(buttonIndex == 3){
        //gif
        XJPickARGiftCustiomViewController* gifVC = [[XJPickARGiftCustiomViewController alloc] initWithDelegate:self];
        UINavigationController* na = [[UINavigationController alloc] initWithRootViewController:gifVC];
        [self presentViewController:na animated:YES completion:nil];
    }
}
//imagePicker did delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _is_gif_imgupdate = NO;
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *editedImage, *orginalIma,*imageToUse;
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
    {
        editedImage = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
        orginalIma =  (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = orginalIma;
        }
        
        //将该图像保存到媒体库中
        //        UIImageWriteToSavedPhotosAlbum(imageToUse, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
    }
    FL_Log(@"消失之前");
    dispatch_async(dispatch_get_main_queue(), ^{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (imageToUse) {
        [self  saveImage: imageToUse type:1];
    }
    FL_Log(@"消失之后");
     });
    
}
//保存到本地的回调方法
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.in first");
    }
    else
    {
        NSLog(@"error occured while saving the picture%@", error);
    }
}

- (void)saveImage:(UIImage*)image type:(NSInteger)xjtype{
    
//    image = [XJFinalTool xj_fixOrientation:image];
    
    if (xjtype==1) {
       [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
    }
//    [FLTool showWith:@"请稍后"];
    
        //            [self.portraitBtn setBackgroundImage:selfPhoto forState:UIControlStateNormal];
    NSInteger iii = xjtype==1?1:4;
    NSDictionary* parm = @{@"token":XJ_USER_SESSION,
                           @"userId":XJ_USERID_WITHTYPE,
                           @"picType":[NSNumber numberWithInteger:iii]
                           };
    UIImage* xjimage = [XJFinalTool xj_fixOrientation:image];
//    UIImageView* xjim = [[UIImageView alloc] initWithImage:image];
//    [self.view addSubview:xjim];
//    xjim.frame = CGRectMake(100, 100, 200, 300);
    
    FL_Log(@"=======dsad【%ld】",(long)xjimage.imageOrientation);
    [FLNetTool setIssueDetailImage:xjimage parm:parm success:^(NSDictionary *data) {
        FL_Log(@"成功nnsdadsafaweqwnnnnnnnn = %@",data);
        if ([[data objectForKey:@"success"] boolValue]) {
            NSString* imageUrlStr =  data[FL_NET_DATA_KEY][@"result"];
            NSString* imageUrlName =  data[FL_NET_DATA_KEY][@"filename"];
            if (xjtype==1) {
                self.xjIssueModel.flactivitytopicThumbnailStr = [XJFinalTool xjReturnImageURLWithStr:imageUrlStr isSite:NO];
                self.xjIssueModel.flactivitytopicThumbnailFileName = imageUrlName;
                //            [FLTool showWith:[NSString stringWithFormat:@"请稍后==【%@】",data]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.xjHideGiftView.xj_topicThBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:imageUrlStr isSite:NO]]] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    }];
                });
            }else {
                //轮播图作为 线索图
                self.xjIssueModel.flactivitytopicDetailchartArr = @[[XJFinalTool xjReturnImageURLWithStr:imageUrlStr isSite:NO]];
                self.xjIssueModel.flactivitytopicDetailchartFileName = imageUrlName;
                self.xj_compareImgStr = [XJFinalTool xj_getCompareCodeWithImg:image];
            }
        }
        [[FLAppDelegate share] hideHUD];
    } failure:^(NSError *error) {
        [[FLAppDelegate share] hideHUD];
//         [FLTool showWith:[NSString stringWithFormat:@"请稍后==【%@】",error]];
    }];
}
//改变图片尺寸，方便服务器上传

#warning  回头一定要搞明白这个算法
//2.保存图片尺寸长款比，生成需要尺寸的图片
- (UIImage*)thumbnailWithImageWithoutScale:(UIImage*)image size:(CGSize)asize
{
    UIImage* newImage;
    if (nil == image)
    {
        image = nil;
    }
    else
    {
        CGSize oldSize = image.size;
        CGRect rect;
        if (asize.width / asize.height > oldSize.width / oldSize.height)
        {
            rect.size.width = asize.height * oldSize.width  / oldSize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        }
        else
        {
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldSize.height / oldSize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor]CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}

#pragma  mark ------------------------ 等待聚焦
- (void)xj_waitJuJiao {
    _xj_needi +=1;
    FL_Log(@"这里是等待聚焦 的状态【%ld】",_xj_needi);
    if (_xj_needi>3) {
        _is_nedd_timer = NO;
        [_xj_need_timer invalidate];
        _xj_need_timer = nil;
        [self xj_setjiaodian];
    }
}

- (void)xj_deveiceDidMode{
    if (_is_nedd_timer) {
        _xj_needi=0;
        if(_xj_need_timer.valid){
            [_xj_need_timer invalidate];
            _xj_need_timer = nil;
            _xj_need_timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(xj_waitJuJiao)
                                                            userInfo:nil
                                                             repeats:YES];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma  mark  -------------------------- 分享
- (void)showMenu {
    
    if (_menuView) {
        [_menuView removeFromSuperview];
        _menuView = nil;
    }
    _menuView = [[CHTumblrMenuView alloc] init];
    __weak typeof(self) weakSelf = self;
    NSArray* nameArray = @[@"微信",@"朋友圈",@"QQ",@"QQ空间",@"新浪",@"免费啦"];
    NSArray* imageArray = @[@"share_wechat",@"share_friend",@"share_qq",@"share_qzone",@"share_sina",@"share_mianfeila"];
    NSArray* typeArray = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,@"freela"];
    for (NSInteger i = 0; i < nameArray.count; i ++ )
    {
        [_menuView addMenuItemWithTitle:nameArray[i] andIcon:[UIImage imageNamed:imageArray[i]] andSelectedBlock:^{
            FL_Log(@"Phot2o selected= %ld",i);
            [weakSelf shareToWithType:typeArray[i]];
        }];
    }
    [_menuView show];
}
- (void)shareToWithType:(NSString*)type
{
    if ([type isEqualToString:@"freela"]) {
        
    } else {
        NSInteger xjType ;
        if ([type isEqualToString:@"qq"]) {
            xjType = 1;
        } else if ([type isEqualToString:@"qzone"]) {
            xjType = 2;
        } else if ([type isEqualToString:@"wxsession"]) {
            xjType = 3;
        } else if ([type isEqualToString:@"wxtimeline"]) {
            xjType = 4;
        } else if ([type isEqualToString:@"sina"]) {
            xjType = 5;
        }
        
//        NSString* xjRelayContentStr = [NSString stringWithFormat:@"http://www.freela.com.cn/WeiXinOt/arTranspond.html"];
        
        NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@/jsp/transpond/transpond-artranspond.jsp?topicId=%ld&userId=%@&userType=%@",FLBaseUrl,self.xjIssueModel.xjTopicId,XJ_USERID_WITHTYPE,XJ_USERTYPE_WITHTYPE];
        
        NSString* da = self.xjIssueModel.flactivitytopicThumbnailStr;
        FL_Log(@"dasaiaf=【%@】",da);
        
        NSString* xjtu = [XJFinalTool xjReturnImageURLWithStr:[NSString stringWithFormat:@"%@", self.xjIssueModel.flactivitytopicThumbnailStr] isSite:NO];
        
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:xjtu];
        [UMSocialData defaultData].extConfig.title = self.xjIssueModel.flactivityTopicSubjectStr;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.qqData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.qzoneData.url = xjRelayContentStr;
        [UMSocialData defaultData].extConfig.sinaData.urlResource = [UMSocialData defaultData].urlResource;
        
         NSString* xjTopicExpline =  @"我给你藏好了一个AR大礼包，速速来找吧~";
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:xjTopicExpline image:nil location:nil urlResource:[UMSocialData defaultData].urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                FL_Log(@"分享成功！");
//                [self flRelayTopicWithNoTypeInHTMLVC];//插入转发记录
            }
        }];
    }
}

#pragma mark ---------------pick gif delegate
- (void)xjPickARGiftGifViewController:(XJPickARGiftGifViewController*)chooseGif didchooseDone:(NSString*)filename imgurl:(NSString*)imgurl{
    FL_Log(@"ssssss==-=【%@】",imgurl);
    _is_gif_imgupdate = YES;
    self.xjIssueModel.flactivitytopicThumbnailFileName = imgurl;
    self.xjIssueModel.flactivitytopicThumbnailStr = imgurl;
//    [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
    [self.xjHideGiftView.xj_topicThBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:imgurl isSite:NO]]] forState:UIControlStateNormal];
}
- (void)xjPickARGiftCustiomViewController:(XJPickARGiftCustiomViewController*)chooseCus
                                      img:(UIImage*)img
                                introduce:(NSString*)introduce
                                      url:(NSString*)url  {
    FL_Log(@"ssssssdadsas==-=【%@】",url);
    _is_gif_imgupdate = NO;
    [self saveImage:img type:1];
    self.xjIssueModel.flactivityTopicIntroduceStr = introduce;
    self.xjIssueModel.url = url;
 
    
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // 通过抽样缓存数据创建一个UIImage对象
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
  
    
    //    NSLog(@"??????==%ld",_xj_needi);
    if (_xj_needi==3) {
        _xjVieoImage = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.session stopRunning];
        });
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







