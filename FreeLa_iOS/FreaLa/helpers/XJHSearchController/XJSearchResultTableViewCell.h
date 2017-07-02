//
//  XJSearchResultTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/5/5.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJSearchResultModel.h"
@interface XJSearchResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *xjThumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *xjTopicThemeLabel;

@property (nonatomic , strong) XJSearchResultModel* xjModel;

@end
