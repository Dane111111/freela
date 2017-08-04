//
//  XJXJScanViewController.m
//  FreeLa
//
//  Created by Collegedaily on 2017/5/2.
//  Copyright © 2017年 FreeLa. All rights reserved.
//  我的天，不需要图片比对， LBS  ， searchC

#import "XJXJScanViewController.h"
#import "FINCamera.h"
#import "FLMyReceiveListModel.h"
#import <CoreMotion/CoreMotion.h>
#import "XJFindGiftViewController.h"
#import "XJFindGiftViewController.h"
#import "XJGiftMapViewController.h"
#import "XJXJFindARGiftViewController.h"
#import "XJFreelaUVManager.h"
#import "LewPopupViewController.h"
#import "XJHFiveCallLocationJsController.h"
#import "DECollectStarCtr.h"
#import "BGFillInformation.h"
#import "BGHideOnlyAR.h"
#import "XJPickARGiftCustiomViewController.h"
#import "XJPickARGiftGifViewController.h"
#import "XJHidePublishDoneView.h"
#import "FLCheckTicketsView.h"
#import "XJVersionTPickSuccess2View.h"
#import "XJBalloonAndPhoto.h"



@interface XJXJScanViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,FINCameraDelagate,UIAccelerometerDelegate,NSURLSessionDelegate,UIActionSheetDelegate>
{
    float _previousY;
    CMMotionManager *manager;
    NSMutableArray* _dataSource;
    NSMutableArray* _imageViewArr;
    NSString* _xjCity;
    UIView* xjImgBaseView;
    NSString*_FLFLHTML_topId;

    
}
@property(nonatomic,strong)FINCamera * camera;
@property (strong, nonatomic) UIButton *flGoBackBtn;

@property (nonatomic , strong) AMapLocationManager *locationManager;
@property (nonatomic , strong) AMapSearchAPI* search;
/**云图搜索结果 数组*/
@property (nonatomic , strong) NSArray* xj_POIsArr;
@property (nonatomic , strong) CLLocation *xj_userLocation;
/** 新的扫描界面按钮 */
//@property (nonatomic , strong)

@property (nonatomic , strong) NSString* xj_topicId;
/**领取模型*/
@property (nonatomic, strong)FLMyReceiveListModel* flmyReceiveMineModel;

@property (nonatomic , strong) UILabel* xjMiddleLabel;
/**相机开启🔐*/
@property(nonatomic,assign)BOOL isCameraOpen;

@property(nonatomic,strong)UIButton*xingxing_Btn;
@property(nonatomic,strong)NSDictionary*jinXingZhu_dic;
@property(nonatomic,strong)BGFillInformation * fillInformationView;


/**发布模型*/
@property (nonatomic , strong) FLIssueInfoModel* xjIssueModel;
/**弹出层*/
@property (nonatomic , strong) BGHideOnlyAR* xjHideGiftView;
/**用来上传的 图片识别码*/
@property (nonatomic , strong) NSString* xj_compareImgStr;

@property(nonatomic,assign)NSInteger imgeType;
/**menu to share*/
@property (nonatomic , strong) CHTumblrMenuView *menuView;

@property(nonatomic,strong)XJVersionTPickSuccess2View*scusssView;
@property(nonatomic,strong)FLCheckTicketsView*checkTicketsView;

@end

@implementation XJXJScanViewController
{
    BOOL      xj_is_push;//是不是退出去找地址 或者 加图片
    BOOL      _is_gif_imgupdate;//是否是 gif 格式缩略图
    NSString* xj_locationJD;//地址经度
    NSString* xj_locationWD;//地址纬度
    NSString* xj_addess;

}
- (BGHideOnlyAR *)xjHideGiftView {
    if (!_xjHideGiftView) {
        //        _xjHideGiftView = [[BGHideARAndLBSView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width* 0.8, FLUISCREENBOUNDS.height* 0.7)];
        _xjHideGiftView = [[BGHideOnlyAR alloc] initWithFrame:CGRectMake(0, 0, 260, 370)];
        
    }
    return _xjHideGiftView;
}

