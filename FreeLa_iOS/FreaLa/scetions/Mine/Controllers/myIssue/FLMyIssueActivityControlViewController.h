//
//  FLMyIssueActivityControlViewController.h
//  FreeLa
//
//  Created by Leon on 15/12/28.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLTool.h"
#import "FLIssueInfoModel.h"
#import "FLIssueBaseInfoViewController.h"
#import "FLMyIssueInMineModel.h"
#import "MJExtension.h"

//view
#import "FLMyIssueActivityControlView.h"
#import "FLMyIssueActivityPartInView.h"
#import "FLMyIssueReceiveViewController.h"
#import "FLMyIssueJudgePLViewController.h"
#import "FLMyIssueJudgePJViewController.h"

//model
#import "FLMyIssueReceiveModel.h"


@interface FLMyIssueActivityControlViewController : UIViewController<UIScrollViewDelegate>
/**我发布的信息html*/
@property (nonatomic , strong)NSDictionary* flIssueInfoModelDic;

/**我发布的模型*/
@property (nonatomic, strong)FLMyIssueInMineModel* flmyIssueInMineModel;

/**默认第几个*/
@property (nonatomic , assign) NSInteger xjSelectedIndex;
/**通过tiopic id 请求数据*/
@property (nonatomic , strong) NSString* xjTopicId;

/**顶部分栏*/
@property (nonatomic , strong)UIView* topView;


@end
