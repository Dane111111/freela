//
//  DECollectStarCtr.m
//  FreeLa
//
//  Created by MBP on 17/6/30.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "DECollectStarCtr.h"

@interface DECollectStarCtr ()
@property(nonatomic,strong)UIImageView*leftIconImageView;
@property(nonatomic,strong)UIImageView*rightIconImageView;
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)UIImageView*detilImageView;
@property(nonatomic,strong)UILabel*personNum;
@property(nonatomic,strong)UILabel*failureLabel;
@property(nonatomic,strong)UIView*collectView;
@end

@implementation DECollectStarCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    UIImageView*backguoundView=({
       UIImageView*imagV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jixinghuodong_beijing"]];
        imagV.frame=self.view.frame;
        [self.view addSubview: imagV];
        imagV;

    });
    self.leftIconImageView=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.layer.masksToBounds=YES;
        imageV.layer.cornerRadius=40;
        imageV.frame=CGRectMake(0, 35, 80, 80);
        imageV.cy_right=DEVICE_WIDTH*0.5-35;
        [backguoundView addSubview:imageV];
        imageV;
    });
    self.rightIconImageView=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.layer.masksToBounds=YES;
        imageV.layer.cornerRadius=40;
        imageV.frame=CGRectMake(0, 35, 80, 80);
        imageV.cy_x=DEVICE_WIDTH*0.5+35;
        [backguoundView addSubview:imageV];

        imageV;
    });
    UIImageView*titleimageV=({
        UIImage*image=[UIImage imageNamed:@"jixingdazuozhan"];
        UIImageView*imageV=[[UIImageView alloc]initWithImage:image];
        imageV.frame=CGRectMake(0, 0, 406/3, 89/3);
        imageV.y=self.rightIconImageView.cy_bottom+23;
        imageV.centerX=backguoundView.centerX;
        [backguoundView addSubview: imageV];
        imageV;
    });
    self.titleLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:20];
        label.textColor=[UIColor whiteColor];
        [backguoundView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleimageV.mas_bottom).offset(10);
            make.centerX.equalTo(backguoundView);
        }];
        label;
    });
    self.detilImageView=({
        UIImageView*imageV=[[UIImageView alloc]init];
        [backguoundView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(180, 180));
            make.centerX.equalTo(backguoundView);
        }];
        imageV;
    });
    self.personNum=({
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:15];
        [backguoundView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detilImageView.mas_bottom).offset(20);
            make.centerX.equalTo(backguoundView);
        }];
        label;
    });
    self.failureLabel=({
        UILabel*label=[[UILabel alloc] init];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:14];
        [backguoundView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.personNum.mas_bottom).offset(3);
            make.centerX.equalTo(backguoundView);
        }];
        label;
    });
    self.collectView=({
        UIView*view=[[UIView alloc] init];
        [backguoundView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 110));
            make.centerX.equalTo(backguoundView);
            make.top.equalTo(self.failureLabel.mas_bottom).offset(0);
        }];
        view;
    });
    UILabel*yaoLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor whiteColor];
        label.text=@"快来邀请你的小伙伴一起来寻宝吧!";
        [backguoundView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectView.mas_bottom);
            make.centerX.equalTo(backguoundView);
        }];
        label;
    });
    UIButton*linQu_button=({
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        []
    })

}
@end
