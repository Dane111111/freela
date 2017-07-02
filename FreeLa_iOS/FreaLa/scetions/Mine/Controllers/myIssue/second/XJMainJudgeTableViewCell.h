//
//  XJMainJudgeTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/3/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyIssueJudgePlModel.h"
@interface XJMainJudgeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *xjHeaderIage;
@property (weak, nonatomic) IBOutlet UILabel *xjname;
@property (weak, nonatomic) IBOutlet UILabel *xjcontent;
@property (weak, nonatomic) IBOutlet UIButton *xjReJudgeBtn;
@property (weak, nonatomic) IBOutlet UILabel *xjCreatTimeLabel;

@property (nonatomic , strong) FLMyIssueJudgePlModel* xjPLModel;


@end
