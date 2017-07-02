//
//  FLIssueBaseInfoViewController.h
//  FreeLa
//
//  Created by Leon on 15/12/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLSquareTools.h"
//#import "FLBaseInfoCategoryCell.h"
#import "FLAvtivityCustomTableViewCell.h"
#import "FLIssueInfoModel.h"
#import "FLActivityHeighterInfoTableViewCell.h"
#import "FLPopBaseView.h"
#import "FLTakeConditionView.h"
#import "FLTakeRulesView.h"


//#import "FLIssueChoiceModelViewController.h"

//#import "FLIssueQuickLookViewController.h"

@class FLIssueQuickLookViewController;
@class FLIssueChoiceModelViewController;
@class FLBaseInfoCategoryCell;
@class FLTakeConditionTableViewCell;
@class FLTakeRulesTableViewCell;

@interface FLIssueBaseInfoViewController : UIViewController
/**tableView*/
@property (nonatomic , strong)UITableView* flBaseInfoTableView;
//cell
/**分类的cell*/
@property (nonatomic , strong)FLBaseInfoCategoryCell* flbaseInfoCategoryCell;
/**活动详情的cell*/
@property (nonatomic , strong)FLAvtivityCustomTableViewCell* flactivityDeailInfoCell;
/**数量上限cell*/
@property (nonatomic , strong)FLActivityHeighterInfoTableViewCell* flactivityDeailHeighterInfoCell;
/**领取条件cell*/
@property (nonatomic  ,strong)FLTakeConditionTableViewCell* fltakeConditionCell;
/**领取桂策*/
@property (nonatomic , strong)FLTakeRulesTableViewCell* fltakeRulesCell;
/**用户领取条件限制的view 的头*/
@property (nonatomic , strong)FLTakeConditionView* flTakeConditionView;
/**用户领取规则限制的view 的头*/
@property (nonatomic , strong)FLTakeRulesView* flTakeRulesView;
/**是否选择了助力抢*/
@property (nonatomic , assign)BOOL isHelpTypeSelected;

/**用户发布的model*/
@property (nonatomic , strong)FLIssueInfoModel* flissueInfoModel;


//用户输入完毕，提交的信息
/**选择的领取条件*/
@property (nonatomic , strong)NSString* flTakeConditionsChoiceStr;
/**选择的领取规则*/
@property (nonatomic , strong)NSString* flTakeRulesChoiceStr;




@end
