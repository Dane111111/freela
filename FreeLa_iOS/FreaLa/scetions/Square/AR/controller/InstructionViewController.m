//
//  InstructionViewController.m
//  FreeLa
//
//  Created by MBP on 17/7/3.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "InstructionViewController.h"

@interface InstructionViewController ()

@end

@implementation InstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI{
    self.view.backgroundColor=[UIColor whiteColor];
    self.NavView.backgroundColor=[UIColor redColor];
    [self setNavTitle:@"活动说明" withColor:[UIColor whiteColor]];
    UIImageView*imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xunbao_shuoming"]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(111*1.5, 22*1.5));
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(80);
    }];
    UILabel *keyLabel=[[UILabel alloc]init];
    keyLabel.text=@"集星活动";
    keyLabel.textColor=[UIColor lightGrayColor];
    keyLabel.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:keyLabel];
    [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(15);
        make.left.equalTo(@15);
    }];
    UIView*line=[[UIView alloc]init];
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(keyLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH-30, 1));
        make.left.mas_equalTo(@15);
    }];
    UILabel*detilLabel=[[UILabel alloc]init];
    detilLabel.text=self.detilStr;
    detilLabel.font=[UIFont systemFontOfSize:13];
    detilLabel.textColor=[UIColor lightGrayColor];
    detilLabel.textAlignment=NSTextAlignmentLeft;
    detilLabel.numberOfLines=0;
    [self.view addSubview:detilLabel];
    [detilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.width.mas_equalTo(DEVICE_WIDTH-40);
    }];
}
@end
