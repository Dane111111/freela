//
//  XJGGViewController.m
//  FreeLa
//
//  Created by Leon on 16/7/12.
//  Copyright © 2016年 FreeLa. All rights reserved.
//

#import "XJGGViewController.h"

@interface XJGGViewController ()

@end

@implementation XJGGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self performSelector:@selector(xjChooseTabBar) withObject:nil afterDelay:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)xjChooseTabBar {
    [UIApplication sharedApplication].keyWindow.rootViewController = [FLAppDelegate share].xjTabBar ;
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
