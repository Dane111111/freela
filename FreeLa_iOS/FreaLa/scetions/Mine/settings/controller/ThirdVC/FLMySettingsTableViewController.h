//
//  FLMySettingsTableViewController.h
//  FreeLa
//
//  Created by 楚志鹏 on 15/10/20.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UINavigationBar+Awesome.h"
#import "FLLogIn_RegisterViewController.h"
#import "FLConst.h"
#import "FLMessageSettingSViewController.h"
#import "FLUserInfoModel.h"

@interface FLMySettingsTableViewController : UITableViewController

/**model判断有没有phone*/
@property (nonatomic , strong) FLUserInfoModel* flUserInfoModel;
@end
