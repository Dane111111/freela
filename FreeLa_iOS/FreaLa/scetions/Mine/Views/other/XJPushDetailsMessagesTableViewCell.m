//
//  XJPushDetailsMessagesTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/5/18.
//  Copyright © 2016年 FreeLa. All rights reserved.
// #f5a631

#import "XJPushDetailsMessagesTableViewCell.h"

@interface  XJPushDetailsMessagesTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *xjLabel1;

@property (weak, nonatomic) IBOutlet UILabel *xjLabelFrome;
@property (weak, nonatomic) IBOutlet UILabel *xjLabelMessage;
@property (weak, nonatomic) IBOutlet UIView *xjBottomView;
@end

@implementation XJPushDetailsMessagesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.separatorInset = UIEdgeInsetsMake(0, FLUISCREENBOUNDS.width, 0, 0);
    self.xjBottomView.layer.cornerRadius =  4;
    self.xjBottomView.layer.masksToBounds = YES;
    self.xjLabelFrome.textColor = [UIColor colorWithHexString:@"#f5a631"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setXjModel:(XJPushDetailModel *)xjModel {
    _xjModel = xjModel ;
    [self xjInitPageWithModel];
}

- (void)xjInitPageWithModel{
    self.xjLabel1.text = _xjModel.createTime;
    self.xjLabelFrome.text = _xjModel.msgTypeString;
    self.xjLabelMessage.text = _xjModel.msgContent;
}

@end
