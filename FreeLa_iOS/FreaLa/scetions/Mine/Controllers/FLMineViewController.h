//
//  FLMineViewController.h
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/16.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimateTabbar.h"
#import "FLNetTool.h"
#import <SDWebImage/UIButton+WebCache.h>  //button 图片
#import "FLMineTools.h"


#import "UINavigationBar+Awesome.h"

#import "FLFuckHtmlViewController.h"
#import "FLMyIssueActivityControlViewController.h"
//cell
#import "FLMyIssueTableViewCell.h"
#import "FLMyReceiveControlViewController.h"
#import "FLMineInfoModel.h"
#import "XJMyWeaitPJModel.h"
#import "XJMineCusTomTwoTableViewCell.h"

#define NAVBAR_CHANGE_POINT 50

@interface FLMineViewController : UIViewController//<AnimateTabbarDelegate>

//@property (nonatomic , strong)UITableView* tableView;

/**个人信息模型，仅用作票券页*/
@property (nonatomic , strong) FLMineInfoModel* flmineInfoModel;


@end
