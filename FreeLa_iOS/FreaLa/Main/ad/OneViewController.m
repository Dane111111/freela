//
//  OneViewController.m
//  广告demo
//
//  Created by Jarlen Huang on 16/5/31.
//  Copyright © 2016年 Jarlen Huang. All rights reserved.
//

#import "OneViewController.h"
#import "AAPLCrossDissolveTransitionAnimator.h"
#define  xjwidth   [UIScreen mainScreen].bounds.size.width
#define  xjheight  [UIScreen mainScreen].bounds.size.height
@interface OneViewController ()<UIViewControllerTransitioningDelegate>
{
    UIImageView *_adsImageView;// 图片视图
    NSTimer *_waitRequestTimer;//
    NSTimer *_adsAccordingTimer;
    UIButton *_time_btton;
    UIButton *_jump_button;
    NSInteger _seconds;
    NSInteger _adsAccording_Integer;
    UIImageView *_LaunchImage;
    NSString* _xjImageURL;
    NSString* _xjJumpURL;
    
}
@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitioningDelegate = self;
    _LaunchImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    _LaunchImage.contentMode = UIViewContentModeScaleAspectFit;
    NSString* name = [self splashImageNameForOrientation:UIDeviceOrientationPortrait];
    _LaunchImage.image = [UIImage imageNamed:name];
//    _LaunchImage.backgroundColor = [UIColor whiteColor];
//    [_LaunchImage sd_setImageWithURL:[NSURL URLWithString:_xjImageURL] placeholderImage:[UIImage imageNamed:@"LaunchImage"]];
    _LaunchImage.userInteractionEnabled = YES;
    [self.view addSubview:_LaunchImage];
    [self requestAds];
    _seconds = 6;
    _waitRequestTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Waiting) userInfo:nil repeats:YES];
}
-(void)requestAds
{
    
    // 模拟网络请求
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self addUI];
//        [_waitRequestTimer invalidate];
//    });
    
    dispatch_async(dispatch_get_main_queue() , ^{
        [FLNetTool xjgetRcommendTopicImageByCommentId:nil success:^(NSDictionary *data) {
            FL_Log(@"this is the data of the image of guanggao per =[%@]",data);
            if ([data[@"total"] integerValue]==0) {
                
            }
            if ([data[FL_NET_KEY_NEW] boolValue] && [data[@"total"] integerValue]!=0) {
                _xjImageURL = [NSString stringWithFormat:@"%@",data[FL_NET_DATA_KEY][0][@"filePath2"]];
                _xjJumpURL = [NSString stringWithFormat:@"%@",data[FL_NET_DATA_KEY][0][@"url"]];
//                [[NSUserDefaults standardUserDefaults] setObject:_xjImageURL forKey:@"xjADImageURL"];
                [self addUI];
                [_waitRequestTimer invalidate];
            }
            NSArray* xxxxx = data[FL_NET_DATA_KEY];
            if ([xxxxx count]>=1) {
                NSInteger xj_selectedId = [xxxxx[0][@"id"] integerValue];
//                [self xj_getPvNumberIndex:xj_selectedId];//增加一个pv
            }
        } failure:^(NSError *error) {
            
        }];
    });
    
}
//获取启动页图片名称
- (NSString *)splashImageNameForOrientation:(UIDeviceOrientation)orientation {
    CGSize viewSize = self.view.bounds.size;
    NSString* viewOrientation = @"Portrait";
    if (UIDeviceOrientationIsLandscape(orientation)) {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            return dict[@"UILaunchImageName"];
    }
    return nil;
}
-(void)Waiting
{
    _seconds--;
    if (_seconds == 0) {
        [self myLog];
    }
}
/**
 *  添加广告上面的UI
 */
-(void)addUI{

    _adsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, xjwidth,  xjheight)];
    _adsImageView.userInteractionEnabled = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_xjImageURL]];
        UIImage *main_image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _adsImageView.image = main_image;
//            [_LaunchImage sd_setImageWithURL:[NSURL URLWithString:_xjImageURL] placeholderImage:[UIImage imageNamed:@"LaunchImage"]];
        });
    });
    [_LaunchImage addSubview:_adsImageView];
    UIButton* xjbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_LaunchImage addSubview:xjbtn];
    xjbtn.frame = CGRectMake(0, 0, xjwidth, xjheight-100);
    [xjbtn addTarget:self action:@selector(xjGotoSafari) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     *  显示倒计时的时间按钮
     *
     */
    _time_btton = [self addButtonWithImagename:@"miaoshu" andTitle:@"5S" andFram:CGRectMake(xjwidth-70, 30, 50, 30)];
    /**
     *  创建倒计时
     *
     */
    _adsAccordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAccord) userInfo:nil repeats:YES];
    _adsAccording_Integer = 6;
}

- (void)xjGotoSafari {
    NSURL* url = [NSURL URLWithString:_xjJumpURL];
    BOOL canjump = [[UIApplication sharedApplication] canOpenURL:url];
    if (canjump) {
        [[UIApplication sharedApplication] openURL:url];
    }
}
/**
 *  广告的倒计时
 */
-(void)timerAccord
{
    _adsAccording_Integer--;
    [_time_btton setTitle:[NSString stringWithFormat:@"%zd",_adsAccording_Integer] forState:0];
    if (_adsAccording_Integer <=  0) {
        [self myLog];
    }
    /**等于2秒时显示直接接入按钮*/
//    if (_adsAccording_Integer == 4) {
        _jump_button  = [self addButtonWithImagename:@"tiaoguo" andTitle:@"直接进入>" andFram:CGRectMake(xjwidth-150,xjheight-80, 120, 45)];
        [_jump_button setTitleColor:[UIColor whiteColor] forState:0];
        _jump_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_jump_button addTarget:self action:@selector(myLog) forControlEvents:UIControlEventTouchUpInside];
//    }
}
/**
 *  点击进入按钮
 */
-(void)myLog
{
     self.myBlock(YES);
//    CATransition * animation = [CATransition animation];
//    animation.duration = 1.5;    //  时间
//    animation.type = @"oglFlip";
//    animation.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [_waitRequestTimer invalidate];
        [_adsAccordingTimer invalidate];
    }];
}
/**
 *  创建广告上面的button按钮
 *
 *  @param imageName 按钮的图片
 *  @param title     按钮的文字
 *  @param btnFram   按钮的fram
 *
 *  @return 返回按钮
 */
-(UIButton *)addButtonWithImagename:(NSString *)imageName andTitle:(NSString *)title andFram:(CGRect)btnFram{
    
//    UIButton *button =[[UIButton alloc]initWithFrame:btnFram];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = btnFram;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:0];
    [button setTitle:title forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [button setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    button.userInteractionEnabled = YES;
    [_adsImageView addSubview:button];
    return button;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [AAPLCrossDissolveTransitionAnimator new];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [AAPLCrossDissolveTransitionAnimator new];
}
@end
