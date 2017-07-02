//
//  XJCircleAnimationView.m
//  xjTest
//
//  Created by Leon on 2017/1/11.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJCircleAnimationView.h"

#define xjWidth [UIScreen mainScreen].bounds.size

#define xj_circle_one  144
#define xj_circle_Two  116
#define xj_circle_Three  150
#define xj_base_circle   100

@interface XJCircleAnimationView ()<CAAnimationDelegate>

@property (nonatomic , strong) UIImageView* imgView1;
@property (nonatomic , strong) UIImageView* imgView2;
@property (nonatomic , strong) UIImageView* imgView3;


@end

@implementation XJCircleAnimationView
{
    CAAnimationGroup * xj_animationGroup;
    CABasicAnimation * xj_scaleAnimationBig;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGPoint xjcenter;
        CGFloat xjW1 = xj_circle_one*2;
        CGFloat xjW2 = xj_circle_Two*2;
        CGFloat xjW3 = xj_circle_Three*2;
        self.imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, xjW1, xjW1)];
        self.imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, xjW2, xjW2)];
        self.imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, xjW3, xjW3)];
        [self addSubview:self.imgView1];
        [self addSubview:self.imgView2];
        [self addSubview:self.imgView3];
        xjcenter = CGPointMake((frame.size.width)/2, (frame.size.height)/2);
        self.imgView1.center = xjcenter;
        self.imgView2.center = xjcenter;
        self.imgView3.center = xjcenter;
        self.imgView1.image = [UIImage imageNamed:@"ar_red_circle"];
        self.imgView2.image = [UIImage imageNamed:@"ar_write_circle"];
        self.imgView3.image = [UIImage imageNamed:@"ar_blue_circle"];
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
//        [self xj_circleStart];
        
        UILabel* xjText = [[UILabel alloc] init];
        xjText.frame = CGRectMake(0, 0, 160, 30);
        xjText.font = [UIFont fontWithName:FL_FONT_NAME size:12];
        xjText.text = @"对准目标物体停留一会儿";
        xjText.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        xjText.textColor = [UIColor whiteColor];
        xjText.layer.cornerRadius = xjText.height/2;
        xjText.layer.masksToBounds = YES;
        [self addSubview:xjText];
        [xjText setTextAlignment:NSTextAlignmentCenter];
        xjText.center = CGPointMake(self.centerX,self.centerY + xj_circle_Three);
        
    
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}

- (void)xj_circleStart{
    [_imgView1.layer removeAllAnimations];
    [_imgView2.layer removeAllAnimations];
    [_imgView3.layer removeAllAnimations];
    
    _imgView1.hidden = NO;
    _imgView2.hidden = NO;
    _imgView3.hidden = NO;
    
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.fillMode = kCAFillModeBackwards;
    animationGroup.beginTime = CACurrentMediaTime()  ;
    animationGroup.duration = 2;
    animationGroup.repeatCount = 1;
    animationGroup.timingFunction = defaultCurve;
    
    
    CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
    opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
    
    CABasicAnimation * scaleAnimationBig = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimationBig.fromValue = @2.3;
    scaleAnimationBig.toValue = @0.9;
    
    animationGroup.animations = @[scaleAnimationBig, opacityAnimation];
    [_imgView1.layer addAnimation:animationGroup forKey:@"plulsing"];
    [_imgView2.layer addAnimation:animationGroup forKey:@"plulsing"];
    [_imgView3.layer addAnimation:animationGroup forKey:@"plulsing"];
    [self performSelector:@selector(xj_middle) withObject:nil afterDelay:2];
}

- (void)xj_done {
    [_imgView1.layer removeAllAnimations];
    [_imgView2.layer removeAllAnimations];
    [_imgView3.layer removeAllAnimations];
    
    [self performSelector:@selector(xj_remove) withObject:nil afterDelay:1.9];
    
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    xj_animationGroup = [CAAnimationGroup animation];
    xj_animationGroup.fillMode = kCAFillModeBackwards;
    xj_animationGroup.beginTime = CACurrentMediaTime()  ;
    xj_animationGroup.duration = 2;
    xj_animationGroup.repeatCount = 1;
    xj_animationGroup.timingFunction = defaultCurve;
    xj_animationGroup.removedOnCompletion = YES;
    
    
    CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
    opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
    
    xj_scaleAnimationBig = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    xj_scaleAnimationBig.fromValue = @1.4;
    xj_scaleAnimationBig.toValue = @2.5;
 
    
    xj_animationGroup.animations = @[xj_scaleAnimationBig, opacityAnimation];
    [_imgView1.layer addAnimation:xj_animationGroup forKey:@"plulsing"];
    [_imgView2.layer addAnimation:xj_animationGroup forKey:@"plulsing"];
    [_imgView3.layer addAnimation:xj_animationGroup forKey:@"plulsing"];
    
}



