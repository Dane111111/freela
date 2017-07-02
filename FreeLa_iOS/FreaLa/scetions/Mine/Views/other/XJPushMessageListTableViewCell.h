//
//  XJPushMessageListTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/5/18.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJPushMessageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *xjBadgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *xjTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *xjHeaderImageView;
 

@property (nonatomic , strong) NSString* xjInfo;

@end
