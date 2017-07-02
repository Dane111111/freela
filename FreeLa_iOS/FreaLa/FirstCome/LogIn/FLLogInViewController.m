
//
//  FLLogInViewController.m
//  FreaLa
//
//  Created by 楚志鹏 on 15/9/16.
//  Copyright (c) 2015年 FreeLa. All rights reserved.
//

#import "FLLogInViewController.h"

@interface FLLogInViewController ()

@end

@implementation FLLogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户注册";
    //  设置导航栏图片
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backImg.jpg"] forBarMetrics:UIBarMetricsDefault];
    //    左返回键
    UIBarButtonItem* returnItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(returnMain)];
    self.navigationItem.leftBarButtonItem = returnItem;
    
}

- (void)returnMain
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