-(FLIssueInfoModel *)xjIssueModel{
    if (_xjIssueModel==nil) {
        _xjIssueModel = [[FLIssueInfoModel alloc] init];
        xj_is_push = NO;
    }
    return _xjIssueModel;
}
- (UILabel *)xjMiddleLabel {
    if (!_xjMiddleLabel) {
        _xjMiddleLabel = [[UILabel alloc] init];
        _xjMiddleLabel.frame = CGRectMake(FLUISCREENBOUNDS.width / 2  - 120, FLUISCREENBOUNDS.height - 200, 240, 24);
        _xjMiddleLabel.textAlignment = NSTextAlignmentCenter;
        _xjMiddleLabel.text = @"360度旋转你的手机，寻找身边的宝贝吧~ ";
        _xjMiddleLabel.textColor = [UIColor whiteColor];
        _xjMiddleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _xjMiddleLabel.layer.cornerRadius = 12;
        _xjMiddleLabel.layer.masksToBounds = YES;
        _xjMiddleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    }
    return _xjMiddleLabel;
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
-(UIButton *)xingxing_Btn{
    if (!_xingxing_Btn) {
        _xingxing_Btn=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage*image=[UIImage imageNamed:@"jixinghuodong_xingxing"];
        _xingxing_Btn.frame=CGRectMake(DEVICE_WIDTH-155/3-40, 40, 155/3, 149/3);
        [_xingxing_Btn setImage:image forState:UIControlStateNormal];
        [_xingxing_Btn addTarget:self action:@selector(xingxing_btnAction) forControlEvents:UIControlEventTouchUpInside];
        _xingxing_Btn.hidden=YES;
        [self.view addSubview:_xingxing_Btn];
    }
    return _xingxing_Btn;
}
-(void)xingxing_btnAction{
    DECollectStarCtr*vc=[[DECollectStarCtr alloc] init];
    vc.jinXingZhu_dic=self.jinXingZhu_dic;
    [self.navigationController pushViewController:vc animated:YES];
}
- (FLMyReceiveListModel *)flmyReceiveMineModel {
    if (!_flmyReceiveMineModel) {
        _flmyReceiveMineModel = [[FLMyReceiveListModel alloc] init];
    }
    return _flmyReceiveMineModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self openCamera];
    _previousY = 0.14;
    _dataSource = @[].mutableCopy;
    _imageViewArr = @[].mutableCopy;
//    [self xjFetchData];
    [self.view addSubview:self.flGoBackBtn];
    [self.view addSubview:self.xjMiddleLabel];
    
    //底部按钮栏
    [self xjCreatBottomView];
    
    [self startSerialLocation];
    
    
    
    
//    XJVersionTPickSuccessView *view = [[XJVersionTPickSuccessView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width , FLUISCREENBOUNDS.height)];
////    view.parentVC = weakSelf;
//    FL_Log(@"dsadsafa=%@",self.flmyReceiveMineModel.flMineTopicThemStr);
//    view.xj_TopicThemeL.text = @"这里是标题";
//    
// 
//    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
//        NSLog(@"动画结束");
//    }];
//    
    
    
}
- (void)appHasGoneInForeground{
    [self.camera endSession];
    [self.camera startSession];
    [self.camera performSelector:@selector(startSession) withObject:nil afterDelay:1.0f];

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.camera startSession];
//    });
    
}

- (void)appEnterBackGround{
    [self.camera endSession];
}



