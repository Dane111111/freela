//
//  XJReJudgePLListViewController.h
//  FreeLa
//
//  Created by Leon on 16/3/10.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyIssueJudgePlModel.h"
@interface XJReJudgePLListViewController : UIViewController

/*评论模型*/
@property (nonatomic , strong) FLMyIssueJudgePlModel* flPLModel;
/**topicId
 */
@property (nonatomic , strong) NSString* xjTopicIdStr;

@end
