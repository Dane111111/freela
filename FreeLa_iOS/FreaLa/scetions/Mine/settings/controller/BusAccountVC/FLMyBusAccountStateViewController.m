//
//  FLMyBusAccountStateViewController.m
//  FreeLa
//
//  Created by Leon on 16/1/20.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "FLMyBusAccountStateViewController.h"
#import "FLBusinessApplyInfoModel.h"

@interface FLMyBusAccountStateViewController ()
{
    NSInteger _xjTotal ;
}
/**本页模型*/
@property (nonatomic , strong) FLMyBusAccountDetailCheckModel* flBusCheckDetailModel;

/**注册信息模型*/
@property (nonatomic , strong) FLApplyBusRegistModel* flRegistBusModel;
/**审核信息模型*/
@property (nonatomic , strong) FLApplyBusCheckModel* flCheckBusModel;
@end

@implementation FLMyBusAccountStateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getInfoFromService];
    [self seeBusAccountInfo];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    
}
#pragma  mark get info
- (void)getInfoFromService
{
    [FLFinalNetTool flNewGetBusAccountDetailsWithBusId:_flUserId success:^(NSDictionary *data) {
        FL_Log(@"this is my bus account detail pass=%@",data);
        if ([data[FL_NET_KEY_NEW] boolValue] && data[FL_NET_DATA_KEY]) {
            _flCheckBusModel = [FLApplyBusCheckModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY]];
            FL_Log(@"tetetetetetetet=%@ ===%@ ===%@", _flCheckBusModel.businessLicenseNum,_flCheckBusModel.userId,_flCheckBusModel.authId);
            _xjTotal = [data[@"total"] integerValue];
            _flBusCheckDetailModel = [FLMyBusAccountDetailCheckModel mj_objectWithKeyValues:data[FL_NET_DATA_KEY]];
 
            [self initUIWithState];
        } else {
            _flBusCheckDetailModel.reason = @"服务器没数据";
            [self initUIWithState];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark get accountInfo
- (void)seeBusAccountInfo
{
    
    NSDictionary* parm = @{@"token":FLFLIsPersonalAccountType? FL_ALL_SESSIONID : FLFLBusSesssionID,
                           @"accountType":FLFLXJUserTypeCompStrKey,
                           @"userid":self.flUserId};
    [FLNetTool seeInfoWithParm:parm success:^(NSDictionary *data) {
        FL_Log(@"this is my bus account info=%@",data);
        if (data) {
            _flRegistBusModel = [FLApplyBusRegistModel mj_objectWithKeyValues:data];
            self.flBusApplyInfoModel = [FLTool returnBusApplyInfoModel:data];
            //此处需要用两个类接
        }
    } failure:^(NSError *error) {
        
    }];
    
}


- (IBAction)flGoBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)flClickBtnActions:(id)sender
{
    // auditStatus  1= 审核中   2=审核通过  3= 审核拒绝
    
    if (_flBusCheckDetailModel.auditStatus)
    {
        switch (_flBusCheckDetailModel.auditStatus)
        {    //1:审批中2：审批通过3：审批拒绝4：认证修改中
            case 1:
            {
                [[FLAppDelegate share] showHUDWithTitile:@"审核中" view:self.navigationController.view delay:1 offsetY:0];
                FLApplyBusinessAccountViewController* aplyVC = [[FLApplyBusinessAccountViewController alloc] init];
                FLFLXJISApplyBusOrRevokeMyAccount = 0;
                //    aplyVC.busApplyInfoModel = self.flBusAccountInfoModel;
                if (_flRegistBusModel) {
                    aplyVC.flBusRegistModelNew = _flRegistBusModel;
                    aplyVC.flBusCheckModelNew = _flCheckBusModel;
                }
//                [self.navigationController pushViewController:aplyVC animated:YES];
            }
                break;
            case 3:
            {
//                [[FLAppDelegate share] showHUDWithTitile:@"测试---拒绝" view:self.navigationController.view delay:1 offsetY:0];
                FLRefuseViewController* refuseVC = [[FLRefuseViewController alloc] initWithNibName:@"FLRefuseViewController" bundle:nil];
                refuseVC.flDetailModel = self.flBusCheckDetailModel;
                refuseVC.flBusAccountInfoModel = self.flBusApplyInfoModel;
                if (_flRegistBusModel && _flCheckBusModel) {
                    refuseVC.flBusCheckModelNew = _flCheckBusModel;
                    refuseVC.flBusRegistModelNew = _flRegistBusModel;
                }
                [self.navigationController pushViewController:refuseVC animated:YES];
            }
                break;
 
            default:
                break;
        }
    } else {
        [[FLAppDelegate share] showHUDWithTitile:@"没有提交审核信息" view:self.navigationController.view delay:1 offsetY:0];
       
        FLApplyBusinessAccountViewController* aplyVC = [[FLApplyBusinessAccountViewController alloc] init];
        FLFLXJISApplyBusOrRevokeMyAccount = 0;
        //    aplyVC.busApplyInfoModel = self.flBusAccountInfoModel;
        if (_flRegistBusModel) {
            aplyVC.flBusRegistModelNew = _flRegistBusModel;
            aplyVC.flBusCheckModelNew = _flCheckBusModel;
        }
        aplyVC.flIsRenZheng = NO;
        [self.navigationController pushViewController:aplyVC animated:YES];
        
    }
    
}
#pragma mark UI
- (void)initUIWithState {
    FL_Log(@"state in my state = %ld",self.flState);
    if (_xjTotal != 0) {
        switch (_flBusCheckDetailModel.auditStatus) {      //  _flBusCheckDetailModel.auditStatus    1= 审核中   2=审核通过  3= 审核拒绝
            case 1:
                self.fltopImageView.image = [UIImage imageNamed:@"bus_apply_state_no"];
                self.fltopLabel.text = [NSString stringWithFormat:@"%@提交审核",[FLTool returnYYDDHHMMWithTime:_flBusCheckDetailModel.createTime]];
                self.flbottomLabel.text = @"正在审核中";
                [self.flBottomBtn setImage:[UIImage imageNamed:@"bus_apply_state_wait"] forState:UIControlStateNormal];
                break;
            case 2:
                self.fltopImageView.image = [UIImage imageNamed:@"bus_apply_state_pass"];
                self.fltopLabel.text = @"恭喜您";
                self.flbottomLabel.text = [NSString stringWithFormat:@"%@审核通过",[FLTool returnYYDDHHMMWithTime:_flBusCheckDetailModel.createTime]];
                [self.flBottomBtn setImage:[UIImage imageNamed:@"bus_apply_state_go"] forState:UIControlStateNormal];
                break;
            case 3:
                self.fltopImageView.image = [UIImage imageNamed:@"bus_apply_state_no"];
                self.fltopLabel.text = [NSString stringWithFormat:@"%@您提交的申请",[FLTool returnYYDDHHMMWithTime:_flBusCheckDetailModel.createTime]];
                self.flbottomLabel.text = [NSString stringWithFormat:@"由于%@已被拒绝",_flBusCheckDetailModel.reason];
                [self.flBottomBtn setImage:[UIImage imageNamed:@"bus_apply_state_back"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    } else {
        self.fltopImageView.image = [UIImage imageNamed:@"bus_apply_state_no"];
        self.fltopLabel.text = @"没有提交审核信息"; //[NSString stringWithFormat:@"由于%@已被拒绝",_flBusCheckDetailModel.reason];
        self.flbottomLabel.text = @"";//[NSString stringWithFormat:@"由于%@已被拒绝",_flBusCheckDetailModel.reason];
        [self.flBottomBtn setImage:[UIImage imageNamed:@"bus_apply_state_wait"] forState:UIControlStateNormal];
     
    }
   
}

@end














