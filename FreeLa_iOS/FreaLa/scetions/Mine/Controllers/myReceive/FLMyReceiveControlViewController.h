//
//  FLMyReceiveControlViewController.h
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyReceiveBaseViewController.h"
#import "FLMyReceiveTicketsViewController.h"
#import "FLMyReceiveJudgeViewController.h"
#import "FLMineInfoModel.h"

@interface FLMyReceiveControlViewController : UIViewController<UIScrollViewDelegate>
/**我领取的html*/
//@property (nonatomic , strong)NSDictionary* flReceiveInfoModelDic;

/**我领取的模型*/
@property (nonatomic, strong)FLMyReceiveListModel* flmyReceiveMineModel;
 
/**顶部分栏*/
@property (nonatomic , strong)UIView* topView;
/**通过tiopic id 请求数据*/
@property (nonatomic , strong) NSString* xjTopicId;
/**默认第几个*/
@property (nonatomic , assign) NSInteger xjSelectedIndex;
/**通过tiopic id 请求数据*/
@property (nonatomic , strong) NSString* xjDetailsId;
@end
