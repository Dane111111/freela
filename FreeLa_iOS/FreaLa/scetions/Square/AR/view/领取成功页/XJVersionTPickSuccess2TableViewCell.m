//
//  XJVersionTPickSuccess2TableViewCell.m
//  FreeLa
//
//  Created by MBP on 17/7/26.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import "XJVersionTPickSuccess2TableViewCell.h"
#import "NSDate+time.h"
@interface XJVersionTPickSuccess2TableViewCell ()
{

}
@end

@implementation XJVersionTPickSuccess2TableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)setFlmodel:(FLMyIssueJudgePlModel *)flmodel
{
    _flmodel = flmodel;
    NSURL* imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[XJFinalTool xjReturnImageURLWithStr:flmodel.avatar isSite:NO]]];
    [self.headerImageV sd_setImageWithURL:imageURL];
    self.nameLabel.text   = flmodel.nickname;
    self.detailLabel.text = flmodel.content;
    NSDate*date=[NSDate dateWithStr:flmodel.createTime];
    self.timeLabel.text    = [date getTime];
    [self.contentView layoutIfNeeded];// 未注释代码

}
- (CGFloat)cellHeight {
    NSLog(@"%s-----%f", __func__, CGRectGetMaxY(_lineView.frame));
    
    return CGRectGetMaxY(_lineView.frame);
}

-(void)createUI{
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
//    UIImageView*backgroundImageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shiYongShuoMing_beiJing-1"]];
//    [self.contentView addSubview:backgroundImageV];
//    [backgroundImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView);
//        make.right.equalTo(self.contentView);
//        make.top.equalTo(self.contentView);
//        make.bottom.equalTo(self.contentView);
//    }];
    self.headerImageV=({
        UIImageView*imageV=[[UIImageView alloc]init];
        imageV.layer.cornerRadius=15;
        imageV.layer.masksToBounds=YES;
        imageV.layer.borderWidth=0.5;
        imageV.layer.borderColor=[UIColor whiteColor].CGColor;
        imageV;
 
    });
    [self.contentView addSubview:self.headerImageV];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(@5);
        make.left.mas_equalTo(7);
    }];
    
    self.nameLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:13];
        label;
    });
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageV);
        make.left.equalTo(self.headerImageV.mas_right).offset(7.5);
    }];
    
    self.detailLabel=({
        UILabel *label=[[UILabel alloc]init];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:13];
        label.numberOfLines=0;
        label;
    });
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5.5);
        make.left.equalTo(self.nameLabel);
        make.width.mas_equalTo(DEF_I6_SIZE(200));
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    self.timeLabel=({
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor whiteColor];
        label.font=[UIFont systemFontOfSize:12];
        label;
    });
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImageV);
        make.right.equalTo(self.contentView).offset(-6);
    }];
    UIView*line=[[UIView alloc]init];
    line.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.height.mas_offset(0.5);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    _lineView=line;
    
    
}
@end
