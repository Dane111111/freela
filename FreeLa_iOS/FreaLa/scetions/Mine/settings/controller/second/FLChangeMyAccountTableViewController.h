//
//  FLChangeMyAccountTableViewController.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/16.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLUserInfoModel.h"
#import "FLMyCustomTableViewCell.h"
#import "FLApplyBusinessTableViewCell.h"
#import <Masonry/Masonry.h>
#import "FLApplyBusinessAccountViewController.h"

#import "FLTool.h"
#import "FLLogIn_RegisterViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "FLConst.h"
#import "FLMyPersonalDateTableViewController.h"
#import "FLConst.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FLRefuseViewController.h"

#import "FLMineViewController.h"
#import "FLMyPersonalDateTableViewController.h"
#import "FLMyBusAccountListModel.h"
#import "FLMyBusAccountStateViewController.h"
#import "FLChangeAccountPersonalTableViewCell.h"

@interface FLChangeMyAccountTableViewController : UITableViewController
/**用户信息*/
@property (nonatomic , strong)FLUserInfoModel* userInfoModel;//用户的个人信息

@end
