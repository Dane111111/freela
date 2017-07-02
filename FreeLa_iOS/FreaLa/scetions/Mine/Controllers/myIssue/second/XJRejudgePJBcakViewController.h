//
//  XJRejudgePJBcakViewController.h
//  FreeLa
//
//  Created by Leon on 16/3/14.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XJRejudgePJBcakViewControllerDelegate;


@interface XJRejudgePJBcakViewController : UIViewController
/*评论模型*/
@property (nonatomic , strong) FLMyIssueJudgePlModel* flPLModel;
/**我发布的模型*/
@property (nonatomic , strong) FLMyIssueInMineModel* flmyIssueInMineModel;
/**我的模型*/
@property (nonatomic , strong) FLMineInfoModel* xjUserModel;


@property (nonatomic , strong) XJMyWeaitPJModel* xjWeaiPJModel;

@property (nonatomic , weak) id<XJRejudgePJBcakViewControllerDelegate>delegate;

@end




@protocol XJRejudgePJBcakViewControllerDelegate <NSObject>
/**刷新待评价的*/

- (void)xjRefreshWeatPJListController;

@end

