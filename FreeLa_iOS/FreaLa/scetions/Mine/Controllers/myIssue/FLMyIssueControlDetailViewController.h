//
//  FLMyIssueControlDetailViewController.h
//  FreeLa
//
//  Created by Leon on 16/1/10.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "FLGrayBaseView.h"

@interface FLMyIssueControlDetailViewController : UIViewController

/**我发布的模型*/
@property (nonatomic, strong)FLMyIssueInMineModel* flmyIssueInMineModel;

/**我发布的信息html*/
@property (nonatomic , strong)NSDictionary* flIssueInfoModelDic;

/**用于数据回填的模型*/
@property (nonatomic , strong) FLIssueInfoModel* flissueInfoModel;

/**推送进来的topicID*/
@property (nonatomic , strong) NSString* xjTioicId;

/**tempId*/
@property (nonatomic , strong) NSString* xj_tempId;

@end
