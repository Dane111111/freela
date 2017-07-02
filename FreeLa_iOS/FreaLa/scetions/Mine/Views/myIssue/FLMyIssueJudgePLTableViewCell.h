//
//  FLMyIssueJudgePLTableViewCell.h
//  FreeLa
//
//  Created by Leon on 16/1/11.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLMyIssueJudgePLTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *flAvatar;
@property (weak, nonatomic) IBOutlet UILabel *flnickName;

@property (weak, nonatomic) IBOutlet UILabel *fltimeStr;
@property (weak, nonatomic) IBOutlet UILabel *flcontentStr;

@property (weak, nonatomic) IBOutlet UIButton *flJudgeBtn;

/**model*/
@property (nonatomic , strong) FLMyIssueJudgePlModel* flmodel;

@property (weak, nonatomic) IBOutlet UILabel *xjReplaysLabel;

 

 
@end
