//
//  XJMyCollectionTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/3/16.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJMyCollectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *xjImageView;
@property (weak, nonatomic) IBOutlet UILabel *xjTitle;
@property (weak, nonatomic) IBOutlet UILabel *xjTime;
@property (weak, nonatomic) IBOutlet UIButton *xjBtn;
@property (nonatomic , strong) XJMyCollectionInfoModel* xjModel;

@end
