//
//  FLFuckHtmlViewController.h
//  FreeLa
//
//  Created by Leon on 15/12/10.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLHeader.h"
#import "FLNetTool.h"
#import "FLDetailsJSXQModel.h"
#import "FLTool.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "FLSquareAllFreeModel.h"
#import "FLChooseMapViewController.h"
#import "UMSocial.h"
#import "CHTumblrMenuView.h"
#import "FLHTMLModel.h"

#import "XJTicketHTMLViewController.h"
#import "FLBlindWithThirdTableViewController.h"
#import "XJBaseViewController.h"

@interface FLFuckHtmlViewController : XJBaseViewController

/**传进来的数据模型*/
@property (nonatomic , strong) NSDictionary* flsquareAllFreeModel;

/**传进来的详情数组*/
//@property (nonatomic , strong)NSDictionary* fldefatilDic;

/**topicId*/
@property (nonatomic , strong) NSString* flFuckTopicId;

/**标记是否是个人进入*/
@property (nonatomic,  assign) BOOL isPersonalComeIn;

/**需要的模型*/
@property (nonatomic , strong) FLHTMLModel* flhtmlMode;
/**推送*/
@property (nonatomic , strong) NSString* xjGoWhere;

/**推送*/
@property (nonatomic ) BOOL xjIsPushIn;

/**推送进来的
 *用于进入回复评论页
 */
@property (nonatomic , strong) NSArray * xjGoToRejudgeListArr;

/**
 * 插入参与记录
 */
- (void)FLFLHTMLInsertParticipate;
/**
 * 查看领取资格
 */
- (void)checkCanPickTopicInHTNL;





@end
