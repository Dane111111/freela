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
@property(nonatomic,assign)NSInteger sumNumber;
@property(nonatomic,strong)NSArray*linqu_arr;
@property(nonatomic,strong)UIButton*linQu_button;

@end

@implementation DECollectStarCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setData];
    [self jiXing_ziHuoDong];
}
-(void)setData{
    NSURL*iconURL=[NSURL URLWithString:self.jinXingZhu_dic[@"avatar"]];
    [self.rightIconImageView sd_setImageWithURL:iconURL];
    self.titleLabel.text=self.jinXingZhu_dic[@"topicTheme"];
    NSURL*detilURL=[NSURL URLWithString:self.jinXingZhu_dic[@"sitethumbnail"]];
    [self.detilImageView sd_setImageWithURL:detilURL];
    self.personNum.text=[NSString stringWithFormat:@"已参与%ld人",[self.jinXingZhu_dic[@"pv"] integerValue]+13];
    self.failureLabel.text=self.jinXingZhu_dic[@"invalidTime"];
}
-(void)jiXing_ziHuoDong{
    [FLNetTool deGetIsChildListWith:nil success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            NSArray * dataArr=data[@"data"];
            if (dataArr&&dataArr.count>0) {
                self.sumNumber=dataArr.count;
                [self jixing_zihuodong_woshoujide];
            }
        }

    } failure:^(NSError *error) {
        
    }];
}
-(void)jixing_zihuodong_woshoujide{
    NSDictionary*parm=@{@"participateDetailes.userId":FLFLIsPersonalAccountType? FL_USERDEFAULTS_USERID_NEW : FLFLXJBusinessUserID,@"participateDetailes.userType":FLFLIsPersonalAccountType ? FLFLXJUserTypePersonStrKey : FLFLXJUserTypeCompStrKey,@"participateDetailes.isChild":@"1",@"participateDetailes.startTime":self.jinXingZhu_dic[@"startTime"],@"participateDetailes.endTime":self.jinXingZhu_dic[@"endTime"]};
    
    [FLNetTool deTopicReceiveListWith:parm success:^(NSDictionary *data) {
        if ([data[FL_NET_KEY_NEW] boolValue]) {
            self.linqu_arr=data[@"data"];
            [self lngqu];
        }

    } failure:^(NSError *error) {
        
    }];

}
-(void)lngqu{
    if (self.linqu_arr.count>=self.sumNumber) {
        self.linQu_button.highlighted=YES;
    }
    int i=0;
    for (NSDictionary *dic in self.linqu_arr) {
        NSURL*url=[NSURL URLWithString:dic[@"thumbnail"]];
        UIImageView*imageV=[self.collectView subviews][i];
        [imageV sd_setImageWithURL:url];
                            i++;
    }
}
-(void)setSumNumber:(NSInteger)sumNumber{
    for (int i=0; i<sumNumber; i++) {
        UIImageView*imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jixing_xingxing"]];
        [self.collectView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.mas_equalTo(300/sumNumber*i);
            make.centerY.equalTo(self.collectView);
        }];
    }
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
        imageV.image=[UIImage imageNamed:@"logo_freela"];
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
    UIButton*wenhao_btn=({
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"jixing_wenhao"] forState:UIControlStateNormal];
        [backguoundView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.equalTo(self.rightIconImageView);
            make.right.mas_equalTo(-25);
        }];
        btn;
    });
    UIImageView*titleimageV=({
        UIImage*image=[UIImage imageNamed:@"jixingdazuozhan"];
        UIImageView*imageV=[[UIImageView alloc]initWithImage:image];
        imageV.frame=CGRectMake(0, 0, 406/2, 89/2);
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
            make.top.equalTo(self.detilImageView.mas_bottom).offset(15);
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
            make.size.mas_equalTo(CGSizeMake(300, 90));
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
    self.linQu_button=({
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"jixing_diangjilingqu_hui"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"jixingdianjilingqu_huang"] forState:UIControlStateHighlighted];
        btn.titleLabel.font=[UIFont systemFontOfSize:13];
        
        [btn setTitle:@"转发" forState:UIControlStateNormal];
        [btn setTitle:@"立即领取" forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backguoundView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo( CGSizeMake(180, 33));
            make.top.equalTo(yaoLabel.mas_bottom).offset(5);
            make.centerX.equalTo(backguoundView);
        }];
        btn;
    });

}
@end
