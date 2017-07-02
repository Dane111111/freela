//
//  FLRefuseViewController.m
//  FreeLa
//
//  Created by Leon on 15/11/19.
//  Copyright © 2015年 FreeLa. All rights reserved.
//

#import "FLRefuseViewController.h"
#import "FLTool.h"
#import "FLAppDelegate.h"
#import "FLNetTool.h"
#import "FLConst.h"
#import "FLHeader.h"


@interface FLRefuseViewController ()


@end

@implementation FLRefuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请被拒";
    self.refuseReason.text = self.flDetailModel.reason;
    NSLog(@"reason = %@",self.flDetailModel.reason);
    self.refuseReason.textAlignment = UIControlContentVerticalAlignmentTop;
    [self.refuseReason setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

    
}
- (IBAction)revokeApply:(id)sender
{
    NSDictionary* parm = @{@"token":FL_ALL_SESSIONID,
                           @"compuserid":[NSNumber numberWithInteger:self.flDetailModel.userId]};
    FL_Log(@"my dic = %@",parm);
    [FLNetTool revokeMyBusApplyWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"revoke is success = %@",data);
        if ([[data objectForKey:FL_NET_KEY]boolValue]){
            [[FLAppDelegate share] showHUDWithTitile:@"撤销成功" view:self.navigationController.view delay:1 offsetY:0];
             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
        }
    } failure:^(NSError *error) {
         NSLog(@"revoke is error = %@",error.description);
        [[FLAppDelegate share] showHUDWithTitile:[NSString stringWithFormat:@"%@",[FLTool returnStrWithErrorCode:error]] view:self.navigationController.view  delay:1 offsetY:0];
    }];
    
}
- (IBAction)editApplyAgain:(id)sender
{
    FLApplyBusinessAccountViewController* aplyVC = [[FLApplyBusinessAccountViewController alloc] init];
    FLFLXJISApplyBusOrRevokeMyAccount = 0;
//    aplyVC.busApplyInfoModel = self.flBusAccountInfoModel;
    if (self.flBusRegistModelNew && self.flBusCheckModelNew) {
        aplyVC.flBusCheckModelNew = self.flBusCheckModelNew;
        aplyVC.flBusRegistModelNew = self.flBusRegistModelNew;
    }
    aplyVC.flIsRenZheng = YES;
    [self.navigationController pushViewController:aplyVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
