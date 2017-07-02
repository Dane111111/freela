////
////  FLSaoMiaoViewController.m
////  FreeLa
////
////  Created by Leon on 16/1/12.
////  Copyright © 2016年 FreeLa. All rights reserved.
////
//
//#import "FLSaoMiaoViewController.h"
//#import "XJEmptyViewController.h"
//#import <ZXingObjC/ZXingObjC.h>
//#import "Radar.h"
//#import "XJGiftMapViewController.h"
//#import "XJGiftPickSuccessView.h"
//#import "LewPopupViewController.h"
//
//@interface FLSaoMiaoViewController ()<ZXCaptureDelegate,UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//{
//    AVCaptureSession * session;//输入输出的中间桥梁
//    BOOL  _xj_is_pushed; //是否已推
//    BOOL  _xj_is_Ar;  //是否是 ar 模式
//    NSInteger xj_needi; //动画需要的 值
//    
//}
//@property (weak, nonatomic) IBOutlet UIImageView *flimageView;
//@property (weak, nonatomic) IBOutlet UIButton *flGoBackBtn;
//@property (weak, nonatomic) IBOutlet UIButton *flLigthBtn;
//
//@property (nonatomic , strong) Radar * centerRadarView;
//@property (nonatomic , strong) UIButton * xjGiftMapBtn; //礼物按钮
//@property (nonatomic , strong) UILabel * xjGiftMapLabel;
//
///**取景框*/
//@property (nonatomic , strong) UIImageView* flKimageView;
///**相册view*/
//@property (nonatomic , strong) UIView* flbottomView;
///**相册Btn*/
//@property (nonatomic , strong) UIButton* flImageBtn;
//@property (nonatomic, strong) UIImagePickerController *imagePickerController;
//
//@property(strong,nonatomic)ZXCapture* capture;
///**最后一次结果*/
//@property (nonatomic) BOOL lastResut;
///**动画*/
//@property (nonatomic , strong) UIImageView* xj_searchGiftDoneImgView;
///**动画需要的数组*/
//@property (nonatomic , strong) NSArray* xj_GiftDoneImgViewArr;
///**添加在动画中间的button*/
//@property (nonatomic , strong) UIButton* xj_allBtn;
//
//@end
//
@implementation FLSaoMiaoViewController : NSObject  
@end
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    _xj_is_Ar = NO;
//    _xj_is_pushed = NO;
//    [self creatSaoMiaoInSelfVC];
//    [self creatBottomBtn];
//    [self createBottomView];
//    _lastResut = YES;
//    self.flLigthBtn.selected = NO;
//    
//}
//
//
//- (void)createBottomView
//{
//    //取景框
//    self.flKimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saomiao_qujing_white"]];
//    CGFloat imageX = FLUISCREENBOUNDS.width * 0.2;
//    CGFloat imageY = FLUISCREENBOUNDS.height * 0.3;
//    CGFloat imageW = FLUISCREENBOUNDS.width * 0.6;
//    CGFloat imageH = FLUISCREENBOUNDS.width * 0.6;
//    self.flKimageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
//    [self.view addSubview:self.flKimageView];
//    //从相册选择
//    self.flbottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
//    self.flbottomView.center  =  CGPointMake(self.flKimageView.centerX, imageY+imageH+30);
//    [self.view addSubview:self.flbottomView];
////    [self.flbottomView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.flimageView).with.offset(FLUISCREENBOUNDS.height * 0.3 + FLUISCREENBOUNDS.width * 0.6 + 30);
////        make.centerX.equalTo(self.flimageView).with.offset(0);
////        make.size.mas_equalTo(CGSizeMake(130, 40));
////    }];
//    self.flbottomView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.7];
//    self.flbottomView.layer.cornerRadius = 20;
//    self.flbottomView.layer.masksToBounds = YES;
//    //logo
//    UIImageView* logoIamge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mypublish_btn_search"]];
//    logoIamge.frame = CGRectMake(15, 10, 20, 20);
//    [self.flbottomView addSubview:logoIamge];
//    //label
//    UILabel* label = [[UILabel alloc] init];
//    label.text = @"从相册选择";
//    label.textColor = [UIColor whiteColor];
//    label.frame = CGRectMake(40, 0, 80, 40);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont fontWithName:FL_FONT_NAME size:XJ_LABEL_SIZE_LARGE];
//    [self.flbottomView addSubview:label];
//    
//    self.flImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.flImageBtn.frame = CGRectMake(0, 0, 130, 40);//self.flbottomView.frame;
//    [self.flbottomView addSubview:self.flImageBtn];
//   
//    
//    [self.flImageBtn addTarget:self action:@selector(clickToPickImageFromLoco) forControlEvents:UIControlEventTouchUpInside];
//    self.flImageBtn.layer.cornerRadius = 20;
//    self.flImageBtn.layer.masksToBounds = YES;
//    
//    
//    //ar 界面 的 地图按钮
//    self.xjGiftMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.xjGiftMapBtn.frame = CGRectMake(FLUISCREENBOUNDS.width * 0.8, FLUISCREENBOUNDS.height - 180, 40, 40);
//    self.xjGiftMapBtn.backgroundColor = [UIColor blackColor];
//    [self.xjGiftMapBtn addTarget:self action:@selector(xjgoGiftMap) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.xjGiftMapLabel = [[UILabel alloc] init];
//    self.xjGiftMapLabel.frame = CGRectMake(FLUISCREENBOUNDS.width * 0.8-10, FLUISCREENBOUNDS.height - 140, 60, 20);
//    self.xjGiftMapLabel.text = @"礼物地图";
//    self.xjGiftMapLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
//    self.xjGiftMapLabel.textAlignment = NSTextAlignmentCenter;
//    self.xjGiftMapLabel.textColor = [UIColor whiteColor];
//    
//    
//}
//
//- (void)creatBottomBtn
//{
//    UIButton* xjLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:xjLeftBtn];
//    xjLeftBtn.frame = CGRectMake(FLUISCREENBOUNDS.width * 0.2, FLUISCREENBOUNDS.height - 100, 40, 40);
//    UILabel* xjleftLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width * 0.2, FLUISCREENBOUNDS.height - 60, 40, 20)];
//    [self.view addSubview:xjleftLabel];
//    xjleftLabel.text = @"扫码";
//    xjleftLabel.textAlignment =NSTextAlignmentCenter;
//    xjleftLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
//    xjleftLabel.textColor = [UIColor whiteColor];
//     xjLeftBtn.backgroundColor = [UIColor blackColor];
//    [xjLeftBtn addTarget:self action:@selector(xj_switchStyleSao) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton* xjRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:xjRightBtn];
//    xjRightBtn.frame = CGRectMake(FLUISCREENBOUNDS.width * 0.8-40, FLUISCREENBOUNDS.height - 100, 40, 40);
//    xjRightBtn.backgroundColor = [UIColor blackColor];
//    [xjRightBtn addTarget:self action:@selector(xj_switchStyleAr) forControlEvents:UIControlEventTouchUpInside];
//    UILabel* xjRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width * 0.8 -40, FLUISCREENBOUNDS.height - 60, 40, 20)];
//    [self.view addSubview:xjRightLabel];
//    xjRightLabel.text = @"AR";
//    xjRightLabel.textAlignment =NSTextAlignmentCenter;
//    xjRightLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
//    xjRightLabel.textColor = [UIColor whiteColor];
//
//}
//
////设置切换模式
//- (void)xj_switchStyleSao {
//    if (_xj_is_Ar) {
//        [self.centerRadarView removeFromSuperview];
//        [self.view addSubview:self.flbottomView];
//        [self.view addSubview:self.flKimageView];
////        [self.view addSubview:self.flImageBtn];
//        _xj_is_Ar = NO;
//        [self.xjGiftMapLabel removeFromSuperview];
//        [self.xjGiftMapBtn removeFromSuperview];
//        //test
//        
//    }
//}
//- (void)xj_switchStyleAr{
//    if (!_xj_is_Ar) {
//        [self.flbottomView removeFromSuperview];
//        [self.flKimageView removeFromSuperview];
////        [self.flImageBtn removeFromSuperview];
//        _xj_is_Ar = YES;
//        _centerRadarView = [[Radar alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        _centerRadarView.center = self.view.center;
//        _centerRadarView.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:self.centerRadarView];
//        [self.view addSubview:self.xjGiftMapBtn];
//        [self.view addSubview:self.xjGiftMapLabel];
//        [self performSelector:@selector(xj_testToShowOK) withObject:nil afterDelay:2];
//    }
//}
//
//- (void)creatSaoMiaoInSelfVC
//{
//    // 摄像头 扫
//    self.capture = [[ZXCapture alloc]init];
//    [self.capture setCamera:1];
//    [self.capture setRotation:90];
//    [self.capture setDelegate:self];
//    [self.capture setLuminance:YES];
//    //    self.capture.scanRect = CGRectMake(FLUISCREENBOUNDS.width * 0.2,FLUISCREENBOUNDS.height * 0.3,FLUISCREENBOUNDS.width * 0.6, FLUISCREENBOUNDS.width * 0.6);
//    //    [self.capture setFocusMode:<#(AVCaptureFocusMode)#>];
//    CALayer* layer      =   self.capture.luminance;//显示彩色照片
//    layer.frame         =   CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
//    layer.borderColor   =   [UIColor clearColor].CGColor;
//    layer.borderWidth   =   0.0f;
//    
//    [self.view.layer addSublayer:self.capture.luminance];
//    [self.view.layer addSublayer:self.flKimageView.layer];
//    [self.view.layer addSublayer:self.flGoBackBtn.layer];
//    [self.view.layer addSublayer:self.flLigthBtn.layer];
//    [self.view.layer addSublayer:self.flKimageView.layer];
//    NSLog(@"%d,%d,%d",[self.capture hasBack],[self.capture hasFront],[self.capture hasTorch]);
//    self.capture.delegate=self;
//    
//}
////原生扫描
//- (void) iosClickSaoMiao
//{
//    //获取摄像设备
//    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    //创建输入流
//    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//    //创建输出流
//    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
//    //设置代理 在主线程里刷新
//    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    
//    //初始化链接对象
//    session = [[AVCaptureSession alloc]init];
//    
//    //高质量采集率
//    [session setSessionPreset:AVCaptureSessionPresetHigh];
//    
//    [session addInput:input];
//    [session addOutput:output];
//    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
//    //设置框
//    output.rectOfInterest=CGRectMake(0.3,0.2,0.6, 0.6);
//    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
//    layer.frame=CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height);
//    [self.view.layer insertSublayer:layer atIndex:0];
//    //开始捕获
//    [session startRunning];
//}
//
//- (void)stopReading
//{
//    [self.capture stop];
//    
//}
//#pragma mark 扫码
//- (void)reportScanResult:(NSString *)result
//{
//    [self stopReading];
//    if (!_lastResut) {
//        return;
//    }
//    _lastResut = NO;
//    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"二维码扫描"
//    //                                                    message:result
//    //                                                   delegate:self
//    //                                          cancelButtonTitle:@"取消"
//    //                                          otherButtonTitles: nil];
//    //    [alert show];
//    [self flUseDetailsTicketsInSaoMiaoVCWithStr:result];
//    // 以及处理了结果，下次扫描
//}
//
//#pragma mark 进活动
//- (void)goToXQHTMLPage:(NSString*)flstr
//{
//    [self stopReading];
//    FL_Log(@"this is my test erweima sao html=%@",flstr);
//    if (!_lastResut) {
//        return;
//    }
//    //    if (![flstr integerValue]) {
//    //        [FLTool showWith:@"二维码失效"];
//    //        [self.capture start];
//    //        return;
//    //    }
//    //
//    [self gotoHTMLPageWithTopicId:flstr];
//}
//
//- (void)gotoHTMLPageWithTopicId:(NSString*)flTopicId
//{
//    if ([flTopicId rangeOfString:@"topic.topicId="].location != NSNotFound) {
//        //        NSString* xjbaseUrl = @"www.freela.com.cn";
//        //        NSString* xjRelayContentStr = [NSString stringWithFormat:@"%@/transpond/transpond!isTranspond.action?topic.topicId=%@",FLBaseUrl,str];
//        NSInteger topicIndex = [flTopicId rangeOfString:@"topic.topicId="].location;
//        flTopicId = [flTopicId substringFromIndex:topicIndex+14];
//        if ([flTopicId rangeOfString:@"&"].location !=NSNotFound ) {
//            NSInteger xj = [flTopicId rangeOfString:@"&"].location;
//            flTopicId = [flTopicId substringToIndex:xj];
//        }
//        FL_Log(@"this is final topic str =%@",flTopicId);
//    }
//    
//    _lastResut = NO;
//    if (![flTopicId integerValue]) {
//        [FLTool showWith:@"二维码失效"];
//        [self.capture start];
//        return;
//    }
//    //    [self.navigationController popToRootViewControllerAnimated:YES];
//    FLFuckHtmlViewController* htmlVC = [[FLFuckHtmlViewController alloc] init];
//    htmlVC.flFuckTopicId = flTopicId;
//    [self.navigationController pushViewController:htmlVC animated:YES];
//}
//
//- (void)systemLightSwitch:(BOOL)open
//{
//    
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    if ([device hasTorch]) {
//        [device lockForConfiguration:nil];
//        if (open) {
//            [device setTorchMode:AVCaptureTorchModeOn];
//        } else {
//            [device setTorchMode:AVCaptureTorchModeOff];
//        }
//        [device unlockForConfiguration];
//    }
//}
//
//#pragma mark  delegate
//-(void)captureSize:(ZXCapture *)capture width:(NSNumber *)width height:(NSNumber *)height{
//    NSLog(@"1%s",__func__);
//}
//- (void)captureCameraIsReady:(ZXCapture *)capture{
//    NSLog(@"2%s",__func__);
//}
//
//
//- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
//{
//    FL_Log(@"Anything is right!!!");
//    FL_Log(@"result = %@",result);
//    NSString* str = [NSString stringWithFormat:@"%@",result];
//    if (_flComeType == 1) {
//        //        if ([str rangeOfString:@"topic.topicId="].location == NSNotFound) {
//        //            [FLTool showWith:@"不是有效的活动二维码"];
//        //            return;
//        //        }
//        //进活动 跳转到详情页
//        //        [self goToXQHTMLPage:str];
//        [self xjSaoMiaoResultWithResult:result.text];
//    } else if (_flComeType == 2) {
//        //验票
//        [self reportScanResult:str];
//    }
//}
//
//- (void)setFlmodel:(FLMyIssueInMineModel *)flmodel
//{
//    _flmodel = flmodel;
//}
//
//- (void)flUseDetailsTicketsInSaoMiaoVCWithStr:(NSString*)str {
//    _lastResut = NO;
//    NSDictionary* parm = @{@"token":XJ_USER_SESSION,
//                           @"participateDetailes.userType":XJ_USERTYPE_WITHTYPE,
//                           @"participateDetailes.detailsid":str,
//                           @"participateDetailes.topicId":_flmodel.flMineIssueTopicIdStr,
//                           @"participateDetailes.userId":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
//                           @"participateDetailes.creator":FLFLIsPersonalAccountType ? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,
//                           @"participateDetailes.checkUser":FL_USERDEFAULTS_USERID_NEW
//                           };
//    [FLNetTool fluseDetailesByIDWithParm:parm success:^(NSDictionary *data) {
//        FL_Log(@"data in use details in saomiao view= %@",data);
//        //        if ([data[FL_NET_DATA_KEY]boolValue]) {
//        //        NSString* strdic = [FLTool returnDictionaryToJson:parm];
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",data[@"msg"]] message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续验证", nil];
//        [alert show];
//        _lastResut = YES;
//        //        }
//        
//    } failure:^(NSError *error) {
//        FL_Log(@"this is error in saomiao =%@",error);
//        [self.capture start];
//    }];
//}
//#pragma mark alertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//        FL_Log(@"000000000000");
//        [self.capture start];
//    } else {
//        FL_Log(@"111111111111");
//        [self.capture start];
//        _lastResut = YES;
//    }
//}
//
//
//#pragma - mark - UIImagePickerViewControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//        [self getInfoWithImage:image];
//    }];
//}
//
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self stopReading];
//    
//    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
//    
//}
//
//#pragma mark 照片处理
//
//-(void)getInfoWithImage:(UIImage *)img{
//    
//    UIImage *loadImage= img;
//    CGImageRef imageToDecode = loadImage.CGImage;
//    
//    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
//    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
//    
//    NSError *error = nil;
//    
//    ZXDecodeHints *hints = [ZXDecodeHints hints];
//    
//    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
//    ZXResult *result = [reader decode:bitmap
//                                hints:hints
//                                error:&error];
//    
//    if (result) {
//        
//        NSString *contents = result.text;
//        switch (_flComeType) {
//            case 1:
//            {
//                [self xjSaoMiaoResultWithResult:contents];
//                //                [self gotoHTMLPageWithTopicId:contents];//version1
//            }
//                break;
//            case 2:
//            {
//                [self flUseDetailsTicketsInSaoMiaoVCWithStr:contents];
//                
//            }
//                break;
//            default:
//                break;
//        }
//        
//        FL_Log(@"相册图片contents == %@",contents);
//        
//    } else {
//        
//        [self showInfoWithMessage:nil andTitle:@"解析失败"];
//        
//    }
//}
//
//- (void)showInfoWithMessage:(NSString *)message andTitle:(NSString *)title
//{
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
//    [alter show];
//    
//}
//
//
//
//#pragma mark Actions
//- (void)clickToPickImageFromLoco {
//    [self stopReading];
//    if (!_imagePickerController) {
//        _imagePickerController = [[UIImagePickerController alloc] init];
//        _imagePickerController.navigationBar.tintColor = [UIColor blackColor];
//        [_imagePickerController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
//        _imagePickerController.delegate = self;
//        _imagePickerController.allowsEditing = YES;
//        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    
//    [self presentViewController:self.imagePickerController animated:YES completion:nil];
//}
//
//- (IBAction)flligthOnOff:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    [self systemLightSwitch:sender.selected];
//    
//}
//
//- (IBAction)flGoBackBtn:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    
//    if (_lastResut) {
//        _xj_is_pushed = NO;
//        [self.capture start];
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = NO;
//    [self stopReading];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//}
//
//- (BOOL)xjHasStrLong:(NSString*)xjOld new:(NSString*)new {
//    if ([xjOld rangeOfString:new].location!=NSNotFound) {
//        return YES;
//    }
//    return NO;
//}
//
//#pragma mark -----------------------------更改后的扫码 1
//- (void)xjSaoMiaoResultWithResult:(NSString*)xjResult {
//    NSString* xjTopicId = @"topic.topicId=";
//    NSString* xjUserId = @"&userId=";
//    NSString* xjUserType = @"&userType=";
//    _lastResut = NO;
//    [self stopReading];
//    //    if ([self xjHasStrLong:xjResult new:xjTopicId]&&![self xjHasStrLong:xjResult new:xjUserId]&&![self xjHasStrLong:xjResult new:xjUserType]) {
//    //        [self gotoHTMLPageWithTopicId:xjResult];//跳详情
//    //    } else if ([self xjHasStrLong:xjResult new:@"{"]&&[self xjHasStrLong:xjResult new:@"}"]) {
//    //        FL_Log(@"this result is the json str");
//    //        NSDictionary* xjDic = [FLTool returnDictionaryWithJSONString:xjResult];
//    //        NSInteger xjTopidId = [xjDic[@"topicId"] integerValue];
//    //        NSNumber* xjTempId  = [NSNumber numberWithInteger:[xjDic[@"templateId"] integerValue]];
//    //        if (!xjTopidId) {
//    //            if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:xjResult]]) {
//    //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:xjResult]];
//    //            }//浏览器
//    //        } else {
//    //            XJLoadOutURLController* xjlo = [[XJLoadOutURLController alloc] init];//自己的H5
//    //            xjlo.xjTempId = xjTempId;
//    //            xjlo.xjTopicIdStr = [NSString stringWithFormat:@"%ld",xjTopidId];
//    //            [self.navigationController pushViewController:xjlo animated:YES];
//    //        }
//    //    } else if ([self xjHasStrLong:xjResult new:@"http://"]) {
//    //        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:xjResult]]) {
//    //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:xjResult]];
//    //        }//浏览器
//    //    } else {
//    //        //显示内容
//    //        XJEmptyViewController* xjx = [[XJEmptyViewController alloc] initWithNibName:@"XJEmptyViewController" bundle:nil];
//    //        xjx.xjContentStr = xjResult;
//    //        [self.navigationController pushViewController:xjx animated:YES];
//    //    }
//    //    _lastResut = YES;
//    //
//    if ([self xjHasStrLong:xjResult new:xjTopicId]&&[self xjHasStrLong:xjResult new:@"http://"]) {
//        if (!_xj_is_pushed) {
//            _xj_is_pushed = YES;
//            [self gotoHTMLPageWithTopicId:xjResult];//跳详情//详情
//        }
//    } else if ([self xjHasStrLong:xjResult new:@"http://"]) {
//        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:xjResult]]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:xjResult]];
//        }//浏览器
//    } else {
//        //显示内容
//        XJEmptyViewController* xjx = [[XJEmptyViewController alloc] initWithNibName:@"XJEmptyViewController" bundle:nil];
//        xjx.xjContentStr = xjResult;
//        if (!_xj_is_pushed) {
//             _xj_is_pushed = YES;
//            [self.navigationController pushViewController:xjx animated:YES];
//        }
//    }
//    _lastResut = YES;
//    
//}
//
///*********************************进入红包地图**************************************/
//- (void)xjgoGiftMap {
//    
//    XJGiftMapViewController* xjgift = [[XJGiftMapViewController alloc] init];
//    [self.navigationController pushViewController:xjgift animated:YES];
//    
//}
//
//- (UIImageView *)xj_searchGiftDoneImgView {
//    if (!_xj_searchGiftDoneImgView) {
//        _xj_searchGiftDoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height)];
//    }
//    return  _xj_searchGiftDoneImgView;
//}
//
//- (UIButton *)xj_allBtn {
//    if (!_xj_allBtn) {
//        _xj_allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _xj_allBtn.frame = CGRectMake((FLUISCREENBOUNDS.width-200)/2, (FLUISCREENBOUNDS.height-200)/2, 200, 200);
////        _xj_allBtn.hidden = YES;
//        [_xj_allBtn addTarget:self action:@selector(xj_clickToShowPickSuccess) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _xj_allBtn;
//}
//
//- (void)xj_testToShowOK {
//    NSMutableArray* xj = [NSMutableArray array];
//    for (NSInteger i = 0; i < 62; i++) {
//        if (i<10) {
//            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"合成 1_0000%ld",i]];
//            if (image) {
//                [xj addObject:image];
//            }
//        }else {
//            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"合成 1_000%ld",i]];
//            if (image) {
//                [xj addObject:image];
//            }
//        }
//    }
//    self.xj_GiftDoneImgViewArr = xj.mutableCopy;
//    //    imageView.image = [UIImage animatedImageWithImages:xj duration:3];
//    self.xj_searchGiftDoneImgView.animationImages = xj;
//    _xj_searchGiftDoneImgView.animationRepeatCount = 1;
//    
//    _xj_searchGiftDoneImgView.animationDuration = xj.count * 0.08;
//    //    [imageView startAnimating];
//    [self.view addSubview:_xj_searchGiftDoneImgView];
//    [self.view addSubview:self.xj_allBtn];
//    
//    /*****************************************************************/
//    xj_needi = -1;
//    [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(setNextImage) userInfo:nil repeats:YES];
//    
//
//}
//
//
//
//
//-(void)setNextImage
//{
//    xj_needi++;
//    if (xj_needi==self.xj_GiftDoneImgViewArr.count) {
//        return;
//    }
//    if (xj_needi<10) {
//        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"合成 1_0000%ld",xj_needi]];
//        if (image) {
//             _xj_searchGiftDoneImgView.image = image;
//        }
//    }else {
////        UIImage* image1 = [UIImage imageNamed:[NSString stringWithFormat:@"合成 1_000%ld",xj_needi]];
////        if (image1) {
////             _xj_searchGiftDoneImgView.image = image1;
////        }
//    }
//}
//
//- (void)xj_clickToShowPickSuccess{
//    
//    __weak typeof(self) weakSelf = self;
//    //领取陈宫界面
//    XJGiftPickSuccessView *view = [[XJGiftPickSuccessView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width* 0.8, FLUISCREENBOUNDS.height* 0.7)];
//    view.parentVC = weakSelf;
//    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
//        NSLog(@"动画结束");
//    }];
//}
//
//
//@end
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