- (void)xj_popGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    if (self.camera) {
        [self.camera startSession];
    }
    NSLog(@"😝🌶%ld",_dataSource.count);
    [self jiXingZhuHuoDong];
    

}
-(void)jiXingZhuHuoDong{
    [FLNetTool deGetNewIsMainWith:nil success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray * dataArr=data[@"data"];
            if (dataArr&&dataArr.count>0) {
                self.jinXingZhu_dic=dataArr[0];
                self.xingxing_Btn.hidden=NO;
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 本地数量少于2个抓取线索寻宝

- (void)xjFetchData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:XJ_USERID_WITHTYPE forKey:@"userid"];

    [FLNetTool xjGetSkyGiftpResultsFromServer:dic success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray* arr = data[FL_NET_DATA_KEY];
            if (arr.count!=0) {
                for (NSInteger i =0; i<arr.count; i++) {
                    if (i<2) {
                        FLMyReceiveListModel* model = [self xjxjxjxjreturnModelForTicketsWithData:arr[i]];
                        [_dataSource addObject:model];
                    }
                }
            }
            if (_dataSource.count!=0) {
                [self getCollectNum];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 获取点赞数
-(void)getCollectNum{
    NSMutableArray*idsArr=@[].mutableCopy;

    for (FLMyReceiveListModel* model in _dataSource) {
        [idsArr addObject:model.flMineIssueTopicIdStr];
    }
    NSDictionary*dic=@{@"idsArray":[idsArr componentsJoinedByString:@","]};
    
    [FLNetTool defindTopicCollectNumWith:dic success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
           NSString*str= data[FL_NET_DATA_KEY][@"collentionNums"];
            NSArray*arr=[str componentsSeparatedByString:@","];
            for (int i=0; i<arr.count; i++) {
                FLMyReceiveListModel* model=    _dataSource[i];
                model.flMineIssueNumbersCollectStr=arr[i];
            }
        }
        [self xjImageInit];

    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 转json格式字符串：
- (NSString*)dictionaryToJson:(NSObject *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - 相机
- (void)openCamera {
    __weak XJXJScanViewController* weakSelf = self;
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
    view.tag=67890;
    view.userInteractionEnabled = YES;
    [self.view insertSubview:view atIndex:0];
    
    //    UIImageView *cover = [[UIImageView alloc] initWithFrame:self.view.frame];
    //    cover.image = [UIImage imageNamed:@"cover"];
    //    [self.view addSubview:cover];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    //    NSLog(@"TEST");
}
-(void)camera:(FINCamera *)camera adjustingFocus:(BOOL)adjustingFocus{
    //    NSLog(@"%@",adjustingFocus?@"正在对焦":@"对焦完毕");
}

- (void)returnModelForTicketsWithData:(NSDictionary*)data {
//    FLMyReceiveListModel* model = [[FLMyReceiveListModel alloc] init];
    self.flmyReceiveMineModel.flIntroduceStr = data[@"topicExplain"];
    self.flmyReceiveMineModel.flMineIssueTopicIdStr = data[@"topicId"];
    self.flmyReceiveMineModel.xjCreator = [data[@"creator"] integerValue];
    self.flmyReceiveMineModel.xjUserId = [data[@"userId"] integerValue];
    self.flmyReceiveMineModel.flTimeBegan = data[@"startTime"];
    self.flmyReceiveMineModel.xjinvalidTime = data[@"invalidTime"];
    self.flmyReceiveMineModel.xjUrl = data[@"url"];
    self.flmyReceiveMineModel.xjUserType = data[@"userType"];
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

- (void)xjImageInit{
    
    //base view
    if (xjImgBaseView) {
        [xjImgBaseView removeFromSuperview];
    }
    NSInteger qq=_dataSource.count/6+1;
    xjImgBaseView = [[UIView alloc] init];
    xjImgBaseView.frame = CGRectMake(-DEVICE_WIDTH*qq , -self.view.frame.size.height / 2, self.view.frame.size.width * 6*qq, -self.view.frame.size.height);
    xjImgBaseView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view insertSubview:xjImgBaseView atIndex:1];
    
    
    //初始化 image
    
    for (NSInteger i = 0; i < _dataSource.count; i++) {
        //img 背景
        XJBalloonAndPhoto*balloonAndPhoto=[[XJBalloonAndPhoto alloc]init];
        balloonAndPhoto.num=i;
        FLMyReceiveListModel* model = _dataSource[i];
        [balloonAndPhoto.imageV sd_setImageWithURL:[NSURL URLWithString:model.xj_xiansuotuStr]];
        if ([model.flMineIssueNumbersCollectStr integerValue]==0) {
            balloonAndPhoto.dianZanView.hidden=YES;
        }else{
            balloonAndPhoto.dianZanView.hidden=NO;
            
            balloonAndPhoto.dianzanLabel.text=model.flMineIssueNumbersCollectStr;
            
        }
        [xjImgBaseView addSubview:balloonAndPhoto];
        balloonAndPhoto.actionBlock=^(NSInteger tag){
            FLMyReceiveListModel* model = _dataSource[tag];
            self.xj_topicId = model.flMineIssueTopicIdStr;
            [self checkTakeCanOrNot];
            NSLog(@"😝被点击了👀👀🌶");
            
        };

        
    }
    
    //判断手机陀螺仪能否使用
    if (!manager) {
        manager = [[CMMotionManager alloc]init];
        //更新频率
        manager.gyroUpdateInterval = 1/100;
    }
    if (![manager isGyroActive] &&[manager isGyroAvailable]) {
        [manager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
            //            NSLog(@"%f,%f",5*gyroData.rotationRate.y,5*gyroData.rotationRate.x);
            
            if (fabs(5*gyroData.rotationRate.y - _previousY) <0.02) {
                //                NSLog(@"位移太小,作废");
                return ;
            }else {
                //                NSLog(@"位移足够,不作废");
            }
            _previousY =5*gyroData.rotationRate.y;
            
            
            CGFloat rotationRateX =  xjImgBaseView.center.x+5*gyroData.rotationRate.y-0.15;
            CGFloat rotationRateY = xjImgBaseView.center.y+5*gyroData.rotationRate.x;
            
            if (rotationRateX > self.view.frame.size.width*5) {
                NSLog(@"rotationRateX > self.view.frame.size.width*3/2");
//                rotationRateX =self.view.frame.size.width*3/2;
            }
            if(rotationRateX < (-self.view.frame.size.width )){
                NSLog(@"rotationRateX < (-self.view.frame.size.width/2)");
//                rotationRateX=(-self.view.frame.size.width/2);
            }
            if (rotationRateY > self.view.frame.size.height) {
                NSLog(@"rotationRateY > self.view.frame.size.height");
                rotationRateY= self.view.frame.size.height;
            }
            if (rotationRateY < 0) {
//                NSLog(@"rotationRateY < 0");
                rotationRateY=0;
            }
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [xjImgBaseView setCenter:CGPointMake(rotationRateX, rotationRateY)];
                             }
                             completion:nil];
            
            
            
        }];
    }
}
- (void)xjxjtesttagtag :(UITapGestureRecognizer*)tapg  {
    
    NSInteger tag = tapg.view.tag - xj_tag;
    FLMyReceiveListModel* model = _dataSource[tag];
    self.xj_topicId = model.flMineIssueTopicIdStr;
    [self checkTakeCanOrNot];
    NSLog(@"😝被点击了👀👀🌶");

//    XJFindGiftViewController* vvc = [[XJFindGiftViewController alloc] init];
//    [vvc xjSetModel:model];
//    [self.navigationController pushViewController:vvc animated:YES];
    
}
- (void)xjCreatBottomView {
    UIButton* xjLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:xjLeftBtn];
    xjLeftBtn.frame = CGRectMake(FLUISCREENBOUNDS.width * 0.2 - 20, FLUISCREENBOUNDS.height - 140, 80, 80);
    UILabel* xjleftLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width * 0.2-10, FLUISCREENBOUNDS.height - 60, 60, 20)];
    [self.view addSubview:xjleftLabel];
    xjleftLabel.text = @"线索寻宝";
    xjleftLabel.textAlignment =NSTextAlignmentCenter;
    xjleftLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    xjleftLabel.textColor = [UIColor whiteColor];
    [xjLeftBtn setBackgroundImage:[UIImage imageNamed:@"ar_icon_ccccccc"] forState:UIControlStateNormal];
    [xjLeftBtn addTarget:self action:@selector(xjClickToGift) forControlEvents:UIControlEventTouchUpInside];
    
    //右边的
    UIButton* xjRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:xjRightBtn];
    xjRightBtn.frame = CGRectMake(FLUISCREENBOUNDS.width * 0.8-40 - 20, FLUISCREENBOUNDS.height - 140, 80, 80);
    //    [xjRightBtn setBackgroundImage:[UIImage imageNamed:@"ar_icon_white"] forState:UIControlStateNormal];
    [xjRightBtn setBackgroundImage:[UIImage imageNamed:@"ar_map_version2"] forState:UIControlStateNormal];
    
    [xjRightBtn addTarget:self action:@selector(xj_switchStyleAr) forControlEvents:UIControlEventTouchUpInside];
    UILabel* xjRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width * 0.8 -50, FLUISCREENBOUNDS.height - 60, 60, 20)];
    [self.view addSubview:xjRightLabel];
    xjRightLabel.text = @"地图寻宝";
    xjRightLabel.textAlignment =NSTextAlignmentCenter;
    xjRightLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    xjRightLabel.textColor = [UIColor whiteColor];
    
    
    //skyar 中间的
    UIButton*  skyArBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:skyArBtn];
    skyArBtn.frame = CGRectMake(FLUISCREENBOUNDS.width / 2 - 20 - 20, FLUISCREENBOUNDS.height - 180, 80, 80);
    [skyArBtn addTarget:self action:@selector(bendiXunBaoAction) forControlEvents:UIControlEventTouchUpInside];
    [skyArBtn setBackgroundImage:[UIImage imageNamed:@"ar_icon_xingkong"] forState:UIControlStateNormal];
    //    [skyArBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_back_red_new"] forState:UIControlStateHighlighted];
    
    UILabel* xjMiddleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width /2 -30, FLUISCREENBOUNDS.height - 100, 60, 20)];
    [self.view addSubview:xjMiddleLabel];
    xjMiddleLabel.text = @"本地寻宝";
    xjMiddleLabel.textAlignment =NSTextAlignmentCenter;
    xjMiddleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    xjMiddleLabel.textColor = [UIColor colorWithHexString:XJ_FCOLOR_REDFONT];
    
}
#pragma mark  -----------------藏宝开始--------------------

