//
//  CYContactCell.m
//  FreeLa
//
//  Created by cy on 16/1/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "CYContactCell.h"

@interface CYContactCell()
// 直接拷贝到.h文件就可以了
//@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
//@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *noticeNumLabel;


@end

@implementation CYContactCell

- (void)awakeFromNib {
//    self.noticeNumLabel.layer.cornerRadius = ; ???
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
