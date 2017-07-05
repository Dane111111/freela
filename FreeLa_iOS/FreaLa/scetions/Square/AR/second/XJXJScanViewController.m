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
#import "XJVersionTPickSuccessView.h"
#import "LewPopupViewController.h"
#import "XJHFiveCallLocationJsController.h"
#import "DECollectStarCtr.h"

#define xj_tag  193992


@interface XJXJScanViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,FINCameraDelagate,UIAccelerometerDelegate>
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
@end

@implementation XJXJScanViewController
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
    
//    [self startSerialLocation];
    
    
    
    
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
    
    [_dataSource removeAllObjects];
    if (xjImgBaseView) {
        for (UIView*view in [xjImgBaseView subviews]) {
            [view removeFromSuperview];
        }
    }
    [self startSerialLocation];

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
                [self xjImageInit];
            }
        }
    } failure:^(NSError *error) {
        
    }];
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
    xjImgBaseView = [[UIView alloc] init];
    xjImgBaseView.frame = CGRectMake(-self.view.frame.size.width * 2 , -self.view.frame.size.height / 2, self.view.frame.size.width * 6, -self.view.frame.size.height);
    [self.view insertSubview:xjImgBaseView atIndex:1];
    
    
    //初始化 image
    
    for (NSInteger i = 0; i < _dataSource.count; i++) {
        //img 背景
        UIView* backview = [[UIView alloc] init];
        [xjImgBaseView addSubview:backview];
        backview.backgroundColor = [UIColor whiteColor];
        
        //随机x  y 轴的初始位置
        CGFloat xjx = 40 +  (arc4random() % 51);
        CGFloat xjy = 20 +  (arc4random() % 251);
        
        CGFloat xjxjxj =  0 + (arc4random() % 100);
        CGFloat xjw ;
        if (xjxjxj < 30) {
            xjw = 200;
        } else if (xjxjxj < 60 && xjxjxj >= 30) {
            xjw = 250;
        } else {
            xjw = 100;
        }
        FL_Log(@"thi s sis the xjxjxjxjw ==【%f】",xjw);
        backview.frame = CGRectMake(xjx + 300 * i, xjy-200, xjw, xjw);
        
        //划线
        UIView* redView = [[UIView alloc] init];
        [backview addSubview:redView];
        redView.frame = CGRectMake(backview.width/2 - 10, -22, 20, 30);
        redView.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
        
        UIView* lineView = [[UIView alloc] init];
        [backview addSubview:lineView];
        lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        lineView.frame = CGRectMake(backview.width/2, -FLUISCREENBOUNDS.height, 1, FLUISCREENBOUNDS.height - 15);
        
        
        
        UIImageView* image = [[UIImageView alloc] init];
        //        image.frame = CGRectMake(xjx + 300 * i, xjy, 200, 160);
        image.frame = CGRectMake(5, 10, xjw-10, xjw-15);
        image.tag = xj_tag + i;
        image.userInteractionEnabled = YES;
        [backview insertSubview:image atIndex:1];
        FLMyReceiveListModel* model = _dataSource[i];
        [image sd_setImageWithURL:[NSURL URLWithString:model.xj_xiansuotuStr]];
        [_imageViewArr addObject:image];
        
        UITapGestureRecognizer* tapg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjxjtesttagtag:)];
        [image addGestureRecognizer:tapg];
        
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
            
            
            CGFloat rotationRateX =  xjImgBaseView.center.x+5*gyroData.rotationRate.y;
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
    NSLog(@"😝🌶%ld",_dataSource.count);

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
//    [skyArBtn addTarget:self action:@selector(xjClickToGift) forControlEvents:UIControlEventTouchUpInside];
    [skyArBtn setBackgroundImage:[UIImage imageNamed:@"ar_icon_xingkong"] forState:UIControlStateNormal];
    //    [skyArBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_back_red_new"] forState:UIControlStateHighlighted];
    
    UILabel* xjMiddleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FLUISCREENBOUNDS.width /2 -30, FLUISCREENBOUNDS.height - 100, 60, 20)];
    [self.view addSubview:xjMiddleLabel];
    xjMiddleLabel.text = @"本地寻宝";
    xjMiddleLabel.textAlignment =NSTextAlignmentCenter;
    xjMiddleLabel.font = [UIFont fontWithName:FL_FONT_NAME size:12];
    xjMiddleLabel.textColor = [UIColor colorWithHexString:XJ_FCOLOR_REDFONT];
    
}

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
            }
         
        } else {
            [FLTool showWith:[NSString stringWithFormat:@"%@",data[@"msg"]]];
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
                
                [self FLFLHTML2GetPartInfoListTopid:xjtopicid userId:XJ_USERID_WITHTYPE partInfo:data[@"data"][@"partInfo"]];
                
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
    if (self.isHtmlPop) {
        [self xj_clickToShowPickSuccess];

        self.isHtmlPop=NO;
    }
    for (UIViewController*ctr in [self.navigationController childViewControllers]) {
        if ([ctr isKindOfClass:[XJXJFindARGiftViewController class]]) {
            XJXJFindARGiftViewController* scCtr=(XJXJFindARGiftViewController*)ctr;
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
            [self xjImageInit];
            
        }

        
    } failure:^(NSError *error) {
        
    }];
}
- (void)startSerialLocation{
    //开始定位
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
- (void)xj_clickToShowPickSuccess{
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
//        [weakSelf xjSearchPOIsFromARKitServiceWithLocationx:self.xj_userLocation.coordinate.longitude
//                                                          y:self.xj_userLocation.coordinate.latitude
//                                                       city:_xjCity?_xjCity:@"北京"];
        weakSelf.xjMiddleLabel.hidden =  NO;
        //跳到票券页
        XJTicketHTMLViewController* ticketVC = [[XJTicketHTMLViewController alloc] init];
        ticketVC.flmyReceiveMineModel = self.flmyReceiveMineModel;
        FL_Log(@"thi1s is te1h acti1on to push the page of ticke3t");
        [weakSelf.navigationController pushViewController:ticketVC animated:YES];
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




























