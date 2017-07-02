//
//  FLMyIssueTableViewCell.h
//  FreeLa
//
//  Created by Leon on 15/12/14.
//  Copyright © 2015年 FreeLa. All rights reserved.
//  废弃，可以删除

#import <UIKit/UIKit.h>
#import "FLHeader.h"
#import <Masonry/Masonry.h>
#import "FLMyIssueInMineModel.h"
#import "FLTool.h"
#import "FLMyReceiveListModel.h"
#import "XJMyPartInInfoModel.h"

@interface FLMyIssueTableViewCell : UITableViewCell

/**日期-日*/
@property (nonatomic , strong)UILabel* fldateDay;
/**日期-月*/
@property (nonatomic , strong)UILabel* fldateMonth;
/**详情图*/
@property (nonatomic , strong)UIImageView* fldetailImageView;
/**阅读数*/
@property (nonatomic , strong)UILabel* flReadNumberLabel;
/**评论数*/
@property (nonatomic , strong)UILabel* flJudgeNumberLabel;
/**转发数*/
@property (nonatomic , strong)UILabel* flRelayNumberLabel;
/**进度label*/
@property (nonatomic , strong)UILabel* flProgressLabel;
/**进度条*/
@property (nonatomic , strong)UIProgressView* flProgressView;

/**传进来的model*/
@property (nonatomic , strong)FLMyIssueInMineModel* flMyIssueInMineModel;

/**我领取的model*/
@property (nonatomic , strong)FLMyReceiveListModel* flMyReceiveListModel;
/**我参与的model*/
@property (nonatomic , strong)XJMyPartInInfoModel*  xjMyPartInInfoModel;


@end



