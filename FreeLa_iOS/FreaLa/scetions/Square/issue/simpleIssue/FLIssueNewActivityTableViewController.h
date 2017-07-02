//
//  FLIssueNewActivityTableViewController.h
//  FreeLa
//
//  Created by Leon on 15/11/26.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLHeader.h"
#import "FLTool.h"
#import "FLConst.h"
#import "UIViewController+MJPopupViewController.h"
#import "FLIssueQuickLookViewController.h"
//cell
#import "FLActivityDetailTableViewCell.h"
#import "FLAvtivityCustomTableViewCell.h"
#import "FLActivityHeighterChooseTableViewCell.h"
#import "FLActivityHeighterInfoTableViewCell.h"
#import "FLActivitySignUpLimitTableViewCell.h"
#import "FLTakeRulesTableViewCell.h"
#import "FLTakeConditionTableViewCell.h"
#import "FLActivityImageTableViewCell.h"
#import "FLSquareTools.h"
//view
#import "FLActivitySignUpBaseView.h"
#import "FLTakeRulesView.h"
#import "FLTakeConditionView.h"
#import "FLTakeRulesTableViewCell.h"

//datepicker
#import "KTSelectDatePicker.h"
//imagepicker
#import "LocalPhotoViewController.h"
#import "LocalAlbumTableViewController.h"
//mappicker/
#import "FLChooseMapViewController.h"
//model
#import "FLIssueInfoModel.h"

//popview
#import "FLPopBaseView.h"
//tag
//#import "JFTagListView.h"

//图文
#import "ZSSRichTextEditor.h"
#import "FLRichTextViewController.h"

@interface FLIssueNewActivityTableViewController : UIViewController<ZHPickViewDelegate,FLChooseMapViewControllerDelegate,FLPopBaseViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

/**tableview*/
@property (nonatomic , strong)UITableView* tableView;
/**图片cell*/
@property (nonatomic , strong)FLActivityImageTableViewCell* flactivityImageCell;
/**活动主题的cell*/
@property (nonatomic , strong)FLActivityDetailTableViewCell* flactivityDeatilCell;
/**活动详情的cell*/
@property (nonatomic , strong)FLAvtivityCustomTableViewCell* flactivityDeailInfoCell;
/**高级选项的cell*/
@property (nonatomic , strong)FLActivityHeighterChooseTableViewCell* flactivityDeailHeighterCell;
/**高级选项的子cell*/
@property (nonatomic , strong)FLActivityHeighterInfoTableViewCell* flactivityDeailHeighterInfoCell;
/**用户报名限制输入内容cell*/
@property (nonatomic , strong)FLActivitySignUpLimitTableViewCell* flactivitySignUpLimitCell;



/**用户报名限制的view 的头*/
@property (nonatomic , strong)FLActivitySignUpBaseView* flSignUpBaseView;



//用户输入完毕，提交的信息


/**选择的限制内容*/
@property (nonatomic , strong)NSString* flTakeLimitChoiceStr;

/**用户发布的model*/
@property (nonatomic , strong)FLIssueInfoModel* flissueInfoModel;

/**传递过来的值，用于用户填写领取信息固定标签*/
@property (nonatomic , strong) NSString* flPartInfoDeliverToThirdVCStr;

/**partInfo*/
@property (nonatomic , strong) NSMutableArray* flmuArrForPartInfo;




@end













