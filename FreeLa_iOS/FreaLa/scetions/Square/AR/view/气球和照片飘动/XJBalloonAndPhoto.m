//
//  XJBalloonAndPhoto.m
//  FreeLa
//
//  Created by MBP on 17/8/3.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJBalloonAndPhoto.h"
@interface XJBalloonAndPhoto ()
@property(nonatomic,strong)UIView*ballAndline;
@property(nonatomic,strong)UIView*backview;

@end

@implementation XJBalloonAndPhoto

-(instancetype)init{
    if (self=[super init]) {
        
    }
    return self;
}
-(void)setNum:(NSInteger)num{
    _num=num;
    [self createUI];
}
-(void)createUI{
    
    //随机x  y 轴的初始位置
    CGFloat xjx = 250 +  (arc4random() % 51);
    CGFloat xjy = 200 +  (arc4random() % 151);
    
    CGFloat xjxjxj =  0 + (arc4random() % 100);
    CGFloat xjw ;
    if (xjxjxj < 30) {
        xjw = 125;
    } else if (xjxjxj < 60 && xjxjxj >= 30) {
        xjw = 150;
    } else {
        xjw = 100;
    }
    xjw=xjw*0.8;
    CGFloat qiQiu_hengShubi=1.162;
    CGFloat xianBili=1.4*0.75;
    self.frame=CGRectMake(xjx+250*_num, xjy-xianBili*xjw, xjw, xjw*(1+qiQiu_hengShubi+xianBili));
    
    /**气球和线*/
    UIView*ballAndline=[[UIView alloc]initWithFrame:CGRectMake(0, 0, xjw, xjw*(qiQiu_hengShubi+xianBili)-15)];
    [self addSubview:ballAndline];
    ballAndline.backgroundColor=[UIColor clearColor];
    //旋转动画。
    ballAndline.layer.anchorPoint = CGPointMake(0.5, 1);
    self.ballAndline=ballAndline;
    
    //气球
    UIImageView*qiqiu_imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LBS_hongqiqiu"]];
    qiqiu_imageV.frame=CGRectMake(0, 0, xjw, xjw*qiQiu_hengShubi);
    [ballAndline addSubview:qiqiu_imageV];
    //线
    UIView* lineView = [[UIView alloc] init];
    [ballAndline addSubview:lineView];
    lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    lineView.frame = CGRectMake(xjw*0.5, xjw*qiQiu_hengShubi-xjw*0.08 , 1, xjw*xianBili-9);
    
    UIView* backview = [[UIView alloc] init];
    [self addSubview:backview];
    backview.backgroundColor = [UIColor whiteColor];
    
    backview.frame = CGRectMake(0, ballAndline.cy_bottom-xjw*0.5, xjw, xjw);
    //翻转动画
    backview.layer.anchorPoint = CGPointMake(0.5, 0);

    self.backview=backview;
    //划线
    UIView* redView = [[UIView alloc] init];
    [backview addSubview:redView];
    redView.frame = CGRectMake(backview.width/2 - 10*0.8, -22, 20*0.8, 30*0.8);
    redView.backgroundColor = [UIColor colorWithHexString:XJ_FCOLOR_REDBACK];

    
    self.imageV = [[UIImageView alloc] init];
    //        image.frame = CGRectMake(xjx + 300 * i, xjy, 200, 160);
    self.imageV.frame = CGRectMake(5, 10, xjw-10, xjw-15);
    backview.tag=self.imageV.tag = xj_tag + _num;
    self.imageV.userInteractionEnabled = YES;
    [backview insertSubview:self.imageV atIndex:1];
    
    UITapGestureRecognizer* tapg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjxjtesttagtag:)];
    [self.imageV addGestureRecognizer:tapg];
    
    
    
    
    /**点赞数*/
    CGFloat dianZanViewHeight=xjw*0.1;
    UIView*dianZanView=[[UIView alloc]init];
    dianZanView.backgroundColor=[UIColor blackColor];
    UIColor *color = [UIColor blackColor];
    dianZanView.backgroundColor = [color colorWithAlphaComponent:0.4];
    self.dianZanView=dianZanView;
    //TODO:uiview 单边圆角或者单边框
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 200, dianZanViewHeight) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(dianZanViewHeight*0.5,dianZanViewHeight*0.5)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, dianZanViewHeight*0.5, dianZanViewHeight*0.5);
    maskLayer.path = maskPath.CGPath;
    dianZanView.layer.mask = maskLayer;
    
    
    [self.imageV addSubview:dianZanView];
    [dianZanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(dianZanViewHeight);
        //            make.width.mas_equalTo(dianZanViewHeight);
        
        make.right.equalTo(@0);
        make.bottom.equalTo(self.imageV).offset(-3);
    }];
    
    self.dianzanLabel=[[UILabel alloc]init];
    self.dianzanLabel.font=[UIFont systemFontOfSize:dianZanViewHeight*0.8];
    self.dianzanLabel.textColor=[UIColor redColor];
    [dianZanView addSubview:self.dianzanLabel];
    [self.dianzanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dianZanView).offset(-dianZanViewHeight*0.5);
        make.top.mas_equalTo(dianZanViewHeight*0.1);
    }];
    
    UIImageView*dianZanImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yiDianZanXing"]];
    dianZanImageV.contentMode=UIViewContentModeScaleAspectFit;
    [dianZanView addSubview:dianZanImageV];
    [dianZanImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(dianZanViewHeight*0.8, dianZanViewHeight*0.8));
        make.top.mas_equalTo(dianZanViewHeight*0.1);
        make.right.equalTo(self.dianzanLabel.mas_left).offset(-0.2*dianZanViewHeight);
        make.left.mas_equalTo(dianZanViewHeight*0.5);
        
    }];
    double delay = (arc4random()%100)/100.00; // 延迟多少秒

    [self performSelector:@selector(donghuaZong) withObject:nil afterDelay:delay];
}
- (void)xjxjtesttagtag :(UITapGestureRecognizer*)tapg  {
    NSInteger tag = tapg.view.tag - xj_tag;

    if (self.actionBlock) {
        self.actionBlock(tag);
    }
}
#pragma mark 动画
-(void)donghuaZong{
    // 任务放到哪个队列中执行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    double delay = (arc4random()%100)/100.00; // 延迟多少秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), queue, ^{
    });

    [_ballAndline.layer addAnimation:[self xrotation:0.9 degree:(5 * M_PI/180.0) direction:1 repeatCount:1000] forKey:nil];
    [_backview.layer addAnimation:[self frotation:0.95 degree:(25 * M_PI/180.0) direction:1 repeatCount:1000] forKey:nil];
    [self.layer addAnimation:[self moveY:1 Y:[NSNumber numberWithFloat:_backview.width*0.25] ] forKey:nil];


}
#pragma mark ====旋转动画======
-(CABasicAnimation *)xrotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, 1);
    CATransform3D rotationTransto = CATransform3DMakeRotation(-degree, 0, 0, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue=[NSValue valueWithCATransform3D:rotationTransform];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransto];
    animation.duration  =  dur;
    animation.autoreverses = YES;//是否自动重复
    //指定动画是否为累加效果,默认为NO
    animation.cumulative = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = repeatCount;//动画重复次数
    animation.delegate = self;
    
    //动画的动作规则,包含以下值
    //kCAMediaTimingFunctionLinear 匀速
    //kCAMediaTimingFunctionEaseIn 慢进快出
    //kCAMediaTimingFunctionEaseOut 快进慢出
    //kCAMediaTimingFunctionEaseInEaseOut 慢进慢出 中间加速
    //kCAMediaTimingFunctionDefault 默认
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
    
}
#pragma mark ====翻转动画======
-(CABasicAnimation *)frotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 1, 0, 0);
    CATransform3D rotationTransto = CATransform3DMakeRotation(-degree, 1, 0, 0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue=[NSValue valueWithCATransform3D:rotationTransform];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransto];
    animation.duration  =  dur;
    animation.autoreverses = YES;//是否自动重复
    //指定动画是否为累加效果,默认为NO
    animation.cumulative = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    
    animation.repeatCount = repeatCount;//动画重复次数
    animation.delegate = self;
    
    //动画的动作规则,包含以下值
    //kCAMediaTimingFunctionLinear 匀速
    //kCAMediaTimingFunctionEaseIn 慢进快出
    //kCAMediaTimingFunctionEaseOut 快进慢出
    //kCAMediaTimingFunctionEaseInEaseOut 慢进慢出 中间加速
    //kCAMediaTimingFunctionDefault 默认
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
    
}
#pragma mark =====纵向移动===========
-(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
    animation.toValue = y;
    animation.duration = time;
    animation.autoreverses = YES;//是否自动重复

    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = 1000;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    return animation;
}

@end
