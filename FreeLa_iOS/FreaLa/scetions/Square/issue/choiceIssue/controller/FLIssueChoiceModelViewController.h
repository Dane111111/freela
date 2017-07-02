//
//  FLIssueChoiceModelViewController.h
//  FreeLa
//
//  Created by Leon on 15/12/23.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Awesome.h"
#import "FLTool.h"
#import "FLIssueChoiceModelCollectionViewCell.h"
#import "FLIssueChoiceModelSectionOneView.h"
#import "FLSquareTools.h"
#import "FLIssueInfoModel.h"
#import "FLIssueNewActivityTableViewController.h"
@interface FLIssueChoiceModelViewController : UIViewController
/**上级页面传过来的模型*/
@property (nonatomic , weak)FLIssueInfoModel* flissueInfoModel;


/**用于传递填写领取信息的值*/
@property (nonatomic, strong) NSString* flPartInfoDeliverToThirdVCStr;
@end
