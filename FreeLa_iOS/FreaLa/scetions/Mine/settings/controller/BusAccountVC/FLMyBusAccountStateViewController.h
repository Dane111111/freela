//
//  FLMyBusAccountStateViewController.h
//  FreeLa
//
//  Created by Leon on 16/1/20.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLMyBusAccountDetailCheckModel.h"  
#import "FLTool.h"
#import "FLApplyBusinessAccountViewController.h"
#import "FLBusinessApplyInfoModel.h"
#import "FLRefuseViewController.h"

#import "FLApplyBusCheckModel.h"
#import "FLApplyBusRegistModel.h"
@interface FLMyBusAccountStateViewController : UIViewController

/**state*/
@property (nonatomic , assign) NSInteger flState;
/**userId,用来请求详细信息*/
@property (nonatomic , strong) NSString* flUserId;

/**商家申请模型*/
@property (nonatomic , strong) FLBusinessApplyInfoModel* flBusApplyInfoModel;

@property (weak, nonatomic) IBOutlet UIImageView *fltopImageView;

@property (weak, nonatomic) IBOutlet UIButton *flBottomBtn;

@property (weak, nonatomic) IBOutlet UILabel *fltopLabel;
@property (weak, nonatomic) IBOutlet UILabel *flbottomLabel;

@end
