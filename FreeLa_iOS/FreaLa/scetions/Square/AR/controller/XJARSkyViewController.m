//
//  XJARSkyViewController.m
//  FreeLa
//
//  Created by Collegedaily on 2017/4/24.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJARSkyViewController.h"
#import "FINCamera.h"
#import "FLMyReceiveListModel.h"
#import <CoreMotion/CoreMotion.h>
#import "XJFindGiftViewController.h"
#import "XJFindGiftViewController.h"

#define xj_tag  1831122

@interface XJARSkyViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,FINCameraDelagate,UIAccelerometerDelegate>
{
    float _previousY;
    CMMotionManager *manager;
    NSMutableArray* _dataSource;
    NSMutableArray* _imageViewArr;
    
}
@property(nonatomic,strong)FINCamera * camera;
@property (strong, nonatomic) UIButton *flGoBackBtn;

@end

@implementation XJARSkyViewController

- (UIButton *)flGoBackBtn {
    if (!_flGoBackBtn) {
        _flGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flGoBackBtn.frame = CGRectMake(20, 20, 40, 40);
        [_flGoBackBtn setBackgroundImage:[UIImage imageNamed:@"mypublish_btn_reback"] forState:UIControlStateNormal];
        [_flGoBackBtn addTarget:self action:@selector(xj_popGoBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flGoBackBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self openCamera];
    _previousY = 0.14;
    _dataSource = @[].mutableCopy;
    _imageViewArr = @[].mutableCopy;
    [self xjFetchData];
    [self.view addSubview:self.flGoBackBtn];
}
- (void)xj_popGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)xjFetchData{
    
    [FLNetTool xjGetSkyGiftpResultsFromServer:nil success:^(NSDictionary *data) {
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
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 相机
- (void)openCamera {
    __weak XJARSkyViewController* weakSelf = self;
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

- (FLMyReceiveListModel*)returnModelForTicketsWithData:(NSDictionary*)data {
    FLMyReceiveListModel* model = [[FLMyReceiveListModel alloc] init];
    model.flIntroduceStr = data[@"topicExplain"];
    model.flMineIssueTopicIdStr = data[@"topicId"];
    model.xjCreator = [data[@"creator"] integerValue];
    model.xjUserId = [data[@"userId"] integerValue];
    model.flTimeBegan = data[@"startTime"];
    model.xjinvalidTime = data[@"invalidTime"];
    model.xjUrl = data[@"url"];
    model.xjUserType = data[@"userType"];
//    NSString* suolve = data[@"sitethumbnail"];
//    if ([XJFinalTool xjStringSafe:suolve]) {
//        if (![suolve hasSuffix:@".gif"]&&![suolve hasSuffix:@".mp4"]) {
//            model.xj_suolvetuStr = suolve;
//        }
//    
//    }
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

- (void)xjImageInit{
    
    //base view
    UIView* base = [[UIView alloc] init];
    base.frame = CGRectMake(-self.view.frame.size.width , -self.view.frame.size.height / 2, self.view.frame.size.width * 3, -self.view.frame.size.height);
    [self.view insertSubview:base atIndex:1];
    
    
    //初始化 image
    
    for (NSInteger i = 0; i < _dataSource.count; i++) {
        //img 背景
        UIView* backview = [[UIView alloc] init];
        [base addSubview:backview];
        backview.backgroundColor = [UIColor whiteColor];
        
        //随机x  y 轴的初始位置
        CGFloat xjx = 30 +  (arc4random() % 51);
        CGFloat xjy = 20 +  (arc4random() % 251);
        backview.frame = CGRectMake(xjx + 300 * i, xjy, 210, 170);
        
        //划线
        UIView* redView = [[UIView alloc] init];
        [backview addSubview:redView];
        redView.frame = CGRectMake(backview.width/2 - 10, -15, 20, 30);
        redView.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];
        
        UIView* lineView = [[UIView alloc] init];
        [backview addSubview:lineView];
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.frame = CGRectMake(backview.width/2, -FLUISCREENBOUNDS.height, 1, FLUISCREENBOUNDS.height);
        
        
        
        UIImageView* image = [[UIImageView alloc] init];
//        image.frame = CGRectMake(xjx + 300 * i, xjy, 200, 160);
        image.frame = CGRectMake(5, 5, 200, 160);
        image.tag = xj_tag + i;
        image.userInteractionEnabled = YES;
        [backview insertSubview:image atIndex:1];
        FLMyReceiveListModel* model = _dataSource[i];
        [image sd_setImageWithURL:[NSURL URLWithString:model.xj_suolvetuStr]];
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
            
            
            CGFloat rotationRateX =  base.center.x+5*gyroData.rotationRate.y;
            CGFloat rotationRateY = base.center.y+5*gyroData.rotationRate.x;
            
            if (rotationRateX > self.view.frame.size.width*3/2) {
                NSLog(@"rotationRateX > self.view.frame.size.width*3/2");
                rotationRateX =self.view.frame.size.width*3/2;
            }
            if(rotationRateX < (-self.view.frame.size.width/2)){
                NSLog(@"rotationRateX < (-self.view.frame.size.width/2)");
                rotationRateX=(-self.view.frame.size.width/2);
            }
            if (rotationRateY > self.view.frame.size.height) {
                NSLog(@"rotationRateY > self.view.frame.size.height");
                rotationRateY= self.view.frame.size.height;
            }
            if (rotationRateY < 0) {
                NSLog(@"rotationRateY < 0");
                rotationRateY=0;
            }
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [base setCenter:CGPointMake(rotationRateX, rotationRateY)];
                             }
                             completion:nil];
            
            
            
        }];
    }
}
- (void)xjxjtesttagtag :(UITapGestureRecognizer*)tapg  {
    
    NSInteger tag = tapg.view.tag - xj_tag;
    FLMyReceiveListModel* model = _dataSource[tag];
    
    XJFindGiftViewController* vvc = [[XJFindGiftViewController alloc] init];
    [vvc xjSetModel:model];
    [self.navigationController pushViewController:vvc animated:YES];
    
}

@end




