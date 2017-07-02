//
//  FLMyIssueReceiveTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/1/9.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLMyIssueReceiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *flAvatar;
@property (weak, nonatomic) IBOutlet UILabel *flnickName;

@property (weak, nonatomic) IBOutlet UILabel *fltimeStr;
@property (weak, nonatomic) IBOutlet UILabel *flStateStr;

@property (weak, nonatomic) IBOutlet UIButton *flStateBtn;

@property (nonatomic , assign) BOOL flchecked;
- (void) setChecked:(BOOL)checked;

@end