- (void)xj_remove{
//    [self removeFromSuperview];
    _imgView1.hidden = YES;
    _imgView2.hidden = YES;
    _imgView3.hidden = YES;
    
}
- (void)xj_middle {
    [_imgView1.layer removeAllAnimations];
    [_imgView2.layer removeAllAnimations];
    [_imgView3.layer removeAllAnimations];
    
    [self xj_init];
    [self xj_set2];
    [self xj_set3];
    

}

- (void) xj_reset {
    [_imgView1.layer removeAllAnimations];
    [_imgView2.layer removeAllAnimations];
    [_imgView3.layer removeAllAnimations];
    
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.fillMode = kCAFillModeBackwards;
    animationGroup.beginTime = CACurrentMediaTime()  ;
    animationGroup.duration = 2;
    animationGroup.repeatCount = 1;
    animationGroup.timingFunction = defaultCurve;
    
    
    CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
    opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
    
    CABasicAnimation * scaleAnimationBig = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimationBig.fromValue = @1.4;
    scaleAnimationBig.toValue = @2.5;
    
    animationGroup.animations = @[scaleAnimationBig, opacityAnimation];
    [_imgView1.layer addAnimation:animationGroup forKey:@"plulsing"];
    [_imgView2.layer addAnimation:animationGroup forKey:@"plulsing"];
    [_imgView3.layer addAnimation:animationGroup forKey:@"plulsing"];
}


- (void)xj_init {
    double animationDuration = 13;
    
    //    [self.imgView1 setTransform:nil];
    
    //    [self.view addSubview:self.imgView1];
    
    
    CABasicAnimation* rotationAnimation1;
    rotationAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation1.duration = 3;
    rotationAnimation1.cumulative = YES;
    rotationAnimation1.repeatCount = HUGE;
    //    [_imgView1.layer addAnimation:rotationAnimation1 forKey:@"rotationAnimation"];
    
    
    
    
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.fillMode = kCAFillModeBackwards;
    animationGroup.beginTime = CACurrentMediaTime()  ;
    animationGroup.duration = animationDuration;
    animationGroup.repeatCount = HUGE;
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat: -(M_PI) ];
    scaleAnimation.toValue = [NSNumber numberWithFloat: M_PI * 4.0 ];
    //    scaleAnimation.
    scaleAnimation.cumulative = YES;
    scaleAnimation.repeatCount = HUGE;
    //    scaleAnimation.autoreverses = YES;
    scaleAnimation.duration = 5;
    
    CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@1, @0.95, @0.9, @0.85, @0.8, @0.75, @0.7, @0.6, @0.6, @0.6, @0.6];
    //    opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
    
    CABasicAnimation * scaleAnimationBig = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //    scaleAnimationBig.fromValue = @1.4;
    //    scaleAnimationBig.toValue = @2.2;
    
    
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [_imgView1.layer addAnimation:scaleAnimation forKey:@"plulsing"];
    //    [_imgView1 addSublayer:pulsingLayer];
    
    
}

- (void)xj_set2{
    double animationDuration = 13;
    
    
    
    CABasicAnimation *momAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    momAnimation.fromValue = [NSNumber numberWithFloat:4];
    momAnimation.toValue = [NSNumber numberWithFloat:-4];
    momAnimation.duration = 5;
    momAnimation.repeatCount = CGFLOAT_MAX;
//    momAnimation.autoreverses = YES;
//    momAnimation.delegate = self;
    [self.imgView2.layer addAnimation:momAnimation forKey:@"animateLayer2"];
    
}

- (void)xj_set3{
    double animationDuration = 13;
    
    
    CABasicAnimation *momAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    momAnimation.fromValue = [NSNumber numberWithFloat: (M_PI) ];
    momAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 4.0 ];
    momAnimation.duration =  5;
    momAnimation.repeatCount = CGFLOAT_MAX;
    momAnimation.autoreverses = YES;
//    momAnimation.delegate = self;
    [self.imgView3.layer addAnimation:momAnimation forKey:@"animateLayer3"];
    
}

 

@end










