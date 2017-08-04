//
//  XJVersionTPickSuccess2TableViewCell.h
//  FreeLa
//
//  Created by MBP on 17/7/26.
//  Copyright © 2017年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJVersionTPickSuccess2TableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView*headerImageV;
@property(nonatomic,strong)UILabel*nameLabel;
@property(nonatomic,strong)UILabel*detailLabel;
@property(nonatomic,strong)UILabel*timeLabel;
@property(nonatomic,strong)UIView  *lineView;

/**model*/
@property (nonatomic , strong) FLMyIssueJudgePlModel* flmodel;
- (CGFloat)cellHeight;
@end