-(void)bendiXunBaoAction{
    self.imgeType=2;
    [self xj_AddImageAction];
}
#pragma mark  -----------------image picker
- (void)xj_AddImageAction {
    UIActionSheet* actionSheet;
    if (self.imgeType==2) {
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"拍照",@"从相册选取", nil];

    }else{
       actionSheet  = [[UIActionSheet alloc]initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"从相册选取",@"gif库",@"免费啦礼包库", nil];

  
    }
    [actionSheet showInView:self.view];
}
#pragma mark --- action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    xj_is_push = YES;
    if (self.imgeType==2) {
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
        }
    }else{
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
            [self  saveImage: imageToUse type:self.imgeType];
        }
        FL_Log(@"消失之后");
    });
    
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

- (void)saveImage:(UIImage*)image type:(NSInteger)xjtype{
    
    //    image = [XJFinalTool xj_fixOrientation:image];
    
//    if (xjtype==1) {
        [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];
//    }
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
                [self xj_hideHere];
            }
        }
        [[FLAppDelegate share] hideHUD];
    } failure:^(NSError *error) {
        [[FLAppDelegate share] hideHUD];
        //         [FLTool showWith:[NSString stringWithFormat:@"请稍后==【%@】",error]];
    }];
}
#pragma 跳出仓礼包
- (void)xj_hideHere{
    //    XJArHideGiftView *view = [[XJArHideGiftView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width* 0.8, FLUISCREENBOUNDS.height* 0.7)];
    
    
    __weak typeof(self) weakSelf = self;
    _xjHideGiftView=nil;
    self.xjHideGiftView.parentVC = weakSelf;
    self.xjHideGiftView.xjLocationStr=xj_addess;
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
        weakSelf.imgeType=1;

        [weakSelf xj_AddImageAction];
    }];
    //添加 地址
    [self.xjHideGiftView xjClickToChooseMap:^{
        
    }];
    [self lew_presentPopupView:self.xjHideGiftView animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];
}
#pragma mark -------------开始上传信息来发布 礼包活动
- (void)xj_publishGiftTopic {
    [[FLAppDelegate share] showSimplleHUDWithTitle:@"" view:self.view];

    if (_is_gif_imgupdate) {
    }

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

            [self shuaxin];

        }
        [[FLAppDelegate share] hideHUD];

    } failure:^(NSError *error) {
        [[FLAppDelegate share] hideHUD];

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
    }];
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
#pragma mark  -----------------藏宝结束

