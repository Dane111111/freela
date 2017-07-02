//
//  XJARClickAnimationView.m
//  FreeLa
//
//  Created by Collegedaily on 2017/5/3.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJARClickAnimationView.h"

@implementation XJARClickAnimationView
{
    CALayer *_layer;
    CAAnimationGroup *_animaTionGroup;
    CADisplayLink *_disPlayLink;
    
    
    UIButton* btn;
    UIImageView* img;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xjInit];
        _layer = [[CALayer alloc] init];
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        img = [[UIImageView alloc] init];
    }
    return self;
}


- (void)xjInit {
    
    _layer.cornerRadius = 40;
    _layer.frame = CGRectMake( self.mj_w /2 - 40, self.mj_h/2 -40, 80  , 80 );
//    layer.position = self.center;
//    layer.position = self.layer.position;
//    UIColor *color = [UIColor colorWithRed:arc4random()%10*0.1 green:arc4random()%10*0.1 blue:arc4random()%10*0.1 alpha:1];
    UIColor* color = [[UIColor redColor] colorWithAlphaComponent:0.6];
    _layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:_layer];
    
    //手指按钮
    
//    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    btn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
//    [btn setImage:[UIImage imageNamed:@"ar_littleHand"] forState:UIControlStateNormal];
    
    btn.frame = _layer.frame;
    btn.layer.cornerRadius = btn.mj_w/2;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(xjxjClickToPick) forControlEvents:UIControlEventTouchUpInside];
    
//    img = [[UIImageView alloc] init];
    [self addSubview:img];
    img.image = [UIImage imageNamed:@"ar_littleHand"];
    img.frame = CGRectMake(0, 0, 40, 40);
    img.center = btn.center;
    img.userInteractionEnabled = NO;
    
    
    
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = [NSNumber numberWithFloat:-5];
    shake.toValue = [NSNumber numberWithFloat:5];
    shake.duration = 0.1;//执行时间
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 200;//次数
    [img.layer addAnimation:shake forKey:@"shakeAnimation"];
    img.alpha = 1.0;
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
        //self.infoLabel.alpha = 0.0; //透明度变0则消失
    } completion:nil];
    
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    _animaTionGroup = [CAAnimationGroup animation];
    _animaTionGroup.delegate = self;
    _animaTionGroup.duration = 2;
    _animaTionGroup.removedOnCompletion = YES;
    _animaTionGroup.timingFunction = defaultCurve;
    _animaTionGroup.fillMode = kCAFillModeRemoved;
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @1.0;
    scaleAnimation.toValue = @4.0;
    scaleAnimation.duration = 2;
    
    CAKeyframeAnimation *opencityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opencityAnimation.duration = 2;
    opencityAnimation.values = @[@0.9,@0.7,@0.4];
    opencityAnimation.keyTimes = @[@0,@0.5,@1];
    opencityAnimation.removedOnCompletion = YES;
    
    
    NSArray *animations = @[scaleAnimation,opencityAnimation];
    _animaTionGroup.animations = animations;
    [_layer addAnimation:_animaTionGroup forKey:nil];
    
//    [self performSelector:@selector(removeLayer:) withObject:layer afterDelay:10.5];
    
    [self performSelector:@selector(xjInit) withObject:nil afterDelay:1];
}
- (void)xjxjClickToPick{
    if (self.xjClickBtn!=nil) {
        self.xjClickBtn();
    }
}


@end






