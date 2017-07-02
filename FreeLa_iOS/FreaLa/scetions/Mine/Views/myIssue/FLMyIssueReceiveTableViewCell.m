//
//  FLMyIssueReceiveTableViewCell.m
//  FreeLa
//
//  Created by Leon on 16/1/9.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyIssueReceiveTableViewCell.h"

@implementation FLMyIssueReceiveTableViewCell

- (void)awakeFromNib
{
    self.flAvatar.layer.cornerRadius =  self.flAvatar.frame.size.width / 2;
    self.flAvatar.layer.masksToBounds = YES;
    self.flStateBtn.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

- (void) setChecked:(BOOL)checked
{
    if (!checked)
    {
        [self.flStateBtn setImage:[UIImage imageNamed:@"button_issue_takecondition_selected"] forState:UIControlStateNormal];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        [self.flStateBtn setImage:[UIImage imageNamed:@"button_issue_takecondition_gray"] forState:UIControlStateNormal];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    self.flchecked = checked;
}

@end
