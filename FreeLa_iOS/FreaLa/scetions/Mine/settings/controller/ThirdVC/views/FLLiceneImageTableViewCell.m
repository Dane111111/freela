//
//  FLLiceneImageTableViewCell.m
//  FreeLa
//
//  Created by Leon on 15/11/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLLiceneImageTableViewCell.h"

@implementation FLLiceneImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)flliceneImageBtn:(id)sender
{
    FL_Log(@"拿照片啦");
}

- (IBAction)flchooseHeader:(id)sender {
    FL_Log(@"拿头像照片啦");
}



@end