//跳转 地图界面
- (void)xj_switchStyleAr{
    XJGiftMapViewController* vvvc = [[XJGiftMapViewController alloc] init];
    [self.navigationController pushViewController:vvvc animated:YES];
}

//跳转直接扫描界面
- (void)xjClickToGift{
    XJXJFindARGiftViewController* vvvc = [[XJXJFindARGiftViewController alloc] init];
    [self.navigationController pushViewController:vvvc animated:YES];
}


#pragma  mark ----------------------_request 
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
            if ([data[@"buttonKey"] isEqualToString: @"b11"]) {
                //可以领取，查看是否有领取信息
//                [self FLFLHTMLHTMLsaveTopicClickOn:nil]; //直接领取
                [self xj_getRequestDetailsOfTopicWithId:self.xj_topicId];

                self.xjMiddleLabel.hidden = YES;
            }else if ([data[@"buttonKey"] isEqualToString: @"b10"]){
                [self lingQuGuoHouZhiJieTiaoPiaoQuanYeWithId:self.xj_topicId];
            }
         
        }else if ([data[@"buttonKey"] isEqualToString: @"b10"]){
            [self lingQuGuoHouZhiJieTiaoPiaoQuanYeWithId:self.xj_topicId];
            [FLTool showWith:[NSString stringWithFormat:@"%@",data[@"msg"]]];

        }else {
            [FLTool showWith:[NSString stringWithFormat:@"%@",data[@"msg"]]];
        }
    } failure:^(NSError *error) {

    }];
}
-(void)lingQuGuoHouZhiJieTiaoPiaoQuanYeWithId:(NSString*)topicId{
    NSDictionary* parm = @{@"topic.topicId":topicId,
                           @"userType":XJ_USERTYPE_WITHTYPE,
                           @"userId":XJ_USERID_WITHTYPE,
                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:topicId]};
    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            FL_Log(@"thi si s the data of html 5=[%@]",data);
            [self xjreturnModelForTicketsWithData:data[FL_NET_DATA_KEY]];
            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:topicId];
            
            
            
            NSDictionary*dic=@{@"topicId":self.flmyReceiveMineModel.flMineIssueTopicIdStr,@"userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID};
            [FLNetTool xjxjGetDetailsIdWith:dic success:^(NSDictionary *data) {
                if ([data[FL_NET_KEY_NEW] boolValue]) {
                    self.flmyReceiveMineModel.flDetailsIdStr=data[@"data"];
                    [self xj_clickToShowPickSuccess];
                    
                    
                }
            } failure:^(NSError *error) {
                
            }];

        }
    } failure:^(NSError *error) {
        
    }];

}

- (void)FLFLHTMLHTMLsaveTopicClickOn:(id)iii{
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
                           @"participateDetailes.message":iii?iii:@"",
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
            [self xj_clickToShowPickSuccess];

        }
    } failure:^(NSError *error) {
        FL_Log(@"error in save topic =%@",error);
    }];
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
            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjtopicid];
//            [self xjFetchData];
            NSString*partInfo=data[@"data"][@"partInfo"];
            
            if (partInfo&&partInfo.length>0) {
                
                [self FLFLHTML3GetPartInfoListTopid:xjtopicid userId:XJ_USERID_WITHTYPE partInfo:data[@"data"][@"partInfo"]];
                
            }else{
                                [self FLFLHTMLHTMLsaveTopicClickOn:nil]; //直接领取

//                [self xj_clickToShowPickSuccess];
                
            }
