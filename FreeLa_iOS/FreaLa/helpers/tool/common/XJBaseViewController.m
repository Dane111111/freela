//
//  XJBaseViewController.m
//  FreeLa
//
//  Created by Leon on 2016/10/17.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJBaseViewController.h"

@interface XJBaseViewController ()

@end

@implementation XJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)xj_alertNumberBind {
    UIAlertController* flAlertViewController = [UIAlertController alertControllerWithTitle:@"操作失败" message:@"您还没有绑定手机号，不能进行此操作" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction* flCancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        FL_Log(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    UIAlertAction *flSureAction = [UIAlertAction actionWithTitle:@"马上去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        FL_Log(@"go to blind phone number now.");
        FLBlindWithThirdTableViewController * blindVC = [[FLBlindWithThirdTableViewController alloc] init];
        [weakSelf.navigationController pushViewController:blindVC animated:YES];
    }];
    [flAlertViewController addAction:flCancleAction];
    [flAlertViewController addAction:flSureAction];
    [self presentViewController:flAlertViewController animated:YES completion:nil];
}
- (void)xj_presentNumberBind {
    FLBlindWithThirdTableViewController * blindVC = [[FLBlindWithThirdTableViewController alloc] init];
//    [self presentViewController:blindVC animated:YES completion:nil];
    [self.navigationController pushViewController:blindVC animated:YES];

}
- (void)xj_uploadVersionNumber {
    //获取版本号
    NSString* versionLocal = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* nimade =  [NSString stringWithFormat:@"iOS_%@",versionLocal];
    //用户id
    [FLNetTool xj_uploadVersionNumber:nimade success:^(NSDictionary *data) {
        FL_Log(@"sllllllllllllllad=%@",data);
    } failure:^(NSError *error) {
        
    }];
    
}

@end













