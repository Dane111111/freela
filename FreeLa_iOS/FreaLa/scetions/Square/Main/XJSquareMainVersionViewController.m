//
//  XJSquareMainVersionViewController.m
//  FreeLa
//
//  Created by Collegedaily on 2017/5/15.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJSquareMainVersionViewController.h"
#import "FINCamera.h"
#import "XJSquareMainView.h"
#import "PGIndexBannerSubiew.h"
#import "NewPagedFlowView.h"
#import "AFWaveView.h"
#import "FLAdvertTopicPictures.h"
#import "FLAllFreeCouponModel.h"
#import "FLCountDownActivityModel.h"
#import "FLZLQTopicModel.h"
#import "RedpacketService.h"
#import <UIImageView+WebCache.h>
#import "XJXJScanViewController.h"
#import "XJTableViewAllFreeVersionTwo.h"
#import "XJTableViewCouponVersionTwo.h"
#import "CollectStarView.h"

#define kRecommandeItemWH 220.0/720 * FLUISCREENBOUNDS.width

@interface XJSquareMainVersionViewController ()<FINCameraDelagate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property(nonatomic,strong)FINCamera * camera;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UIButton *arBtn;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet NewPagedFlowView *hotPointRecommendView;
@property (weak, nonatomic) IBOutlet UIImageView *helpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *countDownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *allFreeImageView;

@property (nonatomic, strong) NSMutableArray *recommendsArr;
@property (nonatomic, strong) NSTimer *rippleTimer;
@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;
@property (weak, nonatomic) IBOutlet UILabel *countDownTitleLb;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *redCircleImageView;
@property (weak, nonatomic) IBOutlet UILabel *arLabel;

/**MainView*/
@property (nonatomic , strong) XJSquareMainView* xjMainView;
@end

@implementation XJSquareMainVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.automaticallyAdjustsScrollViewInsets = NO;
    [self configHotPointRecommendView];
    [self downloadAllData];
    [self openCamera ];
    [self.view addSubview:self.xjMainView];
    [self p_showARButtonCircleView];
    [RedpacketService startRedpacketRainWithView:self.topView];
    self.helpLabel.layer.borderColor = [UIColor colorWithHexString:@"7F7F7F"].CGColor;
    self.helpLabel.layer.borderWidth = 1;
    
    NSString* xx = XJ_USER_SESSION;
    if ([XJFinalTool xjStringSafe:xx]) {
        [self xjRequestUserInfoWithToken:xx];
    }
    //进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnterBackGround)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [self jiXingZhuHuoDong];
}
-(void)jiXingZhuHuoDong{
    [FLNetTool deGetNewIsMainWith:nil success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray * dataArr=data[@"data"];
            if (dataArr&&dataArr.count>0) {
                NSArray *aArray =[ dataArr[0][@"startTime"] componentsSeparatedByString:@" "];
                NSArray *bArray =[ dataArr[0][@"endTime"] componentsSeparatedByString:@" "];
                [self jixingZhuHuoDongViewWithStart:aArray[0] end:bArray[0] ];

            }
        }
    } failure:^(NSError *error) {
        
    }];

}
-(void)jixingZhuHuoDongViewWithStart:(NSString*)start end:(NSString*)end{
    CollectStarView*cview=[[CollectStarView alloc] initWithBeginTime:start endTime:end];
    cview.pushBlock=^(){
        XJXJScanViewController* xjPerson = [[XJXJScanViewController alloc] init];
        [self.navigationController pushViewController:xjPerson animated:YES];
    };
    UIWindow *window = [[UIApplication sharedApplication ].windows lastObject];

    [window addSubview:cview.maskView];
    [window addSubview:cview];
    [cview popUp];

}
- (void)appHasGoneInForeground{
    
    //    [self.rippleTimer setFireDate:[NSDate distantPast]];
    
    if (_rippleTimer == nil) {
        //        self.rippleTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(changeColorAnimation) userInfo:nil repeats:YES];
        //        [[NSRunLoop currentRunLoop] addTimer:_rippleTimer forMode:NSRunLoopCommonModes];
        [self changeColorAnimation];
        self.rippleTimer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeColorAnimation) userInfo:nil repeats:YES];
        
        
    }
    [self.camera endSession];
    
    [self.camera startSession];
    [self.camera performSelector:@selector(startSession) withObject:nil afterDelay:1.0f];

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.camera startSession];
//        
//    });
    
}

- (void)appEnterBackGround{
    
    //    [self.rippleTimer setFireDate:[NSDate distantFuture]];
    
    [self.rippleTimer invalidate];
    self.rippleTimer = nil;
    
    [self.camera endSession];
    
}

