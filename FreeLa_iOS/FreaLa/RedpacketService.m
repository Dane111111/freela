//
//  RedpacketService.m
//  MobileCooperativeOffice
//
//  Created by Nile on 2017/1/16.
//  Copyright © 2017年 pcitc. All rights reserved.
//

#import "RedpacketService.h"
#define RedpacketNum 20
#define ImageX arc4random() % (NSInteger)(ScreenWidth -50)
#define ImageY -60
#define ImageW 45
#define ImageH 33
#define MinW 40
#define MaxW 50
//#define ImageW (arc4random() % (MaxW - MinW + 1)) + MinW
#define ScreenHeight FLUISCREENBOUNDS.height
#define ScreenWidth FLUISCREENBOUNDS.width

@interface RedpacketService()
@property(nonatomic,strong)UIImage * fudaiImage;
@property(nonatomic,strong)UIImage * qiandaiImage;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,weak)UIView * view;
@end

@implementation RedpacketService
+ (void)startRedpacketRainWithView:(UIView *)view{
    if ([self canStartRedpacketRain]) {
        view.layer.masksToBounds = YES;
        RedpacketService * service = [[RedpacketService alloc]initWithView:view];
        [service startRedpacketRain];
    }
}

- (instancetype)initWithView:(UIView *)view{
    if (self = [super init]) {
        self.view = view;
//        NSMutableArray * redpacketList = [NSMutableArray arrayWithCapacity:RedpacketNum];
//        self.fudaiImage = [UIImage imageNamed:@"redbag_icon"];
//        self.qiandaiImage = [UIImage imageNamed:@"redbag_icon"];
//        for (int i = 0; i < RedpacketNum; i++) {
//            
//            UIImage * image;
//            image = self.fudaiImage;
//            UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
//            imageView.frame = CGRectMake(ImageX, ImageY, ImageW, ImageH);
//            [self.view addSubview:imageView];
//            [redpacketList addObject:imageView];
//        }
//        self.redpacketList = redpacketList;
    }
    return self;
}

- (void)startRedpacketRain{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.4 target:self selector:@selector(makeRedpacket) userInfo:nil repeats:YES];
    
}

static int i = 0;
- (void)makeRedpacket
{
    i = i + 1;
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"redbag_icon"]];
    imageView.frame = CGRectMake(ImageX, ImageY, ImageW, ImageH);
    [self.view addSubview:imageView];
    imageView.tag = i;
    //        [self.redpacketList removeObjectAtIndex:0];
    [self redpacketFall:imageView];
//    [self.timer invalidate];
//    self.timer = nil;
}

- (void)redpacketFall:(UIImageView *)aImageView
{
    [UIView beginAnimations:[NSString stringWithFormat:@"%li",(long)aImageView.tag] context:nil];
    CGFloat randomDuration = arc4random() % 3 + 3.5;
    [UIView setAnimationDuration:randomDuration];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x, ScreenHeight, aImageView.frame.size.width, aImageView.frame.size.height);
    [UIView commitAnimations];
}

+ (BOOL)canStartRedpacketRain{
    return YES;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[animationID intValue]];
    imageView.frame = CGRectMake(ImageX, ImageY, ImageW, ImageH);
    [imageView removeFromSuperview];
}



@end

