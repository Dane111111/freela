//
//  FLRefuseViewController.h
//  FreeLa
//
//  Created by Leon on 15/11/19.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLApplyBusinessAccountViewController.h"
#import "FLConst.h"
#import "FLMyBusAccountDetailCheckModel.h"
#import "FLBusinessApplyInfoModel.h"

#import "FLApplyBusRegistModel.h"
#import "FLApplyBusCheckModel.h"


@interface FLRefuseViewController : UIViewController
@property (nonatomic , assign)NSInteger busAccountNumber;

@property (weak, nonatomic) IBOutlet UILabel *refuseReason;

/**用于详细信息的model*/
@property (nonatomic , strong) FLMyBusAccountDetailCheckModel* flDetailModel;
/**用于回填的model*/
@property (nonatomic , strong) FLBusinessApplyInfoModel* flBusAccountInfoModel;


/**用于回填的双model注册信息*/
@property (nonatomic , strong) FLApplyBusRegistModel* flBusRegistModelNew;
/**用于回填的双model审核信息*/
@property (nonatomic , strong) FLApplyBusCheckModel* flBusCheckModelNew;


@end







