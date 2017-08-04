//
//  BGFillInformationTableViewCell.m
//  FreeLa
//
//  Created by MBP on 17/7/10.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "BGFillInformationTableViewCell.h"

@implementation BGFillInformationTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;

}
-(void)createUI{
    self.contentView.backgroundColor=[UIColor clearColor];
    self.backgroundColor=[UIColor clearColor];
    self.keyLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:13];
        label;
    });
    [self.contentView addSubview:self.keyLabel];
    [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(@15);
    }];
    self.valueFiled=({
        UITextField*textFiled=[[UITextField alloc]init];
        textFiled.font=[UIFont systemFontOfSize:13];
        textFiled.textColor=[UIColor whiteColor];
        textFiled;
    });
    [self.contentView addSubview:self.valueFiled];
    [self.valueFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
        make.right.mas_equalTo(-15);
        make.top.equalTo(@0);
        make.left.equalTo(self.keyLabel.mas_right).offset(15);
    }];
    UIView*shuXian=[[UIView alloc]init];
    shuXian.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:shuXian];
    [shuXian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.equalTo(@0);
        make.right.equalTo(self.valueFiled);
        make.left.equalTo(self.valueFiled);
    }];
    
    UIView*hengXian=[[UIView alloc]init];
    hengXian.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:hengXian];
    [hengXian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 25));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.valueFiled.mas_left).offset(-5);
    }];
}

@end
