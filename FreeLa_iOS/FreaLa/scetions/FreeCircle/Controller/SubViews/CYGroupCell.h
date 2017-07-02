//
//  CYGroupCell.h
//  FreeLa
//
//  Created by cy on 16/1/13.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYGroupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *groupPortraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNumLabel;

@end