- (void)configHotPointRecommendView{
    _hotPointRecommendView.backgroundColor = [UIColor clearColor];
    _hotPointRecommendView.delegate = self;
    _hotPointRecommendView.dataSource = self;
    _hotPointRecommendView.minimumPageAlpha = 0;
    _hotPointRecommendView.orginPageCount = self.recommendsArr.count;
    _hotPointRecommendView.isOpenAutoScroll = NO;
    _hotPointRecommendView.leftRightMargin = 36;
    [_hotPointRecommendView reloadData];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.tabBarController.tabBar setHidden:NO];
    [self downloadAllData];
    [self.camera startSession];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self jiXingZhuHuoDong];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (XJSquareMainView *)xjMainView {
    return nil;
    if (!_xjMainView) {
        CGRect frame = CGRectMake(0, 220, FLUISCREENBOUNDS.width, FLUISCREENBOUNDS.height - 220);
        _xjMainView = [[XJSquareMainView alloc] initWithFrame:frame];
    }
    return _xjMainView;
}
#pragma mark - 相机
- (void)openCamera {
    __weak XJSquareMainVersionViewController* weakSelf = self;
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

#pragma mark --懒加载
- (NSMutableArray *)recommendsArr{
    if (!_recommendsArr) {
        _recommendsArr = [NSMutableArray array];
    }
    return _recommendsArr;
}
#pragma mark - 轮播图 NewPagedFlowView Delegate
/**点击了轮播图*/
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    FLRecyclePicModel* model = self.recommendsArr[subIndex];
    FL_Log(@"kkdksjakkkjflajglksjl=【%ld】",model.topicId);
    FLFuckHtmlViewController* html = [[FLFuckHtmlViewController alloc] init];
    html.flFuckTopicId = [NSString stringWithFormat:@"%ld",model.topicId];
    [self.navigationController pushViewController:html animated:YES];
}

#pragma mark  NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.recommendsArr.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, kRecommandeItemWH,kRecommandeItemWH)];
    }
    
    FLRecyclePicModel *item = self.recommendsArr[index];
    bannerView.model = item;
    return bannerView;
}


- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kRecommandeItemWH, kRecommandeItemWH);
}

#pragma mark --旋转屏幕改变newPageFlowView大小之后实现该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [coordinator animateAlongsideTransition:^(id context) { [self.hotPointRecommendView reloadData]; } completion:NULL];
    }
}

- (void)dealloc {
    
    /****************************
     在dealloc或者返回按钮里停止定时器
     ****************************/
    [self p_closeRippleTimer];
    [self.hotPointRecommendView stopTimer];
}

#pragma mark - AR按钮波纹图
- (void)p_showARButtonCircleView{
    [self changeColorAnimation];
    self.rippleTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(changeColorAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_rippleTimer forMode:NSRunLoopCommonModes];
}
- (void)changeColorAnimation{
    [self rippleAnimation];
    [UIView animateWithDuration:1.25 animations:^{
        self.redCircleImageView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.75 animations:^{
            self.redCircleImageView.alpha = 1;
        }];
    }];
    static int flag = 0;
    if (flag % 2 == 0) {
        _arLabel.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:2 animations:^{
            _arLabel.transform = CGAffineTransformScale(_arLabel.transform,0.5,0.5);
        }];
    } else {
        [UIView animateWithDuration:2 animations:^{
            _arLabel.transform = CGAffineTransformIdentity;
        }];
    }
    flag++;
}
- (void)rippleAnimation{
    AFWaveView *waveView = [[AFWaveView alloc]initWithPoint:self.redCircleImageView.center];
    waveView.duration = 2;
    waveView.maxR = 85;
    waveView.waveCount = 3;
    waveView.waveDelta = 10;
    waveView.maxAlpha = 0.4;
    waveView.minAlpha = 0;
    waveView.waveStyle = Circle;
    waveView.mainColor = [UIColor colorWithHexString:@"ff3131"];
    [self.arBtn.superview insertSubview:waveView belowSubview:self.redCircleImageView];
}
- (void)p_closeRippleTimer
{
    if (_rippleTimer) {
        if ([_rippleTimer isValid]) {
            [_rippleTimer invalidate];
        }
        _rippleTimer = nil;
    }
}
#pragma mark - 点击事件

/**
 开启AR寻宝点击事件
 */