//            [self xjFetchData];
            //            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjtopicid];
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
-(BGFillInformation *)fillInformationView{
    if (!_fillInformationView) {
        _fillInformationView=[[BGFillInformation alloc] init];
    }
    return _fillInformationView;
}
- (void)FLFLHTML3GetPartInfoListTopid:(NSString*)topid userId:(NSString*)userId  partInfo:(NSString*)partInfo{
   __weak XJXJScanViewController*weekSelf= self;
    if (self.fillInformationView) {
        [self.fillInformationView.cellDic removeAllObjects];
    }
    
    self.fillInformationView.partInfostr=partInfo;
    self.fillInformationView.hearderImageStr=self.flmyReceiveMineModel.xj_xiansuotuStr;
    self.fillInformationView.xj_topicId=topid;
    self.fillInformationView.flmyReceiveMineModel=self.flmyReceiveMineModel;
    self.fillInformationView.tiJiaoBlock=^(){
        [weekSelf xj_clickToShowPickSuccess];

    };
    UIWindow *window = [[UIApplication sharedApplication ].windows lastObject];
    
    [window addSubview:self.fillInformationView.maskView];
    [window addSubview:self.fillInformationView];
    [self.fillInformationView popUp];

}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    //    [self.HTMLdata appendData:data];
    NSString*str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    str=[str stringByReplacingOccurrencesOfString:@"{"withString:@"["];
    str=[str stringByReplacingOccurrencesOfString:@"}"withString:@"]"];
    NSArray* array1 = [str componentsSeparatedByString:@":["];
    NSArray*array2=[array1[1] componentsSeparatedByString: @"],"];
    
    [self performSelectorOnMainThread:@selector(push2JSCtr:) withObject:array2[0] waitUntilDone:YES];
    
}
-(void)pushJSCtr:(NSString*)str{
    XJHFiveCallLocationJsController*vc=[[XJHFiveCallLocationJsController alloc] initWithTopicId:_FLFLHTML_topId];
    vc.xjPartInfoStr=str;
    vc.flmyReceiveMineModel=self.flmyReceiveMineModel;
    vc.xjPushStyle=HFivePushStylePutInfoForTake;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)push2JSCtr:(NSString*)str{
    BGFillInformation*cview=[[BGFillInformation alloc] initWithPartInfoStr:str];
    cview.tiJiaoBlock=^(){
    };
    UIWindow *window = [[UIApplication sharedApplication ].windows lastObject];
    
    [window addSubview:cview.maskView];
    [window addSubview:cview];
    [cview popUp];

}

