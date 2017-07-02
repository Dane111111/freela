//
//  XJOnlySaoMiaoViewController.m
//  FreeLa
//
//  Created by Leon on 2017/1/10.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJOnlySaoMiaoViewController.h"
#import <AVFoundation/AVFoundation.h>
// 作者自定义的View视图, 继承UIView
#import "XJShadowView.h"
#import "XJEmptyViewController.h"
#import "Radar.h"
#import "XJGiftPickSuccessView.h"
#import "LewPopupViewController.h"
#import "XJGiftMapViewController.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define customShowSize CGSizeMake(200, 200);

@interface XJOnlySaoMiaoViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>
/** 输入数据源 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/** 输出数据源 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;

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

@end

@implementation XJOnlySaoMiaoViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    //显示范围
    self.showSize = customShowSize;
    //调用
    [self creatScanQR];
    //添加拍摄图层
    [self.view.layer addSublayer:self.layerView];
    //开始二维码
    [self.session startRunning];
    //设置可用扫码范围
    [self allowScanRect];
    
    //添加上层阴影视图
    //    [self.view addSubview:self.shadowView];
    
    [self.view addSubview:self.flGoBackBtn];
    [self.view addSubview:self.flLigthBtn];
    
    [self createBottomView];
    
    if (_flComeType==1) {
        
    } else if(_flComeType==2){
        
    }
    
}
#pragma mark --------------------------init
- (XJShadowView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[XJShadowView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight )];
        _shadowView.showSize = self.showSize;
    }
    return _shadowView;
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)xj_stop {
    if (self.session&& self.session.isRunning) {
        [self.session stopRunning];
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
        [self.session addOutput:self.stillImageOutput];
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
}


#pragma mark -------------------------- 实现代理方法, 完成二维码扫描
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count > 0) {
        
        // 停止动画, 看完全篇记得打开注释, 不然扫描条会一直有动画效果
        //        [self.shadowView stopTimer];
        //停止扫描
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
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

@end
