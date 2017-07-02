//
//  CYContactCell.h
//  FreeLa
//
//  Created by cy on 16/1/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeNumLabel;

@end