#pragma  mark --- --------------------------------详情
- (void)getRequestDetailsOfTopicWithId:(NSString*)xjtopicid {
//    if (!xjtopicid) {
//        return;
//    }
//    NSDictionary* parm = @{@"topic.topicId":xjtopicid,
//                           @"userType":XJ_USERTYPE_WITHTYPE,
//                           @"userId":XJ_USERID_WITHTYPE,
//                           @"freelaUVID":[XJFreelaUVManager  xjSearchUVInLocationBySearchId:xjtopicid]};
//    [FLNetTool HTMLSeeTopicDetailsByIDWithParm:parm success:^(NSDictionary *data) {
//        if ([data[FL_NET_KEY_NEW] boolValue]) {
//            FL_Log(@"thi si s the data of html 666666666666 =[%@]",data);
//            [self returnModelForTicketsWithData:data[FL_NET_DATA_KEY]];
//            [XJFreelaUVManager xjAddUVStr:data[FL_NET_DATA_KEY][@"freelaUVID"] SearchId:xjtopicid];
//            NSString* xj_parinfo = data[FL_NET_DATA_KEY][@"partInfo"];
//            if ([XJFinalTool xjStringSafe:xj_parinfo]) {
//                [self  xj_showAddReceiveView];;//[self xjGetPartInfoList:xj_parinfo];//获取填写信息
//            }else{
//                [self FLFLHTMLHTMLsaveTopicClickOn:@""];
//            }
//        }
//    } failure:^(NSError *error) {
//        
//    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if (self.isHtmlPop) {
//        [self xj_clickToShowPickSuccess];
//
//        self.isHtmlPop=NO;
//    }
//    for (UIViewController*ctr in [self.navigationController childViewControllers]) {
//        if ([ctr isKindOfClass:[XJXJFindARGiftViewController class]]) {
//            XJXJFindARGiftViewController* scCtr=(XJXJFindARGiftViewController*)ctr;
//            scCtr.isHtmlPop=NO;
//        }
//    }
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
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

}
- (void)xj_showAddReceiveView {
    __weak typeof(self) weakSelf = self;
//    XJGiftAddReceiveInfoView* view = [[XJGiftAddReceiveInfoView alloc] initWithFrame:CGRectMake(0, 0, FLUISCREENBOUNDS.width*0.8, 400)];
//    //    xjView.center = self.view.center;
//    [view xj_ReturnReceiveInfo:^(NSString *xjReceiveInfo) {
//        [weakSelf lew_dismissPopupView];
//        [weakSelf performSelector:@selector(FLFLHTMLHTMLsaveTopicClickOn:) withObject:xjReceiveInfo afterDelay:1];
//    }];
//    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
//        NSLog(@"动画结束");
//    }];
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
- (CLLocation *)xj_userLocation{
    if (!_xj_userLocation) {
        _xj_userLocation = [[CLLocation alloc] init];
    }
    return _xj_userLocation;
}
#pragma mark -------------- 从自己后台获取云图数据
- (void)xjSearchPOIsFromARKitServiceWithLocationx:(CGFloat)longitude y:(CGFloat)latitude city:(NSString*)city{
    
    NSDictionary* parm = @{@"compid":@"",
                           @"city":city?city:@"北京",
                           @"userid":XJ_USERID_WITHTYPE,
                           @"positon":[NSString stringWithFormat:@"%f,%f",longitude,latitude],
                           @"distance":@"1000000"
                           };
    [FLNetTool xjGetGiftMapResultsFromServer:parm searchType:@"C" success:^(NSDictionary *data) {
        //        XJFL_Log(@"this is pois datsa=【%@】",data );
        NSArray* arr = data[@"data"];
        NSMutableArray* mu = @[].mutableCopy;
        for (NSDictionary* dic in arr) {
            if ([dic[@"lbsOnly"] integerValue]==2) {
                continue;
            }
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
            
            
            FLMyReceiveListModel* model = [[FLMyReceiveListModel alloc] init];
            model.flMineIssueTopicIdStr = dic[@"topicId"];
            model.xj_xiansuotuStr = dic[@"detilschartUrl"];
            [_dataSource addObject:model];
        }
//        [self xjFetchData];
//        self.xj_POIsArr = mu.mutableCopy;
        if (_dataSource.count < 1) {
            self.xj_POIsArr = mu.mutableCopy;
            
            [self xjFetchData];
            
        }else{
            self.xj_POIsArr = mu.mutableCopy;
            [self getCollectNum];

            
        }

        
    } failure:^(NSError *error) {
        
    }];
}
- (void)startSerialLocation{
    //开始定位
    [AMapServices sharedServices].apiKey = FL_GAODE_API_KEY;//@"1e0aebfcb8521c830d96712e95f896ae";

    __weak XJXJScanViewController *weakSelf = self;
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
            self.xj_userLocation = location;
            xj_locationJD=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
            xj_locationWD=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
            
            xj_addess =[NSString stringWithFormat:@"%@%@%@%@",regeocode.city,regeocode.district,regeocode.street,regeocode.number];

            _xjCity = regeocode.city;
            //            [self xjSearchAroundWithLocationx:location.coordinate.longitude y:location.coordinate.latitude];
            [weakSelf xjSearchPOIsFromARKitServiceWithLocationx:location.coordinate.longitude
                                                              y:location.coordinate.latitude
                                                           city:regeocode.city];
        }
        if (regeocode)
        {
            FL_Log(@"reGeocode:%@", regeocode);
            
        }
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
    self.flmyReceiveMineModel.avatar=data[@"avatar"];
    self.flmyReceiveMineModel.xjPublishName=data[@"nickName"];
    NSString* suolve = data[@"sitethumbnail"];
                self.flmyReceiveMineModel.xj_suolvetuStr = suolve;

//    if ([XJFinalTool xjStringSafe:suolve]) {
////        if (![suolve hasSuffix:@".gif"]&&![suolve hasSuffix:@".mp4"]) {
//        }
//        
//    }
    
    self.flmyReceiveMineModel.flMineTopicThemStr = data[@"topicTheme"];
    self.flmyReceiveMineModel.xj_xiansuotuStr = data[@"detailchart"];
    self.flmyReceiveMineModel.xj_suolvetuStr=data[@"thumbnail"];
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
#pragma mark 刷新
-(void)shuaxin{
    [_dataSource removeAllObjects];
    if (xjImgBaseView) {
        for (UIView*view in [xjImgBaseView subviews]) {
            [view removeFromSuperview];
        }
    }
    [self startSerialLocation];

}
//-(XJVersionTPickSuccess2View*)scusssView{
//    if (!_scusssView) {
//        _scusssView = [[XJVersionTPickSuccess2View alloc] init];
//
//    }
//    return _scusssView;
//}
//-(FLCheckTicketsView *)checkTicketsView{
//    if (!_checkTicketsView) {
//        _checkTicketsView=[[FLCheckTicketsView alloc]initWithSuperView:self.view];
//    }
//    return _checkTicketsView;
//}
- (void)xj_clickToShowPickSuccess{
    __weak typeof(self) weakSelf = self;
    [self shuaxin];
    self.xjMiddleLabel.hidden=YES;
    for (UIView*view in [self.view subviews]) {
        if ([view isEqual:xjImgBaseView]||view.tag==67890) {
            continue;
        }
        view.hidden=YES;
    }

    
    
    //领取陈宫界面
    if (_scusssView) {
        [_scusssView removeFromSuperview];
        [_scusssView.maskView removeFromSuperview];
    }
            _scusssView = [[XJVersionTPickSuccess2View alloc] init];

    [self.view addSubview: self.scusssView.maskView ];
    [self.view addSubview:self.scusssView];
    self.scusssView.parentVC = weakSelf;
    FL_Log(@"dsadsafa=%@",self.flmyReceiveMineModel.flMineTopicThemStr);
    self.scusssView.flmyReceiveMineModel =  self.flmyReceiveMineModel;
//    NSString*hh = [XJFinalTool xjReturnImageURLWithStr:self.flmyReceiveMineModel.avatar
//                                       isSite:NO];
//    [view.xj_imageView sd_setImageWithURL:[NSURL URLWithString:hh]];
//    view.xj_NickNameL.text=self.flmyReceiveMineModel.xjPublishName;
    if ([XJFinalTool xjStringSafe:self.flmyReceiveMineModel.xj_suolvetuStr]) {
        NSString* ss=self.flmyReceiveMineModel.xj_suolvetuStr;
        //判断路径的结尾是不是 .mp4
        if(![self.flmyReceiveMineModel.xj_suolvetuStr hasSuffix:@".mp4"]&& ![self.flmyReceiveMineModel.xj_suolvetuStr hasSuffix:@".gif"]){
            ss = [XJFinalTool xjReturnImageURLWithStr:self.flmyReceiveMineModel.xj_suolvetuStr
                                               isSite:NO];
        }
        
        self.scusssView.xj_imgUrlStr = ss;
    }
//    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
//        NSLog(@"动画结束");
//    }];
    //点击完成
    [self.scusssView popUp];
    __weak UIView*weakXjImgBaseView=xjImgBaseView;

    self.scusssView.popBlock=^(){
        for (UIView*view in [weakSelf.view subviews]) {
            if ([view isEqual: weakXjImgBaseView]) {
                continue;
            }
            view.hidden=NO;
        }
        weakSelf.xjMiddleLabel.hidden=NO;
        

    };
    [self.scusssView xj_findGiftSuccessDone:^{
        
        [weakSelf.scusssView popDown];

//        [weakSelf lew_dismissPopupView];
        //        [weakSelf.navigationController popViewControllerAnimated:YES];
        weakSelf.navigationController.navigationBar.hidden = YES;
//        [weakSelf xjSearchPOIsFromARKitServiceWithLocationx:self.xj_userLocation.coordinate.longitude
//                                                          y:self.xj_userLocation.coordinate.latitude
//                                                       city:_xjCity?_xjCity:@"北京"];
//        //跳到票券页
//        XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
//        ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
//        FL_Log(@"thi1s is te1h acti1on to push the page of ticke3t");
//        [weakSelf.navigationController pushViewController:ticketVC animated:YES];
        if(_checkTicketsView){
            [_checkTicketsView removeFromSuperview];
            [_checkTicketsView.maskView removeFromSuperview];

        }
        _checkTicketsView=[[FLCheckTicketsView alloc]initWithSuperView:self.view];

        self.checkTicketsView.flMyReceiveInMineModel=self.flmyReceiveMineModel;
        [self.checkTicketsView popUp];
        self.checkTicketsView.popDownlock=^(){
            for (UIView*view in [weakSelf.view subviews]) {
                if ([view isEqual: weakXjImgBaseView]) {
                    continue;
                }
                view.hidden=NO;
            }
            weakSelf.xjMiddleLabel.hidden=NO;

            weakSelf.checkTicketsView=nil;
        };

    }];
}

- (FLMyReceiveListModel*)xjxjxjxjreturnModelForTicketsWithData:(NSDictionary*)data {
    FLMyReceiveListModel* model = [[FLMyReceiveListModel alloc] init];
    model.flIntroduceStr = data[@"topicExplain"];
    model.flMineIssueTopicIdStr = data[@"topicId"];
    model.xjCreator = [data[@"creator"] integerValue];
    model.xjUserId = [data[@"userId"] integerValue];
    model.flTimeBegan = data[@"startTime"];
    model.xjinvalidTime = data[@"invalidTime"];
    model.xjUrl = data[@"url"];
    model.xjUserType = data[@"userType"];
//            NSString* suolve = data[@"sitethumbnail"];
//            if ([XJFinalTool xjStringSafe:suolve]) {
//                if (![suolve hasSuffix:@".gif"]&&![suolve hasSuffix:@".mp4"]) {
//                    model.xj_suolvetuStr = suolve;
//                }
//    
//            }
    model.flMineTopicThemStr = data[@"topicTheme"];
    model.xj_xiansuotuStr = data[@"detailchart"];
    NSString* ad = data[@"thumbnail"];
    FL_Log(@"dsadsafsadsad===【%@】",ad);
    model.createTime = data[@"createTime"];
    
    //缩略图
    NSString* suolve  = data[@"thumbnail"];
    if ([XJFinalTool xjStringSafe:suolve]) {
        NSString* type  = data[@"userType"];
        model.xj_suolvetuStr = [NSString stringWithFormat:@"http://123.57.35.196:9090/CJH/freela/resources/static/topic/%@/%ld/%@",type,model.xjUserId,suolve];
    }
    //线索图
    NSString* xiansuo  = data[@"detailchart"];
    if ([XJFinalTool xjStringSafe:xiansuo]) {
        NSString* type  = data[@"userType"];
        model.xj_xiansuotuStr = [NSString stringWithFormat:@"http://123.57.35.196:9090/CJH/freela/resources/static/topic/%@/%ld/%@",type,model.xjUserId,xiansuo];
    }
    model.pictureCode = data[@"pictureCode"];
    return model;
}


@end




