- (IBAction)startARAction:(id)sender {
    XJXJScanViewController* xjPerson = [[XJXJScanViewController alloc] init];
    [self.navigationController pushViewController:xjPerson animated:YES];
}
/**助力抢*/
- (IBAction)helpActivityAction:(id)sender {
    XJTableViewAllFreeVersionTwo* xjCoupon = [[XJTableViewAllFreeVersionTwo alloc] initWithType:3];
    [self.navigationController pushViewController:xjCoupon animated:YES];
}
/**全免费*/
- (IBAction)allFreeAction:(id)sender {
    XJTableViewAllFreeVersionTwo* xjAllFree = [[XJTableViewAllFreeVersionTwo alloc] initWithType:1];
    [self.navigationController pushViewController:xjAllFree animated:YES];
}
/**优惠券*/
- (IBAction)couponAction:(id)sender {
    XJTableViewCouponVersionTwo* xjCoupon = [[XJTableViewCouponVersionTwo alloc] init];
    [self.navigationController pushViewController:xjCoupon animated:YES];
}
/**倒计时活动*/
- (IBAction)countDownActivityAction:(id)sender {
    XJTableViewAllFreeVersionTwo* xjCoupon = [[XJTableViewAllFreeVersionTwo alloc] initWithType:4];
    xjCoupon.topicZxTheme=self.countDownTitleLb.text;
    [self.navigationController pushViewController:xjCoupon animated:YES];
}
#pragma mark - 网络相关
- (void)downloadAllData{
    [self p_getPics];
    [self p_getCoupon];
    [self p_getAllFree];
    [self p_getZhuLiQiang];
    [self p_getCountDownActivity];
}
- (void)p_getPics{
    [FLNetTool xjGetRecyclePics:nil success:^(NSDictionary *data) {
        FLAdvertTopicPictures *pics = [FLAdvertTopicPictures mj_objectWithKeyValues:data];
        if (pics.success) {
            [self.recommendsArr removeAllObjects];
            FLRecyclePicModel *item = pics.data.firstObject;
            [self.recommendsArr addObjectsFromArray:pics.data];
            if (pics.data.count == 1) {
                [self.recommendsArr addObjectsFromArray:@[item,item]];
            } else if (pics.data.count == 2) {
                [self.recommendsArr addObjectsFromArray:@[item]];
            }
            [_hotPointRecommendView reloadData];
        } else {
            NSLog(@"返回失败");
        }
    } failure:^(NSError *error) {

    }];
}
- (void)p_getZhuLiQiang{
    [FLNetTool xjGetzlqTopicList:nil success:^(NSDictionary *data) {
        FLZLQTopicModel *zlq = [FLZLQTopicModel mj_objectWithKeyValues:data];
        FLZlqItem *firstItem = zlq.data.firstObject;
        [self.helpImageView sd_setImageWithURL:[NSURL URLWithString:[firstItem.thumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        self.helpLabel.text = firstItem.topicTheme;
    } failure:^(NSError *error) {
        NSLog(@"----%@",error);
    }];
}
- (void)p_getAllFree{
    
    [FLNetTool xjGetAllFreeList:1 success:^(NSDictionary *data) {
        FLAllFreeCouponModel *free = [FLAllFreeCouponModel mj_objectWithKeyValues:data];
        AllFreeItem *item = free.data.firstObject;
        [self.allFreeImageView sd_setImageWithURL:[NSURL URLWithString:[item.thumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } failure:^(NSError *error) {
        NSLog(@"----%@",error);
    }];
}
- (void)p_getCoupon{
    [FLNetTool xjGetCouponList:1 success:^(NSDictionary *data) {
        FLAllFreeCouponModel *free = [FLAllFreeCouponModel mj_objectWithKeyValues:data];
        AllFreeItem *item = free.data.firstObject;
        [self.couponImageView sd_setImageWithURL:[NSURL URLWithString:[item.thumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } failure:^(NSError *error) {
        NSLog(@"----%@",error);
    }];
}
- (void)p_getCountDownActivity{
    [FLNetTool xjGetNewOneList:nil success:^(NSDictionary *data) {
        FLCountDownActivityModel *model = [FLCountDownActivityModel mj_objectWithKeyValues:data];
        CountDownItem *item = model.data.firstObject;
        [self.countDownImageView sd_setImageWithURL:[NSURL URLWithString:[item.thumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        self.countDownLabel.text = item.countDownTime;
        self.countDownTitleLb.text = item.topicZxTheme;
    } failure:^(NSError *error) {
        NSLog(@"----%@",error);
    }];
}


- (void)xjRequestUserInfoWithToken:(NSString*)xjToken {
    NSDictionary* parm  = @{@"token":xjToken,
                            @"accountType":@"per",
                            };
    FL_Log(@"see info 新 in mine :sesdddssionId = %@  parm = %@",xjToken,parm);
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is the result of login =%@",data);
        if (data) {
            NSString* xjStr = [NSString stringWithFormat:@"%@",data[@"userId"]];
            NSString* xjPhone=[NSString stringWithFormat:@"%@",data[@"phone"]];
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjStr key:FL_USERDEFAULTS_USERID_KEY];
            [XJFinalTool xjSaveUserInfoInUserdefaultsValue:xjPhone key:XJ_VERSION2_PHONE];
            
            [[XJUserAccountTool share] xj_saveUserName:data[@"nickname"]];
            [[XJUserAccountTool share] xj_saveUserAvatar:data[@"avatar"]];
            [[XJUserAccountTool share] xj_saveUserState:[NSString stringWithFormat:@"%@",data[@"state"]]];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
