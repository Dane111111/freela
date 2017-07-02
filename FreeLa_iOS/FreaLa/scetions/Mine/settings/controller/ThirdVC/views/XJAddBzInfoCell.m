//
//  XJAddBzInfoCell.m
//  FreeLa
//
//  Created by Leon on 16/8/31.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJAddBzInfoCell.h"

@implementation XJAddBzInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.xjTopBaseView.layer.borderWidth = 1;
    self.xjBottomBaseView.layer.borderWidth = 1;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, ((float)((0xe3e3e3 & 0xFF0000) >> 16))/255.0, 1 });
    
    self.xjTjdwTextfield.borderStyle = UITextBorderStyleNone;//取消边框
    self.xjTjrTextfield.borderStyle = UITextBorderStyleNone ;
 
    [self.xjTopBaseView.layer setBorderColor:colorref];//边框颜色
    [self.xjBottomBaseView.layer setBorderColor:colorref];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
