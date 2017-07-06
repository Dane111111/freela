//
//  CollectStarView.m
//  FreeLa
//
//  Created by MBP on 17/6/30.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "CollectStarView.h"
@interface CollectStarView()
@property(nonatomic,strong)UIImageView*backImageView;
@property(nonatomic,strong)NSString*beginTime;
@property(nonatomic,strong)NSString*endTime;
@end
@implementation CollectStarView

- (instancetype)initWithBeginTime:(NSString*)beginTime endTime:(NSString*)endTime{
    if (self=[super init]) {
        self.beginTime=beginTime;
        self.endTime=endTime;
        [self createView];
        
    }
    return self;

}
-(UIToolbar *)maskView{
    if (!_maskView) {
        _maskView=[[UIToolbar alloc]init];
        _maskView.frame=CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        _maskView.barStyle=UIBarStyleBlackTranslucent;
        //        _maskView.backgroundColor=[UIColor blackColor];
        _maskView.alpha=0.0;
        
    }
    return _maskView;
}
-(void)createView{
    self.frame=[UIScreen mainScreen].bounds;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popDown)];
    tap.numberOfTapsRequired=1;
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tap];
    self.backImageView=({
        UIImageView*imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shoYeJiXingHuoDong"]];
        imageView.frame=CGRectMake(0,0, 310, 360);
        imageView.centerX=self.centerX;
        imageView.cy_y=self.cy_bottom;
        [self addSubview:imageView];
        
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(310, 360));
//            make.centerX.equalTo(self);
//            make.top.equalTo(self.mas_bottom);
//        }];
        imageView.userInteractionEnabled=YES;
        UILabel*label1=[[UILabel alloc] init];
        label1.text=@"集齐满星,立得神秘大礼包";
        label1.font=[UIFont systemFontOfSize:20];
        label1.textColor=[UIColor lightGrayColor];
        label1.textAlignment=NSTextAlignmentCenter;
        [imageView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(180);
            make.centerX.equalTo(imageView);
        }];
        UILabel*label2=[[UILabel alloc] init];
        label2.text=@"这个活动简单的不需要解释";
        label2.font=[UIFont systemFontOfSize:15];
        label2.textColor=[UIColor lightGrayColor];
        label2.textAlignment=NSTextAlignmentCenter;
        [imageView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).offset(15);
            make.centerX.equalTo(imageView);
        }];
        UILabel*label3=[[UILabel alloc] init];
        label3.text=@"马上打开AR寻宝,集星拿大奖吧!";
        label3.font=[UIFont systemFontOfSize:15];
        label3.textColor=[UIColor lightGrayColor];
        label3.textAlignment=NSTextAlignmentCenter;
        [imageView addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label2.mas_bottom).offset(15);
            make.centerX.equalTo(imageView);
        }];
        
        UILabel*label4=[[UILabel alloc] init];
        label4.text=[NSString stringWithFormat:@"活动时间:%@至%@",self.beginTime,self.endTime];
        label4.font=[UIFont systemFontOfSize:15];
        label4.textColor=[UIColor lightGrayColor];
        label4.textAlignment=NSTextAlignmentCenter;
        [imageView addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label3.mas_bottom).offset(3);
            make.centerX.equalTo(imageView);
        }];
        
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitle:@"马上寻宝" forState:UIControlStateNormal];
        button.layer.cornerRadius=20;
        button.layer.masksToBounds=YES;
        button.layer.borderColor=[UIColor lightGrayColor].CGColor;
        button.layer.borderWidth=1;
        
        [imageView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 40));
            make.centerX.equalTo(imageView);
            make.top.equalTo(label4.mas_bottom).offset(5);
        }];
        [button addTarget:self action:@selector(btnkik) forControlEvents:UIControlEventTouchUpInside];


        imageView;
    });
    UIView*line=[[UIView alloc]init];
    line.backgroundColor=[UIColor whiteColor];
    line.alpha=0.8;
    line.frame=CGRectMake(0, 0, 2, 50);
    line.cy_right=self.backImageView.width-30;
    line.cy_bottom=50;
    [self.backImageView addSubview:line];
    UIToolbar*toolbar=[[UIToolbar alloc]init];
    toolbar.frame=CGRectMake(0, 0, 30, 30);
    toolbar.centerX=line.centerX;
    toolbar.cy_bottom=line.cy_y;
    toolbar.alpha=0.5;
    toolbar.barStyle=UIBarStyleDefault;
    toolbar.layer.masksToBounds=YES;
    toolbar.layer.cornerRadius=15;
    [self.backImageView addSubview:toolbar];
    UIImageView*imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chachachachacha"]];
    [toolbar addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.center.equalTo(toolbar);
    }];
    
//    UILabel*label=[[UILabel alloc] init];
//    label.text=@"关闭";
//    label.textColor=[UIColor whiteColor];
//    label.font=[UIFont systemFontOfSize:11];
//    [toolbar addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(toolbar);
//    }];
    
    


}
-(void)btnkik{
    [self popDown];
    if (self.pushBlock) {
        self.pushBlock();
    }
}

-(void)popUp
{
//    [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(310, 360));
//        make.center.equalTo(self);
//    }];
//    // 告诉self.view约束需要更新
//    [self setNeedsUpdateConstraints];
//    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
//    [self updateConstraintsIfNeeded];

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha=1;
        self.backImageView.center=self.center;
//        [self layoutIfNeeded];
    }completion:^(BOOL finished)
     {
         
     }];
}

-(void)popDown{
//    [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(310, 360));
//        make.centerX.equalTo(self);
//        make.top.equalTo(self.mas_bottom);
//    }];
//
//    // 告诉self.view约束需要更新
//    [self setNeedsUpdateConstraints];
//    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
//    [self updateConstraintsIfNeeded];

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha=0.0;
        self.backImageView.cy_y=self.cy_bottom;
//
//        [self layoutIfNeeded];

        
    }completion:^(BOOL finished) {
        [self removeFromSuperview ];
        [self.maskView removeFromSuperview];
    }];
    
}

@end
