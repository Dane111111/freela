//
//  XJPushMessageListTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/5/18.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJPushMessageListTableViewCell.h"

@implementation XJPushMessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.xjBadgeLabel.layer.cornerRadius = 10;
    self.xjBadgeLabel.layer.masksToBounds = YES;
    self.xjBadgeLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setXjInfo:(NSString *)xjInfo {
    _xjInfo = xjInfo;
    if(!xjInfo)return;
    [self xjInitPageWithBadge:xjInfo];
}

- (void)xjInitPageWithBadge:(NSString*)xjInfo {
    if ([xjInfo isEqualToString:@"0"]) {
        self.xjBadgeLabel.hidden = YES;
    } else {
        self.xjBadgeLabel.hidden = NO;
        self.xjBadgeLabel.text = xjInfo;
    }
}

@end
