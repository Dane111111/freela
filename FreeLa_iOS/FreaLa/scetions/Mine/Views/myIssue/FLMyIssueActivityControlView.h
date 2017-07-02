//
//  FLMyIssueActivityControlView.h
//  FreeLa
//
//  Created by Leon on 16/1/7.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyIssueInMineModel.h"
#import "SDCycleScrollView.h"
#import "FLHelpDetailImageModels.h"
#import "FLMineInfoModel.h"
 

@interface FLMyIssueActivityControlView : UIView

/**传进来的模型*/
@property (nonatomic , strong)FLMyIssueInMineModel* flMyIssueInMineModel;
/**传进来的字典*/

/**背景图*/
@property (nonatomic , strong)UIImageView* flMyBackGroundImageView;
/**查看活动详情*/
@property (nonatomic , strong)UIButton * flCheckDetailBtn;
/**撤回*/
@property (nonatomic , strong)UIButton * xjOffBtn;
/**轮播数组*/
@property (nonatomic , strong) NSMutableArray* imagesURLStrings;
/**ScrollView*/
@property (nonatomic , strong)UIScrollView* flScrollView;


- (instancetype)initWithModel:(FLMyIssueInMineModel*)flMyIssueInMineModel;

@end
