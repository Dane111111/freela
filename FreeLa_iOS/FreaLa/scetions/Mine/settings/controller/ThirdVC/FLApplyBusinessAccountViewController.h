//
//  FLApplyBusinessAccountViewController.h
//  FreeLa
//
//  Created by Leon on 15/11/9.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLNetTool.h"
#import "FLHeader.h"
#import "FLAppDelegate.h"
#import "FLTool.h"
#import "UINavigationBar+Awesome.h"
#import "FLBusinessApplyNameTableViewCell.h"
#import "FLBusinessApplyContectTableViewCell.h"
#import "FLBusinessApplyEmailTableViewCell.h"
#import "FLLiceneImageTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FLBusinessApplyInfoModel.h"
#import "FLChangeMyAccountTableViewController.h"
#import "ZHPickView.h"
#import "FLBusIndustryModel.h"
#import <UIButton+WebCache.h>

#import "FLApplyBusCheckModel.h"
#import "FLApplyBusRegistModel.h"
#import "XJAddBzInfoCell.h"


@interface FLApplyBusinessAccountViewController : UITableViewController

@property (nonatomic , strong)NSString* flbusUserID;


@property (nonatomic , strong) FLBusinessApplyContectTableViewCell* cellContect;
@property (nonatomic , strong)FLBusinessApplyEmailTableViewCell* cellemail;
@property (nonatomic , strong)FLLiceneImageTableViewCell* celllicene;
@property (nonatomic , strong)XJAddBzInfoCell* cellAddInfo;
/**pickerView*/
@property (nonatomic , strong)ZHPickView* pickview;


/**回填新 注册信息*/
@property (nonatomic , strong) FLApplyBusRegistModel* flBusRegistModelNew;

/**回填新 审核信息*/
@property (nonatomic , strong) FLApplyBusCheckModel* flBusCheckModelNew;

/**没有认证信息*/
@property (nonatomic , assign) BOOL flIsRenZheng;
@end











