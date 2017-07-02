//
//  FLMyReceiveJudgeViewController.h
//  FreeLa
//
//  Created by Leon on 16/1/19.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyIssueJudgePJTableViewCell.h"

@interface FLMyReceiveJudgeViewController : UIViewController



/**推送进来的topicID*/
@property (nonatomic , strong) NSString* xjTioicId;
/**推送进来的DetailsId*/
@property (nonatomic , strong) NSString* xjDetailsId;
@end
