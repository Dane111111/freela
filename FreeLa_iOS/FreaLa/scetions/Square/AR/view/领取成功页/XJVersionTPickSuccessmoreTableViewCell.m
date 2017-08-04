//
//  XJVersionTPickSuccessmoreTableViewCell.m
//  FreeLa
//
//  Created by MBP on 17/7/28.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJVersionTPickSuccessmoreTableViewCell.h"

@implementation XJVersionTPickSuccessmoreTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
    UILabel*label=[[UILabel alloc]init];
    label.textColor=[UIColor whiteColor];
    label.text=@"查看更多";
    label.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    UIButton*btn=[UIButton buttonWithType :UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, DEVICE_WIDTH, 44);
    btn.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnAction{
    self.block();
}
@end
