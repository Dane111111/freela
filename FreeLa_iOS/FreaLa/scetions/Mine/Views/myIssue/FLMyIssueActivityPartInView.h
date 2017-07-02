//
//  FLMyIssueActivityPartInView.h
//  FreeLa
//
//  Created by Leon on 16/1/8.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyIssueReceiveModel.h"
//cell
#import "FLMyIssueReceiveTableViewCell.h"
@class FLMyIssueActivityControlViewController;

@interface FLMyIssueActivityPartInView : UIView

/**模型数组*/
@property (nonatomic , strong) NSMutableArray* flMyTopicPartInArray;

/**模型*/
@property (nonatomic , weak) FLMyIssueInMineModel* flmyIssueInMineModel;


/**tableView*/
@property (nonatomic , strong) UITableView* flTableView;
/**控制器指针*/
@property (nonatomic , strong) FLMyIssueActivityControlViewController* flSubVC;
/**导出信息button*/
@property (nonatomic , strong) UIButton* flExcleBtn;
/**一键建群button*/
@property (nonatomic , strong) UIButton* flmakeGroupBtn;
/**全选按钮*/
@property (nonatomic , strong) UIButton* flAllChooseBtn;


- (instancetype)initWithData:(NSMutableArray*)flMyTopicPartInArray;

@end













