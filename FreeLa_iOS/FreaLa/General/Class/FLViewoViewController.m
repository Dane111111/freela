//
//  ViewoViewController.m
//  FreeLa
//
//  Created by 楚志鹏 on 15/9/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLViewoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FLHeader.h"
#import "FLLogIn_RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface FLViewoViewController ()
{
    MPMoviePlayerViewController* moviePlayerView;
}

@end

@implementation FLViewoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playingDone) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //添加手势立刻进入注册页
    
    [self playMovie];
  
}

//视频播放
- (void)playMovie
{
    NSString* urlPath = [[NSBundle mainBundle] pathForResource:@"Pizza" ofType:@"mp4"];
    NSURL*    url     = [NSURL fileURLWithPath:urlPath];
    moviePlayerView   = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    
    moviePlayerView.moviePlayer.controlStyle    = MPMovieControlStyleNone;
    moviePlayerView.moviePlayer.scalingMode     = MPMovieScalingModeAspectFill;
    //    moviePlayerView.moviePlayer.
    moviePlayerView.view.frame = CGRectMake(0 ,0, (FLUISCREENBOUNDS.width), (FLUISCREENBOUNDS.height));
    //     moviePlayerView.view.frame = CGRectMake(20 ,20,270, 300);
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GoToNext:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    self.view.userInteractionEnabled = YES;
    [moviePlayerView.view addGestureRecognizer:tapGesture];
    [self.view addSubview:moviePlayerView.view];
}

#pragma mark ------视频结束回调
- (void)playingDone
{
    NSLog(@"播放完成");
    FLLogIn_RegisterViewController* LogIn_RegisterVC = [[FLLogIn_RegisterViewController alloc]init];
    [self presentViewController:LogIn_RegisterVC animated:YES completion:nil];
    
}

- (void)GoToNext:(UIGestureRecognizer*)gesture
{
    NSLog(@"播放完成");
    FLLogIn_RegisterViewController* LogIn_RegisterVC = [[FLLogIn_RegisterViewController alloc]init];
    [self presentViewController:LogIn_RegisterVC animated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
